# Model, Mathematics, and Method Review

Use this reference for physical models, variables, equations, algorithms, relaxations, proofs, and certificates. Every finding must cite a manuscript location and the relation that fails.

## Model Correctness

Check whether the formulation can express the stated engineering problem:

- variables match the grid, device, market, or planning object;
- assumptions, time scale, information timing, and uncertainty/data model are explicit;
- objective represents the claimed decision goal;
- constraints include the physical and operating limits needed for the conclusion;
- units, per-unit bases, signs, domains, and dimensions are consistent;
- case settings do not silently change the model.

A central omitted constraint, invalid physical relation, or inconsistent variable definition may be fatal when the principal result depends on it.

## Formula-Level Check

For each key equation group verify:

- every symbol, set, index, and operator is defined near first use;
- dimensions, units, signs, and bounds are valid;
- the physical quantity and cause-effect direction are stated;
- limiting/degenerate cases behave consistently;
- equation numbers and cross-references are correct;
- no unused variable or decorative equation remains.

Do not pass algebra merely because notation is syntactically complete.

## Original Model Versus Solved Model

Classify every transformation as one of:

- exact reformulation under stated conditions;
- outer relaxation;
- inner approximation;
- lower/upper bounding model;
- asymptotic method;
- heuristic surrogate.

Flag a major or fatal issue when the manuscript solves one object but reports conclusions as though it solved another, or when the required condition is hidden.

## SOCP Exactness Review

Radial topology is not, by itself, a universal exactness condition.

For an exactness claim, require the manuscript to identify and satisfy the applicable theorem's assumptions, including as relevant:

- branch-flow or bus-injection model;
- network topology and parameter conditions;
- objective monotonicity;
- load/generation bounds and controllability;
- voltage/current/flow limits;
- feasibility conditions;
- rank, residual, or recovery condition.

If these are absent, classify the model as a relaxation and require a relaxation-gap or recovery analysis. A numerical match on a few cases does not establish theorem-level exactness.

## Penalty and Augmented-Lagrangian Review

Identify the actual method: quadratic penalty, exact penalty, augmented Lagrangian, or regularization.

Flag an incorrect statement when a manuscript claims that a finite quadratic-penalty solution is automatically feasible for the original problem or constitutes a feasible upper bound. Such a claim requires an exact-penalty theorem or separate feasibility proof.

For exact penalties require:

- penalty form;
- regularity/constraint qualification;
- parameter threshold;
- local/global scope;
- returned-solution feasibility check.

For augmented-Lagrangian methods check multiplier updates, residual definitions, stopping rule, penalty schedule, and feasibility recovery. Convergence of the implemented algorithm must not be inferred from residual decrease alone unless the theorem assumptions are established.

## SDP and Moment-Certificate Review

Determine the set relation. For a valid outer relaxation \(F\subseteq F_{\mathrm{SDP}}\):

- relaxed infeasibility can establish original infeasibility, subject to numerical certification;
- relaxed feasibility alone cannot establish physical realizability.

A positive original-space claim requires the relevant exactness/rank/flat-extension/representing-measure condition. Require the manuscript to distinguish:

- certified infeasible;
- relaxed feasible and recoverable;
- relaxed feasible but inconclusive;
- numerical solver failure or indeterminate status.

Check solver tolerances, dual/primal certificate definition, and whether the reported certificate actually implies the manuscript's conclusion. Do not equate solver nonconvergence with physical infeasibility.

## Theoretical-Method Review

For every theorem, proposition, or claimed guarantee check:

- complete assumptions;
- statement matches what is proved;
- exact, approximate, asymptotic, and empirical claims are separated;
- degenerate cases reduce to known models when claimed;
- error, gap, or validity boundary is stated;
- the case study does not replace a missing proof.

## Data-Driven Method Review

When applicable check:

- chronological or group-aware split where required;
- normalization, feature engineering, and imputation fitted only on training data;
- no future information in inputs;
- baseline strength and equal information access;
- random seeds or repeated-run uncertainty;
- cross-time/system/penetration generalization where claimed;
- physical feasibility or repair of outputs;
- reward and safety constraints for reinforcement learning;
- model/version disclosure for large-model components.

## Complexity and Scalability

A complexity or scalability claim requires both algorithmic analysis and empirical evidence appropriate to the statement. Runtime comparisons must use stated hardware/software, termination tolerances, implementation language, warm starts, and comparable solution quality.

Do not treat use of a particular solver as the contribution unless the manuscript changes the algorithmic object or demonstrates a transferable implementation result.

## Severity Guidance

Potentially fatal:

- physically invalid central model;
- invalid transformation that overturns the result;
- data leakage central to the reported advantage;
- false exactness/certificate claim on which the conclusion depends;
- essential constraint absent.

Usually major:

- unstated but repairable assumptions;
- missing recovery/gap analysis;
- insufficient algorithm details;
- weak reproducibility information;
- physical intuition absent while algebra remains interpretable.

Assign severity from consequence, not from rule labels. Cite the manuscript evidence and confidence for fatal findings.
