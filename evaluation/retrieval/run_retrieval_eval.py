#!/usr/bin/env python3
"""Run a small PowerLit retrieval evaluation fixture."""

from __future__ import annotations

import argparse
import json
import math
import statistics
import subprocess
import sys
from pathlib import Path


def repo_root() -> Path:
    return Path(__file__).resolve().parents[2]


def read_jsonl(path: Path) -> list[dict]:
    rows: list[dict] = []
    with path.open("r", encoding="utf-8") as handle:
        for line in handle:
            if line.strip():
                rows.append(json.loads(line))
    return rows


def qrel_match(result: dict, qrel: dict) -> bool:
    doi = str(qrel.get("doi") or "").strip().casefold()
    if doi and doi == str(result.get("doi") or "").strip().casefold():
        return True
    title_contains = str(qrel.get("title_contains") or "").strip().casefold()
    if title_contains and title_contains in str(result.get("title") or "").casefold():
        return True
    return False


def dcg(relevances: list[int], k: int) -> float:
    score = 0.0
    for index, rel in enumerate(relevances[:k], start=1):
        score += (2**rel - 1) / math.log2(index + 1)
    return score


def percentile(values: list[float], pct: float) -> float:
    if not values:
        return 0.0
    ordered = sorted(values)
    index = min(len(ordered) - 1, max(0, math.ceil((pct / 100.0) * len(ordered)) - 1))
    return ordered[index]


def run_search(query: dict, index_dir: str | None) -> dict:
    script = repo_root() / "skills" / "powerlit-power-systems-literature-intelligence" / "scripts" / "Search-PowerLitIndex.py"
    cmd = [sys.executable, str(script), "--query", str(query["query"]), "--venue-folder", str(query["venue"]), "--top", str(query.get("top", 20))]
    if index_dir:
        cmd.extend(["--index-dir", index_dir])
    proc = subprocess.run(cmd, cwd=repo_root(), text=True, encoding="utf-8", capture_output=True)
    try:
        payload = json.loads(proc.stdout)
    except Exception:
        payload = {"available": False, "message": proc.stderr.strip() or proc.stdout.strip(), "results": []}
    payload["_returncode"] = proc.returncode
    return payload


def main() -> int:
    parser = argparse.ArgumentParser(description="Evaluate PowerLit retrieval fixtures.")
    parser.add_argument("--queries", default=str(Path(__file__).with_name("queries.jsonl")))
    parser.add_argument("--qrels", default=str(Path(__file__).with_name("qrels.jsonl")))
    parser.add_argument("--index-dir")
    args = parser.parse_args()

    queries = read_jsonl(Path(args.queries))
    qrels_by_query: dict[str, list[dict]] = {}
    for qrel in read_jsonl(Path(args.qrels)):
        qrels_by_query.setdefault(str(qrel["query_id"]), []).append(qrel)

    per_query: list[dict] = []
    latencies: list[float] = []
    unknown = 0
    venue_leaks = 0
    duplicate_total = 0
    result_total = 0

    for query in queries:
        payload = run_search(query, args.index_dir)
        results = payload.get("results") or []
        latencies.append(float(payload.get("elapsed_ms") or 0))
        if not payload.get("available"):
            unknown += 1

        expected_venue = (payload.get("resolved_venue_folders") or [query.get("venue")])[0]
        seen_keys: set[str] = set()
        duplicate_count = 0
        for result in results:
            if result.get("venue_folder") != expected_venue:
                venue_leaks += 1
            key = str(result.get("doi") or result.get("title") or "").casefold()
            if key in seen_keys:
                duplicate_count += 1
            seen_keys.add(key)
        duplicate_total += duplicate_count
        result_total += len(results)

        qrels = qrels_by_query.get(str(query["id"]), [])
        matched_qrel_ranks: dict[int, int] = {}
        ranked_rels: list[int] = []
        for rank, result in enumerate(results, start=1):
            rel = 0
            matched_qrel_index: int | None = None
            for qrel_index, qrel in enumerate(qrels):
                if qrel_index in matched_qrel_ranks:
                    continue
                if qrel_match(result, qrel):
                    candidate_rel = int(qrel.get("relevance") or 1)
                    if candidate_rel > rel:
                        rel = candidate_rel
                        matched_qrel_index = qrel_index
            if matched_qrel_index is not None:
                matched_qrel_ranks[matched_qrel_index] = rank
            ranked_rels.append(rel)
        ideal_rels = sorted([int(qrel.get("relevance") or 1) for qrel in qrels], reverse=True)
        ndcg10 = dcg(ranked_rels, 10) / dcg(ideal_rels, 10) if ideal_rels and dcg(ideal_rels, 10) else 0.0
        relevant_total = max(len(qrels), 1)
        per_query.append(
            {
                "id": query["id"],
                "available": bool(payload.get("available")),
                "result_count": len(results),
                "recall_at_5": sum(1 for rank in matched_qrel_ranks.values() if rank <= 5) / relevant_total,
                "recall_at_10": sum(1 for rank in matched_qrel_ranks.values() if rank <= 10) / relevant_total,
                "recall_at_20": sum(1 for rank in matched_qrel_ranks.values() if rank <= 20) / relevant_total,
                "mrr": 1.0 / min(matched_qrel_ranks.values()) if matched_qrel_ranks else 0.0,
                "ndcg_at_10": ndcg10,
                "elapsed_ms": payload.get("elapsed_ms"),
            }
        )

    summary = {
        "query_count": len(queries),
        "recall_at_5": statistics.mean(item["recall_at_5"] for item in per_query) if per_query else 0.0,
        "recall_at_10": statistics.mean(item["recall_at_10"] for item in per_query) if per_query else 0.0,
        "recall_at_20": statistics.mean(item["recall_at_20"] for item in per_query) if per_query else 0.0,
        "mrr": statistics.mean(item["mrr"] for item in per_query) if per_query else 0.0,
        "ndcg_at_10": statistics.mean(item["ndcg_at_10"] for item in per_query) if per_query else 0.0,
        "venue_leakage": venue_leaks / result_total if result_total else 0.0,
        "duplicate_rate": duplicate_total / result_total if result_total else 0.0,
        "unknown_rate": unknown / len(queries) if queries else 0.0,
        "latency_p50_ms": percentile(latencies, 50),
        "latency_p95_ms": percentile(latencies, 95),
    }
    print(json.dumps({"summary": summary, "per_query": per_query}, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
