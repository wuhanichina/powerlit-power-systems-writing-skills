# Model and Evidence Readiness

Use this reference to decide whether the technical core is ready for writing.

## Model Readiness

Check:

- system object is defined;
- variables, parameters, indices, and sets are identified;
- objective and constraints match the stated problem;
- assumptions are explicit;
- physical laws and operating limits are respected;
- units, signs, and time scales are consistent;
- approximation, relaxation, or linearization has a stated boundary;
- algorithm steps correspond to specific model difficulties.

`NO-GO` if the model omits the constraint that defines the claimed problem, changes the physical problem without disclosure, or uses undefined variables central to the claim.

## Evidence Readiness

A case package should map one-to-one to the claims:

- each innovation has at least one verifying result;
- superiority claims have baselines;
- robustness claims have disturbances, uncertainty, attacks, or out-of-sample tests;
- scalability claims have larger systems or runtime evidence;
- parameter-dependent claims have sensitivity or ablation;
- engineering applicability claims have realistic scenarios, data, or implementation constraints.

## Claim Boundary

Before writing, classify each claim:

- `supported`: can be stated directly;
- `conditional`: can be stated with assumptions or scope;
- `unsupported`: cannot be written as a paper claim;
- `future`: belongs to future work, not contribution.

The writing skill should only use supported and conditional claims.
