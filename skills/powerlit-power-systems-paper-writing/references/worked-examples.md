# Worked Examples: Before → After

Use this as an optional deep aid when a delivery gate flags a passage but the repair is unclear. Each example pairs a failing draft with a repaired version and names the gate that drives the repair. Load it only when a Tier-0 gate is insufficient; it is not part of the default writing load.

These examples are illustrative, not a content source. They use synthetic prose around recurring teaching cases (typhoon distribution-network risk screening, inverse probabilistic load flow, distributionally robust AC OPF, distributed voltage control). Do not copy their bracketed placeholders, qualitative phrasings, or any value into a manuscript as if it were a real result; replace every `[...]` with the manuscript's own evidence. Match the venue register; never move a Chinese example verbatim into an IEEE paper or vice versa.

## 中国电机工程学报 (CSEE)

### Introduction opening — trend that never lands → trend pivot that reaches the conflict

Before (fails opening pain-point gate, Tier 1):
> 随着新能源渗透率不断提高，电力系统安全运行面临新的挑战。新能源的发展对电网提出了更高要求，如何保障电网安全成为研究热点。本文对此展开研究。

Why it fails: the whole first paragraph stays at context level; no concrete object, no failing condition, no conflict (`introduction-scalpel.md` Tier 1; sentence-deletion test).

After:
> 随着新能源渗透率不断提高，配电网运行条件日益复杂。台风过境期间，源荷出力与拓扑状态同时偏离常态，使得基于常态统计的风险筛查会系统性漏判真正承压的支路——这正是本文要解决的问题。

Why it passes: the trend is a pivot; the concrete object (配电网/支路)、failing condition (台风过境) 和 conflict (常态统计漏判) all land in the first paragraph.

### Key-equation paragraph — symbol dump → physical intuition

Before (fails Formula Physical Intuition; reader-experience formula-density burden):
> 由式(3)可得电压均值与协方差到功率矩的映射，式中：μ 为电压均值向量，Σ 为电压协方差矩阵，Y 为节点导纳矩阵。该映射用于后续求解。

Why it fails: defines symbols only; no cause-effect direction, no physical reading, no limiting case (`method-model.md` Formula Physical Intuition).

After:
> 式(3)是一个二次型潮流核：电压的均值与协方差通过网络导纳生成有功/无功功率矩，而非来自一般统计拟合。因此功率矩中可被观测的协方差方向是有限的，位于零空间的协方差分量不应被解释为真实的电压波动；当各节点注入相互独立时，式(3)退化为仅由对角协方差驱动的功率方差表达。

Why it passes: names the grid object (二次型潮流核)、cause-effect (导纳生成功率矩)、identifiability boundary (零空间)、and a limiting case (注入独立).

### Case result paragraph — 泛称有效性 → mechanism + boundary

Before (fails sentence-deletion test and the case-conclusion result-discussion layer):
> 仿真结果验证了所提风险筛查方法的有效性和优越性，结果表明该方法显著优于传统方法，具有良好的工程应用价值。

Why it fails: no scenario/metric/baseline/mechanism; empty intensifiers (显著/良好); superiority claim without comparison (`prose-quality-gates.md` sentence-deletion; `case-conclusion.md`).

After:
> 在台风过境场景下，所提方法将真正承压支路的漏判率由 [基线指标] 降至 [方法指标]；改进来自将拓扑偏移与源荷同时偏离纳入筛查判据，使常态统计下被掩盖的支路重新进入风险集。该结论限于风险筛查与定位，不外推为支路越限概率的精确预测。

Why it passes: scenario、metric direction、baseline、mechanism (拓扑偏移+源荷偏离)、and an explicit boundary (筛查/定位 而非精确预测).

### Defensive boundary opener → positive technical subject

Before (fails boundary-posture pass and the SKILL hard rule on `本文不...`):
> 需要强调的是，本文不把结果表述为对线性化 GMM 概率潮流的全面精度替代。

After:
> 本文以电压状态分布反演为目标，在 [给定松弛模型与约束] 下给出可辨识边界与可行性证书；与线性化 GMM 概率潮流相比，二者解决的是不同问题，所提方法在 [可辨识性/反演能力] 上提供后者不具备的能力。

Why it passes: opens with a positive technical subject (反演目标)、scopes the comparison、and drops the defensive `不...` opener.

## 电力系统自动化 (AEPS)

### Abstract — long conceptual motivation → compact operational

Before (fails the manuscript-section-quality Abstract movement and sentence-deletion):
> 在新型电力系统建设背景下，源网荷储协调优化具有重要意义。为了实现系统的安全经济运行，本文对源网荷储协调优化问题进行了深入研究，提出了一种新的协调优化方法，并通过算例验证了方法的有效性。

Why it fails: two sentences of background/importance; no scenario, variables, constraints, or metric.

After:
> 针对 [场景] 下源网荷储多时间尺度出力不匹配的问题，构建以 [目标] 为目标、计及 [关键约束] 的协调优化模型，并采用 [求解方法] 求解。在 [测试系统] 上，与 [基线] 相比，[指标] 由 [值] 改善至 [值]，验证了协调策略在 [运行条件] 下的有效性。

### Method — venue drift into dispatch → object-preserving

Before (fails `venue-profiles.md` no-topic-conversion rule; the supplied paper is a state-estimation paper):
> 本文从电网调度运行角度出发，构建日前-日内多时段经济调度模型……

Why it fails: rewrites a non-dispatch object into dispatch prose because the venue is AEPS (venue drift).

After:
> 本文以配电网状态估计为对象，以 [量测集] 为输入，构建计及 [量测误差模型] 的状态估计模型，状态量为 [状态量]，约束包括 [物理约束]，采用 [估计算法] 求解。

## IEEE TPWRS

### Contribution bullets — adjectives only → deliverable + technical gain

Before (fails `introduction-scalpel.md` anti-pattern: adjective-only contributions):
> The main contributions are: (1) a novel framework; (2) an efficient algorithm; (3) comprehensive case studies.

After:
> The main contributions are: (1) a distributionally robust AC OPF formulation that embeds [uncertainty set] over nodal injections; (2) a [reformulation] that renders the problem [tractable property] without [common assumption]; (3) a case study on [systems] quantifying the cost of robustness against [baseline] under [scenario].

### Method — hidden assumption → assumption-explicit

Before (fails the `method-model.md` SOCP exactness template):
> We reformulate the AC OPF as an SOCP and solve it efficiently.

After:
> We relax the AC power-flow equations to an SOCP. The relaxation is exact for [radial/meshed] networks under [objective monotonicity] and [no reverse-flow / no load over-satisfaction] conditions; when binding upper-voltage constraints violate these conditions, we report the relaxation gap rather than assume exactness.

## IEEE TSG

### Result paragraph — algorithm metric without grid meaning → grid-operational meaning

Before (fails the `case-conclusion.md` TSG rule and the TSG profile):
> The proposed controller achieves lower loss and faster convergence than the baseline.

After:
> Under [feeder] with [delayed-communication] conditions, the controller reduces the feeder voltage-violation ratio from [value] to [value] using only local inverter measurements; the gain comes from [mechanism], and it narrows as communication delay exceeds [threshold], which bounds the claim to the [delay] regime.

### Introduction — data/learning detached → tied to grid operation

Before (fails `introduction-scalpel.md` TSG anti-pattern: AI layer detached from grid physics):
> Deep learning has achieved great success in many fields. This paper applies it to smart grids.

After:
> Local inverter controllers must limit feeder voltage violations without a full system model or fast communication. Model-based methods assume [assumption] that fails under [DER variability]; a learning-enabled local controller can act on local measurements, but its grid value depends on whether it keeps voltages within limits under [communication/uncertainty condition], which this paper tests directly.

## Cross-Venue Reminder

Every "after" example still obeys the no-invention boundary: bracketed slots are evidence the manuscript must supply. If the evidence is missing, keep the slot as a gap note instead of inventing a value. The examples teach sentence shape and logic, not content; the technical object, numbers, baselines, and boundaries must come from the current manuscript.
