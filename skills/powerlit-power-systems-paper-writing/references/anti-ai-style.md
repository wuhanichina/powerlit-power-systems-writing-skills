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

For Chinese journal prose, also run a punctuation-register pass:

- Delete `声称` and `宣称` from manuscript prose. They describe author posture rather than technical evidence. Replace with evidence verbs such as `表明`, `说明`, `支持`, `限定为`, or direct scoped wording.
- Remove quotation marks used only to package concepts or emphasize terms, such as `"单步"` or `“从功率统计量反求电压分布”`. Write the technical object directly.
- Replace em-dash explanation chains, such as `输入参数化—传播—输出重建` or `反方向——由功率样本反求电压分布——`, with commas, semicolons, parentheses, or a direct subject-predicate sentence.
- Keep quotation marks only for literal titles, direct quotations, questionnaire items, or template-required strings. If no such source exists, the marks are a draft smell.

## Working-Language Firewall

Applies to all venues, Chinese and English.

The skill uses two languages that must never mix. The working language organizes the review and drafting process; the manuscript language is domain-technical prose. Working-language terms are internal tools and must not appear in the final manuscript.

Blacklist (must not appear in manuscript prose):

- 范式, 缺口 / 硬缺口 / 软缺口, closest competitor, claim, 白名单, 论证链, 证据包, venue / 轨道, AI化.
- 占位符: allowed only in a logic draft; never in clean manuscript prose.

Rewrite map (working language -> manuscript prose):

- 范式 -> name the method class itself: "解析方法", "基于数据的方法"; never write "该范式".
- closest competitor -> "与本文最相关的是文献[x]的工作", or state that method directly.
- 缺口 / claim -> a concrete unresolved problem or a concrete result; the words themselves must not appear.
- 论证链 / 证据包 / 轨道 -> do not appear; they are organizing tools only.

Term scan: after generating manuscript prose, scan for every blacklisted term. Any hit means the draft is not clean; return to the manuscript language and rewrite before delivering. This blacklist is a fixed word list; it does not touch normal domain terms that happen to use words like "机制" or "框架" when those point to a concrete object.

## Controlled Hedging vs Defensive Writing

Applies to all venues, Chinese and English.

Controlled hedging is allowed: a single, evidence-based limitation on claim strength. In English, prefer controlled qualifiers such as "under the considered conditions", "effective", or "limited to". State it once, where the boundary actually applies.

Defensive writing is forbidden: a pervasive posture of retreat and self-justification that runs through the text.

- Chinese defensive markers to remove: "尝试", "试图", "以期", "在一定程度上", "具有一定的", "由于篇幅所限".
- Claim-retreat markers to rewrite: "需要强调的是", "本文不把", "本文不主张", "并非全面替代", "不声称全面优于", "not intended to replace", "does not claim to supersede".
- Replace defensive prose with an active statement plus, if needed, one controlled boundary.
- A boundary sentence is acceptable only when the previous or same sentence has already stated the positive technical object.

The difference: controlled hedging limits one conclusion with a stated basis; defensive writing keeps apologizing instead of stating what the paper does. For the boundary-statement examples and the anti-流水账 rule, see `publishable-prose.md` (Anti-Defensive Rule); do not duplicate them here.

## English AI Tells

Applies only to English manuscripts: IEEE TPWRS, IEEE TSG, and C-track English introductions or methods.

Register guard (read first): this section is adapted from the stop-slop checklist, but power-system academic English keeps the technical object as the grammatical subject. Passive voice and subjects such as "The constraint enforces...", "The relaxation preserves...", "The model captures..." are correct and expected here. Do NOT apply the following stop-slop rules:

- human subject / mandatory active voice;
- "you" over "People" reader-in-the-room voice;
- the False-Agency ban (technical-object agency is allowed; only melodramatic agency such as "the data tells a compelling story" is removed);
- the absolute ban on adverbs;
- the "two items beat three" rhythm rule (a deliberate 3-4 item contribution list is fine).

AI tells to remove (with power-system before/after):

- Binary contrasts: "not X but Y", "not just X but also Y", "isn't X, it's Y", "The question isn't X, it's Y". State Y directly.
  - Weak: "The challenge is not modeling accuracy but computational tractability."
  - Strong: "The bottleneck is computational tractability under repeated dispatch evaluation."
- Negative listing buildup and dramatic sentence fragmentation. Use complete declarative sentences.
- Rhetorical setups: "What if...?", "Think about it:", "Here's what I mean:". Make the technical point.
- Throat-clearing and meta-commentary: "In this section, we will...", "As we will see...", "It is worth noting that", "It turns out", "At its core", "When it comes to". Start with the system object or formulation.
- Business jargon: navigate, unpack, landscape, deep dive, game-changer. Use plain technical verbs; see `lexicon.md` for the broader avoid list.
- Vague declaratives: "The implications are significant", "The reasons are structural". Name the specific implication or reason.
  - Weak: "The implications for grid operation are significant."
  - Strong: "The method lowers reserve cost by about one order of magnitude on the IEEE 118-bus system."
- Lazy extremes: "every", "always", "never", "all" without specifics. Replace with the stated scope; this also guards against overclaim.
- Em-dashes: replace with commas or periods.
- Empty intensifying adverbs (not an absolute ban): "really", "simply", "fundamentally", "inherently", "significantly" without a metric. Delete or attach a number.
