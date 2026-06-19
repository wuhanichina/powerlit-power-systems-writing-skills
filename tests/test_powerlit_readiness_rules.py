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
