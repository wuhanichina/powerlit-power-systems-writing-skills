# Web-Seeded Direction and Method Canon

Created: 2026-06-14

Purpose: seed a curated direction/method paper canon for PowerLit writing-skill calibration. This is not the final canon and not a replacement for full PowerLit novelty search. It is a web-seeded candidate list for later DOI verification, PowerLit path matching, and human curation.

Selection rule:

- Prefer papers that define a method family, benchmark evidence expectations, or represent a target-venue writing/evidence pattern.
- Keep source PowerLit read-only. Store the stable canon metadata in versioned files; cache copied JSON/PDF-derived records under `.cache` only.
- Treat every entry as `curation_status=pending` until it is checked against PowerLit and manually accepted or rejected.

## Proposed Metadata

Use this shape when converting to JSON:

```json
{
  "direction_id": "probabilistic-power-flow-uncertainty",
  "method_id": "point-estimate-ppf",
  "role": "method_exemplar",
  "title": "Point Estimate Schemes to Solve the Probabilistic Power Flow",
  "year": 2007,
  "venue": "IEEE Transactions on Power Systems",
  "doi": "10.1109/TPWRS.2007.907515",
  "source_url": "https://doi.org/10.1109/TPWRS.2007.907515",
  "selection_reason": "Representative point-estimate probabilistic power-flow paper.",
  "powerlit_status": "pending",
  "curation_status": "pending"
}
```

## probabilistic-power-flow-uncertainty

### method: foundational-ppf

- B. Borkowska, "Probabilistic Load Flow", IEEE Transactions on Power Apparatus and Systems, 1974. DOI: `10.1109/TPAS.1974.293973`. Source: https://doi.org/10.1109/TPAS.1974.293973
  - Role: `foundation`.
  - Why: early formal probabilistic load-flow reference; useful for explaining why uncertainty propagation is a distinct paper object.

- R. N. Allan, A. M. Leite da Silva, and R. C. Burchett, "Evaluation Methods and Accuracy in Probabilistic Load Flow Solutions", IEEE Transactions on Power Apparatus and Systems, 1981. DOI: `10.1109/TPAS.1981.316721`. Source: https://doi.org/10.1109/TPAS.1981.316721
  - Role: `evidence_bar_exemplar`.
  - Why: calibrates accuracy/computation tradeoffs and comparison protocol.

### method: point-estimate-and-cumulant-ppf

- J. M. Morales and J. Perez-Ruiz, "Point Estimate Schemes to Solve the Probabilistic Power Flow", IEEE Transactions on Power Systems, 2007. DOI: `10.1109/TPWRS.2007.907515`. Source: https://doi.org/10.1109/TPWRS.2007.907515
  - Role: `method_exemplar`.
  - Why: canonical point-estimate PPF representative.

- M. Fan, V. Vittal, G. T. Heydt, and R. Ayyanar, "Probabilistic Power Flow Studies for Transmission Systems With Photovoltaic Generation Using Cumulants", IEEE Transactions on Power Systems, 2012. DOI: `10.1109/TPWRS.2012.2190533`. Source: https://doi.org/10.1109/TPWRS.2012.2190533
  - Role: `method_exemplar`.
  - Why: cumulant/Gram-Charlier style PPF with renewable uncertainty and manuscript-facing comparison details.

### method: gaussian-mixture-and-nongaussian-ppf

- G. Valverde, A. T. Saric, and V. Terzija, "Probabilistic Load Flow With Non-Gaussian Correlated Random Variables Using Gaussian Mixture Models", IET Generation, Transmission and Distribution, 2012. DOI: `10.1049/iet-gtd.2011.0545`. Source: https://doi.org/10.1049/iet-gtd.2011.0545
  - Role: `method_exemplar`.
  - Why: strong anchor for GMM-based non-Gaussian/correlated PPF.

- C. Liu, K. Sun, B. Wang, and W. Ju, "Probabilistic Power Flow Analysis Using Multidimensional Holomorphic Embedding and Generalized Cumulants", IEEE Transactions on Power Systems, 2018. DOI: `10.1109/TPWRS.2018.2846203`. Source: https://doi.org/10.1109/TPWRS.2018.2846203
  - Role: `method_exemplar`.
  - Why: modern analytical PPF candidate for high-level method/rhythm calibration.

## risk-resilience-cost-allocation

### method: resilience-framework-and-extreme-weather

- M. Panteli and P. Mancarella, "The Grid: Stronger, Bigger, Smarter? Presenting a Conceptual Framework of Power System Resilience", IEEE Power and Energy Magazine, 2015. DOI: `10.1109/MPE.2015.2397334`. Source: https://doi.org/10.1109/MPE.2015.2397334
  - Role: `foundation`.
  - Why: conceptual vocabulary and resilience framing anchor.

- M. Panteli, C. Pickering, S. Wilkinson, R. Dawson, and P. Mancarella, "Power System Resilience to Extreme Weather: Fragility Modeling, Probabilistic Impact Assessment, and Adaptation Measures", IEEE Transactions on Power Systems, 2017. DOI: `10.1109/TPWRS.2016.2641463`. Source: https://doi.org/10.1109/TPWRS.2016.2641463
  - Role: `evidence_bar_exemplar`.
  - Why: fragility, probabilistic impact, and adaptation measures in a full TPWRS evidence chain.

### method: contingency-risk-screening

- S. Fliscounakis, P. Panciatici, F. Capitanescu, and L. Wehenkel, "Contingency Ranking With Respect to Overloads in Very Large Power Systems Taking Into Account Uncertainty, Preventive, and Corrective Actions", IEEE Transactions on Power Systems, 2013. DOI: `10.1109/TPWRS.2013.2251015`. Source: https://doi.org/10.1109/TPWRS.2013.2251015
  - Role: `method_exemplar`.
  - Why: overload-ranking and large-system screening anchor for risk-screening claims.

### method: risk-cost-allocation-and-lric

- I. J. Perez-Arriaga, F. J. Rubio-Oderiz, J. F. Puerta Gutierrez, J. Arceluz, and J. Marin, "Marginal Pricing of Transmission Services: An Analysis of Cost Recovery", IEEE Transactions on Power Systems, 1995. DOI: `10.1109/59.373981`. Source: https://doi.org/10.1109/59.373981
  - Role: `foundation`.
  - Why: cost recovery and marginal pricing boundary for network-cost claims.

- "Long-Run Marginal Cost Pricing Based on Analytical Method", IEEE Transactions on Power Systems, 2010/2011. DOI candidate: `10.1109/TPWRS.2010.2047278`. Source: https://doi.org/10.1109/TPWRS.2010.2047278
  - Role: `method_exemplar`.
  - Why: candidate anchor for LRIC-style distribution/transmission pricing; needs title/authorship verification.

## probabilistic-operation-optimization

### method: chance-constrained-opf-operation

- H. Zhang and P. Li, "Chance Constrained Programming for Optimal Power Flow Under Uncertainty", IEEE Transactions on Power Systems, 2011. DOI: `10.1109/TPWRS.2011.2154367`. Source: https://doi.org/10.1109/TPWRS.2011.2154367
  - Role: `method_exemplar`.
  - Why: early CC-OPF in TPWRS; useful for chance-constraint formulation structure.

- L. Roald, S. Misra, M. Chertkov, and G. Andersson, "Optimal Power Flow With Weighted Chance Constraints and General Policies for Generation Control", IEEE CDC, 2015. DOI: `10.1109/CDC.2015.7403311`. Source: https://doi.org/10.1109/CDC.2015.7403311
  - Role: `method_exemplar`.
  - Why: weighted chance constraints and policy discussion; good boundary exemplar.

### method: stochastic-and-robust-scuc

- L. Wu, M. Shahidehpour, and T. Li, "Stochastic Security-Constrained Unit Commitment", IEEE Transactions on Power Systems, 2007. DOI: `10.1109/TPWRS.2007.894843`. Source: https://doi.org/10.1109/TPWRS.2007.894843
  - Role: `method_exemplar`.
  - Why: stochastic SCUC anchor.

- Q. Wang, Y. Guan, and J. Wang, "A Chance-Constrained Two-Stage Stochastic Program for Unit Commitment With Uncertain Wind Power Output", IEEE Transactions on Power Systems, 2012. DOI: `10.1109/TPWRS.2011.2159522`. Source: https://doi.org/10.1109/TPWRS.2011.2159522
  - Role: `method_exemplar`.
  - Why: wind-uncertainty UC formulation and evidence pattern.

- D. Bertsimas, E. Litvinov, X. A. Sun, J. Zhao, and T. Zheng, "Adaptive Robust Optimization for the Security Constrained Unit Commitment Problem", IEEE Transactions on Power Systems, 2013. DOI: `10.1109/TPWRS.2012.2205021`. Source: https://doi.org/10.1109/TPWRS.2012.2205021
  - Role: `method_exemplar`.
  - Why: robust SCUC benchmark for uncertainty and conservatism claims.

## distribution-topology-parameter-identification

### method: voltage-correlation-and-smart-meter-topology

- S. Bolognani, N. Bof, D. Michelotti, R. Muraro, and L. Schenato, "Identification of Power Distribution Network Topology via Voltage Correlation Analysis", IEEE CDC, 2013. DOI: `10.1109/CDC.2013.6760120`. Source: https://doi.org/10.1109/CDC.2013.6760120
  - Role: `foundation`.
  - Why: voltage-correlation topology-identification anchor.

- V. Kekatos, G. B. Giannakis, and R. Baldick, "Topology Identification of Radial Distribution Networks Using Smart Meter Data", IEEE Transactions on Smart Grid, 2016. DOI: `10.1109/TSG.2015.2469098`. Source: https://doi.org/10.1109/TSG.2015.2469098
  - Role: `method_exemplar`.
  - Why: smart-meter topology identification with distribution-grid structure.

### method: graphical-model-and-parameter-estimation

- D. Deka, S. Backhaus, and M. Chertkov, "Structure Learning in Power Distribution Networks", IEEE Transactions on Control of Network Systems, 2017/2018. DOI: `10.1109/TCNS.2017.2673546`. Source: https://doi.org/10.1109/TCNS.2017.2673546
  - Role: `method_exemplar`.
  - Why: structure-learning benchmark for topology and statistical assumptions.

- M. Farajollahi, A. Shahsavari, and H. Mohsenian-Rad, "Topology Identification in Distribution Systems Using Line Current Sensors: An MILP Approach", IEEE Transactions on Smart Grid, 2020. DOI: `10.1109/TSG.2019.2933006`. Source: https://doi.org/10.1109/TSG.2019.2933006
  - Role: `method_exemplar`.
  - Why: MILP/sensor-based topology identification exemplar.

- J. Zhang, Y. Wang, and Y. Weng, "Topology Identification and Line Parameter Estimation for Non-PMU Distribution Network: A Numerical Method", IEEE Transactions on Smart Grid, 2020. DOI: `10.1109/TSG.2020.2979368`. Source: https://doi.org/10.1109/TSG.2020.2979368
  - Role: `method_exemplar`.
  - Why: joint topology and parameter estimation anchor.

## moment-sdp-certification

### method: polynomial-moment-and-sos

- J. B. Lasserre, "Global Optimization With Polynomials and the Problem of Moments", SIAM Journal on Optimization, 2001. DOI: `10.1137/S1052623400366802`. Source: https://doi.org/10.1137/S1052623400366802
  - Role: `foundation`.
  - Why: mathematical foundation for moment/SOS hierarchy.

### method: sdp-opf-and-moment-opf

- J. Lavaei and S. H. Low, "Zero Duality Gap in Optimal Power Flow Problem", IEEE Transactions on Power Systems, 2012. DOI: `10.1109/TPWRS.2011.2160974`. Source: https://doi.org/10.1109/TPWRS.2011.2160974
  - Role: `foundation`.
  - Why: SDP relaxation anchor for OPF convexification claims.

- M. Farivar and S. H. Low, "Branch Flow Model: Relaxations and Convexification-Part I", IEEE Transactions on Power Systems, 2013. DOI: `10.1109/TPWRS.2013.2255317`. Source: https://doi.org/10.1109/TPWRS.2013.2255317
  - Role: `method_exemplar`.
  - Why: branch-flow relaxation anchor, especially for radial/mesh distinction.

- M. Farivar and S. H. Low, "Branch Flow Model: Relaxations and Convexification-Part II", IEEE Transactions on Power Systems, 2013. DOI: `10.1109/TPWRS.2013.2255318`. Source: https://doi.org/10.1109/TPWRS.2013.2255318
  - Role: `method_exemplar`.
  - Why: convexification and phase-shifter extension.

- L. Gan, N. Li, U. Topcu, and S. H. Low, "Exact Convex Relaxation of Optimal Power Flow in Radial Networks", IEEE Transactions on Automatic Control, 2015. DOI: `10.1109/TAC.2014.2332712`. Source: https://doi.org/10.1109/TAC.2014.2332712
  - Role: `method_exemplar`.
  - Why: exactness conditions for radial OPF; strong proof-writing exemplar.

- D. K. Molzahn and I. A. Hiskens, "Moment-Based Relaxation of the Optimal Power Flow Problem", PSCC, 2014. Source: https://arxiv.org/abs/1312.1992
  - Role: `method_exemplar`.
  - Why: direct OPF moment hierarchy seed; needs final publisher metadata check.

## grid-planning

### method: transmission-expansion-planning

- L. L. Garver, "Transmission Network Estimation Using Linear Programming", IEEE Transactions on Power Apparatus and Systems, 1970. DOI: `10.1109/TPAS.1970.292825`. Source: https://doi.org/10.1109/TPAS.1970.292825
  - Role: `foundation`.
  - Why: classic transmission expansion planning formulation.

- G. Latorre, R. D. Cruz, J. M. Areiza, and A. Villegas, "Classification of Publications and Models on Transmission Expansion Planning", IEEE Transactions on Power Systems, 2003. DOI candidate: `10.1109/TPWRS.2003.811168`. Source: https://doi.org/10.1109/TPWRS.2003.811168
  - Role: `survey_exemplar`.
  - Why: model taxonomy anchor; verify DOI/title in next pass.

- R. Romero, A. Monticelli, A. Garcia, and S. Haffner, "Test Systems and Mathematical Models for Transmission Network Expansion Planning", IEE Proceedings - Generation, Transmission and Distribution, 2002. DOI: `10.1049/ip-gtd:20020026`. Source: https://doi.org/10.1049/ip-gtd:20020026
  - Role: `benchmark_exemplar`.
  - Why: standard TEP test systems/modeling benchmark.

- R. A. Jabr, "Robust Transmission Network Expansion Planning With Uncertain Renewable Generation and Loads", IEEE Transactions on Power Systems, 2013. DOI: `10.1109/TPWRS.2013.2267058`. Source: https://doi.org/10.1109/TPWRS.2013.2267058
  - Role: `method_exemplar`.
  - Why: robust planning under renewable/load uncertainty.

## grid-dispatch-operation

### method: opf-and-dispatch-foundations

- H. W. Dommel and W. F. Tinney, "Optimal Power Flow Solutions", IEEE Transactions on Power Apparatus and Systems, 1968. DOI: `10.1109/TPAS.1968.292150`. Source: https://doi.org/10.1109/TPAS.1968.292150
  - Role: `foundation`.
  - Why: canonical OPF foundation.

- R. D. Zimmerman, C. E. Murillo-Sanchez, and R. J. Thomas, "MATPOWER: Steady-State Operations, Planning, and Analysis Tools for Power Systems Research and Education", IEEE Transactions on Power Systems, 2011. DOI: `10.1109/TPWRS.2010.2051168`. Source: https://doi.org/10.1109/TPWRS.2010.2051168
  - Role: `benchmark_exemplar`.
  - Why: standard reproducible OPF/power-flow tool and reporting reference.

### method: distribution-operation-and-reconfiguration

- M. E. Baran and F. F. Wu, "Network Reconfiguration in Distribution Systems for Loss Reduction and Load Balancing", IEEE Transactions on Power Delivery, 1989. DOI: `10.1109/61.25627`. Source: https://doi.org/10.1109/61.25627
  - Role: `foundation`.
  - Why: distribution reconfiguration, loss reduction, and load-balancing anchor.

- M. Farivar and S. H. Low, "Branch Flow Model: Relaxations and Convexification-Part I", IEEE Transactions on Power Systems, 2013. DOI: `10.1109/TPWRS.2013.2255317`. Source: https://doi.org/10.1109/TPWRS.2013.2255317
  - Role: `method_exemplar`.
  - Why: branch-flow convex OPF for distribution/radial operation.

## unit-commitment

### method: deterministic-milp-uc

- M. Carrion and J. M. Arroyo, "A Computationally Efficient Mixed-Integer Linear Formulation for the Thermal Unit Commitment Problem", IEEE Transactions on Power Systems, 2006. DOI: `10.1109/TPWRS.2006.876672`. Source: https://doi.org/10.1109/TPWRS.2006.876672
  - Role: `method_exemplar`.
  - Why: standard compact MILP UC formulation.

- G. Morales-Espana, J. M. Latorre, and A. Ramos, "Tight and Compact MILP Formulation of Start-Up and Shut-Down Ramping in Unit Commitment", IEEE Transactions on Power Systems, 2013. DOI: `10.1109/TPWRS.2012.2222938`. Source: https://doi.org/10.1109/TPWRS.2012.2222938
  - Role: `method_exemplar`.
  - Why: ramping/startup/shutdown formulation anchor.

- G. Morales-Espana, J. M. Latorre, and A. Ramos, "Tight and Compact MILP Formulation for the Thermal Unit Commitment Problem", IEEE Transactions on Power Systems, 2013. DOI: `10.1109/TPWRS.2013.2251373`. Source: https://doi.org/10.1109/TPWRS.2013.2251373
  - Role: `method_exemplar`.
  - Why: compact thermal UC formulation benchmark.

### method: uncertainty-aware-uc

- L. Wu, M. Shahidehpour, and T. Li, "Stochastic Security-Constrained Unit Commitment", IEEE Transactions on Power Systems, 2007. DOI: `10.1109/TPWRS.2007.894843`. Source: https://doi.org/10.1109/TPWRS.2007.894843
  - Role: `method_exemplar`.
  - Why: stochastic SCUC anchor.

- D. Bertsimas, E. Litvinov, X. A. Sun, J. Zhao, and T. Zheng, "Adaptive Robust Optimization for the Security Constrained Unit Commitment Problem", IEEE Transactions on Power Systems, 2013. DOI: `10.1109/TPWRS.2012.2205021`. Source: https://doi.org/10.1109/TPWRS.2012.2205021
  - Role: `method_exemplar`.
  - Why: robust SCUC benchmark.

## optimal-dispatch

### method: ac-opf-and-tooling

- H. W. Dommel and W. F. Tinney, "Optimal Power Flow Solutions", IEEE Transactions on Power Apparatus and Systems, 1968. DOI: `10.1109/TPAS.1968.292150`. Source: https://doi.org/10.1109/TPAS.1968.292150
  - Role: `foundation`.
  - Why: OPF formulation anchor.

- R. D. Zimmerman, C. E. Murillo-Sanchez, and R. J. Thomas, "MATPOWER: Steady-State Operations, Planning, and Analysis Tools for Power Systems Research and Education", IEEE Transactions on Power Systems, 2011. DOI: `10.1109/TPWRS.2010.2051168`. Source: https://doi.org/10.1109/TPWRS.2010.2051168
  - Role: `benchmark_exemplar`.
  - Why: standard reproducibility and benchmark tool.

### method: active-distribution-dispatch

- M. E. Baran and F. F. Wu, "Network Reconfiguration in Distribution Systems for Loss Reduction and Load Balancing", IEEE Transactions on Power Delivery, 1989. DOI: `10.1109/61.25627`. Source: https://doi.org/10.1109/61.25627
  - Role: `foundation`.
  - Why: distribution dispatch/reconfiguration baseline.

- L. Gan, N. Li, U. Topcu, and S. H. Low, "Exact Convex Relaxation of Optimal Power Flow in Radial Networks", IEEE Transactions on Automatic Control, 2015. DOI: `10.1109/TAC.2014.2332712`. Source: https://doi.org/10.1109/TAC.2014.2332712
  - Role: `method_exemplar`.
  - Why: radial-network OPF exactness benchmark.

## probabilistic-optimal-power-flow

### method: chance-constrained-opf

- H. Zhang and P. Li, "Chance Constrained Programming for Optimal Power Flow Under Uncertainty", IEEE Transactions on Power Systems, 2011. DOI: `10.1109/TPWRS.2011.2154367`. Source: https://doi.org/10.1109/TPWRS.2011.2154367
  - Role: `foundation`.
  - Why: early CC-OPF formulation exemplar.

- L. Roald, S. Misra, M. Chertkov, and G. Andersson, "Optimal Power Flow With Weighted Chance Constraints and General Policies for Generation Control", IEEE CDC, 2015. DOI: `10.1109/CDC.2015.7403311`. Source: https://doi.org/10.1109/CDC.2015.7403311
  - Role: `method_exemplar`.
  - Why: weighted chance constraints and policy flexibility.

- L. Roald, F. Oldewurtel, B. Van Parys, and G. Andersson, "Security Constrained Optimal Power Flow With Distributionally Robust Chance Constraints", 2015. Source: https://arxiv.org/abs/1508.06061
  - Role: `method_exemplar`.
  - Why: distributionally robust CC-OPF; verify final venue/DOI in next pass.

- "Distributionally Robust Chance-Constrained Optimal Power Flow", IEEE Transactions on Power Systems, DOI candidate: `10.1109/TPWRS.2016.2572104`. Source: https://doi.org/10.1109/TPWRS.2016.2572104
  - Role: `method_exemplar`.
  - Why: candidate DR-CCOPF anchor; verify title/authors before accepting.

### method: unbalanced-distribution-probabilistic-opf

- "Chance-Constrained Optimization-Based Unbalanced Optimal Power Flow for Radial Distribution Networks", IEEE Transactions on Power Delivery, 2013. DOI: `10.1109/TPWRD.2013.2259509`. Source: https://doi.org/10.1109/TPWRD.2013.2259509
  - Role: `method_exemplar`.
  - Why: unbalanced radial distribution OPF under uncertainty.

## distribution-three-phase-rebalancing

### method: reconfiguration-and-phase-balancing

- M. E. Baran and F. F. Wu, "Network Reconfiguration in Distribution Systems for Loss Reduction and Load Balancing", IEEE Transactions on Power Delivery, 1989. DOI: `10.1109/61.25627`. Source: https://doi.org/10.1109/61.25627
  - Role: `foundation`.
  - Why: distribution reconfiguration and load balancing baseline.

- C. H. Lin, C. S. Chen, H. J. Chuang, M. Y. Huang, and C. W. Huang, "An Expert System for Three-Phase Balancing of Distribution Feeders", IEEE Transactions on Power Systems, 2008. Source: web result from IEEE/ResearchGate; DOI pending.
  - Role: `method_exemplar`.
  - Why: three-phase feeder rephasing with engineering heuristics; needs DOI verification.

- C. Y. Ho, C. S. Chen, H. J. Chuang, and C. Y. Ho, "Heuristic Rule-Based Phase Balancing of Distribution Systems by Considering Customer Load Patterns", IEEE Transactions on Power Systems, 2005. Source: web references; DOI pending.
  - Role: `method_exemplar`.
  - Why: customer-load-pattern phase balancing anchor; needs DOI verification.

- R. A. Hooshmand and S. Soltani, "Fuzzy Optimal Phase Balancing of Radial and Meshed Distribution Networks Using BF-PSO Algorithm", IEEE Transactions on Power Systems, 2012. Source: web references; DOI pending.
  - Role: `method_exemplar`.
  - Why: optimization-style phase-balancing exemplar; needs DOI verification.

- R. Castillo-Sierra and L. Roald, "Load Balancing in Distribution Circuits Through Phase Swapping", NAPS, 2021. DOI: `10.1109/NAPS52732.2021.9654542`. Source: https://doi.org/10.1109/NAPS52732.2021.9654542
  - Role: `modern_method_exemplar`.
  - Why: phase swapping and modern operational framing.

## pricing-methods

### method: nodal-and-spot-pricing

- R. E. Bohn, M. C. Caramanis, and F. C. Schweppe, "Optimal Pricing in Electrical Networks Over Space and Time", RAND Journal of Economics, 1984. DOI: `10.2307/2555444`. Source: https://doi.org/10.2307/2555444
  - Role: `foundation`.
  - Why: spatial-temporal electricity pricing foundation.

- W. W. Hogan, "Contract Networks for Electric Power Transmission", Journal of Regulatory Economics, 1992. DOI: `10.1007/BF00133621`. Source: https://doi.org/10.1007/BF00133621
  - Role: `foundation`.
  - Why: contract-network/nodal-pricing market design anchor.

### method: transmission-pricing-and-cost-recovery

- I. J. Perez-Arriaga, F. J. Rubio-Oderiz, J. F. Puerta Gutierrez, J. Arceluz, and J. Marin, "Marginal Pricing of Transmission Services: An Analysis of Cost Recovery", IEEE Transactions on Power Systems, 1995. DOI: `10.1109/59.373981`. Source: https://doi.org/10.1109/59.373981
  - Role: `evidence_bar_exemplar`.
  - Why: marginal pricing versus revenue adequacy boundary.

- "Marginal Pricing of Transmission Services: A Comparative Analysis of Network Cost Allocation Methods", IEEE Transactions on Power Systems, 2000. DOI: `10.1109/59.852158`. Source: https://doi.org/10.1109/59.852158
  - Role: `method_exemplar`.
  - Why: candidate comparative cost-allocation anchor; verify authors/title before accepting.

### method: nonconvex-market-pricing

- R. P. O'Neill, P. M. Sotkiewicz, B. F. Hobbs, M. H. Rothkopf, and W. R. Stewart Jr., "Efficient Market-Clearing Prices in Markets With Nonconvexities", European Journal of Operational Research, 2005. DOI: `10.1016/j.ejor.2003.12.011`. Source: https://doi.org/10.1016/j.ejor.2003.12.011
  - Role: `method_exemplar`.
  - Why: uplift/convex-hull pricing and nonconvex clearing anchor.

## electricity-market-design

### method: lmp-and-contract-network-market-design

- R. E. Bohn, M. C. Caramanis, and F. C. Schweppe, "Optimal Pricing in Electrical Networks Over Space and Time", RAND Journal of Economics, 1984. DOI: `10.2307/2555444`. Source: https://doi.org/10.2307/2555444
  - Role: `foundation`.
  - Why: LMP/spot-pricing foundation.

- W. W. Hogan, "Contract Networks for Electric Power Transmission", Journal of Regulatory Economics, 1992. DOI: `10.1007/BF00133621`. Source: https://doi.org/10.1007/BF00133621
  - Role: `foundation`.
  - Why: organized market transmission-pricing architecture.

### method: stochastic-security-and-nonconvex-clearing

- F. Bouffard, F. D. Galiana, and A. J. Conejo, "Market-Clearing With Stochastic Security-Part I: Formulation", IEEE Transactions on Power Systems, 2005. DOI: `10.1109/TPWRS.2005.857016`. Source: https://doi.org/10.1109/TPWRS.2005.857016
  - Role: `method_exemplar`.
  - Why: market-clearing under stochastic security.

- R. P. O'Neill, P. M. Sotkiewicz, B. F. Hobbs, M. H. Rothkopf, and W. R. Stewart Jr., "Efficient Market-Clearing Prices in Markets With Nonconvexities", European Journal of Operational Research, 2005. DOI: `10.1016/j.ejor.2003.12.011`. Source: https://doi.org/10.1016/j.ejor.2003.12.011
  - Role: `method_exemplar`.
  - Why: nonconvex price formation, uplift and clearing benchmark.

- R. Sioshansi, R. O'Neill, and S. S. Oren, "Economic Consequences of Alternative Solution Methods for Centralized Unit Commitment in Day-Ahead Electricity Markets", IEEE Transactions on Power Systems, 2008. DOI: `10.1109/TPWRS.2008.919246`. Source: https://doi.org/10.1109/TPWRS.2008.919246
  - Role: `boundary_or_negative_example`.
  - Why: useful for writing market-design claims that distinguish model solution, prices, uplift, and welfare effects.

## Next Curation Pass

1. Convert this file to a machine-readable canon file under `skills/powerlit-power-systems-literature-intelligence/references/method-canon.json`.
2. For each DOI, resolve the PowerLit relative path if present; mark missing entries as `external_only`.
3. Normalize titles from DOI/publisher metadata, not mined PowerLit `title`.
4. Add `accepted=true/false`, `rejection_reason`, and `notes_for_skill`.
5. Build `.cache/powerlit-method-canon/<direction>/<method>/` from accepted in-corpus entries only.
6. Update writing/review skills to use canon entries as high-signal exemplars, while still using full PowerLit search for novelty and latest coverage.
