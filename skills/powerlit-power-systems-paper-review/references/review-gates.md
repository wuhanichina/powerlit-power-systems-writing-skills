# Corpus-Based Review Gates

This reference summarizes acceptance signals inferred from already published PowerLit papers. These are necessary signals, not mechanical acceptance rules.

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
