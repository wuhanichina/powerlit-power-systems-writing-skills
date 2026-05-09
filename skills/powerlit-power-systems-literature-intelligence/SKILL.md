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
4. Default LAN path: `\\WHome\PowerLit\literature\json`.

The resolved root must be a readable directory containing venue folders and `.json` paper records. Do not hard-code any other machine-specific path.

Use `scripts/Resolve-PowerLitJsonRoot.ps1` to check availability when shell access is available. Use `scripts/Search-PowerLitJson.ps1` for lightweight local retrieval.

## Access Policy

- If PowerLit is accessible, base novelty and citation judgments on retrieved papers.
- If PowerLit is inaccessible, say `PowerLit unavailable; using fallback non-corpus workflow` once, then continue.
- Never invent citations, DOIs, years, venues, or paper titles.
- Treat retrieval as evidence, not authority. A close paper still needs technical comparison.
- Prefer recent, venue-relevant, and technically adjacent papers over broad background papers.

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
   - literature coverage audit for manuscript review,
   - focused reading synthesis for a specific method or venue.

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
