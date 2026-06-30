# Venue Profiles

Use this reference after the research object and target venue are known. It is the routing layer between the shared writing workflow and the venue-specific references.

## Profile Contract

Load `references/research-object-gate.md` before this file. For each venue, lock these choices after the research object is identified:

- manuscript object: formulation, mechanism, control strategy, estimator, algorithm, engineering verification, or operational rule;
- introduction rhythm: how quickly the gap and proposal appear;
- method depth: how much modeling, derivation, and algorithm detail is expected;
- evidence bar: systems, baselines, metrics, sensitivity, and boundary tests;
- register: sentence rhythm, contribution language, and forbidden overclaims.

Venue profiles are not topic converters. Preserve the manuscript's supplied research object first, then adjust rhythm, section order, evidence emphasis, and register. Do not introduce dispatch, operation, planning, smart-grid, DER, privacy, cyber, formulation, guarantee, or engineering-implementation claims only because a venue profile often contains those objects.

## 中国电机工程学报

Load `references/csee.md` and `references/csee-precision.md`.

- Best fit: engineering mechanism, model construction, control/optimization strategy, estimator, certificate, device/system validation, practical operating problem, or application paper with transferable engineering evidence.
- Introduction rhythm: context appears briefly, then the supplied technical object and unresolved problem arrive early.
- Method depth: dense but readable. Equations, variables, assumptions, and engineering meaning should appear close together for the supplied object.
- Evidence bar: case study, simulation, or experiment must verify the supplied mechanism, model, estimator, certificate, or application insight, not merely demonstrate that code runs.
- Register: formal Chinese engineering prose. Prefer precise verbs such as 建立, 构建, 推导, 计及, 约束, 验证.
- Main rejection risk: policy background, broad engineering value, or "practical significance" replacing the actual object-problem-method-evidence chain; venue drift that inflates a narrow algorithm, estimator, or certificate into unsupported engineering implementation.

## 电力系统自动化

Load `references/aeps.md`.

- Best fit: compact automation/control/protection/coordination, market/DR, frequency/voltage/security, forecasting, estimation, resilience, implementation-oriented methods, or dispatch/operation when that is the actual paper object.
- Introduction rhythm: short path from the original power-system setting to the model, strategy, estimator, criterion, algorithm, or verification.
- Method depth: compact object-preserving logic. The relevant variables, objectives, constraints, states, indices, information timing, assumptions, and solution or evaluation flow should be easy to scan.
- Evidence bar: baselines, scenarios, and metrics that prove the submitted technical object; sensitivity or disturbance response when it supports the claim.
- Register: concise Chinese technical prose. Sequencing words are acceptable when they carry real model-solution-evidence progression.
- Main rejection risk: long conceptual motivation, vague "new power system" wording, metrics that do not prove the claim, or venue drift that rewrites a non-dispatch paper into dispatch/operation/planning prose.

## IEEE TPWRS

Load `references/tpwrs.md`.

- Best fit: formulation, optimization, market mechanism, reliability, stability, planning, estimator, security constraint, relaxation, decomposition, certificate, algorithm, or guarantee when those are the supplied research objects.
- Introduction rhythm: longer method landscape is acceptable; the contribution list should be explicit, technical, and tied to the supplied object.
- Method depth: assumption-explicit and formulation-led when the paper has a formulation object. Separate physical model, approximation/reformulation, guarantee or limitation, and algorithm only when those components are actually claimed.
- Evidence bar: IEEE or realistic systems, relevant baselines, scenario coverage, metrics with units, solver/hardware when runtime is claimed, and boundary tests for strong claims.
- Register: direct English with method objects as grammatical subjects.
- Main rejection risk: contribution list without deliverables, weak baselines, hidden assumptions, case studies that do not test the claimed property, or venue drift that adds optimization/planning/guarantee language to a paper without that object.

## IEEE TSG

Load `references/tsg.md`.

- Best fit: smart-grid data, DER/distribution operation, microgrids, grid-edge control, cyber-physical security, communication/privacy constraints, distributed control, learning-enabled operation, or demand response when that layer is present in the supplied object and evidence.
- Introduction rhythm: similar to TPWRS, but the supplied data, learning, communication, DER, or cyber layer must stay attached to grid operation.
- Method depth: physical constraints, information structure, data assumptions, communication/privacy conditions, and implementation setting must be explicit when they are part of the claim.
- Evidence bar: grid-side metrics plus the claimed smart-grid condition: generalization for learning, communication burden for distributed control, attack scenarios for cyber claims, privacy metric for privacy claims, and runtime/scalability when claimed.
- Register: English smart-grid mechanism prose, not generic AI/ML prose.
- Main rejection risk: treating a power-grid dataset as the contribution, making privacy/distributed/scalability claims without testing them, losing the physical grid mechanism, or venue drift that adds a smart-grid layer not present in the supplied paper.

## Routing Defaults

Routing is object-first. When no venue is specified, match the supplied research object to a venue using the object defaults below; use the IEEE TPWRS default only as a last-resort tiebreaker when the object does not clearly select a venue. This ordering must stay consistent with `SKILL.md` step 2.

- Run the research-object gate before routing. Route by the supplied object, not by the venue's most common published topic.
- If the manuscript's center is formulation, security constraint, reliability, market, stability, or planning, default to TPWRS unless the smart-grid layer is central.
- If the center is DER, data-driven operation, communication/privacy, cyber-physical security, distributed control, or grid-edge implementation, default to TSG.
- If the center is a Chinese engineering mechanism with broader system explanation, default to 中国电机工程学报.
- If the center is compact operational automation or dispatch/control logic, default to 电力系统自动化.
- Last-resort tiebreaker only: if the object does not clearly select a venue, default to IEEE TPWRS for routing and evidence standards. Regardless of the routed venue, produce the first manuscript draft in Chinese unless the user asks for English or final IEEE conversion.
- If the user specifies a venue whose profile does not fit the supplied object, preserve the object and either adapt with an explicit venue-fit warning or recommend retargeting; do not silently add the missing venue object.
- If the contribution is one narrow analytical point, counterexample, correction, compact formulation, or decisive observation, route away from this skill and use `ieee-power-engineering-letter-writing`.
