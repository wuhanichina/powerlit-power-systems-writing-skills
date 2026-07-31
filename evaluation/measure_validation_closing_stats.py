# -*- coding: utf-8 -*-
"""Measure the Chinese validation closing-sentence convention on the bundled index.

This script is the single source for the corpus statistics quoted in
`skills/powerlit-power-systems-paper-writing/references/aeps.md`,
`skills/powerlit-power-systems-paper-writing/references/prose-quality-gates.md`,
`CHANGELOG.md`, and `tests/test_powerlit_readiness_rules.py`. If the bundled
index or the counting rule changes, rerun it and update those files together.

Counting rule
-------------
- Abstract: the text between the `摘要：` marker and the `关键词` (or
  `Abstract`) marker in each record's `content_head`.
- Sentence split: `。！？!?`.
- A hit: at least one sentence matching `验证了…<term>` where `<term>` is one of
  the five terms 有效性/可行性/正确性/优越性/准确性, with `验证了` and the term
  inside the same sentence.
- Closing-sentence count: the abstract's last sentence matches the same rule.

Usage
-----
    python evaluation/measure_validation_closing_stats.py
"""

from __future__ import annotations

import json
import re
import sqlite3
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[1]
INDEX_DIR = (
    REPO_ROOT
    / "skills"
    / "powerlit-power-systems-literature-intelligence"
    / "assets"
    / "powerlit-index"
)

VENUE_SHARDS = {
    "电力系统自动化": "venue_5fa2986a16a0.sqlite",
    "中国电机工程学报": "venue_cf71f77aed85.sqlite",
}

TERMS = "有效性|可行性|正确性|优越性|准确性"
HIT_PATTERN = re.compile(r"验证了[^。！？!?]*(?:" + TERMS + ")")
ABSTRACT_PATTERN = re.compile(r"摘\s*要[:：]\s*([\s\S]*?)(?:\n\s*关键词|\n\s*Abstract|\Z)")


def extract_abstract(content_head: str) -> str | None:
    match = ABSTRACT_PATTERN.search(content_head or "")
    return match.group(1).strip() if match else None


def split_sentences(text: str) -> list[str]:
    return [part.strip() for part in re.split(r"[。！？!?]", text) if part.strip()]


def measure_shard(shard_path: Path) -> dict:
    connection = sqlite3.connect(shard_path)
    heads = [row[0] or "" for row in connection.execute("select content_head from records")]
    connection.close()

    total = len(heads)
    abstracts_found = hits = closing_hits = 0
    for head in heads:
        abstract = extract_abstract(head)
        if abstract is None:
            continue
        abstracts_found += 1
        sentences = split_sentences(abstract)
        if any(HIT_PATTERN.search(sentence) for sentence in sentences):
            hits += 1
            if sentences and HIT_PATTERN.search(sentences[-1]):
                closing_hits += 1

    return {
        "records": total,
        "abstracts_extracted": abstracts_found,
        "hits": hits,
        "hit_rate_pct": round(100.0 * hits / total, 1) if total else 0.0,
        "closing_sentence_hits": closing_hits,
        "closing_share_of_hits_pct": round(100.0 * closing_hits / hits, 1) if hits else 0.0,
    }


def main() -> None:
    results = {}
    for venue, shard_name in VENUE_SHARDS.items():
        shard_path = INDEX_DIR / shard_name
        if not shard_path.exists():
            raise SystemExit(f"missing bundled index shard: {shard_path}")
        results[venue] = measure_shard(shard_path)
    print(json.dumps(results, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
