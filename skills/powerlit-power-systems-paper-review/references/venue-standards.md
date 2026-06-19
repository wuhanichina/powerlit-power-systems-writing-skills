# Venue-Specific Review Standards

Use this reference to judge venue fit and acceptance risk.

Before applying venue standards, identify the manuscript's research object: power-system object, problem type, technical object, evidence object, and adjacent non-objects. A venue standard can reject or redirect a mismatch, but it must not rewrite the manuscript into the venue's common topic.

## 中国电机工程学报

Expected paper shape:

- clear supplied engineering object and physical mechanism, estimator, certificate, model, or application insight;
- sufficient model/control/optimization/estimation/certification depth for the supplied object;
- detailed simulation, experiment, or engineering case;
- conclusions that connect to engineering applicability.

Reject-risk patterns:

- policy-heavy motivation but weak technical object;
- method section lacks physical mechanism or model details;
- case study is shallow compared with the breadth of the claim;
- "工程实用性" is claimed without scenario, data, device, or implementation evidence.

Review stance: tolerate broader engineering explanation, but demand a real mechanism-model-evidence chain.

## 电力系统自动化

Expected paper shape:

- compact technical problem in the submitted power-system object;
- explicit relevant variables, objectives, constraints, states, indices, time scale, and information structure;
- focused validation for the submitted object, including dispatch/control/operation validation only when those are the actual claims;
- concise conclusion, often with practical boundary or follow-up direction.

Reject-risk patterns:

- long background before the concrete submitted problem appears;
- model and solving procedure are not easy to scan;
- case study lacks comparison, operating scenarios, or sensitivity;
- text claims "有效性/可行性" without showing which constraint, metric, or scenario proves it.

Review stance: favor clarity, operational relevance, and complete validation over broad conceptual claims.

Do not mark a manuscript as better aligned with any venue by rewriting its core into that venue's common topic. Judge the original object first, then assess whether the venue's model-evidence rhythm fits it.

## IEEE TPWRS

Expected paper shape:

- object-preserving, formulation-led contribution when the supplied research object supports it;
- explicit assumptions, sets, indices, variables, uncertainty, information timing;
- original model separated from reformulation, relaxation, approximation, or algorithm when those components are claimed;
- case studies with baselines, metrics, and reproducibility details;
- contribution list with concrete deliverables.

Reject-risk patterns:

- contribution is a framework label rather than a formulation or algorithmic advance;
- assumptions are hidden or only appear in the case study;
- method novelty depends on an approximation whose error or boundary is not discussed;
- validation does not include relevant baselines or scalability checks when claimed.
- venue drift adds optimization, planning, guarantee, or security-constraint claims that are not in the manuscript object.

Review stance: be strict on mathematical clarity, novelty relative to existing formulations, and claim-evidence alignment.

## IEEE TSG

Expected paper shape:

- supplied smart-grid mechanism: data, communication, distributed coordination, DER/grid-edge control, cyber-physical operation, markets, learning/control integration, resilience, or active distribution network operation;
- clear distinction between algorithmic novelty and power-system insight;
- evidence on realistic smart-grid settings, data, uncertainty, or communication constraints.

Reject-risk patterns:

- generic ML/control method with only a power-grid dataset attached;
- no physical constraint, operational boundary, or grid-side interpretation;
- data-driven method lacks robustness, generalization, or benchmark comparison;
- communication/privacy/distribution claims are not tested.
- venue drift adds a DER, data, communication, privacy, cyber, or distributed layer that is not in the manuscript object.

Review stance: require both methodological substance and power-system operational meaning.

## IEEE Power-System Letter

Expected paper shape:

- one hard claim;
- one compact formulation, derivation, counterexample, or algorithmic trick;
- minimal but decisive evidence;
- short conclusion.

Official page rule checked 2026-06-18:

- original submissions: at most 3 formatted pages;
- revisions: at most 3.5 formatted pages;
- accepted letter after revision and editing: should not exceed 4 pages.

Reject-risk patterns:

- full-paper scope squeezed into four pages;
- multiple contributions with no single sharp claim;
- long literature review;
- technical core requires many assumptions or modules to understand;
- validation is broad but not decisive.

Review stance: judge sharpness and necessity. A Letter can be narrow, but it cannot be vague.

## Paper Type Handling

Identify the paper type before judging novelty:

- Research Paper: require a new or materially improved model, mechanism, theorem, algorithm, controller, estimator, certificate, or evidence insight.
- Application Paper: engineering integration or system deployment value is not an automatic rejection reason. Judge realistic system evidence, transferable operating insight, implementation detail, and whether the application teaches something beyond a one-off demonstration.
- Review Paper: judge coverage, taxonomy, synthesis, source balance, and whether the review creates a useful map for the field.
- Letter: judge one hard claim, compact technical core, and decisive evidence under the Letter page rules.

## Journal Recommendation

If the direction is technically meaningful but not fit for the target:

- engineering mechanism and device/system validation: consider 中国电机工程学报;
- operation/control/dispatch automation with compact evidence: consider 电力系统自动化;
- rigorous formulation, optimization, market, stability, reliability, or planning contribution: consider TPWRS;
- smart-grid data, DER, cyber-physical, distributed control, learning-enabled grid operation: consider TSG;
- one equation, one counterexample, one analytical correction, or one compact trick: consider Letter.
