[中文](README.md) · English · [Changelog](CHANGELOG.md)

# ⚡ PowerLit Power Systems Writing and Review Skills

> **Start from engineering needs, make the physical logic intuitive, confirm the evidence advantage, and write a power-systems paper that can survive review.**

[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Writing Skill Version](https://img.shields.io/badge/Writing%20Skill-2026.08.01-blueviolet)](#release-notes)
[![Codex Skill](https://img.shields.io/badge/Codex-Skill-blue)](skills/)
[![Claude Skill](https://img.shields.io/badge/Claude-Skill-8A2BE2)](skills/)
[![Cursor Skill](https://img.shields.io/badge/Cursor-Skill-007ACC)](skills/)
[![PowerLit](https://img.shields.io/badge/PowerLit-Evidence%20Grounded-orange)](#about-powerlit)

This repository provides a set of power-systems research-writing skills for Codex, Claude (Claude Code / Cowork), and Cursor: prewriting review, PowerLit literature intelligence, structured paper reading, full-paper drafting, IEEE Letter writing, and strict pre-submission review.

It is not a generic polishing tool. Each install ships a **~14k-paper SQLite index**. The skills start from the engineering need and physical conflict, build the research object, mechanism intuition, and complete argument, then use nearby literature and project results to confirm theoretical, engineering, and evidence advantages before drafting in the target venue's section shape and evidence style. Evidence boundaries calibrate conclusion strength rather than lead the story. Before submission, the review skill closes the loop with a local reviewer gate.

Supported venues and formats:

- Proceedings of the CSEE
- Automation of Electric Power Systems
- IEEE Transactions on Power Systems
- IEEE Transactions on Smart Grid
- IEEE power-systems Letters and short technical communications

[🚀 Install](#install-and-use) · [🧰 What It Does](#what-it-does) · [🎯 Common Entrypoints](#common-entrypoints) · [🧠 Core Mechanisms](#core-mechanisms) · [🧩 Skills](#skills) · [✅ Validation](#validation) · [🗓️ Release Notes](#release-notes) · [📝 Changelog](CHANGELOG.md) · [🔒 About PowerLit](#about-powerlit)

## Release Notes

Current paper-writing version: **2026.08.01**; paper-review version: **2026.07.31**; prewriting-review version: **2026.07.12**. Each `SKILL.md` carries its own `version:` field. After installing, compare the repository copy with your local install using `Select-String -Path skills\*\SKILL.md, ~/.cursor/skills/*/SKILL.md -Pattern '^version:'`.

Only the latest 10 versions are shown (reverse chronological; same-day changes are merged into one version):

- **2026-08-01**: added two supplied Furong Li full-text exemplars to the innovation DOI map for the method and framework routes, distilling source-backed introduction, derivation, case-sequencing, and trend-mechanism-advantage figure-discussion patterns; the narrative router gains the economic-decision loop and minimal-to-practical validation argument functions, locked in by validation tokens and pytest.
- **2026-07-31**: put physical explanation under the no-invention boundary with explicit mechanism status (`model-derivable`, `consistent-with-model`, or an unverified interpretation reported in the delivery note), added a model-consistency blocker, added a case-section figure storyboard with a figures-only read test so the figures carry the engineering story on their own, added a contribution significance gate that treats a correct paper without a non-trivial claim as a story defect, reordered the delivery gates into five groups with always-run technical checks, made review closure name its references and produce an internal verdict, and scoped the AEPS validation closing sentence by corpus measurement instead of deleting it. Same day: reframed writing around engineering needs, physical/engineering intuition, technical logic, and evidence advantage, with evidence boundaries reserved for claim-strength calibration; also integrated field-tested Chinese major-revision practice through source-authority mapping, promise-to-landing closure, equation-level `why → meaning → connection`, causal isolation, and deterministic consistency checks.
- **2026-07-12**: added the four-axis innovation assessment with 0→1/1→100 narrative routing, six case-design contracts, Figure-first trend-mechanism-advantage interpretation, the evidence-verb ladder, submission consistency checking, the three-deliverable revision workflow, and a versioned handoff contract with the MATLAB project template.
- **2026-07-07**: pre-drafting confirmation now requires PowerLit-backed theoretical and engineering value positioning — first explain what problem the paper solves from the engineering need and physical mechanism, then confirm theoretical, engineering, and evidence advantages against neighboring literature; metrics serve as subordinate evidence and evidence boundaries calibrate claim strength instead of leading the story.
- **2026-07-06**: pre-drafting confirmation adds the innovation-level ladder — confirm engineering background, real pain point, discovery/conjecture verification, method contribution, and engineering-problem contribution with the user before formal prose, translating internal project names, case/run labels, claim IDs, and script names into professional power-system problem statements; innovation discovery and manuscript prose both replace binary supports/does-not-support wording with maturity-graded categories.
- **2026-07-03**: index year repair — `derive_year` infers publication years from DOI/content headers, bundled SQLite shards backfilled (14146/14148 records), search results now include `year`; key gates marked with 🔴 CHECKPOINT / 🛑 STOP; `paper-writing` deduplicated; all six skills carry `version:` in frontmatter; README adds Cursor and other Agent-Skills runtime install/sync guidance; semi-automated regression runner (`scripts/Run-SkillRegression.py` + `evaluation/results.tsv`) plus a Letter opening pain-point A/B regression case.
- **2026-06-30**: structural closure — cross-skill section-quality checklist alignment, independent-reviewer stance for write-review closure, removed orphan `baseline-comparison.md`; implementability polish — reference loading tiers, delivery passes consolidated into four groups deduplicated against `prose-quality-gates.md`, plan-keep/prose-strip label rules, object-first venue routing with TPWRS as fallback only, per-venue before→after examples and formula-intuition templates, spine-consistency checking, and translation boundary preservation; added the prewriting minimum-research-object gate that locks the small-peer problem domain before pain-point, innovation, and story judgments.
- **2026-06-27**: added prewriting-stage true-innovation repositioning and physical storyline checks, deciding what technical story the project should tell before writing starts.
- **2026-06-19**: added Codex and Claude dual-platform install instructions, plus stronger paper-spine, evidence-freshness, and tiered opening pain-point rules.
- **2026-06-18**: added the literature-reading skill, readiness migration, cross-platform retrieval entry points, and the repository validation layer.

See [CHANGELOG.md](CHANGELOG.md) for earlier versions and the full history.

---

## Install And Use

These skills run on Codex, Claude, and Cursor. Each skill is a standard `SKILL.md` + `references/` + Python-script bundle—pick any install path below.

### Codex

Run this in PowerShell:

```powershell
python "$env:USERPROFILE\.codex\skills\.system\skill-installer\scripts\install-skill-from-github.py" `
  --repo wuhanichina/powerlit-power-systems-writing-skills `
  --path skills/powerlit-power-systems-literature-intelligence `
         skills/powerlit-power-systems-literature-reading `
         skills/powerlit-power-systems-prewriting-review `
         skills/powerlit-power-systems-paper-writing `
         skills/ieee-power-engineering-letter-writing `
         skills/powerlit-power-systems-paper-review
```

Restart Codex.

### Claude (Claude Code / Cowork)

Each `skills/<name>/` directory is a standard Claude skill (with `SKILL.md` frontmatter). Drop them into a Claude skills directory to make them discoverable:

```bash
git clone https://github.com/wuhanichina/powerlit-power-systems-writing-skills.git
cp -r powerlit-power-systems-writing-skills/skills/* ~/.claude/skills/
```

- Personal skills directory: `~/.claude/skills/` (project-level: `<repo>/.claude/skills/`).
- A single skill directory can also be zipped as a `.skill` package and installed in Claude.
- Restart / reload Claude; the skills then appear in the skill list.

The retrieval scripts run under Claude's Linux environment via the Python entry points (see [Core Mechanisms](#core-mechanisms)); no PowerShell required.

### Other Agent-Skills-compatible runtimes (Cursor, etc.)

Any runtime that supports the Agent Skills standard (`SKILL.md` frontmatter + `references/` + `scripts/`) can use these skills directly: copy or symlink each `skills/<name>/` directory into that runtime's skills directory. Common paths:

| Runtime | Skills directory |
|---|---|
| Codex | `~/.codex/skills/` |
| Claude Code / Cowork | `~/.claude/skills/` |
| Cursor | `~/.cursor/skills/` (or the project-level skills directory; Cursor also discovers skills installed under `~/.codex/skills/`) |
| Others | see that runtime's skills documentation and use its discovery directory |

### Updating installed copies

Installed copies can drift from the repository as the skills evolve. Each `SKILL.md` frontmatter carries a `version:` date stamp; compare and sync with:

```powershell
Select-String -Path "skills\*\SKILL.md", "$env:USERPROFILE\.cursor\skills\*\SKILL.md" -Pattern "^version:"
Copy-Item -Recurse -Force skills\* "$env:USERPROFILE\.cursor\skills\"
```

If you installed via the skill installer, rerun the install command to pick up the latest version.

### Then talk to the skills directly

```text
Use powerlit-power-systems-prewriting-review to decide whether this typhoon distribution-network risk assessment idea is ready for Proceedings of the CSEE writing.
```

```text
Rewrite this introduction in TPWRS style around the engineering need and physical conflict, then use nearby literature to establish the evidence advantage.
```

```text
Use powerlit-power-systems-literature-reading to read this paper and summarize its core argument, mechanism, contribution, research design, key findings, and relevance to my research question.
```

```text
Use these case33bw results to write the case-study analysis paragraph. Do not make a generic effectiveness claim.
```

```text
Review this manuscript strictly under IEEE TSG standards and return local review advice plus must-fix items.
```

Provide an idea, draft, model, result table, or evidence packet—the skills turn it into venue-aware manuscript work.

---

## What It Does

| Capability | Skill | Output | Typical Use |
|---|---|---|---|
| 🧭 Prewriting decision | `powerlit-power-systems-prewriting-review` | `GO` / `CONDITIONAL GO` / `NO-GO` / `RETARGET` with repair actions | Decide whether an idea, model, experiment package, or rough draft is ready |
| 🔎 Literature intelligence | `powerlit-power-systems-literature-intelligence` | Nearby work, citation packets, novelty risks, coverage audits | Introduction writing, rebuttal preparation, novelty checks |
| 📖 Structured paper reading | `powerlit-power-systems-literature-reading` | Core argument, mechanism, contribution, design, findings, and research-question relevance | Read one or a small set of selected papers |
| 📝 Full-paper writing | `powerlit-power-systems-paper-writing` | Abstract, introduction, method, case study, conclusion, captions, results | CSEE, AEPS, TPWRS, and TSG manuscript writing |
| ✉️ IEEE Letter writing | `ieee-power-engineering-letter-writing` | One hard claim, compact technical core, minimal decisive evidence | IEEE PES Letters under official page-budget rules |
| 🧪 Pre-submission review | `powerlit-power-systems-paper-review` | Local review advice + prioritized fix list | Submission checks and revision planning |
| 📊 Figures and results | `powerlit-power-systems-paper-writing` | Self-contained captions, explanatory sentences, MATLAB-to-manuscript paragraphs | Figures, tables, case studies, ablations, sensitivity analysis |
| ✨ Light editing | `powerlit-power-systems-paper-writing` | Smallest useful change that preserves technical meaning | Anti-AI cleanup, terminology, compression, expansion, translation, logic repair |

---

## Common Entrypoints

| Task | Required Input | Example Prompt | Expected Output |
|---|---|---|---|
| Prewriting decision | Idea, model, evidence state, target venue | `Decide whether this typhoon distribution-network risk assessment idea can enter Proceedings of the CSEE writing.` | `GO`, `CONDITIONAL GO`, `NO-GO`, or `RETARGET`, plus concrete repairs. |
| Structured paper reading | PDF, title/DOI, abstract, or PowerLit record; preferably with the user's research question | `Read this TPWRS paper and explain how it responds to my research question: how typhoon-driven source-load uncertainty affects static-security risk.` | Chinese six-part note: core argument, mechanism, contribution, research design, key findings, and research-question response. |
| Introduction rewrite | Engineering problem, target venue, draft, main evidence, citation state | `Rewrite this introduction in TPWRS style around the engineering need and physical conflict, then use nearby literature to establish the evidence advantage.` | Manuscript prose with a coherent engineering object, physical logic, method action, and evidence advantage. |
| Method/model section | Equations, assumptions, variables, algorithm, venue | `Rewrite this DRO AC OPF method section for TPWRS, focusing on assumptions, formulation, and solvability claims.` | A formulation-centered method section with variables, constraints, reformulation, algorithm, and boundaries. |
| Case-study results | MATLAB outputs or result tables, baselines, metrics, scenarios | `Use these case33bw results to write the case-study analysis paragraph. Do not make a generic effectiveness claim.` | A result paragraph tied to system, metric direction, comparison, mechanism, and boundary. |
| Figure/table caption | Figure content, axes or columns, venue | `Write an IEEE TSG caption for this voltage violation probability plot and add one explanatory sentence for the body text.` | A self-contained caption and body explanation tied to grid meaning. |
| Light edit | Original paragraph, target venue, keep/delete constraints | `Lightly polish this Chinese paragraph. Do not add conclusions or citations; only remove AI-style vague wording.` | Revised text first, with only necessary terminology, logic, and style repair. |
| Pre-submission review | Manuscript or section, venue, evidence packet | `Strictly review this paper under Proceedings of the CSEE standards and return local review advice plus must-fix items.` | Local review advice (submit / minor / major / do not submit) and a prioritized fix list. |

---

## Core Mechanisms

### 🔎 PowerLit Positioning And Evidence Advantage

The literature skill ships with a SQLite index (~14k records, ready after install). Writing and prewriting use nearby work to test whether the engineering pain point is real, explain why existing methods remain insufficient, and identify the paper's theoretical, engineering, and evidence advantages. Claim boundaries calibrate conclusion strength at the end—you describe the research object; retrieval runs through the skill scripts.

### 🧭 Minimum Research Object Gate

Before prewriting and major drafting, the skills identify the paper's minimum research object and subfield problem domain, then define pain points, innovation, and story line—preventing narrow technical contributions from being inflated into broad industry narratives.

### 🧭 Project Claim To Paper Claim

`claims.md`, `evidence_map.md`, research notes, and gate reports are evidence boundaries, not manuscript-ready prose. Formal writing passes through:

```text
source claim -> engineering need -> physical mechanism -> evidence advantage -> paper claim -> applicability
```

This first rebuilds project material into a complete engineering and physical argument, then calibrates conclusion strength against the evidence scope.

### 🧱 Physical And Engineering Story First

For both first drafts and revisions, the skills first establish the engineering scene, physical conflict, mechanism changed by the method, and evidence that tests the mechanism. Mathematics, algorithms, and results are then woven into that linear story. Reviewer comments become missing links in the engineering or physical argument rather than point-by-point defensive prose.

### 🧩 Venue Profile Routing

Full-paper writing keeps one public entrypoint, `powerlit-power-systems-paper-writing`, and routes venue differences through reference files for CSEE, AEPS, TPWRS, and TSG. **When the venue is unset, default routing follows TPWRS evidence standards with a Chinese technical first draft** (convert to English IEEE prose when needed). The IEEE Letter flow is separate because a Letter is not a compressed full paper.

### 🧪 Write-Review Closure

Before submission, run `powerlit-power-systems-paper-review`. If the local review skill would still find a fatal flaw, major model/evidence problem, logic break, or venue mismatch, the writing skill must not label the draft as submission-ready.

### 📌 Real-Project Regressions

The repository includes real project claim fixtures, write-review closure cases, published-paper reconstruction cases, and readiness evidence packets. Skill maintenance should add actual failure cases to `evaluation/`, not only abstract rules.

---

## Skills

### `powerlit-power-systems-literature-intelligence`

Use this for novelty checks, nearby competing work, citation packets, introduction support, and literature coverage audits. **Each install includes a SQLite index (~14k records)**—no private corpus required for retrieval.

Fast search (Python, cross-platform, primary path):

```bash
python skills/powerlit-power-systems-literature-intelligence/scripts/Search-PowerLitIndex.py \
  --query "distributed voltage control" \
  --venue-folder ieee_tsg \
  --top 10
```

Windows users can use the PowerShell entry with equivalent behavior:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File `
  skills\powerlit-power-systems-literature-intelligence\scripts\Search-PowerLitJson.ps1 `
  -Query "distributed voltage control" `
  -VenueFolder ieee_tsg `
  -Top 10
```

If you have a private PowerLit JSON corpus and need to refresh or extend the index, set `POWERLIT_JSON_ROOT` and run `Build-PowerLitIndex.py`.

### `powerlit-power-systems-literature-reading`

Use this to read one or a small set of selected papers and return a Chinese research note with a fixed structure:

- core argument
- theoretical or physical mechanism
- theoretical contribution
- research design
- key findings
- how the paper responds to the user's research question

When the full paper is readable, the skill states the evidence state and ties arguments, mechanisms, design, findings, and research implications to paper sections or results. When nearby literature is available, the theoretical contribution section also positions the paper within its research direction, identifies its method family, and compares its unique value against same-family methods. When only title, abstract, or metadata are available, it marks the summary as abstract/metadata limited and does not invent DOI, results, baselines, page numbers, or findings. For power-system papers, `theoretical mechanism` may mean physical mechanism, mathematical model, optimization/control logic, statistical mechanism, or an engineering causal chain.

### `powerlit-power-systems-prewriting-review`

Use this before formal writing. It decides whether an idea, outline, model, experiment package, or rough draft is ready for target-venue writing.

It returns one of:

- `GO`
- `CONDITIONAL GO`
- `NO-GO`
- `RETARGET`

It checks minimum research object positioning, real-innovation repositioning, the multi-act engineering story and physics intuition, innovation chain, model correctness, evidence readiness, claim boundary, nearby-work risk, and venue fit. It first narrows the problem to the best-matching subfield object—for example analytic AC probabilistic power flow, distribution state estimation, protection coordination, or a specific object inside typhoon risk assessment—then answers what story the project should actually tell. The story unfolds through engineering scene, physical contradiction, mechanism intuition, technical object, evidence, and boundary. Mathematical derivation supports the model, mechanism, intuition, or boundary instead of replacing the power-system story. It also scores scientificity, industry pain-point accuracy, correctness, reasonableness, innovation, and engineering feasibility from 1 to 10 against current research progress, gives an overall score, and names the maximum defect.

### `powerlit-power-systems-paper-writing`

Use this for full research papers. The skill keeps one stable public entrypoint and handles venue differences through reference files:

- `references/venue-profiles.md`
- `references/pre-drafting-confirmation.md`
- `references/manuscript-section-quality.md`
- `references/chinese-major-revision.md`
- `references/corpus-grounded-drafting.md`
- `references/csee.md`
- `references/csee-precision.md`
- `references/aeps.md`
- `references/tpwrs.md`
- `references/tsg.md`
- `references/introduction-scalpel.md`
- `references/method-model.md`
- `references/case-conclusion.md`
- `references/figures-tables-results.md`
- `references/prose-quality-gates.md`
- `references/reader-experience-pass.md`
- `references/task-prompts.md`
- `references/worked-examples.md` for per-venue before→after rewrite examples (optional)
- `references/publishable-prose.md` / `references/rhythm.md` / `references/lexicon.md` / `references/anti-ai-style.md` for optional deeper examples

Use it for titles/keywords, abstracts, introductions, methods and models, case studies, conclusions, captions, result paragraphs, venue adaptation, terminology cleanup, and anti-AI-style editing. Before a full paper, title, abstract, introduction, contribution statement, or major rewrite, it searches project files and nearby literature, confirms pain points, innovation points, and feasible titles, then asks you to confirm before manuscript drafting. Chinese major revisions and multi-version fusion additionally separate technical authority from style authority and close claim landings, equation-level physical narration, causal attribution, and mechanical references.

### `ieee-power-engineering-letter-writing`

Use this for IEEE power-systems Letters under official IEEE PES page-budget rules. It treats the Letter as an independent genre, not a compressed full paper:

- One hard claim
- One compact technical core
- Minimal but decisive evidence
- PowerLit nearby-work gate before novelty claims
- A short conclusion with clear boundaries

### `powerlit-power-systems-paper-review`

Use this for strict review under CSEE, AEPS, TPWRS, TSG, and IEEE Letter standards. It returns **local review advice** (submit / minor / major / do not submit) and a prioritized fix list.

---

## Recommended Workflow

1. Run `powerlit-power-systems-prewriting-review` to decide whether the work is ready.
2. Use `powerlit-power-systems-literature-intelligence` to retrieve nearby competing work and citation evidence.
3. Use `powerlit-power-systems-literature-reading` to produce Chinese six-part notes for papers that need close reading.
4. Use `powerlit-power-systems-paper-writing` for full papers, or `ieee-power-engineering-letter-writing` for Letters.
5. Run `powerlit-power-systems-paper-review` before submission to close writing risks against reviewer standards.
6. When maintaining the skills, add real review failures to regression fixtures such as `evaluation/actual-project-claim-regressions.json`.

---

## Repository Structure

```text
powerlit-power-systems-writing-skills/
├── README.md
├── README.en.md
├── LICENSE
├── scripts/
│   ├── Validate-PowerLitSkillRepo.ps1
│   └── Run-SkillRegression.py
├── skills/
│   ├── powerlit-power-systems-literature-intelligence/
│   ├── powerlit-power-systems-literature-reading/
│   ├── powerlit-power-systems-prewriting-review/
│   ├── powerlit-power-systems-paper-writing/
│   ├── ieee-power-engineering-letter-writing/
│   └── powerlit-power-systems-paper-review/
└── evaluation/
    ├── writing-review-closure.json
    ├── actual-project-claim-regressions.json
    ├── powerlit-paper-reconstruction-cases.json
    └── actual-case-evidence-packets.json
```

---

## Validation

Run the repository lint and schema validator from the repository root:

```powershell
$env:PYTHONUTF8 = "1"
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\Validate-PowerLitSkillRepo.ps1
```

To check structure and fixture schemas without the live PowerLit search smoke:

```powershell
$env:PYTHONUTF8 = "1"
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\Validate-PowerLitSkillRepo.ps1 -SkipPowerLitSearch
```

This script is repository lint and schema validation, not a behavior-regression result. It checks:

- skill frontmatter
- referenced `references/` and `scripts/` paths
- behavior fixture JSON schemas
- write-review closure fixture schemas in `evaluation/writing-review-closure.json`
- real project claim fixture schemas in `evaluation/actual-project-claim-regressions.json`
- published-paper reconstruction cases in `evaluation/powerlit-paper-reconstruction-cases.json`
- readiness evidence packets in `evaluation/actual-case-evidence-packets.json`
- PowerLit resolver smoke
- optional PowerLit search smoke

Deterministic unit tests and the retrieval benchmark are separate layers:

```powershell
python -m pytest -q
python evaluation/retrieval/run_retrieval_eval.py
```

CI runs repository lint, unit tests, and retrieval evaluation on both `ubuntu-latest` and `windows-latest`.

Behavior regression (requires an agent run) is orchestrated by the semi-automated runner and logged to `evaluation/results.tsv`:

```powershell
python scripts/Run-SkillRegression.py list                 # list all regression cases
python scripts/Run-SkillRegression.py show --id <case-id>  # fetch prompt for a skilled agent run
python scripts/Run-SkillRegression.py record --id <case-id> --mode full_test --verdict pass --note "..."
python scripts/Run-SkillRegression.py status               # coverage and dry_run ratio alerts
```

---

## About PowerLit

This repository distributes skills and a **built-in literature index** (~14k records), not original PDFs. Retrieved papers support citation planning and argument structure—they are **not copied into your manuscript**. You can extend the index with a private corpus if needed.

---
