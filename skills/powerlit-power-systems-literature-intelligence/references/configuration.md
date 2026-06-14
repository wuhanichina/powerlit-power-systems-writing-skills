# PowerLit Configuration

PowerLit access is configurable. Resolve the JSON corpus root in this order:

1. User-provided path or script parameter.
2. `POWERLIT_JSON_ROOT`.
3. `POWERLIT_LOCAL_CACHE`.
4. `POWERLIT_LITERATURE_JSON`.
5. `\\WHome\PowerLit\literature\json`.

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

Lightweight search command:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\Search-PowerLitJson.ps1 `
  -Query "<technical query>" `
  -VenueFolder ieee_tsg `
  -Top 10
```

Use `-VenueFolder` for target-venue searches before widening. Use `-Top` to keep retrieval bounded.
