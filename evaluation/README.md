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
- `results.tsv` — 回归判定日志（棘轮记录）。由 `scripts/Run-SkillRegression.py record` 追加，记录每个回归用例的最近判定（`full_test`/`dry_run`、pass/fail、依据）。进版本管理：它是技能演化的证据链，技能修订应以"之前失败的用例现在是否通过"来评判。

## 回归执行方式

回归用例本身需要 agent 执行，流程半自动：

```bash
python scripts/Run-SkillRegression.py list                 # 列出全部用例（test-prompts + 闭环 + 重建）
python scripts/Run-SkillRegression.py show --id <case-id>  # 取出 prompt，交给带技能的 agent 跑
python scripts/Run-SkillRegression.py record --id <case-id> --mode full_test --verdict pass --note "..."
python scripts/Run-SkillRegression.py status               # 覆盖率、最近判定、dry_run 比例告警（>30% 时效果分不可信）
```

## 不进版本管理：本地运行产物

由实跑或脚本生成，可再生成，已在仓库根 `.gitignore` 排除。不要手工提交。

- `score-target-runs/` — 评分目标实跑记录，每次运行生成一批。
- `common-research-directions.json` — 生成的研究方向清单。
- `common-research-direction-evidence-strength.json` / `.md` — 生成的证据强度分析。
- `__pycache__/`、`retrieval/__pycache__/` — Python 缓存。

## 判断标准

新增文件时：是手工策划、丢了会削弱技能能力的"标准答案" → 进版本管理；是某次运行的输出、可由脚本/实跑再生成 → 加入 `.gitignore`，不提交。
