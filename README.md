# PowerLit Power-System Writing Skills

This repository contains Codex skills for power-system paper writing, distilled from a local PowerLit JSON corpus.

## Skills

### `powerlit-power-systems-paper-writing`

Use for full research papers targeting:

- 中国电机工程学报
- 电力系统自动化
- IEEE Transactions on Power Systems full papers

The skill uses one shared power-system writing workflow and routes venue-specific style through reference files:

- `references/csee.md`
- `references/aeps.md`
- `references/tpwrs.md`
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

## Install

After publishing this repository to GitHub, install the skills with the Codex skill installer:

```powershell
python "$env:USERPROFILE\.codex\skills\.system\skill-installer\scripts\install-skill-from-github.py" `
  --repo <owner>/powerlit-power-systems-writing-skills `
  --path skills/powerlit-power-systems-paper-writing skills/ieee-power-engineering-letter-writing
```

Restart Codex after installation.

## Usage Examples

```text
请用 powerlit-power-systems-paper-writing，把这段引言改成中国电机工程学报风格。
```

```text
请按 IEEE TPWRS full paper 的写法重写方法部分，重点检查 formulation、assumptions、constraints 和 algorithm 的顺序。
```

```text
请用 ieee-power-engineering-letter-writing，把这个 full paper idea 压缩成 IEEE Letter 的 introduction 和 technical core。
```

## Corpus Boundary

The skills include distilled style rules and corpus statistics. They do not include raw papers, paper PDFs, or the source JSON corpus.

