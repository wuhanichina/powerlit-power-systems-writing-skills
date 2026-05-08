# IEEE TSG Writing Reference

## Corpus Signal

PowerLit mining used 209 IEEE Transactions on Smart Grid full papers from the local JSON corpus and compared them with 553 IEEE TPWRS full papers.

- Median page count: 14.
- Abstracts: median 8 sentences; median sentence length about 23 words.
- Introductions: median 12 paragraphs; explicit contribution markers in about 73.2% of papers.
- Method sections: present in 99.5% of papers; median 62 method paragraphs.
- Case/result sections: present in 99.5% of papers; median 15 case/result paragraphs.
- Median references: 38.
- Compared with TPWRS, TSG has similar full-paper structure but stronger emphasis on data, distributed coordination, DER/distribution operation, learning-enabled control, communication/cyber/privacy constraints, and grid-edge mechanisms.

Use this to write like TSG, not like generic AI/ML or generic TPWRS.

## Register

TSG values smart-grid mechanisms with power-system meaning. A TSG paper can use data-driven, distributed, learning-based, communication-aware, cyber-physical, or DER-focused methods, but the contribution must still resolve a grid-operational problem.

Prefer:

- "This paper proposes/presents/develops..."
- "The proposed distributed control scheme..."
- "The data-driven estimator preserves..."
- "The communication/privacy constraint is incorporated by..."
- "Numerical tests on distribution feeders/microgrids/DER systems show..."

Avoid:

- treating a power-grid dataset as sufficient power-system contribution;
- generic ML claims such as "state-of-the-art accuracy" without grid metrics;
- broad "smart grid framework" language without an operational mechanism;
- claiming privacy, distributed implementation, scalability, or real-time performance without testing the corresponding condition.

## Abstract

Recommended shape:

1. One sentence for smart-grid setting and operational difficulty.
2. One sentence for the technical object: distributed control, estimator, learning policy, cyber-physical detector, DER coordination, market/DR mechanism, or data-driven model.
3. Two to four sentences for mechanism: information structure, physical constraints, communication/privacy setting, learning/control formulation, or optimization.
4. One sentence for grid-side evidence and metrics.
5. Optional boundary sentence if the claim depends on data availability, communication assumptions, topology, or DER behavior.

Use "This paper" once if useful. After that, make the method object, data mechanism, controller, estimator, or constraint the subject.

## Introduction

Use a TSG introduction arc:

1. Smart-grid context: DERs, active distribution networks, microgrids, demand response, EVs, grid-edge control, cyber-physical operation, or data-driven monitoring.
2. Operational consequence: voltage/security/frequency/resilience/market/coordination/privacy/reliability issue.
3. Existing method classes: optimization/control, data-driven/learning, distributed/communication-aware, cyber-physical/security, or market/DR.
4. Exact gap: missing physical constraint, weak generalization, unmodeled communication/privacy limit, poor scalability, unrealistic information timing, or lack of operational interpretability.
5. Contribution list with concrete deliverables and grid-side validation.

Do not let the introduction read like an ML paper. Every data or learning claim should be tied to a grid constraint, operational metric, or physical interpretation.

## Method And Formulation

Use section names such as:

- `II. SYSTEM MODEL`
- `II. PROBLEM FORMULATION`
- `III. PROPOSED METHOD`
- `III. DATA-DRIVEN / DISTRIBUTED / CYBER-PHYSICAL METHOD`
- `IV. CASE STUDY`

State clearly:

- grid object: feeder, DER fleet, microgrid, market participants, sensors, communication graph, or cyber-physical layer;
- information structure: centralized, distributed, local measurements, delayed communication, privacy, or online data;
- physical constraints: power flow, voltage/current limits, inverter capability, storage dynamics, frequency or stability conditions;
- data assumptions: training/test split, forecast horizon, noise, missing data, attack model, domain shift, or generalization setting;
- algorithmic property: convergence, scalability, privacy, robustness, or real-time performance only if demonstrated.

## Case Studies

TSG case studies should make the smart-grid claim observable:

- distribution feeders, microgrids, DER/EV/storage systems, smart meters, or cyber-physical test systems;
- communication, privacy, attack, uncertainty, data quality, or distributed implementation conditions when claimed;
- baselines from both power-system operation and relevant data/control methods;
- metrics with operational meaning: voltage violation, load restoration, frequency nadir/RoCoF, DER utilization, market cost, privacy leakage, detection rate, communication burden, runtime, or out-of-sample performance.

For learning/data-driven papers, include generalization and robustness checks when the claim depends on them. For distributed/cyber-physical papers, include communication or attack scenarios when those are central.

## Conclusion

Use a short paragraph or concise bullets. State what was established in grid terms. Avoid closing with generic AI or smart-grid transformation claims.
