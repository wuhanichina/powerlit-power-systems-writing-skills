# Power-System Lexicon

## Chinese Verbs

Use precise technical verbs:

- 建立: a model is explicitly defined.
- 构建: a framework/model/system relation is assembled from components.
- 推导: equations, bounds, or conditions are derived.
- 刻画: uncertainty, coupling, temporal behavior, or feasible regions are represented.
- 计及: an operational factor enters the model or constraint.
- 协调: multiple resources, time scales, or objectives are jointly decided.
- 校核: a result is checked against security/stability/engineering constraints.
- 松弛: a difficult model is relaxed with a stated relation to the original problem.
- 重构/重构化: use only when the mathematical object is actually reformulated or the network is reconfigured.

## Chinese Nouns

Prefer power-system nouns over generic nouns:

- 运行约束, 安全约束, 潮流约束, 电压越限, 频率稳定, 暂态稳定, 静态安全, N-1校核
- 新能源出力不确定性, 负荷预测误差, 源网荷储协调, 无功优化, 有功-无功协同
- 机会约束, 分布鲁棒, 场景削减, 置信水平, 保守性, 可行域
- 求解效率, 计算规模, 松弛间隙, 最优性间隙, 收敛性

## English Verbs

Prefer:

- formulate, derive, reformulate, enforce, coordinate, dispatch, schedule, regulate, bound, certify, decompose, linearize, convexify, calibrate, curtail, restore.

Use "propose" sparingly. Use a concrete verb when the action is known.

## English Nouns

Prefer:

- operating constraints, security constraints, voltage violations, frequency nadir, reserve requirements, uncertainty set, chance constraints, distributionally robust optimization, tractability, scalability, relaxation gap, optimality gap, feasibility certificate.

## Corpus-Derived Terminology Consistency

For full-paper drafts, major rewrites, venue adaptation, translation, and terminology cleanup, build an internal terminology ledger before final prose:

- `canonical term`: the single manuscript-facing name for the object;
- `term class`: power-system object, problem type, method family, mathematical object, variable, metric, baseline, protocol, scenario, evidence object, or boundary;
- `first-use form`: full term, abbreviation, and Chinese-English pair when needed;
- `allowed short form`: the only shortened form allowed after definition;
- `forbidden aliases`: near-synonyms, internal run codes, or broader terms that would make the object drift;
- `source`: project definition, equation/table label, PowerLit venue-near usage, method-canon anchor, or user-supplied reference.

Consistency rules:

- Use one canonical term for one object. Do not rotate between synonyms for stylistic variety.
- Do not use one term for two different objects. If "risk assessment" and "risk screening" mean different stages, define both; if they mean the same object, choose one.
- The project object controls meaning; PowerLit controls venue-normal wording. Never adopt a corpus term that broadens a screening, diagnostic, certificate, estimation, or boundary-characterization paper into a broader planning, dispatch, control, or validation claim.
- Introduce abbreviations once. After definition, use the same abbreviation and capitalization throughout.
- Replace internal labels such as run tags, case nicknames, and experiment codes with academic scenario descriptions, while preserving the reproducible setup in methods, tables, or captions.
- Before delivery, scan the revised text for alias drift. If multiple names remain for the same object, merge them into the canonical term unless the difference is explicitly defined.

## Avoid

Avoid or replace these unless the manuscript truly justifies them:

- 范式, 赋能, 生态, 闭环赋能, 全面提升, 显著优化 without numbers, 深度融合, 智能化转型 as filler.
- novel paradigm, seamless, robust and comprehensive, cutting-edge, delve into, pave the way, transformative, game-changing.

## Wording Discipline

- If a result is numerical, state the number.
- If a claim is theoretical, state the assumption.
- If a claim is engineering-oriented, state the system, device, or operating condition.
- If evidence is only simulation, do not call it field validation.
