# Published-Paper Reconstruction Benchmark

Use this reference only for skill maintenance, evaluation, and calibration tasks. It is not a normal manuscript-writing workflow for a user's unpublished project.

## Purpose

PowerLit can test whether the writing and review skills can rebuild a publishable argument from real accepted evidence. The goal is not to reproduce an existing paper's text. The goal is to test whether, given the same technical object and evidence package, the skills can produce a manuscript-level argument that would survive a comparable venue review.

## Reconstruction Unit

Each benchmark case starts from one accepted PowerLit paper, but the drafting skill must not see or reuse the paper prose during reconstruction. Build an internal evidence packet with:

- venue and paper type;
- technical problem and operating object;
- proposed method, model, estimator, controller, formulation, or mechanism;
- assumptions, variables, constraints, and algorithmic steps needed to make the method reviewable;
- case-study system, data source, operating scenarios, baselines, metrics with units, and sensitivity or ablation settings;
- figure/table facts, result direction, and boundary cases;
- conclusion boundary: what the evidence proves, what it only suggests, and what remains outside scope.

Case-analysis data alone is not enough for full-paper reconstruction. If only figures, tables, or numerical summaries are available, reconstruct only the case-study/results section and mark the benchmark as section-level.

## Masking Rule

During reconstruction, hide:

- original abstract, introduction, related-work paragraphs, result paragraphs, and conclusion prose;
- author contribution wording;
- sentence order, paragraph templates, and distinctive phrases;
- title if it makes the exact contribution wording unavoidable.

Allowed inputs are evidence facts, model facts, citation identities, venue, and section targets. Do not copy sentences, phrases, or paragraph structure from the original paper.

## Drafting Task

The writing skill should produce a new manuscript argument from the evidence packet:

1. lock the venue profile and paper object;
2. build the gap-to-contribution-to-evidence map;
3. draft the requested full paper or section without source-prose access;
4. run project-claim, reader-burden, rhythm, anti-AI, and review-closure passes;
5. record whether the output is full-paper publishable, section-level acceptable, or blocked by missing evidence.

The expected target is "comparable review strength", not textual similarity.

## Review Delta

The review skill should then compare the reconstructed manuscript against the accepted-paper standard at the level of argument, not wording:

- Does the problem match a real venue-relevant difficulty?
- Is the contribution a technical object rather than a narrative wrapper?
- Is the model/method complete enough for review?
- Does the case evidence test the claimed innovation?
- Are baselines, metrics, systems, scenarios, and boundaries sufficient for the venue?
- Does the conclusion stay inside the demonstrated evidence?

Classify every failure as one of:

- missing method fact;
- missing evidence fact;
- wrong venue rhythm;
- weak gap/contribution chain;
- unsupported claim;
- copied or source-like wording;
- review gate too loose;
- review gate too harsh.

## Skill Learning Rule

Use reconstruction failures to update durable rules only when the failure repeats across multiple papers or exposes a clear gate bug. Do not overfit to one author's style. The durable update should usually be a better venue profile, evidence packet requirement, review gate, result-writing rule, or no-copy boundary.

## Output Boundary

Do not publish reconstructed text as a derivative substitute for the original paper. Use it as internal skill evaluation, regression testing, and rule calibration.
