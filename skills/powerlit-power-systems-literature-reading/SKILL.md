---
name: powerlit-power-systems-literature-reading
description: Read and summarize supplied or retrieved power-system research papers in Chinese, with a fixed structure covering core argument, theoretical or physical mechanism, PowerLit-informed theoretical contribution, research design, key findings, and how the paper responds to the user's research question. Use when the user asks to read, digest, summarize, 精读, 拆解, or extract research implications from one or a small set of papers.
---

# PowerLit Power-Systems Literature Reading

## Purpose

Use this skill to turn a paper into a Chinese research note that helps the user decide what the paper actually says, how it works, what it contributes, and how it affects the user's own research question.

This skill complements `powerlit-power-systems-literature-intelligence`: use literature intelligence to find or rank papers; use this skill to read and synthesize the selected paper(s).

## Access And Evidence

1. If the user supplies a PDF, text, DOI record, PowerLit JSON path, or pasted content, read that source directly.
2. If the user supplies only a title, DOI, or topic and asks for a summary, first try available local sources or `powerlit-power-systems-literature-intelligence`; use web lookup only when current or external verification is needed.
3. When PowerLit is available, use it to strengthen contribution positioning:
   - locate the paper's status in the relevant research direction;
   - identify the paper's method family and nearby same-family papers;
   - compare the paper's unique value against same-family methods;
   - keep this as contextual positioning, not as a substitute for reading the paper.
4. State the evidence state before the summary:
   - `全文可读`: full paper or sufficiently complete source was read.
   - `摘要/元数据有限`: only abstract, metadata, or snippets were available.
   - `用户问题缺失`: the user's own research question was not supplied; infer only broad relevance and ask for the exact question if stronger alignment is needed.
5. Do not invent title, venue, year, DOI, results, datasets, baselines, or page numbers. Mark uncertain items as `未能从当前材料确认`.
6. Separate author-supported claims from reader inference. Use wording such as `文中直接支持`, `PowerLit 近邻对比显示`, `从设计可推断`, or `当前材料不足以判断`.
7. Do not copy long source passages. Paraphrase and cite section/page anchors when available.

## Reading Workflow

1. Identify the paper's research object:
   - system object: transmission, distribution, microgrid, market, resilience, protection, forecasting, planning, operation, etc.;
   - problem object: estimation, optimization, control, diagnosis, screening, risk assessment, scheduling, etc.;
   - method object: model, algorithm, statistical mechanism, physical mechanism, theoretical framework, or empirical design;
   - evidence object: datasets, test systems, scenarios, baselines, metrics, ablations, sensitivity studies, or proofs.
2. Read in this order when the full paper is available:
   - abstract and introduction for the central claim;
   - related work and contribution statements for positioning;
   - method/model sections for mechanism;
   - experiment, case study, or empirical design for research design;
   - results and discussion for key findings;
   - conclusion and limitations for boundary.
3. Build a compact evidence map before writing:
   - claim -> supporting section/result;
   - mechanism -> variables, assumptions, causal or mathematical chain;
   - contribution -> nearest prior limitation, method-family position, same-family difference, or gap;
   - finding -> metric/result and boundary;
   - relevance -> what transfers to the user's question and what does not.
4. For power-system papers, treat `理论机制` broadly as one or more of:
   - physical mechanism in the grid;
   - mathematical model or optimization mechanism;
   - statistical or probabilistic mechanism;
   - control, market, or planning logic;
   - empirical identification logic.
   Do not force social-science terminology if the paper is engineering-oriented.

## Chinese Output Template

Return the answer in Chinese with these headings in this order.

### 文献信息与证据状态

- 文献：title, authors, venue/year/DOI when confirmed.
- 当前阅读依据：full text, PDF path, PowerLit JSON path, abstract, metadata, or supplied excerpt.
- 可信度边界：what was and was not available.

### 核心论点

- Use 1-2 Chinese sentences to state the central claim the authors try to prove or explain.
- Explain what problem the claim addresses and why the paper thinks it matters.
- Anchor the claim to abstract/introduction/conclusion or the clearest available source section.
- Avoid restating the title as the argument; identify the actual intellectual or engineering claim.

### 理论机制

- Describe the framework, model, physical chain, causal chain, or algorithmic mechanism used to explain the result.
- Name the key variables, assumptions, system states, constraints, and interactions.
- Explain how the mechanism connects input conditions to observed outcomes.
- State whether the mechanism fully explains the findings or leaves gaps.

### 理论贡献

- Explain how the paper extends, revises, combines, or narrows existing theory, model families, or engineering understanding.
- When PowerLit is available, use nearby retrieved papers to state the paper's position in the research direction: foundational route, representative application, incremental extension, bridge between two routes, niche scenario, or outlier method.
- Summarize the method system the paper belongs to, then compare it with same-family methods by modeling object, assumptions, data/scenario, uncertainty treatment, optimization or inference mechanism, validation metric, and claim boundary.
- Identify the paper's unique value relative to that method family: new problem formulation, more explicit physical interpretation, tractability improvement, scenario transfer, evidence-standard improvement, or sharper operational implication.
- Distinguish genuine contribution from routine application, parameter tuning, or case-study packaging.
- State the contribution boundary: where the paper's claim should not be stretched.
- For power-system papers, include contribution to physical interpretation, model tractability, uncertainty treatment, evidence standard, or operational insight when relevant.

### 研究设计

- Summarize research question, research object, sample/data/test system, method, variables, baselines, metrics, and analysis procedure.
- For quantitative or simulation studies, check sample size, scenario design, benchmark fairness, metric direction, statistical or numerical validation, ablation, sensitivity, and reproducibility details.
- For qualitative, survey, or review studies, check case selection, data source, coding/analysis method, triangulation, and validity threats.
- Say whether the design can support the stated conclusion.

### 关键发现

- List 3-5 findings only if the current source supports them.
- For each finding, include `发现 -> 证据 -> 边界`.
- Keep findings objective and evidence-based. Do not upgrade discussion speculation into a result.
- If results are missing or inaccessible, say so directly.

### 如何回应我的研究问题

- If the user's research question is supplied, map the paper to it directly:
  - supports or challenges which hypothesis;
  - offers which method, variable, baseline, metric, scenario, or mechanism;
  - exposes which gap or risk;
  - suggests which next experiment, comparison, or wording boundary.
- If the research question is not supplied, give only broad relevance and include `需要你的具体研究问题才能做精确回应`.
- Separate `可直接借鉴`, `需要改造后借鉴`, and `不宜借鉴/不能外推`.

## Quality Gates

- Write for the user's research work, not as a generic book report.
- Keep the summary compact but dense; prefer specific mechanism, evidence, and boundary over long background.
- Do not use unsupported praise such as `首次`, `显著`, `全面优于`, or `具有重要意义` unless the paper's evidence directly supports it.
- Preserve negative or limiting evidence. A paper's weakness may be the most useful finding for the user's work.
- When summarizing multiple papers, either repeat the six-section template per paper or add a final cross-paper comparison; do not merge incompatible mechanisms into one fake consensus.
