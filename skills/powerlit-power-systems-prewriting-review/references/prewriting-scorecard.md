# Prewriting Scorecard

Use this after the innovation chain, model/evidence readiness, literature-near novelty check, and venue-fit pass. The scorecard is a diagnostic tool for deciding what must be repaired before writing. Scores are not publication probabilities, journal decisions, or editor judgments.

## Required Scores

Give each dimension a 1-10 score with a short evidence-based reason:

| Dimension | Question |
| --- | --- |
| Scientificity | Is the problem framed as a clear scientific or engineering question inside the minimum research object rather than a vague task, policy slogan, or result packaging exercise? |
| Industry pain-point accuracy | Does the work identify the real pain point of the smallest matching research object or engineering method family, and does the proposed innovation directly answer it? |
| Correctness | Are the physical concepts, assumptions, variables, equations, algorithms, and evidence mutually consistent? |
| Reasonableness | Are the modeling assumptions, scope, baselines, metrics, and claim boundaries reasonable for the stated object and venue? |
| Innovation | Does the work create or reveal a new technical object, mechanism, certificate, estimator, control law, formulation, or validation insight relative to existing research progress? |
| Engineering feasibility | Can the proposed idea be implemented, simulated, measured, validated, or used in a realistic power-system setting within the stated evidence boundary? |

## Score Anchors

- `9-10`: strong, well-supported, venue-ready dimension; only minor sharpening remains.
- `7-8`: basically solid, but still needs targeted evidence, wording, or boundary repair.
- `5-6`: conditionally workable; writing may proceed only with narrowed claims and explicit repair actions.
- `3-4`: weak; major evidence, model, positioning, or pain-point repair is needed before formal writing.
- `1-2`: absent, wrong, or contradicted by the supplied material or nearby literature.

If PowerLit or literature retrieval is available, use current research progress in the same minimum research object to calibrate novelty, pain-point accuracy, evidence sufficiency, and engineering feasibility. If retrieval is unavailable, state fallback mode and score only against supplied material plus general field knowledge.

Do not reward broad but mismatched motivation. A paper can score high when it identifies and solves a narrow-object pain point that small-field experts recognize. It should score low when it replaces that narrow pain point with a generic renewable, smart-grid, resilience, planning, or operation background unsupported by the method and evidence.

## Overall Score

Return an overall 1-10 score. Use the lowest critical dimension as a cap:

- if `Correctness` is 4 or below, overall score cannot exceed 4;
- if `Industry pain-point accuracy` is 4 or below, overall score cannot exceed 5;
- if `Innovation` is 4 or below for a research paper, overall score cannot exceed 5;
- if `Engineering feasibility` is 4 or below, overall score cannot exceed 6 unless the work is explicitly theoretical and its proof path is mature.

Otherwise, compute the overall score as a judgmental synthesis, not a mechanical average. Explain which dimension controls the score.

## Maximum Defect

Always identify `最大缺陷` as one concrete defect, not a list. Choose the defect that most blocks writing or venue fit:

- wrong or vague industry pain point;
- oversized pain point that belongs to a broader background rather than the minimum research object;
- innovation not matched to the pain point;
- model cannot express the engineering need;
- correctness issue in assumptions, variables, or physical law;
- novelty already covered by nearby literature;
- evidence does not test the claimed innovation;
- engineering feasibility or validation path is missing;
- conclusion would require unsupported evidence.

For the maximum defect, state:

1. why it is the largest blocker;
2. which current evidence shows it;
3. what specific repair would most improve the score.

Do not let high prose quality, broad motivation, or mathematical elegance compensate for a low pain-point, correctness, innovation, or evidence score.
