# IEEE Letter Technical Core Reference

Use this reference when drafting or rewriting Section II/III of an IEEE power-system Letter: problem statement, compact formulation, derivation, counterexample, analytical note, or solution method.

## Corpus Signal

PowerLit mining of 69 IEEE power-system Letter-style papers found:

- method-like sections in 94.2% of Letters;
- median 3 method-like sections;
- median 23 technical-core paragraphs;
- formula markers concentrated in the technical core;
- median method sentence length about 20 words.

Letters are short, but their technical core is still explicit and equation-bearing. The difference from a full TPWRS paper is not absence of method; it is narrower claim scope.

## Core Rule

A Letter's technical core must support one hard claim. It should not be a compressed full-paper methodology.

Use one of four shapes:

1. Counterexample: minimal system -> assumption/model being challenged -> contradiction or failure mode -> implication.
2. Analytical derivation: setting -> key equation -> derivation -> closed-form or property -> boundary.
3. Compact formulation: decision object -> constraints/objective -> tractability or modeling advantage -> minimal validation hook.
4. Algorithmic trick: bottleneck -> reformulation/update rule -> why it is faster/simpler -> compact numerical check.

## Section II Discipline

Section II should start with the technical object immediately:

- "Consider a ... system with ..."
- "Let ... denote ..."
- "The problem is to ..."
- "The standard model can be written as ..."
- "This letter focuses on the case where ..."

Do not begin with a broad method overview. Do not introduce all notation used in a possible full paper. Define only notation that supports the claim.

## Equation Discipline

Keep the equation chain short:

1. Minimal problem/model.
2. Key transformation, observation, or counterexample.
3. Consequence, property, or solution rule.

Number only equations that are referenced later. If a derivation spans many steps, compress algebra and keep the physically meaningful step in the main text.

## Paragraph Rhythm

Most technical paragraphs should do one job:

- define the setting;
- state the model;
- explain one equation;
- derive one consequence;
- state one boundary;
- connect the result to the Letter claim.

Avoid paragraphs that combine literature positioning, model setup, derivation, algorithm, and validation. That is a full-paper rhythm.

## What To Cut

Remove:

- full nomenclature unless inline definitions are impossible;
- multi-module framework descriptions;
- long proof blocks not central to the claim;
- algorithm pseudocode unless the algorithm is the contribution;
- extensive implementation details;
- secondary case studies that only broaden the story.

Keep:

- the exact assumption or model being tested;
- the one equation, proposition, or construction that carries the claim;
- the minimum numerical or analytical evidence needed for credibility;
- the boundary of validity.
