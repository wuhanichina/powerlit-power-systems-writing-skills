# Venue- and Paper-Type Review Standards

Use this reference after classifying both the target venue and paper type. Venue fit is not a substitute for technical correctness, and a research-method paper must not be judged by the same novelty rule as an application paper or review paper.

Official rules change. Hard page, article-type, and submission requirements must be traced through `rule-sources.yaml` and rechecked when stale.

## Paper-Type Gate

### Research or Method Paper

Expected contribution: a reviewable theoretical result, model, formulation, algorithm, estimator, controller, mechanism, certificate, or evidence insight. Engineering integration alone may be insufficient when the manuscript claims method novelty.

### Application Paper

Expected contribution: valuable industry/system experience, a technically credible application of existing or adapted technology to a complex problem, transferable engineering knowledge, and evidence from a realistic implementation, field/system study, or operationally representative validation.

Do not reject an application paper solely because it combines established components. Reject-risk arises when the paper provides neither methodological advance nor transferable application knowledge, or when the engineering evidence cannot establish the claimed benefit.

### Review Paper

Expected contribution: explicit scope, reproducible search/selection method where appropriate, a defensible taxonomy, critical synthesis, gap analysis, and traceable coverage. A long list of papers is not sufficient.

### Letter

Expected contribution: one narrow hard claim supported by a compact derivation, counterexample, formulation, algorithmic result, or decisive observation. Apply current IEEE PES Letter page rules separately from corpus page statistics.

## 中国电机工程学报

Expected research-paper shape:

- explicit engineering object and physical mechanism;
- sufficient model, control, optimization, or theoretical depth;
- detailed simulation, experiment, or engineering case;
- conclusions bounded by the tested systems and conditions.

Application-oriented work should expose the system problem, implementation constraints, engineering decisions, and transferable evidence rather than rely on general “工程实用性”.

Reject-risk patterns include policy-heavy motivation, weak technical object, missing physical mechanism, shallow case evidence, or broad applicability claims without a corresponding system/scenario basis.

## 电力系统自动化

Expected shape:

- compact operating or automation problem;
- explicit variables, objective, constraints, time scale, information structure, and execution protocol;
- focused dispatch, control, protection, market, or operation validation;
- concise conclusion with operating boundary.

Reject-risk patterns include long conceptual motivation, an opaque solving procedure, absent operational baselines/scenarios, or claims of effectiveness without a named constraint, metric, and scenario.

## IEEE Transactions on Power Systems

Research papers normally require a formulation-, theory-, or mechanism-led contribution relevant to planning, operation, markets, stability, reliability, security, estimation, or optimization. Assumptions and the relationship between the original problem and any approximation, relaxation, reformulation, or decomposition must be explicit.

Reject-risk patterns include hidden assumptions, unsupported exactness/tractability claims, comparison against irrelevant baselines, and validation that does not test the claimed mathematical or operational property.

An application-oriented manuscript must still match the venue's scope and demonstrate broadly useful power-system insight; a site-specific implementation report without transferable technical content is weak fit.

## IEEE Transactions on Smart Grid

Research papers should connect data, communication, DERs, grid-edge control, cyber-physical operation, privacy, distributed coordination, learning, markets, or resilience to a power-system operating mechanism and physical constraints.

Application papers are a distinct valid type. Review their industry relevance, application complexity, implementation evidence, transferable experience, and operational effect. Do not apply an automatic “new model or reject” rule to an application paper.

Reject-risk patterns include a generic AI/control method attached to a grid dataset, absent physical feasibility, untested privacy/distributed/scalability claims, data leakage, or no grid-side metric.

## Applied Energy

Assess whether the work provides a substantial energy-system contribution, not merely use of an optimization or AI technique. Relevant evidence may include integrated energy-system behavior, realistic data, cross-sector coupling, economic/environmental metrics, sensitivity/uncertainty, and practical implications.

Application and system-integration work can be valid when the contribution is broadly informative and quantitatively supported. Reject-risk patterns include a single small test system, weak energy-system interpretation, generic algorithm comparison, or conclusions that exceed the geographical, technological, or temporal evidence.

## IEEE Power-System Letter

The current submission rule is an external hard constraint, not a corpus median. Initial manuscripts are limited to 3 formatted pages; revisions are limited to 3.5 formatted pages. Use `rule-sources.yaml` for source and verification date.

Expected shape:

- one hard claim;
- one compact formulation, derivation, correction, counterexample, or algorithmic result;
- minimal but decisive evidence;
- a short scoped conclusion.

Reject-risk patterns include full-paper scope, several unrelated contributions, a broad literature review, a technical core that cannot fit the permitted space, or broad but non-decisive validation.

## Journal Recommendation

When recommending another venue, state the reason in terms of contribution type and evidence:

- broader Chinese engineering mechanism or system validation: consider 中国电机工程学报;
- compact operating/automation/control logic: consider 电力系统自动化;
- formulation, planning, market, reliability, stability, or optimization contribution: consider TPWRS;
- smart-grid data, DER, cyber-physical, distributed, or application experience: consider TSG;
- integrated energy-system analysis with broad energy implications: consider Applied Energy;
- one narrow analytical claim: consider a Letter, subject to current page rules.
