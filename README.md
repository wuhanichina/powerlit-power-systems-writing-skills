# PowerLit Power-System Writing and Review Skills

This repository contains Codex skills for power-system paper writing and strict manuscript review, distilled from a local PowerLit JSON corpus.

## Skills

### `powerlit-power-systems-literature-intelligence`

Use when PowerLit access is available and a task needs corpus-backed novelty checking, closest-competitor analysis, citation packs, or literature coverage audits.

PowerLit JSON root is configurable. Resolution order:

1. User-supplied path or script parameter.
2. `POWERLIT_JSON_ROOT`.
3. `POWERLIT_LITERATURE_JSON`.
4. Default LAN path: `\\WHome\PowerLit\literature\json`.

If PowerLit is unavailable, the other skills continue in fallback mode without fabricating citations.

### `powerlit-power-systems-prewriting-review`

Use before formal writing. It gates whether an idea, outline, model, experiment package, or rough draft is ready for target-journal manuscript writing.

It returns:

- `GO`
- `CONDITIONAL GO`
- `NO-GO`
- `RETARGET`

The gate checks innovation chain, model correctness, evidence readiness, claim boundary, and venue fit.

### `powerlit-power-systems-paper-writing`

Use for full research papers targeting:

- 中国电机工程学报
- 电力系统自动化
- IEEE Transactions on Power Systems full papers
- IEEE Transactions on Smart Grid full papers

The skill uses one shared power-system writing workflow and routes venue-specific style through reference files:

- `references/csee.md`
- `references/csee-precision.md`
- `references/aeps.md`
- `references/tpwrs.md`
- `references/tsg.md`
- `references/publishable-prose.md`
- `references/introduction-scalpel.md`
- `references/method-model.md`
- `references/case-conclusion.md`
- `references/rhythm.md`
- `references/lexicon.md`
- `references/anti-ai-style.md`

### `ieee-power-engineering-letter-writing`

Use for IEEE power-system Letters and 3-4 page technical communications. It treats a Letter as a separate writing form, not a compressed full paper:

- one hard claim;
- one compact technical core;
- minimal but decisive evidence;
- short conclusion with a clear boundary.

### `powerlit-power-systems-paper-review`

Use for strict review of power-system manuscripts targeting:

- 中国电机工程学报
- 电力系统自动化
- IEEE Transactions on Power Systems
- IEEE Transactions on Smart Grid
- IEEE power-system Letters

The review skill checks acceptance risk, logic chain, innovation substance, model/math correctness, evidence sufficiency, conclusion support, venue fit, wording, formatting, and final reviewer-style decisions.

All writing skills apply a publishable-prose standard: each sentence must carry a technical or evidential function, and final prose should avoid流水账, defensive writing, unsupported claims, and polished vagueness.

## Install

After publishing this repository to GitHub, install the skills with the Codex skill installer:

```powershell
python "$env:USERPROFILE\.codex\skills\.system\skill-installer\scripts\install-skill-from-github.py" `
  --repo <owner>/powerlit-power-systems-writing-skills `
  --path skills/powerlit-power-systems-literature-intelligence skills/powerlit-power-systems-prewriting-review skills/powerlit-power-systems-paper-writing skills/ieee-power-engineering-letter-writing skills/powerlit-power-systems-paper-review
```

Restart Codex after installation.

## Usage Examples

```text
请用 powerlit-power-systems-prewriting-review，判断这个 idea 是否已经可以进入中国电机工程学报写作阶段。
```

```text
请用 powerlit-power-systems-paper-writing，把这段引言改成中国电机工程学报风格。
```

```text
请按 IEEE TPWRS full paper 的写法重写方法部分，重点检查 formulation、assumptions、constraints 和 algorithm 的顺序。
```

```text
请用 powerlit-power-systems-paper-writing，把这篇稿件改成 IEEE TSG 风格，注意 data-driven/distributed control 的 grid-operational meaning。
```

```text
请用 ieee-power-engineering-letter-writing，把这个 full paper idea 压缩成 IEEE Letter 的 introduction 和 technical core。
```

```text
请用 powerlit-power-systems-paper-review，从 TPWRS 审稿人的角度严格判断这篇论文是否够录用。
```

## Corpus Boundary

The skills include distilled style rules and corpus statistics. They do not include raw papers, paper PDFs, or the source JSON corpus.

## Recommended Workflow

1. `powerlit-power-systems-prewriting-review`: decide whether the work is ready to write.
2. `powerlit-power-systems-literature-intelligence`: when PowerLit is accessible, retrieve closest competitors and citation evidence.
3. `powerlit-power-systems-paper-writing` or `ieee-power-engineering-letter-writing`: draft or rewrite within the approved claim boundary.
4. `powerlit-power-systems-paper-review`: stress-test the written manuscript before submission.
