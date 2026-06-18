#!/usr/bin/env python3
"""Conservative raw-JSON fallback for PowerLit retrieval."""

from __future__ import annotations

import argparse
import heapq
import json
import sys
import time
from pathlib import Path
from typing import Any

from powerlit_index_common import (
    analyze_query,
    canonicalize_venue,
    get_snippet,
    iter_json_files,
    make_index_record,
    normalize_doi,
    normalize_title,
    resolve_json_root,
)

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Search raw PowerLit JSON records.")
    parser.add_argument("--query", required=True)
    parser.add_argument("--terms", nargs="*", default=[])
    parser.add_argument("--root")
    parser.add_argument("--venue-folder", action="append", default=[])
    parser.add_argument("--top", type=int, default=20)
    parser.add_argument("--candidate-file-limit", type=int, default=1000)
    parser.add_argument("--include-analysis", action="store_true")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    started = time.perf_counter()
    root = resolve_json_root(args.root)
    if not root:
        print(
            json.dumps(
                {
                    "available": False,
                    "message": "PowerLit raw corpus unavailable",
                    "results": [],
                    "novelty_gate": {"status": "UNKNOWN", "reasons": ["raw corpus unavailable"]},
                },
                ensure_ascii=False,
                indent=2,
            )
        )
        return 2

    venues: list[tuple[str, Path]] = []
    unknown: list[str] = []
    if args.venue_folder:
        for supplied in args.venue_folder:
            canonical = canonicalize_venue(supplied)
            if not canonical:
                unknown.append(supplied)
                continue
            path = root / canonical
            if not path.is_dir():
                unknown.append(supplied)
                continue
            venues.append((canonical, path))
    else:
        venues = [(child.name, child) for child in root.iterdir() if child.is_dir()]
        if not venues:
            venues = [("_root", root)]

    if unknown:
        print(
            json.dumps(
                {
                    "available": False,
                    "message": "Unknown or unavailable venue; raw retrieval was not widened",
                    "unknown_venues": unknown,
                    "results": [],
                    "novelty_gate": {"status": "UNKNOWN", "reasons": ["venue unavailable"]},
                },
                ensure_ascii=False,
                indent=2,
            )
        )
        return 2

    analysis = analyze_query(args.query, args.terms)
    exact = analysis["exact_terms"]
    expanded = analysis["expanded_terms"]
    terms = exact + expanded
    heap: list[tuple[float, int, dict[str, Any]]] = []
    parsed = 0
    sequence = 0
    seen_files = 0

    for venue, venue_root in venues:
        for path in iter_json_files(venue_root, include_analysis=args.include_analysis):
            if seen_files >= args.candidate_file_limit:
                break
            seen_files += 1
            record = make_index_record(path, root, venue)
            if not record:
                continue
            parsed += 1
            fields = {
                "title": str(record.get("title") or ""),
                "abstract": str(record.get("abstract") or ""),
                "method": str(record.get("method") or ""),
                "results": str(record.get("results") or ""),
                "content": str(record.get("content") or ""),
            }
            weights = {"title": 5.0, "abstract": 3.0, "method": 3.0, "results": 2.0, "content": 0.25}
            score = 0.0
            matched_fields: set[str] = set()
            matched_terms: list[str] = []
            for term in terms:
                matched = False
                for field, text in fields.items():
                    if term.casefold() in text.casefold():
                        score += weights[field]
                        matched_fields.add(field)
                        matched = True
                if matched:
                    matched_terms.append(term)
            if score <= 0:
                continue
            result = {
                "retrieval_score": round(score, 6),
                "title": record.get("title") or "",
                "title_source": record.get("title_source") or "record",
                "source_title": record.get("source_title") or "",
                "authors": record.get("authors") or "",
                "doi": normalize_doi(str(record.get("doi") or "")),
                "year": record.get("year"),
                "document_type": record.get("document_type") or "",
                "relative_path": record.get("relative_path") or "",
                "venue_folder": venue,
                "matched_terms": list(dict.fromkeys(matched_terms)),
                "matched_fields": sorted(matched_fields),
                "snippet": get_snippet(
                    fields["method"] or fields["abstract"] or fields["results"] or fields["content"],
                    matched_terms or exact,
                ),
            }
            item = (score, sequence, result)
            if len(heap) < max(args.top * 4, 20):
                heapq.heappush(heap, item)
            elif score > heap[0][0]:
                heapq.heapreplace(heap, item)
            sequence += 1

    ordered = [item[2] for item in sorted(heap, key=lambda item: (-item[0], item[1]))]
    deduped: list[dict[str, Any]] = []
    seen: set[str] = set()
    for item in ordered:
        key = normalize_doi(item["doi"]) or normalize_title(item["title"]) or item["relative_path"]
        if key in seen:
            continue
        seen.add(key)
        deduped.append(item)
        if len(deduped) >= max(args.top, 1):
            break

    elapsed = int((time.perf_counter() - started) * 1000)
    print(
        json.dumps(
            {
                "available": True,
                "query": args.query,
                "query_analysis": analysis,
                "candidate_source": "raw_json_scan",
                "candidate_file_limit": args.candidate_file_limit,
                "candidate_file_count": seen_files,
                "parsed_count": parsed,
                "elapsed_ms": elapsed,
                "count": len(deduped),
                "coverage": {
                    "status": "LIMITED",
                    "reasons": [
                        "raw fallback scans a bounded file set",
                        "ranking is lexical and has not passed the indexed retrieval benchmark",
                    ],
                },
                "novelty_gate": {
                    "status": "UNKNOWN",
                    "reasons": [
                        "raw fallback is candidate discovery only",
                        "technical overlap requires manual comparison",
                    ],
                },
                "results": deduped,
            },
            ensure_ascii=False,
            indent=2,
        )
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
