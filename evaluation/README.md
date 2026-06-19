# evaluation/ 目录说明

本目录混合了两类文件：**版本管理内的策划夹具（技能的一部分）** 和 **本地运行生成的产物（被 `.gitignore` 排除）**。改动前请先分清属于哪一类。

## 进版本管理：策划夹具与 benchmark

这些是手工策划的"标准答案"、行为回归夹具和检索质量 benchmark，是技能能力的一部分，由 `scripts/Validate-PowerLitSkillRepo.ps1` 和 CI 引用。修改需经评审。

- `writing-review-closure.json` — 写作到审稿闭环夹具。
- `actual-project-claim-regressions.json` — 真实项目论点回归夹具。
- `powerlit-paper-reconstruction-cases.json` — 已发表论文重建用例。
- `actual-case-evidence-packets.json` — readiness 真实算例证据包。
- `retrieval/` — 检索质量 benchmark：`queries.jsonl`、`qrels.jsonl`、`expected_failures.json`、`run_retrieval_eval.py`。
- `method-canon/web-canon-seed.md` — method canon 种子。
- `behavior/independent-reviewer-prompt.md` — 独立审稿行为提示。
- `internal-readiness-progress.md`、`darwin-luban-audit.md` — 维护记录与审计笔记。

## 不进版本管理：本地运行产物

由实跑或脚本生成，可再生成，已在仓库根 `.gitignore` 排除。不要手工提交。

- `score-target-runs/` — 评分目标实跑记录，每次运行生成一批。
- `common-research-directions.json` — 生成的研究方向清单。
- `common-research-direction-evidence-strength.json` / `.md` — 生成的证据强度分析。
- `__pycache__/`、`retrieval/__pycache__/` — Python 缓存。

## 判断标准

新增文件时：是手工策划、丢了会削弱技能能力的"标准答案" → 进版本管理；是某次运行的输出、可由脚本/实跑再生成 → 加入 `.gitignore`，不提交。
