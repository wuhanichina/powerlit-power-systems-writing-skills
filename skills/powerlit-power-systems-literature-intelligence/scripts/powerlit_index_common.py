#!/usr/bin/env python3
"""Shared helpers for local PowerLit search indexes."""

from __future__ import annotations

import json
import os
import re
from pathlib import Path
from typing import Iterable, Optional


DEFAULT_LAN_ROOT = r"\\WHome\PowerLit\literature\json"
DEFAULT_HEAD_CHARS = 8000


def script_dir() -> Path:
    return Path(__file__).resolve().parent


def repo_root() -> Path:
    return script_dir().parents[2]


def resolve_json_root(explicit: Optional[str] = None) -> Optional[Path]:
    candidates: list[str] = []
    if explicit:
        candidates.append(explicit)
    for name in ("POWERLIT_JSON_ROOT", "POWERLIT_LOCAL_CACHE", "POWERLIT_LITERATURE_JSON"):
        value = os.environ.get(name)
        if value:
            candidates.append(value)
    candidates.append(DEFAULT_LAN_ROOT)

    seen: set[str] = set()
    for candidate in candidates:
        key = candidate.lower()
        if key in seen:
            continue
        seen.add(key)
        path = Path(candidate)
        if path.is_dir():
            return path.resolve()
    return None


def resolve_index_dir(explicit: Optional[str] = None, create: bool = False) -> Optional[Path]:
    candidates: list[Path] = []
    if explicit:
        candidates.append(Path(explicit))

    env_index = os.environ.get("POWERLIT_INDEX_ROOT")
    if env_index:
        candidates.append(Path(env_index))

    local_cache = os.environ.get("POWERLIT_LOCAL_CACHE")
    if local_cache:
        candidates.append(Path(local_cache) / "powerlit-index")

    candidates.append(repo_root() / ".cache" / "powerlit-index")

    for path in candidates:
        if create:
            path.mkdir(parents=True, exist_ok=True)
            return path.resolve()
        if path.is_dir() and ((path / "manifest.json").is_file() or any(path.glob("*.sqlite")) or any(path.glob("*.jsonl"))):
            return path.resolve()
    return None


def normalize_terms(query: str, provided_terms: Optional[Iterable[str]] = None) -> list[str]:
    result: list[str] = []
    if provided_terms:
        for term in provided_terms:
            cleaned = term.strip()
            if cleaned:
                result.append(cleaned)
    if not result:
        for part in re.split(r"[^\w+\-]+", query, flags=re.UNICODE):
            cleaned = part.strip()
            if len(cleaned) >= 3:
                result.append(cleaned)

    unique: list[str] = []
    seen: set[str] = set()
    for term in result:
        key = term.casefold()
        if key not in seen:
            seen.add(key)
            unique.append(term)
    return unique or ([query] if query else [])


def count_contains(text: str, term: str, limit: int = 20) -> int:
    if not text or not term:
        return 0
    text_cf = text.casefold()
    term_cf = term.casefold()
    count = 0
    start = 0
    while count < limit:
        found = text_cf.find(term_cf, start)
        if found < 0:
            break
        count += 1
        start = found + max(len(term_cf), 1)
    return count


def get_snippet(text: str, terms: Iterable[str]) -> str:
    if not text:
        return ""
    text_cf = text.casefold()
    for term in terms:
        pos = text_cf.find(term.casefold())
        if pos >= 0:
            start = max(0, pos - 140)
            return re.sub(r"\s+", " ", text[start : start + 420]).strip()
    return re.sub(r"\s+", " ", text[:300]).strip()


def weak_title(title: str, source_title: str) -> bool:
    normalized_title = re.sub(r"\s+", " ", title or "").strip().casefold()
    normalized_source = re.sub(r"\s+", " ", source_title or "").strip().casefold()
    if len(normalized_title) < 8:
        return True
    if normalized_source and normalized_title == normalized_source:
        return True
    return bool(
        re.match(
            r"^(ieee transactions|proceedings|journal|transactions on|power systems|smart grid)",
            normalized_title,
        )
    )


def title_from_content_head(content: str) -> Optional[str]:
    if not content:
        return None
    head = content[:12000]
    for line in head.splitlines()[:80]:
        candidate = re.sub(r"^\s*#+\s*", "", line)
        candidate = re.sub(r"^\s*[-*]\s*", "", candidate)
        candidate = re.sub(r"\s+", " ", candidate).strip()
        if len(candidate) < 8 or len(candidate) > 220:
            continue
        if re.match(r"^(abstract|index terms|keywords|introduction|references|doi\b|copyright\b)", candidate, re.I):
            continue
        if re.match(r"^(ieee transactions|ieee trans\.|vol\.|volume\b|no\.|arxiv\b)", candidate, re.I):
            continue
        if re.match(r"^[0-9\s,.;:()/-]+$", candidate):
            continue
        if not re.search(r"[^\W\d_]", candidate, re.UNICODE):
            continue
        return candidate
    return None


def iter_json_files(root: Path, include_analysis: bool = False) -> Iterable[Path]:
    for path in root.rglob("*.json"):
        if not include_analysis and path.name.endswith("-analysis.json"):
            continue
        yield path


def safe_name(value: str) -> str:
    cleaned = re.sub(r"[^A-Za-z0-9._-]+", "_", value.strip())
    return cleaned.strip("._") or "root"


def load_json(path: Path) -> Optional[dict]:
    try:
        with path.open("r", encoding="utf-8") as handle:
            return json.load(handle)
    except Exception:
        return None


def make_index_record(path: Path, root: Path, venue_folder: str, head_chars: int = DEFAULT_HEAD_CHARS) -> Optional[dict]:
    record = load_json(path)
    if not record:
        return None

    content = str(record.get("content") or "")
    content_head = content[:head_chars]
    source_title = str(record.get("source_title") or "")
    title = str(record.get("title") or "")
    title_source = "record"
    if weak_title(title, source_title):
        recovered = title_from_content_head(content_head)
        if recovered:
            title = recovered
            title_source = "content_head"

    try:
        relative_path = str(path.resolve().relative_to(root.resolve()))
    except ValueError:
        relative_path = str(path)

    stat = path.stat()
    return {
        "schema_version": 1,
        "venue_folder": venue_folder,
        "relative_path": relative_path.replace(os.sep, "/"),
        "path": str(path.resolve()),
        "title": title,
        "title_source": title_source,
        "source_title": source_title,
        "doi": str(record.get("doi") or ""),
        "year": record.get("year"),
        "content_head": content_head,
        "size_bytes": stat.st_size,
        "mtime": int(stat.st_mtime),
    }
