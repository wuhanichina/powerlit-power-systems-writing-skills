# Insight Discovery

Use this reference before the prewriting gate when the user is exploring an early idea, asking for innovation discovery, reframing a problem, repositioning the real innovation, designing the physical story, designing a multi-act engineering story, or looking for a stronger technical object.

This mode generates candidate insight. It does not approve writing. Every candidate must still pass `references/innovation-chain.md` before any writing skill is invoked.

## Purpose

Translate a rough research idea into structures that can become a power-systems paper:

- minimum research object identification;
- problem reconstruction;
- physical mechanism before mathematical structure;
- real-innovation repositioning;
- multi-act engineering story logic;
- physical intuition;
- theory migration;
- counterintuitive mechanism;
- possible technical object;
- evidence path and claim boundary.

## Physics-First Repositioning

Before looking for abstract theory, identify the minimum research object and reconstruct the engineering scene:

- what is the narrowest method family or research object that matches the title, variables, baselines, and evidence;
- which small peer group would immediately know the closest baselines;
- which broad background is only motivation and must not become the main pain point;
- what grid, device, uncertainty, disturbance, control, market, protection, or planning situation creates the problem;
- what physical coupling, operating limit, timing mismatch, topology change, uncertainty propagation, or device interaction makes the problem nontrivial;
- what a conventional method sees incorrectly, ignores, averages away, linearizes too aggressively, or cannot certify;
- what observed result would convince a power-system reader that the proposed object captures the missing mechanism.

Then choose the real innovation:

- allow "a newly posed narrow research object" to be the real innovation when it is supported by variables, baselines, and evidence;
- prefer a physical mechanism, certificate, estimator, constraint, control logic, validation protocol, or boundary condition over a broad "framework";
- demote pure derivation, equation rearrangement, and metric improvement unless they expose a real power-system mechanism;
- keep only one main story when several candidate innovations compete;
- mark unsupported but promising stories as candidate stories, not manuscript claims.

## Multi-Act Engineering Story

Write the story in acts so the reader follows engineering causality instead of equation order:

| Act | Role | Required Question | Math Role |
| --- | --- | --- | --- |
| I | Engineering scene | What physical system, operating condition, uncertainty, or decision makes the problem real? | Usually none, except defining the object. |
| II | Physical contradiction | What coupling, limit, timing mismatch, topology change, or intuition failure makes existing treatment inadequate? | Translate the contradiction into variables or constraints. |
| III | Mechanism and intuition | What mechanism explains why the proposed idea should work? | Use equations to reveal sensitivity, propagation, conservation, feasibility, risk, or boundary behavior. |
| IV | Technical object | What model, estimator, constraint, certificate, algorithm, or protocol embodies the mechanism? | Formalize only the necessary object. |
| V | Evidence | Which baseline, ablation, scenario, sensitivity, or result isolates the mechanism? | Define metrics and tests; do not let metrics replace the mechanism. |
| VI | Boundary | Where does the claim hold, weaken, or fail? | State assumptions, proof boundary, approximation range, or unsupported cases. |

Do not make mathematics the main plot. Use mathematics as the instrument that clarifies each act's engineering and physical meaning.

## Thinking Moves

First rewrite the idea as a power-system structure:

- what is the system object;
- what variables, states, uncertainties, constraints, or decisions live in it;
- what map turns inputs into outputs;
- which property of that map matters: stability, feasibility, risk, distribution, sensitivity, identifiability, optimality, observability, robustness, scalability, or boundary.

Then search for leverage:

- theory migration: a mature structure from another field that offers a problem statement, model, counterexample, or computation frame;
- counterintuitive behavior: tail behavior, threshold, conditioning reversal, slow-fast mismatch, high-dimensional concentration, duality, symmetry breaking, conservation, topology, or scale effect;
- invariant: a quantity or relation that remains meaningful after changing representation, scenario, or scale;
- reduction: several observed phenomena become one mathematical or engineering object;
- boundary: a condition where a common method changes from valid to invalid.

Use structure only when it clarifies the problem. Do not decorate an ordinary idea with abstract language.

## Honesty Labels

Every output item must be labeled as one of:

- `known theory`: a relatively established mathematical or engineering result;
- `structural analogy`: a plausible transfer whose validity still needs checking;
- `research hypothesis`: a conjecture worth modeling, simulation, literature search, or proof.

Do not present analogy as theorem. Do not present a hypothesis as a supported paper claim.

## Output Contract

For insight-discovery mode, return:

1. `最小研究对象定位`: minimum research object, small peer group, closest problem family, broad background, and non-objects.
2. `问题重构`: the system object, map, and property being studied.
3. `真实创新点重定位`: strongest writable innovation, weaker framings to drop, and whether the current best story is supported or only a candidate.
4. `多幕工程故事与物理直觉`: Act I engineering scene, Act II physical contradiction, Act III mechanism and intuition, Act IV technical object and supporting mathematics, Act V evidence, Act VI boundary.
5. `可迁移结构`: candidate theory or modeling frames, each with an honesty label.
6. `反直觉线索`: where the result may depart from common modeling intuition, with an honesty label.
7. `候选技术对象`: model, constraint, estimator, certificate, algorithm, counterexample, validation protocol, or mechanism.
8. `证据路径`: theorem, simulation, baseline, sensitivity, ablation, field data, or boundary test needed.
9. `回到创新链`: a short problem -> gap -> technical object -> mechanism -> evidence -> boundary sketch, with unknown links explicitly marked.

If the chain has unknown links after discovery, the prewriting decision cannot be `GO`.
