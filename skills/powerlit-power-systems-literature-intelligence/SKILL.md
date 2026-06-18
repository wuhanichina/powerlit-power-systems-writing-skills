---
name: powerlit-power-systems-literature-intelligence
description: Retrieve and technically compare nearby power-system papers from a portable PowerLit index or an explicitly configured JSON corpus. Use for candidate-literature discovery, closest-competitor analysis, citation planning, literature coverage audits, and descriptive evidence-profile support.
---
# PowerLit Power-Systems Literature Intelligence

## Purpose

Use this skill to discover and inspect literature evidence. Retrieval score is a ranking signal, not a novelty score, acceptance score, or authority. A novelty judgment requires technical comparison of the current manuscript with retrieved papers.

## Portable Configuration

The installable skill contains its default cache at:

```text
assets/powerlit-index/
```

Resolve an index in this order:

1. explicit `--index-dir` or `-PowerLitIndexRoot`;
2. `POWERLIT_INDEX_ROOT`;
3. `$CODEX_HOME/powerlit/powerlit-index`;
4. the bundled `assets/powerlit-index` directory.

Resolve a raw JSON corpus only from:

1. explicit `--root` or `-PowerLitJsonRoot`;
2. `POWERLIT_JSON_ROOT`;
3. `POWERLIT_LITERATURE_JSON`.

Do not assume a LAN share, drive letter, user directory, or repository checkout. `POWERLIT_LOCAL_CACHE` is no longer a mixed root/index setting.

Use:

```bash
python scripts/Search-PowerLitIndex.py \
  --query "distributed voltage control" \
  --venue-folder ieee_tsg \
  --top 10
```

On Windows, `scripts/Search-PowerLitJson.ps1` resolves the portable index first and uses `scripts/Search-PowerLitRaw.py` only when an explicit raw corpus is available.

Build a new schema-v2 cache with:

```bash
python scripts/Build-PowerLitIndex.py \
  --root <json-root> \
  --venue-folder ieee_tsg \
  --venue-folder ieee_tpwrs
```

Build output defaults to `$CODEX_HOME/powerlit/powerlit-index`; bundled assets are not overwritten implicitly.

## Retrieval Contract

The search layer must:

- preserve short domain tokens such as AC, DC, PV, EV, DR, UC, OPF, GMM, SDP, and RL;
- expand registered acronyms while retaining the original token;
- generate Chinese bigram/trigram candidates for substring recall;
- treat unknown or absent venue names as errors rather than silently widening the search;
- rank by field-aware matches in title, abstract, keywords, introduction, method, results, and conclusion when available;
- use publication year as a bounded recency signal, not an automatic quality score;
- deduplicate by normalized DOI and then normalized title;
- return relative paths only;
- expose corpus-coverage status and year coverage.

The bundled schema-v1 cache remains searchable. New builds use richer schema-v2 fields and optional trigram FTS.

## Query Decomposition

Translate the current paper or question into separate search objects:

- grid, device, market, or planning object;
- operating/planning problem;
- uncertainty, control, optimization, estimation, data, or communication mechanism;
- mathematical object;
- evidence object and benchmark;
- target venue and year window.

Use multiple focused queries rather than one long keyword string. Include both established terminology and manuscript-specific terminology.

## Venue Registry

Use `references/venue-registry.json` as the canonical alias map. Examples:

- `tpwrs` → `ieee_tpwrs`;
- `tsg` → `ieee_tsg`;
- `csee` → `中国电机工程学报`;
- `aeps` → `电力系统自动化`.

If a requested venue is absent from the manifest, return `UNKNOWN` coverage. Do not substitute all venues.

## Method Canon

Use `references/method-canon.json` when the task maps to a covered method family. It provides curated bibliographic anchors, not exhaustive recall.

- `powerlit_status=in_corpus` and accepted/verified entries may support citation and direct pattern inspection from the indexed record.
- `powerlit_status=out_of_corpus` entries support bibliographic positioning only unless full text is separately supplied.
- The canon cannot replace current nearest-neighbor retrieval.

## Novelty Comparison Gate

Search output may return:

- `REQUIRES_TECHNICAL_COMPARISON`: coverage is adequate for candidate retrieval, but a human/agent must compare technical objects;
- `UNKNOWN`: venue coverage, year coverage, record depth, or candidate count is inadequate.

For each serious competitor, compare:

| Dimension | Question |
|---|---|
| Problem | Is the same operating/planning difficulty solved? |
| Scenario | Is the same grid, uncertainty, information, or deployment setting used? |
| Model | Is the same formulation, variable relation, or mathematical object used? |
| Mechanism | Is the same technical mechanism or algorithmic property central? |
| Data | Are the same data assumptions, distributions, or information sources used? |
| Evidence | Are the same systems, baselines, metrics, and boundary cases tested? |
| Claim | Does the prior paper already establish the manuscript's principal claim? |

Only after this comparison may the task assign `HIGH_THREAT`, `MEDIUM_THREAT`, or `LOW_THREAT`. If source depth is insufficient, use `UNKNOWN`.

## Literature-Claim Discipline

- Never infer method details from title or metadata alone.
- Never invent titles, authors, years, venues, DOIs, results, or comparisons.
- Prefer recent technically adjacent work for competitor analysis and foundational work for method-family context.
- A missing-paper judgment without adequate corpus coverage must be marked `【待核查】`.
- A paper explicitly named by the manuscript but omitted from a necessary comparison may be marked `【已确认遗漏】`.
- Do not copy source wording.

## Descriptive Evidence Profiling

Use `scripts/Analyze-PowerLitEvidenceStrength.py` to select papers for direct inspection and identify lexical hints for systems, baselines, metrics, sensitivity/ablation, reproducibility, and scope boundaries.

The output is explicitly `UNCALIBRATED`:

- accepted-paper samples describe visible practices among accepted papers;
- they do not estimate acceptance probability;
- they do not define a journal review threshold;
- keyword presence does not establish evidence sufficiency.

Use the profile as a reading checklist, then inspect the selected papers before applying manuscript-specific requirements.

## Output Artifacts

For novelty or prewriting work, return:

- access and coverage status;
- focused queries and query analysis;
- candidate competitors with title, year, venue, DOI/relative path, matched fields, and retrieval rationale;
- the seven-dimension technical-overlap matrix;
- novelty threat with evidence, or `UNKNOWN`;
- bounded claim and required repairs.

For citation planning, return sentence-level citation roles: background, method family, limitation/gap, and direct competitor. For review, separate confirmed omissions from items requiring external verification.

## Fallback

When neither a portable index nor explicit raw corpus is available, state once:

```text
PowerLit unavailable; using literature-limited workflow.
```

Continue with supplied references and manuscript-internal evidence. Do not generate a fabricated citation pack or a low-novelty conclusion from absent retrieval evidence.
