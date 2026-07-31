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

## PowerLit Neighbor Evidence Plan

When PowerLit is available and the task involves case analysis, figures, tables, result paragraphs, or a full paper, inspect venue-near and problem-near papers before choosing what to show. Build an internal `figure/table argument map`:

- visual type: setup diagram, topology map, time-series profile, uncertainty distribution, convergence curve, baseline comparison table, sensitivity sweep, ablation result, runtime/scalability table, boundary/failure case, or spatial/topological risk map;
- evidence question: what the visual lets a reviewer decide;
- supported claim: which contribution, mechanism, comparison, reproducibility fact, or boundary the visual supports;
- minimum visible facts: system, scenario, baseline, metric, unit, sample size, solver/protocol, parameter setting, or confidence level;
- text role: whether the result paragraph should report an ordering, explain a mechanism, identify a tradeoff, justify a parameter, or close a boundary.

Use neighboring papers to learn the expected evidence functions for the claim class. Do not imitate their exact figure set, labels, colors, or captions. Do not invent unavailable figures. If the current project lacks a figure/table function that near-neighbor papers treat as central, either mark the missing visual as a blocker, ask for the result, or narrow the claim.

Good case-analysis design usually contains a balanced evidence chain:

- setup evidence: test system, data, scenario, assumptions, or operating condition;
- main comparison: proposed method against fair baselines on the primary metric;
- mechanism evidence: why the improvement, failure, concentration, or tradeoff occurs;
- sensitivity or ablation: which parameter, module, or assumption controls the claim;
- boundary evidence: where the method stops, weakens, or should not be generalized;
- computation/reproducibility evidence when claiming tractability, scalability, online use, or repeatability.

Only keep the functions relevant to the paper's actual claim. A diagnostic or screening paper may need attribution and boundary figures more than dominance tables. A dispatch/control paper may need operating trajectories and constraint-violation metrics. A formulation paper may need relaxation gap, convergence, and feasibility evidence.

## Causal Attribution Discipline

Do not infer a mechanism merely because a result is compatible with it.

- State the pre-result physical or model expectation in the figure plan.
- Identify all factors that could independently produce the same pattern.
- Isolate the claimed factor with a matched baseline, one-factor sweep, ablation, stratification, intervention, or counterfactual comparison.
- Do not use one composite case to attribute the same feature simultaneously to location, capacity, uncertainty source, nonlinear effect, and method component.
- Separate the observed pattern from the mechanism status. Use `isolated`, `consistent with`, or `hypothesized` according to the evidence.
- If the plot shows only the final outcome, treat the mechanism as an interpretation and name the intermediate quantity or additional test needed for causal attribution.

The prose order should be expectation -> observation -> quantitative comparison -> mechanism status -> claim consequence. A result may contradict the expectation; report the contradiction and revise the mechanism rather than forcing the planned story.

## Case-Section Figure Storyboard

Design the case section's figures as one ordered engineering story before writing any result prose. A reader who looks only at the figures, their captions, and their order should be able to recover the paper's problem, mechanism, and bounded result. The per-figure rules above make each figure defensible; this storyboard makes the figure set legible as a whole.

Map the figure set onto the story acts using the existing `evidenceRole` vocabulary rather than a second taxonomy:

| Act | What the reader must see | Typical evidenceRole | Failure if missing |
| --- | --- | --- | --- |
| Engineering scene | the system, operating condition, and the quantity at stake | `scenario-setup` | the reader cannot tell what physical situation is being tested |
| Physical contradiction | the conventional treatment failing under that condition | `scenario-setup` or `sota-comparison` | the paper looks like an improvement without a problem |
| Mechanism | the intermediate physical or model quantity that explains both the failure and the fix | `physical-reproduction` | the mechanism exists only as a prose assertion |
| Technical object at work | the proposed object against a matched baseline on the decision-relevant metric | `sota-comparison` | the claim rests on aggregate numbers the reader cannot inspect |
| Boundary | where the effect weakens, reverses, or stops being tested | `sensitivity-ablation` | the scope must be taken on trust |

One principal figure per act is the target. If two figures carry the same act, merge them or move one to supplementary material. If an act has no figure and none is planned, the story is prose-dependent at that step: design the figure or record the gap.

### Make the mechanism visible, not narrated

- Plot the intermediate quantity, not only the endpoint outcome. A mechanism asserted in prose but absent from every figure stays `consistent with` at best.
- Put the threshold, limit, crossing, or violation boundary on the axes as a line, band, or marked point. Do not describe in text a feature the reader cannot locate in the figure.
- Show with/without, before/after, and proposed/baseline on shared axes and shared units so the difference is read rather than computed.
- Keep axes, units, scaling, and color meaning identical across figures the reader is expected to compare.
- One message per panel. Use panels (a), (b), (c) for one causal progression, not for unrelated results grouped to save space.
- Prefer physical and operational units on the axes over normalized scores when the claim is about grid behavior.

### Figures-Only Read Test

Before writing result prose, read the planned or exported figures in order, with captions only:

1. Can a qualified power-system reader name the system, operating condition, and quantity at stake?
2. Is the unresolved conflict visible as a failure, gap, violation, or mismatch rather than asserted?
3. Is the mechanism visible through an intermediate quantity, an intervention, or a matched contrast?
4. Are the baseline, metric direction, and matched condition readable from the figure and caption?
5. Is the boundary visible as a condition where the effect weakens, reverses, or was not tested?

If a step fails, repair the figure set first: add the missing act, plot the intermediate quantity, annotate the threshold, unify the axes, or merge redundant figures. Do not repair a figure-set gap by writing a longer result paragraph.

When the test passes, the result paragraph's job changes: it points at what the figure already shows and states the consequence, instead of carrying the mechanism alone. This is the intended division of labour with the result-paragraph coverage order below — the storyboard decides what the figures must show, the coverage order decides what the prose must add.

## Project-Template Figure Plan Bridge

When the project follows the MATLAB lite template or contains `01_IDEA/figure_plan.md`, `.cursor/rules/04-case-figure-and-metric-plan.mdc`, `result/<case>/figures/`, or `ProjectName_utils.plotting.save_figure`, use PowerLit before plotting to fill or revise the template figure plan. Do not start from the plots that are easiest to draw.

The PowerLit-derived case and figure plan should be template-ready. For each claim and case, provide:

- `claim`: the claim id from `01_IDEA/claims.md` or the current claim boundary;
- `evidenceRole`: one of `scenario-setup`, `physical-reproduction`, `sota-comparison`, or `sensitivity-ablation`;
- `sciQuestion`: the reviewable scientific or engineering question answered by the figure;
- `physicsReproduction`: the actual measurement, trusted simulation, analytical reference, benchmark behavior, known physical constraint, or operating pattern that the proposed model must reproduce;
- `metric`: definition, unit, direction, and why PowerLit near-neighbor papers or the problem family treat it as a recognized quantity;
- `figureType`: figure/table type learned from near-neighbor evidence practice and matched to the current data shape;
- `dataFiles`: expected `result/<case>/...` source files or a missing-data blocker;
- `visualEncoding`: axes, groups, colors/line styles, normalization, and whether uncertainty or residuals must be shown;
- `figurePlanId` and `contractVersion`: stable links to the project plan and
  versioned handoff contract;
- `expectedTrend`: the pre-result trend whose presence or absence tests the claim;
- `keyFeatureToInspect`: threshold, reversal, peak, separation, concentration,
  crossing, tail, spatial cluster, or residual pattern that deserves attention;
- `mechanismToTest`: the intermediate physical/model quantity that should
  explain the visual pattern;
- `advantageCriterion`: the exact baseline-relative or decision-relative
  condition that would constitute an advantage;
- `boundaryTest`: the condition under which the trend or advantage should
  weaken, reverse, or become inconclusive;
- `storyboardAct`: which case-section storyboard act this figure carries —
  engineering scene, physical contradiction, mechanism, technical object at
  work, or boundary;
- `figureOnlyReadable`: whether this act survives the figures-only read test
  from the figure and caption alone, or still depends on result prose;
- `templateMetadata`: fields needed by `save_figure`, including `claimId`, `sciQuestion`, `physicsReproduction`, `evidenceRole`, `dataFiles`, `dataDescription`, `visualEncoding`, `targetLayout`, `command`, `keyParams`, and `randomSeed`.

Respect the template evidence-role order per claim:

1. `scenario-setup` orients the case.
2. `physical-reproduction` shows the proposed model reproduces real or trusted-reference physical behavior.
3. `sota-comparison` compares against closest baselines at matched conditions.
4. `sensitivity-ablation` tests parameters, modules, runtime, scale, or boundary.

Do not plan `sota-comparison` or `sensitivity-ablation` figures before a `physical-reproduction` figure exists or is explicitly marked as a blocker for the same claim. If PowerLit neighbors usually compare parameter ranges, step sizes, defaults, normalization, or x-axis organization, report those choices in the plan before proposing a local sweep. If the current project uses different parameters or ranges, state the reason in the plan so it can be copied into `01_IDEA/figure_plan.md`, the manifest, or the caption draft.

Output boundary: PowerLit proposes the plan; the project template enforces the export. The plan should name missing computations rather than fabricate figure metadata, result files, or reference behavior.

Planning fields are hypotheses, not observed results. Keep
`expectedTrend`, `keyFeatureToInspect`, `mechanismToTest`,
`advantageCriterion`, and `boundaryTest` in `figure_plan.md`; factual manifests
record only their plan reference and the exported data/artifacts.

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

Each main figure must be explained from the current plot-data file and matching
manifest/check report, in this order:

1. **Condition:** system, scenario, x-variable/range, compared objects, metric,
   unit, and direction.
2. **Trend:** what rises, falls, concentrates, separates, crosses, saturates, or
   reverses over the plotted range.
3. **Key feature:** the threshold, extremum, crossing, spatial cluster, tail, or
   regime change that carries the figure's message.
4. **Quantitative difference:** the decisive value, range, slope, gap, error, or
   ordering against the named baseline. Do not invent precision not present in
   the plot data.
5. **Mechanism:** why the trend and key feature arise in power-system or model
   terms, preferably through an intermediate quantity, constraint, coupling, or
   ablation. Label a mechanism as `isolated`, `consistent with`, or a hypothesis
   according to the causal evidence; a compatible outcome alone does not isolate
   its cause.
6. **Problem answered:** which scientific or engineering question the observed
   pattern resolves.
7. **Method advantage:** where the method has an advantage under the predeclared
   `advantageCriterion`; mixed or absent advantage must be written as a tradeoff
   or boundary, not smoothed into superiority.
8. **Engineering implication:** what planning, operation, control, protection,
   market, risk, or diagnostic decision changes.
9. **Boundary:** where the interpretation weakens, reverses, or remains untested.

This is a coverage and reasoning order, not a requirement to write nine
sentences. Combine adjacent functions when one load-bearing sentence can carry
them without losing the evidence chain.

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
- Do not describe a figure from its caption, image impression, or expected
  trend alone when plot data exist. Match `figurePlanId`, `claimId`, data file,
  manifest timestamp, and current run before writing.
- A "pure figure translation" fails when it only lists axes, colors, and visible
  changes. It passes only when trend, key feature, quantitative difference,
  mechanism status, answered problem, advantage/tradeoff, implication, and
  boundary are covered.

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
- every main figure has a matching current plot-data/manifest surface and the
  condition → trend → key feature → quantitative difference → mechanism →
  problem → advantage → implication → boundary coverage;
- expected planning trends are not reported as observations unless confirmed by
  actual plot data.
- causal explanations identify and control competing factors, or are explicitly
  labeled as consistency/hypothesis rather than isolated mechanism evidence.
- the figure set passes the figures-only read test: read in order with captions
  alone, it carries the engineering scene, the physical contradiction, the
  mechanism through an intermediate quantity, the matched comparison, and the
  boundary. A missing act is repaired by designing or exporting the figure, or
  recorded as a gap — never by lengthening the result prose.
