# Internal Readiness Progress

Current objective: maintain the writing and review skills so supplied evidence packets can be turned into bounded manuscripts, section drafts, or blocker reports with a clear `PowerLit Internal Readiness Index`.

## Current Standard

The former score-band language has been migrated to internal readiness:

- `target_score_band` -> `target_readiness_state`
- `minimum_average` / `minimum_core_category` -> `required_dimensions`
- missing or fatal conditions -> `blocking_conditions`

Readiness states:

- `BLOCKED`
- `SECTION_READY`
- `MANUSCRIPT_REVIEW_READY`
- `SUBMISSION_CANDIDATE`

The readiness index is local and diagnostic. It is not a journal reviewer score, an acceptance threshold, or an acceptance-probability estimate.

## Existing Evidence Packets

The public actual-case evidence packets remain useful as maintenance fixtures, but their outputs must be interpreted as bounded readiness diagnostics:

| Case | Venue | Current Boundary |
|---|---|---|
| `csee-pali-em-sca-pv8f8` | CSEE | Inverse voltage-domain formulation, identifiability boundary, blkLR stabilization, and SDP certificate relative to the stated relaxation and constraints. |
| `tpwrs-rtgmm-risk-screening` | IEEE TPWRS | Two-stage screening and boundary diagnosis; no direct equivalence claim between closed-form RT-GMM ranking and AC replay. |
| `tsg-bayesaqppf-edge-update` | IEEE TSG | Edge update value must be separated by voltage/distribution accuracy, risk-ranking preservation, runtime/resource state, and feeder exclusions. |
| `aeps-tsvarx-mechanism-generation` | AEPS | Mechanism/scenario-generation framing only; no node-level propagation, dispatch improvement, or probabilistic power-flow closure claim without matching evidence. |

## Remaining Work

- Expand behavior tests from fixture schema checks into real model-output grading with human adjudication.
- Add calibrated readiness examples for Application Paper, Review Paper, and Letter types.
- Keep published-paper corpus usage descriptive: completeness benchmark, evidence-dimension reference, and writing-structure reference only.
