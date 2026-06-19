# 版本说明

## Unreleased - 开篇痛点分层规则、逐句删除/精炼测试与写作-审稿闭环

针对"直接写出的论文难以一句话点出痛点、且废话偏多（Codex 比 Claude 更明显）"的问题，把原先依赖模型语感的软原则升级为可机械执行的硬规则，使不靠语感的模型也能照样卡住废话开局。"废话多"在两个层次出现：句子整句多余，以及句子该留但语言不够精炼；本版本两层都加了机械测试。

开篇痛点规则按文体分两层（普通论文与 Letter 要求不同）：

- 普通论文（CSEE/AEPS/TPWRS/TSG）：首句不强制点出痛点，允许用趋势/背景开篇，但具体对象、失效条件、未解冲突必须在首段落内出现，不得拖到后续段落。检查粒度是段落级，不是句级。要拦截的失败模式是"首段全是背景、痛点拖到第二页"，而不是"首句是趋势"。
- IEEE Letter：首句即须点出痛点。摘要与引言首句必须自带对象+失效条件+未解冲突，禁止趋势/重要性/概念/文献活动开局。该严格句级规则写在 Letter 技能内。

主要变化：

- `powerlit-power-systems-paper-writing/references/introduction-scalpel.md` 的「Opening Pain-Point Gate」改为两层：Tier 1 普通论文段落级（趋势可作 pivot，但须在首段落落到冲突）、Tier 2 Letter 句级（指向 Letter 技能）。附普通论文层的"趋势落地/未落地"中文正反例与直接开篇范例。
- `references/prose-quality-gates.md` 把 `Reader-burden cut` 升级为两层机械测试：
  - 「Sentence-Deletion Test（全期刊强制）」：逐句检查是否携带对象/变量/机制/证据/对比五类负载之一，否则删；附高频废话清单、边界规则和删除配额。
  - 「Sentence-Tightening Test（全期刊强制）」：针对"句子该留但不够精炼"，逐句检查同样负载能否用更少的字说清；列出引导语填充、堆叠模糊限定、名词化冗余、空泛强调词、循环表达、过长定语/介词链等可删项，并以"技术主语优先"做密度检查；明确禁止删掉界定论点的条件状语。
- `powerlit-power-systems-paper-writing/SKILL.md`：摘要/引言规则改为引用开篇 gate 的普通论文层（趋势可开篇但首段须落到冲突）；交付前 pass 列表（第 13 步）前置加入开篇 gate、逐句删除测试、句内精炼测试；Hard Rules 的开篇硬规则从"禁止趋势开局"改为"不得停留在背景层、首段须落到冲突"，并注明 Letter 更严。
- `ieee-power-engineering-letter-writing/SKILL.md`：Required Shape 摘要/引言首句要求点出痛点；Hard Rules 新增"首句即点痛点"硬规则（禁止趋势/重要性/概念/文献活动作首句，单句隔离测试）。`references/introduction.md` 的 Recommended Flow 前置首句痛点要求。
- `powerlit-power-systems-paper-review/references/expert-reader-experience.md`：`专家级阅读体验` 新增「开篇痛点与废话密度检查」，按普通论文段落级 / Letter 句级两层判断开篇是否埋没痛点，并把低信息密度列为 `writing` 负担，与写作侧规则形成写作→审稿闭环。

适用范围：删除/精炼测试为全期刊强制；开篇痛点按文体分层（普通论文段落级、Letter 句级）。

## Unreleased - Codex 与 Claude 双平台兼容

本版本让技能库在保留 Codex 安装方式的同时，正式支持 Claude（Claude Code / Cowork）。技能本体（`SKILL.md` + `references/` + Python 脚本 + SQLite 索引）本就与平台无关，本次只补齐 Claude 入口和跨平台调用文档，不改动技能能力内核与脚本逻辑。

主要变化：

- README.md 和 README.en.md 的「装上就能用 / Install And Use」拆分为 Codex 与 Claude 两条安装路径：Claude 通过将 `skills/<name>/` 放入 `~/.claude/skills/`（或项目级 `.claude/skills/`）或打包 `.skill` 安装。
- 检索接口文档把 Python 入口 `Search-PowerLitIndex.py` / `Build-PowerLitIndex.py` 提为跨平台主路径（bash 示例），`Search-PowerLitJson.ps1` 标注为 Windows PowerShell 备选，两者行为等价。
- `powerlit-power-systems-literature-intelligence/SKILL.md` 同步调整检索入口表述与示例顺序：Python 为主入口，PowerShell 为 Windows 备选。
- README 顶部新增 Claude Skill 徽章，介绍语从「Codex 技能」改为「兼容 Codex 和 Claude」。

兼容性说明：

- 现有 Codex 安装方式、PowerShell 入口、环境变量（`POWERLIT_JSON_ROOT` 等）全部保留，不破坏既有用户。
- 六个技能的 `SKILL.md` frontmatter（`name` + `description`）本就符合 Claude 技能规范，无需改动。

## Unreleased - Paper Writing Spine, Evidence Freshness, And Default Venue

本版本补强 `powerlit-power-systems-paper-writing` 的生成路径，使技能先自然形成论文主线、结果解释和证据边界，再用 gate 作为底线约束。

参考来源：

- Virginia Gewin, "How to write a first-class paper", Nature 555, 129-130 (2018), doi: `10.1038/d41586-018-02404-4`。本次只吸收其写作原则：中心主线、读者路径、discussion 的文献语境、证据约束和可复现信息完整性，不复制原文表达。
- 现有 PowerLit 写作技能经验：保持项目 `claims.md` 只作为证据边界，通过“项目论点 -> 论文论点”转换、review-closed loop 和 reader-experience pass 防止防御型写作与过度润色。

主要变化：

- 新增内部 `paper spine` 生成对象，使标题、摘要、引言、结果讨论和结论围绕同一条技术主线展开。
- 引言规则改为先形成内部主线，再决定保留、延后或删除背景、文献和贡献内容。
- 结果/讨论段新增解释层：结果段应说明场景、指标、比较对象、物理或模型机制、支撑的论文论点和解释边界，而不是只复述表格。
- 方法和图表结果规则新增“reproducibility as exposition”：系统、数据、场景、单位、样本数、K 值、求解协议和基线设置应出现在读者判断模型或结果时自然需要的位置。
- 无指定期刊时，默认按 IEEE TPWRS 的路由、证据标准和审稿边界处理，但先输出中文技术稿；需要英文或最终 IEEE 文体时再转换。
- 写作前默认解析最新一致证据面：优先使用最新 completed `RunMetadata`、结果 CSV/MAT、验证报告和与当前 run 对齐的 figure manifest 记录；多条 manifest 时不默认取第一条；`latest` 文件名与元数据冲突时以元数据为准并说明冲突。

验证记录：

- `git diff --check` 通过。
- `scripts\Validate-PowerLitSkillRepo.ps1 -SkipPowerLitSearch` 通过，`skill_count=6`。

## Unreleased - Literature Reading Skill

- 新增 `powerlit-power-systems-literature-reading`，用于对单篇或少量指定电力系统文献做中文精读总结。
- 固定输出六个阅读维度：核心论点、理论机制、理论贡献、研究设计、关键发现、如何回应我的研究问题。
- 将 PowerLit 作为文献精读的可选增强来源：PowerLit 可用时，`理论贡献` 部分需要给出文献在研究方向中的地位、独特价值、方法体系归属，以及与同派系方法的差异。
- 明确证据状态边界：区分 `全文可读`、`摘要/元数据有限` 和 `用户问题缺失`，不编造 DOI、结果、基线、页码或关键发现。
- 同步更新 `README.md`、`README.en.md`、`agents/openai.yaml` 和 `test-prompts.json`，使安装入口、任务入口和行为夹具都能发现该技能。
- 验证记录：`quick_validate.py` 通过；`scripts\Validate-PowerLitSkillRepo.ps1 -SkipPowerLitSearch` 通过，当前 `skill_count=6`。

## Unreleased - Major Portability, Retrieval, Validation, And Readiness Migration

- Moved the distributable PowerLit index into `skills/powerlit-power-systems-literature-intelligence/assets/powerlit-index` and removed machine-local default paths from runtime resolution.
- Migrated public project fixtures to logical `project://` resource IDs and moved `method-canon.json` into the literature skill references.
- Added domain-aware query analysis, venue registry resolution, unknown-venue hard errors, DOI/title deduplication, matched-field telemetry, and a seed retrieval benchmark.
- Added pytest unit tests and Windows/Linux GitHub Actions for repository lint, unit tests, and retrieval evaluation.
- Replaced review-score and score-target language with the `PowerLit Internal Readiness Index`, readiness states, and migrated actual-case evidence packet schema.
- Added `references/rule-sources.yaml` to separate official rules, literature signals, heuristics, and project-specific constraints.
- Updated IEEE PES Letter page-budget rules from official sources checked on 2026-06-18.
- Corrected SOCP exactness, penalty-method, SDP certificate, Application Paper, and local-review recommendation wording.

## Unreleased - Physical-Story Reviewer Revision Gate

- 新增按审稿意见改稿的物理叙事规则：先把意见转成物理机理、模型假设、证据比较或结论边界上的真实缺口，再把修改自然融入正文。
- 在写作入口、`method-model.md`、`prose-quality-gates.md` 和 `review-closed-loop.md` 中加入 `physical-story`、`reviewer-feedback integration` 和 `engineering-math balance` 检查。
- 审稿侧新增 `reviewer-response leakage` 与 `Engineering-Math Balance Review`，用于拦截叠甲式正文、逐条回应痕迹和数学证明过载。
- 增加审稿意见改稿回归用例，验证 CSEE 方法段不会用完整证明替代物理解释。

## 2026-06-16 - Versioned PowerLit Search Index

本版本把 PowerLit 检索从“每台机器各自临时建缓存”调整为“仓库携带可复用索引缓存”，用于支撑论文写作、预审、审稿和文献智能任务的默认快速检索路径。

主要变化：

- 重建 `skills/powerlit-power-systems-literature-intelligence/assets/powerlit-index`，覆盖 10 个 venue，共 14148 条 PowerLit JSON 记录，`failed_records=0`。
- 将 `skills/powerlit-power-systems-literature-intelligence/assets/powerlit-index/*.sqlite` 和 `manifest.json` 纳入版本管理；`.cache` 下的其他临时文件、subset、JSONL 调试文件和 raw run 日志仍保持本地忽略。
- 修复中文 venue 索引文件名冲突：非 ASCII venue 目录现在使用稳定 hash 文件名，避免多个中文期刊都写入 `root.sqlite` 并互相覆盖。
- 验证 Windows PowerShell 搜索入口优先走 SQLite 索引；TPWRS 英文检索约 0.5 秒，`中国电机工程学报` 中文检索约 4 毫秒。

索引快照：

| Venue | Records | SQLite |
| --- | ---: | --- |
| `ieee_tpwrs` | 7139 | `skills/powerlit-power-systems-literature-intelligence/assets/powerlit-index/ieee_tpwrs.sqlite` |
| `ieee_tsg` | 5638 | `skills/powerlit-power-systems-literature-intelligence/assets/powerlit-index/ieee_tsg.sqlite` |
| `中国电机工程学报` | 802 | `skills/powerlit-power-systems-literature-intelligence/assets/powerlit-index/venue_cf71f77aed85.sqlite` |
| `电力系统自动化` | 538 | `skills/powerlit-power-systems-literature-intelligence/assets/powerlit-index/venue_5fa2986a16a0.sqlite` |
| `电网技术` | 24 | `skills/powerlit-power-systems-literature-intelligence/assets/powerlit-index/venue_c62427ef1b1b.sqlite` |
| `applied_energy` | 2 | `skills/powerlit-power-systems-literature-intelligence/assets/powerlit-index/applied_energy.sqlite` |
| `energy` | 1 | `skills/powerlit-power-systems-literature-intelligence/assets/powerlit-index/energy.sqlite` |
| `ieee_tpwrd` | 1 | `skills/powerlit-power-systems-literature-intelligence/assets/powerlit-index/ieee_tpwrd.sqlite` |
| `ijepes` | 2 | `skills/powerlit-power-systems-literature-intelligence/assets/powerlit-index/ijepes.sqlite` |
| `mpce` | 1 | `skills/powerlit-power-systems-literature-intelligence/assets/powerlit-index/mpce.sqlite` |

验证记录：

- `scripts\Validate-PowerLitSkillRepo.ps1` 通过，`powerlit_search=checked`。
- `python -m py_compile` 通过索引构建、索引检索和公共 helper 脚本。
- manifest 中每个 venue 的记录数与 SQLite `records` 表一致。
- 最大 SQLite 文件为 `ieee_tpwrs.sqlite`，约 88.79 MB，低于 GitHub 单文件 100 MB 硬限制。

使用边界：

- PowerLit 主库仍是只读源数据。
- 版本化索引是便利用缓存，不是权威文献库；主库更新后应重新构建并替换该索引。
- `method-canon` 仍负责经典/方法/证据标杆；索引负责主库近邻召回。

## 2026-06-14 - Method Canon And Indexed Retrieval Workflow

- 新增 `skills/powerlit-power-systems-literature-intelligence/references/method-canon.json`，将 DOI 元数据核验和人工策展状态分离。
- 明确合法引用来源：用户提供文献、PowerLit 检索结果、以及 DOI 已核验且 curation accepted 的 method-canon 条目。
- 新增 complete-draft 模式：证据不足以达到 8-9 full-paper gate 时，输出当前证据支持的完整 bounded draft 和缺口清单，而不是编造 DOI、实验数字或 baseline。
- 给 `Search-PowerLitJson.ps1` 增加 index-first 路径、`rg` fallback 和检索 telemetry。
- 保留 reader-experience pass、working-language firewall、no-invention 和 review-closure gate 作为硬门。
