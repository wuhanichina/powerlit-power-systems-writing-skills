from __future__ import annotations

import json
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[1]


def read_text(relative: str) -> str:
    return (REPO_ROOT / relative).read_text(encoding="utf-8")


def test_actual_case_evidence_packets_use_readiness_schema():
    packets = json.loads(read_text("evaluation/actual-case-evidence-packets.json"))
    allowed_states = {"BLOCKED", "SECTION_READY", "MANUSCRIPT_REVIEW_READY", "SUBMISSION_CANDIDATE"}
    assert packets
    for packet in packets:
        assert "target_score_band" not in packet
        assert packet["target_readiness_state"] in allowed_states
        assert "score_gate" not in packet
        gate = packet["readiness_gate"]
        assert "minimum_average" not in gate
        assert "minimum_core_category" not in gate
        assert gate["required_dimensions"]
        assert gate["blocking_conditions"]


def test_decision_rubric_is_internal_readiness_not_publication_probability():
    rubric = read_text("skills/powerlit-power-systems-paper-review/references/decision-rubric.md")
    assert "PowerLit Internal Readiness Index" in rubric
    assert "journal reviewer numeric evaluation" in rubric
    assert "publication-outcome probability" in rubric
    assert "P(Y=accept | X)" in rubric
    assert "SUBMISSION_CANDIDATE" in rubric


def test_rule_sources_registers_official_and_heuristic_rules():
    registry = read_text("references/rule-sources.yaml")
    for token in (
        "source_type: official",
        "source_type: literature",
        "source_type: heuristic",
        "checked_at: 2026-06-18",
        "ieee_pes_letter_initial_revision_page_limit",
        "socp_exactness_claim_template",
        "application_paper_not_auto_reject",
    ):
        assert token in registry


def test_letter_and_math_rules_are_scoped():
    letter = read_text("skills/ieee-power-engineering-letter-writing/references/letter-structure.md")
    assert "3 formatted pages" in letter
    assert "3.5 pages" in letter
    assert "4 pages" in letter
    assert "descriptive corpus signals, not as official page limits" in letter

    method = read_text("skills/powerlit-power-systems-paper-writing/references/method-model.md")
    assert "SOCP exactness template" in method
    assert "Distinguish quadratic penalty, augmented Lagrangian, and exact penalty" in method
    assert "relative to the given relaxation model and constraint set" in method


def test_application_paper_is_not_auto_rejected_for_engineering_integration():
    rubric = read_text("skills/powerlit-power-systems-paper-review/references/decision-rubric.md")
    standards = read_text("skills/powerlit-power-systems-paper-review/references/venue-standards.md")
    assert "Application Paper" in rubric
    assert "engineering integration is not an automatic rejection reason" in rubric
    assert "engineering integration or system deployment value is not an automatic rejection reason" in standards


def test_venue_profiles_preserve_research_object_before_adaptation():
    writing_skill = read_text("skills/powerlit-power-systems-paper-writing/SKILL.md")
    object_gate = read_text("skills/powerlit-power-systems-paper-writing/references/research-object-gate.md")
    venue_profile = read_text("skills/powerlit-power-systems-paper-writing/references/venue-profiles.md")
    aeps = read_text("skills/powerlit-power-systems-paper-writing/references/aeps.md")
    csee = read_text("skills/powerlit-power-systems-paper-writing/references/csee.md")
    tpwrs = read_text("skills/powerlit-power-systems-paper-writing/references/tpwrs.md")
    tsg = read_text("skills/powerlit-power-systems-paper-writing/references/tsg.md")
    method = read_text("skills/powerlit-power-systems-paper-writing/references/method-model.md")
    case = read_text("skills/powerlit-power-systems-paper-writing/references/case-conclusion.md")
    prewriting = read_text("skills/powerlit-power-systems-prewriting-review/references/venue-fit.md")
    review = read_text("skills/powerlit-power-systems-paper-review/references/venue-standards.md")

    assert "Load `references/research-object-gate.md`" in writing_skill
    assert "research object before venue adaptation" in writing_skill
    assert "The target journal comes after that" in object_gate
    assert "A venue profile must not change" in object_gate
    assert "Venue profiles are not topic converters" in venue_profile
    assert "object-preserving 电力系统自动化 style guide" in aeps
    assert "Do not rewrite a manuscript into grid dispatch, operation, or planning" in aeps
    assert "do not silently add the missing venue object" in venue_profile
    assert "the supplied research object" in csee
    assert "it must come from the supplied paper rather than from the venue profile" in tpwrs
    assert "flag venue mismatch or retarget instead of adding one" in tsg
    assert "Write the method section as a compact, object-preserving model and execution procedure" in method
    assert "Do not add optimization, planning, relaxation, guarantee, or scalability machinery" in method
    assert "flag TSG venue mismatch instead of adding one" in method
    assert "Use dispatch/control variables only when the supplied method actually has them" in case
    assert "Do not rewrite the idea into a venue's common topic" in prewriting
    assert "must not rewrite the manuscript into the venue's common topic" in review


def test_prewriting_repositions_real_innovation_with_physics_story():
    skill = read_text("skills/powerlit-power-systems-prewriting-review/SKILL.md")
    insight = read_text("skills/powerlit-power-systems-prewriting-review/references/insight-discovery.md")
    prompts = read_text("skills/powerlit-power-systems-prewriting-review/test-prompts.json")
    readme = read_text("README.md")

    assert "real-innovation repositioning" in skill
    assert "真实创新点重定位" in skill
    assert "multi-act engineering story" in skill
    assert "多幕工程故事与物理直觉" in skill
    assert "Act I: engineering scene" in skill
    assert "Act VI: boundary" in skill
    assert "math role" in skill
    assert "Do not make equation order the narrative order" in skill
    assert "Mathematics should define the model, explain the mechanism, expose the physical intuition, or delimit the claim" in skill

    assert "Physics-First Repositioning" in insight
    assert "Multi-Act Engineering Story" in insight
    assert "physical mechanism before mathematical structure" in insight
    assert "Use mathematics as the instrument that clarifies each act's engineering and physical meaning" in insight

    assert "real-innovation-physical-story" in prompts
    assert "真实创新点重定位、多幕工程故事与物理直觉" in readme


def test_paper_writing_confirms_innovation_and_title_before_drafting():
    skill = read_text("skills/powerlit-power-systems-paper-writing/SKILL.md")
    reference = read_text("skills/powerlit-power-systems-paper-writing/references/pre-drafting-confirmation.md")
    prompts = read_text("skills/powerlit-power-systems-paper-writing/test-prompts.json")
    readme = read_text("README.md")

    assert "references/pre-drafting-confirmation.md" in skill
    assert "写作前确认" in skill
    assert "file-search-confirmed innovation points" in skill
    assert "real industry or engineering pain point" in skill
    assert "technical-level research significance" in skill
    assert "feasible paper titles" in skill
    assert "ask the user to confirm" in skill
    assert "Do not begin a full-paper draft" in skill

    assert "Pre-Drafting Innovation and Title Confirmation" in reference
    assert "Pain Point First" in reference
    assert "Search project files before writing" in reference
    assert "文件检索后确认的创新点" in reference
    assert "corresponding real industry or engineering pain point" in reference
    assert "技术层面研究意义" in reference
    assert "文献检索辅助判断" in reference
    assert "可行论文标题" in reference
    assert "Do not continue into full manuscript drafting" in reference

    assert "pre-drafting-innovation-title-confirmation" in prompts
    assert "pre-drafting-pain-point-significance" in prompts
    assert "文件检索后确认" in readme
    assert "真实存在的行业/工程痛点" in readme


def test_section_quality_gates_cover_title_abstract_intro_case_conclusion():
    writing_skill = read_text("skills/powerlit-power-systems-paper-writing/SKILL.md")
    writing_gate = read_text("skills/powerlit-power-systems-paper-writing/references/manuscript-section-quality.md")
    review_skill = read_text("skills/powerlit-power-systems-paper-review/SKILL.md")
    review_gate = read_text("skills/powerlit-power-systems-paper-review/references/section-quality-review.md")
    writing_prompts = read_text("skills/powerlit-power-systems-paper-writing/test-prompts.json")
    review_prompts = read_text("skills/powerlit-power-systems-paper-review/test-prompts.json")
    readme = read_text("README.md")

    assert "references/manuscript-section-quality.md" in writing_skill
    assert "manuscript-section quality gate" in writing_skill
    assert "keywords precise and at most five" in writing_gate
    assert "recent high-level literature" in writing_gate
    assert "parameter sensitivity, ablation, or boundary tests" in writing_gate
    assert "avoid both exaggeration and excessive self-weakening" in writing_gate

    assert "references/section-quality-review.md" in review_skill
    assert "标题关键词与章节质量" in review_skill
    assert "no more than five" in review_gate
    assert "mainly from the last five years" in review_gate
    assert "sensitivity, ablation, or boundary tests" in review_gate
    assert "Overbroad deployment, robustness, generality, or scalability claims" in review_gate

    assert "manuscript-section-quality-gate" in writing_prompts
    assert "section-quality-review" in review_prompts
    assert "标题关键词与章节质量" in readme


def test_prewriting_scorecard_rates_readiness_and_maximum_defect():
    skill = read_text("skills/powerlit-power-systems-prewriting-review/SKILL.md")
    scorecard = read_text("skills/powerlit-power-systems-prewriting-review/references/prewriting-scorecard.md")
    prompts = read_text("skills/powerlit-power-systems-prewriting-review/test-prompts.json")
    readme = read_text("README.md")

    assert "references/prewriting-scorecard.md" in skill
    assert "scientificity, industry pain-point accuracy, correctness, reasonableness, innovation, and engineering feasibility" in skill
    assert "分项评分与总体评分" in skill
    assert "最大缺陷" in skill

    assert "Prewriting Scorecard" in scorecard
    assert "Scientificity" in scorecard
    assert "Industry pain-point accuracy" in scorecard
    assert "Correctness" in scorecard
    assert "Reasonableness" in scorecard
    assert "Engineering feasibility" in scorecard
    assert "overall 1-10 score" in scorecard
    assert "Maximum Defect" in scorecard
    assert "not publication probabilities" in scorecard

    assert "scorecard-and-maximum-defect" in prompts
    assert "科学性、行业痛点把握准确性、正确性、合理性、创新性和工程可行性" in readme


def test_independent_reviewer_prompt_is_portable_and_readiness_based():
    prompt = read_text("evaluation/behavior/independent-reviewer-prompt.md")
    assert "Independent Reviewer Prompt" in prompt
    assert "Every judgment must cite evidence" in prompt
    assert "PowerLit Internal Readiness Index" in prompt
    assert "BLOCKED" in prompt
    assert "SUBMISSION_CANDIDATE" in prompt
    assert ("D" + ":\\") not in prompt
    assert ("D" + ":/") not in prompt
    assert ("\\" + "One" + "Drive") not in prompt
    legacy_verdict = "直接录用" + " / 小修 / 大修 / 拒稿"
    assert legacy_verdict not in prompt
