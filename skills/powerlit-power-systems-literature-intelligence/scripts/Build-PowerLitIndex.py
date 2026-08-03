#!/usr/bin/env python3
"""Build a local SQLite FTS search index for the PowerLit corpus."""

from __future__ import annotations

import argparse
import copy
import json
import os
import sqlite3
import sys
import time
import hashlib
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
if hasattr(sys.stderr, "reconfigure"):
    sys.stderr.reconfigure(encoding="utf-8")

DEFAULT_MAX_SHARD_SIZE_MIB = 48.0
# FTS5 optimize can temporarily add roughly 10-15% to a populated database
# before the connection is closed. Rotate earlier so the finalized shard stays
# below the configured hard limit rather than only the pre-optimize allocation.
SHARD_ROTATE_FRACTION = 0.80
SHARD_SIZE_CHECK_INTERVAL = 50


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
    parser.add_argument(
        "--max-shard-size-mib",
        type=float,
        default=DEFAULT_MAX_SHARD_SIZE_MIB,
        help="Maximum SQLite/JSONL shard size. Defaults to 48 MiB, below GitHub's 50 MiB warning threshold.",
    )
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
            record_id TEXT NOT NULL UNIQUE,
            venue_folder TEXT NOT NULL,
            relative_path TEXT NOT NULL,
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
            record_id,
            venue_folder,
            relative_path,
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
            item.get("record_id"),
            item.get("venue_folder"),
            item.get("relative_path"),
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


def sqlite_venue_folder(path: Path) -> str:
    conn = sqlite3.connect(str(path))
    try:
        row = conn.execute("SELECT venue_folder FROM records LIMIT 1").fetchone()
        return str(row[0]) if row and row[0] else path.stem
    finally:
        conn.close()


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def entry_files(entry: dict, plural_key: str, singular_key: str) -> list[str]:
    values = entry.get(plural_key) or []
    if isinstance(values, str):
        values = [values]
    result = [str(value) for value in values if value]
    singular = entry.get(singular_key)
    if singular and str(singular) not in result:
        result.insert(0, str(singular))
    return result


def sqlite_allocated_bytes(conn: sqlite3.Connection) -> int:
    page_count = int(conn.execute("PRAGMA page_count").fetchone()[0])
    page_size = int(conn.execute("PRAGMA page_size").fetchone()[0])
    return page_count * page_size


def finalize_sqlite(conn: sqlite3.Connection, tmp_path: Path, final_path: Path, max_bytes: int) -> None:
    try:
        conn.commit()
        conn.execute("INSERT INTO records_fts(records_fts) VALUES('optimize')")
        conn.commit()
        conn.execute("VACUUM")
    finally:
        conn.close()
    final_size = tmp_path.stat().st_size
    if final_size >= max_bytes:
        raise RuntimeError(
            f"PowerLit shard {final_path.name} would be {final_size} bytes; "
            f"limit is {max_bytes} bytes"
        )
    tmp_path.replace(final_path)


def validate_cache_filename(filename: str) -> str:
    name = str(filename or "")
    if not name or Path(name).name != name or name in {".", ".."}:
        raise ValueError(f"Unsafe PowerLit cache filename: {filename!r}")
    return name


def referenced_cache_files(manifest: dict) -> set[str]:
    result: set[str] = set()
    for entry in (manifest.get("venues") or {}).values():
        result.update(validate_cache_filename(name) for name in entry_files(entry, "sqlite_files", "sqlite_file"))
        result.update(validate_cache_filename(name) for name in entry_files(entry, "jsonl_files", "jsonl_file"))
    return result


def write_manifest(path: Path, manifest: dict, started: float) -> None:
    manifest["total_records"] = sum(int(item.get("records") or 0) for item in manifest["venues"].values())
    manifest["failed_records"] = sum(int(item.get("failed_records") or 0) for item in manifest["venues"].values())
    manifest["elapsed_ms"] = int((time.perf_counter() - started) * 1000)
    max_bytes = int(manifest.get("max_shard_size_bytes") or 0)
    shards: dict[str, dict] = {}
    for venue_name, entry in manifest["venues"].items():
        venue_records = 0
        for filename in entry_files(entry, "sqlite_files", "sqlite_file"):
            filename = validate_cache_filename(filename)
            shard_path = path / filename
            if not shard_path.is_file():
                raise FileNotFoundError(f"PowerLit manifest references missing shard: {filename}")
            size_bytes = shard_path.stat().st_size
            if max_bytes and size_bytes >= max_bytes:
                raise RuntimeError(
                    f"PowerLit shard {filename} is {size_bytes} bytes; limit is {max_bytes} bytes"
                )
            record_count = count_sqlite_records(shard_path)
            venue_records += record_count
            shards[filename] = {
                "sha256": sha256_file(shard_path),
                "records": record_count,
                "size_bytes": size_bytes,
            }
        if venue_records != int(entry.get("records") or 0):
            raise RuntimeError(
                f"PowerLit venue {venue_name!r} declares {entry.get('records') or 0} records; "
                f"shards contain {venue_records}"
            )
        for filename in entry_files(entry, "jsonl_files", "jsonl_file"):
            filename = validate_cache_filename(filename)
            jsonl_path = path / filename
            if not jsonl_path.is_file():
                raise FileNotFoundError(f"PowerLit manifest references missing JSONL shard: {filename}")
            if max_bytes and jsonl_path.stat().st_size >= max_bytes:
                raise RuntimeError(
                    f"PowerLit JSONL shard {filename} is {jsonl_path.stat().st_size} bytes; "
                    f"limit is {max_bytes} bytes"
                )
    manifest["shards"] = shards
    manifest_path = path / "manifest.json"
    manifest_tmp_path = path / "manifest.json.tmp"
    manifest_tmp_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    manifest_tmp_path.replace(manifest_path)


def cleanup_unreferenced_cache_files(path: Path, manifest: dict) -> list[str]:
    referenced = referenced_cache_files(manifest)
    failures: list[str] = []
    for pattern in ("*.sqlite", "*.jsonl"):
        for candidate in path.glob(pattern):
            if candidate.name in referenced:
                continue
            try:
                candidate.unlink()
            except OSError as exc:
                failures.append(f"{candidate.name}: {exc}")
    return failures


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
    max_shard_size_bytes = int(args.max_shard_size_mib * 1024 * 1024)
    if max_shard_size_bytes < 1024 * 1024:
        raise ValueError("--max-shard-size-mib must be at least 1")

    if args.refresh_manifest_only:
        existing_venues = existing_manifest.get("venues") or {}
        if not existing_venues:
            print(
                json.dumps(
                    {
                        "ok": False,
                        "message": "Cannot refresh manifest without an existing valid manifest",
                        "elapsed_ms": int((time.perf_counter() - started) * 1000),
                    },
                    ensure_ascii=False,
                    indent=2,
                )
            )
            return 2
        manifest = {
            "schema_version": 3,
            "cache_version": existing_manifest.get("cache_version") or "2026.06",
            "generated_at": datetime.now(timezone.utc).isoformat().replace("+00:00", "Z"),
            "corpus_snapshot_date": existing_manifest.get("corpus_snapshot_date"),
            "analyzer_version": "powerlit-index-portable-v1",
            "include_analysis": bool(existing_manifest.get("include_analysis", args.include_analysis)),
            "content_head_chars": int(existing_manifest.get("content_head_chars") or max(args.content_head_chars, 1000)),
            "max_shard_size_bytes": max_shard_size_bytes,
            "venues": {},
            "total_records": 0,
            "failed_records": 0,
        }
        for venue_name, existing_entry in existing_venues.items():
            sqlite_names = entry_files(existing_entry, "sqlite_files", "sqlite_file")
            if not sqlite_names:
                raise RuntimeError(f"PowerLit venue {venue_name!r} has no manifest-listed SQLite shards")
            entry = copy.deepcopy(existing_entry)
            entry["sqlite_files"] = [validate_cache_filename(name) for name in sqlite_names]
            entry["sqlite_file"] = None
            entry["jsonl_files"] = [
                validate_cache_filename(name)
                for name in entry_files(existing_entry, "jsonl_files", "jsonl_file")
            ]
            entry["jsonl_file"] = None
            for name in entry["sqlite_files"]:
                if not (index_dir / name).is_file():
                    raise FileNotFoundError(f"PowerLit manifest references missing shard: {name}")
            entry["records"] = sum(count_sqlite_records(index_dir / name) for name in entry["sqlite_files"])
            if len(entry["sqlite_files"]) == 1:
                entry["sqlite_file"] = entry["sqlite_files"][0]
            if len(entry["jsonl_files"]) == 1:
                entry["jsonl_file"] = entry["jsonl_files"][0]
            manifest["venues"][venue_name] = entry
        write_manifest(index_dir, manifest, started)
        cleanup_warnings = cleanup_unreferenced_cache_files(index_dir, manifest)
        print(json.dumps({"ok": True, **manifest, "cleanup_warnings": cleanup_warnings}, ensure_ascii=False, indent=2))
        return 0

    venues = discover_venues(root, args.venue_folders)
    rotate_at_bytes = int(max_shard_size_bytes * SHARD_ROTATE_FRACTION)
    now = datetime.now(timezone.utc)
    generated_at = now.isoformat().replace("+00:00", "Z")
    snapshot_date = now.date().isoformat()
    existing_venues = existing_manifest.get("venues") or {}
    is_full_snapshot = not existing_venues or not args.venue_folders
    generation_suffix = ""
    if existing_venues:
        generation_suffix = f".g{now.strftime('%Y%m%dT%H%M%SZ')}-{os.getpid()}-{time.time_ns() % 1_000_000_000:09d}"
    manifest = {
        "schema_version": 3,
        "cache_version": existing_manifest.get("cache_version") or "2026.06",
        "generated_at": generated_at,
        "corpus_snapshot_date": snapshot_date if is_full_snapshot else existing_manifest.get("corpus_snapshot_date"),
        "analyzer_version": "powerlit-index-portable-v1",
        "include_analysis": (
            bool(args.include_analysis)
            if is_full_snapshot
            else bool(existing_manifest.get("include_analysis", args.include_analysis))
        ),
        "content_head_chars": (
            max(args.content_head_chars, 1000)
            if is_full_snapshot
            else int(existing_manifest.get("content_head_chars") or max(args.content_head_chars, 1000))
        ),
        "max_shard_size_bytes": max_shard_size_bytes,
        "venues": copy.deepcopy(existing_venues),
        "total_records": 0,
        "failed_records": 0,
    }

    for venue_name, venue_root in venues:
        safe_venue = safe_name(venue_name)
        records = 0
        failed = 0
        shard_number = 0
        shard_records = 0
        sqlite_files: list[str] = []
        jsonl_files: list[str] = []
        conn: sqlite3.Connection | None = None
        sqlite_tmp_path: Path | None = None
        sqlite_path: Path | None = None
        jsonl_handle = None
        jsonl_tmp_path: Path | None = None
        jsonl_path: Path | None = None

        def open_shard() -> None:
            nonlocal shard_number, shard_records, conn, sqlite_tmp_path, sqlite_path
            nonlocal jsonl_handle, jsonl_tmp_path, jsonl_path
            shard_number += 1
            shard_records = 0
            stem = f"{safe_venue}{generation_suffix}.part{shard_number:03d}"
            sqlite_path = index_dir / f"{stem}.sqlite"
            sqlite_tmp_path = index_dir / f"{stem}.sqlite.tmp"
            conn = initialize_sqlite(sqlite_tmp_path)
            if args.write_jsonl:
                jsonl_path = index_dir / f"{stem}.jsonl"
                jsonl_tmp_path = index_dir / f"{stem}.jsonl.tmp"
                jsonl_handle = jsonl_tmp_path.open("w", encoding="utf-8", newline="\n")

        def close_shard() -> None:
            nonlocal conn, jsonl_handle
            assert conn is not None and sqlite_tmp_path is not None and sqlite_path is not None
            if jsonl_handle:
                jsonl_handle.close()
                jsonl_handle = None
            finalize_sqlite(conn, sqlite_tmp_path, sqlite_path, max_shard_size_bytes)
            conn = None
            sqlite_files.append(sqlite_path.name)
            if args.write_jsonl and jsonl_tmp_path is not None and jsonl_path is not None:
                jsonl_size = jsonl_tmp_path.stat().st_size
                if jsonl_size >= max_shard_size_bytes:
                    raise RuntimeError(
                        f"PowerLit shard {jsonl_path.name} would be {jsonl_size} bytes; "
                        f"limit is {max_shard_size_bytes} bytes"
                    )
                jsonl_tmp_path.replace(jsonl_path)
                jsonl_files.append(jsonl_path.name)

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
            if conn is None:
                open_shard()
            assert conn is not None
            insert_record(conn, item)
            if jsonl_handle:
                jsonl_handle.write(json.dumps(item, ensure_ascii=False, separators=(",", ":")) + "\n")
            records += 1
            shard_records += 1
            if shard_records % SHARD_SIZE_CHECK_INTERVAL == 0:
                conn.commit()
                jsonl_size = jsonl_handle.tell() if jsonl_handle else 0
                if sqlite_allocated_bytes(conn) >= rotate_at_bytes or jsonl_size >= rotate_at_bytes:
                    close_shard()

        if conn is None and not sqlite_files:
            open_shard()
        if conn is not None:
            close_shard()

        if len(sqlite_files) == 1:
            old_name = sqlite_files[0]
            new_name = f"{safe_venue}{generation_suffix}.sqlite"
            (index_dir / old_name).replace(index_dir / new_name)
            sqlite_files = [new_name]
        if len(jsonl_files) == 1:
            old_name = jsonl_files[0]
            new_name = f"{safe_venue}{generation_suffix}.jsonl"
            (index_dir / old_name).replace(index_dir / new_name)
            jsonl_files = [new_name]

        manifest["venues"][venue_name] = {
            "sqlite_file": sqlite_files[0] if len(sqlite_files) == 1 else None,
            "sqlite_files": sqlite_files,
            "jsonl_file": jsonl_files[0] if len(jsonl_files) == 1 else None,
            "jsonl_files": jsonl_files,
            "records": records,
            "failed_records": failed,
            "generated_at": generated_at,
            "corpus_snapshot_date": snapshot_date,
            "include_analysis": bool(args.include_analysis),
            "content_head_chars": max(args.content_head_chars, 1000),
        }
    write_manifest(index_dir, manifest, started)
    cleanup_warnings = cleanup_unreferenced_cache_files(index_dir, manifest)

    print(json.dumps({"ok": True, **manifest, "cleanup_warnings": cleanup_warnings}, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
