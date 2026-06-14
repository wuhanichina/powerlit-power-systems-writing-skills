# Score-Targeted Writing Gate

Use this reference when the user asks for a manuscript that should reach a target review score, such as 8-9 points, or when maintaining evaluation cases that explicitly target high review scores.

## Core Rule

An 8-9 score is not a style target. It is a review-strength target. Fluent prose cannot compensate for a weak technical object, missing method facts, thin case evidence, or an unsupported conclusion.

Before drafting, build a score-target packet:

- target venue and paper type;
- technical object that will be reviewed;
- PowerLit evidence-strength profile for the same venue and claim class when the corpus is available;
- actual case-study evidence, not only intended experiments;
- baselines and fairness protocol;
- metrics with units, directions, and decision thresholds;
- result provenance: exact source table, CSV, report, log, figure data, or manifest for every quantitative result that will appear in the manuscript;
- section-by-section claim boundary;
- expected review-score band and the weakest likely category.

If the packet is incomplete, write the strongest bounded section possible and state that the current packet cannot support an 8-9 full-paper target.

## 8-9 Full-Paper Minimum

A full-paper draft may target 8-9 only when all of these are true:

- the problem is venue-relevant and specific;
- the contribution is a reviewable model, formulation, mechanism, estimator, controller, certificate, or evidence insight;
- accepted PowerLit papers for the same venue or claim class have been used to identify the manuscript-facing evidence bar, or the draft explicitly states literature-limited fallback;
- the manuscript contains a complete method/model section with variables, assumptions, equations, algorithms, physical interpretation, and reproducibility details;
- the manuscript contains a complete case-study section with system setup, scenario construction, parameter settings, baselines, metrics with units, comparison tables or figures, result analysis, sensitivity or ablation when the claim depends on it, and boundary discussion;
- the manuscript contains a literature/novelty argument or a supplied PowerLit novelty boundary sufficient for the venue;
- no reference placeholder, "to be verified" note, missing citation role, or uncited reference remains in the manuscript-facing reference list;
- every reported runtime, error, distance, residual, rank, or feasibility number is traceable to an inspected result artifact and matches that artifact after rounding;
- the results discussion interprets why the method behaves as observed, not only whether metrics are numerically higher or lower;
- the conclusion is narrower than or equal to the demonstrated evidence;
- PowerLit near-neighbor risk has been checked or the draft states fallback limitations.

Case-analysis evidence alone can support an 8-9 case-study section only. It cannot support an 8-9 full-paper claim without the method object and novelty boundary.

A compressed evaluation package, outline, abstract-plus-results draft, or representative full-paper package is not a full paper. It must be labeled as package-level or section-level, and its gate status must be `blocked below 8-9 full-paper completeness` unless the complete manuscript text and required tables/equations are present.

## Diagnostic or Inverse-Method Gate

When the proposed method is diagnostic, inverse, certifying, or otherwise complementary to a strong forward baseline, do not treat structural novelty as enough for an 8-9 target.

Keep the draft below the 8-9 full-paper gate when the most relevant baseline is better on the primary accuracy and runtime metrics unless all of these are manuscript-facing:

- a non-substitutable operating scenario explaining why the baseline or standard forward method cannot directly answer the problem;
- evidence that the proposed method solves that scenario's distinct need, such as identifiability, feasibility certification, observability-limited reconstruction, or failure diagnosis;
- a table or paragraph that explicitly separates baseline accuracy from the proposed method's diagnostic or inverse value;
- conclusion wording that does not imply accuracy or speed superiority when the tables do not show it.

If a core module is disabled, replaced by a baseline, or selected by an after-the-fact setting in any main case study, the manuscript must label that fallback in the table caption, row label, abstract-level claim, and conclusion. Do not pass the 8-9 gate until the paper either adds a transition/boundary experiment showing when the module should be on or narrows the claim to the systems where the module actually ran.

When the same metric name appears in SOTA comparison, sensitivity analysis, and ablation tables, verify that the post-processing and aggregation scope are identical before using the numbers side by side. If they differ, write the result as a within-experiment trend or separate it into a different table; do not use it as cross-table evidence.

## Full-Paper Completeness Gate

Before assigning a full-paper 8-9 score, check that the draft includes all of these manuscript-facing parts:

1. Title, abstract, and contribution statement.
2. Introduction and related-work/near-neighbor positioning.
3. Problem formulation or system model.
4. Proposed method with equations, assumptions, variable definitions, physical intuition, and algorithm or solution procedure.
5. Implementation details: algorithm flow plus enough solver, tolerance, hyperparameter, initialization, fallback, software, hardware, and stopping-condition information for a reviewer to reproduce the run at manuscript level.
6. Case-study design: system, data/scenario, baselines, metrics, parameter settings, and reproducibility details.
7. Results: complete tables/figures or table-ready numeric results, not only prose summaries. Numeric values must be checked against source artifacts before they are used.
8. Comparative analysis: baseline comparison, mechanism interpretation, sensitivity/ablation, and failure or boundary cases.
9. Discussion and conclusion with scoped claims.
10. References with no placeholders, no uncited entries, and enough bibliographic detail for the venue.

If any item is missing, the result may still be useful as a drafting artifact, but it cannot pass the 8-9 full-paper gate. The correct status is `blocked below 8-9 full-paper completeness`, with the first repair action naming the missing manuscript part.

## Complete Bounded Drafts

When the user needs a working draft before the evidence reaches the 8-9 gate, write the most complete bounded draft supported by the current evidence and attach a short missing-evidence list. Do not fill missing references, experiments, baselines, equations, or table values with placeholders that look like facts. The draft remains below `submission-ready` until the review-closure gate and full-paper completeness gate pass.

## Score Repair Discipline

Draft once, review once, then repair the lowest-scoring category before polishing.

Common repairs:

- Problem score low: replace broad background with a specific operational or mathematical failure mode.
- Innovation score low: turn packaging language into a precise technical object or retarget the venue.
- Logic-chain score low: remove gaps that do not motivate a deliverable, and remove deliverables without evidence.
- Model score low: define variables, assumptions, constraints, and information timing near the equations.
- Evidence score low: add baseline, metric direction, system/scenario, sensitivity, boundary wording, or source-checked result provenance.
- Reproducibility score low: add an implementation-parameter table or algorithm box covering solver, tolerance, hyperparameters, initialization, software/hardware, and stopping criteria.
- Reference score low: replace placeholders with traceable literature, remove uncited entries, and align each citation with a sentence-level role.
- Claim-boundary score low: downgrade superiority, robustness, scalability, privacy, real-time, or deployability claims.
- Writing score low: run reader-burden, rhythm, and anti-AI passes after the technical repair.

Do not spend the repair loop on wording while any technical category is below the target band.

## Venue-Specific 8-9 Signals

### CSEE

8-9 drafts show a mechanism-model-evidence chain. The case study must verify the mechanism rather than only report that the method ran. Avoid replacing the contribution with policy background or broad engineering value.

### AEPS

8-9 drafts are operationally scannable: variables, objectives, constraints, scenario timing, baselines, and metrics appear where an automation/control/dispatch reader expects them. Avoid long conceptual motivation without an operating protocol.

For scenario-generation or mechanism-reproduction papers, the 8-9 target can be valid without completed power-flow risk propagation only when the title, abstract, contribution, and conclusion are all restricted to scenario or mechanism generation. Report applicable sample counts separately from not-applicable samples. If the manuscript claims node-level propagation, N-1 risk reduction, dispatch improvement, or probabilistic power-flow closure, require the corresponding grid-risk evidence before passing the 8-9 gate.

### IEEE TPWRS

8-9 drafts are formulation-led. Assumptions, constraints, reformulation or algorithmic tractability, baselines, and boundary tests must align with the same claim. Screening evidence must not be written as calibrated prediction.

For risk-screening or contingency-screening papers, an 8-9 TPWRS target also needs an independent reference check for screening quality. At least one high-priority case should be checked against a stronger calculation, replay, AC-MC benchmark, operator label, or other reference suitable for the claimed screening object. Without that check, keep the paper below the 8-9 full-paper gate even if the ranking and attribution evidence is internally consistent.

Planned validation code does not count as this reference check. Require a result artifact, table, log, manifest, or reviewed output that shows the stronger check was actually run and how the screened candidates behaved.

If the independent reference check does not identify the same top candidate as the closed-form screening score, do not hide the mismatch or call it validation. Repair the paper object: write a two-stage or boundary-diagnosis screening claim only when the evidence supports complementary screening roles. Keep the draft below the 8-9 gate if the manuscript still claims direct ranking equivalence after contradictory reference evidence appears.

### IEEE TSG

8-9 drafts keep the smart-grid layer attached to grid operation. Data, learning, edge, communication, privacy, cyber, or distributed-control claims need the matching grid-side metric and test condition.

For edge-update or data-refresh papers, separate the evidence dimensions before assigning an 8-9 target: voltage/distribution accuracy, risk-ranking preservation, runtime or resource state, and feeder/scope exclusions. A strong result on one dimension must not be generalized to the others. If a larger feeder is used mainly for scaling or scope checks, write it that way and keep risk-ranking claims tied to the feeder where the risk metrics are strong.

## Output Boundary

Do not write "this reaches 8-9" inside manuscript prose. If reporting maintenance results, state the score-target status separately from the manuscript text and identify the category that would most likely prevent the score.

For score-target run files, always separate:

- `Package diagnostic score`: score for the compressed artifact or section, if useful.
- `Full-paper readiness`: `complete manuscript`, `section-level only`, or `compressed evaluation package only`.
- `Gate status`: use `passes 8-9 full-paper gate` only for complete manuscripts. Use `blocked below 8-9 full-paper completeness` for compressed artifacts.
