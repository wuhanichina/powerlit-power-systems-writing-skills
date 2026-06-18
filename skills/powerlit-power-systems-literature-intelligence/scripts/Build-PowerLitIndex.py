#!/usr/bin/env python3
"""Build a portable, field-aware PowerLit SQLite FTS index."""

from __future__ import annotations

import argparse
import json
import sqlite3
import sys
import time
from datetime import datetime, timezone
from pathlib import Path

from powerlit_index_common import (
    DEFAULT_CONTENT_CHARS,
    canonicalize_venue,
    iter_json_files,
    make_index_record,
    resolve_index_dir,
    resolve_json_root,
    safe_name,
)

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")

FTS_COLUMNS = (
    "title",
    "source_title",
    "abstract",
    "keywords",
    "introduction",
    "method",
    "results",
    "conclusion",
    "content",
)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Build a portable PowerLit SQLite FTS index.")
    parser.add_argument("--root", help="Raw PowerLit JSON corpus root.")
    parser.add_argument("--index-dir", dest="index_dir", help="Output index directory.")
    parser.add_argument(
        "--venue-folder",
        dest="venue_folders",
        action="append",
        default=[],
        help="Venue folder or registered alias. Repeat for multiple venues.",
    )
    parser.add_argument("--content-chars", type=int, default=DEFAULT_CONTENT_CHARS)
    parser.add_argument("--content-head-chars", type=int, dest="legacy_content_chars")
    parser.add_argument("--include-analysis", action="store_true")
    parser.add_argument("--write-jsonl", action="store_true")
    parser.add_argument("--limit-per-venue", type=int, default=0)
    return parser.parse_args()


def discover_venues(root: Path, requested: list[str]) -> tuple[list[tuple[str, Path]], list[str]]:
    if not requested:
        venues = [(child.name, child) for child in sorted(root.iterdir()) if child.is_dir()]
        return (venues or [("_root", root)]), []

    venues: list[tuple[str, Path]] = []
    missing: list[str] = []
    for supplied in requested:
        canonical = canonicalize_venue(supplied) or supplied
        path = root / canonical
        if path.is_dir():
            venues.append((canonical, path))
        else:
            missing.append(supplied)
    return venues, missing


def initialize_sqlite(path: Path, venue_name: str) -> tuple[sqlite3.Connection, bool]:
    if path.exists():
        path.unlink()
    conn = sqlite3.connect(str(path))
    conn.execute("PRAGMA journal_mode=OFF")
    conn.execute("PRAGMA synchronous=OFF")
    conn.execute("PRAGMA temp_store=MEMORY")
    conn.executescript(
        """
        CREATE TABLE metadata (
            key TEXT PRIMARY KEY,
            value TEXT NOT NULL
        );
        CREATE TABLE records (
            id INTEGER PRIMARY KEY,
            record_key TEXT NOT NULL UNIQUE,
            venue_folder TEXT NOT NULL,
            relative_path TEXT NOT NULL,
            title TEXT,
            normalized_title TEXT,
            title_source TEXT,
            source_title TEXT,
            authors TEXT,
            doi TEXT,
            year INTEGER,
            document_type TEXT,
            abstract TEXT,
            keywords TEXT,
            introduction TEXT,
            method TEXT,
            results TEXT,
            conclusion TEXT,
            content TEXT,
            size_bytes INTEGER,
            mtime INTEGER
        );
        CREATE INDEX idx_records_doi ON records(doi);
        CREATE INDEX idx_records_title ON records(normalized_title);
        CREATE INDEX idx_records_year ON records(year);
        CREATE VIRTUAL TABLE records_fts USING fts5(
            title,
            source_title,
            abstract,
            keywords,
            introduction,
            method,
            results,
            conclusion,
            content,
            content='records',
            content_rowid='id',
            tokenize='unicode61 remove_diacritics 2'
        );
        """
    )
    conn.execute("INSERT INTO metadata(key, value) VALUES('schema_version', '2')")
    conn.execute("INSERT INTO metadata(key, value) VALUES('venue_folder', ?)", (venue_name,))

    trigram_available = True
    try:
        conn.execute(
            """
            CREATE VIRTUAL TABLE records_trigram USING fts5(
                title,
                abstract,
                keywords,
                method,
                results,
                content,
                content='records',
                content_rowid='id',
                tokenize='trigram case_sensitive 0'
            )
            """
        )
    except sqlite3.OperationalError:
        trigram_available = False
    conn.execute(
        "INSERT INTO metadata(key, value) VALUES('trigram_available', ?)",
        ("true" if trigram_available else "false",),
    )
    return conn, trigram_available


def insert_record(conn: sqlite3.Connection, item: dict, trigram_available: bool) -> bool:
    cursor = conn.execute(
        """
        INSERT OR IGNORE INTO records (
            record_key, venue_folder, relative_path, title, normalized_title,
            title_source, source_title, authors, doi, year, document_type,
            abstract, keywords, introduction, method, results, conclusion,
            content, size_bytes, mtime
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        (
            item.get("record_key"),
            item.get("venue_folder"),
            item.get("relative_path"),
            item.get("title"),
            item.get("normalized_title"),
            item.get("title_source"),
            item.get("source_title"),
            item.get("authors"),
            item.get("doi"),
            item.get("year"),
            item.get("document_type"),
            item.get("abstract"),
            item.get("keywords"),
            item.get("introduction"),
            item.get("method"),
            item.get("results"),
            item.get("conclusion"),
            item.get("content"),
            item.get("size_bytes"),
            item.get("mtime"),
        ),
    )
    if cursor.rowcount == 0:
        return False
    rowid = int(cursor.lastrowid)
    values = tuple(item.get(column) or "" for column in FTS_COLUMNS)
    conn.execute(
        f"INSERT INTO records_fts(rowid, {', '.join(FTS_COLUMNS)}) "
        f"VALUES (?, {', '.join('?' for _ in FTS_COLUMNS)})",
        (rowid, *values),
    )
    if trigram_available:
        trigram_columns = ("title", "abstract", "keywords", "method", "results", "content")
        trigram_values = tuple(item.get(column) or "" for column in trigram_columns)
        conn.execute(
            f"INSERT INTO records_trigram(rowid, {', '.join(trigram_columns)}) "
            f"VALUES (?, {', '.join('?' for _ in trigram_columns)})",
            (rowid, *trigram_values),
        )
    return True


def count_records(path: Path) -> int:
    with sqlite3.connect(str(path)) as conn:
        return int(conn.execute("SELECT COUNT(*) FROM records").fetchone()[0])


def main() -> int:
    args = parse_args()
    started = time.perf_counter()
    root = resolve_json_root(args.root)
    if not root:
        print(
            json.dumps(
                {
                    "ok": False,
                    "message": "PowerLit JSON root is unavailable; provide --root or POWERLIT_JSON_ROOT",
                    "elapsed_ms": int((time.perf_counter() - started) * 1000),
                },
                ensure_ascii=False,
                indent=2,
            )
        )
        return 2

    index_dir = resolve_index_dir(args.index_dir, create=True)
    assert index_dir is not None
    venues, missing = discover_venues(root, args.venue_folders)
    if missing:
        print(
            json.dumps(
                {
                    "ok": False,
                    "message": "One or more requested venue folders do not exist",
                    "missing_venues": missing,
                },
                ensure_ascii=False,
                indent=2,
            )
        )
        return 2

    content_chars = max(args.legacy_content_chars or args.content_chars, 2_000)
    manifest = {
        "schema_version": 2,
        "cache_layout": "portable_powerlit_index",
        "built_at": datetime.now(timezone.utc).isoformat().replace("+00:00", "Z"),
        "content_chars": content_chars,
        "include_analysis": bool(args.include_analysis),
        "venues": {},
        "total_records": 0,
        "failed_records": 0,
        "duplicate_records": 0,
    }

    for venue_name, venue_root in venues:
        sqlite_name = f"{safe_name(venue_name)}.sqlite"
        sqlite_path = index_dir / sqlite_name
        sqlite_tmp = sqlite_path.with_suffix(".sqlite.tmp")
        conn, trigram_available = initialize_sqlite(sqlite_tmp, venue_name)
        jsonl_path = index_dir / f"{safe_name(venue_name)}.jsonl"
        jsonl_tmp = jsonl_path.with_suffix(".jsonl.tmp")
        jsonl_handle = jsonl_tmp.open("w", encoding="utf-8", newline="\n") if args.write_jsonl else None
        records = 0
        failed = 0
        duplicates = 0
        try:
            for path in iter_json_files(venue_root, include_analysis=args.include_analysis):
                if args.limit_per_venue and records >= args.limit_per_venue:
                    break
                item = make_index_record(path, root, venue_name, content_chars=content_chars)
                if not item:
                    failed += 1
                    continue
                if not insert_record(conn, item, trigram_available):
                    duplicates += 1
                    continue
                if jsonl_handle:
                    jsonl_handle.write(json.dumps(item, ensure_ascii=False, separators=(",", ":")) + "\n")
                records += 1
                if records % 250 == 0:
                    conn.commit()
            conn.commit()
            conn.execute("INSERT INTO records_fts(records_fts) VALUES('optimize')")
            if trigram_available:
                conn.execute("INSERT INTO records_trigram(records_trigram) VALUES('optimize')")
            conn.commit()
        finally:
            if jsonl_handle:
                jsonl_handle.close()
            conn.close()

        sqlite_tmp.replace(sqlite_path)
        if args.write_jsonl:
            jsonl_tmp.replace(jsonl_path)
        manifest["venues"][venue_name] = {
            "sqlite_file": sqlite_name,
            "jsonl_file": jsonl_path.name if args.write_jsonl else None,
            "records": count_records(sqlite_path),
            "failed_records": failed,
            "duplicate_records": duplicates,
            "trigram_available": trigram_available,
        }
        manifest["total_records"] += records
        manifest["failed_records"] += failed
        manifest["duplicate_records"] += duplicates

    manifest["elapsed_ms"] = int((time.perf_counter() - started) * 1000)
    (index_dir / "manifest.json").write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    print(json.dumps({"ok": True, **manifest}, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
