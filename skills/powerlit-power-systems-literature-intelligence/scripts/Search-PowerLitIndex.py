#!/usr/bin/env python3
"""Search portable PowerLit SQLite indexes.

Retrieval produces candidate literature, not a novelty verdict.  The output
therefore separates ranking, corpus coverage, and the technical-comparison gate.
Both the bundled schema-v1 cache and newly built schema-v2 indexes are supported.
"""

from __future__ import annotations

import argparse
import json
import math
import sqlite3
import sys
import time
from collections import defaultdict
from pathlib import Path
from typing import Any, Iterable

from powerlit_index_common import (
    analyze_query,
    canonicalize_venue,
    count_contains,
    get_snippet,
    normalize_doi,
    normalize_title,
    resolve_index_dir,
    safe_name,
)

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")

FIELD_WEIGHTS = {
    "title": 8.0,
    "source_title": 2.0,
    "abstract": 5.0,
    "keywords": 5.0,
    "introduction": 2.0,
    "method": 4.0,
    "results": 3.0,
    "conclusion": 2.0,
    "content": 1.0,
    "content_head": 1.0,
}


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Search a portable PowerLit index.")
    parser.add_argument("--query", required=True)
    parser.add_argument("--terms", nargs="*", default=[])
    parser.add_argument("--index-dir")
    parser.add_argument("--venue-folder", action="append", default=[])
    parser.add_argument("--top", type=int, default=20)
    parser.add_argument("--min-year", type=int)
    parser.add_argument("--recent-years", type=int, default=5)
    return parser.parse_args()


def load_manifest(index_dir: Path) -> dict[str, Any]:
    path = index_dir / "manifest.json"
    try:
        item = json.loads(path.read_text(encoding="utf-8"))
        return item if isinstance(item, dict) else {"venues": {}}
    except (OSError, ValueError, TypeError):
        return {"venues": {}}


def table_exists(conn: sqlite3.Connection, name: str) -> bool:
    return conn.execute(
        "SELECT 1 FROM sqlite_master WHERE name=? LIMIT 1", (name,)
    ).fetchone() is not None


def columns(conn: sqlite3.Connection, table: str) -> list[str]:
    return [str(row[1]) for row in conn.execute(f"PRAGMA table_info({table})")]


def quote_fts(terms: Iterable[str]) -> str:
    result: list[str] = []
    for term in terms:
        cleaned = str(term).strip().replace('"', '""')
        if cleaned:
            result.append(f'"{cleaned}"')
    return " OR ".join(result)


def requested_venues(values: list[str]) -> tuple[list[str], list[str]]:
    canonical: list[str] = []
    unknown: list[str] = []
    for value in values:
        mapped = canonicalize_venue(value)
        if mapped:
            canonical.append(mapped)
        else:
            unknown.append(value)
    return list(dict.fromkeys(canonical)), unknown


def select_files(
    index_dir: Path, manifest: dict[str, Any], venues: list[str]
) -> tuple[list[Path], list[str]]:
    entries = manifest.get("venues") or {}
    if venues:
        found: list[Path] = []
        missing: list[str] = []
        for venue in venues:
            entry = entries.get(venue) or {}
            filename = str(entry.get("sqlite_file") or f"{safe_name(venue)}.sqlite")
            path = index_dir / filename
            if path.is_file():
                found.append(path)
            else:
                missing.append(venue)
        return found, missing

    found = []
    for entry in entries.values():
        filename = entry.get("sqlite_file")
        if filename and (index_dir / filename).is_file():
            found.append(index_dir / filename)
    known = {path.name for path in found}
    found.extend(path for path in sorted(index_dir.glob("*.sqlite")) if path.name not in known)
    return found, []


def record_text(record: dict[str, Any], field: str) -> str:
    return str(record.get(field) or "")


def normalized_record(row: sqlite3.Row, available: set[str]) -> dict[str, Any]:
    record = {name: row[name] for name in row.keys() if name != "fts_rank"}
    record.setdefault("relative_path", "")
    record.setdefault("title", "")
    record.setdefault("source_title", "")
    record.setdefault("doi", "")
    record.setdefault("year", None)
    record.setdefault("authors", "")
    record.setdefault("document_type", "")
    record.setdefault("normalized_title", normalize_title(record_text(record, "title")))
    if "content" not in available:
        record["content"] = record_text(record, "content_head")
    return record


def add_rows(
    target: dict[tuple[str, int], dict[str, Any]],
    db_name: str,
    rows: Iterable[sqlite3.Row],
    available: set[str],
    signal: str,
) -> None:
    for row in rows:
        key = (db_name, int(row["id"]))
        item = target.setdefault(
            key,
            {
                "record": normalized_record(row, available),
                "fts_signal": 0.0,
                "substring_signal": 0.0,
            },
        )
        if signal == "fts":
            rank = float(row["fts_rank"] or 0.0)
            item["fts_signal"] = max(item["fts_signal"], max(0.0, -rank))
        else:
            item["substring_signal"] = 1.0


def query_database(
    path: Path,
    exact_terms: list[str],
    expanded_terms: list[str],
    cjk_ngrams: list[str],
    limit: int,
    min_year: int | None,
) -> dict[tuple[str, int], dict[str, Any]]:
    conn = sqlite3.connect(str(path))
    conn.row_factory = sqlite3.Row
    result: dict[tuple[str, int], dict[str, Any]] = {}
    try:
        available_list = columns(conn, "records")
        available = set(available_list)
        selected = ", ".join(f"r.{name}" for name in available_list)
        year_clause = ""
        year_args: tuple[Any, ...] = ()
        if min_year and "year" in available:
            year_clause = " AND (r.year IS NULL OR CAST(r.year AS INTEGER) >= ?)"
            year_args = (min_year,)

        fts_query = quote_fts(exact_terms + expanded_terms)
        if fts_query and table_exists(conn, "records_fts"):
            rows = conn.execute(
                f"""
                SELECT {selected}, bm25(records_fts) AS fts_rank
                FROM records_fts
                JOIN records r ON r.id = records_fts.rowid
                WHERE records_fts MATCH ? {year_clause}
                ORDER BY fts_rank
                LIMIT ?
                """,
                (fts_query, *year_args, limit),
            )
            add_rows(result, path.name, rows, available, "fts")

        # Unicode61 does not provide Chinese substring recall.  A bounded LIKE
        # pass over CJK n-grams preserves recall for the existing bundled cache.
        substring_terms = cjk_ngrams[:24]
        if substring_terms:
            searchable = [
                name
                for name in ("title", "source_title", "abstract", "keywords", "method", "results", "content", "content_head")
                if name in available
            ]
            conditions: list[str] = []
            arguments: list[Any] = []
            for term in substring_terms:
                per_term = []
                for field in searchable:
                    per_term.append(f"r.{field} LIKE ?")
                    arguments.append(f"%{term}%")
                if per_term:
                    conditions.append("(" + " OR ".join(per_term) + ")")
            if conditions:
                rows = conn.execute(
                    f"""
                    SELECT {selected}, 0.0 AS fts_rank
                    FROM records r
                    WHERE ({' OR '.join(conditions)}) {year_clause}
                    LIMIT ?
                    """,
                    (*arguments, *year_args, limit),
                )
                add_rows(result, path.name, rows, available, "substring")
        return result
    finally:
        conn.close()


def score_record(
    item: dict[str, Any],
    exact_terms: list[str],
    expanded_terms: list[str],
    query: str,
    max_year: int | None,
    recent_years: int,
) -> tuple[float, list[str], list[str], dict[str, float]]:
    record = item["record"]
    field_score = 0.0
    matched_fields: set[str] = set()
    matched_terms: list[str] = []
    for field, weight in FIELD_WEIGHTS.items():
        text = record_text(record, field)
        if not text:
            continue
        for term in exact_terms:
            hits = min(count_contains(text, term), 3)
            if hits:
                field_score += weight * (1.0 + math.log1p(hits))
                matched_fields.add(field)
                matched_terms.append(term)
        for term in expanded_terms:
            hits = min(count_contains(text, term), 2)
            if hits:
                field_score += 0.45 * weight * (1.0 + math.log1p(hits))
                matched_fields.add(field)
                matched_terms.append(term)

    phrase_score = 0.0
    normalized_query = query.strip().casefold()
    if len(normalized_query) >= 4:
        if normalized_query in record_text(record, "title").casefold():
            phrase_score += 12.0
        elif normalized_query in record_text(record, "abstract").casefold():
            phrase_score += 5.0

    recency_score = 0.0
    try:
        year = int(record.get("year"))
    except (TypeError, ValueError):
        year = 0
    if year and max_year and recent_years > 0:
        age = max(0, max_year - year)
        if age < recent_years:
            recency_score = 2.0 * (recent_years - age) / recent_years

    components = {
        "field_match": round(field_score, 6),
        "phrase": round(phrase_score, 6),
        "recency": round(recency_score, 6),
        "fts_candidate": round(float(item["fts_signal"]), 6),
        "cjk_substring_candidate": round(float(item["substring_signal"]), 6),
    }
    score = field_score + phrase_score + recency_score + min(float(item["fts_signal"]), 4.0)
    return (
        score,
        list(dict.fromkeys(matched_terms)),
        sorted(matched_fields),
        components,
    )


def year_bounds(files: list[Path]) -> tuple[int | None, int | None]:
    values: list[int] = []
    for path in files:
        with sqlite3.connect(str(path)) as conn:
            if "year" not in set(columns(conn, "records")):
                continue
            row = conn.execute(
                "SELECT MIN(CAST(year AS INTEGER)), MAX(CAST(year AS INTEGER)) "
                "FROM records WHERE year IS NOT NULL AND CAST(year AS INTEGER)>1800"
            ).fetchone()
            for value in row or ():
                if value:
                    values.append(int(value))
    return (min(values), max(values)) if values else (None, None)


def coverage(
    manifest: dict[str, Any], venues: list[str], files: list[Path]
) -> dict[str, Any]:
    entries = manifest.get("venues") or {}
    selected = venues or list(entries)
    counts = {venue: int((entries.get(venue) or {}).get("records") or 0) for venue in selected}
    if not counts:
        status, reasons = "UNKNOWN", ["manifest does not identify venue coverage"]
    elif any(value < 50 for value in counts.values()):
        status, reasons = "INSUFFICIENT", ["a selected venue has fewer than 50 indexed records"]
    elif sum(counts.values()) < 200:
        status, reasons = "LIMITED", ["the selected corpus has fewer than 200 indexed records"]
    else:
        status, reasons = "SUFFICIENT_FOR_CANDIDATE_RETRIEVAL", []
    first_year, last_year = year_bounds(files)
    if last_year is None:
        if status == "SUFFICIENT_FOR_CANDIDATE_RETRIEVAL":
            status = "LIMITED"
        reasons.append("publication-year coverage is unavailable")
    return {
        "status": status,
        "venue_records": counts,
        "year_min": first_year,
        "year_max": last_year,
        "reasons": reasons,
    }


def dedup_key(record: dict[str, Any]) -> str:
    doi = normalize_doi(record_text(record, "doi"))
    if doi:
        return f"doi:{doi}"
    title = record_text(record, "normalized_title") or normalize_title(record_text(record, "title"))
    return f"title:{title}" if title else f"path:{record_text(record, 'relative_path')}"


def fail(message: str, reason: str, **extra: Any) -> int:
    print(
        json.dumps(
            {
                "available": False,
                "message": message,
                **extra,
                "results": [],
                "novelty_gate": {"status": "UNKNOWN", "reasons": [reason]},
            },
            ensure_ascii=False,
            indent=2,
        )
    )
    return 2


def main() -> int:
    args = parse_args()
    started = time.perf_counter()
    index_dir = resolve_index_dir(args.index_dir)
    if not index_dir:
        return fail("PowerLit index unavailable", "index unavailable")

    manifest = load_manifest(index_dir)
    venues, unknown = requested_venues(args.venue_folder)
    if unknown:
        return fail(
            "Unknown venue alias; retrieval was not widened automatically",
            "unknown venue",
            unknown_venues=unknown,
        )
    files, missing = select_files(index_dir, manifest, venues)
    if missing:
        return fail(
            "Requested venue is absent; retrieval was not widened automatically",
            "requested venue absent",
            missing_venues=missing,
        )
    if not files:
        return fail("PowerLit index has no searchable SQLite shards", "no searchable shards")

    query_analysis = analyze_query(args.query, args.terms)
    exact = query_analysis["exact_terms"]
    expanded = query_analysis["expanded_terms"]
    ngrams = query_analysis["cjk_ngrams"]
    limit = max(max(args.top, 1) * 80, 500)

    candidates: dict[tuple[str, int], dict[str, Any]] = {}
    for path in files:
        candidates.update(query_database(path, exact, expanded, ngrams, limit, args.min_year))

    corpus_coverage = coverage(manifest, venues, files)
    max_year = corpus_coverage["year_max"]
    ranked: list[tuple[float, dict[str, Any], list[str], list[str], dict[str, float]]] = []
    for item in candidates.values():
        score, matched_terms, matched_fields, components = score_record(
            item, exact, expanded, args.query, max_year, args.recent_years
        )
        ranked.append((score, item["record"], matched_terms, matched_fields, components))
    ranked.sort(key=lambda value: value[0], reverse=True)

    results: list[dict[str, Any]] = []
    seen: set[str] = set()
    for score, record, matched_terms, matched_fields, components in ranked:
        key = dedup_key(record)
        if key in seen:
            continue
        seen.add(key)
        try:
            year = int(record.get("year")) if record.get("year") not in (None, "") else None
        except (TypeError, ValueError):
            year = None
        source = next(
            (
                record_text(record, field)
                for field in ("method", "abstract", "results", "introduction", "content", "content_head")
                if record_text(record, field)
            ),
            "",
        )
        results.append(
            {
                "retrieval_score": round(score, 6),
                "score_components": components,
                "title": record_text(record, "title"),
                "title_source": record_text(record, "title_source") or "record",
                "source_title": record_text(record, "source_title"),
                "authors": record_text(record, "authors"),
                "doi": normalize_doi(record_text(record, "doi")),
                "year": year,
                "document_type": record_text(record, "document_type"),
                "relative_path": record_text(record, "relative_path").replace("\\", "/"),
                "venue_folder": record_text(record, "venue_folder"),
                "matched_terms": matched_terms,
                "matched_fields": matched_fields,
                "is_recent": bool(
                    year and max_year and year >= max_year - max(args.recent_years, 1) + 1
                ),
                "snippet": get_snippet(source, matched_terms or exact),
            }
        )
        if len(results) >= max(args.top, 1):
            break

    novelty_reasons = [
        "retrieval scores rank candidates and are not novelty scores",
        "problem, mechanism, model, data, evidence, and claim overlap require technical comparison",
    ]
    novelty_status = "REQUIRES_TECHNICAL_COMPARISON"
    if corpus_coverage["status"] != "SUFFICIENT_FOR_CANDIDATE_RETRIEVAL":
        novelty_status = "UNKNOWN"
        novelty_reasons.extend(corpus_coverage["reasons"])
    if len(results) < 3:
        novelty_status = "UNKNOWN"
        novelty_reasons.append("fewer than three candidate records were retrieved")

    print(
        json.dumps(
            {
                "available": True,
                "index_schema_version": manifest.get("schema_version"),
                "index_built_at": manifest.get("built_at") or manifest.get("generated_at"),
                "query": args.query,
                "query_analysis": query_analysis,
                "requested_venues": venues,
                "candidate_source": "powerlit_index_sqlite",
                "candidate_count": len(candidates),
                "elapsed_ms": int((time.perf_counter() - started) * 1000),
                "count": len(results),
                "coverage": corpus_coverage,
                "novelty_gate": {
                    "status": novelty_status,
                    "reasons": list(dict.fromkeys(novelty_reasons)),
                },
                "results": results,
            },
            ensure_ascii=False,
            indent=2,
        )
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
