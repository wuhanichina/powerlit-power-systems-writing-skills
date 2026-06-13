# Venue Profiles

Use this reference after the target venue is known. It is the routing layer between the shared writing workflow and the venue-specific references.

## Profile Contract

For each venue, lock these choices before drafting:

- manuscript object: formulation, mechanism, control strategy, estimator, algorithm, engineering verification, or operational rule;
- introduction rhythm: how quickly the gap and proposal appear;
- method depth: how much modeling, derivation, and algorithm detail is expected;
- evidence bar: systems, baselines, metrics, sensitivity, and boundary tests;
- register: sentence rhythm, contribution language, and forbidden overclaims.

## 中国电机工程学报

Load `references/csee.md` and `references/csee-precision.md`.

- Best fit: engineering mechanism, model construction, control/optimization strategy, device/system validation, or practical operating problem.
- Introduction rhythm: context appears briefly, then the technical object and unresolved mechanism arrive early.
- Method depth: dense but readable. Equations, variables, assumptions, and engineering meaning should appear close together.
- Evidence bar: case study, simulation, or experiment must verify the mechanism, not merely demonstrate that code runs.
- Register: formal Chinese engineering prose. Prefer precise verbs such as 建立, 构建, 推导, 计及, 约束, 验证.
- Main rejection risk: policy background, broad engineering value, or "practical significance" replacing the actual mechanism-model-evidence chain.

## 电力系统自动化

Load `references/aeps.md`.

- Best fit: dispatch, automation, control, protection, coordination, operational optimization, market/DR, frequency/voltage/security, or source-grid-load-storage operation.
- Introduction rhythm: short path from operating scenario to model/strategy and verification.
- Method depth: compact operational logic. Decision variables, objective, constraints, information timing, and solution flow should be easy to scan.
- Evidence bar: baselines, scenarios, and metrics with operational meaning; sensitivity or disturbance response when it supports the claim.
- Register: concise Chinese technical prose. Sequencing words are acceptable when they carry real model-solution-evidence progression.
- Main rejection risk: long conceptual motivation, vague "new power system" wording, or metrics that do not prove the operational claim.

## IEEE TPWRS

Load `references/tpwrs.md`.

- Best fit: formulation, optimization, market mechanism, reliability, stability, planning, estimator, security constraint, relaxation, decomposition, or guarantee.
- Introduction rhythm: longer method landscape is acceptable; the contribution list should be explicit and technical.
- Method depth: assumption-explicit and formulation-led. Separate physical model, approximation/reformulation, guarantee or limitation, and algorithm.
- Evidence bar: IEEE or realistic systems, relevant baselines, scenario coverage, metrics with units, solver/hardware when runtime is claimed, and boundary tests for strong claims.
- Register: direct English with method objects as grammatical subjects.
- Main rejection risk: contribution list without deliverables, weak baselines, hidden assumptions, or case studies that do not test the formulation's claimed property.

## IEEE TSG

Load `references/tsg.md`.

- Best fit: smart-grid data, DER/distribution operation, microgrids, grid-edge control, cyber-physical security, communication/privacy constraints, distributed control, learning-enabled operation, or demand response.
- Introduction rhythm: similar to TPWRS, but the data, learning, communication, or cyber layer must stay attached to grid operation.
- Method depth: physical constraints, information structure, data assumptions, communication/privacy conditions, and implementation setting must be explicit.
- Evidence bar: grid-side metrics plus the claimed smart-grid condition: generalization for learning, communication burden for distributed control, attack scenarios for cyber claims, privacy metric for privacy claims, and runtime/scalability when claimed.
- Register: English smart-grid mechanism prose, not generic AI/ML prose.
- Main rejection risk: treating a power-grid dataset as the contribution, making privacy/distributed/scalability claims without testing them, or losing the physical grid mechanism.

## Routing Defaults

- If the manuscript's center is formulation, security constraint, reliability, market, stability, or planning, default to TPWRS unless the smart-grid layer is central.
- If the center is DER, data-driven operation, communication/privacy, cyber-physical security, distributed control, or grid-edge implementation, default to TSG.
- If the center is a Chinese engineering mechanism with broader system explanation, default to 中国电机工程学报.
- If the center is compact operational automation or dispatch/control logic, default to 电力系统自动化.
- If the contribution is one narrow analytical point, counterexample, correction, compact formulation, or decisive observation, route away from this skill and use `ieee-power-engineering-letter-writing`.
