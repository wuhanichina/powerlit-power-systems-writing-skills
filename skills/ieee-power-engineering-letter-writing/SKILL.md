---
name: ieee-power-engineering-letter-writing
description: Write and revise IEEE power-system Letters around one narrow technical claim under current IEEE PES page limits.
---
# IEEE Power Engineering Letter Writing

## Purpose

Use this skill for one compact analytical result, correction, counterexample, formulation, focused algorithm, or decisive observation. A Letter is not a full paper shortened after drafting.

Use `powerlit-power-systems-paper-review` for an independent review before describing a Letter as review-ready.

## Page Rule

The IEEE PES rule verified on 2026-06-18 is:

- initial submission: at most 3 formatted pages;
- revision: at most 3.5 formatted pages;
- the final edited Letter should remain within 4 pages.

The 4-page median observed in published papers is descriptive and must not be used as the initial-submission limit.

## Workflow

1. State the single claim and its validity condition in one sentence.
2. Classify it as a derivation, counterexample, correction, compact formulation, focused algorithm, metric, or decisive empirical/application result.
3. When novelty matters, use `powerlit-power-systems-literature-intelligence` to retrieve nearby Letters and full papers. Treat retrieval as candidate discovery and compare problem, mechanism, model, data, evidence, and claim.
4. Load `references/letter-structure.md`, `references/introduction.md`, `references/technical-core.md`, `references/evidence-conclusion.md`, and `references/precision.md`. Load `references/compression.md` when reducing a longer draft.
5. Draft to the 3-page initial-submission budget unless the user explicitly supplies a revision context.
6. Apply the independent reviewer protocol. Narrow or block the Letter when a central novelty, model, derivation, or evidence issue remains.

## Required Movement

1. Abstract: problem or assumption, claim, technical object, decisive evidence, scoped implication.
2. Introduction: object, narrow prior work, exact unresolved point, importance, one contribution.
3. Technical core: only necessary variables, assumptions, equations, and steps.
4. Evidence: one focused proof, counterexample, system, benchmark, or numerical check.
5. Conclusion: established result, validity condition, and boundary.

## Hard Rules

- One Letter, one principal claim.
- Every paragraph must expose, derive, verify, or delimit that claim.
- Avoid a broad related-work section and a multi-item contribution list.
- Add nomenclature only when inline definitions are insufficient.
- Do not promise comprehensive validation.
- Do not turn a weak full-paper idea into a Letter by deleting paragraphs.
- Do not invent citations, metadata, results, or page-rule exceptions.
- Do not expose internal drafting labels in manuscript prose.
- Do not call an initial manuscript review-ready above 3 formatted pages or a revision review-ready above 3.5 formatted pages.

## Output Contract

Return manuscript text first. Add a short note only for page-budget violations, unsupported claims, missing minimum evidence, or unresolved literature coverage.
