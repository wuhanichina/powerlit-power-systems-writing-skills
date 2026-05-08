# Innovation Chain Gate

A draft can enter writing only when the innovation chain closes.

## Required Chain

| Link | Question |
| --- | --- |
| Problem | What power-system operation, planning, control, market, protection, uncertainty, observability, stability, or resilience issue is being solved? |
| Gap | Which existing method class fails, and why? |
| Technical object | What is newly constructed: model, constraint, reformulation, algorithm, control law, estimator, certificate, counterexample, or validation protocol? |
| Mechanism | Why should this object resolve the gap? |
| Evidence | Which theorem, case, baseline, metric, sensitivity, or boundary test supports it? |
| Boundary | Under what assumptions does the claim hold? |

## Strong Chain

Strong papers make the gap technically necessary:

- a physical coupling is omitted;
- uncertainty is treated too coarsely;
- security or stability is not enforced;
- information timing is unrealistic;
- computation is intractable at the required scale;
- data-driven performance lacks grid interpretability or robustness;
- coordination across devices, networks, or time scales is missing.

## Weak Chain

Stop or retarget when:

- the gap is only "accuracy is low" or "efficiency is insufficient";
- the contribution is "A+B+C framework" with no new coupling mechanism;
- the method solves a narrower or different problem from the introduction;
- the case study verifies only feasibility, not the claimed innovation;
- the claim depends on assumptions introduced only after the result.

## Prewriting Output

Always state the chain explicitly. If a link is unknown, mark it as unknown rather than inventing it.
