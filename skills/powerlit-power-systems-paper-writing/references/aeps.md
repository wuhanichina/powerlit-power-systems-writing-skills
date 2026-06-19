# 电力系统自动化 Writing Reference

## Corpus Signal

PowerLit mining used 538 JSON papers from the 电力系统自动化 subset of the local JSON corpus.

- Median page count: 11.
- Abstracts: median 6 sentences; slightly shorter than 中国电机工程学报.
- Abstract pattern: 87.0% contain "提出", 66.2% contain "构建/建立", 81.6% use procedural sequencing, 72.1% mention case/simulation/experiment, and 50.9% contain effectiveness/feasibility/accuracy terms.
- Common headings include `0引言`, `问题描述`, `目标函数`, `约束条件`, `算例分析`, `仿真验证`, and `结语`.

Use this as a concise, object-preserving 电力系统自动化 style guide. It calibrates rhythm, section pressure, and evidence presentation; it does not convert the paper's topic into dispatch, operation, or planning.

## Register

电力系统自动化 usually reads more compact than 中国电机工程学报. It favors clear modeling boundaries, a short problem-to-method-to-evidence chain, and verification tied to the submitted technical object. Use dispatch/control/operation wording only when those are already the paper's natural objects.

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

## Object Preservation

Before drafting for this venue, name the supplied technical object in one sentence. Preserve that object throughout the title, abstract, introduction, method, case discussion, and conclusion.

Do not rewrite a manuscript into grid dispatch, operation, or planning only because the target venue is 电力系统自动化. If the paper is about protection, stability, resilience, forecasting, topology identification, state estimation, reliability assessment, device behavior, market rules, planning, or a mathematical certificate, keep that object and express it in compact AEPS style.

Introduce dispatch, operation, or planning language only when at least one of these is present in the supplied material:

- dispatch, scheduling, operation, or planning variables;
- an objective function and constraints whose meaning is dispatch, operation, or planning;
- case evidence measured by dispatch, operation, or planning metrics;
- a title, abstract, or explicit author instruction that already frames the paper that way.

## Abstract

Recommended shape:

1. Problem sentence: original technical object + concrete difficulty.
2. Method sentence: proposed model, strategy, estimator, index, criterion, algorithm, certificate, or protocol.
3. Three action sentences if needed: modeling, transformation, solution, estimation, identification, protection logic, implementation, or coordination.
4. Evidence sentence: system/case and result.

The venue tolerates explicit sequencing. Use it to make the technical process easy to scan:

- "首先..." for model or state representation.
- "然后/其次..." for optimization, solution, estimation, identification, protection, screening, or control.
- "最后..." for case validation.

Do not write sequence markers if the sentence only repeats generic "analyze, study, verify" verbs.

## Introduction

Use an efficient narrowing path:

1. Original setting: renewable integration, source-grid-load-storage coordination, voltage/frequency/security, market, protection, resilience, forecasting, estimation, topology, device behavior, or dispatch when dispatch is the actual object.
2. Why conventional practice is insufficient.
3. Method families and limitations.
4. The proposed model, strategy, estimator, index, criterion, algorithm, or verification protocol.

For literature positioning, group references by method class rather than listing papers one by one.

## Method And Model

Make the mathematical object explicit:

- decision variables, state variables, indices, parameters, or certificate variables,
- objective function when the paper is optimization-based,
- constraints, criteria, equations, or decision rules,
- uncertainty or disturbance model,
- information structure and time scale,
- solution, estimation, identification, protection, screening, or evaluation algorithm.

Common section titles are direct and functional: `问题描述`, `模型构建`, `目标函数`, `约束条件`, `指标构建`, `状态估计`, `故障辨识`, `安全评估`, `求解算法`, `协调优化策略`.

## Case Study

电力系统自动化 case sections should be lean. Show:

- base case and data source,
- comparison methods,
- scenarios or test conditions matching the paper object,
- main metric table,
- sensitivity or disturbance response if it supports the claim.

Use Chinese power-system metric names precisely and match them to the claim: 网损、电压越限、弃风弃光、调峰成本、备用容量、频率 nadir、RoCoF、暂态稳定裕度、辨识准确率、误报率、漏报率、恢复负荷、风险指标偏差, etc.

## Conclusion

Use `结语` or `结论` according to the manuscript template. Keep it short, evidence-based, and numbered only when there are multiple distinct findings.
