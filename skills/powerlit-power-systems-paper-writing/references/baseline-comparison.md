# Comparison With `research-paper-writing`

## What To Keep

The installed `research-paper-writing` skill provides useful general discipline:

- clarify the paper story before sentence edits,
- make each paragraph deliver one message,
- keep terms stable,
- align claims with evidence,
- review as a skeptical reviewer,
- keep tables and figures clean.

These remain valid for power-system papers.

## What To Replace

The installed skill is tuned for ML/CV/NLP-style writing. For power-system journals, replace these defaults:

- "task/SOTA/pipeline" -> "system object/model/constraint/solution/case".
- "teaser and pipeline figure" -> "formulation diagram, system topology, control block, or evidence table only when useful".
- "SOTA comparison" -> "method-class comparison, benchmark system, operating scenario, solver/protocol, and engineering metric".
- "ablation by module" -> "sensitivity, scenario comparison, uncertainty calibration, constraint/security check, or solver/runtime comparison".
- "paragraph roles in output" -> clean manuscript paragraphs without visible scaffolding.

## Main Improvement

The new skill is venue-routed. It uses empirical style signals from PowerLit JSON papers:

- 中国电机工程学报: broader engineering exposition, bilingual/article-format tendency, model/control/topology plus experiment/simulation evidence.
- 电力系统自动化: compact object-preserving style, explicit variables/constraints/indices/algorithm/case structure according to the supplied object.
- IEEE TPWRS: object-preserving formulation-led English, short abstract sentences, clear assumptions, tractability only when claimed, case studies, and precise contribution lists.
- IEEE TSG: IEEE Transactions structure with supplied smart-grid mechanisms: data, DER/distribution operation, distributed control, communication/cyber/privacy, and grid-edge evidence when those layers are present.

## Failure Modes Prevented

- Overusing "novel/comprehensive/significant" instead of stating the mathematical or engineering object.
- Writing "AI-polished" paragraphs that sound generic but do not define variables, constraints, systems, or metrics.
- Importing ML paper structure into power-system manuscripts.
- Leaving unsupported claims in the abstract or introduction.
- Letting a target venue profile rewrite the research object before the object has been identified.
