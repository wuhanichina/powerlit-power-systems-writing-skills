#!/usr/bin/env python3
"""Search the local PowerLit SQLite/JSONL index."""

from __future__ import annotations

import argparse
import heapq
import json
import sqlite3
import sys
import time
from pathlib import Path

from powerlit_index_common import count_contains, get_snippet, normalize_terms, resolve_index_dir, safe_name

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Search a local PowerLit SQLite/JSONL index.")
    parser.add_argument("--query", required=True)
    parser.add_argument("--terms", nargs="*", default=[])
    parser.add_argument("--index-dir", dest="index_dir")
    parser.add_argument("--venue-folder", dest="venue_folders", action="append", default=[])
    parser.add_argument("--top", type=int, default=20)
    return parser.parse_args()


def load_manifest(index_dir: Path) -> dict:
    manifest_path = index_dir / "manifest.json"
    if not manifest_path.is_file():
        return {"venues": {}, "generated_at": None}
    return json.loads(manifest_path.read_text(encoding="utf-8"))


def sqlite_files(index_dir: Path, manifest: dict, venues: list[str]) -> list[Path]:
    manifest_venues = manifest.get("venues") or {}
    if venues:
        files: list[Path] = []
        for venue in venues:
            entry = manifest_venues.get(venue)
            if entry and entry.get("sqlite_file"):
                candidate = index_dir / entry["sqlite_file"]
            else:
                candidate = index_dir / f"{safe_name(venue)}.sqlite"
            if candidate.is_file():
                files.append(candidate)
        return files

    if manifest_venues:
        files = [
            (index_dir / entry["sqlite_file"]).resolve()
            for entry in manifest_venues.values()
            if entry.get("sqlite_file") and (index_dir / entry["sqlite_file"]).is_file()
        ]
        known = {path.name for path in files}
        files.extend(path.resolve() for path in sorted(index_dir.glob("*.sqlite")) if path.name not in known)
        return files
    return sorted(path.resolve() for path in index_dir.glob("*.sqlite"))


def jsonl_files(index_dir: Path, manifest: dict, venues: list[str]) -> list[Path]:
    manifest_venues = manifest.get("venues") or {}
    if venues:
        files: list[Path] = []
        for venue in venues:
            entry = manifest_venues.get(venue)
            if entry and entry.get("jsonl_file"):
                candidate = index_dir / entry["jsonl_file"]
            else:
                candidate = index_dir / f"{safe_name(venue)}.jsonl"
            if candidate.is_file():
                files.append(candidate)
        return files

    if manifest_venues:
        return [
            index_dir / entry["jsonl_file"]
            for entry in manifest_venues.values()
            if entry.get("jsonl_file") and (index_dir / entry["jsonl_file"]).is_file()
        ]
    return sorted(index_dir.glob("*.jsonl"))


def score_record(record: dict, terms: list[str]) -> tuple[int, list[str]]:
    title = str(record.get("title") or "")
    source = str(record.get("source_title") or "")
    content_head = str(record.get("content_head") or "")

    score = 0
    matched: list[str] = []
    for term in terms:
        title_hits = count_contains(title, term)
        source_hits = count_contains(source, term)
        body_hits = count_contains(content_head, term)
        if title_hits + source_hits + body_hits > 0:
            matched.append(term)
        score += 10 * title_hits + 3 * source_hits + body_hits
    return score, matched


def fts_query(terms: list[str]) -> str:
    quoted = []
    for term in terms:
        cleaned = term.replace('"', '""').strip()
        if cleaned:
            quoted.append(f'"{cleaned}"')
    return " OR ".join(quoted) if quoted else '""'


def push_result(heap: list[tuple[int, int, dict]], keep: int, sequence: int, record: dict, terms: list[str]) -> bool:
    score, matched = score_record(record, terms)
    if score <= 0:
        return False
    result = {
        "score": score,
        "record_id": record.get("record_id") or "",
        "title": record.get("title") or "",
        "title_source": record.get("title_source") or "record",
        "source_title": record.get("source_title") or "",
        "doi": record.get("doi") or "",
        "year": record.get("year") or "",
        "relative_path": record.get("relative_path") or "",
        "venue_folder": record.get("venue_folder") or "",
        "matched_terms": sorted(set(matched), key=matched.index),
        "snippet": get_snippet(str(record.get("content_head") or ""), terms),
    }
    item = (score, sequence, result)
    if len(heap) < keep:
        heapq.heappush(heap, item)
    elif score > heap[0][0]:
        heapq.heapreplace(heap, item)
    return True


def search_sqlite(files: list[Path], terms: list[str], keep: int) -> tuple[int, int, list[dict]]:
    candidate_count = 0
    parsed_count = 0
    heap: list[tuple[int, int, dict]] = []
    sequence = 0
    query = fts_query(terms)
    sql_limit = max(keep * 200, 1000)
    for sqlite_file in files:
        conn = sqlite3.connect(str(sqlite_file))
        conn.row_factory = sqlite3.Row
        try:
            rows = conn.execute(
                """
                SELECT
                    r.record_id,
                    r.venue_folder,
                    r.relative_path,
                    r.title,
                    r.title_source,
                    r.source_title,
                    r.doi,
                    r.year,
                    r.content_head
                FROM records_fts
                JOIN records r ON r.id = records_fts.rowid
                WHERE records_fts MATCH ?
                ORDER BY bm25(records_fts)
                LIMIT ?
                """,
                (query, sql_limit),
            )
            for row in rows:
                candidate_count += 1
                record = dict(row)
                parsed_count += 1
                if push_result(heap, keep, sequence, record, terms):
                    sequence += 1
        finally:
            conn.close()
    results = [item[2] for item in sorted(heap, key=lambda item: (-item[0], item[1]))]
    return candidate_count, parsed_count, results


def search_jsonl(files: list[Path], terms: list[str], keep: int) -> tuple[int, int, list[dict]]:
    candidate_count = 0
    parsed_count = 0
    heap: list[tuple[int, int, dict]] = []
    sequence = 0
    for index_file in files:
        with index_file.open("r", encoding="utf-8") as handle:
            for line in handle:
                candidate_count += 1
                try:
                    record = json.loads(line)
                    parsed_count += 1
                except Exception:
                    continue
                if push_result(heap, keep, sequence, record, terms):
                    sequence += 1
    results = [item[2] for item in sorted(heap, key=lambda item: (-item[0], item[1]))]
    return candidate_count, parsed_count, results


def main() -> int:
    args = parse_args()
    started = time.perf_counter()
    index_dir = resolve_index_dir(args.index_dir)
    if not index_dir:
        print(
            json.dumps(
                {
                    "available": False,
                    "message": "PowerLit index unavailable",
                    "candidate_source": "none",
                    "results": [],
                    "elapsed_ms": int((time.perf_counter() - started) * 1000),
                },
                ensure_ascii=False,
                indent=2,
            )
        )
        return 2

    terms = normalize_terms(args.query, args.terms)
    manifest = load_manifest(index_dir)
    files = sqlite_files(index_dir, manifest, args.venue_folders)
    candidate_source = "powerlit_index_sqlite"
    if not files:
        files = jsonl_files(index_dir, manifest, args.venue_folders)
        candidate_source = "powerlit_index_jsonl"
    if not files:
        print(
            json.dumps(
                {
                    "available": False,
                    "message": "PowerLit index has no matching venue files",
                    "index_dir": str(index_dir),
                    "venue_folders": args.venue_folders,
                    "candidate_source": "powerlit_index",
                    "results": [],
                    "elapsed_ms": int((time.perf_counter() - started) * 1000),
                },
                ensure_ascii=False,
                indent=2,
            )
        )
        return 2

    keep = max(args.top, 1)
    if candidate_source == "powerlit_index_sqlite":
        candidate_count, parsed_count, results = search_sqlite(files, terms, keep)
    else:
        candidate_count, parsed_count, results = search_jsonl(files, terms, keep)
    elapsed_ms = int((time.perf_counter() - started) * 1000)
    print(
        json.dumps(
            {
                "available": True,
                "index_dir": str(index_dir),
                "index_built_at": manifest.get("generated_at") or manifest.get("built_at"),
                "query": args.query,
                "terms": terms,
                "candidate_source": candidate_source,
                "candidate_count": candidate_count,
                "candidate_file_limit": 0,
                "parsed_count": parsed_count,
                "elapsed_ms": elapsed_ms,
                "count": len(results),
                "results": results,
            },
            ensure_ascii=False,
            indent=2,
        )
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
