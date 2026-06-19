# Figures, Tables, and Result Paragraphs

Use this reference when drafting or revising figure captions, table titles, result paragraphs, case-study interpretation, MATLAB-result summaries, ablation analysis, sensitivity analysis, or comparison discussion.

## Evidence Contract

Every figure or table must answer one reviewable question.

Before writing, identify:

1. Evidence object: figure, table, result file, MATLAB output, or reported metric.
2. System and scenario: feeder, transmission system, market case, event, uncertainty condition, or operating point.
3. Baseline or comparison object.
4. Metric direction and unit.
5. Supported claim and boundary.

If any item is missing, write only what the evidence supports and mark the missing item in a short note. Do not invent axes, units, baselines, confidence levels, case names, sample sizes, or solver settings.

Evidence description should carry the reproducibility facts that make the result interpretable. Put them where the reader naturally looks: case setup before comparisons, table notes for parameter or solver settings, captions for scenario/metric context, and result prose for the specific baseline or boundary being discussed. Do not move a fact into a caption or result paragraph only to make the text look complete; include it when it changes how the reader should interpret the number, trend, or comparison.

## Latest Evidence Selection

When the user does not name a specific run, use the latest coherent data and validation result as the manuscript evidence surface.

- Prefer result files whose metadata show `status: completed`, the newest `export_time` or timestamp, and consistency between `RunMetadata`, result CSV/MAT files, figure outputs, and validation/check reports.
- If multiple `figure_manifest.jsonl` entries exist for the same figure, select the newest entry that matches existing result files and the current run metadata. Do not default to the first manifest record.
- Treat a manifest record as stale if it references missing files, an older result object, a different sample count, a different model configuration, or a timestamp that does not match the current result tables.
- Use the newest validation or figure-check result that belongs to the same evidence surface. If the latest numerical table has no matching validation report, write the result as unverified or requiring figure/manual review rather than borrowing an older PASS status.
- If `latest` filenames conflict with dated or metadata-bearing outputs, trust the metadata-bearing output and state the conflict in a short note.

## Caption Rules

A caption should be self-contained but not a miniature abstract.

- Name the plotted or tabulated object, system/scenario, and metric.
- Include the comparison dimension when it is essential to understand the result.
- Do not write "performance comparison" or "simulation result" without the actual metric or operating condition.
- Do not put claims in the caption that are not visible in the figure/table.
- Keep captions compatible with the target venue's language and format.

Chinese journal caption pattern:

```text
图x [场景/系统]下[指标]随[变量/方法]的变化
表x [场景/系统]下不同方法的[指标]对比
```

IEEE caption pattern:

```text
Fig. x. [Metric] under [system/scenario] for [methods or operating conditions].
Table x. [Metric or quantity] for [system/scenario] under [methods or settings].
```

## Result Paragraph Rules

Each result paragraph should carry one message:

1. State the result judgment first.
2. Give the key number, direction, or ordering.
3. Explain the mechanism in power-system terms.
4. State the comparison baseline.
5. Close the boundary if the result is conditional.

Prefer:

```text
在台风高强度场景下，RT-GMM 将候选线路集合集中到少量高风险支路，说明多峰源荷尾部分布能够为拓扑筛选提供排序依据。该结果支持候选筛选和归因分析，不等同于逐事件过载概率的校准预测。
```

Avoid:

```text
仿真结果表明所提方法具有较好的有效性和优越性。
```

For IEEE:

```text
The proposed reserve policy reduces voltage-violation hours relative to the deterministic baseline because renewable forecast errors are mapped to recourse actions before the feeder constraint is evaluated. This result supports the security claim under the tested IEEE 123-bus scenarios, but it does not establish real-time deployability.
```

## MATLAB Result to Manuscript Text

When using MATLAB outputs, first extract the manuscript-facing fields:

- case system and scenario;
- method names exactly as used in the paper;
- metric names, units, and direction;
- baseline values and proposed-method values;
- sample count, scenario count, horizon, or data split when the claim depends on statistical spread, generalization, or uncertainty coverage;
- solver settings, convergence tolerance, runtime protocol, and platform only when the result supports a computational, scalability, real-time, or reproducibility claim;
- failed, missing, or smoke-only runs that limit the conclusion.

Do not describe script names, logs, cache state, or local file paths in manuscript prose unless the user is writing a reproducibility appendix.

## Table Writing

Tables are for precise comparison. A table paragraph should not repeat every cell.

- Explain the row or column that decides the claim.
- Name the best or boundary case only when the metric direction is clear.
- If the table shows mixed performance, write the tradeoff directly.
- If a baseline is missing, do not claim superiority.

## Figure Writing

Figures are for shape, mechanism, or trend.

- Explain the trend or separation that the reader should see.
- Tie the visual change to voltage, flow, reserve, uncertainty, topology, load, DER, market, or resilience meaning.
- Do not claim statistical significance, robustness, or generalization unless the evidence includes the required repetitions or scenario spread.

## Sensitivity and Ablation

Use sensitivity analysis to explain a mechanism or boundary, not to add length.

- Parameter sensitivity: state what changes, why it changes, and where the method stops being reliable.
- Ablation: state which model component is removed and which claim weakens.
- Scenario expansion: state whether the result generalizes, reverses, or becomes inconclusive.

## Review Gate

Before finalizing, check that:

- every figure/table is interpreted in the text;
- every result paragraph maps to an abstract or introduction claim;
- metric direction and units are clear;
- comparison baselines are named;
- conclusion strength matches the evidence.
