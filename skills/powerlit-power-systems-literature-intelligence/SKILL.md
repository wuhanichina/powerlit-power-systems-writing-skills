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
3. Environment variable `POWERLIT_LOCAL_SUBSET`, for prompt-debugging subsets copied from the full corpus.
4. Environment variable `POWERLIT_LOCAL_CACHE`, for a local reusable cache.
5. Environment variable `POWERLIT_LITERATURE_JSON`.
6. Default LAN path: `\\WHome\PowerLit\literature\json`.

The resolved root must be a readable directory containing venue folders and `.json` paper records. Do not hard-code any other machine-specific path.

Use `scripts/Resolve-PowerLitJsonRoot.ps1` to check availability when shell access is available. Use `scripts/Search-PowerLitJson.ps1` for lightweight local retrieval. Use `scripts/Analyze-PowerLitEvidenceStrength.ps1` when the task asks what accepted papers write into the manuscript, what evidence strength passes review, or which evidence dimensions should be required before drafting. Use `scripts/Build-PowerLitLocalSubset.ps1` before repeated prompt debugging or benchmark runs when the LAN corpus is slow.

The search script interface is:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\Search-PowerLitJson.ps1 `
  -Query "<technical query>" `
  -VenueFolder ieee_tsg `
  -Top 10
```

`-VenueFolder` is optional but should be used when a target venue is known. `-Top` controls the number of returned records. The script returns JSON with access status, root path, query terms, match count, and ranked results containing title, source title, DOI, file path, matched terms, and a snippet.

For repeated prompt debugging, first build a local subset:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\Build-PowerLitLocalSubset.ps1 `
  -Query "<technical query>" `
  -VenueFolder ieee_tpwrs `
  -Top 100
```

Then set the emitted `POWERLIT_LOCAL_SUBSET` path in the current shell and run search or evidence-strength analysis against the local subset. The subset preserves venue-relative paths and writes `powerlit_subset_manifest.json` for auditability.

## Access Policy

- If PowerLit is accessible, base novelty and citation judgments on retrieved papers.
- For repeated prompt-debugging loops, prefer a local subset built from the needed venues and technical query over scanning the LAN corpus every run.
- If PowerLit is inaccessible, say `PowerLit unavailable; using fallback non-corpus workflow` once, then continue.
- Never invent citations, DOIs, years, venues, or paper titles.
- Treat retrieval as evidence, not authority. A close paper still needs technical comparison.
- Prefer recent, venue-relevant, and technically adjacent papers over broad background papers.
- Never copy long passages from retrieved JSON into a response. Summarize the paper's role, overlap, and citation function.

## Core Workflow

1. Resolve the PowerLit JSON root.
2. Translate the manuscript idea into search objects:
   - grid object,
   - operational or planning problem,
   - uncertainty/control/optimization mechanism,
   - mathematical object,
   - benchmark or evidence object,
   - likely venue.
3. Retrieve candidate papers:
   - start with target-venue folders when the target venue is known,
   - widen to TPWRS, TSG, CSEE, AEPS, MPCE, Applied Energy, Energy, IJEPES, and Power Grid Technology when needed,
   - keep the raw file paths for auditability.
4. Build a closest-competitor set. Do not select papers merely because they share one keyword; they must overlap in problem, mechanism, model, data, or evidence.
5. Produce the requested artifact:
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
