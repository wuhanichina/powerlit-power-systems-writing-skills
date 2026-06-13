# Reader-Experience Pass

Use this reference before returning manuscript prose from `powerlit-power-systems-paper-writing`. This pass is mandatory for every manuscript-facing output, not an optional readability check.

The goal is to make a qualified power-systems reader able to read the manuscript linearly, keep trust in the author's control of the material, and receive the technical judgment with low processing burden.

## Core Rule

Read the produced text in order. Do not use later sentences to excuse an earlier point of confusion. If a later sentence resolves an earlier stall, repair the earlier ordering, definition, transition, or signposting before returning the text.

The final manuscript may be delivered only when:

- no high-impact `[writing]` burden remains unresolved;
- topic-hard passages have enough definitions, transitions, physical intuition, or boundary language for a first read;
- core symbols, abbreviations, equations, units, and cross-references can be followed without avoidable searching;
- positive control signals are real in the prose rather than invented in self-review;
- the draft would reach at least `CONDITIONAL PASS` under the review skill's expert-reader-experience check.

## Reading Burden Sources

Track these while revising:

- symbol or notation drift: one quantity uses multiple symbols, or one symbol refers to different quantities;
- undefined abbreviation: an abbreviation appears before its full name, or the definition is too far from first use;
- formula density: consecutive equations lack words that explain the grid quantity, coupling, feasibility condition, or algorithmic step;
- cross-reference searching: the sentence forces the reader to search backward for a definition, figure, equation, scenario, or metric that should be locally recoverable;
- unit, per-unit, benchmark, or denominator ambiguity;
- narrative drift: a paragraph starts from one technical object but ends by proving, testing, or claiming another;
- empty emphasis: strong words such as significant, effective, robust, comprehensive, or fundamental appear without a metric, condition, or mechanism.

Classify each serious burden as:

- `[writing]`: caused by order, sentence structure, symbol management, missing transition, missing definition, or weak physical intuition. Repair it before delivery.
- `[topic-hard]`: caused by inherent technical complexity. Keep the technical content, but lower the first-read threshold with a definition, transition, physical intuition sentence, or scoped boundary.

## Positive Control Signals

Do not invent positive feedback to balance criticism. Record or preserve only real prose signals:

- precise control: terms, symbols, assumptions, and metrics are consistent and restrained;
- clean mechanism: a difficult relation is explained through the relevant grid object and cause-effect direction;
- useful aha moment: an earlier ambiguity is resolved at the right time;
- sharp boundary: the manuscript states what the evidence supports without defensive posture.

If no clear positive peak exists, repair the prose or acknowledge that the passage has no positive reading peak. Do not call ordinary "followable" prose a strong positive signal.

## Repair Actions

Use the smallest repair that removes the burden:

- move a definition before first use;
- split a paragraph that contains two technical objects;
- add one physical-intuition sentence after a formula group;
- replace empty emphasis with a metric, condition, scenario, or mechanism;
- align the paragraph opening, method action, case evidence, and conclusion boundary;
- add a short transition that names why the next equation, result, or baseline is needed.

Do not add new experiments, baselines, citations, or stronger claims to fix a reading-experience problem. If the missing item is technical evidence, report it as a blocker under the review-closure gate.

## Output Discipline

When the pass succeeds, return manuscript prose first and do not expose this checklist unless the user asks.

When the pass fails, return the safest revised prose if useful, then a short note:

1. `Cannot call this submission-ready yet`;
2. the location of the unresolved reading-experience failure;
3. whether it is `[writing]` or `[topic-hard]`;
4. the concrete item needed to pass.
