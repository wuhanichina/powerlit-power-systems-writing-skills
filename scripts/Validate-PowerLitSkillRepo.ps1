param(
    [switch]$SkipPowerLitSearch
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
$failures = New-Object System.Collections.Generic.List[string]
$powerShellCommand = Get-Command powershell -ErrorAction SilentlyContinue
if (-not $powerShellCommand) {
    $powerShellCommand = Get-Command pwsh -ErrorAction SilentlyContinue
}

function Add-Failure {
    param([string]$Message)
    $failures.Add($Message) | Out-Null
}

function Read-Utf8 {
    param([string]$Path)
    return Get-Content -LiteralPath $Path -Raw -Encoding UTF8
}

function Normalize-Text {
    param([string]$Text)
    if ($null -eq $Text) { return "" }
    return (($Text -replace "\s+", " ").Trim().ToLowerInvariant())
}

function Test-DoiFormat {
    param([string]$Doi)
    return ($Doi -match '^10\.\d{4,9}/\S+$')
}

function Invoke-PowerLitPowerShell {
    param(
        [string]$File,
        [string[]]$Arguments = @()
    )
    if (-not $script:powerShellCommand) {
        throw "No powershell or pwsh executable is available"
    }
    return & $script:powerShellCommand.Source -NoProfile -ExecutionPolicy Bypass -File $File @Arguments
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
    if ($paperSkillText -notmatch "references/powerlit-evidence-strength\.md") {
        Add-Failure "paper-writing skill must load references/powerlit-evidence-strength.md for PowerLit evidence-strength learning"
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
    if ($paperSkillText -notmatch "physical-story pass") {
        Add-Failure "paper-writing skill must require a physical-story pass"
    }
    if ($paperSkillText -notmatch "reviewer-feedback integration pass") {
        Add-Failure "paper-writing skill must require reviewer-feedback integration"
    }
    if ($paperSkillText -notmatch "engineering-math balance pass") {
        Add-Failure "paper-writing skill must require engineering-math balance"
    }
    if ($paperSkillText -notmatch "references/reader-experience-pass\.md") {
        Add-Failure "paper-writing skill must load references/reader-experience-pass.md"
    }
    if ($paperSkillText -notmatch "references/prose-quality-gates\.md") {
        Add-Failure "paper-writing skill must load references/prose-quality-gates.md"
    }
    if ($paperSkillText -match "Paragraphs:.*references/publishable-prose\.md") {
        Add-Failure "paper-writing skill must route mandatory paragraph cleanup through prose-quality-gates.md, not publishable-prose.md"
    }
    if ($paperSkillText -notmatch "Paragraphs: apply.*references/prose-quality-gates\.md") {
        Add-Failure "paper-writing skill must make prose-quality-gates.md the mandatory paragraph cleanup path"
    }
    if ($paperSkillText -notmatch "mandatory reader-experience pass") {
        Add-Failure "paper-writing skill must require mandatory reader-experience pass"
    }
    if ($paperSkillText -notmatch "skills/powerlit-power-systems-literature-intelligence/references/method-canon\.json") {
        Add-Failure "paper-writing skill must recognize verified method-canon citation sources"
    }
    if ($paperSkillText -notmatch "Do not invent or fill in missing DOI") {
        Add-Failure "paper-writing skill must preserve no-invention hard rules"
    }
    if ($paperSkillText -notmatch "Complete-Draft Mode") {
        Add-Failure "paper-writing skill must define complete-draft mode"
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
    if ($methodModelText -notmatch "Physical Story Before Mathematics") {
        Add-Failure "method-model.md must require physical story before mathematics"
    }
    if ($methodModelText -notmatch "uncommon mathematical theory") {
        Add-Failure "method-model.md must guide uncommon mathematical theory introduction"
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
    if ($corpusDraftingText -notmatch "Evidence-Strength Learning Pass") {
        Add-Failure "corpus-grounded-drafting.md must include Evidence-Strength Learning Pass"
    }
    if ($corpusDraftingText -notmatch "skills/powerlit-power-systems-literature-intelligence/references/method-canon\.json") {
        Add-Failure "corpus-grounded-drafting.md must route recurring topics through method-canon.json"
    }
    if ($corpusDraftingText -notmatch "citation_only" -or $corpusDraftingText -notmatch "citation_and_pattern") {
        Add-Failure "corpus-grounded-drafting.md must define method-canon usage policies"
    }
} else {
    Add-Failure "Missing corpus-grounded-drafting.md"
}

$powerlitEvidenceStrength = Join-Path $repoRoot "skills\powerlit-power-systems-paper-writing\references\powerlit-evidence-strength.md"
if (Test-Path -LiteralPath $powerlitEvidenceStrength) {
    $powerlitEvidenceStrengthText = Read-Utf8 -Path $powerlitEvidenceStrength
    if ($powerlitEvidenceStrengthText -notmatch "PowerLit Evidence-Strength Learning") {
        Add-Failure "powerlit-evidence-strength.md must define PowerLit Evidence-Strength Learning"
    }
    if ($powerlitEvidenceStrengthText -notmatch "Manuscript-Facing Quantities") {
        Add-Failure "powerlit-evidence-strength.md must define manuscript-facing quantities"
    }
    if ($powerlitEvidenceStrengthText -notmatch "Diagnostic or inverse-method claim") {
        Add-Failure "powerlit-evidence-strength.md must define the diagnostic or inverse-method evidence bar"
    }
    if ($powerlitEvidenceStrengthText -notmatch "Method-Canon Baselines") {
        Add-Failure "powerlit-evidence-strength.md must require method-canon baselines"
    }
    if ($powerlitEvidenceStrengthText -notmatch "out_of_corpus" -or $powerlitEvidenceStrengthText -notmatch "in_corpus") {
        Add-Failure "powerlit-evidence-strength.md must define in-corpus and out-of-corpus canon limits"
    }
} else {
    Add-Failure "Missing powerlit-evidence-strength.md"
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
    if ($reviewModelMathText -notmatch "Engineering-Math Balance Review") {
        Add-Failure "review model-math.md must include Engineering-Math Balance Review"
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
    if ($reviewLanguageFormatText -notmatch "reviewer-response leakage") {
        Add-Failure "review language-format.md must check reviewer-response leakage"
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
    if ($scoreTargetedText -notmatch "Full-Paper Completeness Gate") {
        Add-Failure "score-targeted-writing.md must define the full-paper completeness gate"
    }
    if ($scoreTargetedText -notmatch "blocked below 8-9 full-paper completeness") {
        Add-Failure "score-targeted-writing.md must define the compressed-package blocked status"
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

$proseQualityGates = Join-Path $repoRoot "skills\powerlit-power-systems-paper-writing\references\prose-quality-gates.md"
if (Test-Path -LiteralPath $proseQualityGates) {
    $proseQualityText = Read-Utf8 -Path $proseQualityGates
    if ($proseQualityText -notmatch "Working-language firewall") {
        Add-Failure "prose-quality-gates.md must preserve the working-language firewall"
    }
    if ($proseQualityText -notmatch "Chinese Register Gate") {
        Add-Failure "prose-quality-gates.md must preserve the Chinese register gate"
    }
    if ($proseQualityText -notmatch "No-Invention Boundary") {
        Add-Failure "prose-quality-gates.md must preserve no-invention cleanup boundaries"
    }
    if ($proseQualityText -notmatch "Reviewer-comment integration pass") {
        Add-Failure "prose-quality-gates.md must include reviewer-comment integration pass"
    }
    if ($proseQualityText -notmatch "Engineering-math balance pass") {
        Add-Failure "prose-quality-gates.md must include engineering-math balance pass"
    }
} else {
    Add-Failure "Missing prose-quality-gates.md"
}

$taskPromptsReference = Join-Path $repoRoot "skills\powerlit-power-systems-paper-writing\references\task-prompts.md"
if (Test-Path -LiteralPath $taskPromptsReference) {
    $taskPromptsText = Read-Utf8 -Path $taskPromptsReference
    $legacyCleanupDefault = [regex]::Escape('apply `publishable-prose.md`, `rhythm.md`, `lexicon.md`, and `anti-ai-style.md`')
    if ($taskPromptsText -match $legacyCleanupDefault) {
        Add-Failure "task-prompts.md must not make the legacy prose/rhythm/lexicon files the default cleanup path"
    }
    if ($taskPromptsText -notmatch "prose-quality-gates\.md" -or $taskPromptsText -notmatch "reader-experience-pass\.md") {
        Add-Failure "task-prompts.md must route light cleanup through prose-quality-gates.md and reader-experience-pass.md"
    }
    if ($taskPromptsText -notmatch "Reviewer-Comment Revision") {
        Add-Failure "task-prompts.md must include reviewer-comment revision handling"
    }
} else {
    Add-Failure "Missing task-prompts.md"
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
            if ([string]$case.project -notmatch "^project://") {
                Add-Failure "$actualEvidencePackets case $($case.id): project must be a logical project:// id"
            }
            foreach ($sourcePath in $case.evidence_sources) {
                $logicalPath = [string]$sourcePath
                if ($logicalPath -match "^[A-Za-z]:/" -or $logicalPath -match "^[A-Za-z]:\\" -or $logicalPath -match "^\\\\") {
                    Add-Failure "$actualEvidencePackets case $($case.id): evidence source must not be a machine path: $logicalPath"
                }
                if ($logicalPath -notmatch "^project://") {
                    Add-Failure "$actualEvidencePackets case $($case.id): evidence source must be a logical project:// id: $logicalPath"
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
        $reviewLoopText = Read-Utf8 -Path $reviewLoop
        if ($reviewLoopText -notmatch "reviewer-comment-physical-story-loop") {
            Add-Failure "${reviewLoop}: must include reviewer-comment physical-story closure case"
        }
        $loopCases = $reviewLoopText | ConvertFrom-Json
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
            if ([string]$case.project -notmatch "^project://") {
                Add-Failure "${actualProjectFixtures} case $($case.id): project must be a logical project:// id"
            }
            foreach ($sourcePath in $case.source_paths) {
                $logicalPath = [string]$sourcePath
                if ($logicalPath -match "^[A-Za-z]:/" -or $logicalPath -match "^[A-Za-z]:\\" -or $logicalPath -match "^\\\\") {
                    Add-Failure "${actualProjectFixtures} case $($case.id): source path must not be a machine path: $logicalPath"
                }
                if ($logicalPath -notmatch "^project://") {
                    Add-Failure "${actualProjectFixtures} case $($case.id): source path must be a logical project:// id: $logicalPath"
                }
            }
        }
    } catch {
        Add-Failure "${actualProjectFixtures}: invalid JSON: $($_.Exception.Message)"
    }
} else {
    Add-Failure "Missing evaluation\actual-project-claim-regressions.json"
}

$resolver = Join-Path $repoRoot "skills\powerlit-power-systems-literature-intelligence\scripts\Resolve-PowerLitJsonRoot.ps1"
if (Test-Path -LiteralPath $resolver) {
    $resolverText = Read-Utf8 -Path $resolver
    if ($resolverText -match "POWERLIT_LOCAL_SUBSET") {
        Add-Failure "PowerLit resolver must not use POWERLIT_LOCAL_SUBSET in the formal root chain"
    }
    foreach ($requiredRootToken in @("POWERLIT_JSON_ROOT", "POWERLIT_LITERATURE_JSON")) {
        if ($resolverText -notmatch [regex]::Escape($requiredRootToken)) {
            Add-Failure "PowerLit resolver missing root token: $requiredRootToken"
        }
    }
    $forbiddenRootTokens = @(
        ("POWERLIT_LOCAL" + "_CACHE"),
        ("\\W" + "Home\PowerLit\literature\json")
    )
    foreach ($forbiddenRootToken in $forbiddenRootTokens) {
        if ($resolverText -match [regex]::Escape($forbiddenRootToken)) {
            Add-Failure "PowerLit resolver must not contain machine-local root token: $forbiddenRootToken"
        }
    }
    $resolveOutput = Invoke-PowerLitPowerShell -File $resolver
    $resolveJson = $resolveOutput | ConvertFrom-Json
    if ($null -eq $resolveJson.available) {
        Add-Failure "PowerLit resolve smoke did not return availability status"
    }
} else {
    Add-Failure "Missing PowerLit resolver script"
}

$searchScript = Join-Path $repoRoot "skills\powerlit-power-systems-literature-intelligence\scripts\Search-PowerLitJson.ps1"
if (Test-Path -LiteralPath $searchScript) {
    $searchScriptText = Read-Utf8 -Path $searchScript
    foreach ($requiredSearchToken in @("Get-CandidateJsonFiles", "Get-Command rg", "candidate_count", "parsed_count", "elapsed_ms", "candidate_source")) {
        if ($searchScriptText -notmatch [regex]::Escape($requiredSearchToken)) {
            Add-Failure "Search-PowerLitJson.ps1 missing rg/telemetry token: $requiredSearchToken"
        }
    }
    foreach ($requiredIndexToken in @("POWERLIT_INDEX_ROOT", "Search-PowerLitIndex.py", "Resolve-PowerLitIndexRoot", "DisableIndex")) {
        if ($searchScriptText -notmatch [regex]::Escape($requiredIndexToken)) {
            Add-Failure "Search-PowerLitJson.ps1 missing index-first token: $requiredIndexToken"
        }
    }
    if ($searchScriptText -match "POWERLIT_LOCAL_SUBSET") {
        Add-Failure "Search-PowerLitJson.ps1 must not use POWERLIT_LOCAL_SUBSET"
    }
} else {
    Add-Failure "Missing PowerLit search script"
}

$indexCommonScript = Join-Path $repoRoot "skills\powerlit-power-systems-literature-intelligence\scripts\powerlit_index_common.py"
$indexBuildScript = Join-Path $repoRoot "skills\powerlit-power-systems-literature-intelligence\scripts\Build-PowerLitIndex.py"
$indexSearchScript = Join-Path $repoRoot "skills\powerlit-power-systems-literature-intelligence\scripts\Search-PowerLitIndex.py"
$queryAnalyzerScript = Join-Path $repoRoot "skills\powerlit-power-systems-literature-intelligence\scripts\query_analyzer.py"
$queryLexicon = Join-Path $repoRoot "skills\powerlit-power-systems-literature-intelligence\references\power-system-query-lexicon.json"
$venueRegistry = Join-Path $repoRoot "skills\powerlit-power-systems-literature-intelligence\references\venue-registry.json"
$builtInIndexRoot = Join-Path $repoRoot "skills\powerlit-power-systems-literature-intelligence\assets\powerlit-index"
foreach ($indexScript in @($indexCommonScript, $indexBuildScript, $indexSearchScript, $queryAnalyzerScript)) {
    if (-not (Test-Path -LiteralPath $indexScript -PathType Leaf)) {
        Add-Failure "Missing PowerLit index script: $indexScript"
    }
}
foreach ($referenceFile in @($queryLexicon, $venueRegistry)) {
    if (-not (Test-Path -LiteralPath $referenceFile -PathType Leaf)) {
        Add-Failure "Missing PowerLit retrieval reference file: $referenceFile"
    }
}
if ((Test-Path -LiteralPath $queryAnalyzerScript) -and (Get-Command python -ErrorAction SilentlyContinue)) {
    try {
        $queryAnalysisOutput = & python $queryAnalyzerScript --query "AC DC PV EV UC DR OPF GMM"
        $queryAnalysis = $queryAnalysisOutput | ConvertFrom-Json
        foreach ($abbr in @("AC", "DC", "PV", "EV", "UC", "DR", "OPF", "GMM")) {
            if (@($queryAnalysis.terms) -notcontains $abbr) {
                Add-Failure "query_analyzer.py must preserve abbreviation: $abbr"
            }
        }
    } catch {
        Add-Failure "query_analyzer.py smoke failed: $($_.Exception.Message)"
    }
}
if (-not (Test-Path -LiteralPath (Join-Path $builtInIndexRoot "manifest.json") -PathType Leaf)) {
    Add-Failure "Missing built-in PowerLit index manifest under literature skill assets"
} else {
    try {
        $indexManifest = Read-Utf8 -Path (Join-Path $builtInIndexRoot "manifest.json") | ConvertFrom-Json
        if ([int]$indexManifest.schema_version -lt 2) {
            Add-Failure "Built-in PowerLit index manifest must use portable schema_version >= 2"
        }
        foreach ($forbiddenManifestField in @("corpus_root", "index_dir", "source_root")) {
            if ($indexManifest.PSObject.Properties.Name -contains $forbiddenManifestField) {
                Add-Failure "Built-in PowerLit index manifest must not contain $forbiddenManifestField"
            }
        }
        if (-not $indexManifest.shards -or @($indexManifest.shards.PSObject.Properties).Count -lt 1) {
            Add-Failure "Built-in PowerLit index manifest must declare shard checksums"
        }
    } catch {
        Add-Failure "Built-in PowerLit index manifest is invalid JSON: $($_.Exception.Message)"
    }
}
if (Test-Path -LiteralPath $indexBuildScript) {
    $indexBuildText = Read-Utf8 -Path $indexBuildScript
    foreach ($requiredIndexBuildToken in @("manifest.json", "content_head_chars", "SQLite FTS", "CREATE VIRTUAL TABLE records_fts")) {
        if ($indexBuildText -notmatch [regex]::Escape($requiredIndexBuildToken)) {
            Add-Failure "Build-PowerLitIndex.py missing index-build token: $requiredIndexBuildToken"
        }
    }
}
if (Test-Path -LiteralPath $indexSearchScript) {
    $indexSearchText = Read-Utf8 -Path $indexSearchScript
    foreach ($requiredIndexSearchToken in @("powerlit_index_sqlite", "records_fts MATCH", "candidate_count", "parsed_count", "elapsed_ms", "matched_fields", "resolve_venues")) {
        if ($indexSearchText -notmatch [regex]::Escape($requiredIndexSearchToken)) {
            Add-Failure "Search-PowerLitIndex.py missing index-search token: $requiredIndexSearchToken"
        }
    }
}

$retrievalEvalDir = Join-Path $repoRoot "evaluation\retrieval"
foreach ($retrievalEvalFile in @("queries.jsonl", "qrels.jsonl", "expected_failures.json", "run_retrieval_eval.py")) {
    $target = Join-Path $retrievalEvalDir $retrievalEvalFile
    if (-not (Test-Path -LiteralPath $target -PathType Leaf)) {
        Add-Failure "Missing retrieval evaluation fixture: $target"
    }
}

$evidenceAnalyzer = Join-Path $repoRoot "skills\powerlit-power-systems-literature-intelligence\scripts\Analyze-PowerLitEvidenceStrength.ps1"
if (Test-Path -LiteralPath $evidenceAnalyzer) {
    $evidenceAnalyzerText = Read-Utf8 -Path $evidenceAnalyzer
    if ($evidenceAnalyzerText -match "POWERLIT_LOCAL_SUBSET") {
        Add-Failure "Analyze-PowerLitEvidenceStrength.ps1 must not use POWERLIT_LOCAL_SUBSET"
    }
    if ($evidenceAnalyzerText -notmatch "Measure-EvidenceSignals") {
        Add-Failure "Analyze-PowerLitEvidenceStrength.ps1 must measure evidence signals"
    }
    if ($evidenceAnalyzerText -notmatch "coverage_in_sample") {
        Add-Failure "Analyze-PowerLitEvidenceStrength.ps1 must return sample coverage"
    }
} else {
    Add-Failure "Missing PowerLit evidence-strength analyzer script"
}

$methodCanon = Join-Path $repoRoot "skills\powerlit-power-systems-literature-intelligence\references\method-canon.json"
if (Test-Path -LiteralPath $methodCanon) {
    try {
        $methodCanonData = Read-Utf8 -Path $methodCanon | ConvertFrom-Json
        if (-not $methodCanonData.entries -or @($methodCanonData.entries).Count -lt 10) {
            Add-Failure "${methodCanon}: must contain a nontrivial verified method canon"
        }
        $requiredDirectionIds = @($methodCanonData.required_direction_ids)
        if ($requiredDirectionIds.Count -lt 13) {
            Add-Failure "${methodCanon}: must declare the full required direction_id coverage set"
        }
        if (-not $methodCanonData.metadata_audit -or $methodCanonData.metadata_audit.source -ne "Crossref Works API" -or -not $methodCanonData.metadata_audit.reverified_at) {
            Add-Failure "${methodCanon}: must include a Crossref metadata audit snapshot"
        }
        $coveredDirectionIds = New-Object System.Collections.Generic.HashSet[string]
        foreach ($entry in @($methodCanonData.entries)) {
            foreach ($field in @("direction_id", "method_id", "role", "title", "year", "venue", "doi", "source_url", "selection_reason", "powerlit_status", "usage_policy", "metadata_verification", "curation_status", "last_reviewed")) {
                if (-not $entry.$field) {
                    Add-Failure "${methodCanon}: entry missing field $field"
                }
            }
            if ($entry.curation_status -eq "accepted") {
                if (-not (Test-DoiFormat -Doi ([string]$entry.doi))) {
                    Add-Failure "${methodCanon}: accepted entry has invalid DOI: $($entry.doi)"
                }
                if ($entry.metadata_verification.status -ne "verified") {
                    Add-Failure "${methodCanon}: accepted entry must have verified metadata: $($entry.doi)"
                }
                if (-not $entry.metadata_verification.retrieved_at -or $entry.metadata_verification.retrieved_at -eq "2026-06-14T00:00:00Z") {
                    Add-Failure "${methodCanon}: accepted entry must have a non-placeholder metadata retrieved_at: $($entry.doi)"
                }
                if (-not $entry.last_reviewed) {
                    Add-Failure "${methodCanon}: accepted entry missing last_reviewed: $($entry.doi)"
                }
                if ((Normalize-Text $entry.doi) -ne (Normalize-Text $entry.metadata_verification.doi)) {
                    Add-Failure "${methodCanon}: DOI does not match verification snapshot: $($entry.doi)"
                }
                if ((Normalize-Text $entry.title) -ne (Normalize-Text $entry.metadata_verification.title)) {
                    Add-Failure "${methodCanon}: title does not match verification snapshot: $($entry.doi)"
                }
                if ([int]$entry.year -ne [int]$entry.metadata_verification.year) {
                    Add-Failure "${methodCanon}: year does not match verification snapshot: $($entry.doi)"
                }
                if ((Normalize-Text $entry.venue) -ne (Normalize-Text $entry.metadata_verification.venue)) {
                    Add-Failure "${methodCanon}: venue does not match verification snapshot: $($entry.doi)"
                }
                $combinedCore = "$($entry.title) $($entry.doi) $($entry.selection_reason) $($entry.source_url)"
                if ($combinedCore -match "(?i)pending|candidate|verify title") {
                    Add-Failure "${methodCanon}: accepted entry contains pending/candidate language: $($entry.doi)"
                }
                if ($entry.metadata_verification.status -eq "verified") {
                    [void]$coveredDirectionIds.Add([string]$entry.direction_id)
                }
            }
            if ($entry.powerlit_status -eq "out_of_corpus" -and $entry.usage_policy -ne "citation_only") {
                Add-Failure "${methodCanon}: out_of_corpus entry must be citation_only: $($entry.doi)"
            }
            if ($entry.powerlit_status -eq "in_corpus") {
                if ($entry.usage_policy -ne "citation_and_pattern") {
                    Add-Failure "${methodCanon}: in_corpus entry must be citation_and_pattern: $($entry.doi)"
                }
                if (-not $entry.powerlit_relative_path) {
                    Add-Failure "${methodCanon}: in_corpus entry missing powerlit_relative_path: $($entry.doi)"
                }
            }
        }
        foreach ($directionId in $requiredDirectionIds) {
            if (-not $coveredDirectionIds.Contains([string]$directionId)) {
                Add-Failure "${methodCanon}: missing verified accepted canon coverage for direction_id=$directionId"
            }
        }
    } catch {
        Add-Failure "${methodCanon}: invalid JSON or schema check failed: $($_.Exception.Message)"
    }
} else {
    Add-Failure "Missing skills\powerlit-power-systems-literature-intelligence\references\method-canon.json"
}

$methodCanonSeed = Join-Path $repoRoot "evaluation\method-canon\web-canon-seed.md"
if (-not (Test-Path -LiteralPath $methodCanonSeed)) {
    Add-Failure "Missing evaluation\method-canon\web-canon-seed.md"
}

if (-not $SkipPowerLitSearch) {
    $search = Join-Path $repoRoot "skills\powerlit-power-systems-literature-intelligence\scripts\Search-PowerLitJson.ps1"
    if (Test-Path -LiteralPath $search) {
        $searchOutput = Invoke-PowerLitPowerShell -File $search -Arguments @("-Query", "voltage control", "-VenueFolder", "ieee_tsg", "-Top", "1")
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

$trackedIgnored = @(git -C $repoRoot ls-files -ci --exclude-standard 2>$null | Where-Object {
    Test-Path -LiteralPath (Join-Path $repoRoot $_)
})
if ($trackedIgnored.Count -gt 0) {
    Add-Failure "Tracked files match .gitignore: $($trackedIgnored -join ', ')"
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
    validation_layers = @("repository_lint", "schema_validation", $(if ($SkipPowerLitSearch) { "powerlit_search_smoke_skipped" } else { "powerlit_search_smoke" }))
    skill_count = $skillFiles.Count
    test_prompt_files = $jsonFiles.Count
    review_closure_cases = if (Test-Path -LiteralPath $reviewLoop) { @($loopCases).Count } else { 0 }
    actual_project_claim_cases = if (Test-Path -LiteralPath $actualProjectFixtures) { @($actualCases).Count } else { 0 }
    reconstruction_cases = if (Test-Path -LiteralPath $reconstructionCases) { @($reconstructionCaseData).Count } else { 0 }
    actual_case_evidence_packets = if (Test-Path -LiteralPath $actualEvidencePackets) { @($actualEvidencePacketData).Count } else { 0 }
    method_canon_entries = if ($methodCanonData -and $methodCanonData.entries) { @($methodCanonData.entries).Count } else { 0 }
    method_canon_directions = if ($methodCanonData -and $methodCanonData.entries) { @($methodCanonData.entries | Select-Object -ExpandProperty direction_id -Unique).Count } else { 0 }
    method_canon_required_directions = if ($methodCanonData -and $methodCanonData.required_direction_ids) { @($methodCanonData.required_direction_ids).Count } else { 0 }
    powerlit_search = $(if ($SkipPowerLitSearch) { "skipped" } else { "checked" })
} | ConvertTo-Json -Depth 5
