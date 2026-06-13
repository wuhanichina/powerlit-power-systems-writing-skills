param(
    [switch]$SkipPowerLitSearch
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
$failures = New-Object System.Collections.Generic.List[string]

function Add-Failure {
    param([string]$Message)
    $failures.Add($Message) | Out-Null
}

function Read-Utf8 {
    param([string]$Path)
    return Get-Content -LiteralPath $Path -Raw -Encoding UTF8
}

$skillFiles = Get-ChildItem -LiteralPath (Join-Path $repoRoot "skills") -Recurse -File -Filter "SKILL.md"
foreach ($skillFile in $skillFiles) {
    $text = Read-Utf8 -Path $skillFile.FullName
    if (-not $text.StartsWith("---")) {
        Add-Failure "$($skillFile.FullName): missing frontmatter start"
    }
    if ($text -notmatch '(?s)^---\s*\r?\nname:\s*.+?\r?\ndescription:\s*.+?\r?\n---') {
        Add-Failure "$($skillFile.FullName): frontmatter must contain name and description"
    }

    $skillDir = Split-Path -Parent $skillFile.FullName
    $matches = [regex]::Matches($text, '`([^`]+)`')
    foreach ($match in $matches) {
        $candidate = $match.Groups[1].Value
        if ($candidate -match "^(references|scripts)/" -or $candidate -match "^(references|scripts)\\") {
            $relative = $candidate.Replace('/', '\')
            $target = Join-Path $skillDir $relative
            if (-not (Test-Path -LiteralPath $target)) {
                Add-Failure "$($skillFile.FullName): missing referenced path $candidate"
            }
        }
    }
}

$jsonFiles = Get-ChildItem -LiteralPath (Join-Path $repoRoot "skills") -Recurse -File -Filter "test-prompts.json"
foreach ($jsonFile in $jsonFiles) {
    try {
        $parsed = Read-Utf8 -Path $jsonFile.FullName | ConvertFrom-Json
        if (-not $parsed) {
            Add-Failure "$($jsonFile.FullName): empty test prompt file"
        }
        foreach ($prompt in $parsed) {
            if (-not $prompt.id -or -not $prompt.prompt -or -not $prompt.expected) {
                Add-Failure "$($jsonFile.FullName): each prompt must contain id, prompt, and expected"
            }
        }
    } catch {
        Add-Failure "$($jsonFile.FullName): invalid JSON: $($_.Exception.Message)"
    }
}

$paperSkill = Join-Path $repoRoot "skills\powerlit-power-systems-paper-writing\SKILL.md"
if (Test-Path -LiteralPath $paperSkill) {
    $paperSkillText = Read-Utf8 -Path $paperSkill
    if ($paperSkillText -notmatch "references/project-claim-translation\.md") {
        Add-Failure "paper-writing skill must load references/project-claim-translation.md"
    }
    if ($paperSkillText -notmatch "references/review-closed-loop\.md") {
        Add-Failure "paper-writing skill must load references/review-closed-loop.md"
    }
    if ($paperSkillText -notmatch "corpus style exemplars") {
        Add-Failure "paper-writing skill must require corpus style exemplars for venue-sensitive writing"
    }
    if ($paperSkillText -notmatch "references/published-paper-reconstruction\.md") {
        Add-Failure "paper-writing skill must load references/published-paper-reconstruction.md for reconstruction benchmarks"
    }
    if ($paperSkillText -notmatch "references/score-targeted-writing\.md") {
        Add-Failure "paper-writing skill must load references/score-targeted-writing.md for score-targeted drafting"
    }
    if ($paperSkillText -notmatch "boundary-posture pass") {
        Add-Failure "paper-writing skill must require a boundary-posture pass"
    }
    if ($paperSkillText -notmatch "formula physical-intuition pass") {
        Add-Failure "paper-writing skill must require a formula physical-intuition pass"
    }
    if ($paperSkillText -notmatch "references/reader-experience-pass\.md") {
        Add-Failure "paper-writing skill must load references/reader-experience-pass.md"
    }
    if ($paperSkillText -notmatch "mandatory reader-experience pass") {
        Add-Failure "paper-writing skill must require mandatory reader-experience pass"
    }
} else {
    Add-Failure "Missing paper-writing SKILL.md"
}

$claimTranslation = Join-Path $repoRoot "skills\powerlit-power-systems-paper-writing\references\project-claim-translation.md"
if (Test-Path -LiteralPath $claimTranslation) {
    $claimTranslationText = Read-Utf8 -Path $claimTranslation
    if ($claimTranslationText -notmatch "Project Claim to Paper Claim Translation") {
        Add-Failure "project-claim-translation.md must define the claim translation rule"
    }
    if ($claimTranslationText -notmatch "Actual-Project Regression Anchors") {
        Add-Failure "project-claim-translation.md must include actual-project regression anchors"
    }
    if ($claimTranslationText -notmatch "Boundary Without Defensive Posture") {
        Add-Failure "project-claim-translation.md must include the boundary-without-defensive-posture rule"
    }
} else {
    Add-Failure "Missing project-claim-translation.md"
}

$methodModelReference = Join-Path $repoRoot "skills\powerlit-power-systems-paper-writing\references\method-model.md"
if (Test-Path -LiteralPath $methodModelReference) {
    $methodModelText = Read-Utf8 -Path $methodModelReference
    if ($methodModelText -notmatch "Formula Physical Intuition") {
        Add-Failure "method-model.md must include Formula Physical Intuition"
    }
    if ($methodModelText -notmatch "quadratic power-flow kernel") {
        Add-Failure "method-model.md must include inverse PLF physical-intuition guidance"
    }
} else {
    Add-Failure "Missing method-model.md"
}

$corpusDrafting = Join-Path $repoRoot "skills\powerlit-power-systems-paper-writing\references\corpus-grounded-drafting.md"
if (Test-Path -LiteralPath $corpusDrafting) {
    $corpusDraftingText = Read-Utf8 -Path $corpusDrafting
    if ($corpusDraftingText -notmatch "Writing-Time Corpus Reference") {
        Add-Failure "corpus-grounded-drafting.md must include Writing-Time Corpus Reference"
    }
    if ($corpusDraftingText -notmatch "Do not copy") {
        Add-Failure "corpus-grounded-drafting.md must include a do-not-copy boundary"
    }
} else {
    Add-Failure "Missing corpus-grounded-drafting.md"
}

$decisionRubric = Join-Path $repoRoot "skills\powerlit-power-systems-paper-review\references\decision-rubric.md"
if (Test-Path -LiteralPath $decisionRubric) {
    $decisionRubricText = Read-Utf8 -Path $decisionRubric
    if ($decisionRubricText -notmatch "8-9 Target Gate") {
        Add-Failure "decision-rubric.md must define the 8-9 Target Gate"
    }
    if ($decisionRubricText -notmatch "Score-Target Output") {
        Add-Failure "decision-rubric.md must define score-target output"
    }
} else {
    Add-Failure "Missing decision-rubric.md"
}

$reviewModelMath = Join-Path $repoRoot "skills\powerlit-power-systems-paper-review\references\model-math.md"
if (Test-Path -LiteralPath $reviewModelMath) {
    $reviewModelMathText = Read-Utf8 -Path $reviewModelMath
    if ($reviewModelMathText -notmatch "Physical-Intuition Review") {
        Add-Failure "review model-math.md must include Physical-Intuition Review"
    }
} else {
    Add-Failure "Missing review model-math.md"
}

$reviewLanguageFormat = Join-Path $repoRoot "skills\powerlit-power-systems-paper-review\references\language-format.md"
if (Test-Path -LiteralPath $reviewLanguageFormat) {
    $reviewLanguageFormatText = Read-Utf8 -Path $reviewLanguageFormat
    if ($reviewLanguageFormatText -notmatch "defensive claim posture") {
        Add-Failure "review language-format.md must check defensive claim posture"
    }
} else {
    Add-Failure "Missing review language-format.md"
}

$reconstructionReference = Join-Path $repoRoot "skills\powerlit-power-systems-paper-writing\references\published-paper-reconstruction.md"
if (Test-Path -LiteralPath $reconstructionReference) {
    $reconstructionText = Read-Utf8 -Path $reconstructionReference
    if ($reconstructionText -notmatch "Published-Paper Reconstruction Benchmark") {
        Add-Failure "published-paper-reconstruction.md must define the reconstruction benchmark"
    }
    if ($reconstructionText -notmatch "Case-analysis data alone is not enough") {
        Add-Failure "published-paper-reconstruction.md must preserve the case-data boundary"
    }
    if ($reconstructionText -notmatch "Do not copy") {
        Add-Failure "published-paper-reconstruction.md must include a do-not-copy boundary"
    }
} else {
    Add-Failure "Missing published-paper-reconstruction.md"
}

$scoreTargetedReference = Join-Path $repoRoot "skills\powerlit-power-systems-paper-writing\references\score-targeted-writing.md"
if (Test-Path -LiteralPath $scoreTargetedReference) {
    $scoreTargetedText = Read-Utf8 -Path $scoreTargetedReference
    if ($scoreTargetedText -notmatch "Score-Targeted Writing Gate") {
        Add-Failure "score-targeted-writing.md must define the score-targeted writing gate"
    }
    if ($scoreTargetedText -notmatch "8-9 Full-Paper Minimum") {
        Add-Failure "score-targeted-writing.md must define the 8-9 full-paper minimum"
    }
    if ($scoreTargetedText -notmatch "Case-analysis evidence alone") {
        Add-Failure "score-targeted-writing.md must preserve the case-data boundary"
    }
} else {
    Add-Failure "Missing score-targeted-writing.md"
}

$readerExperienceReference = Join-Path $repoRoot "skills\powerlit-power-systems-paper-writing\references\reader-experience-pass.md"
if (Test-Path -LiteralPath $readerExperienceReference) {
    $readerExperienceText = Read-Utf8 -Path $readerExperienceReference
    if ($readerExperienceText -notmatch "Reader-Experience Pass") {
        Add-Failure "reader-experience-pass.md must define the reader-experience pass"
    }
    if ($readerExperienceText -notmatch "mandatory") {
        Add-Failure "reader-experience-pass.md must make the pass mandatory"
    }
    if ($readerExperienceText -notmatch "\[writing\]") {
        Add-Failure "reader-experience-pass.md must classify [writing] burdens"
    }
    if ($readerExperienceText -notmatch "\[topic-hard\]") {
        Add-Failure "reader-experience-pass.md must classify [topic-hard] burdens"
    }
} else {
    Add-Failure "Missing reader-experience-pass.md"
}

$reviewSkill = Join-Path $repoRoot "skills\powerlit-power-systems-paper-review\SKILL.md"
if (Test-Path -LiteralPath $reviewSkill) {
    $reviewSkillText = Read-Utf8 -Path $reviewSkill
    if ($reviewSkillText -notmatch "references/expert-reader-experience\.md") {
        Add-Failure "paper-review skill must load references/expert-reader-experience.md"
    }
    if ($reviewSkillText -notmatch "CONDITIONAL PASS") {
        Add-Failure "paper-review skill must output the expert reader-experience PASS scale"
    }
} else {
    Add-Failure "Missing paper-review SKILL.md"
}

$expertReaderExperience = Join-Path $repoRoot "skills\powerlit-power-systems-paper-review\references\expert-reader-experience.md"
if (Test-Path -LiteralPath $expertReaderExperience) {
    $expertReaderText = Read-Utf8 -Path $expertReaderExperience
    if ($expertReaderText -notmatch "Expert Reader-Experience Review") {
        Add-Failure "expert-reader-experience.md must define the expert reader-experience review"
    }
    if ($expertReaderText -notmatch "PASS.*CONDITIONAL PASS.*FAIL") {
        Add-Failure "expert-reader-experience.md must define PASS / CONDITIONAL PASS / FAIL"
    }
    if ($expertReaderText -notmatch "text-internal") {
        Add-Failure "expert-reader-experience.md must separate text-internal evidence"
    }
    if ($expertReaderText -notmatch "external-check-needed") {
        Add-Failure "expert-reader-experience.md must separate external-check-needed evidence"
    }
} else {
    Add-Failure "Missing expert-reader-experience.md"
}

$prewritingSkill = Join-Path $repoRoot "skills\powerlit-power-systems-prewriting-review\SKILL.md"
if (Test-Path -LiteralPath $prewritingSkill) {
    $prewritingSkillText = Read-Utf8 -Path $prewritingSkill
    if ($prewritingSkillText -notmatch "references/insight-discovery\.md") {
        Add-Failure "prewriting-review skill must load references/insight-discovery.md"
    }
    if ($prewritingSkillText -notmatch "return to the innovation-chain gate") {
        Add-Failure "prewriting-review skill must route insight discovery back to the innovation-chain gate"
    }
} else {
    Add-Failure "Missing prewriting-review SKILL.md"
}

$insightDiscovery = Join-Path $repoRoot "skills\powerlit-power-systems-prewriting-review\references\insight-discovery.md"
if (Test-Path -LiteralPath $insightDiscovery) {
    $insightText = Read-Utf8 -Path $insightDiscovery
    if ($insightText -notmatch "Insight Discovery") {
        Add-Failure "insight-discovery.md must define Insight Discovery"
    }
    if ($insightText -notmatch "known theory") {
        Add-Failure "insight-discovery.md must label known theory"
    }
    if ($insightText -notmatch "structural analogy") {
        Add-Failure "insight-discovery.md must label structural analogy"
    }
    if ($insightText -notmatch "research hypothesis") {
        Add-Failure "insight-discovery.md must label research hypothesis"
    }
    if ($insightText -notmatch "innovation-chain\.md") {
        Add-Failure "insight-discovery.md must route candidates back to innovation-chain.md"
    }
} else {
    Add-Failure "Missing insight-discovery.md"
}

$reconstructionCases = Join-Path $repoRoot "evaluation\powerlit-paper-reconstruction-cases.json"
if (Test-Path -LiteralPath $reconstructionCases) {
    try {
        $reconstructionCaseData = Read-Utf8 -Path $reconstructionCases | ConvertFrom-Json
        if (-not $reconstructionCaseData) {
            Add-Failure "${reconstructionCases}: empty reconstruction case file"
        }
        foreach ($case in $reconstructionCaseData) {
            if (-not $case.id -or -not $case.venue_folder -or -not $case.paper_type -or -not $case.selection_query -or -not $case.required_evidence_packet -or -not $case.masked_source -or -not $case.write_prompt -or -not $case.review_prompt -or -not $case.pass_criteria -or -not $case.section_level_only_when) {
                Add-Failure "${reconstructionCases}: each reconstruction case must contain all benchmark fields"
            }
            if ($case.write_prompt -notmatch "published-paper-reconstruction\.md") {
                Add-Failure "$reconstructionCases case $($case.id): write_prompt must invoke published-paper-reconstruction.md"
            }
            if ($case.review_prompt -notmatch "powerlit-power-systems-paper-review") {
                Add-Failure "$reconstructionCases case $($case.id): review_prompt must invoke powerlit-power-systems-paper-review"
            }
        }
    } catch {
        Add-Failure "${reconstructionCases}: invalid JSON: $($_.Exception.Message)"
    }
} else {
    Add-Failure "Missing evaluation\powerlit-paper-reconstruction-cases.json"
}

$actualEvidencePackets = Join-Path $repoRoot "evaluation\actual-case-evidence-packets.json"
if (Test-Path -LiteralPath $actualEvidencePackets) {
    try {
        $actualEvidencePacketData = Read-Utf8 -Path $actualEvidencePackets | ConvertFrom-Json
        if (-not $actualEvidencePacketData) {
            Add-Failure "${actualEvidencePackets}: empty actual evidence packet file"
        }
        foreach ($case in $actualEvidencePacketData) {
            if (-not $case.id -or -not $case.project -or -not $case.target_venue -or -not $case.target_score_band -or -not $case.paper_type -or -not $case.evidence_sources -or -not $case.evidence_packet -or -not $case.score_gate -or -not $case.write_prompt -or -not $case.review_prompt) {
                Add-Failure "${actualEvidencePackets}: each actual evidence packet must contain all score-target fields"
            }
            if ($case.target_score_band -ne "8-9") {
                Add-Failure "$actualEvidencePackets case $($case.id): target_score_band must be 8-9"
            }
            foreach ($sourcePath in $case.evidence_sources) {
                $localPath = [string]$sourcePath
                if (-not (Test-Path -LiteralPath $localPath)) {
                    Add-Failure "$actualEvidencePackets case $($case.id): evidence source path does not exist: $localPath"
                }
            }
            if (-not $case.evidence_packet.technical_object -or -not $case.evidence_packet.case_evidence -or -not $case.evidence_packet.claim_boundary) {
                Add-Failure "$actualEvidencePackets case $($case.id): evidence_packet must define technical_object, case_evidence, and claim_boundary"
            }
            if (-not $case.score_gate.minimum_average -or -not $case.score_gate.minimum_core_category -or -not $case.score_gate.must_not_fail) {
                Add-Failure "$actualEvidencePackets case $($case.id): score_gate must define minimum_average, minimum_core_category, and must_not_fail"
            }
            if ($case.write_prompt -notmatch "score-targeted") {
                Add-Failure "$actualEvidencePackets case $($case.id): write_prompt must invoke the score-targeted gate"
            }
            if ($case.review_prompt -notmatch "decision-rubric\.md") {
                Add-Failure "$actualEvidencePackets case $($case.id): review_prompt must invoke decision-rubric.md"
            }
        }
    } catch {
        Add-Failure "${actualEvidencePackets}: invalid JSON: $($_.Exception.Message)"
    }
} else {
    Add-Failure "Missing evaluation\actual-case-evidence-packets.json"
}

$reviewLoop = Join-Path $repoRoot "evaluation\writing-review-closure.json"
if (Test-Path -LiteralPath $reviewLoop) {
    try {
        $loopCases = Read-Utf8 -Path $reviewLoop | ConvertFrom-Json
        if (-not $loopCases) {
            Add-Failure "${reviewLoop}: empty review closure file"
        }
        foreach ($case in $loopCases) {
            if (-not $case.id -or -not $case.write_prompt -or -not $case.review_prompt -or -not $case.pass_criteria -or -not $case.repair_required_when) {
                Add-Failure "${reviewLoop}: each closure case must contain id, write_prompt, review_prompt, pass_criteria, and repair_required_when"
            }
            if ($case.review_prompt -notmatch "powerlit-power-systems-paper-review") {
                Add-Failure "$reviewLoop case $($case.id): review_prompt must invoke powerlit-power-systems-paper-review"
            }
        }
    } catch {
        Add-Failure "${reviewLoop}: invalid JSON: $($_.Exception.Message)"
    }
} else {
    Add-Failure "Missing evaluation\writing-review-closure.json"
}

$actualProjectFixtures = Join-Path $repoRoot "evaluation\actual-project-claim-regressions.json"
if (Test-Path -LiteralPath $actualProjectFixtures) {
    try {
        $actualCases = Read-Utf8 -Path $actualProjectFixtures | ConvertFrom-Json
        if (-not $actualCases) {
            Add-Failure "${actualProjectFixtures}: empty actual project regression file"
        }
        foreach ($case in $actualCases) {
            if (-not $case.id -or -not $case.project -or -not $case.source_paths -or -not $case.rigid_claim_symptom -or -not $case.review_failure_if_used_verbatim -or -not $case.paper_claim_translation -or -not $case.review_feedback_use -or -not $case.round1_expected_review -or -not $case.round2_expected_repair) {
                Add-Failure "${actualProjectFixtures}: each actual project case must contain all claim-regression fields"
            }
            if ($case.id -eq "pali-em-sca-identifiability-not-dominance") {
                if (-not $case.defensive_manuscript_failure -or -not $case.paper_fit_rewrite -or -not $case.formula_intuition_requirement) {
                    Add-Failure "${actualProjectFixtures}: PALI regression must cover defensive manuscript posture and formula intuition"
                }
            }
            foreach ($sourcePath in $case.source_paths) {
                $localPath = [string]$sourcePath
                if (-not (Test-Path -LiteralPath $localPath)) {
                    Add-Failure "${actualProjectFixtures} case $($case.id): source path does not exist: $localPath"
                }
            }
        }
    } catch {
        Add-Failure "${actualProjectFixtures}: invalid JSON: $($_.Exception.Message)"
    }
} else {
    Add-Failure "Missing evaluation\actual-project-claim-regressions.json"
}

$scoreTargetRunDir = Join-Path $repoRoot "evaluation\score-target-runs"
$scoreTargetRunFiles = @()
if (Test-Path -LiteralPath $scoreTargetRunDir) {
    $scoreTargetRunFiles = @(Get-ChildItem -LiteralPath $scoreTargetRunDir -File -Filter "*.md")
    foreach ($runFile in $scoreTargetRunFiles) {
        $runText = Read-Utf8 -Path $runFile.FullName
        if ($runText -notmatch "Target score band:.*8-9") {
            Add-Failure "$($runFile.FullName): score-target run must state target score band 8-9"
        }
        if ($runText -notmatch "Average score:") {
            Add-Failure "$($runFile.FullName): score-target run must include average score"
        }
        if ($runText -notmatch "Gate status:") {
            Add-Failure "$($runFile.FullName): score-target run must include gate status"
        }
        if ($runText -notmatch "Lowest-scoring category:") {
            Add-Failure "$($runFile.FullName): score-target run must include lowest-scoring category"
        }
        if ($runText -notmatch "First repair action:") {
            Add-Failure "$($runFile.FullName): score-target run must include first repair action"
        }
    }
}

$resolver = Join-Path $repoRoot "skills\powerlit-power-systems-literature-intelligence\scripts\Resolve-PowerLitJsonRoot.ps1"
if (Test-Path -LiteralPath $resolver) {
    $resolveOutput = & powershell -NoProfile -ExecutionPolicy Bypass -File $resolver
    $resolveJson = $resolveOutput | ConvertFrom-Json
    if ($resolveJson.available -ne $true) {
        Add-Failure "PowerLit resolve smoke failed"
    }
} else {
    Add-Failure "Missing PowerLit resolver script"
}

if (-not $SkipPowerLitSearch) {
    $search = Join-Path $repoRoot "skills\powerlit-power-systems-literature-intelligence\scripts\Search-PowerLitJson.ps1"
    if (Test-Path -LiteralPath $search) {
        $searchOutput = & powershell -NoProfile -ExecutionPolicy Bypass -File $search -Query "voltage control" -VenueFolder "ieee_tsg" -Top 1
        $searchJson = $searchOutput | ConvertFrom-Json
        if ($searchJson.available -ne $true) {
            Add-Failure "PowerLit search smoke did not report available=true"
        }
        if ($searchJson.results.Count -lt 1) {
            Add-Failure "PowerLit search smoke returned no results"
        }
    } else {
        Add-Failure "Missing PowerLit search script"
    }
}

if ($failures.Count -gt 0) {
    [pscustomobject]@{
        ok = $false
        failures = @($failures)
    } | ConvertTo-Json -Depth 5
    exit 1
}

[pscustomobject]@{
    ok = $true
    skill_count = $skillFiles.Count
    test_prompt_files = $jsonFiles.Count
    review_closure_cases = if (Test-Path -LiteralPath $reviewLoop) { @($loopCases).Count } else { 0 }
    actual_project_claim_cases = if (Test-Path -LiteralPath $actualProjectFixtures) { @($actualCases).Count } else { 0 }
    reconstruction_cases = if (Test-Path -LiteralPath $reconstructionCases) { @($reconstructionCaseData).Count } else { 0 }
    actual_case_evidence_packets = if (Test-Path -LiteralPath $actualEvidencePackets) { @($actualEvidencePacketData).Count } else { 0 }
    score_target_run_files = @($scoreTargetRunFiles).Count
    powerlit_search = $(if ($SkipPowerLitSearch) { "skipped" } else { "checked" })
} | ConvertTo-Json -Depth 5
