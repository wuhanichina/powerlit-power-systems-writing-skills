# PowerLit Evidence-Strength Learning

Use this reference before drafting, rewriting, or scoring a full paper when PowerLit is available. The goal is to learn from accepted papers what evidence is manuscript-facing, what evidence strength normally survives review, and which missing facts should block a high-score claim.

## Core Rule

Do not use PowerLit only as a citation finder or style source. Use it first as an evidence-strength teacher.

Before writing a full paper or assigning an 8-9 target, build an evidence-strength profile from venue-near and mechanism-near accepted papers. The profile must answer:

- what system, data, scenario, baseline, metric, sensitivity, ablation, runtime, and reproducibility facts are visible in the published paper;
- which facts appear in the main text or tables rather than only in code, supplementary material, or local files;
- how the paper connects each result to the claimed model, mechanism, estimator, controller, certificate, or diagnostic boundary;
- what boundary language is used when the proposed method is not uniformly best on all metrics;
- what evidence would be missing if the current manuscript tried to make the same class of claim.

## Method-Canon Baselines

For the user's recurring research, do not start from project-specific PowerLit scans alone. First load `evaluation/method-canon/method-canon.json` when it is available.

Map the current paper to one or more broad directions:

- probabilistic power flow and uncertainty propagation;
- unit commitment;
- optimal dispatch;
- probabilistic optimal power flow;
- risk, resilience, and cost allocation;
- probabilistic operation optimization;
- distribution topology and parameter identification;
- distribution three-phase rebalancing;
- moment, SDP, and feasibility-certificate methods.
- grid planning;
- grid dispatch and operation;
- pricing methods;
- electricity market design.

Use the nearest verified and accepted method-canon entries as quality anchors: foundational papers define the method family, method exemplars show what a reviewable formulation and comparison look like, and evidence-bar exemplars show which manuscript-facing quantities survived review. Then add stricter gates for the paper's claim class. For example, an inverse PALI paper should be compared against probabilistic-power-flow and diagnostic/certificate anchors when it claims identifiability, feasibility, or non-substitutable inverse value.

Apply canon consumption limits:

- `powerlit_status=in_corpus`: may support citation, evidence-bar extraction, and style/structure pattern learning from the retrieved PowerLit record.
- `powerlit_status=out_of_corpus`: may support bibliographic positioning only; do not infer manuscript-facing quantities, evidence depth, or result patterns from title/metadata alone.
- `curation_status` below `accepted` or `metadata_verification.status` below `verified`: pending candidate only, not a manuscript citation or evidence exemplar.

The method canon cannot replace a final full-corpus novelty check before submission. It prevents the skill from treating keyword-noisy neighbors as classics, but current nearest-neighbor coverage still comes from the main corpus.

## Evidence-Strength Profile

For a target paper, score-target task, or skill-maintenance case, extract a compact profile from 3 to 5 accepted papers:

1. `Paper object`: venue, paper type, grid object, technical problem, and contribution type.
2. `Method visibility`: assumptions, variables, constraints, algorithm steps, theorem/certificate/diagnostic quantities, and physical intuition written in the paper.
3. `Case-study visibility`: test systems, data source, operating scenarios, baselines, metrics with units, comparison protocol, and result tables or figures.
4. `Evidence depth`: sensitivity, ablation, scalability/runtime, boundary/failure case, statistical robustness, or field-data realism when these support the claim.
5. `Reproducibility visibility`: solver, tolerance, random seed, hardware/software, stopping criteria, data split, or source artifact when relevant.
6. `Claim support`: which conclusions are directly supported, which are only suggested, and which are explicitly left outside scope.
7. `Review implication`: what the current manuscript must add, downgrade, or relabel to match the accepted-paper evidence bar.

The evidence-strength profile is an internal drafting artifact unless the user asks to see it. Do not paste it into manuscript prose.

## Claim-Class Evidence Bars

Use the profile to set the minimum evidence bar by claim class:

- Accuracy or superiority claim: strongest relevant baselines, same metric direction, same operating scenario, and enough systems or cases to exclude one-off behavior.
- Diagnostic or inverse-method claim: a non-substitutable operating scenario, direct evidence for the diagnostic or inverse value, and separation from stronger forward baselines on accuracy or speed.
- Certificate or feasibility claim: formal condition, numerical certificate definition, solver tolerance, weak/inconclusive handling, and at least one feasible and one infeasible or boundary case.
- Optimization or control claim: objective/constraint visibility, tractability or convergence explanation, operational metric, baseline policy, and stress/sensitivity case.
- Data-driven claim: data source, split or temporal protocol, out-of-sample or cross-scenario evidence, baseline model, uncertainty or robustness check, and grid-side metric.
- Scalability or real-time claim: larger system, runtime breakdown, hardware/software context, and complexity or bottleneck discussion.

If the current evidence packet falls below the accepted-paper bar for its claim class, narrow the paper object before writing. Do not compensate with smoother prose.

## Manuscript-Facing Quantities

Accepted papers usually make review-critical quantities visible in the paper. For power-system papers, require manuscript-facing statements for:

- system and scenario: network, load/renewable/market/disturbance condition, horizon, and sample count when relevant;
- baselines: method names, information access, implementation fairness, and why each baseline is relevant;
- metrics: definition, unit, direction, aggregation scope, and denominator;
- parameters: solver, tolerance, hyperparameters, random seeds, and switch/fallback rules when they affect results;
- evidence variation: sensitivity, ablation, boundary, failure, or transition cases when the claim depends on a module or threshold;
- result provenance: source table, figure data, report, log, or manifest for every number used in manuscript prose.

## Failure Modes to Block

Block an 8-9 full-paper target when any of these remain after the PowerLit evidence-strength pass:

- the current manuscript has fewer evidence dimensions than accepted papers making the same claim class;
- the core module is disabled in a main case but the paper presents the case as full-method validation;
- a stronger baseline wins on primary metrics and the manuscript has no validated non-substitutable scenario;
- the same metric name is used with different aggregation or post-processing across tables without explanation;
- critical quantities are only local file paths, code comments, or external CSV names rather than manuscript-facing definitions;
- the conclusion generalizes beyond the systems, scenarios, and baselines actually tested.

## No-Copy Boundary

Use accepted papers to learn evidence expectations, not wording. Do not copy sentences, paragraph order, figure captions, or title phrasing from PowerLit papers. Extract evidence functions and review thresholds, then write around the current paper's own method and results.
