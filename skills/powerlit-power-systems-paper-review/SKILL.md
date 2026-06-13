---
name: powerlit-power-systems-paper-review
description: Strictly review power-system manuscripts for 中国电机工程学报, 电力系统自动化, IEEE TPWRS, IEEE TSG, and IEEE power-system Letters. Use for acceptability judgments, reject-risk diagnosis, innovation and logic-chain review, model/math/equation checks, case-study sufficiency, conclusion support, venue fit, and reviewer-style revision advice.
---
# PowerLit Power-System Paper Review

## Purpose

Use this skill to review power-system papers against the standards implied by already published papers in the target venues. The default stance is strict, technical, and evidence-bound. Do not role-play credentials; review from the manuscript evidence.

## Core Workflow

1. Identify the review target:
   - 中国电机工程学报
   - 电力系统自动化
   - IEEE Transactions on Power Systems
   - IEEE Transactions on Smart Grid
   - IEEE power-system Letter
   - unknown venue
2. Identify manuscript scope:
   - full paper,
   - abstract/introduction only,
   - method/model only,
   - case/results only,
   - conclusion only,
   - reviewer response or revision plan.
3. Try to use `powerlit-power-systems-literature-intelligence` for literature coverage and novelty risk:
   - resolve PowerLit from user path, `POWERLIT_JSON_ROOT`, `POWERLIT_LITERATURE_JSON`, or `\\WHome\PowerLit\literature\json`;
   - if accessible, retrieve closest competitors and missing-citation risks;
   - if inaccessible, state fallback mode once and keep the review limited to manuscript evidence and general field knowledge.
4. Load `references/review-gates.md` for corpus-based acceptance signals.
5. Load `references/venue-standards.md` for venue-specific review expectations.
6. Load section references as needed:
   - innovation, introduction, and claim logic: `references/innovation-logic.md`
   - method, model, variables, equations, physical correctness: `references/model-math.md`
   - case studies, numerical results, conclusion: `references/evidence-case-conclusion.md`
   - title, abstract, wording, format, references: `references/language-format.md`
7. Load `references/expert-reader-experience.md` for every manuscript or section review.
8. Load `references/decision-rubric.md` before giving scores or an accept/reject recommendation.
9. For score-targeted reviews, especially 8-9 targets, apply the `8-9 Target Gate` in `references/decision-rubric.md` and report category scores, the lowest-scoring category, gate status, and required repair before any prose polish.
10. If the manuscript is partial, state that the verdict is section-level unless the user explicitly asks for a full-paper risk estimate.

## Review Priority

Lead with acceptability, not polishing.

Check in this order:

1. Technical problem: whether the paper targets a real, current, and nontrivial power-system difficulty.
2. Innovation: whether the contribution is a technical object or only a recombination, application, parameter tweak, or packaging change.
3. Logic chain: whether problem -> method -> validation -> conclusion is closed.
4. Correctness: whether physical concepts, assumptions, mathematical formulation, units, variables, formula-level physical intuition, and algorithms are coherent.
5. Evidence: whether cases, baselines, metrics, sensitivity, and boundary tests actually verify the innovation.
6. Expert reader experience: whether a small-field expert can linearly follow the target, method, evidence, and boundary with at least `CONDITIONAL PASS`.
7. Venue fit: whether the paper matches the expected depth and rhythm of the target journal.
8. Language and format: only after the technical review unless the user asks for proofreading.

## Hard Reject Triggers

Recommend rejection when any of these are central and unrepaired:

- The claimed problem is vague, stale, or not a real bottleneck for the stated venue.
- The innovation is only an engineering combination, dataset substitution, parameter tuning, or incremental application with no new model, mechanism, algorithm, control law, estimator, certificate, or evidence insight.
- The paper changes the problem during the argument: the introduction claims one difficulty, the method solves another, and the case verifies a third.
- Mathematical formulation cannot represent the stated engineering need, violates physical constraints, or uses undefined/inconsistent variables.
- Key equations are only symbolically defined and do not explain the grid quantity, coupling, feasibility condition, or operating mechanism they represent.
- Key assumptions are hidden and would invalidate the claimed improvement.
- Case studies do not test the proposed innovation against relevant baselines or scenarios.
- Conclusions make claims not supported by formulas, proofs, or numerical results.
- The manuscript lacks enough method or evidence depth for the target venue.
- There is credible evidence of plagiarism, duplicated text, or unacknowledged reuse. If only suspicious signs are visible, flag them as requiring similarity/reference checks rather than declaring plagiarism.

## Output Contract

For a full manuscript review, use this structure:

Include a `PowerLit literature coverage` item when corpus retrieval is available, or a fallback limitation when it is not.

1. `审稿结论`: one of `直接录用`, `小修后录用`, `大修后录用`, `拒绝录用`.
2. `总体判断`: 3-6 sentences explaining the main reason.
3. `主要问题`: ordered by severity. Each issue should state the claim, why it fails, and what evidence from the manuscript supports the criticism.
4. `专家级阅读体验`: `PASS`, `CONDITIONAL PASS`, or `FAIL`, with anchored reasons and first repair action from `references/expert-reader-experience.md`.
5. `逻辑链与创新性`: problem -> gap -> method -> validation -> conclusion, with weak links identified.
6. `模型与方法审查`: equations, variables, assumptions, physical meaning, algorithm, complexity, simplification opportunities.
7. `算例与结论审查`: scenarios, baselines, metrics, sensitivity, boundary, conclusion support.
8. `文字与格式问题`: only material issues, including defensive claim posture, not minor copyediting unless requested.
9. `评分`: use the rubric in `references/decision-rubric.md`.
10. `修改建议`: concrete actions, grouped by must-fix and should-fix.

If `专家级阅读体验` is `FAIL`, do not describe the manuscript as submission-ready even if the technical review has no fatal correctness issue.

For an 8-9 target review, the `评分` item must include eight category scores, average score, target-gate status, the lowest-scoring category, and the first repair action needed to move that category into the target band.

For a section-only review, keep the same severity discipline but do not pretend to know missing sections. Use `本节录用风险` instead of a full-paper verdict when appropriate.

## Tone

Write in Chinese by default unless the user asks for English reviewer comments. Be direct and specific. Avoid empty reviewer phrases such as "the paper is interesting" unless followed by a precise technical reason. Do not soften fatal flaws into style suggestions.
