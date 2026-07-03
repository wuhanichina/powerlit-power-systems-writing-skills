#!/usr/bin/env python3
"""Semi-automated regression runner for the PowerLit skill suite.

The repository already ships regression assets (per-skill ``test-prompts.json``
plus write->review closure cases in ``evaluation/``), but executing them needs
an agent. This runner turns those assets into an auditable loop:

1. ``list``    - enumerate all regression cases with ids and sources.
2. ``show``    - print one case's prompt(s) ready to paste into an agent run.
3. ``record``  - append the human/judge verdict for a case to ``evaluation/results.tsv``.
4. ``status``  - summarize latest verdicts and warn when dry_run ratio > 30%%.

Verdicts are recorded, not computed: the point is a ratchet log (like the
darwin-skill ``results.tsv``), so skill revisions can be judged by whether
previously failing cases now pass.

Examples:
    python scripts/Run-SkillRegression.py list
    python scripts/Run-SkillRegression.py show --id tsg-distributed-control-loop
    python scripts/Run-SkillRegression.py record --id tsg-distributed-control-loop \
        --mode full_test --verdict pass --note "review found no fatal flaw"
    python scripts/Run-SkillRegression.py status
"""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")

REPO_ROOT = Path(__file__).resolve().parent.parent
RESULTS_TSV = REPO_ROOT / "evaluation" / "results.tsv"
RESULTS_HEADER = "timestamp\tcommit\tsource\tcase_id\teval_mode\tverdict\tnote\n"
VALID_MODES = ("full_test", "dry_run")
VALID_VERDICTS = ("pass", "fail", "partial", "blocked")


def load_json(path: Path):
    return json.loads(path.read_text(encoding="utf-8"))


def collect_cases() -> list[dict]:
    cases: list[dict] = []
    for prompts_file in sorted(REPO_ROOT.glob("skills/*/test-prompts.json")):
        skill = prompts_file.parent.name
        for item in load_json(prompts_file):
            cases.append(
                {
                    "id": item["id"],
                    "source": f"skills/{skill}/test-prompts.json",
                    "kind": "test_prompt",
                    "prompt": item.get("prompt", ""),
                    "expected": item.get("expected", ""),
                }
            )
    closure_file = REPO_ROOT / "evaluation" / "writing-review-closure.json"
    if closure_file.is_file():
        for item in load_json(closure_file):
            cases.append(
                {
                    "id": item["id"],
                    "source": "evaluation/writing-review-closure.json",
                    "kind": "write_review_closure",
                    "write_prompt": item.get("write_prompt", ""),
                    "review_prompt": item.get("review_prompt", ""),
                    "pass_criteria": item.get("pass_criteria", ""),
                    "repair_required_when": item.get("repair_required_when", ""),
                }
            )
    reconstruction_file = REPO_ROOT / "evaluation" / "powerlit-paper-reconstruction-cases.json"
    if reconstruction_file.is_file():
        for item in load_json(reconstruction_file):
            cases.append(
                {
                    "id": item["id"],
                    "source": "evaluation/powerlit-paper-reconstruction-cases.json",
                    "kind": "reconstruction_benchmark",
                    "write_prompt": item.get("write_prompt", ""),
                    "review_prompt": item.get("review_prompt", ""),
                    "pass_criteria": item.get("pass_criteria", ""),
                }
            )
    return cases


def find_case(case_id: str) -> dict | None:
    for case in collect_cases():
        if case["id"] == case_id:
            return case
    return None


def git_commit() -> str:
    try:
        out = subprocess.run(
            ["git", "-C", str(REPO_ROOT), "rev-parse", "--short", "HEAD"],
            capture_output=True,
            text=True,
            timeout=10,
        )
        return out.stdout.strip() or "unknown"
    except Exception:
        return "unknown"


def cmd_list(_: argparse.Namespace) -> int:
    cases = collect_cases()
    for case in cases:
        print(f"{case['id']}\t{case['kind']}\t{case['source']}")
    print(f"\n{len(cases)} cases.", file=sys.stderr)
    return 0


def cmd_show(args: argparse.Namespace) -> int:
    case = find_case(args.id)
    if not case:
        print(f"Unknown case id: {args.id}", file=sys.stderr)
        return 2
    print(json.dumps(case, ensure_ascii=False, indent=2))
    return 0


def ensure_results_file() -> None:
    if not RESULTS_TSV.is_file():
        RESULTS_TSV.parent.mkdir(parents=True, exist_ok=True)
        RESULTS_TSV.write_text(RESULTS_HEADER, encoding="utf-8")


def cmd_record(args: argparse.Namespace) -> int:
    case = find_case(args.id)
    if not case:
        print(f"Unknown case id: {args.id}", file=sys.stderr)
        return 2
    if args.mode not in VALID_MODES:
        print(f"mode must be one of {VALID_MODES}", file=sys.stderr)
        return 2
    if args.verdict not in VALID_VERDICTS:
        print(f"verdict must be one of {VALID_VERDICTS}", file=sys.stderr)
        return 2
    ensure_results_file()
    note = (args.note or "").replace("\t", " ").replace("\n", " ").strip()
    timestamp = datetime.now(timezone.utc).isoformat(timespec="seconds").replace("+00:00", "Z")
    row = f"{timestamp}\t{git_commit()}\t{case['source']}\t{case['id']}\t{args.mode}\t{args.verdict}\t{note}\n"
    with RESULTS_TSV.open("a", encoding="utf-8", newline="\n") as handle:
        handle.write(row)
    print(f"Recorded: {row.strip()}")
    return 0


def cmd_status(_: argparse.Namespace) -> int:
    if not RESULTS_TSV.is_file():
        print("No results.tsv yet. Use `record` after running a case.")
        return 0
    lines = [line for line in RESULTS_TSV.read_text(encoding="utf-8").splitlines() if line.strip()]
    rows = [line.split("\t") for line in lines[1:]]
    latest: dict[str, list[str]] = {}
    for row in rows:
        if len(row) >= 6:
            latest[row[3]] = row
    total_cases = len(collect_cases())
    covered = len(latest)
    dry_runs = sum(1 for row in latest.values() if row[4] == "dry_run")
    fails = [case_id for case_id, row in latest.items() if row[5] in ("fail", "blocked")]
    print(f"cases_total={total_cases} covered={covered} uncovered={total_cases - covered}")
    for case_id, row in sorted(latest.items()):
        print(f"{case_id}\t{row[4]}\t{row[5]}\t{row[0]}")
    if covered and dry_runs / covered > 0.30:
        print(
            f"WARNING: dry_run ratio {dry_runs}/{covered} exceeds 30% — effect scores are not trustworthy; "
            "run more full tests.",
            file=sys.stderr,
        )
    if fails:
        print(f"WARNING: failing cases: {', '.join(fails)}", file=sys.stderr)
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description="PowerLit skill regression runner.")
    sub = parser.add_subparsers(dest="command", required=True)

    sub.add_parser("list", help="List all regression cases.")

    show = sub.add_parser("show", help="Print one case's prompts for an agent run.")
    show.add_argument("--id", required=True)

    record = sub.add_parser("record", help="Record a verdict for a case.")
    record.add_argument("--id", required=True)
    record.add_argument("--mode", required=True, choices=VALID_MODES)
    record.add_argument("--verdict", required=True, choices=VALID_VERDICTS)
    record.add_argument("--note", default="")

    sub.add_parser("status", help="Summarize latest verdicts and dry_run ratio.")

    args = parser.parse_args()
    handlers = {"list": cmd_list, "show": cmd_show, "record": cmd_record, "status": cmd_status}
    return handlers[args.command](args)


if __name__ == "__main__":
    raise SystemExit(main())
