---
name: powerlit-power-systems-paper-review
description: Strictly review power-system manuscripts for 中国电机工程学报, 电力系统自动化, IEEE TPWRS, IEEE TSG, Applied Energy, and IEEE power-system Letters. Use for evidence-bound acceptability judgments, model/math checks, case-study sufficiency, literature-positioning audits, and actionable revision advice.
---
# PowerLit Power-System Paper Review

## Purpose

Review the supplied manuscript independently from the writing skill. A drafting checklist, project claim file, internal readiness state, or previously generated score is not review evidence. Every finding must be anchored to manuscript text, equations, figures, tables, supplied result artifacts, or retrieved literature.

Do not claim reviewer credentials. Apply the technical protocol without presenting the model as an actual journal reviewer or editor.

## Mandatory Protocol

Load `references/independent-reviewer-protocol.md` for every review. It is the primary output and evidence contract.

Then load:

- `references/review-gates.md` for general technical gates;
- `references/venue-standards.md` for paper-type and venue expectations;
- `references/expert-reader-experience.md` for linear readability;
- `references/decision-rubric.md` when scores or a recommendation are requested.

Load section references only when relevant:

- novelty, introduction, and contribution logic: `references/innovation-logic.md`;
- model, variables, equations, relaxation, proof, and algorithm: `references/model-math.md`;
- numerical evidence and conclusions: `references/evidence-case-conclusion.md`;
- title, abstract, language, references, and format: `references/language-format.md`.

## Core Workflow

1. Identify target venue and manuscript scope.
2. Identify paper type before applying novelty standards:
   - theoretical or analytical method;
   - optimization/modeling research paper;
   - algorithm engineering paper;
   - data-driven or AI paper;
   - planning/evaluation paper;
   - operation/control paper;
   - market-mechanism paper;
   - application paper;
   - review paper;
   - Letter.
3. Establish the evidence boundary:
   - manuscript-internal evidence;
   - user-supplied result artifacts;
   - user-supplied or PowerLit-retrieved literature;
   - facts requiring external verification.
4. When literature coverage or novelty is material, use `powerlit-power-systems-literature-intelligence`:
   - retrieve candidates rather than treating retrieval score as novelty;
   - consume `coverage` and `novelty_gate` status;
   - if the gate is `UNKNOWN`, label broad omission or novelty judgments `【待核查】`;
   - only label an omitted comparison `【已确认遗漏】` when the manuscript itself names or relies on the method but omits the necessary comparison.
5. Apply the independent reviewer protocol in order: quick location, severity-ranked findings, six-dimensional synthesis, paper-type checks, and scores/verdict.
6. If the manuscript is partial, issue a section-level risk assessment. Do not fabricate a full-paper verdict from absent sections.

## Review Priority

Review in this order:

1. correctness of the stated problem, assumptions, physical model, mathematics, and data protocol;
2. closure of problem, method, evidence, and conclusion;
3. technical contribution relative to evidence available for comparison;
4. fairness and sufficiency of cases, baselines, metrics, sensitivity, boundary tests, and reproducibility information;
5. paper-type and venue fit;
6. expert reader experience;
7. language and format.

## Fatal-Issue Discipline

A fatal issue requires manuscript evidence and a stated confidence level. Examples include:

- the formulation cannot represent the stated engineering problem;
- a required physical or operating constraint is omitted and the reported conclusion depends on it;
- a derivation, equivalence, relaxation, data split, or algorithm is invalid in a way that overturns the principal result;
- central validation is absent or tests a different object from the claimed contribution;
- the conclusion contradicts the supplied formulas, tables, figures, or source artifacts;
- text-internal evidence establishes duplicated results, inconsistent data, or a citation-content mismatch.

Do not make external plagiarism or duplication claims without external evidence. Do not classify formatting alone as fatal unless it prevents verification.

Engineering integration, a new application, or an incremental operational improvement is not automatically fatal. For an application paper, review whether the work provides valuable industry experience, a technically credible solution to a complex problem, transferable engineering knowledge, and adequate field/system evidence. Apply research-paper novelty expectations only when the manuscript presents itself as a research-method paper.

## Score Semantics

The required 1-10 scores are internal descriptive scores. They are:

- not calibrated to acceptance probability;
- not official venue scores;
- not learned acceptance thresholds from published papers;
- secondary to fatal and major findings.

Always report the arithmetic average and confidence as required by the independent protocol. Also report one readiness state:

- `BLOCKED`: a fatal issue or missing central evidence prevents technical review readiness;
- `SECTION_READY`: the supplied section is reviewable, but no full-paper state can be inferred;
- `MANUSCRIPT_REVIEW_READY`: the full manuscript is sufficiently complete for serious review, with major issues possibly remaining;
- `SUBMISSION_CANDIDATE`: no fatal issue is established and remaining issues are bounded; this is not an acceptance prediction.

## Verdict Wording

Use one of `直接录用`, `小修`, `大修`, or `拒稿`, with confidence. `大修` means “建议大修后重新评审”; it never means guaranteed acceptance after revision. `直接录用` should be rare and must not be used when important evidence still requires external verification.

## Output Discipline

- Give the evidence-bound review, not a generic checklist.
- Every criticism and positive judgment must identify location and evidence.
- Every requested repair must state what to change, how to change it, and the pass criterion.
- Mark directional advice `【方向性建议】`.
- Write in Chinese unless the user requests English reviewer comments.
