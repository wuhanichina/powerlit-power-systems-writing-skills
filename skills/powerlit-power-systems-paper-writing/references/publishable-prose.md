# Publishable Prose and Logic Closure

Use this reference for every target venue. The goal is not a fluent draft; the goal is publishable prose in which each sentence closes a technical or evidential link.

## Core Standard

Every sentence must do at least one job:

- define a system object, variable, condition, or boundary;
- expose a technical contradiction;
- state a model, constraint, transformation, or algorithmic action;
- explain why a relation holds;
- connect a result to one claim;
- delimit what the paper does not prove.

Delete sentences that only decorate, defend, announce, or repeat.

## Logic Closure

A publishable paragraph has a closed chain:

`object -> issue -> technical action -> consequence -> evidence/boundary`

Do not leave the reader to infer the missing link. If the method solves a different issue from the paragraph's opening sentence, rewrite the paragraph before polishing.

## Reader-Burden Rule

Use this paragraph discipline when drafting or rewriting: 先亮观点，再给理由；一段一意，五句为限；句句支撑，不跑不散。

- Put the judgment first, then give the reason. Do not make the reader assemble the point from background sentences.
- Keep one paragraph to one idea. Five sentences is the upper bound for ordinary manuscript paragraphs; split when a second idea or evidence chain appears.
- Make every sentence support the local judgment. Delete digressions, bridge sentences, and repeated motivation that do not define, constrain, derive, verify, or delimit the point.
- The result should hand the reader the author's judgment clearly, credibly, and with low processing burden.

## Anti-流水账 Rule

Avoid chronological narration:

- "首先介绍背景，然后建立模型，最后进行验证。"
- "This section first presents the model and then introduces the algorithm."

Replace with causal writing:

- state the modeling difficulty;
- introduce the exact object that resolves it;
- explain the constraint, transformation, or control action;
- show how the case result verifies it.

## Anti-Defensive Rule

Do not write as if apologizing to reviewers:

- "Although the method still has some limitations..."
- "To some extent, the result demonstrates..."
- "This may provide a reference for..."
- "The proposed method has certain practical value..."
- "The method is not intended to replace..."
- "需要强调的是，本文不..."

State the boundary directly:

- "The validation is limited to radial feeders; meshed distribution networks require an additional topology model."
- "The result supports the voltage-security claim, but not real-time deployability."

Use the boundary-posture pass for every claim boundary:

- If the sentence begins with what the paper does not claim, move the positive technical object to the front.
- If the boundary is comparative, name the condition under which the baseline remains strong, then state what the proposed object adds.
- If the paragraph needs a limitation, attach it to evidence scope, case system, assumptions, or metric coverage; do not make the author sound as if retreating from the contribution.

Example:

- Defensive: "This paper does not claim to replace linearized GMM-PLF."
- Publishable: "Linearized GMM-PLF remains the direct accuracy baseline under locally valid linearization; the proposed inverse formulation adds identifiability diagnosis and physical-realizability certification for voltage-domain distribution recovery."

## Precision Pass

Before final output, run three passes internally:

1. Claim pass: every claim maps to a formula, assumption, theorem, case result, or stated boundary.
2. Boundary-posture pass: no manuscript paragraph leads with defensive "not a replacement" language when a positive technical subject is available.
3. Cut pass: remove meta narration, repeated motivation, generic adjectives, and sentences without technical load.
4. Rhythm pass: make the paragraph readable without reducing technical density.

Only return the final manuscript prose unless the user asks to see the reasoning.

## Venue Translation

The same standard appears differently by venue:

- 中国电机工程学报: dense Chinese engineering prose; see `csee-precision.md`.
- 电力系统自动化: compact operational logic; short path from scenario to variables, constraints, algorithm, and metric.
- IEEE TPWRS: formulation-led English; assumptions, constraints, reformulations, and evidence must be explicit.
- IEEE TSG: smart-grid mechanism must remain tied to grid operation, physical constraints, data assumptions, and implementation conditions.

No venue accepts polished vagueness.
