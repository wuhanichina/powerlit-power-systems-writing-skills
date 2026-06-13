# Corpus-Grounded Drafting

Use this reference whenever a task needs introduction writing, related-work synthesis, novelty framing, citation planning, or venue adaptation. The repository's advantage is not generic academic style; it is access to a real PowerLit corpus and venue-specific structure signals.

## Access Gate

Resolve PowerLit through `powerlit-power-systems-literature-intelligence`:

1. User-supplied path.
2. `POWERLIT_JSON_ROOT`.
3. `POWERLIT_LITERATURE_JSON`.
4. `\\WHome\PowerLit\literature\json`.

If the corpus is accessible, use it before drafting citation-sensitive prose. If it is not accessible, state `PowerLit unavailable; using fallback non-corpus workflow` once and continue only with supplied references, citation slots, or literature-limited wording.

## Search Contract

When shell access is available, the lightweight retrieval interface is:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File `
  skills\powerlit-power-systems-literature-intelligence\scripts\Search-PowerLitJson.ps1 `
  -Query "<technical query>" `
  -VenueFolder ieee_tsg `
  -Top 10
```

Use `-VenueFolder` when the target venue is known. Valid top-level venue folders in the current corpus include `ieee_tsg`, `ieee_tpwrs`, `中国电机工程学报`, `电力系统自动化`, `mpce`, `ijepes`, `applied_energy`, `energy`, `ieee_tpwrd`, and `电网技术`. Widen only after the target-venue search is too sparse or the problem is cross-venue.

## Writing-Time Corpus Reference

PowerLit is not only for citation lookup. When the task asks for writing, rewriting, venue adaptation, or "make it read like TSG/TPWRS/CSEE/AEPS", use retrieved venue-near papers as writing references:

- section order: where the venue usually places problem formulation, method, algorithm, case study, and conclusion;
- paragraph function: what each paragraph does in the introduction, method transition, evidence discussion, and conclusion;
- sentence rhythm: how long technical sentences are, what becomes the grammatical subject, and how contrast markers are used;
- contribution placement: whether the venue expects explicit contribution bullets, technical-action sentences, or compact proposal paragraphs;
- evidence presentation: how systems, baselines, metrics, solver settings, sensitivity checks, and limitations are stated;
- boundary language: how the paper states what was demonstrated and what remains outside scope.

Use 3 to 5 retrieved exemplars when possible. Prefer papers from the target venue and similar technical object. If exact matches are sparse, use one or two mechanism-near papers plus the static venue profile.

Do not copy sentences, phrases, abstracts, or paragraph templates from the corpus. Extract functions and patterns, then write new prose around the current manuscript's own model, variables, results, and claim boundary.

## Reconstruction Benchmark Use

For skill maintenance, PowerLit papers may also be used as masked reconstruction benchmarks. In that mode, follow `published-paper-reconstruction.md`: extract an evidence packet from an accepted paper, hide the original prose, draft from evidence facts only, and let the review skill judge the review-strength delta.

Do not treat a paper's case-analysis data as enough for full-paper reconstruction. Case data can benchmark result-section writing only unless the evidence packet also includes the method object, assumptions, variables, baselines, metrics, protocol, and conclusion boundary.

## Required Internal Artifacts

Before drafting a citation-sensitive section, build these internal artifacts:

- `Venue profile`: target venue, expected paper object, introduction rhythm, method depth, evidence bar, and register.
- `Closest competitors`: papers overlapping in problem, mechanism, model, data, or evidence. Do not select papers merely because they share a keyword.
- `Corpus style exemplars`: venue-near papers used for section shape, paragraph function, rhythm, evidence presentation, and boundary language. Keep this as internal guidance unless the user asks for a style audit.
- `Citation-to-sentence plan`: each citation supports one sentence-level function: background, method family, limitation, closest contrast, or evidence precedent.
- `Claim boundary`: what the paper may claim after comparison, and what it must not claim.
- `Gap-to-contribution-to-evidence map`: every kept gap motivates one deliverable, and every deliverable has a result, derivation, theorem, or stated assumption.

These artifacts are usually not shown to the user unless the user asks for planning, review, or citation strategy. They must not leak into final manuscript prose as labels.

## Drafting Discipline

Use retrieved papers as evidence, not as decoration.

- Background citations support the system need.
- Method-family citations define the existing routes.
- Gap citations expose the unresolved limitation.
- Closest-competitor citations anchor the direct contrast.
- Evidence-precedent citations justify benchmark choice, data protocol, scenario design, or metric choice.

Do not use a paper as a closest competitor unless it overlaps with the current manuscript in at least two of these dimensions: problem, mechanism, model, data, evidence object, or venue claim.

## Manuscript Boundary

Final manuscript prose may contain normal citation sentences, but it must not contain internal audit language such as:

- "closest competitor";
- "claim boundary";
- "citation pack";
- "corpus style exemplar";
- "PowerLit evidence";
- "gap-to-contribution map";
- "fallback mode".

Replace internal labels with ordinary manuscript logic. For example, "closest competitor" becomes a direct literature sentence about what a named method does and what it leaves unresolved.

## Failure Modes

- If retrieval returns broad topical papers only, write background cautiously and keep novelty language narrow.
- If retrieval finds a paper that covers the same problem, mechanism, and evidence object, stop polishing and narrow the claim, change the technical object, or recommend retargeting.
- If the user supplies references that conflict with PowerLit retrieval, state the conflict in a short note and keep manuscript claims bounded.
- If JSON records are malformed or unreadable, skip those records and cite the retrieval limitation rather than filling the gap from memory.
