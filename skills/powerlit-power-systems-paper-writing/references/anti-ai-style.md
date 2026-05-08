# Anti-AI-Style Cleanup

## Delete Visible Scaffolding

Remove planning language from manuscript prose:

- "本节将..."
- "接下来..."
- "为了更好地说明..."
- "本文的创新点主要体现在以下几个方面" when the following items are generic.
- "The remainder of this paper is organized as follows" unless required by template.
- "This section aims to..."

Replace with the technical subject:

- Weak: "本节将介绍所提模型的构建过程。"
- Strong: "所提模型以机组出力和储能功率为决策变量，计及线路潮流、电压幅值和备用容量约束。"

## Remove AI-Like Intensifiers

Delete broad adjectives unless backed by evidence:

- comprehensive, robust, seamless, efficient, significant, advanced, powerful,
- 全面, 显著, 高效, 鲁棒, 精准, 深度, 智能.

Replace with measured content:

- "求解时间由 18.4 min 降至 3.1 min."
- "95%置信水平下电压越限概率低于 3%."

## Prefer Technical Subjects

Let the model, constraint, method, or result act as the subject.

- "机会约束将节点电压越限风险限制在给定置信水平内。"
- "The affine reserve policy maps renewable forecast errors to generator recourse actions."

For 中国电机工程学报, technical subject is not optional. Avoid sentences whose subject is only "本文", "该方法", "该问题", or "研究结果" unless the predicate names a concrete model relation, constraint, metric, or mechanism.

## Avoid Meta-Claim Piles

Do not stack contribution claims before showing the object:

- Weak: "本文提出了一种高效、准确、鲁棒的新型方法。"
- Strong: "本文将风电预测误差嵌入备用约束，形成计及实时调整能力的机组组合模型。"

## Final Pass

Before finalizing, scan for:

- repeated "本文/所提/this paper/the proposed" in adjacent sentences,
- generic "问题/挑战" not followed by a physical or mathematical object,
- "有效性/优越性" without a metric,
- "novel" without a precise difference from prior work,
- result sentences that do not name the case system.

For Chinese journal prose, also remove soft filler such as "较好地", "一定程度上", "进一步说明", "具有一定参考价值", and "为...提供思路" unless the sentence names the exact technical condition or evidence.
