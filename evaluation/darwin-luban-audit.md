# Darwin and Luban Optimization Audit

## Baseline Findings

The initial skill suite already had strong power-system writing rules, venue references, a PowerLit retrieval skill, and a separate Letter skill. The main weakness was not missing style guidance. The weakness was that the full-paper entry point mixed shared rules with venue-specific routing, and the PowerLit corpus advantage was optional rather than expressed as a concrete drafting gate.

## Darwin Rubric Notes

- Frontmatter and trigger clarity were already usable.
- Workflow clarity improved by separating shared full-paper workflow from venue profiles.
- Failure modes improved by adding explicit no-invention, no-leakage, and near-neighbor gates.
- Checkpoints improved by adding prewriting, corpus access, and claim-boundary gates before manuscript drafting.
- Executable specificity improved by documenting the real `Search-PowerLitJson.ps1 -Query ... -VenueFolder ... -Top ...` interface.
- Resource integration improved by adding `corpus-grounded-drafting.md`, `venue-profiles.md`, and regression prompts.

## Luban Product Notes

The public positioning is now: PowerLit-backed power-system writing skills that turn local corpus evidence into venue-specific manuscript prose for CSEE, AEPS, TPWRS, TSG, and IEEE power-system Letters.

The chosen product structure is a hybrid split:

- one full-paper writing entry point for discoverability;
- venue profile references for journal-specific behavior;
- one independent Letter skill because Letter writing is a different paper form;
- one literature-intelligence skill as the shared evidence layer.

## Regression Prompts

Regression prompts were added for:

- IEEE TSG distributed/data-driven writing;
- IEEE TPWRS formulation writing;
- 中国电机工程学报 engineering-mechanism prose;
- 电力系统自动化 operational abstract writing;
- IEEE Letter compression and prior-work threat handling;
- PowerLit citation-pack and fallback behavior.

## Closed-Loop Test Requirement

The regression standard is now write -> review -> repair/block. A generated manuscript section may be called submission-ready only if `powerlit-power-systems-paper-review` would not find a fatal flaw, a major model/evidence/logic issue, or a venue mismatch. End-to-end closure cases are recorded in `evaluation/writing-review-closure.json`.

Review results are also part of skill evolution. When an actual-project draft fails review because the claim is too rigid, too broad, too defensive, or not paper-shaped, the failure should create or update a regression case. The next skill revision should be judged by whether it prevents the same review failure, not only by whether the prompt text reads better.

## Corpus-as-Writing-Reference Requirement

Writing now uses PowerLit in two roles. The first is evidence: citations, novelty, closest competitors, and claim boundaries. The second is writing reference: section shape, paragraph function, rhythm, contribution placement, evidence presentation, and boundary language. The rule is pattern extraction only; copied source wording is forbidden.

## Actual-Project Claim Lessons

- RT-GMM: repository claims are useful gate controls, but the paper claim must be phrased as screening and attribution, not event-level calibrated prediction.
- TS-VARX: the project explicitly rejects forecasting-superiority framing; paper writing should express mechanism reproduction and dynamic injection-scenario generation.
- PALI_EM_SCA: the strongest paper claim is identifiability/inverse formulation/certification, not accuracy dominance over GMM-PLF.
- BayesAQPPF_3ph: full-refit boundary evidence prevents uniform-dominance language; paper writing should state small-sample/edge-update stability and acknowledge larger-sample refit strength.
