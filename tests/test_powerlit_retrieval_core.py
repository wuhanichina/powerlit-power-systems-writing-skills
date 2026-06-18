from __future__ import annotations

import hashlib
import importlib.util
import json
import os
import re
import sqlite3
import subprocess
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[1]
SKILL_ROOT = REPO_ROOT / "skills" / "powerlit-power-systems-literature-intelligence"
SCRIPT_DIR = SKILL_ROOT / "scripts"
INDEX_DIR = SKILL_ROOT / "assets" / "powerlit-index"
sys.path.insert(0, str(SCRIPT_DIR))

import powerlit_index_common as index_common
import query_analyzer


def load_script_module(filename: str, module_name: str):
    spec = importlib.util.spec_from_file_location(module_name, SCRIPT_DIR / filename)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


search_index = load_script_module("Search-PowerLitIndex.py", "search_powerlit_index")


def run_json(cmd: list[str], *, cwd: Path = REPO_ROOT) -> tuple[int, dict]:
    proc = subprocess.run(cmd, cwd=cwd, text=True, encoding="utf-8", capture_output=True)
    payload = json.loads(proc.stdout)
    return proc.returncode, payload


def test_resolve_index_dir_prefers_bundled_cache_without_environment(monkeypatch):
    monkeypatch.delenv("POWERLIT_INDEX_ROOT", raising=False)
    resolved = index_common.resolve_index_dir()
    assert resolved == INDEX_DIR.resolve()
    assert (resolved / "manifest.json").is_file()


def test_resolve_json_root_has_no_machine_default(monkeypatch):
    monkeypatch.delenv("POWERLIT_JSON_ROOT", raising=False)
    monkeypatch.delenv("POWERLIT_LITERATURE_JSON", raising=False)
    assert index_common.resolve_json_root() is None


def test_manifest_and_sqlite_schema_are_portable():
    manifest = json.loads((INDEX_DIR / "manifest.json").read_text(encoding="utf-8"))
    assert int(manifest["schema_version"]) >= 2
    for forbidden in ("path", "corpus_root", "index_dir", "source_root"):
        assert forbidden not in manifest

    smallest_shard = min(
        (INDEX_DIR / item["sqlite_file"] for item in manifest["venues"].values()),
        key=lambda path: path.stat().st_size,
    )
    shard_manifest = manifest["shards"][smallest_shard.name]
    assert re.fullmatch(r"[0-9a-f]{64}", shard_manifest["sha256"])
    digest = hashlib.sha256(smallest_shard.read_bytes()).hexdigest()
    assert digest == shard_manifest["sha256"]

    conn = sqlite3.connect(str(smallest_shard))
    try:
        columns = {row[1] for row in conn.execute("PRAGMA table_info(records)")}
        for required in ("record_id", "relative_path", "venue_folder", "doi", "title"):
            assert required in columns
        for forbidden in ("path", "corpus_root", "index_dir", "source_root"):
            assert forbidden not in columns
        relative_path = conn.execute("SELECT relative_path FROM records LIMIT 1").fetchone()[0]
        assert not re.match(r"^[A-Za-z]:[\\/]", relative_path)
        assert not relative_path.startswith("\\\\")
    finally:
        conn.close()


def test_query_analyzer_preserves_abbreviations_expands_aliases_and_keeps_cjk_phrases():
    query = '"distributionally robust optimization" AC DC PV EV UC DR OPF GMM DRO \u6982\u7387\u6f6e\u6d41'
    analysis = query_analyzer.analyze_query(query)
    for abbreviation in ("AC", "DC", "PV", "EV", "UC", "DR", "OPF", "GMM", "DRO"):
        assert abbreviation in analysis["terms"]
    assert "distributionally robust optimization" in analysis["phrases"]
    assert "optimal power flow" in analysis["terms"]
    assert "\u6982\u7387\u6f6e\u6d41" in analysis["terms"]
    assert "\u6982\u7387" in analysis["terms"]


def test_venue_registry_resolves_aliases_without_leakage():
    manifest = json.loads((INDEX_DIR / "manifest.json").read_text(encoding="utf-8"))
    resolved, errors = search_index.resolve_venues(["csee", "tpwrs", "\u4e2d\u56fd\u7535\u673a\u5de5\u7a0b\u5b66\u62a5"], manifest)
    assert errors == []
    assert "ieee_tpwrs" in resolved
    assert "\u4e2d\u56fd\u7535\u673a\u5de5\u7a0b\u5b66\u62a5" in resolved
    assert resolved.count("\u4e2d\u56fd\u7535\u673a\u5de5\u7a0b\u5b66\u62a5") == 1

    resolved, errors = search_index.resolve_venues(["not_a_venue"], manifest)
    assert resolved == []
    assert errors == ["not_a_venue"]


def test_dedupe_results_uses_doi_then_normalized_title():
    results = [
        {"doi": "10.1/ABC", "title": "First"},
        {"doi": "10.1/abc", "title": "Duplicate DOI"},
        {"doi": "", "title": "A Robust OPF Method"},
        {"doi": "", "title": "A Robust-OPF Method"},
    ]
    deduped = search_index.dedupe_results(results)
    assert [item["title"] for item in deduped] == ["First", "A Robust OPF Method"]


def test_unknown_venue_returns_error_without_all_venue_fallback():
    code, payload = run_json(
        [
            sys.executable,
            str(SCRIPT_DIR / "Search-PowerLitIndex.py"),
            "--query",
            "voltage control",
            "--venue-folder",
            "not_a_venue",
            "--top",
            "2",
        ]
    )
    assert code == 2
    assert payload["available"] is False
    assert payload["unknown_venues"] == ["not_a_venue"]
    assert payload["results"] == []


def test_build_index_and_search_smoke_use_portable_paths(tmp_path):
    corpus = tmp_path / "corpus"
    venue = corpus / "ieee_tsg"
    venue.mkdir(parents=True)
    paper = {
        "title": "Distributed Voltage Control for Active Distribution Networks",
        "source_title": "IEEE Transactions on Smart Grid",
        "doi": "10.9999/example.voltage",
        "year": 2024,
        "content": "Abstract: a distributed voltage control OPF method. Results show voltage control performance.",
    }
    (venue / "paper.json").write_text(json.dumps(paper), encoding="utf-8")
    index_dir = tmp_path / "index"

    build = subprocess.run(
        [
            sys.executable,
            str(SCRIPT_DIR / "Build-PowerLitIndex.py"),
            "--root",
            str(corpus),
            "--index-dir",
            str(index_dir),
            "--venue-folder",
            "ieee_tsg",
        ],
        cwd=REPO_ROOT,
        text=True,
        encoding="utf-8",
        capture_output=True,
    )
    assert build.returncode == 0, build.stderr or build.stdout

    manifest = json.loads((index_dir / "manifest.json").read_text(encoding="utf-8"))
    assert int(manifest["schema_version"]) >= 2
    assert "corpus_root" not in manifest
    assert manifest["shards"]["ieee_tsg.sqlite"]["records"] == 1

    code, payload = run_json(
        [
            sys.executable,
            str(SCRIPT_DIR / "Search-PowerLitIndex.py"),
            "--index-dir",
            str(index_dir),
            "--query",
            "voltage control",
            "--venue-folder",
            "tsg",
            "--top",
            "1",
        ]
    )
    assert code == 0
    assert payload["available"] is True
    assert payload["resolved_venue_folders"] == ["ieee_tsg"]
    assert payload["results"][0]["relative_path"] == "ieee_tsg/paper.json"
    assert payload["results"][0]["doi"] == "10.9999/example.voltage"
