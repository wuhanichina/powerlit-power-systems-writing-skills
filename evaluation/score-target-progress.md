# Score-Target Progress

Current objective: debug the writing and review skills until typical target venues can produce 8-9 review-score manuscripts when supplied with actual case evidence.

## Completed in This Iteration

- Added `references/score-targeted-writing.md` for 8-9 score-target drafting.
- Added the `8-9 Target Gate` and score-target output requirements to `powerlit-power-systems-paper-review`.
- Added `evaluation/actual-case-evidence-packets.json` with four actual project evidence packets:
  - CSEE: `PALI_EM_SCA` PV8f8 evidence.
  - IEEE TPWRS: `Typhoon RT-GMM` risk-screening evidence.
  - IEEE TSG: `BayesAQPPF_3ph` edge-update evidence.
  - AEPS: `TS_VARX` mechanism-generation evidence.
- Connected the validator to check score-target references, actual evidence packet fields, target score band, and evidence source paths.
- Added a writing test prompt for actual-case 8-9 score targeting.

## Current Validation

`scripts/Validate-PowerLitSkillRepo.ps1` passes with:

- `skill_count = 5`
- `test_prompt_files = 3`
- `review_closure_cases = 7`
- `actual_project_claim_cases = 4`
- `reconstruction_cases = 3`
- `actual_case_evidence_packets = 4`
- `score_target_run_files = 5`
- `powerlit_search = checked`

`git diff --check` passes.

Installed skill sync:

- The five local installed skills under `C:/Users/wuhan/.codex/skills` were backed up to `C:/Users/wuhan/.codex/skill-backups/_backup_powerlit_sync_20260613_001912`.
- The installed copies now match this repository's `skills/` copies by file list and SHA256 hash for:
  - `ieee-power-engineering-letter-writing`
  - `powerlit-power-systems-literature-intelligence`
  - `powerlit-power-systems-paper-review`
  - `powerlit-power-systems-paper-writing`
  - `powerlit-power-systems-prewriting-review`

## Completion Audit

The score-target objective is now proven at the representative full-paper-package level. For each typical venue packet, the repository contains:

1. Generate a manuscript or representative full-paper package from the actual evidence packet.
2. Review it with `powerlit-power-systems-paper-review`.
3. Record the eight category scores, average score, gate status, lowest-scoring category, and repair action.
4. Run at least one repair loop when any core category is below 8.
5. Show that the repaired draft reaches the 8-9 gate, or mark the missing evidence that blocks the target.

Remaining work is manuscript-production work, not score-target skill debugging: final equation numbering, reference formatting, polished figures/tables, and final venue templates would still be needed before real submission.

## Generated-and-Reviewed Runs

| Evidence packet | Venue | Artifact | Current result | Next repair |
| --- | --- | --- | --- | --- |
| `csee-pali-em-sca-pv8f8` | CSEE | `evaluation/score-target-runs/csee-pali-em-sca-pv8f8-round1.md` | Average 8.33, passes 8-9 gate as a compressed full-paper package | Add final equation blocks and complete symbol definitions before submission use. |
| `tpwrs-rtgmm-risk-screening` | IEEE TPWRS | `evaluation/score-target-runs/tpwrs-rtgmm-risk-screening-round2.md` | Average 8.24, passes 8-9 gate as a bounded two-stage screening-and-reference package | Add final notation/equation tables; preserve the RT-GMM vs AC replay mismatch as boundary evidence. |
| `tsg-bayesaqppf-edge-update` | IEEE TSG | `evaluation/score-target-runs/tsg-bayesaqppf-edge-update-round1.md` | Average 8.26, passes 8-9 gate as a compact full-paper package | Add final Dirichlet-NIW equations and keep IEEE 13 risk evidence separate from IEEE 123 scaling evidence. |
| `aeps-tsvarx-mechanism-generation` | AEPS | `evaluation/score-target-runs/aeps-tsvarx-mechanism-generation-round1.md` | Average 8.26, passes 8-9 gate only as a mechanism/scenario-generation paper; blocked for grid-risk framing | Add applicability/tolerance table and keep node-level propagation as future work. |

Remaining packets without generated-and-reviewed artifacts:

- None.

Current blocker for the overall objective:

- None at the score-target package level. The four typical venue packets now have generated-and-reviewed artifacts that either pass the 8-9 gate under their bounded paper object or explicitly block unsupported framings.

New TPWRS replay evidence:

- Base AC replay produced `D:/Research/25Typhoon_resilience_RT-GMM/result/historical_replay_ac_base_9events_20260612_233630/historical_replay_ac_base_summary.csv`.
- Connected N-1 AC replay produced `D:/Research/25Typhoon_resilience_RT-GMM/result/historical_replay_ac_n1_connected_screened_9events_20260612_235005/historical_replay_ac_n1_screened_summary.csv`.
- Replay reference: `30344` AC N-1 topK cases, `30344` AC successes, `24333` event-minute rows with at least one AC-confirmed branch above 100%, and worst pair `285 -> 286` in all replayed events.
- The TPWRS claim was repaired from direct top-branch validation to a two-stage screening workflow because RT-GMM and AC replay expose different high-risk structures.
