# Prose Quality Gates

Use this reference before delivery for manuscript prose in any target venue. It consolidates the routine prose, rhythm, lexicon, and anti-AI cleanup passes while preserving the non-negotiable hard gates.

## Core Passes

Run these checks after the technical draft is complete:

1. `Reader-burden cut` (deletion-level): each paragraph should carry one technical function; remove throat-clearing, policy padding, and repeated claims. Enforce this with the sentence-deletion test below, not by feel. This pass owns padding and redundancy only. Structural reading burden — symbol drift, undefined abbreviations, formula density, ordering, missing definitions, and cross-reference searching (the `[writing]`/`[topic-hard]` classes) — is owned by `reader-experience-pass.md`; do not duplicate that classification here.
2. `Progression and non-repetition pass`: every retained sentence must add one new payload to the local argument. Adjacent sentences must not restate the same motivation, contribution, effectiveness claim, or boundary in different words.
3. `Rhythm pass`: vary sentence length only to improve traceability; keep technical subjects visible and avoid stacked abstractions.
4. `Lexicon pass`: replace generic academic verbs with domain actions such as formulate, constrain, estimate, screen, certify, allocate, or dispatch when the evidence supports them.
5. `Boundary-posture pass`: state the positive technical scope first; move limitations to scoped boundary sentences instead of opening with defensive disclaimers.
6. `Non-binary manuscript framing pass`: do not write manuscript prose as a binary opposition such as "the evidence supports A but does not support B", "本文支持...但不支持...", or "X is valid while Y is invalid" unless the section is explicitly a limitation, ablation failure, or review response. Convert evidence boundaries into positive technical scope, conditional applicability, observed phenomena, boundary evidence, or future-work needs.
7. `Physical-story pass`: check that the paragraph moves from the power-system object and operating conflict to the mathematical or algorithmic object, not from abstract theory to after-the-fact engineering decoration.
8. `Reviewer-comment integration pass`: when editing after review, remove rebuttal-shaped prose from the manuscript body. The reviewer's concern should appear only as a clearer assumption, physical mechanism, comparison, evidence boundary, or scoped conclusion.
9. `Engineering-math balance pass`: keep derivation depth proportional to the venue and claim. Do not add complete proof-style exposition when a physical interpretation, validity condition, and evidence link would be the publishable engineering explanation.
10. `Working-language firewall`: remove internal drafting labels from manuscript prose, including `closest competitor`, `claim boundary`, `citation pack`, `evidence-strength profile`, `gap-to-contribution map`, `PowerLit evidence`, and similar process labels. This firewall applies only to manuscript-facing prose. In prewriting, planning, and `写作前确认` responses these labels are the intended user-facing diagnostic structure and must be kept, not removed.
11. `Evidence-verb calibration`: select the strongest verb licensed by the
    evidence ladder below; a stronger verb requires stronger evidence, not more
    confident prose.

## Power-System Evidence-to-Verb Ladder

| Evidence available | Licensed verbs | Do not upgrade to |
| --- | --- | --- |
| Definition or formulation only | defines, formulates, represents, incorporates | proves, guarantees, validates |
| Analytic derivation under stated assumptions | derives, establishes under, characterizes, bounds | universally proves, guarantees outside assumptions |
| Formal proof/certificate | proves, guarantees, certifies, establishes | demonstrates field performance |
| One coherent simulation or benchmark | shows in the tested case, reproduces, yields, is consistent with | proves, validates generally, ensures deployment |
| Multi-case/repeated simulation with fair baselines | demonstrates across tested cases, consistently reduces under, outperforms under matched conditions | establishes universal superiority, guarantees robustness |
| Ablation/intervention/mechanism isolation | attributes, isolates, indicates that the gain arises from | proves causality outside the intervention design |
| Statistical association | is associated with, correlates with, predicts within the evaluated data | causes, explains mechanistically |
| Field/operational data with protocol | observes in, validates against measured data, demonstrates for the monitored system | validates all systems, guarantees operation |

`significantly` is licensed only by an explicit statistical test or a clearly
defined engineering-significance threshold. `Robust`, `scalable`, `real-time`,
and `deployable` require tests of perturbation, scale, timing, and deployment
conditions respectively. If evidence types conflict, use the weaker verb and
state the tested scope.

## Sentence-Deletion Test (mandatory, all venues)

This is the mechanical form of the reader-burden cut. It is designed so that a model relying on intent and a model relying on rules delete the same sentences. Apply it sentence by sentence to introduction, method, and result/discussion prose.

### The test

For each sentence, check whether it carries at least one of these payloads:

- names or constrains a power-system object (grid, device, market, uncertainty source, control layer);
- defines or relates a variable, set, assumption, or constraint;
- states a mechanism or causal link (why something happens or holds);
- reports or interprets evidence (system, scenario, metric, comparison, boundary);
- draws a contrast with a specific prior method or alternative.

If a sentence carries none of these, it is padding. Delete it or merge its only useful fragment into an adjacent payload-bearing sentence. Do not keep a sentence because it "reads smoothly" or "provides transition" — a transition that carries no payload is padding.

### High-frequency padding to delete on sight

- importance/value statements: "...具有重要意义", "plays a vital role", "is of great significance";
- restatements of the obvious: "众所周知", "it is well known that", "随着...的发展";
- empty method praise: "本文方法具有良好的效果", "the proposed method is effective and efficient" (without metric/baseline/condition);
- forward-reference filler: "下面将详细介绍", "in what follows, we discuss" (let the structure do this);
- summary sentences that only repeat the previous sentence in different words.

### Venue-licensed closing summary

One pattern needs section-level scope rather than deletion on sight. In Chinese venues the validation summary sentence — "最后，基于 [系统/平台] 验证了所提 [对象] 的 [有效性/可行性/正确性/优越性/准确性]" — is a real convention in the abstract's final sentence and in `结语`/`结论`. Measured on the bundled PowerLit index, 39.8% of 电力系统自动化 abstracts (214/538) contain this pattern and 92.5% of those instances are the abstract's last sentence; in 中国电机工程学报 it is 5.2% (42/802). Keep it where the venue uses it, and keep the corpus form: name the case system or validation platform and the object being validated.

It remains padding, and must be cut, when it is the payload of a case-study result paragraph, a figure or table interpretation, or a contribution item — locations where the metric, comparison, and condition are what the reader came for. A bare "所提方法具有良好的效果" with no system, platform, or object attached fails in every location.

### Borderline rule

A sentence that carries a payload but also drags padding should be cut down to the payload, not deleted whole. A sentence whose only function is to announce what the paper "aims to" or "tries to" do should be rewritten as the direct technical action.

### Quota guidance

If applying the test to a paragraph deletes nothing, re-read more strictly: well-edited power-system prose almost always has at least one cuttable sentence per draft paragraph. If the test would delete more than half a paragraph, the paragraph was padding-dominated and should be rebuilt around its single real payload.

## Sentence-Tightening Test (mandatory, all venues)

The deletion test removes whole sentences. This test attacks the more common problem: a sentence that earns its place but says its payload with too many words. "废话多" usually shows up here as low information density, not as extra sentences. Apply this to every retained sentence.

### The test

For each retained sentence, ask: "Can the same technical payload survive in fewer words without losing object, condition, mechanism, or evidence?" If yes, tighten it. The target is information density, not minimum length — a long sentence that is fully load-bearing passes; a short sentence padded with hedges fails.

### Tighten on sight

- redundant lead-ins: "值得注意的是", "需要指出的是", "it is worth noting that", "it should be pointed out that" — delete, keep the clause after them;
- stacked hedges: "可能在一定程度上有助于" → "有助于" or a stated condition; "may potentially help to some extent" → "helps under [condition]";
- nominalization padding: "对...进行分析/优化/处理" → "分析/优化/处理..."; "perform an analysis of" → "analyze";
- empty intensifiers: "非常", "极大地", "显著地" (without a number), "very", "greatly", "significantly" (without a metric) — delete or replace with the measured value;
- double statement: a clause that restates the previous clause in synonyms — keep one;
- ">2 的 的-chains" before the verb (Chinese) or ">2 prepositional phrases before the main verb (English): rewrite around the technical subject;
- circular phrasing: "通过...的方式来实现...的目的" → name the action directly.

### Density check

After tightening, the sentence should read as: subject (technical object) + action/relation + object/condition + (evidence or bound). If a reader cannot find the technical subject within the first few words, the sentence is still circling — rewrite subject-first.

### Boundary

Tightening must not delete a real qualifier that bounds a claim. "在台风条件下" or "under N-1 contingencies" is payload, not padding. Cut hedges and filler, never the conditions that keep a claim honest.

## Progression And Non-Repetition Gate (mandatory, all venues)

After deletion and tightening, read each paragraph as a sequence of sentence functions. The paragraph passes only if each sentence changes the argument state.

### One sentence, one new payload

Assign one primary function to every sentence:

- object or condition;
- unresolved conflict;
- prior-method limitation;
- model or algorithm action;
- mechanism or causal relation;
- evidence interpretation;
- comparison;
- scoped boundary.

A sentence may contain a condition or qualifier, but it should not try to motivate, define, claim, and defend at the same time. If it carries several unrelated functions, split or rewrite around the function needed at that location. If it carries no new function, delete it.

### No adjacent duplicate function

Two adjacent sentences fail when they:

- repeat the same motivation with different adjectives;
- restate the same contribution as "method", "framework", "strategy", and "approach";
- describe effectiveness twice without adding a new metric, baseline, system, or condition;
- give a limitation and then repeat the same limitation as a boundary sentence;
- use a transition sentence whose only payload is that the next sentence will continue the topic.

Keep the sentence with the stronger technical subject. Merge any unique condition, metric, or boundary from the weaker sentence into it.

### Adjective replacement rule

Adjectives and adverbs such as important, significant, effective, robust, accurate, comprehensive, novel, valuable, greatly, and clearly are not payload. Keep them only when the same sentence gives the measured metric, comparison target, operating condition, or reviewable mechanism that makes the modifier true. Otherwise delete the modifier or replace it with the measurable content.

### Corpus consistency check

When PowerLit exemplars were used, compare the paragraph against the internal `Corpus progression pattern`, not against source wording. The draft should preserve the learned movement of functions while using the current manuscript's own object, variables, evidence, and boundary. If the paragraph has more sentences than the learned function sequence requires, delete or merge until every sentence advances a distinct step.

## Non-Binary Manuscript Framing Gate (mandatory, manuscript prose)

Formal paper text should not inherit prewriting or gate language as a binary opposition. The manuscript must tell the strongest bounded technical story, not list what the project can and cannot claim.

### Failing pattern

Reject manuscript-facing sentences that use these patterns as the main contribution or result wording:

- "the evidence supports X but does not support Y";
- "本文支持/验证了...，但不支持...";
- "X can be claimed, while Y cannot be claimed";
- "the method is not A, not B, and not C" outside a dedicated limitation paragraph;
- "only X is supported" when the sentence could instead name X's technical scope, mechanism, condition, and manuscript role.

These patterns may appear in internal notes, review verdicts, rebuttal planning, or explicit limitations sections. They should not carry the title, abstract, contribution list, introduction close, result topic sentence, or conclusion.

### Rewrite pattern

Convert binary boundaries into one of these manuscript-safe forms:

- **positive technical scope:** "The method converts [conditioned input] into [technical output] for [bounded use]."
- **conditional applicability:** "Under [event set/assumption/model boundary], the result characterizes [mechanism or decision]."
- **observed phenomenon:** "The retained cases reveal [phenomenon], which motivates [model choice or diagnostic]."
- **boundary evidence:** "The comparison positions the method as [scoped role] rather than [broader role]."
- **future-work need:** "Extending the claim to [broader object] requires [specific experiment/data/proof]."

Keep the boundary, but do not make the boundary the sentence's main subject unless the section is explicitly about limitations. In ordinary manuscript prose, lead with the power-system object, mechanism, method action, or evidence role.

### Scope preservation

Removing defensive posture must not widen a claim. After the rewrite, the tested system, scenario, event set, assumption, information condition, or metric definition that bounded the original sentence must still be recoverable somewhere a reader will reach before relying on the claim — the same sentence, the adjacent sentence, or the section that owns that condition. If a rewrite can only be made confident by dropping the condition, keep the condition and accept the longer sentence. Turning "本文不主张替代 X" into an unconditional capability sentence is a failure of this gate, not a success of the boundary-posture pass.

## Chinese Register Gate

For CSEE and AEPS prose:

- remove `声称` and `宣称` from manuscript claims;
- remove quotation marks used only for emphasis, concept packaging, or self-conscious terminology;
- replace em-dash explanation chains with commas, semicolons, parentheses, or direct enumeration;
- keep a colon for a displayed equation, genuine list, or deliberate parallel mechanism statement; rewrite colons that merely introduce a complete causal explanation, rhetorical question, or ordinary continuation;
- scan translation-shaped constructions such as an unnecessary passive, `成为...的函数`, `位于不同层面`, distant `其`, and stacked prepositions; replace them only when a direct power-systems subject and verb preserve the precise mathematical meaning;
- keep dense engineering nouns only when the sentence also names the grid object, variable, constraint, metric, or mechanism.

For major Chinese revision, apply the fuller source-authority, defensive-posture, punctuation, and translation-shape procedure in `chinese-major-revision.md`. Treat manuscript-specific terminology replacements as entries in that paper's terminology ledger, not as universal bans.

## English AI-Tells Gate

For IEEE prose:

- avoid generic phrases such as `state-of-the-art`, `comprehensive framework`, `significant improvements`, and `robust performance` unless the evidence names the metric, baseline, and condition;
- avoid meta-writing about what the paper "aims to" do when a direct technical action sentence is possible;
- do not use quotation marks to make ordinary technical terms look novel.

## No-Invention Boundary

Prose cleanup must not add citations, methods, numerical results, baselines, solver settings, or conclusions. If the clean sentence would require a missing fact, leave a gap note instead of filling it.

The same boundary covers physical explanation. Do not add or strengthen a physical mechanism, cause-effect direction, propagation path, identifiability reading, dominance argument, or limiting-case degeneration that the supplied model, data, or references do not support. A mechanism invented during polishing is harder to detect than an invented number and survives review more often. Keep the status discipline in `method-model.md`: `model-derivable`, `consistent-with-model`, or an `unverified interpretation` reported in the delivery note.
