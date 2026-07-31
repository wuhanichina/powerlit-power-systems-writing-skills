# Evidence, Case Study, and Conclusion Review

Use this reference for 算例分析, 仿真验证, 实验验证, numerical results, case studies, and conclusions.

## Case-Study Gate

A case section must test the innovation. It should state:

- test system or engineering platform;
- data source and preprocessing if relevant;
- operating scenarios, disturbances, or uncertainty settings;
- baseline methods and why they are fair;
- metrics with units;
- solver, tolerance, hardware, or implementation details when they affect the claim;
- sensitivity, ablation, or boundary cases when the method has parameters or modules.

Reject risk is high when:

- only one base case is shown;
- no baseline is used for a superiority claim;
- the method claims robustness but no disturbance, uncertainty, or out-of-sample case is tested;
- the method claims scalability but no larger system or runtime analysis is shown;
- figures and tables are described but not interpreted;
- numerical gains are reported without explaining their operational meaning.
- a composite case attributes one observed pattern to several competing factors without a matched baseline, ablation, one-factor sweep, stratification, intervention, or counterfactual;
- a mechanism is stated as causal when the evidence only shows an outcome consistent with that mechanism;
- the expected trend is copied from the case plan and reported as if it were an observation.

For each central mechanism claim, separate `expectation`, `observation`, `quantitative comparison`, `mechanism status`, and `claim consequence`. Accept `isolated` only when competing causes are controlled. Otherwise require `consistent with` or hypothesis wording and identify the missing intermediate quantity or control.

## Venue Expectations

中国电机工程学报:

- expects fuller engineering explanation and often richer simulation/experiment detail;
- case evidence should support mechanism and engineering applicability.

电力系统自动化:

- expects lean but complete validation for the submitted object, including operation/control/dispatch validation only when those are the claims;
- scenarios, baselines, and metrics should be easy to scan.

IEEE TPWRS:

- expects concise but rigorous baselines, metrics, and reproducibility;
- numerical tests should map directly to formulation and algorithm claims.

IEEE TSG:

- expects smart-grid realism when claimed: data quality, DER behavior, communication/control limits, distribution operation, learning generalization, or cyber-physical constraints.

IEEE Letter:

- expects minimal but decisive evidence, not comprehensive validation.

## Conclusion Gate

The conclusion should:

- restate the technical object;
- summarize verified findings, not manuscript actions;
- use numbers only if already supported;
- state limitations or future work only when useful;
- avoid broad claims about "fundamentally solving", "completely improving", or "true realization" unless proven.

Reject-risk conclusions:

- claim engineering deployment from simulation-only evidence;
- claim generality from one benchmark;
- repeat the abstract without findings;
- introduce new contributions not tested in the paper;
- overstate small numerical differences.
