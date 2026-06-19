# Corpus-Based Review Gates

This reference summarizes acceptance signals inferred from already published PowerLit papers. These are necessary signals, not mechanical acceptance rules.

## Reconstruction Calibration

Accepted PowerLit papers can calibrate the review skill through masked reconstruction: hide source prose, provide only the technical object and evidence packet, let the writing skill reconstruct the argument, and then review the reconstruction against venue standards.

Use this calibration to find review-gate errors, not to reward textual similarity. A reconstruction fails at full-paper level when the supplied packet lacks method facts, baseline protocols, metric definitions, or claim boundaries, even if the numerical case data look strong. In that situation, review only the case-study section and mark the missing facts as blockers for a full-paper verdict.

## Evidence-Strength Calibration

Before judging a full-paper draft as internally ready or submission-ready, compare its evidence dimensions with accepted PowerLit papers from the same venue or claim class. Use `powerlit-evidence-strength.md` and, when shell access is available, `Analyze-PowerLitEvidenceStrength.ps1` to identify which quantities accepted papers make visible in the manuscript.

Run the research-object check before venue comparison. Compare with accepted papers in the same venue and claim class only after the manuscript's power-system object, problem type, technical object, and evidence object are clear.

The comparison should ask:

- Does the draft expose the same class of systems, scenarios, baselines, metrics, sensitivity, ablation, runtime, certificate, or reproducibility details as accepted papers making a similar claim?
- Does the case study verify the proposed mechanism, or only show that the method ran?
- Are fallback rules, disabled modules, and weaker-than-baseline dimensions labeled as clearly as accepted papers label their boundaries?
- Are result numbers defined and traceable in the manuscript, not only in local result files?

If the current draft has materially thinner evidence than accepted papers in the same claim class, lower evidence sufficiency and claim-boundary scores even when the prose is fluent.

## Published-Corpus Surface

| Venue / Type | Papers | Median pages | Median intro paragraphs | Gap marker | Median method paragraphs | Median case paragraphs | Median references |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 中国电机工程学报 | 802 | 12 | 7 | 98.6% | 30 | 22 | 28 |
| 电力系统自动化 | 538 | 11 | 7 | 99.3% | 40 | 22 | 26 |
| IEEE TPWRS full papers | 553 | 13 | 12 | 87.5% | 68 | 10 | 38 |
| IEEE TSG full papers | 209 | 14 | 12 | 87.1% | 62 | 15 | 38 |
| IEEE power-system Letters | 69 | 4 | 7 | 88.4% | 23 | 7 | 9 |

Interpret these numbers as a review baseline:

- A full-paper draft with no clear gap is below the observed published standard.
- A full-paper draft with a thin method section is structurally immature.
- A full-paper draft whose case section only shows one running example is usually under-validated.
- A Letter can be short, but it still needs a concrete technical core and a decisive evidence object.

## Five Review Gates

### Gate 1: Problem Specificity

The manuscript must state a power-system difficulty that is concrete enough to be tested:

- security, stability, voltage/frequency, uncertainty, observability, computation, coordination, market operation, resilience, planning, protection, or control;
- a stated failure mode of existing methods;
- a reason the issue matters under current grid conditions.

Reject risk is high when the problem is only "new energy development", "new power system", "low-carbon transformation", or "improving efficiency" without a technical contradiction.

### Gate 2: Technical Object

The contribution should be a reviewable technical object:

- model or formulation;
- constraint, relaxation, or reformulation;
- control law or dispatch mechanism;
- estimator or identification method;
- algorithm with a reason for tractability;
- analytical property, certificate, or counterexample;
- validation design revealing a new operational insight.

Packaging several known modules is not enough unless the coupling itself is new and necessary.

### Gate 3: Correctness

The physical system, assumptions, variables, equations, and algorithms must be mutually consistent. A paper can be rejected for a correct-looking formula chain if the chain solves a different engineering problem from the one claimed.

Correctness also includes physical readability. Equations that define symbols but never explain the represented grid object, coupling direction, feasibility condition, or operational meaning remain review-risky even when the algebra is internally consistent.

### Gate 4: Evidence

The case study must test the claimed innovation, not just the ability to run the method. Strong evidence normally includes:

- relevant test system or field data;
- baseline methods;
- metrics with units;
- scenarios or uncertainty/disturbance settings;
- sensitivity or ablation when the claim depends on parameters or components;
- runtime or scalability only when claimed.

### Gate 5: Claim Boundary

The conclusion must stay within what the paper proves or demonstrates. Strong papers state the boundary without weakening the contribution.

Flag defensive boundary posture when a manuscript leads with "not a replacement", "does not claim", or "本文不..." instead of stating the positive technical object and the scoped comparison condition. The problem is not honesty; the problem is that the paper has failed to translate an internal gate into a publishable claim.
