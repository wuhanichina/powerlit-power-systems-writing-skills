#!/usr/bin/env python3
"""Build an uncalibrated descriptive evidence profile from retrieved papers."""

from __future__ import annotations

import argparse
import json
import re
import sqlite3
import subprocess
import sys
from pathlib import Path
from typing import Any

from powerlit_index_common import canonicalize_venue, normalize_doi, normalize_title, resolve_index_dir

SIGNALS = {
    "systems": re.compile(r"IEEE\s*\d+\s*[- ]?\s*(?:bus|node)|case\d+|RTS|PEGASE|CIGRE|MATPOWER|feeder|distribution system|配电网|节点系统|母线系统", re.I),
    "baselines": re.compile(r"compared with|comparison|benchmark|baseline|state-of-the-art|existing method|对比|相比|基准|传统方法|已有方法", re.I),
    "metrics": re.compile(r"RMSE|MAE|MAPE|MSE|KS|Wasserstein|cost|runtime|CPU time|voltage deviation|voltage violation|probability|误差|成本|电压偏差|越限|运行时间|概率|精度", re.I),
    "sensitivity_or_ablation": re.compile(r"sensitivity|ablation|varying|different cases|消融|敏感性|不同场景|不同参数", re.I),
    "reproducibility": re.compile(r"solver|tolerance|hardware|CPU|GPU|MATLAB|Python|CVX|CPLEX|Gurobi|seed|stopping criterion|求解器|容差|硬件|随机种子|停止准则", re.I),
    "boundary": re.compile(r"limitation|outside the scope|future work|under the condition|局限|适用范围|边界|未来工作|在.*条件下", re.I),
}


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Analyze descriptive evidence signals in PowerLit candidates.")
    parser.add_argument("--query", required=True)
    parser.add_argument("--terms", nargs="*", default=[])
    parser.add_argument("--index-dir")
    parser.add_argument("--venue-folder", action="append", default=[])
    parser.add_argument("--top", type=int, default=5)
    return parser.parse_args()


def run_search(args: argparse.Namespace, index_dir: Path) -> dict[str, Any]:
    command = [
        sys.executable,
        str(Path(__file__).with_name("Search-PowerLitIndex.py")),
        "--query",
        args.query,
        "--index-dir",
        str(index_dir),
        "--top",
        str(max(args.top, 1)),
    ]
    if args.terms:
        command.append("--terms")
        command.extend(args.terms)
    for venue in args.venue_folder:
        command.extend(["--venue-folder", venue])
    completed = subprocess.run(command, check=False, capture_output=True, text=True, encoding="utf-8")
    if not completed.stdout:
        raise RuntimeError(completed.stderr.strip() or "PowerLit search produced no JSON output")
    payload = json.loads(completed.stdout)
    if completed.returncode != 0:
        raise RuntimeError(payload.get("message") or completed.stderr.strip() or "PowerLit search failed")
    return payload


def database_files(index_dir: Path, search: dict[str, Any]) -> list[Path]:
    selected = (search.get("coverage") or {}).get("selected_files") or []
    files = [index_dir / name for name in selected if (index_dir / name).is_file()]
    return files or sorted(index_dir.glob("*.sqlite"))


def table_columns(conn: sqlite3.Connection) -> set[str]:
    return {str(row[1]) for row in conn.execute("PRAGMA table_info(records)")}


def fetch_candidate_text(files: list[Path], result: dict[str, Any]) -> str:
    doi = normalize_doi(str(result.get("doi") or ""))
    title = normalize_title(str(result.get("title") or ""))
    relative_path = str(result.get("relative_path") or "").replace("\\", "/")
    for file in files:
        if not file.is_file():
            continue
        conn = sqlite3.connect(str(file))
        conn.row_factory = sqlite3.Row
        try:
            available = table_columns(conn)
            text_columns = [
                name
                for name in ("abstract", "introduction", "method", "results", "conclusion", "content", "content_head")
                if name in available
            ]
            if not text_columns:
                continue
            select = ", ".join(text_columns)
            row = None
            if doi and "doi" in available:
                rows = conn.execute(f"SELECT doi, {select} FROM records WHERE doi IS NOT NULL").fetchall()
                row = next((item for item in rows if normalize_doi(str(item["doi"] or "")) == doi), None)
            if row is None and relative_path and "relative_path" in available:
                rows = conn.execute(f"SELECT relative_path, {select} FROM records").fetchall()
                row = next((item for item in rows if str(item["relative_path"] or "").replace("\\", "/") == relative_path), None)
            if row is None and title and "normalized_title" in available:
                row = conn.execute(f"SELECT {select} FROM records WHERE normalized_title=? LIMIT 1", (title,)).fetchone()
            if row is None and title and "title" in available:
                rows = conn.execute(f"SELECT title, {select} FROM records").fetchall()
                row = next((item for item in rows if normalize_title(str(item["title"] or "")) == title), None)
            if row is not None:
                return "\n".join(str(row[name] or "") for name in text_columns)
        finally:
            conn.close()
    return str(result.get("snippet") or "")


def signal_profile(text: str) -> dict[str, Any]:
    result: dict[str, Any] = {}
    for name, pattern in SIGNALS.items():
        matches = [match.group(0).strip() for match in pattern.finditer(text)]
        result[name] = {
            "present": bool(matches),
            "count": len(matches),
            "examples": list(dict.fromkeys(matches))[:6],
        }
    return result


def main() -> int:
    args = parse_args()
    index_dir = resolve_index_dir(args.index_dir)
    if not index_dir:
        print(json.dumps({"available": False, "message": "PowerLit index unavailable"}, ensure_ascii=False, indent=2))
        return 2
    try:
        search = run_search(args, index_dir)
        files = database_files(index_dir, search)
        papers = []
        for result in search.get("results") or []:
            text = fetch_candidate_text(files, result)
            papers.append(
                {
                    "title": result.get("title"),
                    "venue_folder": result.get("venue_folder"),
                    "year": result.get("year"),
                    "doi": result.get("doi"),
                    "relative_path": result.get("relative_path"),
                    "retrieval_score": result.get("retrieval_score"),
                    "lexical_hints": signal_profile(text),
                }
            )
        hint_coverage = {
            name: sum(1 for paper in papers if paper["lexical_hints"][name]["present"])
            for name in SIGNALS
        }
        payload = {
            "available": True,
            "query": args.query,
            "requested_venues": [canonicalize_venue(value) or value for value in args.venue_folder],
            "retrieval_coverage": search.get("coverage"),
            "sampled_paper_count": len(papers),
            "lexical_hint_coverage": hint_coverage,
            "calibration": {
                "status": "UNCALIBRATED",
                "reason": "Accepted-paper samples estimate descriptive feature prevalence, not acceptance probability or a review threshold.",
                "allowed_use": [
                    "identify manuscript-facing evidence dimensions for manual inspection",
                    "form a descriptive completeness checklist",
                    "select papers for direct technical reading",
                ],
                "forbidden_use": [
                    "infer probability of acceptance",
                    "claim an official venue score threshold",
                    "treat keyword presence as evidence sufficiency",
                ],
            },
            "inspection_required": True,
            "papers": papers,
        }
        print(json.dumps(payload, ensure_ascii=False, indent=2))
        return 0
    except Exception as exc:
        print(json.dumps({"available": False, "message": str(exc)}, ensure_ascii=False, indent=2))
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
