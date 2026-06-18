# Decision Rubric

Use this rubric when the user asks for a readiness judgment, a score-like diagnostic, or a submit/repair/block recommendation.

This is an internal diagnostic rubric. It is not a journal reviewer numeric evaluation, an acceptance threshold, or a publication-outcome probability model.

## PowerLit Internal Readiness Index

Score each dimension with evidence-anchored levels:

- 0 = missing or fatal issue.
- 1 = insufficient information.
- 2 = major gap remains.
- 3 = mostly complete but repair is still needed.
- 4 = ready under the evidence currently available.

Use exactly these dimensions:

- Problem importance and venue relevance.
- Innovation substance.
- Logic-chain closure.
- Model and mathematical correctness.
- Method clarity and reproducibility.
- Case-study and evidence sufficiency.
- Conclusion support and claim boundary.
- Writing, structure, and format.

Published PowerLit papers may be used only as:

- descriptive completeness benchmarks;
- evidence-dimension references;
- writing-structure references.

Do not interpret published-paper corpus signals as:

- publication-outcome probability;
- journal scoring thresholds;
- official reviewer scores.

Only a future dataset with labeled accept/reject outcomes may support a calibrated statistical model such as `P(Y=accept | X)`, and that would require cross-validation, confidence intervals, and calibration curves. This skill does not output publication-outcome probabilities.

## Readiness Gate

Use this gate when a draft is being debugged toward internal submission readiness.

`MANUSCRIPT_REVIEW_READY` requires:

- no fatal flaw and no major venue mismatch;
- all core dimensions at level 4 or a documented level-3 repair with the exact missing evidence named;
- problem relevance, innovation substance, logic-chain closure, model correctness, evidence sufficiency, and claim boundary at level 4;
- writing/structure at least level 3 after technical repair;
- Chinese manuscript register is clean when the target venue is Chinese: no `声称/宣称` in authorial prose, no emphasis quotation marks around ordinary technical terms, and no em-dash explanation chains in manuscript text;
- actual case evidence with baselines, metrics, systems, scenarios, and boundaries;
- complete manuscript content: introduction, novelty positioning, method/model with equations and physical interpretation, algorithm or solution procedure, case-study protocol, result tables/figures, comparative analysis, discussion, and conclusion;
- result provenance is inspected: key numeric tables and figures match source CSV/report/log/manifest artifacts after rounding;
- reproducibility details are manuscript-facing: solver, tolerance, hyperparameters, initialization/fallback, software/hardware or runtime context, and stopping criteria are stated when they affect the result;
- references are manuscript-ready: no placeholder notes, no "to be verified" entries, no uncited references, and no citation used for the wrong method family.

`SUBMISSION_CANDIDATE` requires a complete manuscript whose remaining issues are minor, local, and unlikely to change the method, evidence, novelty boundary, or venue fit. Use this state sparingly and only after the review-closure gate passes.

Do not mark a full paper above `SECTION_READY` when only case-analysis data are supplied without enough method, novelty, baseline, and claim-boundary facts.

Do not let compressed artifacts pass as full papers. A representative package, outline, abstract-with-results draft, or readiness run that lacks full equations, model derivation, complete case analysis, comparison tables, and discussion must be labeled `BLOCKED` or `SECTION_READY` even if its direction is promising.

Use `BLOCKED` when the manuscript is complete-looking but its main result tables are not checked against source artifacts, references still contain placeholders or wrong citation roles, or the algorithm/protocol cannot be reproduced from manuscript-facing details.

Do not mark a diagnostic, inverse, feasibility-certifying, or boundary-characterization paper as `MANUSCRIPT_REVIEW_READY` merely because the formulation is novel. If the most relevant baseline is better on primary accuracy and runtime metrics, the manuscript must prove a distinct non-substitutable use case and validate that use case with direct evidence.

Do not let a main case study hide a fallback. If a core contribution is turned off, replaced by a baseline, or selected after seeing worse accuracy, require explicit table/caption/abstract/conclusion labeling and a transition experiment or pre-declared diagnostic threshold. Without it, evidence sufficiency cannot reach level 4.

When sensitivity, ablation, and SOTA tables reuse the same metric name, check whether the aggregation scope and post-processing are identical. Unexplained differences such as two different W1 values for the same nominal case are a reproducibility and claim-boundary issue, not a formatting issue.

## Verdict Mapping

`建议直接投稿`:

- Rare. Use only when the manuscript is already technically complete, correctly written, and has no meaningful local reviewer risk. This is local advice, not an editor decision.

`建议小修后投稿`:

- Core contribution is sound.
- Model and evidence are sufficient.
- Remaining issues are clarity, formatting, minor missing explanations, or limited extra references.

`建议大修后重审`:

- Direction may be worth publishing.
- Core model may be sound, but evidence, framing, explanation, or venue fit needs substantial repair.
- No fatal mathematical or logical flaw is visible.

`不建议投稿`:

- Fatal issue in problem, novelty, logic chain, model correctness, or evidence.
- Contribution is too incremental for the target paper type.
- Validation cannot support the claims.
- Paper solves a different problem from the one it motivates.
- Suspected plagiarism or duplicated contribution requires rejection risk or formal similarity/reference checks.

## Paper-Type Discipline

First identify the manuscript type:

- Research Paper.
- Application Paper.
- Review Paper.
- Letter.

For an Application Paper, engineering integration is not an automatic rejection reason. Judge method innovation, system application value, field or realistic-system evidence, transferable experience, and operational lessons. For a Research Paper, require a clearer new model, mechanism, theorem, algorithm, controller, estimator, certificate, or evidence insight. For a Review Paper, judge coverage, taxonomy, synthesis value, and source balance.

## Output Discipline

Findings must lead. Order by severity:

1. fatal flaws;
2. major technical flaws;
3. missing evidence;
4. venue mismatch;
5. writing and formatting issues.

For each finding, state:

- location or section if available;
- what the manuscript claims;
- why the claim is not established;
- what would be required to repair it.

Do not bury a rejection reason inside a long proofreading list.

## Readiness Output

When the user asks whether a draft is internally ready, return a compact readiness table with exactly these categories:

- Problem importance and venue relevance.
- Innovation substance.
- Logic-chain closure.
- Model and mathematical correctness.
- Method clarity and reproducibility.
- Case-study and evidence sufficiency.
- Conclusion support and claim boundary.
- Writing, structure, and format.

Then state:

- readiness state: `BLOCKED`, `SECTION_READY`, `MANUSCRIPT_REVIEW_READY`, or `SUBMISSION_CANDIDATE`;
- full-paper readiness: `complete manuscript`, `section-level only`, or `compressed evaluation package only`;
- blocking conditions;
- lowest-readiness dimension;
- first repair action.

If the manuscript is section-only, label the result as section-level and do not use it as a full-paper readiness result.
