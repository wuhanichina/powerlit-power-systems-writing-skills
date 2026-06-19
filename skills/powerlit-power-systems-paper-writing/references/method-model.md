# Method, Model, and Formulation Reference

Use this reference when drafting or rewriting 方法, 模型, 问题描述, 目标函数, 约束条件, 算法, 求解, 控制策略, `Problem Formulation`, `System Model`, `Proposed Method`, or `Solution Algorithm` sections.

## Corpus Signal

PowerLit mining found method-like sections in almost all target papers:

- 中国电机工程学报: 802 papers, 97.4% with method sections, median 6 method sections, 30 method paragraphs, 29 display-equation markers.
- 电力系统自动化: 538 papers, 99.3% with method sections, median 9 method sections, 40 method paragraphs, 41.5 display-equation markers.
- IEEE TPWRS full papers: 553 full papers, 99.5% with method sections, median 7 method sections, 68 method paragraphs, 64 display-equation markers.
- IEEE TSG full papers: 209 full papers, 99.5% with method sections, median 62 method paragraphs.

The exact counts are heuristic, but the signal is stable: the method section must be explicit, technical, and venue-specific.

## Global Rule

The method section is where the paper's claim becomes a technical object. Write in this order unless the manuscript has a good reason to deviate:

1. Operating object and modeling boundary.
2. Assumptions, variables, sets, parameters, and information timing.
3. Objective, constraints, physical equations, uncertainty model, or control law.
4. Transformation, derivation, relaxation, decomposition, or analytical property.
5. Solution algorithm, control procedure, or implementation condition.
6. Reproducibility details at the point where they affect interpretation.

Avoid generic section announcements such as "This section introduces the proposed method." Start with the system object or formulation.

## Reproducibility as Exposition

Do not treat reproducibility information as an appendix-style checklist that is added after the method is already written. Place each fact where a reader needs it to understand or trust the technical object.

- Put base system, topology, time scale, information timing, and operating boundary where the model object is introduced.
- Define variables, units, per-unit bases, sign conventions, sets, and indices near the first equation that uses them.
- State data source, sample construction, scenario generation, uncertainty model, train/test split, or forecast horizon where the method starts depending on those data.
- Place solver, tolerance, convergence rule, hardware/software context, or runtime protocol near the algorithm only when they affect tractability, scalability, online use, or reproducibility of the reported computation.
- Put baseline definitions and parameter settings before the comparison that depends on them, not after the result has already claimed superiority.

The prose should make the study reproducible by being locally informative, not by dumping every parameter into the main text. Routine constants may remain in tables, appendices, or supplementary material when the venue allows it, but any fact needed to judge the paper's claim belongs near the claim it supports.

## Physical Story Before Mathematics

For power-system engineering papers, the physical picture is the primary logic and mathematics is the disciplined language used to express it. Before adding equations, propositions, or proof fragments, state the grid object, operating conflict, coupling mechanism, and engineering consequence that make the mathematics necessary.

Use this order for mathematically dense material:

1. physical scene: network, device, market, uncertainty source, control layer, or feasibility boundary;
2. engineering conflict: which voltage, current, power, reserve, risk, communication, or observability relation fails or becomes hard;
3. mathematical object: variable, kernel, constraint, ambiguity set, relaxation, certificate, theorem, or algorithmic property;
4. physical reading of the object: what the operator, planner, or reviewer learns from it;
5. evidence or next model step.

Do not write engineering manuscripts as if they were pure-math papers. Most target venues need enough derivation to make assumptions, validity conditions, and computational consequences reviewable; they do not need a complete proof of every supporting property. Put proof-level detail in the main text only when the claim depends on the proof and the venue expects it.

When introducing an uncommon mathematical theory in power-system papers, add a short prerequisite bridge before using it: define only the concepts needed later, state the condition under which they apply, and tie the concept to the current grid object. Do not insert a self-contained textbook tutorial.

Reviewer-comment revisions follow the same rule. A reviewer request for clarification should become a clearer physical mechanism, assumption, equation interpretation, or evidence comparison at the natural manuscript location. It should not become a defensive proof block or a paragraph whose main subject is the reviewer's concern.

## Local Motivation Before Properties

Do not let propositions, proofs, lemmas, algorithm blocks, or named properties appear without a local reason. Before a subsection such as `半正定性`, `可行性`, `收敛性`, `复杂度`, `等价性`, or `约束满足性`, add one short technical bridge that states:

- which modeling or optimization difficulty from the previous subsection makes the property necessary;
- what physical, probabilistic, feasibility, or computational condition the property protects;
- what the consequence is for the next step, such as gradient refinement, relaxation, decomposition, or certificate construction.

Weak: opening `2.2 半正定性` directly with a proposition.
Strong: state that covariance must remain positive semidefinite during unconstrained gradient refinement; otherwise the recovered voltage distribution is nonphysical and residual reduction is meaningless. Then give the proposition.

## Formula Physical Intuition

Symbol definition is not enough. For every key equation or equation group, give the reader one short physical-intuition sentence or paragraph that answers the following questions when relevant:

- What grid object does the equation represent: voltage phasor, branch flow, injection, reserve, covariance, uncertainty set, certificate, or operating limit?
- What is the cause-effect direction: which disturbance, decision, or network parameter changes which electrical quantity?
- Why are the terms added, multiplied, relaxed, decomposed, or bounded in this form?
- Do the sign convention, units, dimensions, and per-unit scaling match the stated physical direction?
- What happens in a limiting case: zero uncertainty, radial feeder without reverse flow, independent injections, perfect observability, no communication delay, or a single mixture component?
- What does the equation let an operator or reviewer diagnose that a black-box numerical result would not show?

Do not turn "式中:" or notation paragraphs into long textbook exposition. Keep notation close to the formula, then add physical intuition as a separate technical sentence anchored to the manuscript's claim.

For inverse probabilistic load flow, the physical intuition must be explicit:

- The voltage-to-power moment equation is a quadratic power-flow kernel: voltage means and covariances create active/reactive power moments through network admittance, rather than through a generic statistical fit.
- Voltage-covariance identifiability asks which co-fluctuation directions can be observed from the supplied power moments; null-space directions should not be interpreted as meaningful voltage variance.
- An SDP feasibility certificate should be stated as evidence relative to the given relaxation model and constraint set. Distinguish original-problem feasibility, SDP-relaxation feasibility, infeasibility at the chosen relaxation order, and any rank or representing-measure condition needed to lift the certificate back to the original physical model.

## Model-Algorithm Consistency

Whenever the method uses a relaxation, convexification, penalty, discretization, decomposition, or surrogate model, the manuscript must state the relationship between the original problem and what is actually solved.

- State the relationship explicitly in prose: equivalence, upper bound, lower bound, or gap, together with the condition under which it holds.
- A simple relationship (for example, an exact relaxation) needs one sentence. A complex relationship (penalty limiting behavior, the equivalence chain of a multi-step decomposition, surrogate approximation quality) may take a short paragraph, but it must still land on two points: the relationship, and the condition.
- If the relationship cannot be established, do not default to claiming equivalence. Keep it as an explicit conditional statement in the text rather than hiding it.

SOCP exactness template:

- State the network model: branch-flow or bus-injection, radial or meshed, balanced or unbalanced, and which variables are relaxed.
- State objective monotonicity: whether the objective is strictly or weakly increasing in losses, injections, currents, or controllable load.
- State load and generation bounds: whether over-satisfaction, reverse flow, reactive limits, or flexible demand can break the condition.
- State voltage and branch constraints: whether binding upper voltage, current, or apparent-power constraints affect exactness.
- State feasible-region assumptions and the exact theorem being invoked.
- State the conclusion only within that theorem's scope. Do not write a universal sentence such as "radial network plus no load over-satisfaction makes SOCP exact" unless the cited theorem's other assumptions are also satisfied.

Penalty relationship template:

- Distinguish quadratic penalty, augmented Lagrangian, and exact penalty.
- For quadratic penalties, state limiting behavior as the penalty weight grows; do not claim finite-penalty feasibility unless proved.
- For augmented Lagrangian methods, state primal feasibility and dual update conditions separately from objective bounds.
- For exact penalties, state the regularity and threshold conditions that make a finite penalty parameter exact.
- Do not claim that a finite penalty parameter produces a feasible upper bound for the original problem unless the manuscript proves both feasibility and the objective-bound relation.

## Standard Parts vs Claimed Novelty

Many power-system methods reuse high-frequency standard parts. By default these are not the paper's contribution.

- Treat SOCP relaxation, ADMM, chance-constrained reformulation, DRO ambiguity sets, scenario reduction, PINN, and similar well-established techniques as standard machinery, not as the novelty, unless the paper changes the technique itself.
- Map every claimed contribution to a specific equation, algorithm step, or proposition. If a claimed novelty cannot be mapped to a concrete object, soften the statement or flag it for the author rather than asserting it.
- This complements the Prewriting Gate in `SKILL.md`: this rule constrains how novelty is worded during drafting; it does not repeat the prewriting novelty judgment.

## 中国电机工程学报

Write the method section as an engineering-mechanism expansion:

- Start from system structure, coupling relation, device behavior, operating scenario, or physical mechanism.
- Then construct the model: variables and parameters should be defined near the first equation.
- Separate objective function, constraints, control equations, and solution algorithm.
- Explain the physical meaning of important constraints before giving the algorithm.
- Use parameter configuration or implementation subsections only when they affect engineering use.

Useful section shapes:

- `系统建模`
- `问题描述`
- `目标函数与约束条件`
- `协调控制策略`
- `模型求解`
- `参数整定与实现`

Preferred sentence rhythm:

- "针对...，将...表示为...，建立..."
- "约束...用于刻画...，其物理含义为..."
- "在上述模型基础上，采用...求解..."

Do not let "首先/其次/最后" become a list of writing actions. Each sequence marker must move the model forward.

## 电力系统自动化

Write the method section as a compact operational model and execution procedure:

- Clarify time scale, information source, dispatch/control object, and decision boundary early.
- Make decision variables, objective function, constraints, uncertainty/disturbance model, and solution process easy to scan.
- Use direct functional headings: `问题描述`, `模型构建`, `目标函数`, `约束条件`, `求解算法`, `协调优化策略`.
- Keep implementation notes brief unless solver behavior, convergence, or runtime is part of the claim.

Preferred sentence rhythm:

- "计及...，构建..."
- "以...为目标，约束包括..."
- "采用...对模型进行求解/滚动优化/分层协调。"

Avoid mixing background motivation, modeling, and case-study interpretation in the same paragraph.

## IEEE TPWRS

Write the method section as a formulation-first technical argument:

- Use `NOMENCLATURE` only if notation is heavy; otherwise define notation near first use.
- Put assumptions, sets, indices, variables, uncertainty, and information timing before equations.
- Separate the original physical/operational model from approximation, reformulation, relaxation, or decomposition.
- State what each transformation preserves, relaxes, approximates, or guarantees.
- Give the algorithm after the formulation difficulty is clear.
- Include convergence, scalability, complexity, or exactness only when actually supported.

Common section names:

- `II. PROBLEM FORMULATION`
- `II. SYSTEM MODEL`
- `III. PROPOSED METHOD`
- `III. SOLUTION METHODOLOGY`
- `A. Preliminaries`
- `B. Reformulation`
- `C. Solution Algorithm`

Preferred English subjects:

- `The formulation...`
- `The constraint...`
- `The relaxation...`
- `The decomposition...`
- `The operator...`
- `The uncertainty model...`

Avoid "we explore", "we comprehensively investigate", and "a novel framework" unless followed by a precise formulation, assumption, or guarantee.

## IEEE TSG

Write the method section as a smart-grid mechanism, not as a generic algorithm description:

- State the grid object first: feeder, DER fleet, microgrid, EV/storage system, sensors, market participants, communication graph, or cyber-physical layer.
- Make the information structure explicit: centralized/distributed, local measurements, delayed communication, privacy, online data, or attack model.
- Keep physical constraints close to data/control machinery: power flow, voltage/current limits, inverter capability, storage dynamics, frequency, stability, or restoration constraints.
- For learning/data-driven methods, state training/test split, noise, forecast horizon, domain shift, robustness, or generalization when relevant.
- For distributed/cyber-physical methods, state communication assumptions, privacy mechanism, attack model, or implementation burden when relevant.

Avoid letting the method read like an ML/control paper with a power-grid dataset attached. The algorithmic object must explain what grid-operational difficulty it resolves.

## Method-Section Quality Check

Before finalizing, verify:

- Every variable in an equation is defined close to first use.
- Objective and constraints are not buried inside prose.
- The physical meaning of key equations and constraints is stated through grid objects, cause-effect direction, units/signs, limiting cases, or operational diagnosis.
- Algorithm steps correspond to specific model difficulties.
- Approximation, relaxation, or linearization has a stated validity condition or boundary.
- Every relaxation, reformulation, decomposition, or surrogate states its relationship to the original problem (equivalence, bound, or gap) and the condition under which it holds.
- Mathematical depth matches the venue: enough derivation for reviewability, not proof-heavy exposition that displaces the engineering mechanism.
- Any uncommon theory is introduced only to the extent needed by the later model and is connected to the physical object before it is used.
- Solver and platform details are placed in the method only when method-level claims depend on them.
- The venue's expected granularity is respected: broader mechanism for 中国电机工程学报, leaner operational formulation for 电力系统自动化, assumption-explicit formulation for TPWRS.
