# IEEE TPWRS Writing Reference

## Corpus Signal

PowerLit mining used 661 JSON papers from the IEEE TPWRS subset of the local JSON corpus.

- Median page count: 13.
- Extracted abstracts: 621.
- Abstracts: median 8 sentences; average sentence length about 24 words.
- Abstract pattern: 64.9% use "This paper", 44.3% refer to "the proposed method/approach/model", 31.9% mention tractability/convexity/scalability/efficiency, 37.8% mention case studies or numerical tests, and 51.7% use demonstrate/show/validate/verify language.
- Frequent headings include `I. INTRODUCTION`, `NOMENCLATURE`, `II. PROBLEM FORMULATION`, `IV/V. CASE STUDY`, and `CONCLUSION/CONCLUDING REMARKS`.

Use this to write like TPWRS, not like a generic AI/ML conference paper. Identify the supplied research object before applying this profile.

## Register

TPWRS values precise mathematical and system-operational claims. The prose should be direct, active, and evidence-bound. The central object may be a formulation, control law, market mechanism, estimator, stability certificate, reliability model, planning model, or solution algorithm, but it must come from the supplied paper rather than from the venue profile.

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
- generic "outperforms state of the art" unless the baseline set justifies it,
- optimization, planning, security, or guarantee claims that are not present in the supplied method and evidence.

## Abstract

Recommended shape:

1. One sentence for target system setting and the supplied problem.
2. One sentence for the paper's technical object.
3. Two to four sentences for formulation, reformulation, estimator, algorithm, certificate, or control mechanism according to the supplied object.
4. One sentence for tractability, scalability, security, or guarantee only if proven.
5. One sentence for case-study evidence and main numerical finding.

Use "This paper" once at the beginning if useful. After that, let the method or formulation be the subject.

## Introduction

Use a TPWRS introduction arc:

1. System context and consequence for the supplied research object.
2. Literature groups by method class.
3. Technical gap, stated as a modeling, information, uncertainty, or computational limitation.
4. Proposed contribution and why it resolves the gap.
5. Contribution list only if it is specific and technical.

When contributions are listed, each item should contain a deliverable and its advantage:

- formulation, estimator, certificate, or mechanism + what constraint/uncertainty/physics it captures,
- reformulation/algorithm + why it is tractable when tractability is claimed,
- validation + what systems/scenarios it covers.

## Formulation And Method

Use TPWRS section names such as:

- `NOMENCLATURE`
- `II. PROBLEM FORMULATION`
- `II. SYSTEM MODEL`
- `III. PROPOSED METHOD`
- `III. SOLUTION ALGORITHM`
- `IV. CASE STUDY`

Write assumptions explicitly. Define sets, indices, variables, uncertainty, and information timing before equations when they belong to the supplied object. If using convex relaxation, decomposition, chance constraints, distributional robustness, or stability conditions, separate:

- original physical model,
- approximation/reformulation,
- guarantee or limitation,
- algorithm.

Do not convert a non-optimization manuscript into an optimization/planning/security-constraint paper only because TPWRS often expects formulation-led prose. If the supplied object is an estimator, certificate, counterexample, reliability index, or validation protocol, make that object assumption-explicit and evidence-bound instead.

## Case Studies

State:

- IEEE or real system,
- data source and uncertainty model,
- scenarios or test conditions,
- baselines,
- metrics and units,
- solver and hardware when runtime is a claim.

Use "Numerical tests" or "Case studies" rather than "Experiments" unless physical experiments are involved.

For screening papers, include a reference check that tests screening quality, not only internal metric movement. Examples include AC-MC validation for selected high-risk events, replay validation, operator event labels, or a stronger offline calculation. If this reference check is absent, write the result as candidate prioritization and do not target `MANUSCRIPT_REVIEW_READY` for a TPWRS full paper.

## Conclusion

Use a short paragraph. State the demonstrated result and one realistic limitation or future extension when appropriate. Avoid expansive social-impact closing sentences.
