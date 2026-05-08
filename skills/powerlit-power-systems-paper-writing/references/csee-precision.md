# 中国电机工程学报 Precision Reference

Use this reference when writing or rewriting 中国电机工程学报 prose. The target is not merely formal Chinese; it is dense, precise, and logically closed engineering prose.

## Core Principle

Every sentence must earn its place. A sentence should either:

- define the object;
- identify the contradiction;
- state a model relation;
- explain a constraint or mechanism;
- justify a transformation;
- report evidence;
- delimit the claim.

Delete sentences that only announce, decorate, summarize vaguely, or repeat context.

## Sentence Closure

A strong CSEE sentence closes a local logical loop:

`对象 -> 条件/限制 -> 技术动作 -> 结果/作用`

Examples:

- Weak: "本文对该问题进行了深入研究，并提出一种有效方法。"
- Strong: "针对新能源出力波动导致的备用配置保守问题，将预测误差分布嵌入备用约束，构建计及实时调节能力的机组组合模型。"

- Weak: "该方法能够提高系统运行的经济性和安全性。"
- Strong: "所提约束将节点电压越限概率限制在给定置信水平内，在不增加备用冗余的情况下降低弃风功率。"

## Verb Precision

Use verbs according to technical action:

- `建立/构建`: model, index system, optimization problem.
- `提出`: method, strategy, framework, criterion.
- `设计`: controller, coordination mechanism, experiment, algorithm flow.
- `推导`: analytical relation, constraint, bound, criterion.
- `转化/等价转化`: formulation change with stated equivalence or approximation.
- `引入`: variable, uncertainty set, correction term, penalty, criterion.
- `验证`: case, simulation, experiment, benchmark.

Avoid weak verbs:

- 研究, 探讨, 分析了, 进行了, 实现了, 具有, 体现了, 促进了, 提升了.

Use them only when the object and mechanism are explicit.

## Compression Rules

Delete:

- "为了更好地..."
- "本文首先/其次/最后" when it only narrates section order.
- "具有重要意义" unless followed by a technical consequence.
- "有效性和优越性" without metric.
- "一定程度上", "较好地", "显著地" without numbers.
- repeated "所提方法/本文方法" in adjacent sentences.

Replace:

- "考虑到..." with the actual condition.
- "通过对...进行分析" with the analytical result.
- "仿真结果验证了..." with the metric and mechanism.

## Paragraph Logic

A paragraph should have one task:

1. state the technical issue;
2. explain why existing methods fail;
3. construct one model component;
4. explain one constraint group;
5. interpret one result.

Do not mix literature review, model construction, and case interpretation in the same paragraph. Do not let a paragraph end with a loose slogan; end with the technical consequence.

## CSEE Style Guardrails

- Background must be short enough to reach the technical problem early.
- Long sentences are acceptable only when their internal causality is visible.
- A formula must be accompanied by physical meaning, not by a long paraphrase.
- Innovation should be written as a technical action, not as a self-evaluation.
- Evidence sentences should name system, scenario, metric, and direction of change.

## Final Tightening Pass

For each sentence, ask:

- What exact object is the subject?
- Which problem link does it close?
- Does it introduce a claim without evidence?
- Can two adjectives be replaced by one metric?
- Can "研究/分析/探讨" be replaced by the actual technical action?

If a sentence cannot answer these questions, rewrite or delete it.
