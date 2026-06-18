#!/usr/bin/env python3
"""Shared helpers for portable PowerLit indexes and retrieval."""

from __future__ import annotations

import hashlib
import json
import os
import re
import unicodedata
from pathlib import Path
from typing import Any, Iterable, Optional

DEFAULT_CONTENT_CHARS = 120_000
_CJK_RE = re.compile(r"[\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff]+")
_LATIN_TOKEN_RE = re.compile(r"[A-Za-z0-9]+(?:[+./_-][A-Za-z0-9]+)*")


def script_dir() -> Path:
    return Path(__file__).resolve().parent


def skill_dir() -> Path:
    return script_dir().parent


def repo_root() -> Path:
    """Return the development repository root when this skill is in a checkout."""
    return skill_dir().parents[1]


def codex_home() -> Path:
    return Path(os.environ.get("CODEX_HOME", Path.home() / ".codex")).expanduser()


def bundled_index_dir() -> Path:
    return skill_dir() / "assets" / "powerlit-index"


def managed_index_dir() -> Path:
    return codex_home() / "powerlit" / "powerlit-index"


def _valid_json_root(path: Path) -> bool:
    if not path.is_dir():
        return False
    try:
        if any(path.glob("*.json")):
            return True
        return any(
            child.is_dir() and any(child.glob("*.json")) for child in path.iterdir()
        )
    except OSError:
        return False


def resolve_json_root(explicit: Optional[str] = None) -> Optional[Path]:
    """Resolve an optional raw corpus root without machine-specific defaults."""
    candidates: list[str] = []
    if explicit:
        candidates.append(explicit)
    for name in ("POWERLIT_JSON_ROOT", "POWERLIT_LITERATURE_JSON"):
        value = os.environ.get(name)
        if value:
            candidates.append(value)

    seen: set[str] = set()
    for candidate in candidates:
        path = Path(candidate).expanduser()
        key = os.path.normcase(str(path.resolve(strict=False)))
        if key in seen:
            continue
        seen.add(key)
        if _valid_json_root(path):
            return path.resolve()
    return None


def _valid_index_dir(path: Path) -> bool:
    if not path.is_dir():
        return False
    return (
        (path / "manifest.json").is_file()
        or any(path.glob("*.sqlite"))
        or any(path.glob("*.jsonl"))
    )


def resolve_index_dir(
    explicit: Optional[str] = None, create: bool = False
) -> Optional[Path]:
    """Resolve a portable cache.

    Read order: explicit path, POWERLIT_INDEX_ROOT, managed CODEX_HOME cache,
    then the cache bundled inside this installable skill. Build operations write
    to the first explicit/environment/managed location and never mutate bundled
    assets implicitly.
    """
    candidates: list[Path] = []
    if explicit:
        candidates.append(Path(explicit).expanduser())
    env_index = os.environ.get("POWERLIT_INDEX_ROOT")
    if env_index:
        candidates.append(Path(env_index).expanduser())
    candidates.append(managed_index_dir())
    candidates.append(bundled_index_dir())

    if create:
        destination = candidates[0] if explicit or env_index else managed_index_dir()
        destination.mkdir(parents=True, exist_ok=True)
        return destination.resolve()

    seen: set[str] = set()
    for path in candidates:
        key = os.path.normcase(str(path.resolve(strict=False)))
        if key in seen:
            continue
        seen.add(key)
        if _valid_index_dir(path):
            return path.resolve()
    return None


def load_json(path: Path) -> Optional[dict[str, Any]]:
    try:
        with path.open("r", encoding="utf-8") as handle:
            item = json.load(handle)
        return item if isinstance(item, dict) else None
    except (OSError, ValueError, TypeError):
        return None


def _load_reference_json(name: str) -> dict[str, Any]:
    return load_json(skill_dir() / "references" / name) or {}


def venue_alias_map() -> dict[str, str]:
    registry = _load_reference_json("venue-registry.json")
    result: dict[str, str] = {}
    for key, entry in (registry.get("venues") or {}).items():
        canonical = str(entry.get("canonical") or key)
        result[canonical.casefold()] = canonical
        for alias in entry.get("aliases") or []:
            result[str(alias).casefold()] = canonical
    return result


def canonicalize_venue(value: str) -> Optional[str]:
    value = (value or "").strip()
    if not value:
        return None
    return venue_alias_map().get(value.casefold())


def query_lexicon() -> tuple[dict[str, list[str]], set[str]]:
    item = _load_reference_json("power-system-query-lexicon.json")
    expansions = {
        str(key).casefold(): [str(v) for v in values if str(v).strip()]
        for key, values in (item.get("expansions") or {}).items()
    }
    protected = {
        str(value).casefold() for value in item.get("protected_tokens") or []
    }
    return expansions, protected


def cjk_ngrams(value: str, sizes: tuple[int, ...] = (2, 3)) -> list[str]:
    result: list[str] = []
    for sequence in _CJK_RE.findall(value):
        if sequence:
            result.append(sequence)
        for size in sizes:
            if len(sequence) < size:
                continue
            result.extend(
                sequence[index : index + size]
                for index in range(len(sequence) - size + 1)
            )
    return result


def analyze_query(
    query: str,
    provided_terms: Optional[Iterable[str]] = None,
    *,
    expand: bool = True,
) -> dict[str, list[str]]:
    """Analyze mixed Chinese/English queries without dropping domain acronyms."""
    expansions, protected = query_lexicon()
    source_terms = [
        str(term).strip() for term in provided_terms or [] if str(term).strip()
    ]
    if not source_terms:
        source_terms = _LATIN_TOKEN_RE.findall(query)
        source_terms.extend(_CJK_RE.findall(query))

    exact: list[str] = []
    expanded: list[str] = []
    ngrams: list[str] = cjk_ngrams(query)

    for term in source_terms:
        cleaned = unicodedata.normalize("NFKC", term).strip()
        if not cleaned:
            continue
        folded = cleaned.casefold()
        is_cjk = bool(_CJK_RE.fullmatch(cleaned))
        if is_cjk or len(cleaned) >= 2 or folded in protected:
            exact.append(cleaned)
        if expand:
            expanded.extend(expansions.get(folded, []))

    def unique(values: Iterable[str]) -> list[str]:
        seen: set[str] = set()
        result: list[str] = []
        for value in values:
            value = unicodedata.normalize("NFKC", str(value)).strip()
            key = value.casefold()
            if value and key not in seen:
                seen.add(key)
                result.append(value)
        return result

    exact = unique(exact)
    expanded = unique(expanded)
    exact_keys = {item.casefold() for item in exact}
    ngrams = [item for item in unique(ngrams) if item.casefold() not in exact_keys]
    return {
        "exact_terms": exact,
        "expanded_terms": expanded,
        "cjk_ngrams": ngrams,
    }


def normalize_terms(
    query: str, provided_terms: Optional[Iterable[str]] = None
) -> list[str]:
    """Compatibility wrapper used by legacy callers."""
    analyzed = analyze_query(query, provided_terms)
    return analyzed["exact_terms"] + analyzed["expanded_terms"]


def normalize_title(value: str) -> str:
    value = unicodedata.normalize("NFKC", value or "").casefold()
    value = re.sub(r"[^\w\u3400-\u9fff]+", " ", value, flags=re.UNICODE)
    return re.sub(r"\s+", " ", value).strip()


def normalize_doi(value: str) -> str:
    value = (value or "").strip().casefold()
    value = re.sub(r"^(?:https?://(?:dx\.)?doi\.org/|doi:\s*)", "", value)
    return value.rstrip(".,; ")


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


def get_snippet(text: str, terms: Iterable[str], *, width: int = 460) -> str:
    if not text:
        return ""
    compact = re.sub(r"\s+", " ", text).strip()
    folded = compact.casefold()
    for term in terms:
        pos = folded.find(str(term).casefold())
        if pos >= 0:
            start = max(0, pos - 150)
            return compact[start : start + width]
    return compact[: min(width, len(compact))]


def weak_title(title: str, source_title: str) -> bool:
    normalized_title = normalize_title(title)
    normalized_source = normalize_title(source_title)
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
    head = content[:12_000]
    for line in head.splitlines()[:80]:
        candidate = re.sub(r"^\s*#+\s*", "", line)
        candidate = re.sub(r"^\s*[-*]\s*", "", candidate)
        candidate = re.sub(r"\s+", " ", candidate).strip()
        if len(candidate) < 8 or len(candidate) > 220:
            continue
        if re.match(
            r"^(abstract|index terms|keywords|introduction|references|doi\b|copyright\b)",
            candidate,
            re.I,
        ):
            continue
        if re.match(
            r"^(ieee transactions|ieee trans\.|vol\.|volume\b|no\.|arxiv\b)",
            candidate,
            re.I,
        ):
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
    raw = value.strip()
    cleaned = re.sub(r"[^A-Za-z0-9._-]+", "_", raw).strip("._")
    if cleaned and cleaned != "_":
        return cleaned
    digest = hashlib.sha1(raw.encode("utf-8")).hexdigest()[:12]
    return f"venue_{digest}" if digest else "root"


def _stringify(value: Any) -> str:
    if value is None:
        return ""
    if isinstance(value, list):
        parts: list[str] = []
        for item in value:
            if isinstance(item, dict):
                parts.append(str(item.get("name") or item.get("family") or item))
            else:
                parts.append(str(item))
        return "; ".join(part for part in parts if part)
    return str(value)


def extract_sections(content: str) -> dict[str, str]:
    """Extract coarse sections from Markdown-like paper text."""
    sections = {
        "abstract": "",
        "introduction": "",
        "method": "",
        "results": "",
        "conclusion": "",
    }
    if not content:
        return sections

    heading_re = re.compile(
        r"(?m)^\s*(?:#{1,6}\s*)?(?:[IVXLC]+\.?|\d+(?:\.\d+)*)?\s*([^\n]{2,120})\s*$"
    )
    matches = list(heading_re.finditer(content))
    for index, match in enumerate(matches):
        heading = normalize_title(match.group(1))
        start = match.end()
        end = matches[index + 1].start() if index + 1 < len(matches) else len(content)
        body = content[start:end].strip()
        if not body:
            continue
        if heading.startswith(("abstract", "摘要")):
            sections["abstract"] += "\n" + body
        elif "introduction" in heading or heading.startswith(("引言", "绪论")):
            sections["introduction"] += "\n" + body
        elif any(
            token in heading
            for token in (
                "method",
                "model",
                "formulation",
                "algorithm",
                "方法",
                "模型",
                "建模",
                "求解",
            )
        ):
            sections["method"] += "\n" + body
        elif any(
            token in heading
            for token in (
                "result",
                "case study",
                "simulation",
                "experiment",
                "算例",
                "结果",
                "仿真",
                "实验",
            )
        ):
            sections["results"] += "\n" + body
        elif any(
            token in heading
            for token in ("conclusion", "discussion", "结论", "讨论")
        ):
            sections["conclusion"] += "\n" + body

    return {key: value.strip() for key, value in sections.items()}


def make_index_record(
    path: Path,
    root: Path,
    venue_folder: str,
    content_chars: int = DEFAULT_CONTENT_CHARS,
) -> Optional[dict[str, Any]]:
    record = load_json(path)
    if not record:
        return None

    content = _stringify(record.get("content"))[: max(content_chars, 2_000)]
    source_title = _stringify(record.get("source_title"))
    title = _stringify(record.get("title"))
    title_source = "record"
    if weak_title(title, source_title):
        recovered = title_from_content_head(content)
        if recovered:
            title = recovered
            title_source = "content_head"

    sections = extract_sections(content)
    abstract = _stringify(record.get("abstract")) or sections["abstract"]
    keywords = _stringify(record.get("keywords") or record.get("index_terms"))
    authors = _stringify(record.get("authors") or record.get("author"))
    document_type = _stringify(
        record.get("document_type") or record.get("paper_type")
    )

    try:
        relative_path = str(path.resolve().relative_to(root.resolve()))
    except ValueError:
        relative_path = path.name
    relative_path = relative_path.replace(os.sep, "/")

    stat = path.stat()
    doi = normalize_doi(_stringify(record.get("doi")))
    record_key = doi or normalize_title(title) or relative_path.casefold()
    return {
        "schema_version": 2,
        "record_key": record_key,
        "venue_folder": venue_folder,
        "relative_path": relative_path,
        "title": title,
        "normalized_title": normalize_title(title),
        "title_source": title_source,
        "source_title": source_title,
        "authors": authors,
        "doi": doi,
        "year": record.get("year"),
        "document_type": document_type,
        "abstract": abstract,
        "keywords": keywords,
        "introduction": sections["introduction"],
        "method": sections["method"],
        "results": sections["results"],
        "conclusion": sections["conclusion"],
        "content": content,
        "size_bytes": stat.st_size,
        "mtime": int(stat.st_mtime),
    }
