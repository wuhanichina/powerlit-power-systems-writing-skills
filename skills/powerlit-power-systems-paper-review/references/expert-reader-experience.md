# Expert Reader-Experience Review

Use this reference in every `powerlit-power-systems-paper-review` review. It evaluates whether a small-field expert can read the paper linearly while maintaining trust in the author's control of the technical object.

This check is mandatory and must appear in the review output as:

`专家级阅读体验`: `PASS`, `CONDITIONAL PASS`, or `FAIL`.

It does not replace novelty, correctness, evidence, or venue-fit review. It reports the expert reader's trust and reading motivation based on the manuscript text.

## Linear Evidence Rule

Read in manuscript order. Each reading-experience finding must be anchored to a concrete section, paragraph, equation, figure, table, or short source phrase.

Do not use later material to erase an earlier stall. If a later passage resolves the stall, record that the manuscript creates a delayed resolution and decide whether the delay is acceptable.

## Tone Boundary

Be sharp about the text, not the author. Allowed:

- "At this point the reader loses the method object because the paragraph moves from voltage distribution recovery to baseline accuracy without a transition."
- "The formula group defines symbols but does not say which grid coupling the equations express."

Not allowed:

- claims about the author's ability, intent, or seriousness;
- declaring an externally checkable field fact as false when the manuscript only gives insufficient evidence;
- using absolute language such as "all", "never", or "completely" without section-level evidence.

## Evidence Classes

Separate two evidence classes:

- `text-internal`: internal contradiction, missing definition, unkept promise, target-method-evidence mismatch, undefined central symbol, unsupported transition, or empty emphasis in the manuscript.
- `external-check-needed`: benchmark representativeness, parameter reasonableness, field-data typicality, or whether a method truly works under a domain condition.

Only `text-internal` failures can by themselves produce an expert-reader `FAIL`. `external-check-needed` findings can lower confidence, but should not be used alone to fail the reading-experience pass.

## PASS Scale

`PASS`:

- a qualified power-systems reader can follow the problem, technical object, method action, evidence, and boundary in order;
- symbols, abbreviations, equations, units, scenarios, and metrics are recoverable without avoidable searching;
- hard technical passages provide enough physical intuition or local signposting;
- positive control signals are visible in precise definitions, restrained claims, and aligned evidence.

`CONDITIONAL PASS`:

- the paper is readable by an expert, but some local repairs are needed;
- burdens are concentrated in secondary passages or are mostly `[topic-hard]`;
- no critical section creates unrecovered confusion about the main technical object;
- the review can name concrete repairs that would likely reach `PASS`.

`FAIL`:

- critical sections create unrecovered reading stalls;
- the introduction, method, evidence, or conclusion appear to follow different technical objects during linear reading;
- central symbols, formulas, assumptions, units, baselines, or metrics are undefined or inconsistent enough to block trust;
- formula density forces the reader to reconstruct the physical mechanism without textual help;
- mathematical preliminaries, proofs, or reviewer-triggered derivations take over the section before the power-system picture and engineering consequence are clear;
- propositions, proofs, algorithms, or property subsections appear abruptly, without a local sentence explaining why the property is needed for the preceding model difficulty and how it enables the next step;
- empty emphasis, generic claims, or defensive posture repeatedly erode confidence;
- positive control signals are absent or too weak to sustain expert reading motivation.

## Output Requirements

In the review output, include:

- status: `PASS`, `CONDITIONAL PASS`, or `FAIL`;
- 2-5 anchored reasons;
- the dominant burden source: `writing`, `topic-hard`, `text-internal logic`, or `external-check-needed`;
- first repair action.

If the status is `FAIL`, do not call the manuscript submission-ready even when the technical review has no fatal correctness issue.
