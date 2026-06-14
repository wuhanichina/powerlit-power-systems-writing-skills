#!/usr/bin/env python3
"""Build a local SQLite FTS search index for the PowerLit corpus."""

from __future__ import annotations

import argparse
import json
import sqlite3
import sys
import time
from datetime import datetime, timezone
from pathlib import Path

from powerlit_index_common import (
    DEFAULT_HEAD_CHARS,
    iter_json_files,
    make_index_record,
    resolve_index_dir,
    resolve_json_root,
    safe_name,
)

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Build a local PowerLit SQLite FTS index.")
    parser.add_argument("--root", dest="root", help="PowerLit JSON corpus root.")
    parser.add_argument("--index-dir", dest="index_dir", help="Output index directory.")
    parser.add_argument(
        "--venue-folder",
        dest="venue_folders",
        action="append",
        default=[],
        help="Venue folder to index. Repeat for multiple venues. Defaults to all venue folders.",
    )
    parser.add_argument("--content-head-chars", type=int, default=DEFAULT_HEAD_CHARS)
    parser.add_argument("--include-analysis", action="store_true")
    parser.add_argument(
        "--write-jsonl",
        action="store_true",
        help="Also write per-venue JSONL files for inspection. SQLite is always written.",
    )
    parser.add_argument(
        "--limit-per-venue",
        type=int,
        default=0,
        help="Optional smoke-test limit per venue. Zero means no limit.",
    )
    parser.add_argument(
        "--refresh-manifest-only",
        action="store_true",
        help="Rebuild manifest entries from existing per-venue SQLite files without scanning the corpus.",
    )
    return parser.parse_args()


def discover_venues(root: Path, requested: list[str]) -> list[tuple[str, Path]]:
    if requested:
        venues: list[tuple[str, Path]] = []
        for venue in requested:
            path = root / venue
            if path.is_dir():
                venues.append((venue, path))
        return venues

    venues = [(child.name, child) for child in sorted(root.iterdir()) if child.is_dir()]
    if venues:
        return venues
    return [("_root", root)]


def load_existing_manifest(index_dir: Path) -> dict:
    manifest_path = index_dir / "manifest.json"
    if not manifest_path.is_file():
        return {}
    try:
        return json.loads(manifest_path.read_text(encoding="utf-8"))
    except Exception:
        return {}


def initialize_sqlite(path: Path) -> sqlite3.Connection:
    if path.exists():
        path.unlink()
    conn = sqlite3.connect(str(path))
    conn.execute("PRAGMA journal_mode=OFF")
    conn.execute("PRAGMA synchronous=OFF")
    conn.execute("PRAGMA temp_store=MEMORY")
    conn.execute(
        """
        CREATE TABLE records (
            id INTEGER PRIMARY KEY,
            venue_folder TEXT NOT NULL,
            relative_path TEXT NOT NULL,
            path TEXT NOT NULL,
            title TEXT,
            title_source TEXT,
            source_title TEXT,
            doi TEXT,
            year TEXT,
            content_head TEXT,
            size_bytes INTEGER,
            mtime INTEGER
        )
        """
    )
    conn.execute(
        """
        CREATE VIRTUAL TABLE records_fts USING fts5(
            title,
            source_title,
            content_head,
            content='records',
            content_rowid='id'
        )
        """
    )
    return conn


def insert_record(conn: sqlite3.Connection, item: dict) -> None:
    cursor = conn.execute(
        """
        INSERT INTO records (
            venue_folder,
            relative_path,
            path,
            title,
            title_source,
            source_title,
            doi,
            year,
            content_head,
            size_bytes,
            mtime
        )
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        (
            item.get("venue_folder"),
            item.get("relative_path"),
            item.get("path"),
            item.get("title"),
            item.get("title_source"),
            item.get("source_title"),
            item.get("doi"),
            item.get("year"),
            item.get("content_head"),
            item.get("size_bytes"),
            item.get("mtime"),
        ),
    )
    rowid = cursor.lastrowid
    conn.execute(
        "INSERT INTO records_fts(rowid, title, source_title, content_head) VALUES (?, ?, ?, ?)",
        (rowid, item.get("title"), item.get("source_title"), item.get("content_head")),
    )


def count_sqlite_records(path: Path) -> int:
    conn = sqlite3.connect(str(path))
    try:
        row = conn.execute("SELECT COUNT(*) FROM records").fetchone()
        return int(row[0]) if row else 0
    finally:
        conn.close()


def write_manifest(path: Path, manifest: dict, started: float) -> None:
    manifest["total_records"] = sum(int(item.get("records") or 0) for item in manifest["venues"].values())
    manifest["failed_records"] = sum(int(item.get("failed_records") or 0) for item in manifest["venues"].values())
    manifest["elapsed_ms"] = int((time.perf_counter() - started) * 1000)
    manifest_path = path / "manifest.json"
    manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def main() -> int:
    args = parse_args()
    started = time.perf_counter()
    root = resolve_json_root(args.root)
    if not root and not args.refresh_manifest_only:
        print(
            json.dumps(
                {
                    "ok": False,
                    "message": "PowerLit JSON root is unavailable",
                    "elapsed_ms": int((time.perf_counter() - started) * 1000),
                },
                ensure_ascii=False,
                indent=2,
            )
        )
        return 2

    index_dir = resolve_index_dir(args.index_dir, create=True)
    assert index_dir is not None

    existing_manifest = load_existing_manifest(index_dir)
    if args.refresh_manifest_only:
        root = root or Path(existing_manifest.get("corpus_root") or "")
        manifest = {
            "schema_version": 1,
            "built_at": datetime.now(timezone.utc).isoformat().replace("+00:00", "Z"),
            "corpus_root": str(root) if root else existing_manifest.get("corpus_root"),
            "index_dir": str(index_dir),
            "content_head_chars": existing_manifest.get("content_head_chars") or args.content_head_chars,
            "include_analysis": bool(existing_manifest.get("include_analysis", args.include_analysis)),
            "venues": existing_manifest.get("venues") or {},
            "total_records": 0,
            "failed_records": 0,
        }
        for sqlite_path in sorted(index_dir.glob("*.sqlite")):
            venue_name = sqlite_path.stem
            existing = manifest["venues"].get(venue_name) or {}
            manifest["venues"][venue_name] = {
                "sqlite_file": sqlite_path.name,
                "jsonl_file": existing.get("jsonl_file"),
                "records": count_sqlite_records(sqlite_path),
                "failed_records": int(existing.get("failed_records") or 0),
                "source_root": existing.get("source_root") or (str(root / venue_name) if root else None),
            }
        write_manifest(index_dir, manifest, started)
        print(json.dumps({"ok": True, **manifest}, ensure_ascii=False, indent=2))
        return 0

    venues = discover_venues(root, args.venue_folders)
    manifest = {
        "schema_version": 1,
        "built_at": datetime.now(timezone.utc).isoformat().replace("+00:00", "Z"),
        "corpus_root": str(root),
        "index_dir": str(index_dir),
        "content_head_chars": args.content_head_chars,
        "include_analysis": bool(args.include_analysis),
        "venues": existing_manifest.get("venues") or {},
        "total_records": 0,
        "failed_records": 0,
    }

    for venue_name, venue_root in venues:
        safe_venue = safe_name(venue_name)
        sqlite_name = f"{safe_venue}.sqlite"
        sqlite_path = index_dir / sqlite_name
        sqlite_tmp_path = sqlite_path.with_suffix(".sqlite.tmp")
        conn = initialize_sqlite(sqlite_tmp_path)
        jsonl_name = f"{safe_venue}.jsonl"
        jsonl_path = index_dir / jsonl_name
        jsonl_tmp_path = jsonl_path.with_suffix(".jsonl.tmp")
        jsonl_handle = jsonl_tmp_path.open("w", encoding="utf-8", newline="\n") if args.write_jsonl else None
        records = 0
        failed = 0

        try:
            for path in iter_json_files(venue_root, include_analysis=args.include_analysis):
                if args.limit_per_venue and records >= args.limit_per_venue:
                    break
                item = make_index_record(
                    path=path,
                    root=root,
                    venue_folder=venue_name,
                    head_chars=max(args.content_head_chars, 1000),
                )
                if not item:
                    failed += 1
                    continue
                insert_record(conn, item)
                if jsonl_handle:
                    jsonl_handle.write(json.dumps(item, ensure_ascii=False, separators=(",", ":")) + "\n")
                records += 1
                if records % 500 == 0:
                    conn.commit()
            conn.commit()
            conn.execute("INSERT INTO records_fts(records_fts) VALUES('optimize')")
            conn.commit()
        finally:
            if jsonl_handle:
                jsonl_handle.close()
            conn.close()

        sqlite_tmp_path.replace(sqlite_path)
        if args.write_jsonl:
            jsonl_tmp_path.replace(jsonl_path)
        manifest["venues"][venue_name] = {
            "sqlite_file": sqlite_name,
            "jsonl_file": jsonl_name if args.write_jsonl else None,
            "records": records,
            "failed_records": failed,
            "source_root": str(venue_root),
        }
    write_manifest(index_dir, manifest, started)

    print(json.dumps({"ok": True, **manifest}, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
