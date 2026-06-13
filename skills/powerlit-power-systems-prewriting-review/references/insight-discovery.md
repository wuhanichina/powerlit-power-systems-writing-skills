# Insight Discovery

Use this reference before the prewriting gate when the user is exploring an early idea, asking for innovation discovery, reframing a problem, or looking for a stronger technical object.

This mode generates candidate insight. It does not approve writing. Every candidate must still pass `references/innovation-chain.md` before any writing skill is invoked.

## Purpose

Translate a rough research idea into structures that can become a power-systems paper:

- problem reconstruction;
- mathematical or physical structure;
- theory migration;
- counterintuitive mechanism;
- possible technical object;
- evidence path and claim boundary.

## Thinking Moves

First rewrite the idea as a structure:

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

1. `问题重构`: the system object, map, and property being studied.
2. `可迁移结构`: candidate theory or modeling frames, each with an honesty label.
3. `反直觉线索`: where the result may depart from common modeling intuition, with an honesty label.
4. `候选技术对象`: model, constraint, estimator, certificate, algorithm, counterexample, validation protocol, or mechanism.
5. `证据路径`: theorem, simulation, baseline, sensitivity, ablation, field data, or boundary test needed.
6. `回到创新链`: a short problem -> gap -> technical object -> mechanism -> evidence -> boundary sketch, with unknown links explicitly marked.

If the chain has unknown links after discovery, the prewriting decision cannot be `GO`.
