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

## 中国电机工程学报

### Case / Results

Use a complete engineering validation chain:

1. System and parameters.
2. Scenario or operating condition.
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

Use a tighter operational validation chain:

1. Case setup.
2. Scenario/data.
3. Metrics and comparison.
4. Operational result.
5. Parameter or scenario effect.
6. Method effectiveness.

Common headings include `算例分析`, `仿真验证`, `实验验证`, with subsections such as `算例设置`.

Keep the writing close to the model: objective function, constraints, dispatch/control variables, and operating metrics should be visible in the validation.

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
2. Scenario and uncertainty/model assumptions.
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

A TSG case section should make the smart-grid mechanism visible:

1. Distribution feeder, microgrid, DER/EV/storage system, sensor network, market/DR setting, or cyber-physical test system.
2. Data, communication, privacy, attack, uncertainty, or distributed implementation assumptions when claimed.
3. Power-system baselines and relevant data/control baselines.
4. Grid metrics and method metrics with units.
5. Generalization, robustness, communication burden, privacy leakage, or scalability if these are claimed.
6. Operational interpretation of the result.

Avoid reporting ML/control performance without grid-side meaning. A TSG result paragraph should explain what improves in the grid, not only what improves in the algorithm.

### Conclusion

Use a short conclusion, usually 1-3 paragraphs. State what the method established in smart-grid terms and keep any deployment or real-time claim inside the tested boundary.

## Cross-Venue Rules

- Every result paragraph should map to a claim in the abstract or introduction.
- Every table/figure should answer one question.
- Comparison must identify the baseline and the metric direction.
- Sensitivity analysis should explain a mechanism or boundary, not just add length.
- Conclusion claims must already be supported by derivation or case results.
