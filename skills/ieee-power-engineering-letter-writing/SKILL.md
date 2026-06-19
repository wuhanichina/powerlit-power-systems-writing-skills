---
name: ieee-power-engineering-letter-writing
description: Write, rewrite, or revise IEEE power-system Letters such as IEEE Power Engineering Letters and TPWRS/TSG short Letters under the official IEEE PES Letter page-budget rules. Use for letter abstracts, introductions, compact formulations, counterexample/analytical notes, case-study compression, reviewer-comment revision, and anti-full-paper cleanup.
---
# IEEE Power Engineering Letter Writing

## Purpose

Use this skill when the target is an IEEE power-system Letter. A Letter is not a shortened full paper. It is a compact technical communication built around one hard claim, one deliverable, and minimal evidence.

Do not use this skill as the standalone acceptability or reject-risk reviewer. Use `powerlit-power-systems-paper-review` for strict IEEE Letter review; this Letter skill only applies review standards internally before delivery.

Official IEEE PES Letter page-budget rule, checked 2026-06-18: original submissions are limited to 3 formatted pages; revisions are limited to 3.5 pages; letters exceeding these limits are not reviewed. The author information page also states that an accepted letter should not exceed 4 pages after revision and editing. Treat corpus median page counts only as descriptive statistics, never as the hard rule.

## Core Workflow

1. Identify the Letter claim type:
   - counterexample,
   - analytical derivation,
   - correction or limitation of a common model,
   - compact formulation,
   - fast algorithm or sensitivity calculation,
   - focused metric/index,
   - small but decisive empirical observation.
2. Write the one-sentence claim before drafting.
3. If the Letter claim depends on novelty or prior-work contrast, try `powerlit-power-systems-literature-intelligence`:
   - resolve PowerLit from user path, `POWERLIT_JSON_ROOT` or `POWERLIT_LITERATURE_JSON`;
   - if accessible, identify the nearest Letters/full papers and the one contrast the Letter must win;
   - if inaccessible, state fallback mode once and keep the Letter narrow without inventing citations.
4. Apply the near-neighbor gate:
   - if PowerLit finds a close Letter or full paper with the same problem, mechanism, and evidence object, do not proceed by rephrasing;
   - narrow the claim, change the technical object, retarget as a full paper, or recommend against submission;
   - if the nearest papers are broad background only, keep novelty language narrow.
5. Load `references/letter-structure.md` for section and page-budget guidance.
6. Load `references/introduction.md` for the surgical introduction and contribution style.
7. Load `references/technical-core.md` for problem statement, compact formulation, derivation, counterexample, or solution-method sections.
8. Load `references/evidence-conclusion.md` for case-study, numerical-results, and conclusion sections.
9. Load `references/precision.md` before final prose.
10. Load `references/compression.md` when cutting a full-paper draft into Letter form.
11. Draft with "this letter" as the natural self-reference when appropriate.
12. Apply the reader-burden rule in `references/precision.md`: state the local judgment first, keep one idea per paragraph, and remove anything that does not support the single claim.
13. Before returning a submission-ready Letter, apply `powerlit-power-systems-paper-review` standards for IEEE power-system Letters. If the review would find a fatal novelty, logic, model, or evidence issue, narrow the claim, repair the technical core, or return a blocker instead of polished Letter prose.

## Corpus-Based Defaults

PowerLit mining found 69 IEEE power-system Letter-style papers in TPWRS/TSG. These are descriptive corpus signals, not official page limits:

- median length: 4 pages;
- median abstract: 5 sentences, about 21 words per sentence;
- median introduction: 7 paragraphs;
- median major sections: 5;
- median equations: 15;
- median references: 9.

Treat these as pressure constraints. If the draft needs a long literature review, a large nomenclature section, many experiments, and 30+ references, it is drifting into full-paper form.

## Required Shape

The Letter should usually fit this movement:

1. Abstract: problem assumption -> Letter claim -> technical deliverable -> compact validation -> implication. The first sentence must pinpoint the pain point (see Hard Rules), not warm up with a trend.
2. Introduction: object -> narrow prior work -> exact gap -> why the gap matters -> this letter's single contribution. The very first sentence must already name the object, its failing condition, and the unresolved conflict.
3. Technical core: load `references/technical-core.md`; define only necessary variables and derive, formulate, or test the deliverable.
4. Evidence: one focused case study, counterexample, benchmark, or numerical check.
5. Conclusion: one short paragraph stating what was established and the boundary.

## Hard Rules

- One Letter, one core claim.
- Pinpoint the pain point in the first sentence. The opening sentence of both the abstract and the introduction must itself carry: a concrete power-system object, its operating/uncertainty condition, and the unresolved conflict (two requirements that cannot be met together, or one that current methods cannot meet). Unlike full papers, a Letter has no room to warm up: a trend, importance, definition, or literature-activity opener ("随着...", "with the increasing penetration of...", "...受到广泛关注", "...至关重要", "许多学者研究了...") is prohibited as the first sentence. Read the first sentence in isolation — if a reviewer cannot tell what breaks and under what condition without the next sentence, rewrite it.
- Every paragraph must either expose the claim, derive it, or verify it.
- Do not write a broad related-work section.
- Do not add `NOMENCLATURE` unless the notation is truly impossible to read inline.
- Do not promise comprehensive validation.
- Do not use a full contribution list unless each item is a concrete deliverable.
- Prefer a narrow title that names the exact object.
- Run `references/precision.md` before final output. Every sentence must expose, derive, verify, or delimit the Letter claim.
- Keep each paragraph centered on one judgment; five sentences is the upper bound, and most Letter paragraphs should be shorter.
- If PowerLit finds a close prior Letter with the same claim, do not proceed by rephrasing. Narrow the claim, change the technical object, or recommend against Letter submission.
- Do not turn a weak full-paper idea into a Letter merely by cutting length. The Letter must have a sharper claim than the full paper, not just fewer paragraphs.
- Do not invent DOI, title, venue, year, or author details when PowerLit is unavailable or sparse.
- Do not expose internal labels such as `near-neighbor gate`, `claim boundary`, or `closest competitor` in final Letter prose.
- Do not call a Letter submission-ready if the local review skill would reject it for weak novelty, unsupported claim, missing technical core, or insufficient evidence.

## Output Contract

When rewriting prose, return manuscript-ready text first. Add only a short note for removed full-paper material, unsupported claims, or missing minimum evidence.
