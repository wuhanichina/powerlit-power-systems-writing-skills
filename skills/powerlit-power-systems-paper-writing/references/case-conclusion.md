# Case-Study and Conclusion Reference

Use this reference when drafting or revising case-study, numerical-results, experiment, simulation, conclusion, or closing sections for 中国电机工程学报, 电力系统自动化, IEEE TPWRS, and IEEE TSG.

## Corpus Signal

PowerLit mining found that case/result and conclusion sections are near-universal:

- 中国电机工程学报: case/result sections in 96.3% of papers, conclusion sections in 99.0%.
- 电力系统自动化: case/result sections in 97.4%, conclusion sections in 99.8%.
- IEEE TPWRS full papers: case/result sections in 97.8%, conclusion sections in 99.5%.
- IEEE TSG full papers: case/result sections in 99.5%, conclusion sections in 99.0%.

Median case/result paragraph counts:

- 中国电机工程学报: about 22.
- 电力系统自动化: about 22.
- IEEE TPWRS: about 10.
- IEEE TSG: about 15.

Median conclusion paragraph counts:

- 中国电机工程学报: about 3.
- 电力系统自动化: about 4.
- IEEE TPWRS: about 2.
- IEEE TSG: about 2.

## Result Discussion Layer

Case-study prose should not merely restate tables or assert that the method is effective. Use the numerical result to explain what became clearer about the paper's technical object.

When a result is important enough to discuss, write toward these functions naturally:

- identify the scenario, metric, and comparison that make the result meaningful;
- explain the physical mechanism, model property, constraint effect, uncertainty behavior, or computational reason behind the observed change;
- connect the result back to the paper's main claim, abstract promise, or introduction contribution;
- position the result against the relevant baseline or literature expectation when PowerLit or supplied references make that comparison available;
- state the boundary of interpretation when the result supports diagnosis, complementarity, screening, feasibility, or scope control rather than broad superiority.

This is a writing move, not a mandatory paragraph template. If the table already makes the numerical ranking obvious, spend the prose on why the ranking occurs and what claim it supports. If the evidence is mixed, let the discussion explain the tradeoff instead of smoothing it into uniform dominance.

Before writing result prose, design the figure set as one ordered engineering
story using the case-section figure storyboard in `figures-tables-results.md`.
The figures, read in order with captions alone, should carry the engineering
scene, the physical contradiction, the mechanism through an intermediate
quantity, the matched comparison, and the boundary. A missing act is a figure
problem: design or export the figure, or record the gap. Do not repair it by
lengthening the result paragraph.

For every main figure, enforce the Figure-first chain in
`figures-tables-results.md`: actual condition and plot data → trend → key feature
→ quantitative difference → mechanism status → answered problem → bounded
advantage/tradeoff → engineering implication → boundary. A paragraph that only
rephrases the caption, enumerates curves, or says that the method is effective
fails even when the figure is visually clear. When the storyboard passes, the
prose points at what the figure already shows instead of carrying the mechanism
alone.

## Neighbor Case-Study Learning

When PowerLit is available, learn the case-study evidence chain from near-neighbor papers before drafting the section. Extract:

- case-section order: setup, baseline definition, main comparison, mechanism/result explanation, sensitivity or ablation, boundary/failure case, and conclusion link;
- figure/table roles: what each visual proves, not only what it plots;
- result-paragraph functions: whether the paragraph reports a ranking, explains a physical mechanism, compares against literature/baseline expectation, diagnoses a failure mode, or bounds the claim;
- missing-evidence signals: evidence functions that accepted neighbors use for the same claim class but the current project has not yet produced.

Use this extraction to organize the current evidence surface. The goal is not to make the section longer; it is to ensure that every visual and paragraph has a reviewable job. If a neighbor-style result function is absent from the project outputs, do not fill it with prose. Mark it as a blocker, ask for the computation, or narrow the manuscript claim.

Case-analysis learning must remain object-preserving. A neighboring dispatch paper may teach how to compare baselines and constraints, but it must not turn a screening, diagnostic, certificate, topology, or uncertainty paper into a dispatch paper. The current paper's innovation point decides which result functions are central.

## 中国电机工程学报

### Case / Results

Use a complete engineering validation chain:

1. System and parameters.
2. Scenario, operating condition, or test condition.
3. Comparison method.
4. Main result.
5. Mechanism interpretation.
6. Sensitivity or impact analysis.
7. Engineering implication.

Common headings include `算例分析`, `实验验证`, `仿真验证`, `结果与讨论`.

Write result sentences with metrics:

- Prefer: "在...场景下，...指标由...降至...，说明..."
- Avoid: "仿真验证了所提方法的有效性" without numbers or mechanism.

### Conclusion

Use `结论` by default. A good conclusion has 2-4 compact findings:

1. What model/strategy was proposed.
2. What the main evidence showed.
3. What boundary or future extension remains if needed.

Do not use the conclusion to introduce new claims.

## 电力系统自动化

### Case / Results

Use a tighter, object-preserving validation chain:

1. Case setup.
2. Scenario/data.
3. Metrics and comparison.
4. Result tied to the submitted technical object.
5. Parameter or scenario effect.
6. Method effectiveness stated through the reported metric, scenario, and technical object rather than as a bare effectiveness assertion.

Common headings include `算例分析`, `仿真验证`, `实验验证`, with subsections such as `算例设置`.

Keep the writing close to the model: objective function, constraints, states, indices, criteria, estimator variables, protection logic, or operating metrics should be visible according to the paper object. Use dispatch/control variables only when the supplied method actually has them.

### Conclusion

Use `结语` by default when matching this venue. The corpus often uses a four-part close:

1. Proposed model/strategy.
2. Main result.
3. Applicability or limitation.
4. Future work.

Future work should be specific: data source, real-time deployment, scenario expansion, additional constraint, or field validation.

## IEEE TPWRS

### Case Study / Numerical Results

Use `CASE STUDY`, `CASE STUDIES`, `NUMERICAL RESULTS`, or `SIMULATION RESULTS`.

A TPWRS case section should state:

1. System and data.
2. Scenario, test condition, and uncertainty/model assumptions.
3. Baselines.
4. Metrics and units.
5. Main result.
6. Comparison or sensitivity.
7. Boundary of interpretation.

Let tables and figures carry the main evidence. In text, explain one message per paragraph. Avoid broad "comprehensive validation" claims unless the experiments are actually comprehensive.

### Conclusion

Use a short conclusion, usually 1-3 paragraphs:

1. "This paper formulated/proposed/developed..."
2. "Numerical studies showed..."
3. Optional short future extension.

Do not repeat the abstract, re-open the literature review, or introduce unsupported implications.

## IEEE TSG

### Case Study / Numerical Results

Use `CASE STUDY`, `CASE STUDIES`, `NUMERICAL RESULTS`, or `SIMULATION RESULTS`.

A TSG case section should make the supplied smart-grid mechanism visible:

1. Distribution feeder, microgrid, DER/EV/storage system, sensor network, market/DR setting, or cyber-physical test system.
2. Data, communication, privacy, attack, uncertainty, or distributed implementation assumptions when claimed.
3. Power-system baselines and relevant data/control baselines.
4. Grid metrics and method metrics with units.
5. Generalization, robustness, communication burden, privacy leakage, or scalability if these are claimed.
6. Operational interpretation of the result.

Do not add communication, privacy, attack, DER, or learning evidence requirements unless the manuscript claims that layer. If the user requests TSG for a paper without a smart-grid evidence object, report the venue mismatch instead of fabricating a smart-grid case design.

Avoid reporting ML/control performance without grid-side meaning. A TSG result paragraph should explain what improves in the grid, not only what improves in the algorithm.

### Conclusion

Use a short conclusion, usually 1-3 paragraphs. State what the method established in smart-grid terms and keep any deployment or real-time claim inside the tested boundary.

## Cross-Venue Rules

- Every result paragraph should map to a claim in the abstract or introduction.
- Every table/figure should answer one question.
- Comparison must identify the baseline and the metric direction.
- Sensitivity analysis should explain a mechanism or boundary, not just add length.
- Conclusion claims must already be supported by derivation or case results.

## Data-Preprocessing Detail Cut

The case-setup paragraph often carries data-engineering detail that belongs in a reproducibility appendix, not in the case section. The reader of the case section came to understand the method's operating condition; preprocessing implementation choices are not load-bearing for the claim unless the method itself is a preprocessing method.

Apply this cut to case-setup prose:

- **Delete** raw-data resolution statements (`原始分辨率为 15 min`), aggregation method statements (`按小时均值聚合`), aggregation-error metrics (`RMSE 158.27 MW`, `P95 39.20%`, `P99 47.23%`, `最大爬坡损失 66.89%`), and calendar-handling notes (`2024年为闰年，删除 2 月 29 日`). These are reproducibility facts that belong in an appendix or a methods-detail section, not in the case-setup narrative.
- **Keep** data scale (`全年 8 760 时刻时序数据`) and any statement that ties the data directly to the method's stated time-scale target (`本文储能配置以小时尺度能量调节为目标`). Scale and time-scale target are load-bearing; the RMSE of the aggregation step is not.
- **Decision rule**: ask whether the reader came to this sentence to understand the method or to reproduce the data pipeline. If the former, keep it; if the latter, move it to a reproducibility appendix or delete it.

This rule is the case-section analogue of the parameter-and-implementation placement rule in `method-model.md`. Method constants live in the method; data-engineering constants live in the appendix or the reproducibility note.

## Case-Paragraph Redundancy Types

After the case-section figure storyboard passes and result prose is drafted, scan every result paragraph for three recurring redundancy patterns. Each is a separate failure mode; delete or merge by type, not by feel.

### Type 1: Commentary summary sentence

A sentence appended after a data statement that merely re-summarizes what the data already says. The pattern is `数据陈述 + 评论性总结句`.

- Failing: `图 4 中的计算点总体分布在 y=x 参照线附近，与预期一致，表明解析传播能够复现主要空间差异。` — the comment sentence restates the visual; delete the comment.
- Failing: `该结果支持两类储能功能互补，但不支持 BESS 在所有网络风险指标上占主导。` — the comment sentence converts a measurement into a binary support claim; delete it.
- Rule: if the data sentence already shows the point, the comment is padding. Cut under the sentence-deletion test in `prose-quality-gates.md`.

### Type 2: Method self-evaluation sentence

A sentence that, after stating a result, steps back to describe what the paper's method `does` in the abstract. Method-positioning language belongs in the introduction or the method chapter, not in the case section.

- Failing: `因此，本文以解析谱作为规划信号，以非线性结果限定其工程解释。` — method positioning in the result section.
- Failing: `该运行记录反映带回溯的顺序代理块迭代在当前算例上的数值收敛行为，非凸联合模型的全局最优性和一般收敛速度仍需进一步验证。` — meta-evaluation of the algorithm; if kept, it should be in the convergence or reproducibility subsection, not appended to a result paragraph.
- Rule: a result paragraph reports the result and its mechanism; method self-positioning is removed.

### Type 3: Information repetition

The same fact stated in two locations: prose vs. table, prose vs. earlier prose, or two adjacent sentences.

- Failing: prose restating table parameters (`PSH 和 BESS 功率上限分别为 300 MW 和 200 MW`) when Table 1 already lists them.
- Failing: `全部方法采用相同候选节点、容量上限、储能参数、支路限额和独立验证日复核口径` as a standalone sentence when the comparison-methods paragraph already says it.
- Failing: a sentence at the end of `5.6.1` that repeats the mechanism already explained in the preceding two sentences.
- Rule: each fact appears in exactly one location. Parameter values live in tables; method settings live in the comparison-methods paragraph; mechanism interpretation lives with the result that shows it.

When all three types are removed, the case section should pass the progression and non-repetition gate in `prose-quality-gates.md` on the first read. If it does not, the remaining redundancy is content-level, not pattern-level, and should be diagnosed per paragraph.
