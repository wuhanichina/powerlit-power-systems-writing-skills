# PowerLit 电力系统论文写作与审稿技能

这个仓库提供一组 Codex 技能，用于电力系统论文的选题预审、文献智能、正式写作、Letter 写作和严格审稿。它把本地或局域网中的 PowerLit JSON 语料库转化为面向目标期刊的写作支持，覆盖：

- 中国电机工程学报
- 电力系统自动化
- IEEE Transactions on Power Systems
- IEEE Transactions on Smart Grid
- IEEE 电力系统 Letter 和短技术通信

本仓库不包含原始论文、PDF 或私有文献记录。技能只在可访问 PowerLit JSON 语料库时读取本地语料；语料不可用时，技能进入 fallback 模式，不编造引用、近邻文献或语料风格结论。

## 安装

发布或克隆本仓库后，在 PowerShell 中使用 Codex skill installer 安装：

```powershell
python "$env:USERPROFILE\.codex\skills\.system\skill-installer\scripts\install-skill-from-github.py" `
  --repo <owner>/powerlit-power-systems-writing-skills `
  --path skills/powerlit-power-systems-literature-intelligence `
         skills/powerlit-power-systems-prewriting-review `
         skills/powerlit-power-systems-paper-writing `
         skills/ieee-power-engineering-letter-writing `
         skills/powerlit-power-systems-paper-review
```

安装后重启 Codex。

## 核心能力

这个仓库的核心不是普通润色，而是基于语料的论文写作闭环。PowerLit 可访问时，技能会先检索近邻论文，形成最近竞争工作和引用证据，锁定可主张边界，再把目标期刊论文作为写作参照，用于章节形态、段落功能、论证节奏、贡献摆放和证据呈现。最后才进入目标期刊语域下的正文写作。

完整论文写作采用混合拆分：

- 一个公开的完整论文入口：`powerlit-power-systems-paper-writing`
- CSEE、AEPS、TPWRS、TSG 的期刊 profile
- 一个独立的 Letter 技能，因为 Letter 不是完整论文的压缩版
- 一个共享的文献智能技能，作为证据层

写作技能还会把项目 claim 翻译成论文 claim。`claims.md`、`evidence_map.md`、研究笔记和 gate 报告只作为证据边界，不会被机械复制进论文。除非原始表述已经是期刊可接受的论文主张，否则必须经过“源 claim -> 证据状态 -> 审稿风险 -> 论文 claim”的转换。

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

## 推荐工作流

1. 先运行 `powerlit-power-systems-prewriting-review`，判断工作是否已经可写。
2. 使用 `powerlit-power-systems-literature-intelligence` 检索近邻竞争工作和引用证据。
3. 完整论文使用 `powerlit-power-systems-paper-writing`，Letter 使用 `ieee-power-engineering-letter-writing`。期刊敏感写作中，PowerLit 论文只能作为结构和节奏参照，不能作为可复制文本。
4. 投稿前运行 `powerlit-power-systems-paper-review`。写作技能把这一步当作闭环门槛：如果本地审稿会发现致命缺陷、重大模型或证据问题、逻辑断裂或期刊错配，草稿必须修复或明确阻断，不能标成 submission-ready。
5. 维护技能本身时，把真实项目中的审稿失败加入回归用例。例子记录在 `evaluation/actual-project-claim-regressions.json`。

## 常见任务入口

| 任务 | 使用技能 | 必要输入 | 示例提示 | 期望输出 |
|---|---|---|---|---|
| 写作前决策 | `powerlit-power-systems-prewriting-review` | idea、模型、证据状态、目标期刊 | `请判断这个台风配电网风险评估 idea 是否能进入中国电机工程学报写作。` | `GO`、`CONDITIONAL GO`、`NO-GO` 或 `RETARGET`，并给出具体修复项。 |
| 引言重写 | `powerlit-power-systems-paper-writing` | 目标期刊、草稿、证据边界、引用状态 | `把这段引言改成 TPWRS 风格，先锁定 claim boundary 和近邻文献。` | 缩窄或阻断无支撑主张后的论文正文。 |
| 方法模型段 | `powerlit-power-systems-paper-writing` | 方程、假设、变量、算法、期刊 | `把这个 DRO AC OPF 方法部分改成 TPWRS 写法，重点检查假设、公式和可解性主张。` | 以 formulation 为中心的方法段，包含变量、约束、重构、算法和边界。 |
| 算例结果段 | `powerlit-power-systems-paper-writing` | MATLAB 或结果表、基线、指标、场景 | `根据这些 case33bw 结果写算例分析段，不要泛称有效性。` | 说明系统、指标方向、对比、机理和边界的结果段。 |
| 图表标题 | `powerlit-power-systems-paper-writing` | 图表内容、坐标轴或列名、期刊 | `为这张电压越限概率图写 IEEE TSG caption，并给正文解释句。` | 自洽图题和一段与电网含义绑定的正文解释。 |
| 轻量润色 | `powerlit-power-systems-paper-writing` | 原段落、目标期刊、保留与删除约束 | `轻量润色这段中文，不新增结论和引用，只去掉 AI 味和空泛句。` | 先给改后文本，只做必要术语、逻辑和风格修理。 |
| 投稿前审稿 | `powerlit-power-systems-paper-review` | 稿件或章节、期刊、证据包 | `按中国电机工程学报标准严格审查这篇论文是否够录用。` | 按严重程度排序的审稿问题和必须修复项。 |

## 使用示例

```text
请用 powerlit-power-systems-prewriting-review，判断这个 idea 是否已经可以进入中国电机工程学报写作阶段。
```

```text
请用 powerlit-power-systems-paper-writing，把这段引言改成中国电机工程学报风格，要求先检查 PowerLit 中的近邻文献和可主张边界。
```

```text
请用 powerlit-power-systems-paper-writing，把这个 IEEE TPWRS 方法部分重写一版。重点检查 assumptions、formulation、constraints、reformulation、algorithm 和 case-study boundary。
```

```text
请用 powerlit-power-systems-paper-writing，把这篇稿件改成 IEEE TSG 风格。所有 data-driven、distributed control、privacy 或 communication 主张都要绑定到电网运行含义。
```

```text
请用 ieee-power-engineering-letter-writing，把这个完整论文 idea 压缩成 IEEE power-system Letter 的引言和技术核心。
```

```text
请用 powerlit-power-systems-paper-review，从 TPWRS 审稿人的角度严格判断这篇论文是否够录用。
```

## 验证

在仓库根目录运行验证脚本：

```powershell
$env:PYTHONUTF8 = "1"
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\Validate-PowerLitSkillRepo.ps1
```

如果只想检查结构和 prompt，不运行实时 PowerLit 检索 smoke：

```powershell
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

## 语料边界

本仓库只保存技能说明、期刊信号、脚本和回归 prompt。它不保存原始 PowerLit 语料、PDF 或私有论文记录。检索到的论文只能作为本地分析证据和写作参照，不能把原文复制进输出。
