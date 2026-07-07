# Pre-Drafting Innovation and Title Confirmation

Use this before full-paper drafting, major rewriting, title design, abstract, introduction, contribution, or venue-positioning work.

The goal is to prevent a fluent draft from being built around the wrong contribution or a weak title. First confirm the real industry or engineering pain point, then confirm the innovation that answers it, then write.

## When This Gate Applies

Apply this gate when:

- the user asks for a full paper, abstract, introduction, contribution list, title, venue positioning, or major rewrite;
- the current title is missing, tentative, stale, or inconsistent with the method/evidence;
- the industry or engineering pain point is vague, assumed, stale, or disconnected from the proposed method;
- the innovation point is broad, project-management-shaped, defensive, copied from `claims.md`, or not mapped to a pain point;
- the closest literature threat could change the title, claim, or contribution emphasis.

Do not force this gate for pure light editing, translation, caption writing, or a small result paragraph when the supplied text already fixes the title and innovation boundary.

## Evidence Search Order

Search project files before writing:

1. User-supplied title, abstract, outline, manuscript, or instructions.
2. Project truth files such as `claims.md`, `claim_boundary.md`, `evidence_map.md`, `README`, `01_IDEA`, `02_METHOD`, `03_REFERENCE`, `04_EXPERIMENT`, reports, review notes, and gate reports.
3. Current evidence outputs such as result tables, figure manifests, validation reports, `RunMetadata`, and baseline-comparison summaries.
4. Existing manuscript drafts and previous titles, but treat them as candidates, not truth.

Use `rg` or an equivalent project-file search to find pain point, title, contribution, innovation, claim, evidence, baseline, and conclusion signals when files are available. Do not infer the main innovation or pain point only from directory names.

## Pain Point First

Before discussing innovation with the user, clarify the current real industry or engineering pain point:

- what grid, device, market, planning, operation, protection, uncertainty, resilience, data, or control problem exists now;
- who or what is affected: operator, planner, controller, protection setting, equipment, market participant, or reliability/security margin;
- why the problem is not just academic: safety, economy, observability, feasibility, reliability, risk, computation, coordination, or implementation consequence;
- which current method, engineering practice, or literature family fails to handle it, and why;
- what project-file or literature evidence supports the pain point.

The innovation point must be paired with this pain point. A candidate innovation that does not answer the pain point should be downgraded, moved to a secondary contribution, or dropped.

## Innovation Level Ladder

Before formal manuscript writing, discuss the innovation level with the user and keep the levels separate:

- **Discovery or conjecture verification:** what phenomenon, mechanism, failure mode, boundary condition, counterexample, or engineering conjecture the work discovers, verifies, or falsifies.
- **Method-level contribution:** what model, formulation, constraint, estimator, control law, algorithm, certificate, validation protocol, or measurement procedure the work proposes.
- **Engineering-problem contribution:** what real operating, planning, protection, risk, observability, feasibility, coordination, computation, or implementation problem becomes better handled because of the discovery and method.

Do not collapse these levels into a single generic "innovation point". A strong confirmation brief should show whether the paper's main contribution is a discovered/verified insight, a new method, an engineering solution, or a defensible combination of these. If the evidence is mature at only one level, state the usable level and keep the other levels as boundary, discussion, or future-work material.

The user-facing discussion must clarify the engineering background and innovation before writing begins. Ask the user to confirm whether the engineering pain point is correctly stated, which innovation level is primary, which levels are secondary, and which unsupported framings should be dropped.

## Evidence Maturity And Manuscript Use

For innovation discovery and pre-drafting confirmation, do not present the result as a binary "supports X / does not support Y" judgment. That wording is too blunt for innovation mining and can make partial findings look like failures.

Classify each candidate by evidence maturity and manuscript use:

- **Mainline innovation:** mature enough for the title, abstract, contribution list, introduction, and conclusion.
- **Conditional contribution:** usable only with a stated scenario, data window, assumption, event set, model boundary, or metric definition.
- **Observed phenomenon:** interesting and technically relevant, but not stable enough to carry the paper's main claim.
- **Boundary evidence:** useful for narrowing the paper, explaining why a stronger framing is not chosen, or motivating future experiments.
- **Uncovered evidence need:** not yet tested or not present in the available samples; use only as future work or a required next experiment.

Write user-facing confirmation language as "the current evidence is best used as..." rather than "the project supports/does not support...". Reserve strict support/blocker wording for internal review gates, fatal overclaim checks, and explicit readiness decisions.

## PowerLit Theoretical And Engineering Value Positioning

Before formal writing, use project evidence and PowerLit near-neighbor literature to position the paper's theoretical value and engineering value at a level above individual metric changes.

Do not reduce theoretical value to "metric A improves by X". Metrics demonstrate value; they do not define it. Ask what larger role the work plays in the closest problem family, method family, and target-venue literature:

- **Theoretical value positioning:** whether the work poses a new research object, verifies a conjecture, clarifies a mechanism, reveals a boundary condition, transfers a theory to a power-system object, links two model families, constructs an identifiability or feasibility certificate, defines a validation protocol, exposes a counterexample, or reframes an existing method class.
- **Engineering value positioning:** whether the work improves an operating, planning, protection, risk, observability, feasibility, computation, coordination, resilience, or decision-support problem in a way that a power-system practitioner can recognize.
- **Metric-level evidence:** which result, baseline, sensitivity, ablation, or boundary case demonstrates the above value, without letting the metric become the contribution itself.
- **Corpus-near role:** whether PowerLit near-neighbor papers make this value look like a mainline theoretical contribution, conditional engineering contribution, boundary clarification, validation contribution, or future-work hypothesis.

The confirmation discussion should explicitly tell the user what theoretical claim is plausible, what engineering decision or interpretation becomes better supported, and what should remain only metric-level evidence. If PowerLit is unavailable, state that the positioning is project-evidence-only and must be refreshed when the corpus is accessible.

## Professional Problem Statement

When describing the problem, use common professional power-system terms rather than internal project vocabulary:

- translate project names, run labels, claim IDs, cache names, script names, branch names, and experiment nicknames into the actual system object, scenario, method class, metric, or evidence object;
- keep reproducibility identifiers in notes or evidence references when needed, but do not make them the manuscript-facing problem name;
- avoid acronyms or shorthand that are only meaningful inside the project unless they are standard in the field or defined as the paper's method name after confirmation;
- state the engineering pain point as a recognizable technical problem, not as "the problem in ProjectName", "case X", "claim Y", or a local workflow gap.

## Literature Support

Use `powerlit-power-systems-literature-intelligence` when available to support the decision:

- retrieve closest competitors and same-family papers;
- confirm whether the claimed pain point is current and real in recent research or engineering practice;
- identify whether the proposed contribution is a new problem, model, mechanism, certificate, estimator, control law, validation protocol, or only a packaging variation;
- check whether title wording would overclaim relative to nearby papers;
- use PowerLit evidence to rank title directions and claim boundaries.

If PowerLit or literature retrieval is unavailable, state fallback mode and rely only on project-file evidence and user-supplied references. Do not invent paper titles, DOIs, years, or competitor claims.

## Confirmation Brief

Before drafting, return a compact `写作前确认` brief unless the user already confirmed both innovation and title direction:

1. `文件检索后确认的创新点`: list one to three candidates. For each, state:
   - corresponding real industry or engineering pain point;
   - innovation level: discovery/conjecture verification, method-level contribution, engineering-problem contribution, or a supported combination;
   - evidence maturity and manuscript use: mainline innovation, conditional contribution, observed phenomenon, boundary evidence, or uncovered evidence need;
   - PowerLit-backed theoretical value positioning: closest problem family, corpus-near theoretical role, and whether the value is mainline, conditional, boundary-level, or still a hypothesis;
   - engineering value positioning: the operating, planning, protection, risk, observability, feasibility, computation, coordination, resilience, or decision-support problem that becomes better handled;
   - metric-level evidence: the result or comparison that demonstrates the value without defining the contribution;
   - technical object;
   - physical or engineering mechanism;
   - supporting project files or result artifacts;
   - how to phrase the candidate without binary "supports/does not support" wording;
   - overclaim risk or weaker framing to drop.
2. `文献检索辅助判断`: closest competitors, novelty threat, title-positioning implication, or fallback limitation.
3. `技术层面研究意义`: list concise technical significance items, not broad social value:
   - what mechanism, model, estimator, constraint, certificate, algorithm, validation protocol, or evidence boundary becomes clearer;
   - what operational, planning, protection, risk, observability, feasibility, or computation decision is technically better supported;
   - what the paper changes about understanding or using the relevant method class.
4. `可行论文标题`: give three to five title candidates:
   - recommended title first;
   - at least one mechanism-focused title;
   - at least one evidence-boundary or venue-conservative title when evidence is incomplete;
   - avoid title wording that claims superiority, real-time deployment, full risk propagation, or broad robustness unless evidence supports it.
5. `需要使用者确认`: ask the user to approve the pain point, innovation point, research-significance emphasis, and title direction, or to select one candidate.
   - explicitly ask which innovation level should be the main paper story;
   - explicitly ask whether the professional problem statement removes internal project names while preserving the real technical meaning.

Do not continue into full manuscript drafting in the same response unless the user explicitly says to proceed with the recommended option or asks for best-judgment drafting.

## Title Quality Rules

A feasible title should expose:

- the power-system object;
- the technical object or action;
- the physical mechanism or operating condition when it differentiates the work;
- the claim boundary when needed to avoid overclaiming.

Avoid titles that are:

- only a method acronym plus "application";
- broader than the evidence surface;
- copied from a nearby paper's phrasing;
- built around mathematics that is not the reader-facing contribution;
- disconnected from the title/abstract/introduction/result/conclusion spine.

## Confirmation Pass Outcome

After the user confirms, lock:

- confirmed title or title direction;
- confirmed real industry or engineering pain point;
- confirmed main innovation;
- confirmed technical-level research significance;
- subordinate innovations to keep;
- framings to drop;
- literature-near novelty boundary;
- evidence boundary that must appear in abstract, introduction, result discussion, and conclusion.

If confirmation is impossible because project files conflict or the literature threat is too strong, return a narrowed decision brief instead of drafting.
