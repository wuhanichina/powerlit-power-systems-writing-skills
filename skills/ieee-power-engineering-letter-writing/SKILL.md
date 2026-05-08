---
name: ieee-power-engineering-letter-writing
description: Write, rewrite, or review IEEE power-system Letters such as IEEE Power Engineering Letters, TPWRS/TSG short Letters, and 3-4 page power-system technical communications. Use for letter abstracts, introductions, compact formulations, counterexample/analytical notes, case-study compression, and anti-full-paper cleanup.
---
# IEEE Power Engineering Letter Writing

## Purpose

Use this skill when the target is an IEEE power-system Letter. A Letter is not a shortened full paper. It is a compact technical communication built around one hard claim, one deliverable, and minimal evidence.

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
3. Load `references/letter-structure.md` for section and page-budget guidance.
4. Load `references/introduction.md` for the surgical introduction and contribution style.
5. Load `references/technical-core.md` for problem statement, compact formulation, derivation, counterexample, or solution-method sections.
6. Load `references/evidence-conclusion.md` for case-study, numerical-results, and conclusion sections.
7. Load `references/compression.md` when cutting a full-paper draft into Letter form.
8. Draft with "this letter" as the natural self-reference when appropriate.
9. Remove anything that does not support the single claim.

## Corpus-Based Defaults

PowerLit mining found 69 IEEE power-system Letter-style papers in TPWRS/TSG:

- median length: 4 pages;
- median abstract: 5 sentences, about 21 words per sentence;
- median introduction: 7 paragraphs;
- median major sections: 5;
- median equations: 15;
- median references: 9.

Treat these as pressure constraints. If the draft needs a long literature review, a large nomenclature section, many experiments, and 30+ references, it is drifting into full-paper form.

## Required Shape

The Letter should usually fit this movement:

1. Abstract: problem assumption -> Letter claim -> technical deliverable -> compact validation -> implication.
2. Introduction: object -> narrow prior work -> exact gap -> why the gap matters -> this letter's single contribution.
3. Technical core: load `references/technical-core.md`; define only necessary variables and derive, formulate, or test the deliverable.
4. Evidence: one focused case study, counterexample, benchmark, or numerical check.
5. Conclusion: one short paragraph stating what was established and the boundary.

## Hard Rules

- One Letter, one core claim.
- Every paragraph must either expose the claim, derive it, or verify it.
- Do not write a broad related-work section.
- Do not add `NOMENCLATURE` unless the notation is truly impossible to read inline.
- Do not promise comprehensive validation.
- Do not use a full contribution list unless each item is a concrete deliverable.
- Prefer a narrow title that names the exact object.

## Output Contract

When rewriting prose, return manuscript-ready text first. Add only a short note for removed full-paper material, unsupported claims, or missing minimum evidence.
