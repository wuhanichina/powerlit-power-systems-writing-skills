# IEEE TSG Score-Target Run: BayesAQPPF Edge Update

Case id: `tsg-bayesaqppf-edge-update`
Target venue: `IEEE TSG`
Target score band: `8-9`
Run status: `blocked below 8-9 full-paper completeness; compact edge-update package only`
Full-paper readiness: `compressed evaluation package only; missing full Dirichlet-NIW equations, update algorithm, complete case tables, comparison discussion, references, and IEEE template`

## Evidence Packet

Technical object: edge-side Bayesian Dirichlet-NIW update for three-phase AQPPF voltage-distribution and risk updates.

Actual evidence used:

- IEEE 13 small-sample posterior-only update with `N_new = 12, 24, 48, 96, 168`.
- IEEE 13: Bayes Edge Update gives mean voltage KS `0.16226`, compared with Small-sample PALI Refit `0.1881` and Static PALI `0.2154`.
- IEEE 13: risk-ranking topK overlap is `0.85455` across all tested `N_new`, and rank correlation remains above `0.95679`.
- IEEE 13: mean update time is about `0.017-0.021 s`; posterior state size is `2.8848e5` doubles.
- IEEE 123 scaling: Bayes Edge Update gives mean voltage KS `0.13588`, compared with Small-sample PALI Refit `0.23151` and Static PALI `0.14259`.
- IEEE 123 scaling: mean update time is `0.98317 s`; `610.A/B/C` are excluded consistently by the voltage-scope check.
- IEEE 123 full-refit diagnostic folder: Bayes Edge Update has mean voltage KS `0.14407`, Small-sample PALI Refit has `0.18079`, Static PALI has `0.16935`, and the refit requires mean fitting time `388.72 s`.
- Project claim boundary: do not claim global dominance over full refit. The full-refit path is diagnostic boundary evidence, not a license to write a universal superiority claim.

Boundary:

- Use the evidence for small-sample edge updating of voltage distributions and risk rankings.
- Limit strong risk-ranking claims to IEEE 13, where the topK and rank-correlation evidence is strong.
- Treat IEEE 123 as scaling, voltage-distribution, runtime, and scope-check evidence; do not imply that IEEE 123 risk ranking is equally strong without a stronger risk table.
- Do not hide the `610.A/B/C` voltage-scope exclusion.
- Do not claim privacy, communication robustness, field deployment, or global full-refit dominance.

PowerLit coverage:

- TSG folder search was run with query `edge Bayesian update probabilistic power flow distribution feeder`.
- Search returned 4634 records. Top adjacent results included Bayesian inference/information methods, Bayesian online learning for stochastic distribution hardening, distribution-feeder learning/restoration, feeder-demand separation, and feeder outage control.
- The retrieved set was style- and topic-near for Bayesian/data-driven distribution-system papers, but no inspected top hit matched the same combination of three-phase AQPPF voltage-distribution state, Dirichlet-NIW posterior update, edge-side small-sample adaptation, risk-ranking preservation, and IEEE 13/123 scope diagnostics.

## Manuscript Package

### Title

Edge-Side Bayesian Updating of Three-Phase Probabilistic Power-Flow Distributions Under Small New-Sample Batches

### Abstract

Active distribution feeders increasingly require probabilistic voltage and risk information to be refreshed from small batches of newly observed edge data. Re-fitting a full probabilistic power-flow model after each local data update can be computationally expensive and unstable when the new sample size is small. This paper develops an edge-side Bayesian updating method for three-phase analytical probabilistic power flow. The method treats the non-source phase-node injection-current Gaussian mixture as the update state and applies a Dirichlet-normal-inverse-Wishart posterior update to component weights, means, and covariances. The posterior state is then propagated through the existing three-phase AQPPF voltage mapping, so the edge device updates distributional voltage and risk quantities without re-running a full mixture refit from raw historical samples. Tests on IEEE 13-node and IEEE 123-node feeders show that the proposed update improves small-sample voltage-distribution accuracy relative to static PALI and small-sample refit baselines. On IEEE 13, the mean voltage KS distance is reduced to `0.16226`, and the risk ranking keeps topK overlap `0.85455` with rank correlation above `0.95679`. On IEEE 123, the method maintains mean voltage KS `0.13588` with mean update time `0.98317 s` under a declared voltage-scope exclusion. The results support an edge-updating claim for voltage distributions and bounded risk ranking, not a global dominance claim over every full-refit protocol.

### I. Introduction

Distribution-system operation is moving toward faster local monitoring, higher DER variability, and more frequent changes in feeder operating statistics. In this setting, a probabilistic power-flow model is useful only if its voltage distributions and risk indicators can be refreshed when new measurements arrive. A centralized re-fit of the full source-load mixture after each edge data batch is often disproportionate to the amount of new information, especially when the new sample set contains only tens of observations.

Existing probabilistic power-flow methods usually emphasize offline distribution fitting, analytical propagation, or Monte Carlo replacement. These methods can produce useful voltage-distribution estimates, but they do not directly answer an edge-update question: if an existing three-phase probabilistic model is already available, how should a local device update the distributional state after receiving a small new batch, and how much of the voltage/risk information is preserved without re-fitting the entire model?

This paper formulates the update object as the injection-current Gaussian-mixture state used by three-phase AQPPF. Instead of treating new samples as a trigger for complete model reconstruction, the proposed method performs a conjugate Bayesian update on the mixture weights and component moments. The updated posterior is then passed to the voltage-distribution calculation. This design gives the edge device an updateable state, a fixed memory footprint, and a direct path from new samples to grid-side voltage and risk metrics.

The contribution is threefold. First, the paper identifies a Bayesian state for three-phase AQPPF edge updating: a non-source phase-node injection-current GMM with Dirichlet-NIW component statistics. Second, it develops a posterior-only update workflow that separates new-sample assimilation from full PALI refitting. Third, it evaluates voltage-distribution, risk-ranking, runtime, and voltage-scope behavior on IEEE 13 and IEEE 123 feeders. The claim is deliberately bounded: the method targets small-batch edge adaptation and does not assert uniform dominance over every full-refit baseline.

### II. Edge-Side Bayesian AQPPF Update

Let the edge device store a Gaussian mixture over non-source phase-node injection-current variables. Each component has a weight, mean vector, and covariance matrix. The prior state is represented by Dirichlet parameters for mixture weights and normal-inverse-Wishart parameters for component means and covariances. A new local sample batch is assigned to mixture components under the current model, and the sufficient statistics of the assigned samples update the posterior component counts, means, scatter matrices, and covariance degrees of freedom.

The posterior state is then used by the three-phase AQPPF voltage mapping. This is the key distinction from a small-sample refit: the edge update changes the posterior parameters of the stored mixture state, while the voltage propagation and risk extraction remain tied to the same grid model and phase-node scope. The method therefore avoids rebuilding the full mixture from a small raw batch, which can reduce mixture order or create unstable covariance estimates.

The output metrics are grid-side quantities. Voltage-distribution quality is measured by KS distance and Wasserstein-1 distance against the reference voltage samples. Risk behavior is measured by under-voltage and over-voltage absolute errors, topK overlap, and rank correlation of risk rankings. Runtime and state size are reported to show whether the update is compatible with an edge-side workflow. Scope exclusions are reported explicitly; in the IEEE 123 test, phase nodes `610.A/B/C` are excluded from paper-facing voltage means by the registered scope check.

### III. Case Study Design

The IEEE 13-node feeder is used as the main small-sample risk-preservation test. The new sample sizes are `12, 24, 48, 96, 168`. Bayes Edge Update is compared with a Small-sample PALI Refit and a Static PALI baseline under the same small-sample protocol. The primary evidence is whether the posterior-only update can improve voltage-distribution distance and preserve risk ranking when the new batch is too small for reliable full reconstruction.

The IEEE 123-node feeder is used as a scaling and voltage-scope test. The main scaling protocol uses `N_new = 12, 48, 168` and months `2, 6, 12`; an additional spot-check includes the small-sample refit path. The voltage-scope table records whether excluded `610.A/B/C` rows are handled consistently. This case is not used to claim uniformly strong risk-ranking preservation, because the available IEEE 123 risk-ranking evidence is weaker than the IEEE 13 evidence.

### IV. Results and Discussion

On IEEE 13, Bayes Edge Update improves the mean voltage KS distance to `0.16226`, compared with `0.1881` for Small-sample PALI Refit and `0.2154` for Static PALI. The W1 distance remains comparable across methods: Bayes has `0.004981`, refit has `0.0051643`, and Static PALI has `0.0049354`. The main gain is therefore not a blanket advantage on every distribution metric, but a more stable small-sample update in KS distance without reconstructing the full model.

The IEEE 13 risk-ranking results support the edge-update claim. For `N_new = 12, 24, 48, 96, 168`, the mean topK overlap remains `0.85455`, and the rank correlation remains above `0.95679`. These numbers show that the posterior update preserves the ordering of high-risk phase nodes well enough for screening and monitoring decisions in the tested feeder.

The IEEE 13 resource results show why the method is appropriate for an edge-side workflow. The mean update time is `0.0209 s` at `N_new = 12` and stays near `0.017-0.018 s` for larger new-sample batches. The stored posterior has `2.8848e5` double values, while the raw new-sample size grows from `7296` to `1.0214e5` doubles. The method therefore updates a fixed posterior state rather than retaining a growing raw-data history.

On IEEE 123, the mean voltage KS distance is `0.13588` for Bayes Edge Update, compared with `0.23151` for Small-sample PALI Refit and `0.14259` for Static PALI. The mean update time is `0.98317 s`. The voltage-scope check excludes `610.A/B/C` consistently for all method groups, with zero non-610 excluded rows. These results support voltage-distribution scaling and scope control on a larger unbalanced feeder.

The IEEE 123 evidence is intentionally interpreted more narrowly than the IEEE 13 evidence. The available risk-ranking summary shows topK overlap in the approximate range `0.54545-0.65455`, although rank correlations remain above `0.92618`. This is sufficient to report moderate ranking consistency, but not sufficient to claim the same risk-screening strength as IEEE 13. The paper therefore uses IEEE 123 mainly for voltage-distribution accuracy, runtime, and scope-check validation.

The full-refit diagnostic folder also supports bounded wording. In that run, Bayes Edge Update has mean voltage KS `0.14407`, Small-sample PALI Refit has `0.18079`, and Static PALI has `0.16935`, while refit requires mean fitting time `388.72 s`. These results favor the posterior-only workflow under the registered protocol, but they still do not establish global dominance over all possible full-refit designs, larger training sets, or different mixture-order choices.

### V. Conclusion

This paper presented an edge-side Bayesian update for three-phase AQPPF. By treating the non-source phase-node injection-current mixture as a Dirichlet-NIW posterior state, the method assimilates small new sample batches without re-fitting the full probabilistic model from raw historical data.

The IEEE 13 study shows improved voltage-distribution KS distance and strong risk-ranking preservation under small new-sample batches. The IEEE 123 study shows voltage-distribution scaling, sub-second mean update time, and explicit voltage-scope control under the registered exclusion of `610.A/B/C`. These results support the proposed method as a bounded edge-update mechanism for probabilistic voltage and risk monitoring. Future work should test communication constraints, real measurement streams, and stronger large-feeder risk-ranking protocols before making deployment-level claims.

## Review

Verdict: `not ready for minor-revision acceptance as a real TSG manuscript`. The artifact keeps the edge-update claim bounded, but it is still a compact package without the full posterior-update derivation, algorithm, complete result tables, comparison discussion, references, and final IEEE manuscript structure.

### Scores

| Category | Score | Reason |
| --- | ---: | --- |
| Problem importance and venue relevance | 8.5 | Edge updating for DER-rich distribution feeders is a concrete TSG problem, and the paper keeps the smart-grid layer operational. |
| Innovation substance | 8.3 | The updateable Dirichlet-NIW AQPPF state is a reviewable mechanism rather than generic learning packaging. |
| Logic-chain closure | 8.3 | Problem, Bayesian state, edge update, voltage/risk metrics, and bounded conclusion are aligned. |
| Model and mathematical correctness | 8.1 | The mixture-state and posterior-update logic are coherent, but final equations and assignment details must be formalized. |
| Method clarity and reproducibility | 8.1 | Protocols, sample sizes, baselines, metrics, update times, and scope exclusions are stated; implementation details need final algorithm formatting. |
| Case-study and evidence sufficiency | 8.0 | IEEE 13 supports voltage and risk claims, IEEE 123 supports voltage scaling and scope control; the risk claim is correctly narrowed where IEEE 123 topK overlap is moderate. |
| Conclusion support and claim boundary | 8.6 | The conclusion avoids global full-refit dominance, privacy, communication, and deployment claims. |
| Writing, structure, and format | 8.2 | The package follows TSG's data-driven grid-operation rhythm and avoids generic AI framing. |

Average score: `8.26`
Package diagnostic score: `8.26 for compressed artifact only`
Gate status: `blocked below 8-9 full-paper completeness`
Lowest-scoring category: `Case-study and evidence sufficiency`
First repair action: write the full Dirichlet-NIW posterior-update equations and algorithm, then add complete IEEE 13 and IEEE 123 case tables, risk-ranking versus voltage-scaling discussion, full-refit comparison, and references.

### Repair Applied in This Draft

The first score-target framing risk was overextending the IEEE 13 risk-ranking result to IEEE 123. The repaired draft separates IEEE 13 as the risk-preservation case and IEEE 123 as the larger-feeder voltage-scaling and voltage-scope case, while preserving the project boundary against global full-refit dominance claims.
