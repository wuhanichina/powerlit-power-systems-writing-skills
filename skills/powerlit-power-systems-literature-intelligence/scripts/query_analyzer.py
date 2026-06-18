#!/usr/bin/env python3
"""Domain-aware query analysis for PowerLit retrieval."""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path
from typing import Iterable


def skill_root() -> Path:
    return Path(__file__).resolve().parent.parent


def default_lexicon_path() -> Path:
    return skill_root() / "references" / "power-system-query-lexicon.json"


def load_lexicon(path: Path | None = None) -> dict:
    target = path or default_lexicon_path()
    if not target.is_file():
        return {"domain_abbreviations": {}, "phrase_aliases": {}, "cjk_keep_terms": [], "stopwords": []}
    return json.loads(target.read_text(encoding="utf-8"))


def unique_ordered(values: Iterable[str]) -> list[str]:
    result: list[str] = []
    seen: set[str] = set()
    for value in values:
        cleaned = re.sub(r"\s+", " ", value).strip()
        if not cleaned:
            continue
        key = cleaned.casefold()
        if key in seen:
            continue
        seen.add(key)
        result.append(cleaned)
    return result


def explicit_phrases(query: str) -> list[str]:
    phrases: list[str] = []
    patterns = (
        r'"([^"]+)"',
        r"'([^']+)'",
        r"\u201c([^\u201d]+)\u201d",
        r"\u300c([^\u300d]+)\u300d",
        r"\u300e([^\u300f]+)\u300f",
    )
    for pattern in patterns:
        for match in re.finditer(pattern, query):
            phrase = match.group(1)
            if phrase:
                phrases.append(phrase)
    return phrases


def cjk_ngrams(text: str) -> list[str]:
    grams: list[str] = []
    for seq in re.findall(r"[\u4e00-\u9fff]+", text):
        if 2 <= len(seq) <= 8:
            grams.append(seq)
        for n in (2, 3):
            if len(seq) >= n:
                grams.extend(seq[i : i + n] for i in range(0, len(seq) - n + 1))
    return grams


def technical_tokens(query: str, stopwords: set[str]) -> list[str]:
    tokens: list[str] = []
    # Keep abbreviations, N-1 terms, hyphenated method names, and formula-like compounds.
    for token in re.findall(r"[A-Za-z0-9]+(?:[+\-_/][A-Za-z0-9]+)*", query):
        cleaned = token.strip("-_/+")
        if not cleaned:
            continue
        if cleaned.casefold() in stopwords and not cleaned.isupper():
            continue
        tokens.append(cleaned)
    return tokens


def analyze_query(query: str, provided_terms: Iterable[str] | None = None, lexicon: dict | None = None) -> dict:
    lex = lexicon or load_lexicon()
    stopwords = {str(item).casefold() for item in lex.get("stopwords", [])}
    abbreviations = {str(key).upper(): [str(v) for v in values] for key, values in (lex.get("domain_abbreviations") or {}).items()}
    phrase_aliases = {str(key): [str(v) for v in values] for key, values in (lex.get("phrase_aliases") or {}).items()}
    cjk_keep_terms = [str(item) for item in lex.get("cjk_keep_terms", [])]

    phrases = explicit_phrases(query)
    if provided_terms:
        phrases.extend(str(term) for term in provided_terms if str(term).strip())

    tokens = technical_tokens(query, stopwords)
    cjk_terms = cjk_ngrams(query)
    cjk_terms.extend(term for term in cjk_keep_terms if term in query)

    expansions: list[str] = []
    for token in tokens:
        upper = token.upper()
        if upper in abbreviations:
            expansions.extend(abbreviations[upper])
    query_cf = query.casefold()
    for phrase, aliases in phrase_aliases.items():
        if phrase.casefold() in query_cf:
            expansions.extend(aliases)
        for alias in aliases:
            if alias.casefold() in query_cf:
                expansions.append(phrase)

    terms = unique_ordered([*phrases, *tokens, *cjk_terms, *expansions])
    return {
        "query": query,
        "phrases": unique_ordered(phrases),
        "tokens": unique_ordered(tokens),
        "cjk_terms": unique_ordered(cjk_terms),
        "expansions": unique_ordered(expansions),
        "terms": terms or ([query] if query else []),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description="Analyze a PowerLit retrieval query.")
    parser.add_argument("--query", required=True)
    parser.add_argument("--terms", nargs="*", default=[])
    args = parser.parse_args()
    print(json.dumps(analyze_query(args.query, args.terms), ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
