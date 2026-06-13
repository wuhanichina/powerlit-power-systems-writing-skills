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

The previous score-target audit was too permissive. The recorded artifacts are compressed evaluation packages, not complete manuscripts. They do not contain the full method derivations, equations, algorithms, complete case-study tables, baseline discussion, references, or venue templates needed for real journal review.

Corrected rule:

1. A compressed package may receive a package diagnostic score.
2. A full-paper 8-9 gate may be passed only by a complete manuscript.
3. Missing equations, model derivation, full case comparison, or discussion blocks the full-paper gate regardless of the package's diagnostic score.
4. Existing score-target runs must be read as direction diagnostics and repair plans, not as evidence that a manuscript would pass real review.

Remaining work is still score-target skill debugging and manuscript-production work: the skill must now generate complete manuscripts or explicitly report `blocked below 8-9 full-paper completeness`.

## Generated-and-Reviewed Runs

| Evidence packet | Venue | Artifact | Current result | Next repair |
| --- | --- | --- | --- | --- |
| `csee-pali-em-sca-pv8f8` | CSEE | `evaluation/score-target-runs/csee-pali-em-sca-pv8f8-round1.md` | Package diagnostic score 8.33; blocked below 8-9 full-paper completeness | Write full equations, symbol definitions, physical intuition, baseline tables, sensitivity/boundary analysis, references, and final CSEE structure. |
| `tpwrs-rtgmm-risk-screening` | IEEE TPWRS | `evaluation/score-target-runs/tpwrs-rtgmm-risk-screening-round2.md` | Package diagnostic score 8.24; blocked below 8-9 full-paper completeness | Write full formulation, RT-GMM score equations, replay protocol, event-level tables, mismatch discussion, and references. |
| `tsg-bayesaqppf-edge-update` | IEEE TSG | `evaluation/score-target-runs/tsg-bayesaqppf-edge-update-round1.md` | Package diagnostic score 8.26; blocked below 8-9 full-paper completeness | Add full Dirichlet-NIW derivation, update algorithm, complete IEEE 13/123 tables, full-refit comparison, and references. |
| `aeps-tsvarx-mechanism-generation` | AEPS | `evaluation/score-target-runs/aeps-tsvarx-mechanism-generation-round1.md` | Package diagnostic score 8.26; blocked below 8-9 full-paper completeness | Add TS-VARX equations, applicability/tolerance tables, event-city mechanism comparison, discussion, and references. |

Remaining packets without generated-and-reviewed artifacts:

- None.

Current blocker for the overall objective:

- The repository does not yet contain complete generated manuscripts for the four venue packets. The existing runs are compressed diagnostic artifacts and must not be used as proof that the writing skill can pass real journal review.

New TPWRS replay evidence:

- Base AC replay produced `D:/Research/25Typhoon_resilience_RT-GMM/result/historical_replay_ac_base_9events_20260612_233630/historical_replay_ac_base_summary.csv`.
- Connected N-1 AC replay produced `D:/Research/25Typhoon_resilience_RT-GMM/result/historical_replay_ac_n1_connected_screened_9events_20260612_235005/historical_replay_ac_n1_screened_summary.csv`.
- Replay reference: `30344` AC N-1 topK cases, `30344` AC successes, `24333` event-minute rows with at least one AC-confirmed branch above 100%, and worst pair `285 -> 286` in all replayed events.
- The TPWRS claim was repaired from direct top-branch validation to a two-stage screening workflow because RT-GMM and AC replay expose different high-risk structures.
