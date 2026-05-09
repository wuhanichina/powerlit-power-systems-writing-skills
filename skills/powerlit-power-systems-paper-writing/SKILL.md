---
name: powerlit-power-systems-paper-writing
description: Draft, rewrite, or review power-system research papers for 中国电机工程学报, 电力系统自动化, IEEE Transactions on Power Systems, and IEEE Transactions on Smart Grid. Use for abstracts, introductions, methods, experiments, conclusions, terminology polishing, and anti-AI-style cleanup in power-system manuscripts.
---
# PowerLit Power-Systems Paper Writing

## Purpose

Use this skill to write power-system papers in the target journal's own register. The default style is concise, technically explicit, evidence-bound, and free of visible meta narration.

## Core Workflow

1. If the idea, model, or evidence package has not passed prewriting review, use `powerlit-power-systems-prewriting-review` first. Do not polish unsupported claims into manuscript prose.
2. Identify target venue: 中国电机工程学报, 电力系统自动化, IEEE TPWRS, or IEEE TSG.
3. Lock the paper object before drafting: system setting, technical problem, model/formulation, method, evidence, and claim boundary.
4. For introduction, related-work, novelty, or citation-sensitive writing, try `powerlit-power-systems-literature-intelligence` first:
   - resolve PowerLit from user path, `POWERLIT_JSON_ROOT`, `POWERLIT_LITERATURE_JSON`, or `\\WHome\PowerLit\literature\json`;
   - if accessible, use the citation pack and closest-competitor matrix as evidence;
   - if inaccessible, state fallback mode once and continue without inventing citations.
5. Load only the venue reference needed:
   - 中国电机工程学报: `references/csee.md`
   - 电力系统自动化: `references/aeps.md`
   - IEEE TPWRS: `references/tpwrs.md`
   - IEEE TSG: `references/tsg.md`
6. For 中国电机工程学报 precision writing, also load `references/csee-precision.md`.
7. For all venues, load `references/publishable-prose.md` before final manuscript writing.
8. For introduction writing, load `references/introduction-scalpel.md`.
9. For readability and sentence rhythm, load `references/rhythm.md`.
10. For method, model, formulation, algorithm, solution, control, or optimization sections, load `references/method-model.md`.
11. For case-study, numerical-results, experiment, simulation, conclusion, or closing sections, load `references/case-conclusion.md`.
12. For wording cleanup, also load `references/lexicon.md` and `references/anti-ai-style.md`.
13. Draft by section using the venue reference. Do not expose planning labels, paragraph roles, or self-review scaffolds in the final prose unless the user asks for them.
14. Before finalizing, run the `publishable-prose.md` claim pass, cut pass, and rhythm pass. Every performance, novelty, accuracy, feasibility, scalability, or superiority claim must map to a result, derivation, citation pack, or explicitly stated assumption.

## Power-System Story Order

Prefer this order over generic ML/CV paper templates:

1. Operating or planning object: grid, device, market, uncertainty source, control layer, or protection/resilience setting.
2. Practical conflict: security, economy, voltage/frequency, uncertainty, computation, coordination, observability, or engineering feasibility.
3. Existing method classes and their precise limitation.
4. Proposed technical object: model, formulation, control strategy, algorithm, estimator, certificate, or dispatch mechanism.
5. Why it works: physical mechanism, convexity/relaxation, decomposition, uncertainty calibration, stability condition, or computational property.
6. Evidence: benchmark system, field/system data, comparative method, sensitivity, ablation where meaningful, and boundary cases.

## Section Rules

- Abstract: one compact problem sentence, one contribution sentence, one to three technical-action sentences, one evidence sentence, optional boundary sentence.
- Introduction: do not spend multiple paragraphs on policy slogans. Move from power-system context to a concrete unsolved technical reason.
- Method/model: load `references/method-model.md`; make the technical object explicit before implementation details. Define variables, sets, constraints, assumptions, physical meaning, and algorithmic steps in the venue's expected order.
- Experiments/case studies: use power-system evidence objects, not generic "SOTA" language. State system, operating scenario, baselines, metrics, and solver/protocol when relevant.
- Conclusion: state what was demonstrated and where the method's boundary remains. Avoid broad future-impact claims.
- All venues: load `references/publishable-prose.md`; every paragraph must close a technical logic chain. Do not produce流水账, defensive prose, or readable-but-empty paragraphs.
- 中国电机工程学报: load `references/csee-precision.md`; every sentence must define, constrain, derive, verify, or delimit something. Delete decorative and meta sentences.

## Rhythm Rule

Readable power-system prose does not mean many short generic sentences. For Chinese venues, use long technical sentences only when their internal beats are clear: problem -> method object -> modeling step -> evidence. For IEEE Transactions papers, keep most sentences in the 18-30 word range and make the formulation, constraint, algorithm, controller, estimator, data mechanism, or result the grammatical subject. See `references/rhythm.md`.

## Introduction Rule

Write the introduction like a technical dissection: object -> consequence -> method families -> limitation -> technical reason -> core contradiction -> contribution. Chinese venues usually keep gap and proposal close; IEEE Transactions papers usually spend more paragraphs separating method families before explicit contributions. For TSG, keep every data, learning, communication, privacy, or distributed-control claim tied to a grid-operational mechanism. Use `references/introduction-scalpel.md`.

When PowerLit is accessible, do not draft the introduction from memory alone. First build or consume a citation pack: background citations, method-family citations, gap citations, closest-competitor citations, and a citation-to-sentence plan. When PowerLit is unavailable, keep citations generic only if supplied by the user; otherwise leave citation slots or state the literature limitation.

## Anti-Meta Rule

Do not write prose that announces writing actions:

- Avoid: "This section introduces...", "The remainder of this paper is organized as follows" unless the venue explicitly needs it.
- Avoid: "we comprehensively explore", "a novel paradigm", "seamlessly integrates", "significant improvement" without numbers.
- Prefer subject-led sentences: "The chance constraint is reformulated as...", "The rolling horizon model coordinates...", "Simulation on the IEEE 118-bus system shows...".

## Prewriting Gate

When the available material has not been pre-reviewed, do not begin with manuscript text. First establish:

- real problem,
- exact gap,
- technical object,
- model correctness,
- evidence support,
- claim boundary,
- target-venue fit.

If any of these are missing, state the blocker and recommend `GO`, `CONDITIONAL GO`, `NO-GO`, or `RETARGET` rather than writing polished prose.

## Iteration Rule

You may spend extra internal passes on reflection before returning manuscript text. Prefer a slower final answer that survives review over a quick, fluent draft. Do not show intermediate self-review unless requested; use it to remove unsupported claims, tighten logic, and improve rhythm.

## Relationship to `research-paper-writing`

Keep from the existing skill:

- story before sentence edits,
- paragraph-level reverse outline,
- evidence-bound claims,
- reviewer-facing self-checks,
- clean tables and figures.

Replace for power-system venues:

- generic "task/SOTA/pipeline" framing with "system object/model/constraint/solution/case" framing,
- ML-style teaser and module-ablation defaults with benchmark, operating scenario, solver, sensitivity, and engineering-boundary evidence,
- visible output scaffolds with clean manuscript prose.

For details, use `references/baseline-comparison.md`.

## Output Contract

When rewriting paper prose, return the revised manuscript text first. Add a short note only when it clarifies unsupported claims, missing results, or terminology choices. Do not include a long self-review checklist in the manuscript-facing answer unless requested.
