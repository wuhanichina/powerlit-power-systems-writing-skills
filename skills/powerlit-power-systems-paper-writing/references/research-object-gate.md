# Research Object Gate

Use this reference before venue routing, venue adaptation, drafting, review closure, or prewriting venue-fit judgment. The first task is to identify what problem the paper is actually about. The target journal comes after that.

## Object Map

Lock five items before loading a venue profile:

1. `power_system_object`: the grid, device, market, uncertainty source, data source, protection layer, control layer, planning horizon, resilience event, stability phenomenon, or feasibility boundary being studied.
2. `problem_type`: dispatch/operation, planning, protection, control, stability, reliability/risk/resilience, forecasting, estimation/identification, market/DR, device modeling, mathematical certification, algorithmic formulation, or engineering implementation.
3. `technical_object`: the model, formulation, mechanism, controller, estimator, index, criterion, algorithm, theorem, certificate, counterexample, validation protocol, or system implementation that the paper contributes.
4. `evidence_object`: the theorem, case system, simulation, experiment, field data, baseline, metric, sensitivity, ablation, or boundary case that tests the technical object.
5. `non_object`: adjacent topics that are not supported by the supplied title, method, variables, equations, or evidence.

If one item cannot be identified, state the assumption or blocker before drafting. Do not fill the gap by borrowing a topic from the target venue profile.

## Venue After Object

A venue profile may change:

- section order and paragraph rhythm;
- how quickly the gap appears;
- amount of derivation or implementation detail;
- evidence granularity, baselines, and metric presentation;
- Chinese or English register.

A venue profile must not change:

- the power-system object;
- the problem type;
- the technical object;
- the evidence object;
- the supported claim boundary.

When the requested target venue expects a different object, return a venue-fit warning or retargeting suggestion. Do not silently rewrite the paper into the venue's most common topic.

## Drift Checks

Flag venue drift before drafting if any of these occur:

- A dispatch, operation, or planning objective appears when the supplied method has no dispatch, operation, or planning variables.
- A smart-grid, DER, communication, privacy, cyber, or data-driven layer appears only because the target venue is TSG.
- A formulation, guarantee, or planning contribution appears only because the target venue is TPWRS.
- A broad engineering mechanism, device implementation, or system validation claim appears only because the target venue is 中国电机工程学报.
- A method object in the abstract differs from the one tested in the case section.

## Output Use

For writing tasks, keep this map internal unless the user asks for planning or diagnosis. For venue-fit, prewriting, review, or retargeting tasks, show the map briefly because it explains the recommendation.
