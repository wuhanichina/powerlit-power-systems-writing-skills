# Published-Paper Rhythm Reference

This reference is based on deeper rhythm mining of PowerLit JSON papers:

- 中国电机工程学报: 802 papers.
- 电力系统自动化: 538 papers.
- IEEE TPWRS: 661 papers, 621 extracted abstracts.
- IEEE TSG: 209 full papers in the TPWRS comparison corpus.

## Main Finding

Formal power-system papers do not read well because every sentence is short. They read well because information arrives in a stable order.

For Chinese journals, rhythm is built by long technical sentences with visible internal beats. A Chinese abstract often has only 4-5 full sentences by period punctuation, but about 6 information clauses when semicolons are counted. The sentence is long, but the reader can follow it because "首先/其次/然后/最后", "针对", "为此", "然而", and "结果表明" mark the turns.

For IEEE Transactions papers, rhythm is built by short-to-medium sentences. The median abstract sentence is about 23 words. Most sentences carry one technical action: formulate, reformulate, derive, enforce, solve, learn, estimate, coordinate, or validate.

## Abstract Rhythm

### 中国电机工程学报

Typical beat:

1. Engineering problem or limitation.
2. Proposed model/control/topology/strategy.
3. Mechanism or model construction.
4. Solution/control/simulation arrangement.
5. Result and engineering implication.

Length tendency:

- Full sentences: median about 4.
- Information clauses: median about 6.
- Sentence length: median about 60 Chinese characters; early technical sentences are often longer than final evidence sentences.

Writing rule:

- Use one long sentence only if it contains a clear internal order.
- Let the final evidence sentence shorten slightly and name the tested system or metric.

### 电力系统自动化

Typical beat:

1. Operational problem.
2. Proposed model/strategy.
3. Modeling step.
4. Solution or coordination step.
5. Case verification.

Length tendency:

- Full sentences: median about 5.
- Information clauses: median about 6.
- Sentence length: median about 51 Chinese characters.

Writing rule:

- This venue accepts explicit procedural rhythm, but prefers tighter sentences than 中国电机工程学报.
- Keep "首先/然后/最后" for real model-solution-evidence progression, not for generic writing actions.

### IEEE TPWRS / TSG

Typical TPWRS beat:

1. System setting and operational issue.
2. Technical object of the paper.
3. Formulation/model.
4. Reformulation/algorithm/guarantee.
5. Case-study evidence.

Typical TSG beat:

1. Smart-grid setting and operational issue.
2. Technical object: data-driven model, distributed controller, estimator, cyber-physical detector, or DER coordination mechanism.
3. Physical/information structure.
4. Learning/control/optimization mechanism.
5. Grid-side evidence.

Length tendency:

- Abstract sentences: median about 8.
- Sentence length: median about 23 words, with most sentences around 18-29 words.

Writing rule:

- Use one sentence for one technical action.
- Prefer subject-led sentences: "The reformulation...", "The affine policy...", "Numerical tests...".
- For TSG, prefer subjects such as "The distributed controller...", "The data-driven estimator...", "The communication constraint...", and "The DER coordination scheme...".
- Use "This paper" once if useful, then shift subjects to the model, constraints, algorithm, and results.

## Introduction Rhythm

Good introductions move in waves:

1. Known system context.
2. Operational consequence.
3. Prior method class.
4. Limitation and technical reason.
5. Proposed object.
6. Contributions or validation boundary.

For Chinese venues, introduction paragraphs in the corpus often have about 3 sentences. The first sentence sets the object; the middle sentence carries literature or limitation; the last sentence points to the gap or transition. The rhythm is less "short-short-short" and more "known -> contrast -> narrowing".

For IEEE Transactions papers, introduction paragraphs also cluster around 3 sentences, but each sentence is shorter. "However" is the dominant contrast marker; "to address" marks the transition to the proposed work. For TSG, keep data/learning/distributed/cyber clauses attached to grid operation rather than letting them become standalone algorithm claims.

## Method Rhythm

Method sections should be denser and less rhetorical.

Use this order:

1. Define object, set, index, variable, or device state.
2. State physical or operational relation.
3. Give equation or constraint.
4. Explain what the equation enforces.
5. Move to the next component.

Avoid motivation at every paragraph. Once the section has entered the model, let equations and variable meaning drive the rhythm.

## Case-Study Rhythm

Case sections should alternate setup and result:

1. System and scenario.
2. Parameter or baseline.
3. Result table/figure.
4. Interpretation tied to one claim.
5. Sensitivity or boundary.

Do not put three unrelated results in one paragraph. A readable result paragraph usually has one numerical message.

## Sentence-Level Rules

Chinese:

- Use 45-70 Chinese characters as the default sentence band.
- Use longer sentences only for model chains with internal markers.
- Use short sentences for result interpretation or boundary statements.
- If a sentence has more than two "的" chains before the verb, rewrite around the technical subject.

English:

- Keep most sentences between 18 and 30 words.
- Avoid stacking more than two prepositional phrases before the main verb.
- Start sentences with the technical subject rather than "In this paper" repeatedly.
- Use contrast markers sparingly; one "However" should introduce a real limitation.

## Anti-Rhythm Patterns

Avoid:

- repeated "本文首先/本文其次/本文最后" at paragraph starts,
- multiple abstract sentences that all start with "提出/构建/设计",
- long Chinese sentences without semicolon-level internal beats,
- IEEE Transactions sentences over 35 words with three or more clauses,
- result paragraphs that say "有效性和优越性" without naming the metric,
- meta transitions such as "下面将详细介绍".

## Practical Rewrite Pass

After drafting, mark every sentence with one of these roles:

- context,
- problem,
- prior,
- gap,
- method,
- mechanism,
- evidence,
- boundary.

Then check the rhythm:

- Abstract should move toward evidence, not circle around motivation.
- Introduction should alternate prior and gap instead of listing references.
- Method should alternate definition and enforcement.
- Case study should alternate setup and numerical interpretation.
