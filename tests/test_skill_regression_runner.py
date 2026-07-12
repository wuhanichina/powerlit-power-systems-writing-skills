"""Tests for scripts/Run-SkillRegression.py and the year-derivation helper."""

import importlib.util
import json
import subprocess
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
RUNNER = REPO_ROOT / "scripts" / "Run-SkillRegression.py"
INDEX_COMMON = (
    REPO_ROOT
    / "skills"
    / "powerlit-power-systems-literature-intelligence"
    / "scripts"
    / "powerlit_index_common.py"
)


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def run_runner(*args: str):
    return subprocess.run(
        [sys.executable, str(RUNNER), *args],
        capture_output=True,
        text=True,
        encoding="utf-8",
        cwd=str(REPO_ROOT),
    )


def test_runner_list_covers_all_regression_sources():
    result = run_runner("list")
    assert result.returncode == 0, result.stderr
    lines = [line for line in result.stdout.splitlines() if line.strip()]
    kinds = {line.split("\t")[1] for line in lines}
    assert "test_prompt" in kinds
    assert "write_review_closure" in kinds
    assert "reconstruction_benchmark" in kinds
    assert "innovation_narrative" in kinds
    assert "figure_first" in kinds
    # every skill's test-prompts.json contributes at least one case
    sources = {line.split("\t")[2] for line in lines}
    prompt_files = set(
        f"skills/{p.parent.name}/test-prompts.json" for p in REPO_ROOT.glob("skills/*/test-prompts.json")
    )
    assert prompt_files <= sources


def test_runner_show_returns_case_payload():
    result = run_runner("show", "--id", "tsg-distributed-control-loop")
    assert result.returncode == 0, result.stderr
    payload = json.loads(result.stdout)
    assert payload["kind"] == "write_review_closure"
    assert "write_prompt" in payload and "review_prompt" in payload


def test_runner_show_unknown_id_fails():
    result = run_runner("show", "--id", "no-such-case")
    assert result.returncode == 2


def test_runner_show_returns_new_routing_fixture():
    result = run_runner("show", "--id", "zero-to-one-object-not-leaderboard")
    assert result.returncode == 0, result.stderr
    payload = json.loads(result.stdout)
    assert payload["kind"] == "innovation_narrative"
    assert "leaderboard" in payload["expected"]


def test_runner_record_appends_valid_row(tmp_path, monkeypatch):
    runner = load_module(RUNNER, "run_skill_regression")
    results = tmp_path / "results.tsv"
    monkeypatch.setattr(runner, "RESULTS_TSV", results)

    class Args:
        id = "tsg-distributed-control-loop"
        mode = "dry_run"
        verdict = "pass"
        note = "unit\ttest"

    assert runner.cmd_record(Args()) == 0
    lines = results.read_text(encoding="utf-8").splitlines()
    assert lines[0] == runner.RESULTS_HEADER.strip()
    row = lines[1].split("\t")
    assert len(row) == 7
    assert row[3] == "tsg-distributed-control-loop"
    assert row[4] == "dry_run"
    assert row[5] == "pass"
    assert "\t" not in row[6]


def test_derive_year_from_common_doi_families():
    common = load_module(INDEX_COMMON, "powerlit_index_common")
    assert common.derive_year(None, "10.1109/tpwrs.2012.2187804", "") == "2012"
    assert common.derive_year("", "10.1016/j.apenergy.2023.122106", "") == "2023"
    assert common.derive_year("", "10.7500/aeps20240129007", "") == "2024"
    assert common.derive_year("", "10.13334/j.0258-8013.pcsee.220221", "") == "2022"
    assert common.derive_year("", "10.13335/j.1000-3673.pst.2024.1240", "") == "2024"
    assert common.derive_year("2019", "10.1109/tpwrs.2012.2187804", "") == "2019"
    assert common.derive_year("", "", "IEEE TRANSACTIONS ON POWER SYSTEMS, VOL. 27, NO. 4, NOVEMBER 2012") == "2012"
    assert common.derive_year("", "", "发表于 2021 年第 3 期") == "2021"
    assert common.derive_year("", "", "no year here") == ""
