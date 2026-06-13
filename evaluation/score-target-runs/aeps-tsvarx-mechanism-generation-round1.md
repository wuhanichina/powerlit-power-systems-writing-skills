# AEPS Score-Target Run: TS-VARX Mechanism Generation

Case id: `aeps-tsvarx-mechanism-generation`
Target venue: `电力系统自动化`
Target score band: `8-9`
Run status: `blocked below 8-9 full-paper completeness; compressed mechanism/scenario-generation package only`
Full-paper readiness: `compressed evaluation package only; missing complete model equations, applicability tables, full case-study comparison, discussion, references, and venue template`

## Evidence Packet

Technical object: weather-conditioned, city-level TS-VARX source-load mechanism reproducer and dynamic injection-scenario generator.

Actual evidence used:

- Full mechanism table: `624` event-city-mechanism rows.
- Event coverage: `12` typhoon events and `13` prefecture-city aggregations.
- Leave-one-event validation is recorded in the event table; each typhoon appears once as held-out and otherwise as training.
- Mechanism checks have no `fail` rows in the inspected full-event file.
- Applicable mechanism samples:
  - peak advance: `39` pass, `117` not applicable.
  - correlation flip: `75` pass, `81` not applicable.
  - wind rush: `80` pass, `76` not applicable.
  - wind loss: `14` pass, `142` not applicable.
- The model variants are separated as `raw_varx`, `correlation_corrected`, and `mechanism_corrected`; the claim relies on train-only mechanism variants, not raw VARX alone.

Boundary:

- Use the evidence for city-level mechanism reproduction and dynamic source-load injection-scenario generation.
- Do not claim load, wind, solar, or net-load point-forecasting superiority.
- Do not claim node-level VARX propagation, completed city-to-node injection mapping, closed-loop N-1 risk reduction, probabilistic power-flow closure, or GMM multimodal injection modeling.
- If the title or abstract is changed to grid-risk propagation, the current evidence falls below the 8-9 full-paper gate.

PowerLit coverage:

- AEPS folder search with query `typhoon source load VARX scenario generation` returned zero records.
- Chinese query `台风 源荷 场景 生成 负荷 风电` also returned zero records through the script interface, likely because the lightweight search treats the Chinese query as one term.
- A fast `rg` scan over the AEPS JSON folder found adjacent papers on uncertainty, scenario generation, wind/photovoltaic output, probabilistic power flow, and security-region analysis, but no inspected candidate matched the same combination of typhoon weather covariates, city-level source-load anomaly trajectories, windowed TS-VARX, train-only mechanism correction, and dynamic injection-scenario generation.
- Final submission still needs a curated Chinese reference table; the current evidence is enough for score-target skill debugging, not for final citation completeness.

## Manuscript Package

### 题目

计及台风天气过程的城市级源荷动态机制复现与注入场景生成方法

### 摘要

台风过程会同时改变负荷、风电和光伏出力的时序形态，使常规同月同小时基线难以刻画源荷异常的提前、相关性翻转和风电阶段性变化。为支撑后续输电风险分析中的动态注入场景构造，提出一种计及台风天气过程的城市级源荷动态机制复现方法。首先，以非台风同月同小时数据为基准，构建城市负荷、风电和光伏异常状态，并聚合与城市相关的 Holland 风场协变量。然后，按预警、告警和后告警窗口以及风速状态建立岭回归 TS-VARX 模型，并设置原始 VARX、相关性修正和机制修正 3 类输出变体。最后，采用留一台风事件验证，对峰值提前、源荷相关性翻转、风电 rush 和风电 loss 4 类机制进行适用性判别和复现检查。12 个台风事件、13 个城市的 624 条事件-城市-机制记录表明，所有适用样本均通过机制检查，其中峰值提前、相关性翻转、风电 rush 和风电 loss 的通过样本数分别为 39、75、80 和 14。结果说明，所提方法可将台风天气驱动的源荷现象转化为可复现的城市级动态注入场景；当前证据不支持节点级风险传播或 N-1 风险降低结论。

### 0 引言

台风影响下的电力系统运行风险并不只来自线路故障或设备停运。强风、降雨和云量变化还会改变城市负荷、风电和光伏出力的时间轨迹，使源荷注入偏离常规运行统计特征。若后续风险分析仍采用非台风日的静态注入场景，可能无法反映台风过程中的负荷峰值提前、风电先增后降以及源荷相关性变化。

现有场景生成研究多关注风光不确定性、负荷随机性或多能源系统运行场景，能够为调度和安全分析提供随机输入。但对于台风过程，关键问题不是单一变量的点预测精度，而是能否把观测到的源荷异常机制转化为可重复生成的动态注入轨迹。若模型只报告平均预测误差，可能掩盖机制是否被复现；若直接声称风险降低，又需要完成城市到节点映射和潮流风险传播验证。

本文将研究对象限定为城市级源荷机制复现和注入场景生成。模型以城市负荷、风电和光伏异常为状态变量，以台风风场统计量及其变化率为外生变量，在不同预警窗口和风速状态下建立 TS-VARX 关系。为避免把原始线性 VARX 的预测误差解释成机制能力，本文进一步设计相关性修正和机制修正变体，用训练事件中识别出的机制方向生成动态场景。

本文主要工作如下：1）建立天气协变量到城市级源荷异常状态的接口，用于描述台风过程中的动态注入变化；2）构建分窗口、分风速状态的 TS-VARX 机制复现模型，并区分原始 VARX、相关性修正和机制修正输出；3）基于 12 个台风事件和 13 个城市开展留一事件验证，按适用性样本统计峰值提前、相关性翻转、风电 rush 和风电 loss 4 类机制的复现结果。

### 1 问题描述与状态构造

对城市 `c` 和时刻 `t`，定义源荷异常状态向量为负荷、风电和光伏相对非台风同月同小时基线的偏差。该状态不用于直接声明预测精度，而用于描述台风过程中注入场景相对正常运行状态的动态偏移。为引入天气驱动因素，将城市所关联线路或区域上的 Holland 风场统计量聚合为外生变量，包括平均风速、95% 分位风速、最大风速及其变化率。

事件过程按预警、告警和后告警窗口划分，并进一步按风速状态区分。这样做的目的在于避免用一个全局线性模型同时解释台风靠近、登陆和远离阶段的不同源荷响应。窗口和风速状态共同决定 TS-VARX 参数组，使模型能够表达负荷峰值时移、风电中等风速增发和高风速损失等不同机制。

### 2 TS-VARX 机制复现模型

在给定窗口 `k` 和风速状态 `r` 下，城市源荷异常状态由滞后源荷状态和天气协变量共同解释。模型采用岭估计获得系数，以降低不同城市样本量和变量维数差异带来的不稳定性。输出保留 3 类变体：`raw_varx` 作为递归 VARX 基准；`correlation_corrected` 用训练事件识别出的源荷相关性方向修正相关性翻转；`mechanism_corrected` 用训练事件中的峰值时移和风速阶段规则修正峰值提前、风电 rush 和风电 loss。

机制检查不把所有城市-事件样本都强行纳入同一指标。若观测事件本身未出现清晰机制，或城市没有映射的风电列，则该机制被标记为不适用。只有在机制适用时，才检查模型输出是否在容差内复现对应方向。例如，峰值提前检查输出峰值时刻是否在容差内沿相同方向移动；相关性翻转检查输出相关性是否具有事件中的翻转符号；风电 rush 和 wind loss 分别检查中等风速正异常和高风速负异常。

### 3 算例设置

算例覆盖 12 个台风事件和 13 个城市。每次验证将一个台风事件作为 held-out，其余事件用于训练机制方向和 TS-VARX 参数。事件时间窗长度为 73 到 176 个时刻，所有事件记录状态均为 `ok`。机制表共包含 624 条事件-城市-机制记录，字段包括事件、城市、机制类型、预测变体、状态、观测指标、预测指标、参考指标、容差和适用性说明。

评价不采用点预测误差作为主指标，而采用机制级通过/不适用统计。这样可以保证论文结论对应于“机制复现和场景生成”，而不是误写为“负荷或风电预测模型”。对需要后续电网风险分析的场景，本文只给出从城市级源荷机制轨迹到动态注入场景的接口，不声称已完成城市到节点映射或 N-1 风险传播。

### 4 结果分析

机制检查结果显示，624 条记录中没有 fail 样本。峰值提前机制有 39 个适用样本全部通过，117 个样本因观测负荷峰值未清晰提前而标记为不适用。相关性翻转机制有 75 个适用样本全部通过，81 个样本不适用。风电 rush 机制有 80 个适用样本全部通过，76 个样本不适用。风电 loss 机制有 14 个适用样本全部通过，142 个样本不适用。

上述结果说明，机制修正变体能够在适用样本中复现观测到的源荷动态方向。峰值提前和相关性翻转反映了台风过程对负荷时序和源荷耦合关系的影响；风电 rush 和 wind loss 则对应中等风速出力增加和高风速出力受限两个阶段。由于不同城市的风电接入和观测机制不同，不适用样本本身也是场景生成边界的一部分，不能被当作失败样本或隐藏在总准确率中。

从论文证据角度看，当前结果足以支持城市级动态注入场景生成。模型能够把台风天气协变量、源荷异常状态和训练事件中的机制方向连接起来，并在留一事件验证中保持机制复现。当前结果还不能支持节点级风险结论，因为城市级异常尚未映射到电网节点注入，也没有通过潮流或 N-1 风险计算验证场景对线路越限概率的影响。

### 5 结语

本文提出了计及台风天气过程的城市级源荷动态机制复现与注入场景生成方法。该方法构建了天气协变量到源荷异常状态的接口，并通过分窗口、分风速状态的 TS-VARX 模型及训练事件机制修正，生成可用于后续风险研究的动态注入轨迹。

12 个台风事件和 13 个城市的验证结果表明，在峰值提前、相关性翻转、风电 rush 和风电 loss 4 类机制的适用样本中，模型输出均通过机制复现检查。本文结论限于城市级机制复现和场景生成；后续需要进一步完成城市到节点注入映射、潮流传播和 N-1 风险验证，才能形成完整的电网风险评估论文。

## Review

Verdict: `cannot be called 小修后录用 as a real manuscript`. The artifact supports a mechanism/scenario-generation direction, but it is not a complete AEPS paper because it lacks full equations, applicability/tolerance tables, complete case comparison, discussion, references, and final manuscript structure.

### Scores

| Category | Score | Reason |
| --- | ---: | --- |
| Problem importance and venue relevance | 8.3 | Typhoon-driven source-load scenario generation is operationally relevant to AEPS when framed as an input mechanism for risk studies. |
| Innovation substance | 8.1 | The contribution is a bounded weather-conditioned TS-VARX mechanism interface, not a generic forecasting model. |
| Logic-chain closure | 8.4 | Weather covariates, city-level anomaly states, mechanism variants, and mechanism checks stay aligned. |
| Model and mathematical correctness | 8.1 | The state, exogenous variables, windowing, and ridge TS-VARX formulation are coherent; final equations need full notation and parameter tables. |
| Method clarity and reproducibility | 8.0 | Event, city, mechanism, variant, status, and tolerance fields are explicit, but the final paper should include the exact applicability rules. |
| Case-study and evidence sufficiency | 8.2 | Twelve events, thirteen cities, leave-one-event validation, and no failed applicable mechanism samples support the mechanism-generation claim. |
| Conclusion support and claim boundary | 8.8 | The draft explicitly blocks forecasting-superiority, node-level propagation, and N-1 risk-reduction claims. |
| Writing, structure, and format | 8.2 | The draft follows AEPS's concise problem-model-case-conclusion rhythm. |

Average score: `8.26`
Package diagnostic score: `8.26 for compressed artifact only`
Gate status: `blocked below 8-9 full-paper completeness`
Lowest-scoring category: `Method clarity and reproducibility`
First repair action: write the complete TS-VARX model and mechanism-check equations, then add applicability/tolerance tables, event-city comparison tables, mechanism-wise discussion, and a clear boundary separating scenario generation from node-level risk propagation.

### Repair Applied in This Draft

The first framing risk was to present the project as a typhoon risk-propagation paper. The repaired draft moves the contribution to city-level source-load mechanism reproduction and dynamic injection-scenario generation, while explicitly naming city-to-node mapping and N-1 risk propagation as future evidence requirements.
