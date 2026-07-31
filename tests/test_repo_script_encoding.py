"""Windows PowerShell 5.1 parses BOM-less UTF-8 .ps1 files as ANSI, which
corrupts non-ASCII string literals at parse time. Every .ps1 in the repository
that contains non-ASCII content must therefore carry a UTF-8 BOM."""

from __future__ import annotations

from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[1]
UTF8_BOM = b"\xef\xbb\xbf"
EXCLUDED_PARTS = {".git", "__pycache__", ".pytest_cache", ".venv", "venv"}


def _repo_ps1_files() -> list[Path]:
    return [
        p
        for p in REPO_ROOT.rglob("*.ps1")
        if not EXCLUDED_PARTS.intersection(p.relative_to(REPO_ROOT).parts)
    ]


def test_ps1_files_exist() -> None:
    assert _repo_ps1_files(), "expected at least one .ps1 script in the repository"


def test_non_ascii_ps1_files_have_utf8_bom() -> None:
    offenders = []
    for path in _repo_ps1_files():
        data = path.read_bytes()
        has_non_ascii = any(byte > 127 for byte in data)
        if has_non_ascii and not data.startswith(UTF8_BOM):
            offenders.append(str(path.relative_to(REPO_ROOT)))
    assert not offenders, (
        "non-ASCII .ps1 files must be saved as UTF-8 with BOM for "
        f"Windows PowerShell 5.1: {offenders}"
    )


def test_ps1_files_decode_as_utf8() -> None:
    for path in _repo_ps1_files():
        path.read_bytes().decode("utf-8-sig")
