# Logic Chain and Innovation Review

Use this reference for title, abstract, introduction, contribution, and overall logic.

## Logic Chain

A publishable power-system paper should close this chain:

1. Operating context: what system, device, market, uncertainty, control layer, or planning setting is involved.
2. Technical contradiction: why existing practice or methods fail.
3. Key problem: what must be modeled, controlled, estimated, optimized, proven, or validated.
4. Proposed technical object: model, formulation, algorithm, control strategy, estimator, certificate, or dispatch mechanism.
5. Verification: which case, scenario, metric, baseline, or theorem tests the object.
6. Conclusion: what is now established and where it applies.

If any link is absent or changes topic, mark it as a major issue. If the method solves a different problem from the introduction, recommend rejection unless the paper can be reframed.

## Innovation Test

Ask four questions:

- Is the claimed pain point real for the target venue and current power-system practice?
- Is the unresolved part technical, not only a policy or engineering-management statement?
- Does the paper create or reveal a new technical object?
- Does validation prove the object, not only demonstrate a numerical improvement?

Strong innovation:

- captures a neglected physical coupling or operational constraint;
- reduces conservatism while preserving security;
- gives a tractable reformulation of a previously hard problem;
- improves observability, coordination, robustness, stability, or scalability with a clear mechanism;
- provides a counterexample or correction that changes how a known model should be used.

Weak innovation:

- combines known algorithms without a new coupling mechanism;
- changes a data source or test system only;
- tunes weights, thresholds, or solver settings;
- adds more objectives or constraints without explaining why the formulation is new;
- claims "higher accuracy" without a meaningful power-system metric or baseline.

## Introduction Review

High-level background should narrow quickly:

- broad grid transition;
- concrete operational consequence;
- method families and their limitations;
- exact technical reason for the gap;
- proposed solution and contributions.

Reject-risk introduction patterns:

- several paragraphs of general "new power system" context before the technical issue appears;
- literature is listed paper by paper rather than grouped by method class;
- limitations are generic, such as "accuracy is low" or "efficiency is insufficient";
- contribution bullets repeat section contents rather than stating deliverables.

## Title and Keywords

The title should name the technical object and target problem. Avoid titles that only list buzzwords.

Keywords should be no more than five unless the venue requires otherwise. They should include the system object, method object, and key application domain.
