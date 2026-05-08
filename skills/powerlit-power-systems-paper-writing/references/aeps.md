# 电力系统自动化 Writing Reference

## Corpus Signal

PowerLit mining used 538 JSON papers from the 电力系统自动化 subset of the local JSON corpus.

- Median page count: 11.
- Abstracts: median 6 sentences; slightly shorter than 中国电机工程学报.
- Abstract pattern: 87.0% contain "提出", 66.2% contain "构建/建立", 81.6% use procedural sequencing, 72.1% mention case/simulation/experiment, and 50.9% contain effectiveness/feasibility/accuracy terms.
- Common headings include `0引言`, `问题描述`, `目标函数`, `约束条件`, `算例分析`, `仿真验证`, and `结语`.

Use this as a concise automation/control/operation style guide.

## Register

电力系统自动化 usually reads more compact and operational than 中国电机工程学报. It favors clear modeling boundaries, dispatch/control logic, and verification under operating scenarios.

Prefer:

- "为解决...，提出..."
- "计及..."
- "构建...优化模型/控制策略"
- "设计...求解流程"
- "验证了所提方法的有效性/可行性"

Avoid:

- long conceptual motivation before the actual model,
- broad "新型电力系统" wording without a specific operational issue,
- unnecessary bilingual or translation-like phrasing,
- overclaiming "显著" without numbers.

## Abstract

Recommended shape:

1. Problem sentence: object + operational difficulty.
2. Method sentence: proposed model/strategy/algorithm.
3. Three action sentences if needed: modeling, transformation/solution, implementation or coordination.
4. Evidence sentence: system/case and result.

The venue tolerates explicit sequencing. Use it to make the technical process easy to scan:

- "首先..." for model or state representation.
- "然后/其次..." for optimization, solution, or control.
- "最后..." for case validation.

Do not write sequence markers if the sentence only repeats generic "analyze, study, verify" verbs.

## Introduction

Use an efficient narrowing path:

1. Operational setting: renewable integration, source-grid-load-storage coordination, dispatch, voltage/frequency/security, market, protection, or resilience.
2. Why conventional practice is insufficient.
3. Method families and limitations.
4. The proposed model or strategy.

For literature positioning, group references by method class rather than listing papers one by one.

## Method And Model

Make the mathematical object explicit:

- decision variables,
- objective function,
- constraints,
- uncertainty or disturbance model,
- information structure and time scale,
- solution algorithm.

Common section titles are direct and functional: `问题描述`, `模型构建`, `目标函数`, `约束条件`, `求解算法`, `协调优化策略`.

## Case Study

电力系统自动化 case sections should be lean. Show:

- base case and data source,
- comparison methods,
- operating scenarios,
- main metric table,
- sensitivity or disturbance response if it supports the claim.

Use Chinese power-system metric names precisely: 网损、电压越限、弃风弃光、调峰成本、备用容量、频率 nadir、RoCoF、暂态稳定裕度, etc.

## Conclusion

Use `结语` or `结论` according to the manuscript template. Keep it short, evidence-based, and numbered only when there are multiple distinct findings.
