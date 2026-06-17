# Prose Quality Gates

Use this reference before delivery for manuscript prose in any target venue. It consolidates the routine prose, rhythm, lexicon, and anti-AI cleanup passes while preserving the non-negotiable hard gates.

## Core Passes

Run these checks after the technical draft is complete:

1. `Reader-burden cut`: each paragraph should carry one technical function; remove throat-clearing, policy padding, and repeated claims.
2. `Rhythm pass`: vary sentence length only to improve traceability; keep technical subjects visible and avoid stacked abstractions.
3. `Lexicon pass`: replace generic academic verbs with domain actions such as formulate, constrain, estimate, screen, certify, allocate, or dispatch when the evidence supports them.
4. `Boundary-posture pass`: state the positive technical scope first; move limitations to scoped boundary sentences instead of opening with defensive disclaimers.
5. `Physical-story pass`: check that the paragraph moves from the power-system object and operating conflict to the mathematical or algorithmic object, not from abstract theory to after-the-fact engineering decoration.
6. `Reviewer-comment integration pass`: when editing after review, remove rebuttal-shaped prose from the manuscript body. The reviewer's concern should appear only as a clearer assumption, physical mechanism, comparison, evidence boundary, or scoped conclusion.
7. `Engineering-math balance pass`: keep derivation depth proportional to the venue and claim. Do not add complete proof-style exposition when a physical interpretation, validity condition, and evidence link would be the publishable engineering explanation.
8. `Working-language firewall`: remove internal drafting labels from manuscript prose, including `closest competitor`, `claim boundary`, `citation pack`, `evidence-strength profile`, `gap-to-contribution map`, `PowerLit evidence`, and similar process labels.

## Chinese Register Gate

For CSEE and AEPS prose:

- remove `声称` and `宣称` from manuscript claims;
- remove quotation marks used only for emphasis, concept packaging, or self-conscious terminology;
- replace em-dash explanation chains with commas, semicolons, parentheses, or direct enumeration;
- keep dense engineering nouns only when the sentence also names the grid object, variable, constraint, metric, or mechanism.

## English AI-Tells Gate

For IEEE prose:

- avoid generic phrases such as `state-of-the-art`, `comprehensive framework`, `significant improvements`, and `robust performance` unless the evidence names the metric, baseline, and condition;
- avoid meta-writing about what the paper "aims to" do when a direct technical action sentence is possible;
- do not use quotation marks to make ordinary technical terms look novel.

## No-Invention Boundary

Prose cleanup must not add citations, methods, numerical results, baselines, solver settings, or conclusions. If the clean sentence would require a missing fact, leave a gap note instead of filling it.
