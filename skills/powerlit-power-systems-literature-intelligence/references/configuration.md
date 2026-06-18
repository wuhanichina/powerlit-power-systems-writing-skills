# PowerLit Configuration

PowerLit access is configurable. Resolve the JSON corpus root in this order:

1. User-provided path or script parameter.
2. `POWERLIT_JSON_ROOT`.
3. `POWERLIT_LITERATURE_JSON`.

Expected layout:

```text
<PowerLit JSON root>/
  ieee_tpwrs/
  ieee_tsg/
  中国电机工程学报/
  电力系统自动化/
  ...
```

Expected record fields include `doi`, `title`, `source_title`, and `content`. Some records may contain analysis files or different metadata. Use graceful field checks.

If the path is unavailable, run the caller skill in fallback mode. Do not stop manuscript writing, prewriting review, or review solely because PowerLit is unavailable.

## Local Search Index

For recurring PowerLit-backed applications, raw corpus search is not fast enough. Use the skill-bundled local SQLite FTS cache as the default retrieval path when it is present.

Index root resolution order:

1. Explicit index path supplied by script parameter.
2. `POWERLIT_INDEX_ROOT`.
3. Skill-bundled `assets/powerlit-index`.

Build or refresh the index:

```bash
python scripts/Build-PowerLitIndex.py --venue-folder ieee_tsg --venue-folder ieee_tpwrs
```

Search the index directly on macOS, Linux, or Windows:

```bash
python scripts/Search-PowerLitIndex.py \
  --query "<technical query>" \
  --venue-folder ieee_tsg \
  --top 10
```

The index stores compact metadata and content heads, not original PDFs. The literature skill carries `assets/powerlit-index/*.sqlite` plus `manifest.json` as the default convenience cache; temporary files, JSONL inspection dumps, and other cache build artifacts remain local.

## Search Commands

Windows-compatible public search command:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\Search-PowerLitJson.ps1 `
  -Query "<technical query>" `
  -VenueFolder ieee_tsg `
  -Top 10
```

`Search-PowerLitJson.ps1` uses the skill-bundled local index first when available and falls back to `rg` prefiltering over the raw corpus only when the index is missing or incomplete and a raw corpus root is explicitly configured. Use `-VenueFolder` or `--venue-folder` for target-venue searches before widening. Use `-Top` or `--top` to keep retrieval bounded.
