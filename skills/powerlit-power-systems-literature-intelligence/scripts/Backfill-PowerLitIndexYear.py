#!/usr/bin/env python3
"""Backfill empty year fields in existing PowerLit SQLite index shards.

Derives the year from the stored DOI and content head via
``powerlit_index_common.derive_year``, so it does not need the raw corpus.
After a successful backfill, refresh the manifest with:

    python Build-PowerLitIndex.py --refresh-manifest-only
"""

from __future__ import annotations

import argparse
import json
import sqlite3
import sys
import time
from pathlib import Path

from powerlit_index_common import derive_year, resolve_index_dir

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Backfill year fields in PowerLit index shards.")
    parser.add_argument("--index-dir", dest="index_dir", help="Index directory. Defaults to the bundled cache.")
    parser.add_argument("--dry-run", action="store_true", help="Report what would change without writing.")
    return parser.parse_args()


def backfill_shard(path: Path, dry_run: bool) -> dict:
    conn = sqlite3.connect(str(path))
    try:
        total = conn.execute("SELECT COUNT(*) FROM records").fetchone()[0]
        rows = conn.execute(
            "SELECT id, year, doi, content_head FROM records WHERE year IS NULL OR year = ''"
        ).fetchall()
        updates: list[tuple[str, int]] = []
        for row_id, year, doi, content_head in rows:
            derived = derive_year(year, doi or "", content_head or "")
            if derived:
                updates.append((derived, row_id))
        if updates and not dry_run:
            conn.executemany("UPDATE records SET year = ? WHERE id = ?", updates)
            conn.commit()
        remaining = len(rows) - len(updates)
        return {
            "sqlite_file": path.name,
            "records": int(total),
            "empty_year_before": len(rows),
            "backfilled": len(updates),
            "still_empty": remaining,
        }
    finally:
        conn.close()


def main() -> int:
    args = parse_args()
    started = time.perf_counter()
    index_dir = resolve_index_dir(args.index_dir)
    if not index_dir:
        print(json.dumps({"ok": False, "message": "PowerLit index unavailable"}, ensure_ascii=False, indent=2))
        return 2

    shards = sorted(index_dir.glob("*.sqlite"))
    if not shards:
        print(json.dumps({"ok": False, "message": "No SQLite shards found", "index_dir": str(index_dir)}, ensure_ascii=False, indent=2))
        return 2

    report = [backfill_shard(path, args.dry_run) for path in shards]
    summary = {
        "ok": True,
        "dry_run": bool(args.dry_run),
        "index_dir": str(index_dir),
        "elapsed_ms": int((time.perf_counter() - started) * 1000),
        "total_backfilled": sum(item["backfilled"] for item in report),
        "total_still_empty": sum(item["still_empty"] for item in report),
        "shards": report,
    }
    print(json.dumps(summary, ensure_ascii=False, indent=2))
    if not args.dry_run and summary["total_backfilled"]:
        print("Reminder: refresh the manifest with `python Build-PowerLitIndex.py --refresh-manifest-only`.", file=sys.stderr)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
