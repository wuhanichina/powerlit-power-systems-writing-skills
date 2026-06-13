# TPWRS Score-Target Run: RT-GMM Risk Screening

Case id: `tpwrs-rtgmm-risk-screening`
Target venue: `IEEE TPWRS`
Target score band: `8-9`
Run status: `repairable below 8-9; current evidence supports a strong screening paper direction but not an 8-9 TPWRS full-paper verdict`
Full-paper readiness: `compressed evaluation package only; missing independent reference evidence in this round and missing complete manuscript structure`

## Evidence Packet

Technical object: closed-form candidate-line risk screening under typhoon-conditioned multimodal source-load tails and connected N-1 topology states.

Actual evidence used:

- Nine typhoon events with per-event top-risk branch, time, truncation diagnostics, retained scenario mass, and attribution outputs.
- Bebinca: maximum violation probability `2.943e-3` at branch 202, mean retained scenario mass `0.99145`, maximum unretained fault mass `0.26739`.
- Muifa: maximum violation probability `9.926e-4` at branch 202, mean retained scenario mass `0.99854`, maximum unretained fault mass `0.05303`.
- Source-load ablation: replacing typhoon-conditioned PCA-GMM with non-typhoon PCA-GMM changes the top branch in 6/9 events, gives median top-10 overlap `0.000`, median branch Spearman `-0.873`, and median log10 risk shift `5.357`.
- Source-load ablation: replacing typhoon-conditioned PCA-GMM with non-typhoon single Gaussian changes the top branch in 6/9 events, gives median top-10 overlap `0.000`, median branch Spearman `-0.971`.

Boundary:

- Use the evidence for screening, ranking, and attribution.
- Do not claim calibrated event-level overload prediction.
- Do not claim AC-MC equivalence.
- Do not claim complete N-k topology coverage.

PowerLit coverage:

- The target script search for `typhoon risk screening transmission line overload probabilistic contingency` in `ieee_tpwrs` timed out after 180 s.
- A fast `rg` candidate search found TPWRS papers on weather-related faults, contingencies, overloads, and voltage-stability screening, but no inspected candidate matched the same combination of typhoon-conditioned source-load GMM tails, connected N-1 topology states, closed-form PTDF propagation, and event-level attribution.
- Literature coverage is therefore marked as limited. A final TPWRS manuscript needs a curated nearest-neighbor table before submission.

## Manuscript Package

### Title

Typhoon-Conditioned Multimodal Source-Load Modeling for Candidate Line-Risk Screening Under Connected N-1 States

### Abstract

Extreme weather can redirect transmission-line overload risk by changing both source-load injections and outage-conditioned network states. This paper presents a risk-screening model that represents typhoon-period source-load anomalies as conditional multimodal tails and couples them with base and connected N-1 topology states. The model propagates each retained source-load mode through a PTDF-based flow map and evaluates candidate overload probabilities in closed form. A truncation diagnostic is retained for each event so that the screening result is not interpreted as a calibrated event-level probability forecast. Case studies on nine historical typhoon events show that typhoon-conditioned source-load statistics alter the screened branch set: replacing the typhoon PCA-GMM with a non-typhoon PCA-GMM changes the top-risk branch in 6/9 events and yields a median top-10 overlap of 0.000. The results support candidate-line screening and attribution under the considered topology set, but they do not establish AC-MC equivalence or complete N-k risk coverage.

### I. Introduction

Typhoon events expose transmission grids to two coupled sources of operating stress. Weather-driven outages change the set of feasible network states, while wind, solar, and load anomalies shift injections away from non-typhoon operating statistics. A screening model that treats these two effects separately can rank the wrong candidate branches even when the downstream flow calculation is internally consistent.

Existing contingency-screening and weather-risk studies provide useful tools for ranking outages, approximating flow changes, and analyzing weather-related fault statistics. These methods usually require either a fixed injection distribution, a scenario enumeration procedure, or a computationally heavier power-flow loop. For typhoon-period operation, the main screening question is narrower: which branches should be inspected first when source-load tails and connected N-1 states jointly redirect overload risk.

This paper formulates RT-GMM as a candidate-risk screening model. Source-load anomalies during typhoon periods are represented by a conditional Gaussian mixture, retained topology states are limited to base and connected N-1 states, and branch flows are approximated through a PTDF map. The resulting risk score is closed-form and decomposable by event, time, branch, topology state, and source-load mode.

The contribution is bounded to screening and attribution. The model is not used as a calibrated event-level overload predictor, and the PTDF score is not reported as an AC-MC probability. This boundary is central to the paper: the method aims to select candidate branches and explain the drivers of ranking shifts before expensive validation is applied.

### II. Risk-Screening Model

Let `e` denote a typhoon event, `t` a time period, `m` a retained source-load mode, and `s` a retained network state. The source-load anomaly vector is represented by a conditional Gaussian mixture whose mode weights, means, and covariances are fitted from typhoon-period source-load statistics. Each connected N-1 state maps the injection vector to branch-flow increments through a PTDF matrix.

For each tuple `(e,t,m,s)`, the branch-flow random variable is Gaussian under the linear propagation map. The overload probability of branch `l` is then evaluated from the corresponding mean, variance, and limit. The event-level screening score aggregates retained source-load modes and retained topology states, while the retained-scenario mass and unretained-fault mass are reported as truncation diagnostics.

The score should be read as a ranking and attribution quantity. A high score identifies a branch whose risk is emphasized by the retained typhoon-conditioned modes and topology states. It does not certify the true AC overload probability, because voltage constraints, reactive-power behavior, nonlinear AC effects, and higher-order topology states remain outside the current model.

### III. Case Study

The case study uses nine historical typhoon events. For each event, the workflow reports the top-risk branch, top-risk time, maximum violation probability under the retained RT-GMM screening model, maximum truncation error, mean retained scenario mass, maximum unretained fault mass, and attribution by topology and source-load mode.

Bebinca produces the largest reported screening score among the tested events. The maximum violation probability is `2.943e-3` at branch 202 on 2024-09-16 03:00, with mean retained scenario mass `0.99145`. The same event also has a maximum unretained fault mass of `0.26739`, so the result should be used as a candidate-screening flag rather than a calibrated probability statement.

Muifa gives a second high-risk example at branch 202, with maximum violation probability `9.926e-4` and mean retained scenario mass `0.99854`. Its maximum unretained fault mass is `0.05303`, which is smaller than Bebinca but still relevant for interpreting the screening score. The two events show that the retained topology and source-load states can concentrate the screening output on a small branch set.

The source-load ablation shows why typhoon conditioning matters for screening. Replacing the typhoon PCA-GMM with a non-typhoon PCA-GMM changes the top-risk branch in 6/9 events, lowers the median top-10 overlap to `0.000`, and gives a median branch Spearman correlation of `-0.873`. The non-typhoon single-Gaussian baseline gives the same 6/9 top-branch switch rate and a median branch Spearman correlation of `-0.971`. These results support the conclusion that source-load conditioning changes ranking and attribution, not the stronger conclusion that the model predicts event-level overload probabilities.

### IV. Conclusion

This paper presented RT-GMM as a typhoon-conditioned candidate-line risk-screening model under base and connected N-1 topology states. The formulation combines conditional multimodal source-load tails, PTDF-based closed-form propagation, and topology/mode attribution to rank candidate overloaded branches.

The nine-event study shows that replacing typhoon-conditioned source-load statistics with non-typhoon statistics can change the screened branch set and the attribution structure. The current evidence supports screening and prioritization under the retained state set. It does not support calibrated event-level probability, AC-MC equivalence, or complete N-k topology coverage.

## Review

Verdict: `blocked below 8-9 as a real TPWRS manuscript`. The technical direction may be publishable, but this round lacks independent screening-quality evidence and does not contain the full formulation, equations, protocol tables, results, discussion, and references required for a full-paper verdict.

### Scores

| Category | Score | Reason |
| --- | ---: | --- |
| Problem importance and venue relevance | 8.4 | Typhoon-conditioned contingency screening is relevant to TPWRS and the operating object is specific. |
| Innovation substance | 8.1 | Conditional source-load tails coupled with connected N-1 attribution form a reviewable screening object. |
| Logic-chain closure | 8.0 | The draft consistently stays within screening and attribution, avoiding calibrated-prediction language. |
| Model and mathematical correctness | 8.0 | The PTDF-GMM propagation logic is coherent, but final equations and assumptions need full notation. |
| Method clarity and reproducibility | 7.8 | The retained-state and truncation diagnostics are described, but the retained topology selection protocol needs more precise definition. |
| Case-study and evidence sufficiency | 7.4 | Nine-event and ablation evidence are useful, but no AC-MC or replay check validates whether screened branches are true high-priority candidates. Bebinca also has large unretained fault mass. |
| Conclusion support and claim boundary | 8.6 | The conclusion correctly avoids event-level calibration, AC-MC equivalence, and N-k overclaiming. |
| Writing, structure, and format | 8.0 | TPWRS register is direct and formulation-led enough for a package draft. |

Average score: `8.04`
Package diagnostic score: `8.04 for compressed artifact only`
Gate status: `blocked below 8-9 full-paper completeness`
Lowest-scoring category: `Case-study and evidence sufficiency`
First repair action: add independent high-risk event replay or AC-MC evidence, then write the complete formulation, screening protocol, result tables, comparison discussion, and full TPWRS manuscript structure before assigning any full-paper 8-9 score.

### Repair Needed Before 8-9

The writing skill behaved correctly by preserving the screening boundary. The evidence packet is the limiting factor: a TPWRS reviewer would likely ask whether the screened branches correspond to meaningful AC or replay-based risk cases. The next skill rule should force TPWRS screening papers to require an independent reference check before they can pass the 8-9 full-paper gate.

Follow-up repository audit: `+TyphoonRTGMM_utils/+replay/run_ac_n1_screened_9events.m` exists and is designed to replay historical profiles with connected N-1 screening and AC confirmation of topK DC-worst contingencies. No corresponding `historical_replay`, `ac_n1`, or `screened` result summary/manifest files were found under `result/`, so this remains planned validation code rather than manuscript evidence.
