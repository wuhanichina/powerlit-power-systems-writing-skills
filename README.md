中文 · [English](README.en.md)

# ⚡ PowerLit 电力系统论文写作与审稿技能

> **先锁定证据边界，再写能经得起审稿的电力系统论文。**

[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Codex Skill](https://img.shields.io/badge/Codex-Skill-blue)](skills/)
[![PowerLit](https://img.shields.io/badge/PowerLit-Evidence%20Grounded-orange)](#powerlit-语料边界)

这个仓库提供一组面向电力系统论文的 Codex 技能，覆盖选题预审、PowerLit 文献智能、完整论文写作、IEEE Letter 写作和投稿前严格审稿。

它不是普通润色工具。PowerLit 可访问时，技能先检索近邻论文和引用证据，锁定可主张边界，再按目标期刊的段落功能、论证节奏和证据呈现方式写正文；投稿前还会用本地审稿 skill 反向检查，形成“写作 -> 审稿 -> 修复”的闭环。

适配期刊和文体：

- 中国电机工程学报
- 电力系统自动化
- IEEE Transactions on Power Systems
- IEEE Transactions on Smart Grid
- IEEE 电力系统 Letter 和短技术通信

[🚀 安装](#装上就能用) · [🧰 能做什么](#能做什么) · [🎯 常见任务入口](#常见任务入口) · [🧠 核心机制](#核心机制) · [🧩 技能入口](#技能入口) · [✅ 验证](#验证) · [🔒 语料边界](#powerlit-语料边界)

---

## 装上就能用

在 PowerShell 中运行：

```powershell
python "$env:USERPROFILE\.codex\skills\.system\skill-installer\scripts\install-skill-from-github.py" `
  --repo wuhanichina/powerlit-power-systems-writing-skills `
  --path skills/powerlit-power-systems-literature-intelligence `
         skills/powerlit-power-systems-prewriting-review `
         skills/powerlit-power-systems-paper-writing `
         skills/ieee-power-engineering-letter-writing `
         skills/powerlit-power-systems-paper-review
```

安装后重启 Codex，然后直接说话：

```text
请判断这个台风配电网风险评估 idea 是否能进入中国电机工程学报写作。
```

```text
把这段引言改成 TPWRS 风格，先锁定 claim boundary 和近邻文献。
```

```text
根据这些 case33bw 结果写算例分析段，不要泛称有效性。
```

```text
按 IEEE TSG 审稿人的标准严格检查这篇论文是否够录用。
```

没有按钮、没有面板、没有手工翻 JSON。你给 idea、草稿、模型、结果或证据包，skill 负责把它们转换成期刊可审的论文表达。

---

## 能做什么

| 能力 | 使用技能 | 交付物 | 典型场景 |
|---|---|---|---|
| 🧭 写作前预审 | `powerlit-power-systems-prewriting-review` | `GO` / `CONDITIONAL GO` / `NO-GO` / `RETARGET` 与修复清单 | idea、模型、实验包或粗稿还不确定能不能写 |
| 🔎 文献智能 | `powerlit-power-systems-literature-intelligence` | 近邻竞争工作、引用包、创新性风险、文献覆盖审计 | 写引言、回应审稿、判断 novelty |
| 📝 完整论文写作 | `powerlit-power-systems-paper-writing` | 摘要、引言、方法、算例、结论、图表标题和结果段 | CSEE、AEPS、TPWRS、TSG 正文写作 |
| ✉️ IEEE Letter 写作 | `ieee-power-engineering-letter-writing` | 一个硬主张、紧凑技术核心和最小决定性证据 | 3-4 页 Letter 或短技术通信 |
| 🧪 投稿前审稿 | `powerlit-power-systems-paper-review` | 按严重程度排序的拒稿风险和必须修复项 | 投稿前自查、返修前定位致命问题 |
| 📊 图表与结果段 | `powerlit-power-systems-paper-writing` | 自洽 caption、正文解释句、MATLAB 结果到论文段落 | 处理 figure、table、case study、ablation、sensitivity |
| ✨ 轻量润色 | `powerlit-power-systems-paper-writing` | 保留原技术含义的最小必要修改 | 去 AI 味、术语统一、压缩、扩写、翻译、逻辑修理 |

---

## 常见任务入口

| 任务 | 必要输入 | 示例提示 | 期望输出 |
|---|---|---|---|
| 写作前决策 | idea、模型、证据状态、目标期刊 | `请判断这个台风配电网风险评估 idea 是否能进入中国电机工程学报写作。` | `GO`、`CONDITIONAL GO`、`NO-GO` 或 `RETARGET`，并给出具体修复项。 |
| 引言重写 | 目标期刊、草稿、证据边界、引用状态 | `把这段引言改成 TPWRS 风格，先锁定 claim boundary 和近邻文献。` | 缩窄或阻断无支撑主张后的论文正文。 |
| 方法模型段 | 方程、假设、变量、算法、期刊 | `把这个 DRO AC OPF 方法部分改成 TPWRS 写法，重点检查假设、公式和可解性主张。` | 以 formulation 为中心的方法段，包含变量、约束、重构、算法和边界。 |
| 算例结果段 | MATLAB 或结果表、基线、指标、场景 | `根据这些 case33bw 结果写算例分析段，不要泛称有效性。` | 说明系统、指标方向、对比、机理和边界的结果段。 |
| 图表标题 | 图表内容、坐标轴或列名、期刊 | `为这张电压越限概率图写 IEEE TSG caption，并给正文解释句。` | 自洽图题和一段与电网含义绑定的正文解释。 |
| 轻量润色 | 原段落、目标期刊、保留与删除约束 | `轻量润色这段中文，不新增结论和引用，只去掉 AI 味和空泛句。` | 先给改后文本，只做必要术语、逻辑和风格修理。 |
| 投稿前审稿 | 稿件或章节、期刊、证据包 | `按中国电机工程学报标准严格审查这篇论文是否够录用。` | 按严重程度排序的审稿问题和必须修复项。 |

---

## 核心机制

### 🔎 PowerLit 证据门控

PowerLit 可访问时，技能会先检索近邻论文，确认最近竞争工作、可引用证据和 novelty 风险。新颖性、贡献、对比优势和语料风格结论都必须有检索依据；没有依据时，skill 会缩窄主张或明确阻断。

### 🧭 项目 claim 到论文 claim 的翻译

`claims.md`、`evidence_map.md`、研究笔记和 gate 报告只作为证据边界，不会被机械复制进论文。正式写作必须经过：

```text
源 claim -> 证据状态 -> 审稿风险 -> 论文 claim -> 边界句
```

这一步防止把项目口号直接写成期刊贡献。

### 🧩 期刊 profile 路由

完整论文保持一个稳定入口 `powerlit-power-systems-paper-writing`，再通过 reference 文件处理 CSEE、AEPS、TPWRS、TSG 的差异。Letter 单独拆出，因为 Letter 不是完整论文的压缩版。

### 🧪 写作到审稿闭环

投稿前运行 `powerlit-power-systems-paper-review`。如果本地审稿会发现致命缺陷、重大模型或证据问题、逻辑断裂或期刊错配，写作技能不能把草稿标成 submission-ready。

### 📌 真实项目回归

仓库包含真实项目 claim 回归、写作审稿闭环用例、已发表论文重建用例和高分算例证据包。维护技能时，应把实际翻车样例加入 evaluation，而不是只补抽象规则。

---

## 技能入口

### `powerlit-power-systems-literature-intelligence`

用于需要 PowerLit 支撑的文献任务，包括创新性检查、近邻竞争工作分析、引用包、引言支撑和文献覆盖审计。

PowerLit JSON 根目录解析顺序：

1. 用户显式提供的路径或脚本参数
2. `POWERLIT_JSON_ROOT`
3. `POWERLIT_LOCAL_CACHE`
4. `POWERLIT_LITERATURE_JSON`
5. 默认局域网路径：`\\WHome\PowerLit\literature\json`

高频应用应先构建本地 SQLite FTS 索引。索引写入 `.cache/powerlit-index` 或 `POWERLIT_INDEX_ROOT`，不进入版本管理：

```powershell
python skills\powerlit-power-systems-literature-intelligence\scripts\Build-PowerLitIndex.py `
  --venue-folder ieee_tsg `
  --venue-folder ieee_tpwrs
```

跨平台快速检索接口：

```powershell
python skills\powerlit-power-systems-literature-intelligence\scripts\Search-PowerLitIndex.py `
  --query "distributed voltage control" `
  --venue-folder ieee_tsg `
  --top 10
```

Windows 兼容检索接口会优先使用本地索引，索引缺失时才回退到主库 `rg` 预筛：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File `
  skills\powerlit-power-systems-literature-intelligence\scripts\Search-PowerLitJson.ps1 `
  -Query "distributed voltage control" `
  -VenueFolder ieee_tsg `
  -Top 10
```

### `powerlit-power-systems-prewriting-review`

用于正式写作前的预审。它判断一个 idea、大纲、模型、实验包或粗稿是否已经可以进入目标期刊写作。

返回四类结论之一：

- `GO`
- `CONDITIONAL GO`
- `NO-GO`
- `RETARGET`

检查重点包括创新链条、模型正确性、证据就绪度、可主张边界、PowerLit 近邻风险和期刊匹配度。

### `powerlit-power-systems-paper-writing`

用于完整研究论文。技能保持一个稳定的公开入口，并通过 reference 文件处理期刊差异：

- `references/venue-profiles.md`
- `references/corpus-grounded-drafting.md`
- `references/csee.md`
- `references/csee-precision.md`
- `references/aeps.md`
- `references/tpwrs.md`
- `references/tsg.md`
- `references/introduction-scalpel.md`
- `references/method-model.md`
- `references/case-conclusion.md`
- `references/figures-tables-results.md`
- `references/prose-quality-gates.md`
- `references/reader-experience-pass.md`
- `references/task-prompts.md`
- `references/publishable-prose.md` / `references/rhythm.md` / `references/lexicon.md` / `references/anti-ai-style.md`（可选深入例子）

适用于摘要、引言、方法与模型、算例、结论、图表标题、结果段落、期刊适配、术语清理和去 AI 味润色。

### `ieee-power-engineering-letter-writing`

用于 IEEE 电力系统 Letter 和 3-4 页短技术通信。它把 Letter 当作独立文体，而不是把完整论文压缩：

- 一个硬主张
- 一个紧凑技术核心
- 最少但决定性的证据
- 新颖性主张前先做 PowerLit 近邻门控
- 边界清楚的短结论

### `powerlit-power-systems-paper-review`

用于按照 CSEE、AEPS、TPWRS、TSG 和 IEEE Letter 标准严格审稿。审查优先级是可录用性、创新实质、逻辑链闭合、模型与数学正确性、证据充分性、结论支撑、期刊匹配、措辞和格式。

---

## 推荐工作流

1. 先运行 `powerlit-power-systems-prewriting-review`，判断工作是否已经可写。
2. 使用 `powerlit-power-systems-literature-intelligence` 检索近邻竞争工作和引用证据。
3. 完整论文使用 `powerlit-power-systems-paper-writing`，Letter 使用 `ieee-power-engineering-letter-writing`。
4. 投稿前运行 `powerlit-power-systems-paper-review`，让审稿门槛反向关闭写作风险。
5. 维护技能本身时，把真实项目中的审稿失败加入回归用例，例如 `evaluation/actual-project-claim-regressions.json`。

---

## 仓库结构

```text
powerlit-power-systems-writing-skills/
├── README.md
├── README.en.md
├── LICENSE
├── scripts/
│   └── Validate-PowerLitSkillRepo.ps1
├── skills/
│   ├── powerlit-power-systems-literature-intelligence/
│   ├── powerlit-power-systems-prewriting-review/
│   ├── powerlit-power-systems-paper-writing/
│   ├── ieee-power-engineering-letter-writing/
│   └── powerlit-power-systems-paper-review/
└── evaluation/
    ├── writing-review-closure.json
    ├── actual-project-claim-regressions.json
    ├── powerlit-paper-reconstruction-cases.json
    └── actual-case-evidence-packets.json
```

---

## 验证

在仓库根目录运行验证脚本：

```powershell
$env:PYTHONUTF8 = "1"
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\Validate-PowerLitSkillRepo.ps1
```

如果只想检查结构和 prompt，不运行实时 PowerLit 检索 smoke：

```powershell
$env:PYTHONUTF8 = "1"
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\Validate-PowerLitSkillRepo.ps1 -SkipPowerLitSearch
```

验证脚本检查：

- skill frontmatter
- `references/` 和 `scripts/` 引用路径
- 回归 prompt JSON
- `evaluation/writing-review-closure.json` 中的写作到审稿闭环用例
- `evaluation/actual-project-claim-regressions.json` 中的真实项目 claim 回归用例
- `evaluation/powerlit-paper-reconstruction-cases.json` 中的已发表论文重建用例
- `evaluation/actual-case-evidence-packets.json` 中的 8-9 分真实算例证据包
- PowerLit resolver smoke
- 可选的 PowerLit search smoke

---

## PowerLit 语料边界

本仓库只保存技能说明、期刊信号、脚本和回归 prompt。它不保存原始 PowerLit 语料、PDF 或私有论文记录。

技能只在可访问 PowerLit JSON 语料库时读取本地语料；语料不可用时进入 fallback 模式，不编造引用、近邻文献或语料风格结论。检索到的论文只能作为本地分析证据和写作参照，不能把原文复制进输出。

---

## 限制

- PowerLit 不可访问时，skill 只能做结构、逻辑和语言层面的保守写作，不能声称完成近邻文献门控。
- 全量 JSON 语料检索可能较慢；高频使用建议先构建 SQLite FTS 索引。
- 期刊论文只能作为结构、节奏和论证方式参照，不能复制原文句子。
- `submission-ready` 只能在证据、模型、逻辑和期刊匹配都通过本地审稿门槛后使用。
