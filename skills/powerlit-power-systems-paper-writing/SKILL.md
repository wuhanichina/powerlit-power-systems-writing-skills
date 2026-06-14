---
name: powerlit-power-systems-paper-writing
description: Draft, rewrite, or review full-length power-system research papers for 中国电机工程学报, 电力系统自动化, IEEE Transactions on Power Systems, and IEEE Transactions on Smart Grid. Use for abstracts, introductions, method/model sections, case studies, figure/table captions, result paragraphs, conclusions, terminology cleanup, venue adaptation, and PowerLit-grounded citation planning.
---
# PowerLit Power-Systems Paper Writing

## Purpose

Use this skill to produce full-paper manuscript prose that is ready for serious venue review. The skill is a shared writing entry point plus venue profiles, not four independent skills. Shared rules handle evidence, PowerLit retrieval, logic closure, paragraph discipline, and anti-AI cleanup. Venue profiles handle the journal-specific register, structure, evidence expectation, and rejection risks.

Do not use this skill for IEEE Letters. Use `ieee-power-engineering-letter-writing` when the target is a 3-4 page Letter or compact technical communication.

## Core Workflow

1. Identify the target venue: 中国电机工程学报, 电力系统自动化, IEEE TPWRS, or IEEE TSG.
2. If the idea, model, or evidence package has not passed prewriting review, use `powerlit-power-systems-prewriting-review` first. Do not turn an unsupported paper into fluent manuscript prose.
3. Lock the paper object before drafting:
   - grid or market object;
   - technical problem;
   - model, formulation, control law, estimator, algorithm, or mechanism;
   - evidence package;
   - claim boundary.
4. Load `references/project-claim-translation.md`. Treat project `claims.md`, research notes, evidence maps, and gate files as evidence boundaries, not as final manuscript claims.
5. Load `references/corpus-grounded-drafting.md` and `references/powerlit-evidence-strength.md`. When introduction, related-work, novelty, citation-sensitive writing, venue adaptation, style/rhythm calibration, full-paper drafting, score-targeting, or evidence-strength judgment is requested, use `powerlit-power-systems-literature-intelligence` first unless PowerLit is unavailable.
   - For skill maintenance or known-paper reconstruction tasks, also load `references/published-paper-reconstruction.md`. Treat accepted papers as masked evidence benchmarks, not text sources to imitate.
6. Load `references/venue-profiles.md`, then load exactly one venue reference:
   - 中国电机工程学报: `references/csee.md`; also load `references/csee-precision.md`.
   - 电力系统自动化: `references/aeps.md`.
   - IEEE TPWRS: `references/tpwrs.md`.
   - IEEE TSG: `references/tsg.md`.
7. Load the section references needed for the requested manuscript part:
   - introduction or related work: `references/introduction-scalpel.md`;
   - method, model, formulation, algorithm, control, optimization, or derivation: `references/method-model.md`;
   - case study, numerical results, experiment, simulation, conclusion, or closing section: `references/case-conclusion.md`;
   - figure captions, table titles, MATLAB-result summaries, result paragraphs, sensitivity analysis, or ablation discussion: `references/figures-tables-results.md`;
   - target review score, 8-9 score debugging, or score-bearing evaluation: `references/score-targeted-writing.md`;
   - light editing, translation, compression, expansion, logic checking, terminology cleanup, or anti-AI cleanup: `references/task-prompts.md`;
   - final prose pass: `references/publishable-prose.md`, `references/rhythm.md`, and mandatory `references/reader-experience-pass.md`;
   - review closure before delivery: `references/review-closed-loop.md`;
   - wording cleanup: `references/lexicon.md` and `references/anti-ai-style.md`.
8. Build the internal drafting map before writing:
   - project claim translation: source claim, review failure risk, paper claim candidate, and boundary sentence;
   - venue profile;
   - closest competitors or fallback status;
   - PowerLit evidence-strength profile for the same venue, claim class, and technical object when PowerLit is available;
   - corpus style exemplars when the task needs venue rhythm or section shaping;
   - citation-to-sentence plan when literature evidence is needed;
   - gap-to-contribution-to-evidence map;
   - section budget so standard material does not hide the contribution.
9. Draft manuscript prose by section. Do not expose planning labels, citation-pack labels, paragraph roles, or self-review scaffolds in final manuscript text unless the user explicitly asks to see them.
10. Before finalizing, run the claim pass, reader-burden pass, mandatory reader-experience pass, boundary-posture pass, formula physical-intuition pass, cut pass, rhythm pass, and working-language firewall from the loaded references. For captions, tables, and result paragraphs, also run the figure/table evidence check in `references/figures-tables-results.md`. For English/IEEE drafts, also run the English AI Tells scan in `references/anti-ai-style.md`.
11. If a target review score is requested, apply `references/score-targeted-writing.md` before review closure. Do not claim an 8-9 full-paper target when the evidence packet only supports a section-level result.
12. Run the review-closure gate in `references/review-closed-loop.md`. Use `powerlit-power-systems-paper-review` standards on the produced manuscript or section. If the review finds a fatal flaw, a major logic/model/evidence problem, or a target-venue mismatch, repair the draft before returning it. If repair is impossible because evidence or model details are missing, return the best bounded draft plus a short blocker note instead of presenting it as submission-ready.

## Power-System Story Order

Prefer this order over generic AI, ML, or optimization paper templates:

1. Operating or planning object: grid, device, market, uncertainty source, control layer, protection, or resilience setting.
2. Practical conflict: security, economy, voltage/frequency, uncertainty, computation, coordination, observability, or engineering feasibility.
3. Existing method classes and their precise limitation.
4. Proposed technical object: model, formulation, control strategy, algorithm, estimator, certificate, or dispatch mechanism.
5. Why it works: physical mechanism, convexity/relaxation, decomposition, uncertainty calibration, stability condition, or computational property.
6. Evidence: benchmark system, field/system data, comparative method, sensitivity, ablation where meaningful, and boundary cases.

## Venue Routing

Use the venue as a design constraint, not a late style filter.

- 中国电机工程学报: engineering mechanism and dense Chinese exposition. Keep policy background short and make every sentence define, constrain, derive, verify, or delimit.
- 电力系统自动化: compact operational logic. Move quickly from operating scenario to variables, constraints, algorithm, and metric.
- IEEE TPWRS: formulation-led English. Assumptions, constraints, reformulations, guarantees, and case evidence must be explicit.
- IEEE TSG: smart-grid mechanism. Data, learning, DER, privacy, communication, distributed-control, and cyber claims must remain tied to grid operation and physical constraints.

See `references/venue-profiles.md` for the full profile contract.

## Corpus-Grounded Drafting Rule

When PowerLit is accessible, do not draft citation-sensitive, venue-sensitive, or full-paper score-bearing sections from memory alone. Use the corpus in three ways:

1. Evidence use: retrieve nearby papers for novelty, citation function, and closest-competitor boundaries.
2. Evidence-strength use: inspect accepted venue-near papers to learn which systems, baselines, metrics, sensitivities, ablations, solver settings, and boundary cases are manuscript-facing for the same claim class.
3. Writing use: inspect venue-near exemplars for section order, paragraph function, sentence rhythm, contribution placement, evidence presentation, and conclusion boundary.

First build or consume:

- background citations;
- method-family citations;
- gap citations;
- closest-competitor citations;
- PowerLit evidence-strength profile;
- corpus style exemplars;
- citation-to-sentence plan;
- claim boundary after comparison.

If PowerLit is unavailable, state fallback mode once and continue only with supplied references, citation slots, or the static venue profiles. Never invent titles, DOIs, years, venues, paper-specific claims, or corpus-derived style statistics.

For skill maintenance, use `references/published-paper-reconstruction.md` to run masked reconstruction benchmarks from accepted PowerLit papers. If only case-analysis data are available, evaluate only the result/case-study writing ability; do not claim the skill can reconstruct a full publishable paper without method, model, baseline, metric, and claim-boundary facts.

## Section Rules

- Abstract: one compact problem sentence, one contribution sentence, one to three technical-action sentences, one evidence sentence, optional boundary sentence.
- Introduction: use `references/introduction-scalpel.md`; move from a concrete power-system object to a precise unresolved technical reason.
- Method/model: use `references/method-model.md`; define variables, sets, assumptions, physical meaning, constraints, transformations, and algorithmic steps in the venue's expected order. Key equations need physical intuition, not only symbol definitions.
- Case study/results: use power-system evidence objects, not generic SOTA language. State system, operating scenario, baselines, metrics, solver/protocol, sensitivity, and boundary where relevant.
- Figures/tables: use `references/figures-tables-results.md`; each caption must name the evidence object, system/scenario, metric, and comparison dimension when needed.
- Conclusion: state what was demonstrated and where the method's boundary remains. Avoid broad future-impact claims.
- Paragraphs: apply the reader-burden rule in `references/publishable-prose.md`: judgment first, reason after it, one idea per paragraph, and every sentence supporting the same point.
- Reader experience: apply `references/reader-experience-pass.md` before delivery. Repair high-impact `[writing]` burdens; keep `[topic-hard]` density only when definitions, transitions, physical intuition, or boundary language make the passage linearly followable.

## Hard Rules

- Do not polish a NO-GO idea into manuscript prose.
- Do not copy project `claims.md` wording into the paper as the headline contribution. Project claims are often rigid evidence controls; translate them into a venue-fit paper claim before drafting.
- Do not lead manuscript paragraphs with defensive boundary language such as "需要强调的是", "本文不把...", "本文不主张...", or "not intended to replace..." unless the target text is explicitly a limitations paragraph. Translate the boundary into a positive technical subject plus a stated scope.
- For Chinese journal manuscripts, run the punctuation-register gate before delivery: remove `声称/宣称` from manuscript prose, remove quotation marks used only for emphasis or concept packaging, and replace em-dash explanation chains with commas, semicolons, parentheses, or direct enumeration. Quotation marks are allowed only for literal titles, survey items, direct quotations, or template-required text.
- Do not cite or summarize papers that were not supplied or retrieved.
- Do not copy venue corpus sentences into manuscript prose. Use corpus papers for structure, rhythm, citation function, and evidence presentation; write the final text from the current manuscript's own technical object.
- Do not let internal planning terms appear in final manuscript prose. Terms such as `closest competitor`, `claim boundary`, `citation pack`, `gap-to-contribution map`, and similar working-language labels are for internal drafting only.
- Do not use generic ML claims such as state-of-the-art accuracy unless the venue profile, baselines, and metrics justify them.
- Do not claim scalability, real-time use, robustness, privacy, distributed implementation, or engineering deployability unless the evidence tests the corresponding condition.
- Do not call a draft submission-ready if the mandatory reader-experience pass fails or if the review skill would mark `专家级阅读体验` as `FAIL`.
- Do not call a draft submission-ready unless it can pass the internal review-closure gate without fatal flaws or major review issues.

## Output Contract

When rewriting paper prose, return the revised manuscript text first. Add a short note only when it clarifies unsupported claims, missing results, missing references, or terminology choices. Do not include a long self-review checklist in the manuscript-facing answer unless requested.

For planning or pre-drafting tasks, return the venue-grounded writing plan and explicitly mark which parts require PowerLit evidence, supplied references, or additional experiments.

For light editing, translation, compression, figure/table captions, and result-paragraph tasks, apply only the references needed for that small task. Preserve the supplied technical meaning and return the revised text first; name unsupported or missing evidence only in a short note.
