# Corpus-Grounded Drafting

Use this reference whenever a task needs introduction writing, related-work synthesis, novelty framing, citation planning, or venue adaptation. The repository's advantage is not generic academic style; it is access to a real PowerLit corpus and venue-specific structure signals.

## Access Gate

Resolve PowerLit through `powerlit-power-systems-literature-intelligence`:

1. User-supplied path.
2. `POWERLIT_JSON_ROOT`.
3. `POWERLIT_LITERATURE_JSON`.

If the corpus is accessible, use it before drafting citation-sensitive prose. If it is not accessible, state `PowerLit unavailable; using fallback non-corpus workflow` once and continue only with supplied references, citation slots, or literature-limited wording.

For shell-backed retrieval, use the skill-bundled `assets/powerlit-index` SQLite cache before raw corpus search. Explicit script parameters and `POWERLIT_INDEX_ROOT` may override it; raw JSON fallback runs only when a raw corpus root is explicitly configured.

For recurring research directions, first consult `skills/powerlit-power-systems-literature-intelligence/references/method-canon.json`. Use verified accepted entries to identify foundational papers, method-family exemplars, and evidence-bar anchors. Then search the main PowerLit corpus for current nearest neighbors, target-venue papers, and project-specific novelty threats.

Do not treat the benchmark paper set as recall coverage. It is a curated quality anchor; final novelty and citation coverage still come from the main corpus or user-supplied references.

Respect canon usage policy:

- `powerlit_status=in_corpus` with `usage_policy=citation_and_pattern`: the entry may be cited and its retrieved PowerLit record may be used for evidence-bar, structure, and style-pattern extraction.
- `powerlit_status=out_of_corpus` with `usage_policy=citation_only`: the entry may be used only for bibliographic positioning; do not summarize its content or extract prose/evidence patterns.
- Entries without verified DOI metadata and accepted curation status are pending candidates only; do not cite them in manuscript prose.

## Search Contract

When shell access is available, the lightweight retrieval interface is:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File `
  skills\powerlit-power-systems-literature-intelligence\scripts\Search-PowerLitJson.ps1 `
  -Query "<technical query>" `
  -VenueFolder ieee_tsg `
  -Top 10
```

Use `-VenueFolder` when the target venue is known. Valid top-level venue folders in the current corpus include `ieee_tsg`, `ieee_tpwrs`, `中国电机工程学报`, `电力系统自动化`, `mpce`, `ijepes`, `applied_energy`, `energy`, `ieee_tpwrd`, and `电网技术`. Widen only after the target-venue search is too sparse or the problem is cross-venue.

## Writing-Time Corpus Reference

PowerLit is not only for citation lookup. When the task asks for writing, rewriting, venue adaptation, or "make it read like TSG/TPWRS/CSEE/AEPS", use retrieved venue-near papers as writing references:

- section order: where the venue usually places problem formulation, method, algorithm, case study, and conclusion;
- paragraph function: what each paragraph does in the introduction, method transition, evidence discussion, and conclusion;
- sentence rhythm: how long technical sentences are, what becomes the grammatical subject, and how contrast markers are used;
- contribution placement: whether the venue expects explicit contribution bullets, technical-action sentences, or compact proposal paragraphs;
- evidence presentation: how systems, baselines, metrics, solver settings, sensitivity checks, and limitations are stated;
- boundary language: how the paper states what was demonstrated and what remains outside scope.

Use 3 to 5 retrieved exemplars when possible. Prefer papers from the target venue and similar technical object. If exact matches are sparse, use one or two mechanism-near papers plus the static venue profile.

Do not copy sentences, phrases, abstracts, or paragraph templates from the corpus. Extract functions and patterns, then write new prose around the current manuscript's own model, variables, results, and claim boundary.

## Corpus Pattern Extraction Pass

PowerLit exemplars should be learned as abstract writing moves, not as source text. Before drafting venue-sensitive prose, extract a compact pattern note from 3 to 5 venue-near papers:

- `section_move`: how the section advances from object, condition, conflict, method action, mechanism, evidence, and boundary;
- `paragraph_function`: the single job of each paragraph, such as motivating a conflict, narrowing a literature gap, defining a model object, interpreting a table, or bounding a conclusion;
- `sentence_payload_sequence`: the new payload added by each sentence. Adjacent sentences should not perform the same job in different words;
- `grammatical_subject`: what accepted papers put in subject position: grid object, variable, constraint, uncertainty source, model component, baseline, metric, or result;
- `contrast_operator`: how contrast is introduced, and whether it is tied to a named prior method, operating condition, metric, or modeling limitation;
- `evidence_sentence_shape`: how system, scenario, baseline, metric, and interpretation appear in one or two load-bearing sentences;
- `boundary_sentence_shape`: how the paper states demonstrated scope without defensive hedging or inflated significance language.

Then draft from the extracted functions only. A useful pattern looks like `object/condition -> unresolved conflict -> existing-method limitation -> proposed technical action -> mechanism -> evidence/boundary`. It is not a sentence template and it must not preserve the source paper's wording, order quirks, or distinctive phrasing.

For each paragraph, build a one-line progression plan before writing. The plan must contain no duplicate payload. If two planned sentences both say "the method is useful", "the gap is important", "the result verifies effectiveness", or "the paper contributes", merge them into one technical sentence with the object, condition, metric, or contrast named.

High-quality corpus prose is usually concise because every sentence changes the reader's state. Learn that discipline first. Do not learn decorative habits, broad motivation, author-specific rhetoric, or repeated contribution wording even if they appear in an accepted paper.

## Terminology Learning Pass

PowerLit should also teach technical terminology. Before drafting or rewriting terminology-sensitive prose, extract a `Corpus terminology map` from venue-near papers and method-family anchors:

- `canonical_term`: the term used for the same power-system object, problem class, method family, mathematical object, metric, baseline, protocol, scenario, or boundary;
- `allowed_abbreviation`: abbreviation introduced once after the full term, with the venue's capitalization and hyphenation;
- `cn_en_pair`: Chinese-English pair when drafting in Chinese under IEEE logic or translating between Chinese and English;
- `source_scope`: whether the term comes from the project evidence, a PowerLit in-corpus exemplar, an accepted method-canon entry, or a user-supplied reference;
- `forbidden_aliases`: near-synonyms that should not be used for the same object in this manuscript;
- `scope_note`: the condition under which the term is valid, so a narrow screening method is not renamed as broad assessment, operation, planning, control, or validation.

Use one canonical term for one technical object. Do not use multiple names for the same object merely to avoid repetition. Do not let one term refer to two different objects. Project equations, data files, claims, and result tables decide the actual object; PowerLit decides the venue-normal wording for that object. If the corpus uses inconsistent terms, choose the term dominant in the target venue and closest problem family, then keep the manuscript consistent.

Do not coin a new term when an accepted venue term already names the object. Do not import a corpus term that changes the project's meaning. Internal experiment codes, run tags, or shorthand labels are not manuscript terms; translate them into academic scenario descriptions while preserving reproducibility details.

## Case-Evidence and Main-Body Learning Pass

For case-study, result-discussion, method/model, or full-paper drafting, use PowerLit neighbors to learn what the manuscript body is expected to prove and how accepted papers make that proof visible.

Extract a compact `Corpus case-evidence plan` from 3 to 5 venue-near and problem-near papers:

- `figure_table_inventory`: what kinds of figures and tables appear, such as test-system setup, baseline comparison, temporal profile, distribution/histogram, convergence curve, sensitivity sweep, ablation table, runtime/scalability table, boundary/failure case, or spatial/topological visualization;
- `evidence_question`: the reviewable question answered by each figure or table;
- `supported_argument`: which contribution, mechanism, baseline contrast, robustness/boundary statement, or reproducibility claim the visual supports;
- `minimum_visible_facts`: system, scenario, baseline, metric, unit, sample count, solver/protocol, or parameter setting needed for the reader to interpret the visual;
- `result_paragraph_move`: how the accepted paper moves from observed number or shape to mechanism and claim boundary.

Also extract a `Corpus main-body pattern`:

- method-section order: where accepted papers introduce operating object, assumptions, variables, formulation, transformation, algorithm, and reproducibility details;
- equation-exposition style: whether equations are followed by physical intuition, validity conditions, proof sketches, or implementation notes;
- transition functions: how the paper moves from problem formulation to method, from method to case setup, and from result tables to conclusion;
- body-level evidence rhythm: how many distinct results are used to support the central claim and which result functions are not optional for the claim class.

Use these patterns to decide what the current paper should show, not to invent missing figures or results. If neighbors routinely include a baseline, sensitivity, ablation, runtime, or boundary case that the current evidence lacks, mark it as a missing-evidence blocker or narrow the claim. Do not create a figure/table plan that is disconnected from available project outputs.

## Evidence-Strength Learning Pass

Before drafting a full paper, readiness-targeted manuscript, review response, or major case-study section, use PowerLit to learn the evidence bar for the same venue and claim class. Load `powerlit-evidence-strength.md` and build an internal evidence-strength profile from accepted papers before writing.

This pass is different from citation planning. It asks:

- what quantities accepted papers actually put in the manuscript;
- which baselines, metrics, systems, scenarios, sensitivity studies, ablations, certificates, runtime details, and reproducibility details are visible;
- how result tables are interpreted rather than merely reported;
- how the conclusion is bounded when a competing method wins on some metrics;
- what the current manuscript must add, narrow, or relabel before it can claim a higher internal readiness state.

For diagnostic, inverse, certificate, screening, or boundary-characterization papers, this pass is mandatory when PowerLit is available. If a stronger baseline wins on primary metrics, the profile must identify accepted-paper precedents for treating diagnostic value as publishable evidence; otherwise the paper claim must be narrowed.

## Reconstruction Benchmark Use

For skill maintenance, PowerLit papers may also be used as masked reconstruction benchmarks. In that mode, follow `published-paper-reconstruction.md`: extract an evidence packet from an accepted paper, hide the original prose, draft from evidence facts only, and let the review skill judge the review-strength delta.

Do not treat a paper's case-analysis data as enough for full-paper reconstruction. Case data can benchmark result-section writing only unless the evidence packet also includes the method object, assumptions, variables, baselines, metrics, protocol, and conclusion boundary.

## Required Internal Artifacts

Before drafting a citation-sensitive section, build these internal artifacts:

- `Venue profile`: target venue, expected paper object, introduction rhythm, method depth, evidence bar, and register.
- `Closest competitors`: papers overlapping in problem, mechanism, model, data, or evidence. Do not select papers merely because they share a keyword.
- `Evidence-strength profile`: verified method-canon anchor first, then venue-near accepted-paper evidence bar for the same claim class, including manuscript-facing quantities and missing-evidence blockers.
- `Corpus style exemplars`: venue-near papers used for section shape, paragraph function, rhythm, evidence presentation, and boundary language. Keep this as internal guidance unless the user asks for a style audit.
- `Corpus progression pattern`: abstract sentence-function sequence learned from venue-near papers, with duplicate payloads removed before drafting.
- `Corpus terminology map`: canonical terms, allowed abbreviations, Chinese-English pairs, forbidden aliases, and scope notes for the current paper object.
- `Corpus case-evidence plan`: figure/table functions, evidence questions, supported arguments, minimum visible facts, and result-paragraph moves learned from neighboring papers.
- `Corpus main-body pattern`: accepted-paper ordering for method/model exposition, equation interpretation, transitions, and body-level evidence rhythm.
- `Citation-to-sentence plan`: each citation supports one sentence-level function: background, method family, limitation, closest contrast, or evidence precedent.
- `Claim boundary`: what the paper may claim after comparison, and what it must not claim.
- `Gap-to-contribution-to-evidence map`: every kept gap motivates one deliverable, and every deliverable has a result, derivation, theorem, or stated assumption.

These artifacts are usually not shown to the user unless the user asks for planning, review, or citation strategy. They must not leak into final manuscript prose as labels.

## Drafting Discipline

Use retrieved papers as evidence, not as decoration.

- Background citations support the system need.
- Method-family citations define the existing routes.
- Gap citations expose the unresolved limitation.
- Closest-competitor citations anchor the direct contrast.
- Evidence-precedent citations justify benchmark choice, data protocol, scenario design, or metric choice.

Do not use a paper as a closest competitor unless it overlaps with the current manuscript in at least two of these dimensions: problem, mechanism, model, data, evidence object, or venue claim.

## Manuscript Boundary

Final manuscript prose may contain normal citation sentences, but it must not contain internal audit language such as:

- "closest competitor";
- "claim boundary";
- "citation pack";
- "corpus style exemplar";
- "PowerLit evidence";
- "gap-to-contribution map";
- "fallback mode".

Replace internal labels with ordinary manuscript logic. For example, "closest competitor" becomes a direct literature sentence about what a named method does and what it leaves unresolved.

## Failure Modes

- If retrieval returns broad topical papers only, write background cautiously and keep novelty language narrow.
- If retrieval finds a paper that covers the same problem, mechanism, and evidence object, stop polishing and narrow the claim, change the technical object, or recommend retargeting.
- If the user supplies references that conflict with PowerLit retrieval, state the conflict in a short note and keep manuscript claims bounded.
- If JSON records are malformed or unreadable, skip those records and cite the retrieval limitation rather than filling the gap from memory.
