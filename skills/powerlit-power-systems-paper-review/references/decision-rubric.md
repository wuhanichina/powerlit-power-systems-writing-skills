# Independent Review Decision Rubric

Use this rubric only after applying `independent-reviewer-protocol.md` and completing the evidence-bound findings.

## Statistical Status

The 1-10 scores are internal descriptive scores. They are not:

- target-journal official scores;
- calibrated probabilities of acceptance;
- thresholds learned from accepted papers;
- substitutes for fatal-issue analysis.

Accepted-paper samples estimate characteristics conditional on publication. Without comparable rejected-paper outcomes, they cannot identify acceptance probability or an acceptance threshold. Scores must therefore be interpreted as a structured summary of the current evidence state.

## Nine Equal-Weight Dimensions

Score each dimension from 1 to 10 and give a location/evidence-based deduction reason.

1. 选题与行业相关性。
2. 创新性，并标注理论、方法或工程创新。
3. 建模正确性。
4. 方法合理性与可扩展性。
5. 算例与对比充分性。
6. 结论可信度与可外推性。
7. 可复现性。
8. 可读性。
9. 投稿匹配度，并指明目标期刊与论文类型。

Default to equal weighting. A non-equal weighting is permitted only when the user requests it or the paper type makes equal weighting demonstrably inappropriate; state the weights and reason before scoring.

## Score Anchors

Use these descriptive anchors consistently:

- `9-10`: the supplied evidence establishes this dimension with only minor bounded refinements remaining;
- `7-8`: substantially developed but containing one or more repairable weaknesses;
- `5-6`: major evidence, correctness, or positioning repair is required;
- `3-4`: a central weakness makes this dimension unsuitable for submission in its current form;
- `1-2`: fatal or nearly fatal failure in this dimension, or no usable evidence for a central requirement.

A missing section must not receive a high score because it might exist elsewhere. Score only the supplied scope and label section-only review where applicable.

## Total Score

Compute the arithmetic mean:

\[
S=\frac{1}{9}\sum_{i=1}^{9}s_i.
\]

Report the numerical average and `【高/中/低】` confidence. Confidence reflects the completeness and traceability of supplied evidence, not certainty about the editor's future decision.

Do not mechanically map an average to a verdict. Examples:

- one high-confidence fatal model error can justify rejection despite a moderate average;
- incomplete manuscript scope can require a section-level result despite high prose quality;
- unresolved external literature coverage should reduce confidence rather than become an invented omission.

## Readiness State

Report one state separately from the verdict:

- `BLOCKED`: a fatal issue, invalid central method, or missing central evidence prevents serious submission review;
- `SECTION_READY`: the supplied section is technically reviewable, but full-paper readiness is unknown;
- `MANUSCRIPT_REVIEW_READY`: the complete manuscript can undergo serious peer review, although major revisions may remain;
- `SUBMISSION_CANDIDATE`: no fatal issue is established and remaining issues are bounded; this is not an acceptance prediction.

## Verdict Mapping

Use the four user-facing verdicts from the independent protocol.

### 直接录用

Rare. Use only when the complete manuscript has no meaningful technical or evidence defect and no important item remains `【待核查】`. This is a reviewer recommendation, not an editorial decision.

### 小修

Use when the central contribution, model, evidence, and conclusion are established. Remaining issues are bounded clarification, minor reproducibility details, limited extra analysis, or format/wording repair that does not alter the central result.

### 大修

Means `建议大修后重新评审`, not “大修后录用”. Use when the direction may be publishable but substantial model explanation, evidence, comparison, reproducibility, framing, or paper-type alignment must be repaired and no established fatal flaw necessarily invalidates the work.

### 拒稿

Use when a high- or medium-confidence fatal issue remains, the central validation cannot support the claim, the paper solves a materially different problem from the one motivated, or the contribution is not viable for the selected paper type/venue after evidence-bound comparison.

Suspected external plagiarism or duplication cannot be used without external evidence. Text-internal duplication, inconsistent numbers, or citation-content contradictions may be used when their locations are identified.

## Finding-to-Decision Discipline

Order findings by severity:

1. fatal correctness or integrity defects;
2. major technical defects;
3. missing or unfair evidence;
4. literature/positioning items, separated into `【已确认遗漏】` and `【待核查】`;
5. venue or paper-type mismatch;
6. readability and format.

For each finding state:

- location;
- manuscript claim;
- quoted/formula/table evidence;
- why the evidence fails;
- what to change;
- how to change it;
- pass criterion.

Mark non-executable strategic advice `【方向性建议】` and supply the first concrete step.

## Required Score Output

| 维度 | 分数（1-10） | 扣分依据 |
|---|---:|---|
| 选题与行业相关性 | | |
| 创新性（理论/方法/工程） | | |
| 建模正确性 | | |
| 方法合理性与可扩展性 | | |
| 算例与对比充分性 | | |
| 结论可信度与可外推性 | | |
| 可复现性 | | |
| 可读性 | | |
| 投稿匹配度（期刊与论文类型） | | |

Then report:

- total average and confidence;
- evidence scope: full manuscript or named section(s);
- readiness state;
- final verdict and confidence;
- lowest-scoring dimension;
- first repair action.
