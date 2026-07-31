# Chinese Major-Revision Practice

Use this reference for a major revision of a Chinese power-systems manuscript, especially when the task includes multiple manuscript versions, an author-written style sample, extensive restructuring, terminology cleanup, or a full-paper consistency pass.

This file owns the revision procedure. Keep section-construction detail in the existing authority files:

- cross-section promises and manuscript spine: `manuscript-section-quality.md`;
- equations, method exposition, and parameter placement: `method-model.md`;
- result interpretation and causal attribution: `figures-tables-results.md`;
- Chinese register and sentence cleanup: `prose-quality-gates.md`;
- deterministic final checks: `submission-consistency-check.md`.

## Navigation

- Portability Boundary
- Build a Source-Authority Map
- Diagnose Before Rewriting
- Lock Promises and Body Landings
- Rebuild the Main Body Around Technical Logic
- Weave Physical Intuition Through Equations
- Separate Observation From Causal Explanation
- Run the Chinese Revision Pass
- Close the Revision Mechanically

## Portability Boundary

Extract reusable decision rules from project experience; do not turn one paper's terminology choices into universal bans.

- Treat a project-specific replacement such as changing one control term, storage label, or matrix subscript as an entry in that manuscript's terminology ledger.
- Promote a rule to this skill only when it applies across research objects, such as separating style authority from technical authority, requiring a body landing for an abstract promise, or isolating a causal factor in a case study.
- Preserve a technically valid term when another paper uses it correctly. Do not blacklist a term merely because it was inaccurate in one manuscript.

## Build a Source-Authority Map

When several files describe the same paper, assign authority before merging prose.

| Source role | Controls | Must not control |
| --- | --- | --- |
| Current technical manuscript, equations, data, and verified results | research object, model, symbols, parameters, evidence, claim boundary | authorial rhythm when a better author sample exists |
| Author-written manuscript or prose sample | sentence movement, paragraph entry, punctuation habits, preferred technical subjects, compression pattern | equations, results, or a different technical framework |
| PowerLit and supplied literature | field facts, method-family positioning, citation function, venue-normal terminology and evidence expectations | current-project facts or distinctive source sentences |
| Reviewer comments and revision notes | defects to repair and scope to clarify | manuscript-facing defensive language |
| Target-venue profile | register, section emphasis, evidence granularity | a new research object absent from the project |

Create an internal ledger with `source`, `authority`, `allowed use`, `forbidden transfer`, and `conflict resolution`.

When two versions use different technical frameworks, borrow only clean-room writing functions from the style source. Do not transplant its model names, assumptions, symbols, mechanism claims, or evidence. Resolve factual conflicts from the current equations, data, and verified evidence rather than from the more fluent version.

Derive an author-style profile from recurring functions rather than copying sentences:

- abstract movement and sentence count;
- preferred subject placement;
- mechanism sentence structure;
- paragraph opening and transition behavior;
- punctuation and enumeration habits;
- recurring compression choices;
- canonical terms and Chinese-English pairs.

Never expose an author name as a prose template, and never copy a distinctive source sentence merely to reproduce the style.

## Diagnose Before Rewriting

Classify the manuscript's main failure before changing sentences:

1. `story`: theoretical or engineering value is hidden behind implementation details;
2. `spine`: abstract, introduction, contribution list, body, results, and conclusion promise different objects;
3. `landing`: a mechanism, concept, or contribution is announced but never developed or verified;
4. `exposition`: equations are defined but their physical motivation and consequence are absent;
5. `causality`: one case factor is made to explain several mechanisms without controls;
6. `register`: defensive prose, translation-shaped Chinese, or punctuation habits obscure the technical relation;
7. `mechanical`: terms, symbols, numbers, references, or numbering drift after revision.

Repair in that order. Do not begin with sentence polishing when the story, spine, or claim landing is still broken.

When the user asks for diagnosis or wants to approve a broad rewrite, return a change map before editing. Include the material to retain, move, compress, delete, or add, with the technical reason for each major change. When the user explicitly authorizes direct rewriting or best judgment, proceed without an extra stop but keep the requested scope and report any additional suggestions separately.

## Lock Promises and Body Landings

Use the promise-to-landing matrix in `manuscript-section-quality.md`.

- Give every abstract concept and contribution item a body location.
- Require a claimed mechanism to appear as a model relation, dedicated analysis, or other explicit technical development, then require case evidence or a scoped theoretical argument to close it.
- Align the abstract movement, introduction contribution order, main-section order, result order, and conclusion order. Align functions and objects, not exact wording.
- Write each contribution item as a technical object plus its mechanism, property, or engineering consequence. Keep representative days, solver settings, data splits, pressure windows, parameter scans, and other experiment inventory out of the contribution list.
- Delete, narrow, or explicitly mark a promise when no supported body landing exists. Do not preserve it because it sounds innovative.

## Rebuild the Main Body Around Technical Logic

Prefer theory or mechanism before implementation details when the theoretical object is part of the contribution.

- Put problem definition and theoretical basis before the objective function or solver when those later objects depend on the theory.
- Introduce each major section with a load-bearing transition: identify the unresolved relation inherited from the preceding section, the object resolved here, and what the result enables next.
- Do not use empty navigation such as `本章将介绍...`. Let the power-system object, conflict, or previous finding carry the transition.
- Keep generic symbols and model relations in the method section. Move case-specific constants and routine settings to the case setup, parameter table, appendix, or supplement unless the value defines the method or validity condition.
- Put software, solver version, initialization, iteration traces, and hardware in the reproducibility or computational-performance location where they affect a claim.

## Weave Physical Intuition Through Equations

Apply the `why -> what it means -> how it connects` discipline from `method-model.md`.

- Before a key equation, state the physical or engineering reason that makes this mathematical description necessary.
- After the equation, define symbols locally, then explain what grid quantity, propagation path, constraint cost, feasibility boundary, or diagnostic relation the equation reveals.
- At the section transition, state how that result creates the next modeling need or evidence expectation.

Weave the explanation into the causal flow. Avoid answer-defense forms such as `之所以采用...是因为...`, `需要指出的是，其物理意义为...`, or a detached paragraph whose only subject is `该式的作用`. Prefer a technical subject joined by `由于`, `因此`, `从而`, `而非`, or a direct cause-effect relation.

Treat a cold opening such as `设...为` or `在...点线性化，有` as a diagnostic signal, not an automatic deletion rule. Keep it when the physical motivation is already locally recoverable; otherwise add the missing reason before the equation.

## Separate Observation From Causal Explanation

Design and write case studies so each mechanism has a reviewable comparison.

- State the pre-result physical expectation before reading the plotted result.
- Separate factors that can independently produce the same pattern. Vary one factor at a time or use an ablation, matched baseline, stratification, or counterfactual comparison.
- Do not let one test case simultaneously prove mechanism origin, location effect, capacity effect, nonlinear effect, and superiority without controls.
- Report the observation first, then the isolated mechanism evidence. If the current figure cannot isolate the mechanism, label the explanation as a hypothesis or consistency check rather than a causal finding.
- Map each principal result back to the mechanism or contribution it was designed to test.

## Run the Chinese Revision Pass

Preserve precise technical Chinese and remove revision-shaped prose.

### Defensive posture

For each boundary sentence, ask whether it communicates a model boundary or merely anticipates reviewer attack.

- Keep the technical boundary, assumption, convergence target, or applicability condition.
- Rewrite it with a positive technical subject and scoped condition.
- Delete pure disclaimers that add no model, evidence, or applicability information.

### Colon discipline

Keep a colon when it introduces:

- a displayed equation;
- a genuine list;
- a deliberate parallel mechanism statement.

Rewrite a colon that introduces a complete causal explanation, a rhetorical question, or ordinary continuation. Use a direct sentence, `即`, a comma, or a split sentence as the relation requires.

### Translation-shaped Chinese

Scan for constructions that hide the technical subject or imitate English syntax:

- passive sentences with no reason for suppressing the actor;
- `成为...的函数` when the intended meaning is simply `随...变化`;
- `位于不同层面` when the manuscript can name the quantities affected;
- distant `其` references;
- stacked prepositions;
- literal `out-of-sample`, `need not`, or similar imported structures when a normal power-systems term exists;
- noun-heavy phrases where a direct technical verb is clearer.

Treat these as diagnostics, not blind replacements. Preserve the original term when it is the precise mathematical meaning.

## Close the Revision Mechanically

Run `submission-consistency-check.md` after any structural, terminology, formula, citation, or result change.

At minimum:

1. scan old terms, forbidden aliases, and obsolete symbols for zero unintended residue;
2. verify equation, section, figure, and table numbering and every in-text reference;
3. reject formula references that point forward to an equation not yet introduced; distinguish them from acceptable section-level navigation;
4. rebuild citation order when the target venue numbers references by first appearance;
5. verify that a terminology replacement also updates symbols, subscripts, captions, legends, and English titles;
6. compare every headline number with one coherent result run and denominator;
7. scan generated or converted text for malformed LaTeX, control characters, and fragments such as `rac{` that may indicate a lost backslash;
8. confirm that abstract promises, contribution items, body sections, result evidence, and conclusion findings remain closed after the edits.

Do not declare the manuscript clean because the revised passages read well. A major revision closes only when both the argument and the mechanical references pass.
