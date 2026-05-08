# 中国电机工程学报 Writing Reference

## Corpus Signal

PowerLit mining used 802 JSON papers from the 中国电机工程学报 subset of the local JSON corpus.

- Median page count: 12.
- Abstracts: median 6 sentences; sentence length is relatively long.
- Abstract pattern: 71.1% contain "提出", 53.5% contain "构建/建立", 60.5% use procedural sequencing such as "首先/其次/然后/最后", and 45.3% contain result-showing language.
- Common major headings include `0引言`, `算例分析`, `仿真验证`, `实验验证`, `结果与讨论`, and `结论`.

Use these as style tendencies, not templates to copy mechanically.

## Register

中国电机工程学报 tolerates a slightly broader engineering background than 电力系统自动化, but the paper still needs a concrete technical object. The best tone is formal engineering exposition: define the operating object, state the mechanism or constraint, then show the proposed model/control/optimization method.

Prefer:

- "针对...问题，提出..."
- "建立/构建...模型"
- "设计...控制策略/协调机制"
- "推导...关系/约束/判据"
- "算例/仿真/实验结果表明..."

Avoid:

- long policy-only openings,
- "赋能、范式、闭环生态、全面提升" without technical content,
- repeated "本文首先...本文其次..." in every paragraph,
- claiming "工程实用性" without device/system data, simulation conditions, or implementation constraints.

## Abstract

Recommended shape:

1. One sentence for concrete engineering problem and why existing practice is insufficient.
2. One sentence naming the proposed method/model/control strategy.
3. Two or three sentences for the technical chain: model construction, mechanism derivation, control/optimization, solution.
4. One sentence for case/simulation/experiment and measurable result.
5. Optional final sentence for engineering implication, only when supported.

Keep "首先/其次/最后" if the abstract needs a procedural chain, but do not let it become a list of actions without a technical claim. If using "结果表明", pair it with the actual metric or effect.

## Introduction

Use a four-part introduction:

1. Power-system context and operating consequence, preferably in one paragraph.
2. Existing method classes, grouped by mechanism or modeling assumption.
3. Exact unresolved limitation: physical coupling, constraint conservatism, uncertainty description, scalability, observability, or field feasibility.
4. Proposed method and contributions tied to the limitation.

For Chinese journals, the introduction can mention national strategy or high-renewable transition, but only as the first step. The technical problem should appear early.

## Method And Model

Use section titles that expose the technical object:

- `系统建模`
- `问题描述`
- `目标函数与约束条件`
- `协调控制策略`
- `求解算法`
- `参数整定与实现`

Define every variable near its first equation. Explain the physical meaning of constraints before algorithmic details. Solver/file/cache details usually belong outside the manuscript unless they affect reproducibility or engineering use.

## Case Study

State:

- test system or engineering platform,
- operating scenarios,
- uncertainty source or disturbance,
- baselines,
- metrics with units,
- solver and tolerances when they affect interpretation.

Prefer "算例分析/仿真验证/实验验证" based on evidence type. Use "结果与讨论" when the section combines mechanism interpretation with numerical evidence.

## Conclusion

Use 2 to 4 compact findings. Each finding should correspond to one verified claim. Do not add broad application promises unless the experiments support them.
