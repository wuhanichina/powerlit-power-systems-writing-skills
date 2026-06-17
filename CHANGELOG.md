# 版本说明

## Unreleased - Physical-Story Reviewer Revision Gate

- 新增按审稿意见改稿的物理叙事规则：先把意见转成物理机理、模型假设、证据比较或结论边界上的真实缺口，再把修改自然融入正文。
- 在写作入口、`method-model.md`、`prose-quality-gates.md` 和 `review-closed-loop.md` 中加入 `physical-story`、`reviewer-feedback integration` 和 `engineering-math balance` 检查。
- 审稿侧新增 `reviewer-response leakage` 与 `Engineering-Math Balance Review`，用于拦截叠甲式正文、逐条回应痕迹和数学证明过载。
- 增加审稿意见改稿回归用例，验证 CSEE 方法段不会用完整证明替代物理解释。

## 2026-06-16 - Versioned PowerLit Search Index

本版本把 PowerLit 检索从“每台机器各自临时建缓存”调整为“仓库携带可复用索引缓存”，用于支撑论文写作、预审、审稿和文献智能任务的默认快速检索路径。

主要变化：

- 重建 `.cache/powerlit-index`，覆盖 10 个 venue，共 14148 条 PowerLit JSON 记录，`failed_records=0`。
- 将 `.cache/powerlit-index/*.sqlite` 和 `manifest.json` 纳入版本管理；`.cache` 下的其他临时文件、subset、JSONL 调试文件和 raw run 日志仍保持本地忽略。
- 修复中文 venue 索引文件名冲突：非 ASCII venue 目录现在使用稳定 hash 文件名，避免多个中文期刊都写入 `root.sqlite` 并互相覆盖。
- 验证 Windows PowerShell 搜索入口优先走 SQLite 索引；TPWRS 英文检索约 0.5 秒，`中国电机工程学报` 中文检索约 4 毫秒。

索引快照：

| Venue | Records | SQLite |
| --- | ---: | --- |
| `ieee_tpwrs` | 7139 | `.cache/powerlit-index/ieee_tpwrs.sqlite` |
| `ieee_tsg` | 5638 | `.cache/powerlit-index/ieee_tsg.sqlite` |
| `中国电机工程学报` | 802 | `.cache/powerlit-index/venue_cf71f77aed85.sqlite` |
| `电力系统自动化` | 538 | `.cache/powerlit-index/venue_5fa2986a16a0.sqlite` |
| `电网技术` | 24 | `.cache/powerlit-index/venue_c62427ef1b1b.sqlite` |
| `applied_energy` | 2 | `.cache/powerlit-index/applied_energy.sqlite` |
| `energy` | 1 | `.cache/powerlit-index/energy.sqlite` |
| `ieee_tpwrd` | 1 | `.cache/powerlit-index/ieee_tpwrd.sqlite` |
| `ijepes` | 2 | `.cache/powerlit-index/ijepes.sqlite` |
| `mpce` | 1 | `.cache/powerlit-index/mpce.sqlite` |

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

- 新增 `evaluation/method-canon/method-canon.json`，将 DOI 元数据核验和人工策展状态分离。
- 明确合法引用来源：用户提供文献、PowerLit 检索结果、以及 DOI 已核验且 curation accepted 的 method-canon 条目。
- 新增 complete-draft 模式：证据不足以达到 8-9 full-paper gate 时，输出当前证据支持的完整 bounded draft 和缺口清单，而不是编造 DOI、实验数字或 baseline。
- 给 `Search-PowerLitJson.ps1` 增加 index-first 路径、`rg` fallback 和检索 telemetry。
- 保留 reader-experience pass、working-language firewall、no-invention 和 review-closure gate 作为硬门。
