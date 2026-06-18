# Method, Model, and Formulation Reference

Use this reference for problem formulation, system models, objectives, constraints, algorithms, control strategies, derivations, relaxations, and feasibility certificates.

## Core Order

Unless the technical object requires another order, present:

1. operating/planning object and modeling boundary;
2. assumptions, sets, indices, variables, parameters, units, and information timing;
3. objective, physical equations, constraints, uncertainty/data model, or control law;
4. transformation, approximation, relaxation, decomposition, analytical result, or certificate;
5. algorithm, implementation condition, and stopping/fallback rule;
6. evidence boundary and reproducibility details relevant to the claim.

Do not begin with a generic announcement. Start with the power-system object or the precise modeling conflict.

## Physical Story Before Mathematics

Before a dense equation group, state:

- the grid, device, market, uncertainty, communication, or planning object;
- the operating conflict or missing information;
- why the mathematical object is needed;
- what operational or physical conclusion it permits.

Mathematics is not justified by density. A lemma, proposition, proof, or certificate belongs in the main text only when it establishes a property used by the paper's claim or algorithm.

## Formula Physical Intuition

For each key equation group, explain when relevant:

- represented electrical/operational quantity;
- cause-effect direction;
- units, per-unit base, sign convention, and dimensions;
- why terms are coupled, bounded, relaxed, or decomposed in that form;
- limiting or degenerate case;
- the diagnostic or operating implication.

Definitions alone are insufficient. Keep symbol definitions close to first use, then add one concise physical explanation.

## Model-Algorithm Consistency

For every approximation, relaxation, surrogate, penalty, decomposition, or discretization, state the exact relationship to the original problem:

- equivalence under listed conditions;
- outer or inner approximation;
- lower or upper bound on a named objective;
- asymptotic relation;
- heuristic relation with an unquantified gap.

If the relationship is not established, do not write “equivalent”, “exact”, or “guaranteed”. Report the method actually solved and its observed behavior.

## SOCP and Convex-Relaxation Claims

Do not use radial topology, or radial topology plus one informal condition, as a universal SOCP exactness statement.

An exactness claim must identify:

1. the network and branch-flow/bus-injection model;
2. the objective and required monotonicity properties;
3. load and generation lower/upper bounds;
4. voltage, current, power-flow, and controllability conditions;
5. feasibility and topology assumptions;
6. the cited theorem or a proof applicable to this formulation;
7. the recovery condition showing that the relaxed solution satisfies the original nonconvex relation.

Acceptable template:

> Under Assumptions A1–A5 and the exactness theorem cited in [x], the conic relaxation recovers an original feasible solution because the stated objective, bound, and voltage/current conditions satisfy that theorem. Table/Fig. y additionally reports the recovery residual or rank condition.

Unacceptable template:

> The relaxation is exact because the network is radial.

If exactness is not proved, describe a relaxation, report the relaxation gap or recovery residual, and bound the conclusion accordingly.

## Penalty and Augmented-Lagrangian Claims

Distinguish:

- quadratic or smooth penalty methods;
- exact nonsmooth penalties;
- augmented-Lagrangian methods;
- regularization terms used only to guide a numerical solution.

For a finite quadratic penalty parameter, the minimizer generally need not satisfy the original constraints and is not automatically a feasible upper bound. Do not make either claim without proof.

An exact-penalty statement requires:

- the actual penalty function;
- regularity/constraint-qualification assumptions;
- a proved or cited threshold for the penalty parameter;
- a statement of local or global scope;
- a feasibility check for the returned solution.

For an augmented-Lagrangian algorithm, report primal and dual residuals, multiplier/penalty updates, stopping criteria, and any feasibility-recovery step. Numerical residual decrease is not by itself proof of equivalence.

## SDP and Moment Feasibility Certificates

First identify whether the SDP set is:

- an outer relaxation of the original feasible set;
- an inner approximation;
- an exact reformulation under rank/structure conditions;
- one level of a moment/SOS hierarchy.

For an outer relaxation \(F\subseteq F_{\mathrm{SDP}}\):

\[
F_{\mathrm{SDP}}=\varnothing \;\Rightarrow\; F=\varnothing,
\]

provided the relaxation and numerical infeasibility certificate are valid. The converse does not hold in general:

\[
F_{\mathrm{SDP}}\ne\varnothing
\]

is not sufficient to establish a physically realizable original solution.

A positive physical-realizability claim additionally requires the condition appropriate to the formulation, such as exactness, rank recovery, flat extension, or existence of a representing measure. State solver tolerances and distinguish:

- certified infeasible;
- relaxed feasible with recovery condition satisfied;
- relaxed feasible but physically inconclusive;
- numerically indeterminate.

Use “certificate” only for the proposition actually certified. Prefer:

> infeasibility evidence relative to the stated SDP relaxation and tolerance

unless the stronger original-space implication has been proved.

## Inverse Probabilistic Load Flow

When relevant, explain that voltage-domain means and covariances generate active/reactive power moments through the network power-flow relation, rather than a generic statistical fit. Identifiability concerns which voltage co-fluctuation directions are observable from the supplied moments. Any SDP condition must be described according to the relaxation logic above; relaxed feasibility alone cannot be called proof that an admissible voltage distribution exists.

## Standard Machinery and Claimed Novelty

SOCP, SDP, ADMM, chance constraints, ambiguity sets, scenario reduction, Gaussian mixtures, PINNs, and standard Bayesian updates are established machinery by default. A contribution must map to a concrete formulation, mechanism, theorem, algorithm step, diagnostic quantity, or application insight supported by evidence.

Do not reject legitimate application work merely because it uses standard machinery. Instead distinguish a research-method claim from an application-paper claim and require the evidence appropriate to that type.

## Venue Routing

### 中国电机工程学报

Use an engineering mechanism-model-evidence order. Keep equations, assumptions, variable definitions, and physical meaning close together. Do not replace the contribution with policy background.

### 电力系统自动化

State time scale, information source, operating object, objective, constraints, and execution procedure early. Keep implementation logic easy to scan.

### IEEE TPWRS

Use an assumption-explicit, formulation-led argument. Separate original model, transformation/relaxation, theoretical relationship, algorithm, and validation. State every exactness, guarantee, and scalability claim with its conditions and evidence.

### IEEE TSG

Connect data, learning, communication, privacy, cyber, DER, or edge machinery to physical grid constraints and an operational metric. State data protocol and information structure.

## Final Method Check

Before delivery verify:

- every core variable is defined and used consistently;
- units, signs, bases, indices, and domains are coherent;
- required operating constraints are present;
- assumptions precede the result that uses them;
- transformations state their relationship to the original model;
- exactness, penalty, and certificate claims satisfy the rules above;
- algorithm steps correspond to modeling difficulties;
- initialization, stopping, fallback, and reproducibility details are present when material;
- conclusions do not exceed proved or tested conditions.
