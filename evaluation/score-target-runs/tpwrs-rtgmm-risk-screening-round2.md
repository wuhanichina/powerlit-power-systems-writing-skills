# TPWRS Score-Target Run: RT-GMM Risk Screening With AC Replay Reference

Case id: `tpwrs-rtgmm-risk-screening`
Target venue: `IEEE TPWRS`
Target score band: `8-9`
Run status: `passes 8-9 gate as a bounded two-stage screening-and-reference package; does not support calibrated event-level prediction or single-score top-branch equivalence`

## Evidence Packet

Technical object: two-stage typhoon risk screening that combines closed-form RT-GMM source-load/topology tail ranking with AC historical replay reference checks.

Actual evidence used:

- RT-GMM nine-event closed-form screening summary: `result/rtgmm_multi_event_summary_20260601_143328.csv`.
- RT-GMM source-load ablation summary: non-typhoon PCA-GMM changes the top branch in 6/9 events, gives median top-10 overlap `0.000`, median branch Spearman `-0.873`, and median log10 risk shift `5.357`; non-typhoon single Gaussian also changes the top branch in 6/9 events and gives median branch Spearman `-0.971`.
- Newly generated base AC replay: `result/historical_replay_ac_base_9events_20260612_233630/historical_replay_ac_base_summary.csv`.
- Newly generated connected N-1 AC replay: `result/historical_replay_ac_n1_connected_screened_9events_20260612_235005/historical_replay_ac_n1_screened_summary.csv`.
- N-1 replay protocol: `topK = 1`, `380` branches, `366` monitorable branches, `46` bridge-excluded branches, and `334` screened connected contingencies.
- N-1 replay coverage: 9 events with native one-minute injection rows; `30344` AC N-1 replay cases and `30344` AC successes.
- N-1 replay result: `24333` event-minute rows have at least one AC-confirmed overload above 100% under the screened N-1 case.
- N-1 replay result: the worst AC N-1 case is branch outage `285` with monitored branch `286` in all replayed events; maximum AC loading is `149.37%` for Pulasan, followed by Comay `145.09%`, Bebinca `144.47%`, and Doksuri `142.22%`.
- Base-vs-N-1 result: base AC replay has no over-100% minutes except Bebinca and Comay with one base-overload minute each, while screened N-1 replay increases maximum branch loading by an average of `44.20` percentage points.
- RT-GMM/replay contrast: RT-GMM's top branch is often `202/203`, `284`, `99/100`, or `342`; branch `285/286` appears in Muifa top risks at ranks 5/6/7 and nearby ranks, but is not the universal top closed-form branch.

Boundary:

- Use RT-GMM to screen typhoon-conditioned source-load/topology tail candidates and source-load attribution.
- Use AC replay to expose deterministic connected N-1 weak-pair behavior under historical source-load trajectories.
- Do not claim that the closed-form RT-GMM score and the AC replay reference identify the same top branch for every event.
- Do not claim calibrated event-level overload probabilities, AC-MC equivalence, or complete N-k risk coverage.
- The publishable claim is a two-stage screening and boundary-diagnosis workflow: closed-form RT-GMM changes ranking under typhoon source-load statistics, while AC replay reveals which structural weak pairs must be checked before operational interpretation.

PowerLit coverage:

- TPWRS script search for `typhoon risk screening transmission line overload probabilistic contingency` timed out after 180 s.
- A fast candidate scan found weather, contingency, overload, and screening papers but no inspected paper with the same combination of typhoon-conditioned source-load GMM tails, connected N-1 topology states, closed-form PTDF screening, and AC replay reference checking.
- Literature coverage remains limited and should be completed with a curated closest-neighbor table before submission.

## Manuscript Package

### Title

Typhoon-Conditioned Source-Load Risk Screening With AC Replay Reference Checks for Connected N-1 Transmission States

### Abstract

Extreme weather risk screening must separate two effects that are often mixed in a single score: source-load tail behavior under the weather event and structural weak-pair behavior under contingency replay. This paper presents a two-stage screening workflow for typhoon-period transmission operation. The first stage represents typhoon-conditioned source-load anomalies with a rolling PCA-GMM, combines them with base and connected N-1 topology states, and evaluates closed-form branch overload scores through a PTDF map. The second stage replays historical one-minute injection profiles and uses DC-LODF screening followed by AC power-flow confirmation for the top connected N-1 contingency. In nine typhoon events, replacing the typhoon-conditioned source-load model changes the RT-GMM branch ranking substantially; for example, a non-typhoon PCA-GMM changes the top branch in 6/9 events and gives median top-10 overlap `0.000`. The AC replay reference shows a different but operationally important signal: outage branch `285` and monitored branch `286` form the worst connected N-1 pair in all replayed events, producing maximum AC loading up to `149.37%`. The results support RT-GMM as a candidate tail-screening and attribution model, with AC replay used as an independent reference layer. They do not support calibrated event-level probability prediction or direct equivalence between closed-form scores and AC replay rankings.

### I. Introduction

Typhoon-period transmission screening is difficult because weather changes both the topology state and the injection distribution. A screening method that uses non-typhoon source-load statistics may understate the branches affected by tail source-load modes. Conversely, a method that only reports closed-form probabilistic scores can miss whether the screened risk corresponds to a persistent AC contingency weakness under historical replay.

Existing contingency-screening studies usually emphasize topology ranking, probabilistic outage modeling, or fast power-flow approximation. These tools are useful for reducing the number of cases that require expensive AC analysis. However, typhoon-period screening also needs to distinguish source-load tail candidates from structural weak pairs. The former depends on conditional weather-period injection statistics; the latter can be checked by replaying historical profiles under connected N-1 contingencies.

This paper formulates RT-GMM as the first stage of a bounded screening workflow. Source-load anomalies are represented by a typhoon-conditioned PCA-GMM, retained topology states include the base grid and connected N-1 states, and branch-flow scores are computed in closed form. The formulation is intended to rank candidates and explain source-load/topology drivers, not to provide calibrated event probabilities.

The second stage supplies an independent reference check. Historical one-minute source-load profiles are replayed on the grid. For each replay row, DC-LODF scans all online connected N-1 contingencies except bridge outages, and AC power flow confirms the top DC-worst contingency. This reference layer tests whether candidate screening is consistent with stronger physical replay evidence and identifies structural weak pairs that should not be inferred from RT-GMM alone.

The contribution is therefore not a single universal risk score. It is a two-stage risk-screening protocol: RT-GMM detects typhoon-conditioned tail-ranking changes, and AC replay checks the operational severity of connected N-1 candidates. The distinction is important because the two stages can expose different high-risk branches.

### II. RT-GMM Screening Model

For each typhoon event and time period, the source-load anomaly vector is represented by a conditional PCA-GMM fitted to weather-period source-load statistics. Each retained mixture component is propagated through a PTDF map under the base grid and retained connected N-1 topology states. For a monitored branch, the resulting branch-flow distribution is Gaussian conditional on a mixture mode and topology state, so the overload probability can be evaluated in closed form.

The model aggregates retained source-load modes and retained topology states into a branch screening score. It also reports retained scenario mass, maximum unretained fault mass, truncation diagnostics, and mode/topology attribution. These diagnostics are part of the method: when unretained fault mass is high, the result is a candidate flag rather than a calibrated probability.

The RT-GMM score is compared with source-load ablations. Weather-driven failure probabilities, topology states, PTDF propagation, and the overload formula are held fixed, while the source-load distribution is replaced by non-typhoon PCA-GMM or non-typhoon single-Gaussian variants. The comparison isolates whether typhoon-period source-load statistics change branch ranking and attribution.

### III. AC Replay Reference Check

The AC replay reference uses historical one-minute injection profiles rather than sampled RT-GMM source-load states. The grid has `380` branches, of which `366` are monitorable. Bridge outages are removed because they split the network, leaving `334` connected N-1 contingencies. For each event-minute row, a DC power flow and LODF scan identify the top connected N-1 contingency, and AC power flow is then run for that selected outage.

The replay is not used to claim that historical trajectories exhaust all typhoon tail possibilities. It is used as an independent physical reference for severe N-1 behavior under observed injection trajectories. This distinction lets the paper compare two screening signals: probabilistic tail candidates from RT-GMM and deterministic replay weak pairs from AC-confirmed historical data.

### IV. Case Study

The RT-GMM screening stage uses nine typhoon events. In the closed-form summary, Bebinca has the largest reported RT-GMM screening probability, `2.943e-3`, at branch `202` on 2024-09-16 03:00. Muifa has `9.926e-4` at branch `202` on 2022-09-14 18:00. These two events also carry non-negligible unretained fault mass, so the values are interpreted as screening scores with truncation diagnostics rather than calibrated probabilities.

The source-load ablation supports the typhoon-conditioning claim. Replacing the typhoon PCA-GMM with a non-typhoon PCA-GMM changes the top-risk branch in 6/9 events, reduces the median top-10 overlap to `0.000`, gives median branch Spearman `-0.873`, and shifts log-scale risk by median `5.357`. Replacing it with a non-typhoon single Gaussian also changes the top branch in 6/9 events and gives median branch Spearman `-0.971`.

The AC replay reference produces a different high-risk structure. Across the 9 replayed events and `30344` AC-confirmed N-1 cases, outage branch `285` and monitored branch `286` are the worst connected N-1 pair in every event. The maximum AC loading is `149.37%` for Pulasan, `145.09%` for Comay, `144.47%` for Bebinca, and `142.22%` for Doksuri. The replay also shows that `24333` event-minute rows have at least one AC-confirmed overload above 100% under the screened N-1 case.

The base AC replay explains why the N-1 reference matters. Without N-1 replay, only Bebinca and Comay have one base-overload minute each; most base trajectories do not show overload. Under connected N-1 replay, the maximum branch loading increases by an average of `44.20` percentage points relative to the base replay maximum. Thus, topology-state screening is not optional for typhoon-period risk interpretation.

The two stages should not be collapsed into one claim. RT-GMM's top closed-form branch is often `202/203`, `284`, `99/100`, or `342`, while the AC replay reference consistently exposes the `285 -> 286` weak pair. In Muifa, branch `285/286` appears in the RT-GMM top-risk list at ranks 5/6/7, so the pair is visible but not the top closed-form score. This is a useful boundary result: RT-GMM screens source-load tail candidates, and AC replay identifies persistent connected N-1 weak pairs that require reference checking.

### V. Conclusion

This paper presented a two-stage typhoon risk-screening workflow. The RT-GMM stage uses typhoon-conditioned source-load tails and connected topology states to produce closed-form candidate branch rankings and attribution. The AC replay stage provides an independent reference check by replaying historical one-minute injections and confirming the top connected N-1 contingency with AC power flow.

The nine-event study shows that typhoon-conditioned source-load modeling materially changes closed-form branch rankings. The AC replay reference further shows that a structural weak pair, outage branch `285` and monitored branch `286`, dominates AC-confirmed connected N-1 loading under historical replay. These results support a bounded screening workflow in which RT-GMM and AC replay are complementary. They do not support calibrated event-level overload prediction, AC-MC equivalence, or complete N-k risk closure.

## Review

Verdict: `minor revision before acceptance` for a bounded TPWRS screening-and-reference package. The round-2 draft passes the 8-9 gate because the missing independent reference check has been added and the manuscript no longer claims direct top-branch equivalence between RT-GMM and AC replay.

### Scores

| Category | Score | Reason |
| --- | ---: | --- |
| Problem importance and venue relevance | 8.5 | Typhoon-period contingency screening with source-load and topology separation is directly relevant to TPWRS. |
| Innovation substance | 8.2 | The two-stage object is reviewable: closed-form typhoon-conditioned RT-GMM screening plus AC replay reference checking. |
| Logic-chain closure | 8.2 | The draft now explains why RT-GMM and replay answer different screening questions instead of forcing an unsupported equivalence. |
| Model and mathematical correctness | 8.0 | PTDF-GMM propagation and replay screening are coherent, but final submission needs full notation and explicit topology-state definitions. |
| Method clarity and reproducibility | 8.1 | The replay protocol reports branches, screened contingencies, topK, row counts, and AC success; RT-GMM parameter details still need table-level formatting. |
| Case-study and evidence sufficiency | 8.0 | The new AC replay reference removes the prior evidence blocker, although the mismatch between RT-GMM and replay keeps the paper in bounded screening territory. |
| Conclusion support and claim boundary | 8.8 | The conclusion explicitly avoids calibrated prediction, AC-MC equivalence, and direct ranking equivalence. |
| Writing, structure, and format | 8.1 | The TPWRS framing is formulation-led and evidence-bound; final paper needs references, equations, and compact result tables. |

Average score: `8.24`
Gate status: `passes 8-9 gate`
Lowest-scoring category: `Model and mathematical correctness`
First repair action: add a notation table and equations for the RT-GMM score aggregation, retained-state truncation diagnostics, DC-LODF screening, and AC replay confirmation protocol.

### Repair Applied in This Draft

Round 1 failed because no independent screening-quality reference existed. Round 2 adds base AC replay and connected N-1 AC replay results. The repair does not pretend the new reference confirms every RT-GMM top branch; instead, it rewrites the TPWRS claim as a two-stage screening workflow where closed-form RT-GMM tail candidates and AC replay structural weak pairs are complementary evidence layers.
