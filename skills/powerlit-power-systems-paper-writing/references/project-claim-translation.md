# Project Claim to Paper Claim Translation

Use this reference whenever a project provides `claims.md`, `evidence_map.md`, a research note, a gate report, a reviewer support index, or a pre-submission review. These files are not automatically manuscript claims. They often exist to keep the project honest, so their wording can be too rigid, defensive, implementation-specific, or gate-shaped for a paper.

Chinese-facing wording rule: translate "claim" as "论点" rather than "主张". Keep code identifiers, filenames, and schema fields such as `claims.md`, `claim_boundary`, and `paper_claim_candidate` unchanged.

## Core Rule

Do not preserve a project claim verbatim unless it already reads as a venue-fit scientific contribution. Translate it.

Project claims usually answer: "What can this repository currently prove without overclaiming?"

Paper claims must answer: "What technical object does this paper contribute, why is it necessary, what does it establish, and under what boundary?"

## Translation Workflow

Before drafting, build this internal map:

| Item | Required content |
| --- | --- |
| Source claim | The claim as written in project materials. |
| Evidence state | supported, implemented, diagnostic, unsupported, conditional, or retarget. |
| Review failure risk | How `powerlit-power-systems-paper-review` would attack the claim. |
| Paper claim candidate | A contribution-shaped statement for the target venue. |
| Boundary sentence | What the paper does not claim. |
| Required repair | Missing experiment, baseline, citation, model definition, or retargeting needed before submission-ready writing. |

Use this map internally. Do not print it unless the user asks for planning, review, or claim design.

## Common Translation Patterns

### Rigid Screening Claim

Project wording: "The method is a candidate-screening and attribution tool, not an event-level calibrated predictor."

Paper translation: "The paper contributes a closed-form screening and attribution model for identifying typhoon-conditioned high-risk line candidates under base and connected N-1 topology states."

Boundary: "The result supports screening and attribution, not calibrated event-level overload prediction or full N-k risk coverage."

### Non-Forecasting Mechanism Claim

Project wording: "This is not a load, wind, or net-load forecasting paper."

Paper translation: "The paper models weather-conditioned source-load mechanism reproduction and converts observed typhoon effects into dynamic injection-scenario variants for downstream risk studies."

Boundary: "It does not claim point-forecasting superiority or completed node-level risk propagation unless those experiments exist."

### Honesty Constraint Against Superiority

Project wording: "Do not claim the method dominates the closest baseline."

Paper translation: "The paper's contribution is the identifiable inverse formulation, certificate, or mechanism insight that the baseline does not provide; accuracy is reported as competitive, complementary, or boundary-dependent."

Boundary: "Do not use superiority language when the evidence only supports complementarity, scope control, or diagnosis."

### Boundary Without Defensive Posture

Project wording often starts from a negative guardrail: "do not claim X", "not a replacement for Y", or "only under condition Z". That language is useful for internal evidence control, but it is not normally publishable manuscript posture.

Manuscript translation must follow this order:

1. State the strongest positive technical object first: formulation, certificate, mechanism, estimator, control law, or diagnostic property.
2. State the comparator's valid role only where the comparison is used.
3. Attach the boundary to the evidence condition, not to the paper's self-image.

Forbidden manuscript posture:

- "需要强调的是，本文不把结果表述为..."
- "本文不主张对某基线形成全面替代..."
- "The method is not intended to replace..."
- "This result should not be overinterpreted as..."

Paper-fit posture:

- "线性化 GMM 概率潮流为局部线性假设成立且功率域分量划分充分的场景提供精度基线；本文转向功率统计量到电压分布的反演可辨识性，利用二次型潮流矩核刻画电压均值、协方差与功率矩之间的对应关系，并通过可辨识诊断和 SDP 可行性证书给出可恢复统计结构与物理可实现边界。"
- "Linearized GMM-based PLF remains the direct accuracy baseline under locally valid linearization and adequate input-component partitioning. The proposed formulation instead treats voltage-distribution recovery as an inverse moment-matching problem and certifies which voltage statistics are identifiable and physically realizable from the supplied power moments."

If the paragraph still begins with "not", "does not", "不", or "并非", rewrite it before delivery unless the user explicitly asked for a limitations paragraph or reviewer response.

### Diagnostic Boundary Evidence

Project wording: "A larger-sample refit can outperform the proposed update in one subset."

Paper translation: "The proposed update is positioned for small-sample stability, online updating, or evidence-efficient operation; large-sample refit remains a strong diagnostic comparator."

Boundary: "Do not claim uniform dominance across sample sizes, systems, or metrics."

## Review-Result Feedback

Use review output to refine the skill behavior, not only the current draft:

- If review says the claim is too broad, add a boundary sentence or retarget the venue.
- If review says the contribution is only implementation packaging, reframe around the mathematical object, mechanism, estimator, control law, certificate, or evidence insight.
- If review says evidence does not support the conclusion, downgrade the claim before polishing prose.
- If review says the draft is defensive, keep the boundary but make the main technical judgment positive and direct.
- If review says the problem, method, and evidence solve different objects, rebuild the paper object map before writing another paragraph.

For skill evolution, record the failure mode as a regression case when it appears in a real project. A new writing rule is useful only if it prevents the same review failure in a later draft.

## Actual-Project Regression Anchors

Use actual projects as regression anchors when evolving this skill:

- RT-GMM: screening and attribution must not become calibrated event-level prediction or full N-k coverage.
- TS-VARX: mechanism reproduction and dynamic injection-scenario generation must not become a forecasting-superiority paper.
- PALI_EM_SCA: identifiability, single-step inverse formulation, and feasibility certificate must not become an unsupported accuracy-dominance claim over GMM-PLF.
- BayesAQPPF_3ph: edge-side Bayesian updating must not become uniform dominance over full refit when larger-sample refit can win in a subset.

These anchors are not text templates. They are review-failure tests.
