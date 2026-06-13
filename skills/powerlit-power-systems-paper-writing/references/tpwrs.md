# IEEE TPWRS Writing Reference

## Corpus Signal

PowerLit mining used 661 JSON papers from the IEEE TPWRS subset of the local JSON corpus.

- Median page count: 13.
- Extracted abstracts: 621.
- Abstracts: median 8 sentences; average sentence length about 24 words.
- Abstract pattern: 64.9% use "This paper", 44.3% refer to "the proposed method/approach/model", 31.9% mention tractability/convexity/scalability/efficiency, 37.8% mention case studies or numerical tests, and 51.7% use demonstrate/show/validate/verify language.
- Frequent headings include `I. INTRODUCTION`, `NOMENCLATURE`, `II. PROBLEM FORMULATION`, `IV/V. CASE STUDY`, and `CONCLUSION/CONCLUDING REMARKS`.

Use this to write like TPWRS, not like a generic AI/ML conference paper.

## Register

TPWRS values precise mathematical and system-operational claims. The prose should be direct, active, and evidence-bound. The central object is usually a formulation, control law, market mechanism, estimator, stability certificate, or solution algorithm.

Prefer:

- "This paper presents/formulates/derives..."
- "The proposed formulation enforces..."
- "The reformulation yields..."
- "Numerical tests on the IEEE ... system show..."
- "The method is compared with..."

Avoid:

- "novel paradigm", "comprehensive framework", "seamless integration",
- "we delve into/explore" for technical contributions,
- contribution claims without assumptions or numerical evidence,
- generic "outperforms state of the art" unless the baseline set justifies it.

## Abstract

Recommended shape:

1. One sentence for target system setting and operational issue.
2. One sentence for the paper's technical object.
3. Two to four sentences for formulation, reformulation, algorithm, or control mechanism.
4. One sentence for tractability/scalability/security guarantee if proven.
5. One sentence for case-study evidence and main numerical finding.

Use "This paper" once at the beginning if useful. After that, let the method or formulation be the subject.

## Introduction

Use a TPWRS introduction arc:

1. System context and operational consequence.
2. Literature groups by method class.
3. Technical gap, stated as a modeling, information, uncertainty, or computational limitation.
4. Proposed contribution and why it resolves the gap.
5. Contribution list only if it is specific and technical.

When contributions are listed, each item should contain a deliverable and its advantage:

- formulation + what constraint/uncertainty/physics it captures,
- reformulation/algorithm + why it is tractable,
- validation + what systems/scenarios it covers.

## Formulation And Method

Use TPWRS section names such as:

- `NOMENCLATURE`
- `II. PROBLEM FORMULATION`
- `II. SYSTEM MODEL`
- `III. PROPOSED METHOD`
- `III. SOLUTION ALGORITHM`
- `IV. CASE STUDY`

Write assumptions explicitly. Define sets, indices, variables, uncertainty, and information timing before equations. If using convex relaxation, decomposition, chance constraints, distributional robustness, or stability conditions, separate:

- original physical model,
- approximation/reformulation,
- guarantee or limitation,
- algorithm.

## Case Studies

State:

- IEEE or real system,
- data source and uncertainty model,
- operating scenarios,
- baselines,
- metrics and units,
- solver and hardware when runtime is a claim.

Use "Numerical tests" or "Case studies" rather than "Experiments" unless physical experiments are involved.

For screening papers, include a reference check that tests screening quality, not only internal score movement. Examples include AC-MC validation for selected high-risk events, replay validation, operator event labels, or a stronger offline calculation. If this reference check is absent, write the result as candidate prioritization and do not target an 8-9 TPWRS full-paper score.

## Conclusion

Use a short paragraph. State the demonstrated result and one realistic limitation or future extension when appropriate. Avoid expansive social-impact closing sentences.
