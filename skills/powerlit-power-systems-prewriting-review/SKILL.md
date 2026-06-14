---
name: powerlit-power-systems-prewriting-review
description: Gate power-system paper ideas or drafts before formal writing for 中国电机工程学报, 电力系统自动化, IEEE TPWRS, IEEE TSG, and IEEE power-system Letters. Use to decide GO, CONDITIONAL GO, NO-GO, or RETARGET based on innovation chain, model correctness, evidence readiness, and venue fit before invoking a writing skill.
---
# PowerLit Power-Systems Prewriting Review

## Purpose

Use this skill before formal drafting or heavy rewriting. Its job is to discover stronger early-stage insight when needed, then decide whether the current idea, outline, experiment package, or partial draft is ready to enter target-journal writing.

Do not polish prose first. A polished but unsupported paper should be stopped before writing.

## Core Workflow

1. Identify target venue:
   - 中国电机工程学报
   - 电力系统自动化
   - IEEE TPWRS
   - IEEE TSG
   - IEEE power-system Letter
2. Identify available material:
   - idea only,
   - early brainstorm or innovation-discovery request,
   - outline,
   - model/formulation,
   - experiment/case results,
   - full rough draft.
3. Try to use `powerlit-power-systems-literature-intelligence` for a corpus-backed novelty check:
   - resolve PowerLit from user path, `POWERLIT_JSON_ROOT`, `POWERLIT_LOCAL_CACHE`, `POWERLIT_LITERATURE_JSON`, or `\\WHome\PowerLit\literature\json`;
   - if accessible, retrieve closest competitors and build a novelty-threat matrix;
   - if inaccessible, state fallback mode once and continue with the non-corpus prewriting review.
4. If the user is asking for early brainstorming, innovation discovery, idea reframing, theoretical migration, or insight generation, load `references/insight-discovery.md` first. Generate candidate structures, label them as `known theory`, `structural analogy`, or `research hypothesis`, then return to the innovation-chain gate before any writing decision.
5. Load `references/preflight-gates.md`.
6. Load `references/innovation-chain.md` to test problem -> gap -> technical object -> mechanism -> evidence -> boundary.
7. Load `references/model-evidence-readiness.md` to check formulation correctness and case support.
8. Load `references/venue-fit.md` to decide whether the target journal is realistic.
9. Give one of four decisions:
   - `GO`: enter writing.
   - `CONDITIONAL GO`: enter writing only with narrowed claims or specified missing checks.
   - `NO-GO`: do not write yet; repair model, evidence, or positioning first.
   - `RETARGET`: current contribution may be publishable, but not in the requested venue/form.

## Output Contract

Use this structure:

Include a `PowerLit evidence` item that states access status, closest competitors, novelty threat, or fallback limitation.

1. `预审结论`: GO / CONDITIONAL GO / NO-GO / RETARGET.
2. `一句话判断`: concise reason.
3. `洞见发掘`: include only when insight-discovery mode was used; state problem reconstruction, transferable structures, counterintuitive leads, honesty labels, and candidate technical objects.
4. `创新链`: problem, gap, technical object, mechanism, evidence, boundary.
5. `模型与正确性`: what is sound, what is undefined, what may be physically or mathematically wrong.
6. `算例支撑`: which claims are supported, unsupported, or overclaimed.
7. `目标期刊匹配`: whether the current package fits the venue.
8. `进入写作前必须补齐`: short action list.
9. `写作边界`: if writing is allowed, state exactly what claims the writing skill may make.

## Hard Rule

If the innovation chain, model correctness, or evidence support is not ready, say so directly. Do not offer a writing plan that would hide the weakness in better prose.

Insight-discovery output is not a writing approval. A candidate idea labeled `structural analogy` or `research hypothesis` cannot become a manuscript claim until the innovation chain, model readiness, evidence path, and venue fit are checked.

If PowerLit retrieval finds a closest competitor that already covers the same problem, mechanism, and evidence object, do not let prose polishing proceed until the claim is narrowed or the technical difference is made explicit.
