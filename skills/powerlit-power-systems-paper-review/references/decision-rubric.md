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
- actual case evidence with baselines, metrics, systems, scenarios, and boundaries;
- complete manuscript content: introduction, novelty positioning, method/model with equations and physical interpretation, algorithm or solution procedure, case-study protocol, result tables/figures, comparative analysis, discussion, and conclusion.

A 9-score full-paper verdict requires:

- average score at least 9;
- no category below 8.5;
- model correctness, evidence sufficiency, and claim boundary at least 9;
- only minor refinements remain.

Do not give a full-paper score above 7.5 when only case-analysis data are supplied without enough method, novelty, baseline, and claim-boundary facts. Score the available section instead.

Do not let compressed artifacts pass as full papers. A representative package, outline, abstract-with-results draft, or score-target run that lacks full equations, model derivation, complete case analysis, comparison tables, and discussion must be labeled `blocked below 8-9 full-paper completeness` even if its direction is promising.

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
