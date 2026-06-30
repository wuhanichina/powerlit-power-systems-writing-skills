---
name: powerlit-power-systems-prewriting-review
description: Gate power-system paper ideas or drafts before formal writing for 中国电机工程学报, 电力系统自动化, IEEE TPWRS, IEEE TSG, and IEEE power-system Letters. Use to decide GO, CONDITIONAL GO, NO-GO, or RETARGET based on innovation chain, model correctness, evidence readiness, and venue fit before invoking a writing skill.
---
# PowerLit Power-Systems Prewriting Review

## Purpose

Use this skill before formal drafting or heavy rewriting. Its job is to rediscover the project's real writable innovation when needed, build the multi-act engineering story and physics intuition that should carry the paper, then decide whether the current idea, outline, experiment package, or partial draft is ready to enter target-journal writing.

Do not polish prose first. A polished but unsupported paper should be stopped before writing.

Do not let mathematical derivation become the story by default. Mathematics should define the model, explain the mechanism, expose the physical intuition, or delimit the claim; the prewriting review must first identify the power-system object, physical coupling, operating contradiction, and evidence path that make the paper worth reading.

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
3. Load `references/minimum-research-object.md` and lock the smallest research object before naming the pain point, innovation, venue fit, or story:
   - identify the minimum research object, small peer group, closest problem family, broad background, and non-objects;
   - define the pain point inside that narrow object rather than importing a broader industry background;
   - treat a newly identified narrow research object as a possible innovation when the supplied evidence supports it.
4. Try to use `powerlit-power-systems-literature-intelligence` for a corpus-backed novelty check:
   - resolve PowerLit from user path, `POWERLIT_JSON_ROOT` or `POWERLIT_LITERATURE_JSON`;
   - if accessible, retrieve closest competitors and build a novelty-threat matrix;
   - if inaccessible, state fallback mode once and continue with the non-corpus prewriting review.
5. If the user is asking for early brainstorming, innovation discovery, idea reframing, real-innovation repositioning, physical storytelling, multi-act engineering story design, theoretical migration, or insight generation, load `references/insight-discovery.md` first. Generate candidate structures, label them as `known theory`, `structural analogy`, or `research hypothesis`, then return to the innovation-chain gate before any writing decision.
6. Load `references/preflight-gates.md`.
7. Load `references/innovation-chain.md` to test problem -> gap -> technical object -> mechanism -> evidence -> boundary.
8. Load `references/model-evidence-readiness.md` to check formulation correctness and case support.
9. Load `references/venue-fit.md` to decide whether the target journal is realistic.
10. Load `references/prewriting-scorecard.md` to score scientificity, industry pain-point accuracy, correctness, reasonableness, innovation, and engineering feasibility on a 1-10 scale against current research progress.
11. Run a real-innovation repositioning pass:
   - separate the project's strongest supported physical mechanism from weaker packaging, metric-only, or derivation-only framings;
   - verify that the selected innovation answers the minimum research object rather than a broader borrowed background;
   - state the paper's main story in power-system language before naming equations or algorithms;
   - write the story as acts, not as a derivation sequence;
   - identify which mathematical parts are necessary support and which should stay subordinate;
   - reject stories that are elegant mathematically but not anchored in the supplied engineering object or evidence.
12. Give one of four decisions:
   - `GO`: enter writing.
   - `CONDITIONAL GO`: enter writing only with narrowed claims or specified missing checks.
   - `NO-GO`: do not write yet; repair model, evidence, or positioning first.
   - `RETARGET`: current contribution may be publishable, but not in the requested venue/form.

## Output Contract

Use this structure:

Include a `PowerLit evidence` item that states access status, closest competitors, novelty threat, or fallback limitation.

1. `预审结论`: GO / CONDITIONAL GO / NO-GO / RETARGET.
2. `一句话判断`: concise reason.
3. `最小研究对象定位`: state the minimum research object, small peer problem domain, matching pain point, broad backgrounds or adjacent objects to avoid, and whether the innovation comes from identifying a new narrow research object.
4. `真实创新点重定位`: name the strongest writable innovation inside the minimum research object, the weaker framings to drop, the closest novelty threat, and the exact physical object that should carry the paper.
5. `多幕工程故事与物理直觉`: write the story as acts before derivations. Use:
   - Act I: engineering scene and why the problem matters;
   - Act II: physical contradiction, missing coupling, or failed intuition;
   - Act III: mechanism and physical intuition behind the proposed idea;
   - Act IV: technical object and where the mathematics enters as support;
   - Act V: evidence that isolates the mechanism;
   - Act VI: boundary, assumptions, and what must not be claimed.
   For each act, state the `math role`: model definition, mechanism explanation, intuition extraction, boundary proof, metric construction, or none. Do not make equation order the narrative order.
6. `洞见发掘`: include only when insight-discovery mode was used; state problem reconstruction, transferable structures, counterintuitive leads, honesty labels, and candidate technical objects.
7. `创新链`: problem, gap, technical object, mechanism, evidence, boundary.
8. `模型与正确性`: what is sound, what is undefined, what may be physically or mathematically wrong.
9. `算例支撑`: which claims are supported, unsupported, or overclaimed.
10. `目标期刊匹配`: whether the current package fits the venue.
11. `分项评分与总体评分`: 1-10 scores for scientificity, industry pain-point accuracy, correctness, reasonableness, innovation, engineering feasibility, plus an overall score and a short evidence-based explanation for each dimension.
12. `最大缺陷` / `maximum defect`: the single most damaging defect, why it matters, and what evidence or repair would most improve the score.
13. `进入写作前必须补齐`: short action list.
14. `写作边界`: if writing is allowed, state exactly what claims the writing skill may make.

## Hard Rule

If the innovation chain, model correctness, or evidence support is not ready, say so directly. Do not offer a writing plan that would hide the weakness in better prose.

Scores are diagnostic readiness scores, not publication probabilities or editor judgments. Do not inflate scores to make the user feel ready; scores must be anchored to supplied material, PowerLit/literature evidence when available, and current research progress.

Insight-discovery output is not a writing approval. A candidate idea labeled `structural analogy` or `research hypothesis` cannot become a manuscript claim until the innovation chain, model readiness, evidence path, and venue fit are checked.

A physical story is not an invitation to overclaim. If the most compelling story exceeds the available evidence, output it as a candidate story and mark the missing proof, simulation, baseline, sensitivity, or boundary test before allowing writing.

The multi-act story is a prewriting scaffold, not decorative prose. Each act must reduce reader burden by connecting engineering reality, physical intuition, technical construction, and evidence. If an act is only mathematical manipulation without engineering meaning, demote it to supporting material.

If PowerLit retrieval finds a closest competitor that already covers the same problem, mechanism, and evidence object, do not let prose polishing proceed until the claim is narrowed or the technical difference is made explicit.
