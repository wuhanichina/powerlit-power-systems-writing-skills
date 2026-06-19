[中文](README.md) · English · [Changelog](CHANGELOG.md)

# ⚡ PowerLit Power Systems Writing and Review Skills

> **Lock the evidence boundary first, then write a power-systems paper that can survive review.**

[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Codex Skill](https://img.shields.io/badge/Codex-Skill-blue)](skills/)
[![Claude Skill](https://img.shields.io/badge/Claude-Skill-8A2BE2)](skills/)
[![PowerLit](https://img.shields.io/badge/PowerLit-Evidence%20Grounded-orange)](#powerlit-corpus-boundary)

This repository provides a set of power-systems research-writing skills, compatible with both Codex and Claude (Claude Code / Cowork): prewriting review, PowerLit literature intelligence, structured paper reading, full-paper drafting, IEEE Letter writing, and strict pre-submission review.

It is not a generic polishing tool. When PowerLit is available, the skills first retrieve nearby papers and citation evidence, define what can be claimed, and then write in the target venue's section shape, paragraph function, argument rhythm, and evidence style. Before submission, the review skill closes the loop by checking whether the draft would still fail under a local reviewer gate.

Supported venues and formats:

- Proceedings of the CSEE
- Automation of Electric Power Systems
- IEEE Transactions on Power Systems
- IEEE Transactions on Smart Grid
- IEEE power-systems Letters and short technical communications

[🚀 Install](#install-and-use) · [🧰 What It Does](#what-it-does) · [🎯 Common Entrypoints](#common-entrypoints) · [🧠 Core Mechanisms](#core-mechanisms) · [🧩 Skills](#skills) · [✅ Validation](#validation) · [📝 Changelog](CHANGELOG.md) · [🔒 Corpus Boundary](#powerlit-corpus-boundary)

---

## Install And Use

These skills work with both Codex and Claude (Claude Code / Cowork). Each skill is a standard `SKILL.md` + `references/` + Python-script bundle that is platform-independent, so the two install paths below can coexist.

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

### Then talk to the skills directly

```text
Use powerlit-power-systems-prewriting-review to decide whether this typhoon distribution-network risk assessment idea is ready for Proceedings of the CSEE writing.
```

```text
Rewrite this introduction in TPWRS style. Start by locking the claim boundary and nearby literature.
```

```text
Use powerlit-power-systems-literature-reading to read this paper and summarize its core argument, mechanism, contribution, research design, key findings, and relevance to my research question.
```

```text
Use these case33bw results to write the case-study analysis paragraph. Do not make a generic effectiveness claim.
```

```text
Review this manuscript strictly as an IEEE TSG reviewer and decide whether it is publishable.
```

No buttons, no panel, no manual JSON browsing. Provide an idea, draft, model, result table, or evidence packet; the skills turn it into venue-aware manuscript work.

---

## What It Does

| Capability | Skill | Output | Typical Use |
|---|---|---|---|
| 🧭 Prewriting decision | `powerlit-power-systems-prewriting-review` | `GO` / `CONDITIONAL GO` / `NO-GO` / `RETARGET` with repair actions | Decide whether an idea, model, experiment package, or rough draft is ready |
| 🔎 Literature intelligence | `powerlit-power-systems-literature-intelligence` | Nearby work, citation packets, novelty risks, coverage audits | Introduction writing, rebuttal preparation, novelty checks |
| 📖 Structured paper reading | `powerlit-power-systems-literature-reading` | Core argument, mechanism, contribution, design, findings, and research-question relevance | Read one or a small set of selected papers |
| 📝 Full-paper writing | `powerlit-power-systems-paper-writing` | Abstract, introduction, method, case study, conclusion, captions, results | CSEE, AEPS, TPWRS, and TSG manuscript writing |
| ✉️ IEEE Letter writing | `ieee-power-engineering-letter-writing` | One hard claim, compact technical core, minimal decisive evidence | IEEE PES Letters under official page-budget rules |
| 🧪 Pre-submission review | `powerlit-power-systems-paper-review` | Review risks ranked by severity | Submission checks and revision planning |
| 📊 Figures and results | `powerlit-power-systems-paper-writing` | Self-contained captions, explanatory sentences, MATLAB-to-manuscript paragraphs | Figures, tables, case studies, ablations, sensitivity analysis |
| ✨ Light editing | `powerlit-power-systems-paper-writing` | Smallest useful change that preserves technical meaning | Anti-AI cleanup, terminology, compression, expansion, translation, logic repair |

---

## Common Entrypoints

| Task | Required Input | Example Prompt | Expected Output |
|---|---|---|---|
| Prewriting decision | Idea, model, evidence state, target venue | `Decide whether this typhoon distribution-network risk assessment idea can enter Proceedings of the CSEE writing.` | `GO`, `CONDITIONAL GO`, `NO-GO`, or `RETARGET`, plus concrete repairs. |
| Structured paper reading | PDF, title/DOI, abstract, or PowerLit record; preferably with the user's research question | `Read this TPWRS paper and explain how it responds to my research question: how typhoon-driven source-load uncertainty affects static-security risk.` | Chinese six-part note: core argument, mechanism, contribution, research design, key findings, and research-question response. |
| Introduction rewrite | Target venue, draft, evidence boundary, citation state | `Rewrite this introduction in TPWRS style. First lock the claim boundary and nearby literature.` | Manuscript text after unsupported claims are narrowed or blocked. |
| Method/model section | Equations, assumptions, variables, algorithm, venue | `Rewrite this DRO AC OPF method section for TPWRS, focusing on assumptions, formulation, and solvability claims.` | A formulation-centered method section with variables, constraints, reformulation, algorithm, and boundaries. |
| Case-study results | MATLAB outputs or result tables, baselines, metrics, scenarios | `Use these case33bw results to write the case-study analysis paragraph. Do not make a generic effectiveness claim.` | A result paragraph tied to system, metric direction, comparison, mechanism, and boundary. |
| Figure/table caption | Figure content, axes or columns, venue | `Write an IEEE TSG caption for this voltage violation probability plot and add one explanatory sentence for the body text.` | A self-contained caption and body explanation tied to grid meaning. |
| Light edit | Original paragraph, target venue, keep/delete constraints | `Lightly polish this Chinese paragraph. Do not add conclusions or citations; only remove AI-style vague wording.` | Revised text first, with only necessary terminology, logic, and style repair. |
| Pre-submission review | Manuscript or section, venue, evidence packet | `Strictly review this paper under Proceedings of the CSEE standards and decide whether it is publishable.` | Review issues and required fixes ranked by severity. |

---

## Core Mechanisms

### 🔎 PowerLit Evidence Gate

When PowerLit is available, the skills retrieve nearby papers before making novelty, contribution, comparison, or venue-style claims. If evidence is missing, the skills narrow the claim or explicitly block it.

### 🧭 Project Claim To Paper Claim

`claims.md`, `evidence_map.md`, research notes, and gate reports are evidence boundaries, not manuscript-ready prose. Formal writing passes through:

```text
source claim -> evidence state -> review risk -> paper claim -> boundary sentence
```

This prevents project slogans from becoming unsupported venue claims.

### 🧱 Physical Story First

When revising after reviewer comments, the skills first translate each comment into a real gap in physical mechanism, model assumption, evidence comparison, or conclusion boundary, then integrate the repair into the natural manuscript location. The body text should not read like point-by-point defense, and mathematics should serve the engineering picture and reviewability instead of turning the paper into a complete proof exercise.

### 🧩 Venue Profile Routing

Full-paper writing keeps one public entrypoint, `powerlit-power-systems-paper-writing`, and routes venue differences through reference files for CSEE, AEPS, TPWRS, and TSG. The IEEE Letter flow is separate because a Letter is not a compressed full paper.

### 🧪 Write-Review Closure

Before submission, run `powerlit-power-systems-paper-review`. If the local review skill would still find a fatal flaw, major model/evidence problem, logic break, or venue mismatch, the writing skill must not label the draft as submission-ready.

### 📌 Real-Project Regressions

The repository includes real project claim fixtures, write-review closure cases, published-paper reconstruction cases, and readiness evidence packets. Skill maintenance should add actual failure cases to `evaluation/`, not only abstract rules.

---

## Skills

### `powerlit-power-systems-literature-intelligence`

Use this for PowerLit-backed literature work: novelty checks, nearby competing work, citation packets, introduction support, and literature coverage audits.

PowerLit JSON root resolution order:

1. Explicit user path or script parameter
2. `POWERLIT_JSON_ROOT`
3. `POWERLIT_LITERATURE_JSON`

For frequent use, prefer the SQLite FTS cache bundled inside the literature skill at `skills/powerlit-power-systems-literature-intelligence/assets/powerlit-index`. Standard skill installation copies that directory, so indexed retrieval works without a private raw corpus.

The primary entry point is the Python script, callable from Codex, Claude (Linux environment), or any environment with Python3.

Index build (Python, cross-platform):

```bash
python skills/powerlit-power-systems-literature-intelligence/scripts/Build-PowerLitIndex.py \
  --venue-folder ieee_tsg \
  --venue-folder ieee_tpwrs
```

Fast search (Python, cross-platform, recommended primary path):

```bash
python skills/powerlit-power-systems-literature-intelligence/scripts/Search-PowerLitIndex.py \
  --query "distributed voltage control" \
  --venue-folder ieee_tsg \
  --top 10
```

The Windows PowerShell entry point is an alternative; it prefers the skill-bundled local cache and only falls back to `rg` prefiltering when a raw corpus root is explicitly configured:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File `
  skills\powerlit-power-systems-literature-intelligence\scripts\Search-PowerLitJson.ps1 `
  -Query "distributed voltage control" `
  -VenueFolder ieee_tsg `
  -Top 10
```

### `powerlit-power-systems-literature-reading`

Use this to read one or a small set of selected papers and return a Chinese research note with a fixed structure:

- core argument
- theoretical or physical mechanism
- theoretical contribution
- research design
- key findings
- how the paper responds to the user's research question

When the full paper is readable, the skill states the evidence state and ties arguments, mechanisms, design, findings, and research implications to paper sections or results. When PowerLit is available, the theoretical contribution section also positions the paper within its research direction, identifies its method family, and compares its unique value against same-family methods. When only title, abstract, or metadata are available, it marks the summary as abstract/metadata limited and does not invent DOI, results, baselines, page numbers, or findings. For power-system papers, `theoretical mechanism` may mean physical mechanism, mathematical model, optimization/control logic, statistical mechanism, or an engineering causal chain.

### `powerlit-power-systems-prewriting-review`

Use this before formal writing. It decides whether an idea, outline, model, experiment package, or rough draft is ready for target-venue writing.

It returns one of:

- `GO`
- `CONDITIONAL GO`
- `NO-GO`
- `RETARGET`

It checks innovation chain, model correctness, evidence readiness, claim boundary, PowerLit nearby-work risk, and venue fit.

### `powerlit-power-systems-paper-writing`

Use this for full research papers. The skill keeps one stable public entrypoint and handles venue differences through reference files:

- `references/venue-profiles.md`
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
- `references/publishable-prose.md` / `references/rhythm.md` / `references/lexicon.md` / `references/anti-ai-style.md` for optional deeper examples

Use it for abstracts, introductions, methods and models, case studies, conclusions, captions, result paragraphs, venue adaptation, terminology cleanup, and anti-AI-style editing.

### `ieee-power-engineering-letter-writing`

Use this for IEEE power-systems Letters under official IEEE PES page-budget rules. It treats the Letter as an independent genre, not a compressed full paper:

- One hard claim
- One compact technical core
- Minimal but decisive evidence
- PowerLit nearby-work gate before novelty claims
- A short conclusion with clear boundaries

### `powerlit-power-systems-paper-review`

Use this for strict review under CSEE, AEPS, TPWRS, TSG, and IEEE Letter standards. Review priority is publishability, substantive innovation, closed logic chain, model and mathematical correctness, evidence sufficiency, conclusion support, venue fit, language, and format.

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
│   └── Validate-PowerLitSkillRepo.ps1
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

---

## PowerLit Corpus Boundary

This repository stores only skill instructions, venue signals, scripts, and behavior fixtures. It does not store original PowerLit corpus records, PDFs, or private literature data.

The skills read local PowerLit JSON only when that corpus is accessible. If the corpus is unavailable, they enter fallback mode and do not fabricate citations, nearby papers, or corpus-style conclusions. Retrieved papers may be used as local analytical evidence and writing references, but source text must not be copied into generated output.

---

## Limitations

- Without PowerLit access, the skills can provide conservative structure, logic, and language work, but cannot claim to have completed nearby-literature gating.
- Full JSON corpus search can be slow; build the SQLite FTS index for frequent use.
- Target papers can be used as references for structure, rhythm, and argument patterns, not as text to copy.
- `submission-ready` should only be used after evidence, model logic, and venue fit pass the local review gate.
