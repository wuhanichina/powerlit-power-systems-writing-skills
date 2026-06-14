# Decision Rubric

Use this rubric when the user asks for scores or an accept/reject recommendation.

## Scores

Score each item from 1 to 10:

- Problem importance and venue relevance.
- Innovation substance.
- Logic-chain closure.
- Model and mathematical correctness.
- Method clarity and reproducibility.
- Case-study and evidence sufficiency.
- Conclusion support and claim boundary.
- Writing, structure, and format.

Use strict scoring:

- 9-10: publishable at target venue with only minor refinements.
- 7-8: promising but still has repairable weaknesses.
- 5-6: major revision required; contribution or evidence is not yet convincing.
- 3-4: likely rejection; core logic, model, or validation is weak.
- 1-2: fatal flaw, wrong problem, wrong model, unsupported claim, or plagiarism risk.

## 8-9 Target Gate

Use this gate when a draft is being debugged toward an 8-9 score.

An 8-score full-paper verdict requires:

- no fatal flaw and no major venue mismatch;
- average score at least 8 across the eight categories;
- no core category below 8 for problem relevance, innovation substance, logic-chain closure, model correctness, evidence sufficiency, or claim boundary;
- writing/structure score at least 7.5 after technical repair;
- Chinese manuscript register is clean when the target venue is Chinese: no `声称/宣称` in authorial prose, no emphasis quotation marks around ordinary technical terms, and no em-dash explanation chains in manuscript text;
- actual case evidence with baselines, metrics, systems, scenarios, and boundaries;
- complete manuscript content: introduction, novelty positioning, method/model with equations and physical interpretation, algorithm or solution procedure, case-study protocol, result tables/figures, comparative analysis, discussion, and conclusion.
- result provenance is inspected: key numeric tables and figures match source CSV/report/log/manifest artifacts after rounding;
- reproducibility details are manuscript-facing: solver, tolerance, hyperparameters, initialization/fallback, software/hardware or runtime context, and stopping criteria are stated when they affect the result;
- references are manuscript-ready: no placeholder notes, no "to be verified" entries, no uncited references, and no citation used for the wrong method family.

A 9-score full-paper verdict requires:

- average score at least 9;
- no category below 8.5;
- model correctness, evidence sufficiency, and claim boundary at least 9;
- only minor refinements remain.

Do not give a full-paper score above 7.5 when only case-analysis data are supplied without enough method, novelty, baseline, and claim-boundary facts. Score the available section instead.

Do not let compressed artifacts pass as full papers. A representative package, outline, abstract-with-results draft, or score-target run that lacks full equations, model derivation, complete case analysis, comparison tables, and discussion must be labeled `blocked below 8-9 full-paper completeness` even if its direction is promising.

Do not give an 8-score verdict to a complete-looking manuscript whose main result tables are not checked against source artifacts, whose references still contain placeholders or wrong citation roles, or whose algorithm/protocol cannot be reproduced from manuscript-facing details. Use `repairable below 8-9` when the manuscript is complete but these issues are repairable.

Do not give an 8-score verdict to a diagnostic, inverse, feasibility-certifying, or boundary-characterization paper merely because the formulation is novel. If the most relevant baseline is better on primary accuracy and runtime metrics, the manuscript must prove a distinct non-substitutable use case and validate that use case with direct evidence. Without that, score innovation, logic-chain closure, and conclusion support in the 5-7 range even when the mathematics is sound.

Do not let a main case study hide a fallback. If a core contribution is turned off, replaced by a baseline, or selected after seeing worse accuracy, require explicit table/caption/abstract/conclusion labeling and a transition experiment or pre-declared diagnostic threshold. Without it, evidence sufficiency cannot reach 8.

When sensitivity, ablation, and SOTA tables reuse the same metric name, check whether the aggregation scope and post-processing are identical. Unexplained differences such as two different W1 values for the same nominal case are a reproducibility and claim-boundary issue, not a formatting issue.

## Verdict Mapping

`直接录用`:

- Rare. Use only when the manuscript is already technically complete, correctly written, and has no meaningful reviewer risk.

`小修后录用`:

- Core contribution is sound.
- Model and evidence are sufficient.
- Remaining issues are clarity, formatting, minor missing explanations, or limited extra references.

`大修后录用`:

- Direction is worth publishing.
- Core model may be sound, but evidence, framing, explanation, or venue fit needs substantial repair.
- No fatal mathematical or logical flaw.

`拒绝录用`:

- Fatal issue in problem, novelty, logic chain, model correctness, or evidence.
- Contribution is too incremental for the target venue.
- Validation cannot support the claims.
- Paper solves a different problem from the one it motivates.
- Suspected plagiarism or duplicated contribution requires rejection or formal investigation.

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

## Score-Target Output

When the user asks whether a draft reaches 8-9, return a compact score table with exactly these categories:

- Problem importance and venue relevance.
- Innovation substance.
- Logic-chain closure.
- Model and mathematical correctness.
- Method clarity and reproducibility.
- Case-study and evidence sufficiency.
- Conclusion support and claim boundary.
- Writing, structure, and format.

Then state:

- average score;
- full-paper readiness: `complete manuscript`, `section-level only`, or `compressed evaluation package only`;
- gate status: `passes 8-9 full-paper gate`, `repairable below 8-9`, `blocked below 8-9`, or `blocked below 8-9 full-paper completeness`;
- lowest-scoring category;
- first repair action.

If the manuscript is section-only, label the score as section-level and do not use it as a full-paper score.
