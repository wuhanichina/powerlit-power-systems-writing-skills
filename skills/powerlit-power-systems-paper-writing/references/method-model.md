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

## Corpus-Derived Main-Body Construction

When PowerLit is available for a method/model, case-study, or full-paper task, learn the main-body construction from venue-near papers in the same problem family before drafting. Extract:

- section ordering: where accepted papers place system model, assumptions, problem formulation, reformulation, algorithm, implementation, case setup, and result discussion;
- equation role: whether equations define the physical model, introduce a constraint, transform the problem, prove a property, or support an algorithm step;
- paragraph role: what each method paragraph adds to the technical object;
- transition role: how the paper moves from operating conflict to model, from model to algorithm, and from algorithm to evidence;
- reproducibility placement: where data, scenario, solver, tolerance, runtime protocol, and baseline settings are stated.

Use the extracted pattern as a body-writing plan, not as a template. The current project's equations, variables, evidence, and claim boundary decide what can be written. If a near-neighbor method section has a proof, convergence statement, complexity analysis, communication model, privacy mechanism, or runtime protocol that the current project does not support, do not import that body element. Treat it as a missing-evidence or missing-model blocker only if the current claim requires it.

The body should read as a sequence of technical commitments: define the object, state assumptions, formulate relations, explain transformations, give the solution procedure, then show evidence. Do not hide a weak technical object behind fluent section prose.

## Reproducibility as Exposition

Do not treat reproducibility information as an appendix-style checklist that is added after the method is already written. Place each fact where a reader needs it to understand or trust the technical object.

- Put base system, topology, time scale, information timing, and operating boundary where the model object is introduced.
- Define variables, units, per-unit bases, sign conventions, sets, and indices near the first equation that uses them.
- State data source, sample construction, scenario generation, uncertainty model, train/test split, or forecast horizon where the method starts depending on those data.
- Place solver, tolerance, convergence rule, hardware/software context, or runtime protocol near the algorithm only when they affect tractability, scalability, online use, or reproducibility of the reported computation.
- Put baseline definitions and parameter settings before the comparison that depends on them, not after the result has already claimed superiority.

The prose should make the study reproducible by being locally informative, not by dumping every parameter into the main text. Routine constants may remain in tables, appendices, or supplementary material when the venue allows it, but any fact needed to judge the paper's claim belongs near the claim it supports.

## Parameter and Implementation Placement

Keep the method general enough to expose the reusable technical relation.

- Write model equations with symbols and validity conditions. Move case-specific confidence levels, duration assumptions, capacity caps, damping values, convergence tolerances, and similar settings to the case setup or parameter table unless a value is part of the method definition or theorem condition.
- Keep a parameter in the method when changing it changes the formal method, feasibility relation, convergence claim, or scope. Otherwise define the symbol in the method and report the selected value with the evidence setup.
- Put software, solver version, hardware, initialization, iteration traces, and wall-clock protocol in the reproducibility or computational-performance location where they support a tractability, scalability, convergence, or repeatability claim.
- Do not let implementation inventory interrupt the model's physical and mathematical progression.

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

### Intuition sentence template

After a key equation or group, write one sentence in this shape, dropping any slot that does not apply:

> 式(n) 表明 [电网量/状态] 在 [物理成因/扰动/网络参数] 作用下 [如何变化或被约束]，从而 [运行/可行/可辨识后果]；当 [极限情形] 时退化为 [已知结果]。

English: "Equation (n) says [grid quantity] responds to [physical cause] as [relation], so that [operating/feasibility consequence]; in the limit of [case] it reduces to [known result]."

Use it as logic, not boilerplate. If a slot would be padding, cut it. Never invent the limiting-case result; omit that clause when it is not derivable. For paired before/after rewrites of equation paragraphs, see `references/worked-examples.md`.

For inverse probabilistic load flow, the physical intuition must be explicit:

- The voltage-to-power moment equation is a quadratic power-flow kernel: voltage means and covariances create active/reactive power moments through network admittance, rather than through a generic statistical fit.
- Voltage-covariance identifiability asks which co-fluctuation directions can be observed from the supplied power moments; null-space directions should not be interpreted as meaningful voltage variance.
- An SDP feasibility certificate should be stated as evidence relative to the given relaxation model and constraint set. Distinguish original-problem feasibility, SDP-relaxation feasibility, infeasibility at the chosen relaxation order, and any rank or representing-measure condition needed to lift the certificate back to the original physical model.

## Mechanism Honesty

A physical-intuition sentence is a technical claim, not decoration. Before writing one, decide which status it has and keep that status honest:

- `model-derivable`: the cause-effect direction, term structure, or limiting behavior follows from the supplied equations, assumptions, data, or a cited result. Write it as a plain technical statement.
- `consistent-with-model`: the reading is compatible with the supplied model but was not derived from it. State the observable relation and the condition, and do not assert a causal direction the model does not fix.
- `unverified interpretation`: the explanation comes from general power-system reasoning rather than this manuscript's equations, results, or references. Write the safest version that the model does support, and list the interpretation in the delivery note for author confirmation.

Do not upgrade a status to make a paragraph read more confidently. Do not invent a physical mechanism, cause-effect direction, propagation path, identifiability reading, dominance argument, or limiting-case degeneration that the supplied model, data, or literature does not support. This is the same no-invention boundary that applies to numbers, baselines, and citations; a fabricated mechanism is harder for a reviewer to detect than a fabricated number and does more damage when it survives.

Report unverified interpretations in the short delivery note, never as hedging inside manuscript prose. The manuscript keeps a clean technical sentence; the note tells the author which physical readings still need confirmation.

## Why, Meaning, and Connection

For each key equation group and each major section transition, close three layers:

1. `Why before`: state the physical observation, scale separation, engineering constraint, or information limitation that makes the mathematical description necessary.
2. `What it means after`: after local symbol definitions, explain the grid quantity, propagation channel, sensitivity, feasibility boundary, resource cost, or diagnostic relation expressed by the equation.
3. `How it connects`: state what the result enables or requires next in the model, algorithm, case design, or conclusion.

Do not isolate these layers as answer-defense commentary. Weave them into the technical sequence with the grid object as subject and a direct causal relation. Avoid detachable prose such as "The reason for using X is...", "It should be noted that the physical meaning is...", or a paragraph whose only content is "the role of this equation." A cold opening such as `设...为` or `在...点线性化，有` is acceptable only when the physical reason is already locally recoverable.

At chapter scale, use the same progression: inherit one unresolved relation from the preceding section, resolve it here, and name what the result makes possible next. In a case section, state the mechanism-based expectation before comparing the observed result.

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

## Model Consistency Blocker

Writing cannot repair a model defect. If the supplied material shows any of the following, stop and report it instead of writing fluent physical intuition around it:

- units, dimensions, or per-unit bases that do not balance across an equation;
- a sign convention or direction that contradicts the stated physical effect;
- a variable used before definition, or one symbol carrying two different physical quantities;
- an assumption required by an invoked theorem, exactness condition, or relaxation that the manuscript neither states nor satisfies;
- a stated mechanism that the equation cannot produce;
- an equation whose limiting case contradicts a known result the manuscript itself relies on.

Name the exact location, the observed inconsistency, and the minimum information needed to resolve it. Do not silently correct the author's model, and do not choose the interpretation that makes the surrounding prose work. A polished physical story built on an inconsistent model is a worse outcome than a blocked draft, because it moves the defect past the point where a reviewer can see it.

## Standard Parts vs Claimed Novelty

Many power-system methods reuse high-frequency standard parts. By default these are not the paper's contribution.

- Treat SOCP relaxation, ADMM, chance-constrained reformulation, DRO ambiguity sets, scenario reduction, PINN, and similar well-established techniques as standard machinery, not as the novelty, unless the paper changes the technique itself.
- Map every claimed contribution to a specific equation, algorithm step, or proposition. If a claimed novelty cannot be mapped to a concrete object, soften the statement or flag it for the author rather than asserting it.
- This complements the Prewriting Gate in `SKILL.md`: this rule constrains how novelty is worded during drafting; it does not repeat the prewriting novelty judgment.

## 中国电机工程学报

Write the method section as an engineering-mechanism expansion:

- Start from the supplied research object: system structure, coupling relation, device behavior, scenario, estimator, certificate, index, or physical mechanism.
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

Write the method section as a compact, object-preserving model and execution procedure:

- Clarify time scale, information source, technical object, and decision, estimation, protection, screening, or verification boundary early.
- Make relevant variables, objectives, constraints, states, indices, uncertainty/disturbance model, and solution or evaluation process easy to scan.
- Use direct functional headings: `问题描述`, `模型构建`, `目标函数`, `约束条件`, `指标构建`, `状态估计`, `故障辨识`, `安全评估`, `求解算法`, `协调优化策略`.
- Keep implementation notes brief unless solver behavior, convergence, or runtime is part of the claim.
- Do not replace the manuscript object with dispatch, operation, or planning because the target venue is 电力系统自动化. Use dispatch/control vocabulary only when the supplied method actually contains those variables, objectives, constraints, or evidence.

Preferred sentence rhythm:

- "计及...，构建..."
- "以...为目标/判据，约束或条件包括..."
- "采用...对模型进行求解/估计/辨识/校核/滚动优化/分层协调。"

Avoid mixing background motivation, modeling, and case-study interpretation in the same paragraph.

## IEEE TPWRS

Write the method section as an object-preserving, formulation-first technical argument:

- Use `NOMENCLATURE` only if notation is heavy; otherwise define notation near first use.
- Put assumptions, sets, indices, variables, uncertainty, and information timing before equations.
- Separate the original physical/operational model from approximation, reformulation, relaxation, or decomposition.
- State what each transformation preserves, relaxes, approximates, or guarantees.
- Give the algorithm after the formulation difficulty is clear.
- Include convergence, scalability, complexity, or exactness only when actually supported.
- Do not add optimization, planning, relaxation, guarantee, or scalability machinery that is not part of the supplied research object.

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

Write the method section as a supplied smart-grid mechanism, not as a generic algorithm description:

- State the grid object first: feeder, DER fleet, microgrid, EV/storage system, sensors, market participants, communication graph, or cyber-physical layer.
- Make the information structure explicit: centralized/distributed, local measurements, delayed communication, privacy, online data, or attack model.
- Keep physical constraints close to data/control machinery: power flow, voltage/current limits, inverter capability, storage dynamics, frequency, stability, or restoration constraints.
- For learning/data-driven methods, state training/test split, noise, forecast horizon, domain shift, robustness, or generalization when relevant.
- For distributed/cyber-physical methods, state communication assumptions, privacy mechanism, attack model, or implementation burden when relevant.
- If the supplied paper has no DER, data, communication, cyber, privacy, distributed, or grid-edge object, flag TSG venue mismatch instead of adding one.

Avoid letting the method read like an ML/control paper with a power-grid dataset attached. The algorithmic object must explain what grid-operational difficulty it resolves.

## Method-Section Quality Check

Before finalizing, verify:

- Every variable in an equation is defined close to first use.
- Objective and constraints are not buried inside prose.
- The physical meaning of key equations and constraints is stated through grid objects, cause-effect direction, units/signs, limiting cases, or operational diagnosis.
- Every physical-intuition statement has a defensible status: `model-derivable`, `consistent-with-model`, or an `unverified interpretation` reported in the delivery note. No mechanism, causal direction, or degeneration result is asserted beyond what the model, data, or references support.
- No model inconsistency was written around: units and dimensions balance, sign conventions match the stated effect, symbols are unique, and every invoked theorem's assumptions are stated. Any unresolved inconsistency is reported as a blocker instead of absorbed into prose.
- Algorithm steps correspond to specific model difficulties.
- Approximation, relaxation, or linearization has a stated validity condition or boundary.
- Every relaxation, reformulation, decomposition, or surrogate states its relationship to the original problem (equivalence, bound, or gap) and the condition under which it holds.
- Mathematical depth matches the venue: enough derivation for reviewability, not proof-heavy exposition that displaces the engineering mechanism.
- Any uncommon theory is introduced only to the extent needed by the later model and is connected to the physical object before it is used.
- Solver and platform details are placed in the method only when method-level claims depend on them.
- Key equation groups close the `why before -> what it means after -> how it connects` sequence without detached answer-defense prose.
- Case-specific constants and implementation settings are separated from general model relations unless they define the method or its validity.
- The venue's expected granularity is respected without changing the research object: broader mechanism for 中国电机工程学报, leaner object-preserving formulation for 电力系统自动化, assumption-explicit formulation for TPWRS, and supplied smart-grid mechanism for TSG.
