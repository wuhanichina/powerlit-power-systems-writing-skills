#!/usr/bin/env python3
"""Migrate a PowerLit SQLite cache into a portable skill asset directory.

The migration removes machine-specific path fields from SQLite records and the
manifest, verifies record counts, and computes per-shard checksums.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import shutil
import sqlite3
import sys
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

MACHINE_PATH_PATTERNS = (
    re.compile(r"^[A-Za-z]:[\\/]"),
    re.compile(r"^\\\\"),
    re.compile(r"^/(?:home|Users|mnt|Volumes)/"),
)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Migrate a PowerLit cache to a portable, installable layout."
    )
    parser.add_argument("--source", required=True, help="Legacy cache directory.")
    parser.add_argument("--destination", required=True, help="Portable cache directory.")
    parser.add_argument(
        "--check-only",
        action="store_true",
        help="Validate an already migrated destination without changing files.",
    )
    return parser.parse_args()


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def looks_machine_specific(value: str) -> bool:
    value = value.strip()
    return bool(value and any(pattern.search(value) for pattern in MACHINE_PATH_PATTERNS))


def table_columns(conn: sqlite3.Connection, table: str) -> set[str]:
    return {str(row[1]) for row in conn.execute(f"PRAGMA table_info({table})")}


def inspect_sqlite(path: Path, *, mutate: bool) -> dict[str, Any]:
    conn = sqlite3.connect(str(path))
    try:
        tables = {
            str(row[0])
            for row in conn.execute("SELECT name FROM sqlite_master WHERE type='table'")
        }
        if "records" not in tables:
            raise RuntimeError(f"{path}: missing records table")

        columns = table_columns(conn, "records")
        record_count = int(conn.execute("SELECT COUNT(*) FROM records").fetchone()[0])

        # Preserve the legacy column for schema compatibility, but make it portable.
        if mutate and "path" in columns:
            if "relative_path" in columns:
                conn.execute(
                    "UPDATE records SET path = REPLACE(relative_path, '\\\\', '/')"
                )
            else:
                conn.execute("UPDATE records SET path = ''")

        # Source mtimes are not semantically useful in a distributed cache.
        if mutate and "mtime" in columns:
            conn.execute("UPDATE records SET mtime = NULL")

        if mutate:
            conn.commit()
            conn.execute("VACUUM")
            conn.commit()

        offending: list[dict[str, Any]] = []
        for column in ("path", "relative_path"):
            if column not in columns:
                continue
            for row_id, value in conn.execute(
                f"SELECT id, {column} FROM records WHERE {column} IS NOT NULL"
            ):
                text = str(value)
                if looks_machine_specific(text):
                    offending.append({"id": row_id, "column": column, "value": text})
                    if len(offending) >= 20:
                        break
        if offending:
            raise RuntimeError(
                f"{path}: machine-specific paths remain: "
                f"{json.dumps(offending, ensure_ascii=False)}"
            )

        return {
            "records": record_count,
            "sha256": sha256_file(path),
            "size_bytes": path.stat().st_size,
        }
    finally:
        conn.close()


def load_manifest(source: Path) -> dict[str, Any]:
    manifest_path = source / "manifest.json"
    if not manifest_path.is_file():
        return {}
    try:
        return json.loads(manifest_path.read_text(encoding="utf-8"))
    except Exception as exc:
        raise RuntimeError(f"Cannot parse {manifest_path}: {exc}") from exc


def migrate(source: Path, destination: Path) -> dict[str, Any]:
    if not source.is_dir():
        raise RuntimeError(f"Cache source does not exist: {source}")

    destination.mkdir(parents=True, exist_ok=True)
    source_manifest = load_manifest(source)
    old_venues = source_manifest.get("venues") or {}

    # Remove stale destination shards before copying to avoid phantom venue coverage.
    for old_file in destination.glob("*.sqlite"):
        old_file.unlink()

    sqlite_sources = sorted(source.glob("*.sqlite"))
    if not sqlite_sources:
        raise RuntimeError(f"No SQLite shards found under {source}")

    shards: dict[str, dict[str, Any]] = {}
    for source_file in sqlite_sources:
        destination_file = destination / source_file.name
        shutil.copy2(source_file, destination_file)
        shards[source_file.name] = inspect_sqlite(destination_file, mutate=True)

    venues: dict[str, dict[str, Any]] = {}
    for venue, entry in old_venues.items():
        sqlite_file = str(entry.get("sqlite_file") or "")
        if sqlite_file not in shards:
            continue
        venues[str(venue)] = {
            "sqlite_file": sqlite_file,
            "records": int(shards[sqlite_file]["records"]),
            "failed_records": int(entry.get("failed_records") or 0),
        }

    known_files = {entry["sqlite_file"] for entry in venues.values()}
    for sqlite_file, info in shards.items():
        if sqlite_file not in known_files:
            venues[Path(sqlite_file).stem] = {
                "sqlite_file": sqlite_file,
                "records": int(info["records"]),
                "failed_records": 0,
            }

    manifest = {
        "schema_version": 2,
        "cache_layout": "portable_skill_asset",
        "generated_at": datetime.now(timezone.utc).isoformat().replace("+00:00", "Z"),
        "source_snapshot_built_at": source_manifest.get("built_at"),
        "content_head_chars": source_manifest.get("content_head_chars"),
        "include_analysis": bool(source_manifest.get("include_analysis", False)),
        "venues": venues,
        "shards": shards,
        "total_records": sum(int(item["records"]) for item in venues.values()),
        "failed_records": sum(
            int(item.get("failed_records") or 0) for item in venues.values()
        ),
    }
    (destination / "manifest.json").write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    return manifest


def validate(destination: Path) -> dict[str, Any]:
    manifest = load_manifest(destination)
    if int(manifest.get("schema_version") or 0) < 2:
        raise RuntimeError("Portable cache manifest must use schema_version >= 2")
    if manifest.get("cache_layout") != "portable_skill_asset":
        raise RuntimeError("Portable cache manifest has an invalid cache_layout")

    for forbidden_key in ("corpus_root", "index_dir", "source_root"):
        if forbidden_key in manifest:
            raise RuntimeError(f"Portable manifest must not contain {forbidden_key}")

    shards = manifest.get("shards") or {}
    for filename, expected in shards.items():
        path = destination / filename
        if not path.is_file():
            raise RuntimeError(f"Missing cache shard: {path}")
        actual = inspect_sqlite(path, mutate=False)
        if int(actual["records"]) != int(expected.get("records") or -1):
            raise RuntimeError(f"Record count mismatch for {filename}")
        if actual["sha256"] != expected.get("sha256"):
            raise RuntimeError(f"Checksum mismatch for {filename}")
    return manifest


def main() -> int:
    args = parse_args()
    source = Path(args.source).expanduser().resolve()
    destination = Path(args.destination).expanduser().resolve()

    try:
        if args.check_only:
            manifest = validate(destination)
        else:
            migrate(source, destination)
            manifest = validate(destination)
        print(json.dumps({"ok": True, **manifest}, ensure_ascii=False, indent=2))
        return 0
    except Exception as exc:
        print(
            json.dumps({"ok": False, "error": str(exc)}, ensure_ascii=False, indent=2),
            file=sys.stderr,
        )
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
