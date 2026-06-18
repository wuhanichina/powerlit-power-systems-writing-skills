# Task Prompt Reference

Use this reference when the user asks for a small writing operation rather than a full section draft: light editing, translation, compression, expansion, terminology cleanup, anti-AI cleanup, logic checking, abstract/contribution rewriting, or format conversion.

## Before Any Small Task

Lock four items before editing:

1. Target venue: 中国电机工程学报, 电力系统自动化, IEEE TPWRS, or IEEE TSG.
2. Engineering object: grid, device, market, uncertainty source, control layer, resilience setting, or data source.
3. Technical object: model, formulation, estimator, control law, algorithm, index, theorem, counterexample, or validation protocol.
4. Evidence boundary: supplied result, equation, citation, case system, or explicit missing item.
5. Reviewer comment or revision target, if the task is a response-to-reviewer rewrite.

If one item is missing, proceed only when the task is pure wording cleanup. Do not add unsupported results, citations, baselines, deployment claims, robustness claims, privacy claims, scalability claims, or real-time claims.

## Light Edit Contract

For light polishing, preserve the original technical meaning and make the smallest useful change.

- Keep equations, variable names, result values, case names, and citation markers unchanged unless the user asks to normalize them.
- Fix only technical ambiguity, venue register, reader burden, repeated motivation, generic adjectives, and AI-like scaffolding.
- Do not change a weak but honest boundary into a stronger manuscript claim.
- Return the revised text first. Add a short note only for unsupported claims, missing evidence, or terminology decisions.

## Prompt Patterns

### Light Chinese Polish

User prompt shape:

```text
请用 $powerlit-power-systems-paper-writing 轻量润色下面这段中文，目标期刊为[期刊]。保留原有公式、指标、引用和结论边界，不新增结果；只修复AI味、空泛句、术语和段落负担。
```

Expected behavior: apply `prose-quality-gates.md` and the mandatory `reader-experience-pass.md`; consult the legacy prose/rhythm/lexicon examples only when the consolidated gate is insufficient. Do not reroute into a full rewrite unless the paragraph has a logic break.

### English IEEE Cleanup

User prompt shape:

```text
Use $powerlit-power-systems-paper-writing to clean this TPWRS/TSG paragraph. Preserve all equations, result values, citation markers, and claim boundaries; remove AI-like phrasing and make the technical subject explicit.
```

Expected behavior: keep power-system technical subjects as valid grammatical subjects; do not apply generic blog-style active-voice rules.

### Translation with Claim Control

User prompt shape:

```text
请把这段中文技术草稿翻译成 IEEE TPWRS 英文。不要直译项目管理语言；把工程对象、模型关系和证据边界转成论文语言。
```

Expected behavior: translate the technical relation, not the literal project wording. Replace internal terms such as `claim boundary`, `evidence pack`, or `closest competitor` with manuscript language or omit them. In Chinese-facing output, render "claim" as "论点" rather than "主张".

### Compression

User prompt shape:

```text
请把这段引言压缩到[字数/段数]，目标期刊为[期刊]。保留问题、技术对象、核心证据和结论边界，删除背景重复和空泛价值判断。
```

Expected behavior: preserve the local logic chain. Do not delete the only sentence that states the evidence boundary.

### Expansion

User prompt shape:

```text
请把这段逻辑草稿扩展为[摘要/引言段/方法过渡段]。只能使用已给出的模型、结果和引用；缺失处用短注说明，不要编造。
```

Expected behavior: expand by making the object, mechanism, and evidence relation explicit, not by adding generic background.

### Logic Check Before Rewrite

User prompt shape:

```text
请先检查这段是否存在对象不一致、方法和证据错位、结论越界或术语混乱；再给出必要的最小改写。
```

Expected behavior: list only high-impact issues that change the rewrite. If there is no major issue, return the cleaned text without a long review checklist.

### Reviewer-Comment Revision

User prompt shape:

```text
请根据这些审稿意见修改正文。不要写成逐条防御或叠甲；先把每条意见转成物理逻辑、模型假设、证据比较或结论边界上的真实缺口，再把修改自然融进对应章节。
```

Expected behavior: build the reviewer-feedback integration map internally, then return revised manuscript prose. The final text should read as if the paper always had the clarified physical story: no standalone "为回应审稿人", no apology-like hedging, no paragraph that begins by denying overclaim unless the user explicitly asks for a response letter or limitations paragraph. When the comment asks for mathematical detail, add only the derivation or theory needed to make the physical mechanism and claim reviewable; do not replace engineering explanation with a complete proof tutorial.

### Abstract and Contribution Repair

User prompt shape:

```text
请把这些项目论点改成[期刊]论文摘要/贡献表述。不要照抄 claims.md；先把防守性边界转成可审稿的技术论点。
```

Expected behavior: load `project-claim-translation.md`; keep the supported boundary but make the manuscript statement positive, technical, and reviewable.

## Output Defaults

- Manuscript-facing tasks: revised prose first, short blocker note second if needed.
- Planning tasks: venue-grounded plan with missing evidence marked.
- Review tasks: severity-ranked findings first.
- Translation and cleanup: no hidden checklist unless the user asks for rationale.
