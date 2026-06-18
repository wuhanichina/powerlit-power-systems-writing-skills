---
name: powerlit-power-systems-literature-intelligence
description: Retrieve and synthesize nearby power-system papers from a configurable local PowerLit JSON corpus for novelty checks, closest-competitor analysis, citation packs, introduction support, and review coverage audits. Use when PowerLit literature access, citation evidence, or corpus-backed innovation judgment is requested.
---
# PowerLit Power-Systems Literature Intelligence

## Purpose

Use this skill when a writing, prewriting, or review task needs evidence from the user's PowerLit corpus.

The skill is optional by design. If the PowerLit corpus is accessible, use it aggressively. If it is not accessible, report that the task is running in fallback mode and continue with the original non-corpus writing, prewriting, or review workflow.

## Configuration

Resolve the PowerLit JSON root in this order:

1. Explicit path supplied by the user or command parameter.
2. Environment variable `POWERLIT_JSON_ROOT`.
3. Environment variable `POWERLIT_LITERATURE_JSON`.

The resolved root must be a readable directory containing venue folders and `.json` paper records. There is no machine-specific default raw-corpus path.

Fast retrieval is mandatory for PowerLit-backed workflows. Prefer the skill-bundled local SQLite FTS cache when it exists:

1. Explicit index path supplied by script parameter.
2. `POWERLIT_INDEX_ROOT`.
3. Skill-bundled `assets/powerlit-index`.

Use `scripts/Build-PowerLitIndex.py` to build or refresh the local index. Use `scripts/Search-PowerLitIndex.py` for direct cross-platform indexed retrieval. On Windows, `scripts/Search-PowerLitJson.ps1` is still the public search entry and automatically uses the skill-bundled cache first; it falls back to `rg` prefiltering and raw JSON parsing only when the index is missing or incomplete and a raw corpus root is explicitly configured. Use `scripts/Resolve-PowerLitJsonRoot.ps1` to check corpus availability when shell access is available. Use `scripts/Analyze-PowerLitEvidenceStrength.ps1` when the task asks what accepted papers write into the manuscript, what evidence strength passes review, or which evidence dimensions should be required before drafting.

When the task maps to a known direction or method family, consult `references/method-canon.json` before broad retrieval. The method canon is a quality anchor for method families and evidence bars; it is not a substitute for a final main-corpus novelty search.

The search script interface is:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\Search-PowerLitJson.ps1 `
  -Query "<technical query>" `
  -VenueFolder ieee_tsg `
  -Top 10
```

Cross-platform indexed interface:

```bash
python scripts/Search-PowerLitIndex.py \
  --query "<technical query>" \
  --venue-folder ieee_tsg \
  --top 10
```

Index build interface:

```bash
python scripts/Build-PowerLitIndex.py --venue-folder ieee_tsg --venue-folder ieee_tpwrs
```

`-VenueFolder` or `--venue-folder` is optional but should be used when a target venue is known. `-Top` or `--top` controls the number of returned records. The script returns JSON with access status, root path, query terms, candidate source, candidate count, parsed count, elapsed milliseconds, match count, and ranked results containing title, title source, source title, DOI, file path, matched terms, and a snippet. `candidate_source=powerlit_index_sqlite` is the normal fast path. `candidate_source=rg` is a fallback path and should trigger index build/refresh when repeated workflows depend on PowerLit.

## Access Policy

- If PowerLit is accessible, base novelty and citation judgments on retrieved papers.
- Use the method canon as a stable benchmark set, then use the main corpus for current nearest-neighbor retrieval.
- Legal citation sources are user-supplied references, PowerLit retrieval results, and method-canon entries whose `metadata_verification.status` is `verified` and whose `curation_status` is `accepted`.
- For `powerlit_status=in_corpus`, use the PowerLit record or `.cache/powerlit-method-canon/` copy for citation, evidence-bar pattern extraction, and corpus style/structure signals. Do not copy source wording.
- For `powerlit_status=out_of_corpus`, use only bibliographic identity and method-family positioning. Do not summarize method details, evidence patterns, results, or prose style unless the paper text is separately supplied or retrieved.
- Entries marked `pending`, `candidate`, or needing title/DOI verification must not be cited in manuscript prose and must not be used as evidence-bar exemplars.
- If PowerLit is inaccessible, say `PowerLit unavailable; using fallback non-corpus workflow` once, then continue.
- Never invent citations, DOIs, years, venues, or paper titles.
- Treat retrieval as evidence, not authority. A close paper still needs technical comparison.
- Prefer recent, venue-relevant, and technically adjacent papers over broad background papers.
- Never copy long passages from retrieved JSON into a response. Summarize the paper's role, overlap, and citation function.

## Core Workflow

1. Resolve the PowerLit JSON root.
2. Translate the manuscript idea into method-canon and search objects:
   - grid object,
   - operational or planning problem,
   - uncertainty/control/optimization mechanism,
   - mathematical object,
   - benchmark or evidence object,
   - likely venue.
3. Read relevant verified method-canon entries when available, respecting `usage_policy`.
4. Retrieve candidate papers from the main PowerLit corpus:
   - use the skill-bundled local PowerLit index first; build or refresh it if repeated queries are expected and the cache is missing or stale,
   - start with target-venue folders when the target venue is known,
   - widen to TPWRS, TSG, CSEE, AEPS, MPCE, Applied Energy, Energy, IJEPES, and Power Grid Technology when needed,
   - keep the raw file paths for auditability.
5. Build a closest-competitor set. Do not select papers merely because they share one keyword; they must overlap in problem, mechanism, model, data, or evidence.
6. Produce the requested artifact:
   - novelty pack for prewriting review,
   - citation pack for introduction writing,
   - corpus style exemplar pack for venue-specific writing,
   - evidence-strength profile for score-targeted writing or review calibration,
   - literature coverage audit for manuscript review,
   - focused reading synthesis for a specific method or venue.

## Venue Folder Hints

When the target venue is known, search that venue first:

- IEEE TSG: `ieee_tsg`
- IEEE TPWRS: `ieee_tpwrs`
- 中国电机工程学报: `中国电机工程学报`
- 电力系统自动化: `电力系统自动化`

Widen to MPCE, IJEPES, Applied Energy, Energy, IEEE TPWRD, Power Grid Technology, or other available folders only after the target-venue search is sparse or the technical object is cross-venue.

## Output Artifacts

For prewriting review, produce:

- `PowerLit access`: resolved path or fallback mode.
- `Closest competitors`: title, venue, DOI/path, problem, method, evidence, overlap with the current paper.
- `Novelty threat`: high, medium, low, or unknown.
- `Innovation boundary`: what can still be claimed after comparison.
- `Required repairs`: missing baselines, missing citations, unclear distinction, or insufficient evidence.

For introduction writing, produce:

- `Background citations`: papers supporting the engineering context.
- `Method-family citations`: papers representing existing technical routes.
- `Gap citations`: papers that expose the limitation the manuscript must resolve.
- `Closest-competitor citations`: papers that must be contrasted directly.
- `Citation-to-sentence plan`: which claim each citation supports.

For writing-style reference, produce:

- `Venue exemplars`: 3 to 5 retrieved papers, with path or DOI.
- `Section-shape signals`: how the target venue organizes introduction, method, case study, and conclusion.
- `Paragraph-function signals`: how paragraphs move from object to limitation to contribution to evidence.
- `Rhythm and register signals`: sentence subjects, contrast markers, contribution placement, and evidence wording.
- `Do-not-copy boundary`: a reminder to use corpus patterns only, not source wording.

For evidence-strength learning, produce:

- `Accepted-paper sample`: 3 to 5 venue-near and mechanism-near papers with DOI/path.
- `Manuscript-facing quantities`: systems, data, scenarios, baselines, metrics, solver/runtime, sensitivity, ablation, boundary/failure cases, and reproducibility details visible in the accepted papers.
- `Evidence-depth pattern`: how many independent evidence dimensions the accepted papers use to support the claim class.
- `Claim-boundary pattern`: how accepted papers state limitations or complementary value without defensive posture.
- `Current-manuscript implication`: evidence dimensions that must be added, downgraded, relabeled, or moved into the manuscript before a high-score draft can be claimed.

For review, produce:

- `Coverage audit`: important nearby papers that are absent or under-discussed.
- `Novelty risk`: whether the claimed contribution is already covered.
- `Citation risk`: missing, stale, weak, or misused references.
- `Reviewer action`: accept the cited boundary, require revision, or reject/retarget due to weak novelty.

## Retrieval Discipline

- Search both titles and body content.
- Keep duplicates under control by DOI and normalized title.
- Prefer exact mechanism matches over broad topical matches.
- Use negative evidence: if a nearby paper already solves the same core object, narrow or reject the current claim.
- Cite file paths or DOI identifiers in intermediate artifacts so the result can be traced.

## Fallback Discipline

When PowerLit is unavailable:

- keep using `powerlit-power-systems-prewriting-review`, `powerlit-power-systems-paper-writing`, `ieee-power-engineering-letter-writing`, or `powerlit-power-systems-paper-review`;
- mark novelty and citation judgments as literature-limited;
- do not create fake citation packs;
- ask for supplied references only if the task cannot proceed without any literature evidence.
