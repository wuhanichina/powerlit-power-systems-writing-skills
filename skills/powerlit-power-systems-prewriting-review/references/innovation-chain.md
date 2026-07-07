# Innovation Chain Gate

A draft can enter writing only when the innovation chain closes inside the minimum research object. Load `minimum-research-object.md` first.

## Required Chain

| Link | Question |
| --- | --- |
| Problem | What problem is being solved inside the smallest matching research object or method family? |
| Gap | Which existing method class in that same object fails, and why? |
| Technical object | What is newly constructed: model, constraint, reformulation, algorithm, control law, estimator, certificate, counterexample, or validation protocol? |
| Innovation level | Is the primary contribution a discovery or conjecture verification, a method-level contribution, an engineering-problem contribution, or a supported combination? |
| Evidence maturity | Should each candidate be used as a mainline innovation, conditional contribution, observed phenomenon, boundary evidence, or uncovered evidence need? |
| Value position | What theoretical value and engineering value does this chain create beyond a metric gain, and how does PowerLit near-neighbor literature position that value? |
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
- a narrow research object has not been posed before, or existing methods in that object do not output, certify, reconstruct, or distinguish the physical quantity required by the paper.
- the work first discovers or verifies a mechanism/conjecture, then proposes a method that uses it, then demonstrates the engineering problem that becomes better handled.

## Weak Chain

Stop or retarget when:

- the gap is only "accuracy is low" or "efficiency is insufficient";
- the gap is borrowed from a broader application area while the method and evidence actually belong to a narrower object;
- the contribution is "A+B+C framework" with no new coupling mechanism;
- the response mixes discovery, method, and engineering benefit into one vague innovation label without saying which level is supported;
- the response reduces innovation discovery to binary "supports X / does not support Y" wording instead of assigning each candidate a manuscript use;
- the response treats a metric gain as the theoretical value, instead of using metrics as evidence for a higher-level mechanism, boundary, validation, certificate, or engineering decision value;
- the method solves a narrower or different problem from the introduction;
- the case study verifies only feasibility, not the claimed innovation;
- the claim depends on assumptions introduced only after the result.

## Non-Binary Innovation Framing

In prewriting and innovation-mining outputs, avoid binary support language as the primary wording. Replace "supports/does not support" with evidence-maturity and manuscript-use categories:

- mainline innovation;
- conditional contribution;
- observed phenomenon;
- boundary evidence;
- uncovered evidence need.

Strict support or blocker language is allowed only when the user explicitly asks for a review verdict, readiness decision, or fatal overclaim check.

## Professional Problem Naming

State the problem in field-standard terms. Do not use internal project names, case nicknames, claim IDs, run labels, local file names, or workflow terms as the manuscript-facing problem. Translate them into the actual grid object, operating condition, method family, metric, and evidence object before judging the chain.

## Prewriting Output

Always state the chain explicitly. If a link is unknown, mark it as unknown rather than inventing it.
