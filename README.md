中文 · [English](README.en.md) · [版本说明](CHANGELOG.md)

# ⚡ PowerLit 电力系统论文写作与审稿技能

> **先锁定证据边界，再写能经得起审稿的电力系统论文。**

[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Skill Version](https://img.shields.io/badge/Skill%20Version-2026.07.03-blueviolet)](#版本更新记录)
[![Codex Skill](https://img.shields.io/badge/Codex-Skill-blue)](skills/)
[![Claude Skill](https://img.shields.io/badge/Claude-Skill-8A2BE2)](skills/)
[![Cursor Skill](https://img.shields.io/badge/Cursor-Skill-007ACC)](skills/)
[![PowerLit](https://img.shields.io/badge/PowerLit-Evidence%20Grounded-orange)](#关于-powerlit)

这个仓库提供一组面向电力系统论文的技能，兼容 Codex、Claude（Claude Code / Cowork）和 Cursor 等 Agent Skills 运行时，覆盖选题预审、PowerLit 文献智能、单篇文献精读总结、完整论文写作、IEEE Letter 写作和投稿前严格审稿。

它不是普通润色工具。安装后自带近 **1.4 万篇** PowerLit 索引，技能会先检索近邻论文、规划引用与论点边界，再按目标期刊的段落功能、论证节奏和证据呈现方式写正文；投稿前还会用本地审稿 skill 反向检查，形成「写作 → 审稿 → 修复」的闭环。

适配期刊和文体：

- 中国电机工程学报
- 电力系统自动化
- IEEE Transactions on Power Systems
- IEEE Transactions on Smart Grid
- IEEE 电力系统 Letter 和短技术通信

[🚀 安装](#装上就能用) · [🧰 能做什么](#能做什么) · [🎯 常见任务入口](#常见任务入口) · [🧠 核心机制](#核心机制) · [🧩 技能入口](#技能入口) · [✅ 验证](#验证) · [🗓️ 更新记录](#版本更新记录) · [📝 版本说明](CHANGELOG.md) · [🔒 关于 PowerLit](#关于-powerlit)

## 版本更新记录

当前技能版本：**2026.07.03**（六个 `SKILL.md` frontmatter 的 `version:` 字段）。安装后可用 `Select-String -Path skills\*\SKILL.md, ~/.cursor/skills/*/SKILL.md -Pattern '^version:'` 对比仓库与本地副本是否一致。

- **2026-07-03（2026.07.03）**：索引 year 字段修复——`derive_year` 从 DOI/正文推断年份， bundled SQLite 分片回填 14146/14148 条，检索结果现带 `year`；关键检查点加 🔴 CHECKPOINT / 🛑 STOP 视觉标记；`paper-writing` 去重瘦身；六个技能 frontmatter 增加 `version:`；README 补充 Cursor 等通用 runtime 安装与同步说明；新增半自动回归 runner（`scripts/Run-SkillRegression.py` + `evaluation/results.tsv`）与 Letter 开篇痛点 A/B 回归用例。
- 2026-06-30：结构完整性收口——写作侧与审稿侧 section 质量清单互相对齐以防跨技能漂移；写作闭环复审改为独立审稿人姿态（接入 `evaluation/behavior/independent-reviewer-prompt.md`）以消除自评偏置；删除未被任何流程加载的孤儿参考文件 `baseline-comparison.md`。
- 2026-06-30：打磨写作技能可实施性——新增参考文件加载分层（常见任务不再全量加载）、把交付前的十余个 pass 收敛为四组并与 `prose-quality-gates.md` 去重、明确内部标签“计划要/正文删”规则、期刊路由改为对象优先（TPWRS 仅作兜底）、新增按期刊的 before→after 正例库与公式直觉句模板、跨章节主线一致性检查和翻译保边界规则。
- 2026-06-30：新增预审阶段的最小研究对象门，先锁定小同行问题域，再判断痛点、创新点、文献对照和工程故事，避免把窄对象贡献扩写成宽泛行业背景。
- 2026-06-27：新增预写作阶段的真实创新点重定位和物理故事线检查，先判断项目真正该讲什么技术故事再进入写作。
- 2026-06-19：新增 Codex 与 Claude 双平台安装说明，并补强论文主线、证据新鲜度和开篇痛点分层规则。
- 2026-06-18：新增文献精读 skill、readiness 迁移、跨平台检索入口和仓库验证层。
- 2026-06-17：新增审稿意见改稿的物理叙事 gate，避免正文写成逐条回应或数学堆砌。
- 2026-06-16：新增随仓库分发的 PowerLit SQLite 检索索引，使默认文献召回更快、更可复用。

完整变更见 [CHANGELOG.md](CHANGELOG.md)。

---

## 装上就能用

这套技能同时兼容 Codex、Claude 和 Cursor 等运行时。技能本体是标准的 `SKILL.md` + `references/` + Python 脚本；下面任选一种安装方式即可。

### Codex

在 PowerShell 中运行：

```powershell
python "$env:USERPROFILE\.codex\skills\.system\skill-installer\scripts\install-skill-from-github.py" `
  --repo wuhanichina/powerlit-power-systems-writing-skills `
  --path skills/powerlit-power-systems-literature-intelligence `
         skills/powerlit-power-systems-literature-reading `
         skills/powerlit-power-systems-prewriting-review `
         skills/powerlit-power-systems-paper-writing `
         skills/ieee-power-engineering-letter-writing `
         skills/powerlit-power-systems-paper-review
```

安装后重启 Codex。

### Claude（Claude Code / Cowork）

每个 `skills/<name>/` 目录就是一个标准 Claude 技能（含 `SKILL.md` frontmatter）。把它们放进 Claude 的技能目录即可被发现：

```bash
# 方式一：克隆后软链/复制到个人技能目录
git clone https://github.com/wuhanichina/powerlit-power-systems-writing-skills.git
cp -r powerlit-power-systems-writing-skills/skills/* ~/.claude/skills/
```

- 个人技能目录：`~/.claude/skills/`（项目级可用 `<repo>/.claude/skills/`）。
- 也可以把单个技能目录打包成 `.skill`（zip）后在 Claude 中安装。
- 安装后重启 / 重载 Claude，技能即出现在技能列表中。

检索脚本在 Claude 的 Linux 环境下用 Python 入口（见[核心机制](#核心机制)），无需 PowerShell。

### 其他兼容 Agent Skills 的运行时（Cursor 等）

任何支持 Agent Skills 标准（`SKILL.md` frontmatter + `references/` + `scripts/`）的运行时都可以直接使用：把 `skills/<name>/` 目录复制或软链到该运行时的技能目录即可。常见路径：

| 运行时 | 技能目录 |
|---|---|
| Codex | `~/.codex/skills/` |
| Claude Code / Cowork | `~/.claude/skills/` |
| Cursor | `~/.cursor/skills/`（或项目级技能目录；Cursor 也能发现 `~/.codex/skills/` 下已安装的技能） |
| 其他 | 参考该运行时的 skills 文档，放入其技能发现目录 |

### 更新已安装的副本

技能演化后，仓库版本与已安装副本可能漂移。每个 `SKILL.md` 的 frontmatter 带有 `version:` 字段（日期戳）；判断和同步方法：

```powershell
# 对比仓库与已装副本的版本
Select-String -Path "skills\*\SKILL.md", "$env:USERPROFILE\.cursor\skills\*\SKILL.md" -Pattern "^version:"

# 同步到 Cursor（或把路径换成 .codex/skills / .claude/skills）
Copy-Item -Recurse -Force skills\* "$env:USERPROFILE\.cursor\skills\"
```

若通过 skill-installer 安装，重跑一次安装命令即可获得最新版本。

### 装好后直接说话

```text
请判断这个台风配电网风险评估 idea 是否能进入中国电机工程学报写作。
```

```text
把这段引言改成 TPWRS 风格，先锁定论点边界和近邻文献。
```

```text
请用 powerlit-power-systems-literature-reading 精读这篇论文，并按核心论点、理论机制、理论贡献、研究设计、关键发现和我的研究问题回应来总结。
```

```text
根据这些 case33bw 结果写算例分析段，不要泛称有效性。
```

```text
按 IEEE TSG 标准严格审查这篇稿件，给出本地审稿建议和必须修复项。
```

你给 idea、草稿、模型、结果或证据包，skill 负责把它们转换成期刊可审的论文表达。

---

## 能做什么

| 能力 | 使用技能 | 交付物 | 典型场景 |
|---|---|---|---|
| 🧭 写作前预审 | `powerlit-power-systems-prewriting-review` | `GO` / `CONDITIONAL GO` / `NO-GO` / `RETARGET` 与修复清单 | idea、模型、实验包或粗稿还不确定能不能写 |
| 🔎 文献智能 | `powerlit-power-systems-literature-intelligence` | 近邻竞争工作、引用包、创新性风险、文献覆盖审计 | 写引言、回应审稿、判断 novelty |
| 📖 文献精读总结 | `powerlit-power-systems-literature-reading` | 核心论点、理论机制、理论贡献、研究设计、关键发现、研究问题回应 | 精读单篇或少量指定文献 |
| 📝 完整论文写作 | `powerlit-power-systems-paper-writing` | 摘要、引言、方法、算例、结论、图表标题和结果段 | CSEE、AEPS、TPWRS、TSG 正文写作 |
| ✉️ IEEE Letter 写作 | `ieee-power-engineering-letter-writing` | 一个硬论点、紧凑技术核心和最小决定性证据 | 符合官方页数规则的 IEEE PES Letter |
| 🧪 投稿前审稿 | `powerlit-power-systems-paper-review` | 本地审稿建议 + 按严重程度排序的问题清单 | 投稿前自查、返修前定位致命问题 |
| 📊 图表与结果段 | `powerlit-power-systems-paper-writing` | 自洽 caption、正文解释句、MATLAB 结果到论文段落 | 处理 figure、table、case study、ablation、sensitivity |
| ✨ 轻量润色 | `powerlit-power-systems-paper-writing` | 保留原技术含义的最小必要修改 | 去 AI 味、术语统一、压缩、扩写、翻译、逻辑修理 |

---

## 常见任务入口

| 任务 | 必要输入 | 示例提示 | 期望输出 |
|---|---|---|---|
| 写作前决策 | idea、模型、证据状态、目标期刊 | `请判断这个台风配电网风险评估 idea 是否能进入中国电机工程学报写作。` | `GO`、`CONDITIONAL GO`、`NO-GO` 或 `RETARGET`，并给出具体修复项。 |
| 文献精读总结 | PDF、题名/DOI、摘要或 PowerLit 记录；最好附自己的研究问题 | `请精读这篇 TPWRS 论文，并说明它如何回应我的研究问题：台风天气下源荷不确定性如何影响静态安全风险。` | 中文六块总结：核心论点、理论机制、理论贡献、研究设计、关键发现、研究问题回应。 |
| 引言重写 | 目标期刊、草稿、证据边界、引用状态 | `把这段引言改成 TPWRS 风格，先锁定论点边界和近邻文献。` | 缩窄或阻断无支撑论点后的论文正文。 |
| 方法模型段 | 方程、假设、变量、算法、期刊 | `把这个 DRO AC OPF 方法部分改成 TPWRS 写法，重点检查假设、公式和可解性论点。` | 以 formulation 为中心的方法段，包含变量、约束、重构、算法和边界。 |
| 算例结果段 | MATLAB 或结果表、基线、指标、场景 | `根据这些 case33bw 结果写算例分析段，不要泛称有效性。` | 说明系统、指标方向、对比、机理和边界的结果段。 |
| 图表标题 | 图表内容、坐标轴或列名、期刊 | `为这张电压越限概率图写 IEEE TSG caption，并给正文解释句。` | 自洽图题和一段与电网含义绑定的正文解释。 |
| 轻量润色 | 原段落、目标期刊、保留与删除约束 | `轻量润色这段中文，不新增结论和引用，只去掉 AI 味和空泛句。` | 先给改后文本，只做必要术语、逻辑和风格修理。 |
| 投稿前审稿 | 稿件或章节、期刊、证据包 | `按中国电机工程学报标准严格审查这篇稿件，给出本地审稿建议和必须修复项。` | 本地审稿建议（直接投稿 / 小修 / 大修 / 不建议投稿）与按优先级排列的修改清单。 |

---

## 核心机制

### 🔎 PowerLit 证据门控

文献检索 skill 自带 SQLite 索引（约 1.4 万条，安装即用）。写作与预审会先查近邻论文，再定引用、新颖性和论点边界——你只需描述研究对象，检索由 skill 脚本完成。

### 🧭 最小研究对象门

预审和重大写作前，技能会先识别论文所属的最小研究对象和小同行问题域，再定义痛点、创新点与故事主线，避免把细分技术贡献包装成宽泛行业背景。

### 🧭 项目论点到论文论点的翻译

`claims.md`、`evidence_map.md`、研究笔记和 gate 报告只作为证据边界，不会被机械复制进论文。正式写作必须经过：

```text
源论点 -> 证据状态 -> 审稿风险 -> 论文论点 -> 边界句
```

这一步防止把项目口号直接写成期刊贡献。

### 🧱 物理叙事优先

按审稿意见改稿时，技能先把意见转成物理机理、模型假设、证据比较或结论边界上的真实缺口，再把修改自然融入正文。正文不写成逐条防御或“叠甲”，数学也服务于工程图景和可审稿性，而不是把工科论文改成完整证明。

### 🧩 期刊 profile 路由

完整论文保持一个入口 `powerlit-power-systems-paper-writing`，通过 reference 适配 CSEE、AEPS、TPWRS、TSG。**期刊未定时默认按 TPWRS 证据标准路由，首稿输出中文技术正文**（需要英文 IEEE 版时再转换）。Letter 单独成 skill——它是独立文体，不是缩略版长文。

### 🧪 写作到审稿闭环

投稿前运行 `powerlit-power-systems-paper-review`。如果本地审稿会发现致命缺陷、重大模型或证据问题、逻辑断裂或期刊错配，写作技能不能把草稿标成 submission-ready。

### 📌 真实项目回归

仓库包含真实项目论点回归、写作审稿闭环用例、已发表论文重建用例和 readiness 算例证据包。维护技能时，应把实际翻车样例加入 evaluation，而不是只补抽象规则。

---

## 技能入口

### `powerlit-power-systems-literature-intelligence`

用于创新性检查、近邻竞争工作分析、引用包、引言支撑和文献覆盖审计。**安装即带 SQLite 索引**（约 1.4 万条），无需自备语料即可检索。

快速检索（Python，跨平台，主路径）：

```bash
python skills/powerlit-power-systems-literature-intelligence/scripts/Search-PowerLitIndex.py \
  --query "distributed voltage control" \
  --venue-folder ieee_tsg \
  --top 10
```

Windows 用户可用 PowerShell 入口，行为等价：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File `
  skills\powerlit-power-systems-literature-intelligence\scripts\Search-PowerLitJson.ps1 `
  -Query "distributed voltage control" `
  -VenueFolder ieee_tsg `
  -Top 10
```

若你有私有 PowerLit JSON 语料并需要增量更新索引，可配置 `POWERLIT_JSON_ROOT` 后运行 `Build-PowerLitIndex.py`。

### `powerlit-power-systems-literature-reading`

用于精读单篇或少量指定文献，并用中文输出固定结构的研究笔记：

- 核心论点
- 理论机制
- 理论贡献
- 研究设计
- 关键发现
- 如何回应我的研究问题

如果全文可读，它会先标注证据状态，再把论点、机制、设计、发现和研究启示绑定到正文、方法、实验或结论证据。PowerLit 可用时，`理论贡献` 会进一步给出该文献在研究方向中的地位、独特价值、方法体系归属，以及与同派系方法的差异。若只有摘要、题名或元数据，它会明确标注 `摘要/元数据有限`，不编造 DOI、结果、基线、页码或关键发现。对电力系统论文，`理论机制` 会按物理机制、数学模型、优化/控制逻辑、统计机制或工程因果链理解，而不是生硬套用社会科学术语。

### `powerlit-power-systems-prewriting-review`

用于正式写作前的预审。它判断一个 idea、大纲、模型、实验包或粗稿是否已经可以进入目标期刊写作。

返回四类结论之一：

- `GO`
- `CONDITIONAL GO`
- `NO-GO`
- `RETARGET`

检查重点包括最小研究对象定位、真实创新点重定位、多幕工程故事与物理直觉、创新链条、模型正确性、证据就绪度、论点边界、PowerLit 近邻风险和期刊匹配度。它会先把问题压回最匹配的小同行研究对象，例如解析交流概率潮流、配电网状态估计、保护配合或台风风险评估中的具体技术对象，再回答“这个项目真正该讲什么故事”。故事按工程现场、物理矛盾、机制直觉、技术对象、证据和边界展开，数学推导只作为模型、机制、直觉或边界的支撑，不替代电力系统物理叙事。预审还会结合现有研究进展，从科学性、行业痛点把握准确性、正确性、合理性、创新性和工程可行性按 1-10 分给出分项评分、总体评分，并指出最大缺陷。

### `powerlit-power-systems-paper-writing`

用于完整研究论文。技能保持一个稳定的公开入口，并通过 reference 文件处理期刊差异：

- `references/venue-profiles.md`
- `references/pre-drafting-confirmation.md`
- `references/manuscript-section-quality.md`
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
- `references/worked-examples.md`（按期刊的 before→after 改写正例，可选深入）
- `references/publishable-prose.md` / `references/rhythm.md` / `references/lexicon.md` / `references/anti-ai-style.md`（可选深入例子）

适用于标题/关键词、摘要、引言、方法与模型、算例、结论、图表标题、结果段落、期刊适配、术语清理和去 AI 味润色。完整论文、标题、摘要、引言或重大改写前，会先检索项目文件与近邻文献，确认痛点、创新点、可行标题，再请你确认后进入正文写作。

### `ieee-power-engineering-letter-writing`

用于符合官方 IEEE PES 页数规则的电力系统 Letter。它把 Letter 当作独立文体，而不是把完整论文压缩：

- 一个硬论点
- 一个紧凑技术核心
- 最少但决定性的证据
- 新颖性论点前先做 PowerLit 近邻门控
- 边界清楚的短结论

### `powerlit-power-systems-paper-review`

用于按照 CSEE、AEPS、TPWRS、TSG 和 IEEE Letter 标准严格审稿，输出**本地审稿建议**（直接投稿 / 小修 / 大修 / 不建议投稿）和按优先级排列的修改清单。

---

## 推荐工作流

1. 先运行 `powerlit-power-systems-prewriting-review`，判断工作是否已经可写。
2. 使用 `powerlit-power-systems-literature-intelligence` 检索近邻竞争工作和引用证据。
3. 对确定需要细读的文献，使用 `powerlit-power-systems-literature-reading` 形成中文六块研究笔记。
4. 完整论文使用 `powerlit-power-systems-paper-writing`，Letter 使用 `ieee-power-engineering-letter-writing`。
5. 投稿前运行 `powerlit-power-systems-paper-review`，让审稿门槛反向关闭写作风险。
6. 维护技能本身时，把真实项目中的审稿失败加入回归用例，例如 `evaluation/actual-project-claim-regressions.json`。

---

## 仓库结构

```text
powerlit-power-systems-writing-skills/
├── README.md
├── README.en.md
├── LICENSE
├── scripts/
│   ├── Validate-PowerLitSkillRepo.ps1
│   └── Run-SkillRegression.py
├── skills/
│   ├── powerlit-power-systems-literature-intelligence/
│   ├── powerlit-power-systems-literature-reading/
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

在仓库根目录运行 repository lint 和 schema validation：

```powershell
$env:PYTHONUTF8 = "1"
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\Validate-PowerLitSkillRepo.ps1
```

如果只想检查结构和夹具 schema，不运行实时 PowerLit 检索 smoke：

```powershell
$env:PYTHONUTF8 = "1"
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\Validate-PowerLitSkillRepo.ps1 -SkipPowerLitSearch
```

该脚本是 repository lint 和 schema validation，不代表行为回归测试结果。它检查：

- skill frontmatter
- `references/` 和 `scripts/` 引用路径
- 行为夹具 JSON schema
- `evaluation/writing-review-closure.json` 中的写作到审稿闭环夹具 schema
- `evaluation/actual-project-claim-regressions.json` 中的真实项目论点夹具 schema
- `evaluation/powerlit-paper-reconstruction-cases.json` 中的已发表论文重建用例
- `evaluation/actual-case-evidence-packets.json` 中的 readiness 真实算例证据包
- PowerLit resolver smoke
- 可选的 PowerLit search smoke

确定性单元测试和检索 benchmark 是独立层：

```powershell
python -m pytest -q
python evaluation/retrieval/run_retrieval_eval.py
```

CI 会在 `ubuntu-latest` 和 `windows-latest` 上分别运行 repository lint、unit tests 和 retrieval evaluation。

行为回归（需要 agent 实跑）由半自动 runner 编排并记录到 `evaluation/results.tsv`：

```powershell
python scripts/Run-SkillRegression.py list                 # 列出全部回归用例
python scripts/Run-SkillRegression.py show --id <case-id>  # 取出 prompt 交给带技能的 agent 执行
python scripts/Run-SkillRegression.py record --id <case-id> --mode full_test --verdict pass --note "..."
python scripts/Run-SkillRegression.py status               # 覆盖率与 dry_run 比例告警
```

---

## 关于 PowerLit

本仓库分发的是技能与**内置文献索引**（约 1.4 万条），不含原始 PDF。检索结果用于规划引用与论证结构，**不会把原文抄进你的稿件**。若你有私有语料库，也可自行扩展索引。

---
