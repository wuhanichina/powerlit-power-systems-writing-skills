# Method, Model, and Formulation Reference

Use this reference when drafting or rewriting 方法, 模型, 问题描述, 目标函数, 约束条件, 算法, 求解, 控制策略, `Problem Formulation`, `System Model`, `Proposed Method`, or `Solution Algorithm` sections.

## Corpus Signal

PowerLit mining found method-like sections in almost all target papers:

- 中国电机工程学报: 802 papers, 97.4% with method sections, median 6 method sections, 30 method paragraphs, 29 display-equation markers.
- 电力系统自动化: 538 papers, 99.3% with method sections, median 9 method sections, 40 method paragraphs, 41.5 display-equation markers.
- IEEE TPWRS full papers: 553 full papers, 99.5% with method sections, median 7 method sections, 68 method paragraphs, 64 display-equation markers.

The exact counts are heuristic, but the signal is stable: the method section must be explicit, technical, and venue-specific.

## Global Rule

The method section is where the paper's claim becomes a technical object. Write in this order unless the manuscript has a good reason to deviate:

1. Operating object and modeling boundary.
2. Assumptions, variables, sets, parameters, and information timing.
3. Objective, constraints, physical equations, uncertainty model, or control law.
4. Transformation, derivation, relaxation, decomposition, or analytical property.
5. Solution algorithm, control procedure, or implementation condition.
6. Reproducibility details only when they affect interpretation.

Avoid generic section announcements such as "This section introduces the proposed method." Start with the system object or formulation.

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

## Method-Section Quality Check

Before finalizing, verify:

- Every variable in an equation is defined close to first use.
- Objective and constraints are not buried inside prose.
- The physical meaning of key constraints is stated.
- Algorithm steps correspond to specific model difficulties.
- Approximation, relaxation, or linearization has a stated validity condition or boundary.
- Solver and platform details are placed in the method only when method-level claims depend on them.
- The venue's expected granularity is respected: broader mechanism for 中国电机工程学报, leaner operational formulation for 电力系统自动化, assumption-explicit formulation for TPWRS.
