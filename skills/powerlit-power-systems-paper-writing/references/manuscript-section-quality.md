# Manuscript Section Quality Gate

Use this reference when drafting or revising the title, keywords, abstract, introduction, case analysis, conclusion, or full-paper structure. It turns common reviewer expectations into writing checks before the review skill is invoked.

## Role and Precedence

This file is the cross-section quality checklist: it turns reviewer expectations into pre-delivery acceptance checks. It is not the construction authority. For the deep how-to, defer to the section-authority references and do not maintain a competing version of their detail here:

- introduction cutting order, venue paragraph flow, gap/innovation categories, numeric whitelist, contribution patterns: `introduction-scalpel.md`;
- case-study prose construction, result-discussion layer, venue validation chains, conclusion boundary: `case-conclusion.md`;
- figure captions, table titles, result-paragraph evidence binding: `figures-tables-results.md`;
- equation physical intuition and method-section construction: `method-model.md`.

When this checklist and an authority file appear to disagree on detail, the authority file wins. Fix the discrepancy at the authority file rather than carrying two versions.

The review-side parallel of this checklist is `powerlit-power-systems-paper-review/references/section-quality-review.md` (the same dimensions seen from the reviewer stance). Keep the two aligned; do not let the writing-side and review-side wording drift apart.

## Title and Keywords

The title must be scientific, concise, and contribution-bearing:

- expose the power-system object, technical object, and differentiating mechanism or operating condition;
- avoid broad slogans, pure acronym titles, and math-first wording when the paper's value is engineering or physical;
- avoid superiority, real-time, robustness, deployment, or comprehensive-risk wording unless the evidence supports it;
- if no title is supplied, draft candidate titles before writing and align the selected title with the abstract, introduction, case study, and conclusion.

Keywords:

- keep keywords precise and at most five;
- use no more than five unless the venue explicitly requires otherwise;
- include the system object, method/technical object, application or operating condition, and one key mechanism or metric when needed;
- avoid duplicate levels of the same concept, vague words, and keywords that never appear as paper objects.

## Abstract

The abstract should be compact and fluent. It should quickly enter the technical subject rather than spending several sentences on broad background.

Required movement:

1. Background or operating context, in one short pivot sentence.
2. Purpose or unresolved problem.
3. Method or technical object.
4. Main result or evidence object.
5. Significance, engineering value, and boundary when needed.

The abstract must highlight innovation and practical value without overclaiming. It should not read as a section-by-section task list, and it should not contain claims that are absent from the case analysis.

The abstract must not frame the paper as a binary opposition. Avoid sentences whose main payload is "this paper supports X but not Y" or "we do not claim A/B/C". If a boundary is needed, state the positive technical scope and attach the condition or evidence boundary.

Every named mechanism, framework property, or technical concept in the abstract must have a recoverable body landing. Solver versions, initialization details, representative-day counts, parameter-sweep inventories, and other implementation facts normally belong in the case or reproducibility section rather than in the abstract. Retain a numerical result only when its comparison object, metric direction, and tested scope remain visible.

## Introduction

Authority: `introduction-scalpel.md` (cutting order, venue paragraph flow, gap-to-contribution map). This subsection is only the acceptance checklist; do not restate the scalpel's how-to here.

The introduction must:

- start from the broader power-system background but quickly focus on the concrete object and conflict;
- explain the current problem and challenge, not only state that the topic is important;
- analyze the technical essence of the problem: physical coupling, operating constraint, uncertainty, information limitation, computation, stability, security, observability, or evidence gap;
- condense the key scientific or engineering problem the paper solves;
- use recent high-level literature, preferably EI-indexed or above and mainly from the last five years, to summarize the research state when available;
- group literature by method family or technical limitation rather than listing papers one by one;
- state the paper's basic idea and relative advantage compared with existing approaches;
- make transitions natural from background -> existing methods -> unresolved technical reason -> proposed technical object -> evidence boundary;
- avoid binary contribution framing. The close of the introduction should state what technical object the paper constructs, what mechanism or decision it clarifies, and under which evidence boundary it is evaluated; it should not read like a list of supported and unsupported claims.
- write each contribution as a technical object plus its mechanism, property, or engineering consequence; do not use a solver setting, data split, case inventory, parameter scan, or implementation procedure as the contribution itself;
- keep the contribution order aligned with the body development and the evidence order, while avoiding sentence-level repetition.

If PowerLit is available, use it to retrieve recent venue-near or method-near papers before writing citation-sensitive introduction claims. If recent high-level literature is unavailable or not supplied, state the fallback and leave citation slots instead of inventing references.

## Case Analysis

Authority: `case-conclusion.md` (result-discussion layer, venue validation chains) and `figures-tables-results.md` (caption and result-paragraph evidence binding). This subsection is only the acceptance checklist.

The case analysis must be designed around the innovation point, not around whatever outputs are easiest to plot.

A complete case-analysis plan or section should state:

- which theoretical or engineering problem the case is meant to solve;
- data source, test system, scenario, operating condition, and why they are appropriate;
- baselines and why they are fair for the claim;
- metrics, units, and direction of improvement;
- comparison against existing methods where the paper claims relative advantage;
- parameter sensitivity, ablation, or boundary tests when parameters, modules, or assumptions affect the conclusion;
- case scale and analysis depth sufficient for the venue and claim class;
- figure and table interpretation one by one, with each visual tied to a claim, mechanism, or boundary;
- Figure-first coverage from the matching current plot data and manifest:
  condition, trend, key feature, quantitative difference, mechanism status,
  answered problem, bounded advantage/tradeoff, engineering implication, and
  boundary;
- a figure set that passes the figures-only read test in
  `figures-tables-results.md`: read in order with captions alone, the figures
  carry the engineering scene, the physical contradiction, the mechanism, the
  matched comparison, and the boundary;
- reproducibility details such as solver, tolerance, runtime, preprocessing, or hardware when they affect the claim.

The prose should explain mechanism and engineering meaning, not only repeat numbers. If data are incomplete, sources uncertain, baselines absent, or sensitivity missing, mark those as writing blockers or claim boundaries.

Reject prose that merely restates a caption, lists curve colors, or declares
"effective" without showing where the observed trend answers the paper's
problem and where the method's advantage holds.

Result paragraphs should not make "supported vs unsupported" the topic sentence. Present the evidence as mainline result, conditional result, observed phenomenon, boundary evidence, or future-work need. Use limitation wording only after the positive result role is clear.

## Conclusion

Authority: `case-conclusion.md` (venue-specific conclusion length and close patterns). This subsection is only the acceptance checklist.

The conclusion should be short and evidence-bound:

- summarize the main technical content and innovation points;
- state only conclusions supported by derivation, proof, case results, or cited evidence;
- avoid both exaggeration and excessive self-weakening;
- keep the length compact and do not reopen the literature review;
- include reasonable future work only when it follows from a real boundary, such as additional data, larger systems, field validation, new constraints, or broader scenarios.

Do not introduce new contributions, new numbers, or untested deployment implications in the conclusion.

Do not close the paper with a binary inventory of what was supported and unsupported. The conclusion should restate the mainline technical contribution, conditional scope, and most important boundary in a constructive form; future work should name the specific evidence needed to broaden the claim.

## Promise-to-Landing Matrix

For a full-paper draft or major rewrite, build an internal matrix before prose revision:

| Promise | First appearance | Body development | Model/equation landing | Evidence location | Conclusion closure |
| --- | --- | --- | --- | --- | --- |
| mechanism, theory, method, framework property, or engineering effect | title, abstract, or introduction contribution | section/subsection where it is explained | relation, constraint, proposition, algorithm step, or explicit technical argument | figure, table, baseline, ablation, sensitivity, proof, or boundary test | supported finding and scope |

Apply these rules:

- Every abstract concept and contribution item needs a body development location.
- A claimed mechanism needs more than a repeated sentence: require a model relation or explicit analysis and then mechanism-relevant evidence.
- A contribution may map to several pieces of evidence, but each principal figure or table should have one primary promise.
- If a promised object has no supported landing, add the missing supported development, narrow the promise, or delete it.
- Keep abstract movement, contribution order, body section order, principal-result order, and conclusion order functionally aligned. Do not force identical wording.
- Treat delayed resolution as a reader burden: a later section cannot silently repair an undefined or unsupported promise made earlier.

## Spine Consistency

The paper spine is one sentence naming the technical object, the unresolved conflict, the central action, and the evidence boundary (defined in `introduction-scalpel.md`). Before delivery, verify the spine is consistent across the five load-bearing locations: title, abstract, introduction contribution, result discussion, and conclusion.

Check that all five share:

- the same name for the technical object — no silent rename (e.g. 反演 in the title but 估计 in the abstract; "screening index" in the contribution but "predictor" in the results);
- the same central claim verb and scope — screening vs prediction, identification vs calibration, reduction vs elimination, support vs guarantee;
- the same evidence boundary — a limit stated in the conclusion must also bound the abstract and introduction claims, not appear only at the end;
- the same non-binary framing — boundaries should appear as scoped technical conditions across title/abstract/introduction/results/conclusion, not as late-stage "not supported" corrections.

If a location drifts, repair it back to the spine rather than weakening the spine. If two locations genuinely need different scope (for example a broader introduction motivation narrowing to a specific contribution), make the narrowing explicit so it does not read as a contradiction. This is a cross-section consistency check, not an instruction to repeat one sentence five times.

## Contribution Significance Gate

Run this before delivery for any full paper or major rewrite. A manuscript can pass every prose, structure, and evidence gate and still be a correct paper that no reader needs. The other gates remove defects; this one asks whether anything worth reading survives.

Answer four questions from the draft text alone, not from drafting memory or project context:

1. `Primary insight type`: which of theory migration, counterintuitive behavior, invariant, reduction, or boundary does the paper actually deliver? The discovery moves are defined in `powerlit-power-systems-prewriting-review/references/insight-discovery.md`; do not re-derive them here. If the honest answer is an incremental improvement on an established task, say so in the paper's own claim wording instead of borrowing mechanism or discovery language.
2. `Non-trivial claim`: name the one sentence a qualified reader could not have written before this paper. If every result sentence would be predicted by a specialist from the method description alone, the paper reports an implementation, not a finding. Narrow the claim to what is genuinely new, or report the gap.
3. `Reader consequence`: which decision, model choice, parameter setting, or belief of the target reader changes. Venue-relevant importance is not the same as a changed conclusion, and a metric table is not by itself a consequence.
4. `Largest remaining defect`: the single weakest link a strict reviewer would attack first, and where the manuscript addresses, bounds, or acknowledges it.

If questions 1 to 3 cannot be answered from the draft, this is a story defect, not a wording defect. Repair the framing, narrow the paper to its real finding, or return the blocker. Do not resolve it by strengthening adjectives, adding contribution bullets, or expanding the case section.

This gate is an internal check. Its labels stay out of manuscript prose under the working-language firewall in `prose-quality-gates.md`; the manuscript shows the insight, it does not announce which insight type it is.
