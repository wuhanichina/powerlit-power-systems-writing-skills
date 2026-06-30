# Manuscript Section Quality Gate

Use this reference when drafting or revising the title, keywords, abstract, introduction, case analysis, conclusion, or full-paper structure. It turns common reviewer expectations into writing checks before the review skill is invoked.

## Role and Precedence

This file is the cross-section quality checklist: it turns reviewer expectations into pre-delivery acceptance checks. It is not the construction authority. For the deep how-to, defer to the section-authority references and do not maintain a competing version of their detail here:

- introduction cutting order, venue paragraph flow, gap/innovation categories, numeric whitelist, contribution patterns: `introduction-scalpel.md`;
- case-study prose construction, result-discussion layer, venue validation chains, conclusion boundary: `case-conclusion.md`;
- figure captions, table titles, result-paragraph evidence binding: `figures-tables-results.md`;
- equation physical intuition and method-section construction: `method-model.md`.

When this checklist and an authority file appear to disagree on detail, the authority file wins. Fix the discrepancy at the authority file rather than carrying two versions.

The review-side parallel of this checklist is `powerlit-power-systems-paper-review/references/section-quality-review.md` (the same dimensions seen from the reviewer stance). Keep the two aligned; do not let the writing-side and review-side wording drift apart.

## Title and Keywords

The title must be scientific, concise, and contribution-bearing:

- expose the power-system object, technical object, and differentiating mechanism or operating condition;
- avoid broad slogans, pure acronym titles, and math-first wording when the paper's value is engineering or physical;
- avoid superiority, real-time, robustness, deployment, or comprehensive-risk wording unless the evidence supports it;
- if no title is supplied, draft candidate titles before writing and align the selected title with the abstract, introduction, case study, and conclusion.

Keywords:

- keep keywords precise and at most five;
- use no more than five unless the venue explicitly requires otherwise;
- include the system object, method/technical object, application or operating condition, and one key mechanism or metric when needed;
- avoid duplicate levels of the same concept, vague words, and keywords that never appear as paper objects.

## Abstract

The abstract should be compact and fluent. It should quickly enter the technical subject rather than spending several sentences on broad background.

Required movement:

1. Background or operating context, in one short pivot sentence.
2. Purpose or unresolved problem.
3. Method or technical object.
4. Main result or evidence object.
5. Significance, engineering value, and boundary when needed.

The abstract must highlight innovation and practical value without overclaiming. It should not read as a section-by-section task list, and it should not contain claims that are absent from the case analysis.

## Introduction

Authority: `introduction-scalpel.md` (cutting order, venue paragraph flow, gap-to-contribution map). This subsection is only the acceptance checklist; do not restate the scalpel's how-to here.

The introduction must:

- start from the broader power-system background but quickly focus on the concrete object and conflict;
- explain the current problem and challenge, not only state that the topic is important;
- analyze the technical essence of the problem: physical coupling, operating constraint, uncertainty, information limitation, computation, stability, security, observability, or evidence gap;
- condense the key scientific or engineering problem the paper solves;
- use recent high-level literature, preferably EI-indexed or above and mainly from the last five years, to summarize the research state when available;
- group literature by method family or technical limitation rather than listing papers one by one;
- state the paper's basic idea and relative advantage compared with existing approaches;
- make transitions natural from background -> existing methods -> unresolved technical reason -> proposed technical object -> evidence boundary.

If PowerLit is available, use it to retrieve recent venue-near or method-near papers before writing citation-sensitive introduction claims. If recent high-level literature is unavailable or not supplied, state the fallback and leave citation slots instead of inventing references.

## Case Analysis

Authority: `case-conclusion.md` (result-discussion layer, venue validation chains) and `figures-tables-results.md` (caption and result-paragraph evidence binding). This subsection is only the acceptance checklist.

The case analysis must be designed around the innovation point, not around whatever outputs are easiest to plot.

A complete case-analysis plan or section should state:

- which theoretical or engineering problem the case is meant to solve;
- data source, test system, scenario, operating condition, and why they are appropriate;
- baselines and why they are fair for the claim;
- metrics, units, and direction of improvement;
- comparison against existing methods where the paper claims relative advantage;
- parameter sensitivity, ablation, or boundary tests when parameters, modules, or assumptions affect the conclusion;
- case scale and analysis depth sufficient for the venue and claim class;
- figure and table interpretation one by one, with each visual tied to a claim, mechanism, or boundary;
- reproducibility details such as solver, tolerance, runtime, preprocessing, or hardware when they affect the claim.

The prose should explain mechanism and engineering meaning, not only repeat numbers. If data are incomplete, sources uncertain, baselines absent, or sensitivity missing, mark those as writing blockers or claim boundaries.

## Conclusion

Authority: `case-conclusion.md` (venue-specific conclusion length and close patterns). This subsection is only the acceptance checklist.

The conclusion should be short and evidence-bound:

- summarize the main technical content and innovation points;
- state only conclusions supported by derivation, proof, case results, or cited evidence;
- avoid both exaggeration and excessive self-weakening;
- keep the length compact and do not reopen the literature review;
- include reasonable future work only when it follows from a real boundary, such as additional data, larger systems, field validation, new constraints, or broader scenarios.

Do not introduce new contributions, new numbers, or untested deployment implications in the conclusion.

## Spine Consistency

The paper spine is one sentence naming the technical object, the unresolved conflict, the central action, and the evidence boundary (defined in `introduction-scalpel.md`). Before delivery, verify the spine is consistent across the five load-bearing locations: title, abstract, introduction contribution, result discussion, and conclusion.

Check that all five share:

- the same name for the technical object — no silent rename (e.g. 反演 in the title but 估计 in the abstract; "screening index" in the contribution but "predictor" in the results);
- the same central claim verb and scope — screening vs prediction, identification vs calibration, reduction vs elimination, support vs guarantee;
- the same evidence boundary — a limit stated in the conclusion must also bound the abstract and introduction claims, not appear only at the end.

If a location drifts, repair it back to the spine rather than weakening the spine. If two locations genuinely need different scope (for example a broader introduction motivation narrowing to a specific contribution), make the narrowing explicit so it does not read as a contradiction. This is a cross-section consistency check, not an instruction to repeat one sentence five times.
