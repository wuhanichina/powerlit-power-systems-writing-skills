# Review-Closed Writing Loop

Use this reference before returning manuscript prose from `powerlit-power-systems-paper-writing`. The writing skill and review skill must form a closed loop: a draft that would immediately fail the local review skill should not be presented as submission-ready.

## Gate Timing

Run this gate after:

1. project claims have been translated into paper claims through `project-claim-translation.md`;
2. venue profile and PowerLit evidence have been applied;
3. reviewer comments, if present, have been translated into physical mechanism, model, evidence, or scope repairs at natural manuscript locations;
4. the draft has passed claim, physical-story, reader-burden, mandatory reader-experience, cut, rhythm, and anti-AI-language passes;
5. section-specific references have been applied.

For a full manuscript, review the full manuscript. For a section-only task, review the produced section and state the verdict as section-level.

## Review Standard

Apply the standards of `powerlit-power-systems-paper-review`:

- technical problem is real and venue-relevant;
- contribution is a technical object, not decoration or packaging;
- problem -> gap -> method -> validation -> conclusion is closed;
- model, variables, assumptions, equations, units, and algorithms are coherent;
- key equations explain physical intuition, not only notation;
- case evidence supports the claim and uses relevant baselines, scenarios, metrics, and boundaries;
- venue rhythm and depth match the target journal;
- reviewer feedback is absorbed into the paper's physical logic rather than preserved as defensive rebuttal posture;
- mathematical depth matches engineering need; proof-style detail does not displace physical mechanism, assumptions, and validation unless the claim requires it;
- expert reader experience is at least `CONDITIONAL PASS`;
- final prose does not hide unsupported claims behind polished wording;
- final prose does not convert valid claim boundaries into defensive "not a replacement" posture.

When the task targets an 8-9 review score, also apply `score-targeted-writing.md` and `decision-rubric.md`. The closure gate must repair or block any draft whose core score category would fall below the requested target band.

## Pass Criteria

A draft may be returned as manuscript-ready only if the internal review would be no worse than:

- full manuscript: `小修后录用` or a clearly bounded `大修后录用` caused only by missing optional references, formatting, or minor extra explanation;
- section-only task: no fatal flaw, no section-level venue mismatch, and no major model/evidence contradiction inside the produced section.

In both cases, the review skill's `专家级阅读体验` item must be at least `CONDITIONAL PASS`. A technical draft with expert-reader `FAIL` is not manuscript-ready.

The draft fails the closure gate if the internal review would identify any of these:

- `拒绝录用` verdict;
- fatal problem, novelty, logic-chain, model, or evidence issue;
- introduction motivates one problem while the method or section solves another;
- method claims a property that is not derived, tested, or bounded;
- method formulas are syntactically defined but lack the physical intuition needed to understand what grid quantity, coupling, or feasibility property they represent;
- reviewer comments are handled as standalone defensive disclaimers, apology-like hedges, or isolated rebuttal sentences instead of repairs to the manuscript's physical story;
- an engineering section becomes proof-heavy or theory-heavy while leaving the physical picture, engineering background, or operating interpretation unclear;
- case/conclusion claims unsupported superiority, scalability, robustness, privacy, or engineering deployability;
- expert reader experience would be `FAIL` because critical sections are not linearly followable, high-impact `[writing]` burdens remain, or target-method-evidence alignment breaks during reading;
- manuscript paragraphs lead with defensive self-limitation when a positive technical contribution and scoped boundary can be stated instead;
- PowerLit near-neighbor evidence already covers the same problem, mechanism, and evidence object.

## Repair Loop

If the draft fails:

1. Repair the issue in the manuscript text when the needed information is available.
2. If the failure came from reviewer-comment revision, rebuild the physical-story map before changing sentences: concern -> real gap -> physical mechanism -> manuscript location -> evidence or formula.
3. Update the internal project-claim translation if the review shows the source claim was too rigid, too broad, or not paper-shaped.
4. If the issue is expert-reader `FAIL`, repair structure, definitions, transitions, formula explanation, paragraph order, or boundary language before any further polish.
5. Rerun the relevant review check mentally against the repaired section.
6. If the issue remains because information is missing, do not hide it. Return a bounded draft and a short note naming the missing model, evidence, baseline, citation requirement, or reading-experience blocker.

Do not run unlimited polishing cycles. One repair loop is required; a second loop is allowed when the first repair exposes a clear fix. After that, report the blocker.

## Output Discipline

When the draft passes, return manuscript prose first. Do not show the review checklist unless the user asks.

When the draft cannot pass, return:

1. the safest bounded draft, if useful;
2. a short `Cannot call this submission-ready yet` note;
3. the concrete missing item required to pass review.

Do not expose internal labels such as `review-closure gate`, `pass criteria`, or `repair loop` inside the manuscript prose itself.
