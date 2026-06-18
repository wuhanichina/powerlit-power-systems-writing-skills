# Internal Readiness Writing Gate

Use this reference when the user asks for a manuscript that should be internally ready for serious submission review, or when maintaining evaluation cases that target high readiness.

This gate produces a `PowerLit Internal Readiness Index`. It is not a journal reviewer score, not an acceptance threshold, and not an acceptance-probability estimate.

## Core Rule

Internal readiness is not a style target. Fluent prose cannot compensate for a weak technical object, missing method facts, thin case evidence, or an unsupported conclusion.

Before drafting, build a readiness packet:

- target venue and paper type;
- technical object that will be reviewed;
- PowerLit evidence-strength profile for the same venue and claim class when the corpus is available;
- actual case-study evidence, not only intended experiments;
- baselines and fairness protocol;
- metrics with units, directions, and decision thresholds;
- result provenance: exact source table, CSV, report, log, figure data, or manifest for every quantitative result that will appear in the manuscript;
- section-by-section claim boundary;
- target readiness state and the weakest likely dimension.

If the packet is incomplete, write the strongest bounded section possible and state that the current packet cannot support full-manuscript readiness.

## Full-Manuscript Readiness Minimum

A full-paper draft may target `MANUSCRIPT_REVIEW_READY` only when all of these are true:

- the problem is venue-relevant and specific;
- the contribution is a reviewable model, formulation, mechanism, estimator, controller, certificate, application insight, or evidence insight appropriate to the paper type;
- accepted PowerLit papers for the same venue or claim class have been used to identify manuscript-facing evidence dimensions, or the draft explicitly states literature-limited fallback;
- the manuscript contains a complete method/model section with variables, assumptions, equations, algorithms, physical interpretation, and reproducibility details;
- the manuscript contains a complete case-study section with system setup, scenario construction, parameter settings, baselines, metrics with units, comparison tables or figures, result analysis, sensitivity or ablation when the claim depends on it, and boundary discussion;
- the manuscript contains a literature/novelty argument or a supplied PowerLit novelty boundary sufficient for the venue;
- no reference placeholder, "to be verified" note, missing citation role, or uncited reference remains in the manuscript-facing reference list;
- every reported runtime, error, distance, residual, rank, or feasibility number is traceable to an inspected result artifact and matches that artifact after rounding;
- the results discussion interprets why the method behaves as observed, not only whether metrics are numerically higher or lower;
- the conclusion is narrower than or equal to the demonstrated evidence;
- PowerLit near-neighbor risk has been checked or the draft states fallback limitations.

Case-analysis evidence alone can support `SECTION_READY` for a case-study section only. It cannot support full-manuscript readiness without the method object and novelty boundary.

A compressed evaluation package, outline, abstract-plus-results draft, or representative full-paper package is not a full paper. It must be labeled as package-level or section-level, and its readiness state must be `BLOCKED` unless the complete manuscript text and required tables/equations are present.

## Diagnostic or Inverse-Method Gate

When the proposed method is diagnostic, inverse, certifying, or otherwise complementary to a strong forward baseline, do not treat structural novelty as enough for full-manuscript readiness.

Keep the draft below `MANUSCRIPT_REVIEW_READY` when the most relevant baseline is better on the primary accuracy and runtime metrics unless all of these are manuscript-facing:

- a non-substitutable operating scenario explaining why the baseline or standard forward method cannot directly answer the problem;
- evidence that the proposed method solves that scenario's distinct need, such as identifiability, feasibility certification, observability-limited reconstruction, or failure diagnosis;
- a table or paragraph that explicitly separates baseline accuracy from the proposed method's diagnostic or inverse value;
- conclusion wording that does not imply accuracy or speed superiority when the tables do not show it.

If a core module is disabled, replaced by a baseline, or selected by an after-the-fact setting in any main case study, the manuscript must label that fallback in the table caption, row label, abstract-level claim, and conclusion. Do not pass the readiness gate until the paper either adds a transition/boundary experiment showing when the module should be on or narrows the claim to the systems where the module actually ran.

When the same metric name appears in SOTA comparison, sensitivity analysis, and ablation tables, verify that the post-processing and aggregation scope are identical before using the numbers side by side. If they differ, write the result as a within-experiment trend or separate it into a different table; do not use it as cross-table evidence.

## Full-Paper Completeness Gate

Before assigning full-manuscript readiness, check that the draft includes all of these manuscript-facing parts:

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

If any item is missing, the result may still be useful as a drafting artifact, but it cannot pass full-manuscript readiness. The correct state is `BLOCKED`, with the first repair action naming the missing manuscript part.

## Complete Bounded Drafts

When the user needs a working draft before the evidence reaches the readiness gate, write the most complete bounded draft supported by the current evidence and attach a short missing-evidence list. Do not fill missing references, experiments, baselines, equations, or table values with placeholders that look like facts. The draft remains below `submission-ready` until the review-closure gate and full-paper completeness gate pass.

## Readiness Repair Discipline

Draft once, review once, then repair the lowest-readiness dimension before polishing.

Common repairs:

- Problem dimension low: replace broad background with a specific operational or mathematical failure mode.
- Innovation dimension low: turn packaging language into a precise technical object or retarget the venue.
- Logic-chain dimension low: remove gaps that do not motivate a deliverable, and remove deliverables without evidence.
- Model dimension low: define variables, assumptions, constraints, and information timing near the equations.
- Evidence dimension low: add baseline, metric direction, system/scenario, sensitivity, boundary wording, or source-checked result provenance.
- Reproducibility dimension low: add an implementation-parameter table or algorithm box covering solver, tolerance, hyperparameters, initialization, software/hardware, and stopping criteria.
- Reference dimension low: replace placeholders with traceable literature, remove uncited entries, and align each citation with a sentence-level role.
- Claim-boundary dimension low: downgrade superiority, robustness, scalability, privacy, real-time, or deployability claims.
- Writing dimension low: run reader-burden, rhythm, and anti-AI passes after the technical repair.

Do not spend the repair loop on wording while any technical dimension is below the target readiness state.

## Venue-Specific Readiness Signals

### CSEE

Ready drafts show a mechanism-model-evidence chain. The case study must verify the mechanism rather than only report that the method ran. Avoid replacing the contribution with policy background or broad engineering value.

### AEPS

Ready drafts are operationally scannable: variables, objectives, constraints, scenario timing, baselines, and metrics appear where an automation/control/dispatch reader expects them. Avoid long conceptual motivation without an operating protocol.

For scenario-generation or mechanism-reproduction papers, full-manuscript readiness can be valid without completed power-flow risk propagation only when the title, abstract, contribution, and conclusion are all restricted to scenario or mechanism generation. Report applicable sample counts separately from not-applicable samples. If the manuscript claims node-level propagation, N-1 risk reduction, dispatch improvement, or probabilistic power-flow closure, require the corresponding grid-risk evidence before passing the readiness gate.

### IEEE TPWRS

Ready drafts are formulation-led. Assumptions, constraints, reformulation or algorithmic tractability, baselines, and boundary tests must align with the same claim. Screening evidence must not be written as calibrated prediction.

For risk-screening or contingency-screening papers, TPWRS readiness also needs an independent reference check for screening quality. At least one high-priority case should be checked against a stronger calculation, replay, AC-MC benchmark, operator label, or other reference suitable for the claimed screening object. Without that check, keep the paper below `MANUSCRIPT_REVIEW_READY` even if the ranking and attribution evidence is internally consistent.

Planned validation code does not count as this reference check. Require a result artifact, table, log, manifest, or reviewed output that shows the stronger check was actually run and how the screened candidates behaved.

If the independent reference check does not identify the same top candidate as the closed-form screening score, do not hide the mismatch or call it validation. Repair the paper object: write a two-stage or boundary-diagnosis screening claim only when the evidence supports complementary screening roles. Keep the draft below the readiness gate if the manuscript still claims direct ranking equivalence after contradictory reference evidence appears.

### IEEE TSG

Ready drafts keep the smart-grid layer attached to grid operation. Data, learning, edge, communication, privacy, cyber, or distributed-control claims need the matching grid-side metric and test condition.

For edge-update or data-refresh papers, separate the evidence dimensions before assigning readiness: voltage/distribution accuracy, risk-ranking preservation, runtime or resource state, and feeder/scope exclusions. A strong result on one dimension must not be generalized to the others. If a larger feeder is used mainly for scaling or scope checks, write it that way and keep risk-ranking claims tied to the feeder where the risk metrics are strong.

## Output Boundary

Do not write readiness labels inside manuscript prose. If reporting maintenance results, state the readiness result separately from the manuscript text and identify the dimension that most likely blocks advancement.

For readiness run files, always separate:

- `Package diagnostic readiness`: readiness for the compressed artifact or section, if useful.
- `Full-paper readiness`: `complete manuscript`, `section-level only`, or `compressed evaluation package only`.
- `Readiness state`: `BLOCKED`, `SECTION_READY`, `MANUSCRIPT_REVIEW_READY`, or `SUBMISSION_CANDIDATE`.
