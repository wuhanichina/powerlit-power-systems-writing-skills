# Introduction Scalpel Reference

Use this when writing or rewriting the introduction of a power-system paper. The goal is to cut from a broad system context to the exact technical nerve of the paper, then state actual innovations as technical deliverables.

## Corpus Signal

PowerLit introduction mining used:

- 中国电机工程学报: 800 introductions.
- 电力系统自动化: 538 introductions.
- IEEE TPWRS: 564 introductions.
- IEEE TSG: 209 full-paper introductions in the comparison corpus.

Median rhythm:

- Chinese venues: about 7 paragraphs, 3 sentences per paragraph.
- IEEE Transactions papers: about 12 paragraphs, 3 sentences per paragraph.

Almost all introductions contain a gap. In Chinese venues, explicit "创新点/主要贡献" language is rare: about 8.0% in 中国电机工程学报 and 11.5% in 电力系统自动化. In IEEE Transactions papers, explicit contribution paragraphs are common: about 70.4% in TPWRS and about 73.2% in TSG.

## Principle

The introduction should not merely prove that the topic is important. It should prove that a specific power-system object has a specific unresolved contradiction under a specific operating, planning, control, market, or uncertainty condition.

Before drafting, reduce the paper to one internal spine sentence:

`For [power-system object] under [operating condition], this paper [technical action] so that [unresolved conflict] can be addressed within [evidence boundary].`

Do not print this sentence as a label. Use it to decide what the introduction keeps, delays, or deletes. The title should expose the same technical object or action when possible; the abstract should compress the same line; the contribution statement should unfold it; the result discussion and conclusion should return to what this line promised. If a background paragraph, citation group, or contribution candidate cannot attach to the spine, it is probably context noise or a different paper.

Use this cutting order:

1. Object: which system, device, market, uncertainty source, or control layer?
2. Consequence: what security, stability, economy, feasibility, or observability issue appears?
3. Method families: which existing method classes address parts of it?
4. Limitation: what exactly is missing?
5. Technical reason: why does the limitation arise?
6. Core contradiction: what requirement cannot be met jointly?
7. Innovation: what model, constraint, strategy, algorithm, theorem, or validation answers it?

## Chinese Venues: Short Cut

中国电机工程学报 and 电力系统自动化 usually place the first gap and the first proposal close together, often in the same or adjacent paragraph.

Recommended paragraph flow:

1. Object and operating consequence.
2. Existing method family 1 and limitation.
3. Existing method family 2 and limitation.
4. Existing method family 3 and limitation.
5. Core contradiction.
6. Proposed model/strategy/algorithm.
7. Case verification boundary.

Do not overuse a formal "创新点如下" list. It often reads less natural for these venues unless the manuscript template expects it. Instead, write innovations as technical actions:

- "计及 X 与 Y 的耦合关系，构建 Z 模型。"
- "将 A 约束转化为 B 形式，以降低 C。"
- "引入 D 判据，使 E 可在 F 条件下校核。"

## TPWRS: Long Cut

TPWRS usually builds a longer method landscape before the proposal. The first gap often appears early, while the first proposal appears several paragraphs later. Explicit contribution lists are normal.

Recommended paragraph flow:

1. System context and operational challenge.
2. Method family 1 and limitation.
3. Method family 2 and limitation.
4. Method family 3 and limitation.
5. Remaining technical gap.
6. Proposed formulation or method.
7. Contributions and validation scope.

Contribution bullets should each contain deliverable plus technical gain:

- formulation + what physics, uncertainty, or constraint it captures;
- reformulation/algorithm + why it is tractable, scalable, or less conservative;
- theory/guarantee + under what assumptions it holds;
- case study + what systems and metrics validate it.

## TSG: Smart-Grid Cut

TSG uses a similar long IEEE Transactions introduction, but the method landscape often includes data-driven operation, distributed coordination, DER/distribution systems, cyber-physical security, communication/privacy constraints, learning-enabled control, and grid-edge devices.

Recommended paragraph flow:

1. Smart-grid object and operational challenge.
2. Existing power-system operation/control methods and limitation.
3. Existing data/learning/distributed/cyber-physical methods and limitation.
4. Remaining gap in physical feasibility, information structure, communication/privacy, robustness, or generalization.
5. Proposed smart-grid mechanism.
6. Contributions and validation scope.

Every data, learning, privacy, or distributed-control claim should be tied to a grid-operational consequence. Do not let the introduction become a generic AI-method literature review.

## Gap Categories

A good gap is not "previous work is insufficient" by itself. It should land in one or more of these categories:

- model/physics: physical relation, nonlinear flow, dynamic process, or mechanism is not represented.
- security/stability: voltage, frequency, transient, reliability, or security constraint is not enforced.
- computation/scalability: the model is hard to solve, not real-time, or does not scale.
- uncertainty/risk: forecast error, random output, probability, scenario, or distribution is weakly handled.
- operation/market: dispatch, reserve, cost, market rule, or demand response is detached from operation.
- data/observability: measurement, estimation, identification, prediction, or information is insufficient.
- coupling/coordination: multi-time-scale, source-grid-load-storage, multi-energy, or device coordination is missing.

## Innovation Categories

Actual innovations should be stated as objects:

- model/formulation: new model, variables, constraints, uncertainty representation, or physical characterization.
- control/strategy: coordination, dispatch, energy management, protection, or regulation strategy.
- algorithm/solution: relaxation, decomposition, linearization, iteration, distributed solution, or rolling horizon.
- theory/guarantee: criterion, proof, convergence, feasibility, stability, conservativeness, or bound.
- data/case system: real data, benchmark system, engineering case, scenario design, or validation protocol.

## Gap-to-Contribution Map

Before writing the final introduction, make this map as a support for the spine, not as a separate checklist:

| Gap | Technical reason | Contribution | Evidence |
| --- | --- | --- | --- |
| What is not solved? | Why not? | What object solves it? | Which result supports it? |

Every contribution should point back to a gap. Every gap kept in the introduction should either motivate a contribution or be removed. The map is successful only when the introduction reads as one developing line: the operating object creates the conflict, the literature explains why the conflict remains, the proposed technical object resolves the relevant part, and the evidence boundary makes the claim honest without sounding defensive.

## Numeric Whitelist

High-level numbers may enter the introduction when they establish necessity or delimit the contribution boundary:

- renewable/load penetration or share;
- the order of magnitude of an error or deviation (for example, "about one percentage point", "one order lower");
- time scale or horizon (minute level, day-ahead, annual planning);
- system-scale magnitude (thousands of buses, millions of state variables);
- engineering thresholds (voltage-violation ratio, N-1 count magnitude).

Fine-grained case numbers must stay in the case-study section, not the introduction:

- single-run records, multi-digit error values, specific runtimes, sentences such as "the maximum relative deviation is 0.83% under a given parameter".

Test: if the number argues why the work is worth doing or bounds where the contribution applies, it may stay; if it reports how much this experiment produced, move it to the case study.

## Sentence Patterns

Use patterns as logic, not boilerplate.

Chinese:

- "现有...方法能够...，但在...条件下难以..."
- "其主要原因在于..."
- "为解决上述问题，本文..."
- "不同于...，所提方法..."

English:

- "Existing ... methods capture ..., but they typically assume ..."
- "This limitation becomes restrictive when ..."
- "To address this gap, this paper formulates ..."
- "The main contributions are as follows."

## Anti-Patterns

Avoid:

- policy-only openings without a technical object;
- listing papers one by one instead of grouping method families;
- gap sentences without a cause;
- contributions that are only adjectives, such as "novel", "efficient", "accurate", or "comprehensive";
- Chinese introductions with a long contribution list that does not match the venue's natural style;
- IEEE Transactions introductions that hide contributions or state them without deliverables.
- TSG introductions where the data/learning/cyber layer is detached from grid physics or operation.
