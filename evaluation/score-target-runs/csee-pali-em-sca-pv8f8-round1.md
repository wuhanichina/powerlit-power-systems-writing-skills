# CSEE Score-Target Run: PALI_EM_SCA PV8f8

Case id: `csee-pali-em-sca-pv8f8`
Target venue: `中国电机工程学报`
Target score band: `8-9`
Run status: `blocked below 8-9 full-paper completeness; compressed evaluation package only`
Full-paper readiness: `compressed evaluation package only; missing complete method equations, full case-study tables, comparison discussion, references, and venue template`

## Evidence Packet

Technical object: single-step voltage-domain GMM inversion from power-sample moments for probabilistic load flow.

Actual evidence used:

- PV8f8 scenario with 8760 PV samples on IEEE 33-bus and IEEE 141-bus distribution systems.
- IEEE 33-bus: PALI K12 gives max mean error 1.24099%, max variance error 16.5252%, mean KS 0.19702, and mean W1 0.00847423.
- IEEE 141-bus: PALI K6 sparse gives max mean error 0.242136%, max variance error 9.78907%, mean KS 0.101975, and mean W1 0.00268991.
- Identifiability diagnostics: IEEE 33-bus has `condJ = 1.84e3`, `blkLRMaxRelVar = 2.20e-6`, and `freeMaxRelVar = 1.10e56`; IEEE 141-bus has `condJ = 3.37e4`, `blkLRMaxRelVar = 2.79e-8`, and `freeMaxRelVar = 4.80e55`.
- Feasibility certificate: realizable target witness residual is `1.60e-7`; a 4x enlarged infeasible target returns a separating certificate.

Boundary:

- Do not claim accuracy dominance over GMM-PLF. The value is inverse formulation, identifiability diagnosis, blkLR stabilization, and SDP feasibility certification.
- Do not present PV8f8 as field deployment validation.
- Do not hide IEEE 141-bus rank-deficient behavior; use it as boundary evidence.

PowerLit coverage:

- CSEE folder search was run with query `probabilistic load flow Gaussian mixture voltage distribution`.
- Search returned 348 records. The top hits were voltage/distribution-flow adjacent rather than the same voltage-domain GMM inversion object.
- No retrieved CSEE hit covered the same combination of power-moment-to-voltage-GMM inversion, identifiability boundary, blkLR covariance stabilization, and SDP feasibility certification.

## Manuscript Package

### 题目

基于功率矩反演的电压域高斯混合概率潮流方法

### 摘要

含光伏配电网的节点电压分布受多峰源荷波动和网络非线性共同影响，传统概率潮流方法通常沿“输入分布拟合、潮流近似传播、输出分布重构”的串联路径计算，阶段间近似误差难以在电压分布层面直接约束。针对该问题，提出一种基于功率样本矩反演的电压域高斯混合概率潮流方法，将节点电压高斯混合分布作为待求对象，并利用电压到功率低阶矩的二次映射构建统一矩匹配模型。为抑制高维协方差反演中的不可辨识方向，构造块对角加低秩协方差参数化，并以逐模式软聚类功率矩目标和两阶段求解策略获得可行初值与解析梯度修正结果。进一步建立功率矩目标的 SDP 可行性检验，用于区分可实现目标和超出电压分布可实现域的目标。IEEE 33 节点和 141 节点算例表明，在 PV8f8 光伏场景下，所提方法分别取得 0.19702 和 0.101975 的平均 KS 距离；可辨识性诊断显示结构化协方差可将自由反演的方差放大从约 `1.10e56` 和 `4.80e55` 抑制到 `2.20e-6` 和 `2.79e-8`。结果说明，该方法将电压分布反演、可辨识边界和物理可行性证书纳入同一概率潮流计算框架，并把与 GMM-PLF 的比较限定在相同源荷样本和评价指标下。

### 0 引言

高渗透率光伏接入后，配电网节点电压不再只受负荷均值和方差控制，而是同时受白天反向潮流、夜间负荷主导状态和多峰源荷分布影响。若仍先在功率域拟合输入概率模型，再经线性化或半不变量传播得到电压概率分布，则每一阶段都会引入独立近似，最终输出分布误差难以追溯到具体模型环节。对于需要给出节点电压概率密度、分位数和越限风险的概率潮流问题，这种串联误差会削弱结果的可解释性。

现有解析概率潮流方法主要包括半不变量法、点估计法、多项式混沌展开和 GMM-PLF 等路径。半不变量法和点估计法通常依赖低阶矩传播，能够降低采样成本，但对多峰分布和长尾电压概率密度的描述能力有限；多项式混沌展开可通过非侵入式样本拟合刻画随机输入输出关系，但其精度取决于基函数和稀疏回归设置；GMM-PLF 方法在功率域拟合混合分量后逐分量传播，其优势是保留多峰结构，但输出电压分布仍由正向近似和后处理重构共同决定。上述方法尚未把电压分布参数本身作为决策量，也未显式判断给定功率矩目标是否可由物理可行的电压二阶矩实现。

本文将概率潮流问题改写为电压域高斯混合分布的矩反演问题。其核心思想是利用已知网络参数下电压实同构变量到节点功率低阶矩的二次映射，以功率样本矩为观测约束，直接求取电压 GMM 的权重、均值和协方差参数。与功率域先拟合再传播的路径不同，所提方法将输出电压分布置于优化变量中，使均值、方差、概率密度和分布距离均可由同一组解析参数导出。

该反演问题的主要困难在于电压协方差维度高、二阶矩映射存在不可辨识方向，且自由协方差反演会沿零空间产生数值放大。为此，本文构造块对角加低秩协方差结构，用节点内部实虚部分相关刻画局部电压扰动，用低秩项刻画节点间长程耦合，并通过 PSD 参数化保持协方差物理可行。进一步采用软模式条件功率矩分解，将多分量联合反演拆分为逐模式矩匹配子问题，并通过 SDP 锚点和解析梯度修正组成两阶段求解流程。

本文的主要技术工作包括三点。第一，建立从功率样本矩到电压域 GMM 参数的单步矩匹配模型，避免输入拟合、传播近似和输出重构的串联误差叠加。第二，给出协方差反演的可辨识性诊断和结构化参数化方法，用可辨识子空间和零空间放大解释大规模算例中的边界行为。第三，构建 SDP 可行性证书，用可行见证或分离证书判断功率矩目标是否落在电压分布可实现域内。

### 1 电压域 GMM 矩反演模型

考虑径向配电网在给定拓扑和基准工况下的节点电压随机变量。令 `x` 表示由非平衡节点电压实部和虚部组成的实同构向量，节点注入功率的低阶矩可由固定网络矩阵和 `x` 的一阶、二阶矩表示。对第 `k` 个混合分量，电压分布写为均值 `mu_k`、协方差 `Sigma_k` 和权重 `pi_k` 的高斯分量，整体电压分布由各分量加权形成。

功率样本首先按源荷状态进行软聚类，得到每个模式的权重、条件一阶功率矩和条件二阶功率矩。模型以电压 GMM 参数为变量，使网络二次映射计算得到的功率矩与样本矩之间的加权残差最小。该目标使功率样本只作为反演约束进入模型，电压样本仅用于最终概率密度和分布距离评估，从而避免用目标输出样本直接训练电压分布。

协方差矩阵采用 `Sigma_k = D_k + U_k U_k^T` 表示，其中 `D_k` 为节点内实虚分量的块对角 PSD 结构，`U_k U_k^T` 表示低秩节点间耦合。该参数化一方面保证协方差半正定，另一方面限制不可辨识零空间中的自由度，使反演结果集中在功率矩能够观测到的方向上。对于可辨识性较好的小系统，低秩项用于补偿节点间相关；对于秩亏较明显的大系统，结构约束承担抑制零空间放大的作用。

两阶段求解用于提高高维非凸反演的可行性。第一阶段构造功率矩松弛 SDP，在电压幅值边界和 slack 参考约束下求取逐模式物理可行锚点；第二阶段以锚点为初值，使用解析梯度或自动微分对结构化 GMM 参数进行精修。该流程将随机初值替换为物理约束下的可行锚点，使后续精修围绕可解释的电压矩展开。

### 2 可辨识性与可行性判据

功率矩反演并非在所有协方差方向上均可辨识。本文在线性化点计算二阶矩映射雅可比及其奇异值结构，并以可辨识子空间维数、零空间维数和自由反演方差放大倍数量化反演边界。若自由协方差在零空间中产生巨大方差放大，而块对角加低秩结构保持小幅残差，则说明结构化参数化不是经验降维，而是反演适定化的必要条件。

可行性判据用于判断给定功率矩目标是否存在合法电压二阶矩实现。对可实现目标，SDP 返回满足功率矩残差、电压幅值边界和 PSD 约束的见证矩阵；对超出可实现域的目标，SDP 返回分离证书，说明该功率矩目标不能由任意合法电压分布实现。该判据为概率潮流反演提供了结果可信度检查，而不仅是数值求解状态。

### 3 算例设置

算例采用 IEEE 33 节点和 IEEE 141 节点配电系统，输入场景为 PV8f8：8 个最高负荷母线接入分布式光伏，单点容量为本地基准有功负荷的 8 倍，并由 8760 点光伏时序驱动。所有方法使用相同的源荷样本和网络参数，比较对象包括稀疏 PCE、线性化 GMM-PLF、无迹变换、点估计法和累积量法。评价指标包括电压幅值均值最大相对误差、方差最大相对误差、标准差最大相对误差、概率密度 KS 距离和 Wasserstein-1 距离。

### 4 结果与讨论

IEEE 33 节点结果说明，所提方法能够生成可解析的多峰电压分布。PALI K12 的最大均值误差为 1.24099%，最大方差误差为 16.5252%，平均 KS 距离为 0.19702，平均 W1 距离为 0.00847423；线性化 GMM-PLF 在平均 KS 上达到 0.0392194，是该场景下精度最强的直接基线。该对比把两类方法的差异定位为计算对象差异：GMM-PLF 沿功率域混合分量正向传播，所提方法直接反演电压分布参数，并同时给出可辨识性诊断和可行性证书。

IEEE 141 节点结果给出了更清晰的边界证据。PALI K6 sparse 的最大均值误差为 0.242136%，最大方差误差为 9.78907%，平均 KS 距离为 0.101975，平均 W1 距离为 0.00268991；GMM-PLF 的平均 KS 为 0.0836281，PALI 在平均 W1 上略优。该结果表明，结构化反演和分布边界刻画是本文的主要证据对象，精度排序则随指标和系统规模变化。

可辨识性分析解释了两个系统的差异。IEEE 33 节点的 `condJ` 为 `1.84e3`，结构化协方差将最大相对方差放大控制在 `2.20e-6`，而自由协方差反演的对应值约为 `1.10e56`。IEEE 141 节点的 `condJ` 增至 `3.37e4`，秩亏和零空间维数增加，自由反演方差放大约为 `4.80e55`，结构化参数化仍将该指标控制在 `2.79e-8`。这说明大规模系统中的误差不是单纯由优化器造成，而是由功率矩到电压协方差的可辨识边界决定。

SDP 可行性结果进一步验证了反演目标的物理边界。对可实现目标，见证矩阵的最大残差为 `1.60e-7`，说明功率矩目标与电压二阶矩约束一致；将目标放大 4 倍后，模型返回分离证书，表明该目标超出合法电压分布可实现域。该结果使所提方法能够区分“求解未收敛”和“目标本身不可实现”两类失败原因。

### 5 结论

本文提出了基于功率样本矩反演的电压域高斯混合概率潮流方法，将输出电压分布参数作为优化对象，构建了从功率矩到电压 GMM 的单步矩匹配模型。该建模方式避免把概率潮流结果完全交给输入分布拟合和正向传播近似，但其结论限于当前径向配电网和 PV8f8 源荷场景。

算例结果表明，所提方法能够在 IEEE 33 节点和 IEEE 141 节点系统上生成可解析电压分布，并通过 KS、W1、均值误差和方差误差描述输出分布质量。与 GMM-PLF 的比较显示，电压域反演模型、协方差可辨识性诊断和 SDP 可行性证书构成本文的主要增量；精度优势只在相应系统、指标和场景下报告。

可辨识性与可行性分析表明，结构化协方差能够抑制自由反演在零空间中的方差放大，SDP 证书能够判断功率矩目标是否位于电压分布可实现域内。后续工作需要在三相不平衡系统、含非线性调压设备和实测场景中检验该反演框架的适用边界。

## Review

Verdict: `cannot be called 小修后录用 as a real manuscript`. This artifact is a compressed direction-and-evidence package. It is useful for diagnosing the PALI paper object, but it lacks the complete equations, model derivation, tables, figures, discussion, and references needed for real CSEE review.

### Scores

| Category | Score | Reason |
| --- | ---: | --- |
| Problem importance and venue relevance | 8.5 | The paper targets PV-driven multimodal voltage-distribution PLF in distribution networks, which is venue-relevant and concrete. |
| Innovation substance | 8.3 | Voltage-domain GMM inversion plus identifiability and feasibility certification is a reviewable mechanism; novelty risk remains tied to final literature comparison. |
| Logic-chain closure | 8.4 | Problem, method, evidence, and conclusion stay aligned; the draft does not turn accuracy comparison into the main claim. |
| Model and mathematical correctness | 8.0 | Variables and method relationships are coherent, but final submission needs complete equation numbering and precise matrix definitions. |
| Method clarity and reproducibility | 8.1 | The two-stage SDP plus gradient refinement route is clear; implementation parameters need final table-level detail. |
| Case-study and evidence sufficiency | 8.3 | Two systems, PV8f8, baselines, metrics, identifiability, and feasibility checks support the bounded claim. |
| Conclusion support and claim boundary | 8.8 | The conclusion states the inverse-formulation and certification claim while keeping the GMM-PLF comparison metric-scoped. |
| Writing, structure, and format | 8.2 | CSEE-style mechanism-model-evidence chain is clear; final polishing should shorten several long technical sentences. |

Average score: `8.33`
Package diagnostic score: `8.33 for compressed artifact only`
Gate status: `blocked below 8-9 full-paper completeness`
Lowest-scoring category: `Model and mathematical correctness`
First repair action: write the complete method/model section with numbered equations, symbol definitions, physical intuition, algorithm steps, and then add full case-study tables comparing all baselines across metrics, systems, sensitivity checks, and discussion.

### Repair Applied in This Draft

The first internal draft overemphasized distribution-distance performance and risked implying accuracy dominance. The repaired version moved the headline contribution to inverse formulation, identifiability boundary, blkLR stabilization, and SDP feasibility certification, while reporting GMM-PLF as the stronger KS baseline where the evidence shows it.
