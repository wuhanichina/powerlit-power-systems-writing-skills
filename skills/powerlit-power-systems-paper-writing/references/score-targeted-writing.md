# Score-Targeted Writing Gate

Use this reference when the user asks for a manuscript that should reach a target review score, such as 8-9 points, or when maintaining evaluation cases that explicitly target high review scores.

## Core Rule

An 8-9 score is not a style target. It is a review-strength target. Fluent prose cannot compensate for a weak technical object, missing method facts, thin case evidence, or an unsupported conclusion.

Before drafting, build a score-target packet:

- target venue and paper type;
- technical object that will be reviewed;
- actual case-study evidence, not only intended experiments;
- baselines and fairness protocol;
- metrics with units, directions, and decision thresholds;
- section-by-section claim boundary;
- expected review-score band and the weakest likely category.

If the packet is incomplete, write the strongest bounded section possible and state that the current packet cannot support an 8-9 full-paper target.

## 8-9 Full-Paper Minimum

A full-paper draft may target 8-9 only when all of these are true:

- the problem is venue-relevant and specific;
- the contribution is a reviewable model, formulation, mechanism, estimator, controller, certificate, or evidence insight;
- method facts include variables, assumptions, equations or algorithms, and reproducibility details;
- case evidence includes at least one main system, relevant baselines, metrics with units, and a boundary or sensitivity test when the claim depends on it;
- the conclusion is narrower than or equal to the demonstrated evidence;
- PowerLit near-neighbor risk has been checked or the draft states fallback limitations.

Case-analysis evidence alone can support an 8-9 case-study section only. It cannot support an 8-9 full-paper claim without the method object and novelty boundary.

## Score Repair Discipline

Draft once, review once, then repair the lowest-scoring category before polishing.

Common repairs:

- Problem score low: replace broad background with a specific operational or mathematical failure mode.
- Innovation score low: turn packaging language into a precise technical object or retarget the venue.
- Logic-chain score low: remove gaps that do not motivate a deliverable, and remove deliverables without evidence.
- Model score low: define variables, assumptions, constraints, and information timing near the equations.
- Evidence score low: add baseline, metric direction, system/scenario, sensitivity, or boundary wording.
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
