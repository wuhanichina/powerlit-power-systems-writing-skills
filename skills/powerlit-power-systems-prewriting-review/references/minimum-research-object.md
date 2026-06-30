# Minimum Research Object Gate

Use this reference before innovation-chain scoring, pain-point scoring, venue-fit judgment, or physical-story design.

The prewriting review must first identify the smallest expert community that would naturally review the paper. Do not start from a broad power-system application area when the supplied method, variables, evidence, or closest competitors indicate a narrower research object.

## Purpose

High-level papers can make a major contribution inside a narrow research object. Finding that object is part of the innovation work. A broad industry scene is useful only after the narrow object is locked.

The review must distinguish:

- broad application background: renewable integration, distribution operation, resilience, planning, reliability, market, or smart grid;
- research direction: probabilistic load flow, AC OPF relaxation, distribution-state estimation, voltage control, protection coordination, risk assessment, restoration, or another method family;
- minimum research object: the most specific object that matches the paper's title, variables, equations, baselines, and case evidence, such as analytical AC probabilistic load flow, voltage-domain inverse PLF, moment-relaxation feasibility certificate, or topology-aware typhoon risk index.

## Narrowing Procedure

Lock these fields before naming the innovation:

| Field | Required question |
| --- | --- |
| `minimum_research_object` | What is the smallest research object or method family that owns the problem? |
| `small_peer_group` | Which small-field experts would review this paper and know the nearest baselines? |
| `closest_problem_family` | Which existing problem family supplies the real pain points and comparison logic? |
| `broad_background` | What larger engineering background is allowed only as motivation, not as the main pain point? |
| `non_objects` | Which adjacent objects must not be imported into the story without evidence? |

Choose the narrowest object supported by all four anchors:

1. title and keywords;
2. mathematical variables and physical quantities;
3. baseline methods and literature competitors;
4. case-study outputs and claim-bearing figures/tables.

If the four anchors disagree, state the conflict. Do not widen the object to hide the mismatch.

## Pain-Point Alignment

After the minimum research object is locked, define the pain point inside that object:

- For a probabilistic-load-flow paper, compare against PLF pain points, not a new operation, planning, or dispatch application unless the evidence directly studies that application.
- For an analytical-method paper, compare against analytical-method limitations before comparing against Monte Carlo or broad engineering workflows.
- For an inverse, diagnostic, certificate, or state-distribution paper, treat the new object itself as a possible innovation when nearby literature has not posed or solved that object.

Industry or engineering pain-point scoring must ask whether the narrow-object pain point is accurate. A real broad background cannot compensate for a wrong or oversized narrow-object problem.

## Innovation Repositioning

When several framings are possible, prefer this order:

1. a newly identified research object or problem formulation;
2. a new physical state, coupling, certificate, boundary, or mechanism inside that object;
3. a new analytic construction that enables a capability other methods in the same object do not provide;
4. numerical accuracy or efficiency gains.

Do not demote a genuine new research object merely because it is narrow. Conversely, do not inflate a narrow method improvement into a broad industry solution.

## Output Requirement

In prewriting output, include a short `最小研究对象定位` section before `真实创新点重定位`:

- `最小研究对象`;
- `小同行问题域`;
- `对应痛点`;
- `不应扩展到`;
- `创新是否来自新研究对象本身`.

Example pattern:

> 最小研究对象不是“高比例新能源配电网运行评估”，而是“解析交流概率潮流中的电压状态分布反演”。因此痛点应从解析 PLF 的输出对象、状态分布可得性、支路功率概率重构和可辨识边界出发，而不是重新寻找新的工程应用背景。

