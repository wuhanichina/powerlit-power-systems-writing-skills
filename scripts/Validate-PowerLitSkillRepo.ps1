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

# Windows PowerShell 5.1 parses BOM-less UTF-8 .ps1 files as ANSI, which corrupts
# non-ASCII string literals at parse time. Require a BOM on every non-ASCII .ps1.
$psScriptFiles = Get-ChildItem -LiteralPath $repoRoot -Recurse -File -Filter "*.ps1" |
    Where-Object { $_.FullName -notmatch '\\(\.git|__pycache__|\.pytest_cache|\.venv|venv)\\' }
foreach ($psScriptFile in $psScriptFiles) {
    $scriptBytes = [System.IO.File]::ReadAllBytes($psScriptFile.FullName)
    $hasNonAscii = $false
    foreach ($scriptByte in $scriptBytes) {
        if ($scriptByte -gt 127) { $hasNonAscii = $true; break }
    }
    $hasUtf8Bom = ($scriptBytes.Length -ge 3 -and $scriptBytes[0] -eq 0xEF -and $scriptBytes[1] -eq 0xBB -and $scriptBytes[2] -eq 0xBF)
    if ($hasNonAscii -and -not $hasUtf8Bom) {
        Add-Failure "$($psScriptFile.FullName): .ps1 with non-ASCII content must be saved as UTF-8 with BOM so Windows PowerShell 5.1 can parse it"
    }
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
    if ($paperSkillText -notmatch "references/pre-drafting-confirmation\.md") {
        Add-Failure "paper-writing skill must load references/pre-drafting-confirmation.md"
    }
    if ($paperSkillText -notmatch "references/manuscript-section-quality\.md") {
        Add-Failure "paper-writing skill must load references/manuscript-section-quality.md"
    }
    if ($paperSkillText -notmatch "manuscript-section quality gate") {
        Add-Failure "paper-writing skill must run the manuscript-section quality gate"
    }
    if ($paperSkillText -notmatch "file-search-confirmed innovation points" -or $paperSkillText -notmatch "feasible paper titles") {
        Add-Failure "paper-writing skill must confirm innovation points and feasible paper titles before drafting"
    }
    if ($paperSkillText -notmatch "innovation level ladder" -or $paperSkillText -notmatch "professional problem statement" -or $paperSkillText -notmatch "evidence maturity and manuscript use") {
        Add-Failure "paper-writing skill must confirm innovation levels, evidence maturity, and professional problem wording before drafting"
    }
    if ($paperSkillText -notmatch "supports/does not support" -or $paperSkillText -notmatch "mainline innovation" -or $paperSkillText -notmatch "conditional contribution") {
        Add-Failure "paper-writing skill must avoid binary innovation wording in pre-drafting confirmation"
    }
    if ($paperSkillText -notmatch "non-binary manuscript framing pass" -or $paperSkillText -notmatch "formal manuscript prose as binary opposition") {
        Add-Failure "paper-writing skill must avoid binary opposition in formal manuscript prose"
    }
    if ($paperSkillText -notmatch "real industry or engineering pain point" -or $paperSkillText -notmatch "technical-level research significance") {
        Add-Failure "paper-writing skill must confirm pain point and technical-level research significance before drafting"
    }
    if ($paperSkillText -notmatch "theoretical value positioning" -or $paperSkillText -notmatch "engineering value positioning" -or $paperSkillText -notmatch "metric-level evidence") {
        Add-Failure "paper-writing skill must confirm theoretical and engineering value positioning above metric-level evidence before drafting"
    }
    foreach ($engineeringFirstToken in @("real power-system engineering need", "complete physical and engineering intuition", "linear technical logic", "relative evidence advantage", "evidence boundary as final claim-strength calibration")) {
        if ($paperSkillText -notmatch [regex]::Escape($engineeringFirstToken)) {
            Add-Failure "paper-writing skill missing engineering/physics-first positioning token: $engineeringFirstToken"
        }
    }
    foreach ($majorRevisionRouteToken in @("Select exactly one revision-entry route", "Existing-object Chinese major-revision route", "do not run or stop for the full", "brief by default", "Do not apply this STOP by default", "Escalation rule")) {
        if ($paperSkillText -notmatch [regex]::Escape($majorRevisionRouteToken)) {
            Add-Failure "paper-writing skill missing existing-object major-revision route token: $majorRevisionRouteToken"
        }
    }
    if ($paperSkillText -notmatch "references/review-closed-loop\.md") {
        Add-Failure "paper-writing skill must load references/review-closed-loop.md"
    }
    foreach ($requiredRoutingReference in @("references/innovation-narrative-router.md", "references/case-design-contracts.md", "references/innovation-exemplar-doi-map.md", "references/chinese-major-revision.md", "references/submission-consistency-check.md", "references/revision-response.md")) {
        if ($paperSkillText -notmatch [regex]::Escape($requiredRoutingReference)) {
            Add-Failure "paper-writing skill missing required workflow reference: $requiredRoutingReference"
        }
    }
    if ($paperSkillText -notmatch "corpus style exemplars") {
        Add-Failure "paper-writing skill must require corpus style exemplars for venue-sensitive writing"
    }
    if ($paperSkillText -notmatch "corpus progression pattern") {
        Add-Failure "paper-writing skill must require corpus-derived progression patterns"
    }
    if ($paperSkillText -notmatch "corpus terminology map") {
        Add-Failure "paper-writing skill must require a corpus-informed terminology map"
    }
    if ($paperSkillText -notmatch "corpus case-evidence plan") {
        Add-Failure "paper-writing skill must require corpus case-evidence plans"
    }
    if ($paperSkillText -notmatch "template-ready figure plan") {
        Add-Failure "paper-writing skill must require template-ready figure plans"
    }
    if ($paperSkillText -notmatch "01_IDEA/figure_plan\.md" -or $paperSkillText -notmatch "save_figure") {
        Add-Failure "paper-writing skill must bridge PowerLit figure planning to the project-template figure plan and save_figure gate"
    }
    if ($paperSkillText -notmatch "corpus main-body pattern") {
        Add-Failure "paper-writing skill must require corpus main-body patterns"
    }
    if ($paperSkillText -notmatch "references/lexicon\.md") {
        Add-Failure "paper-writing skill must load references/lexicon.md for terminology consistency"
    }
    if ($paperSkillText -notmatch "references/published-paper-reconstruction\.md") {
        Add-Failure "paper-writing skill must load references/published-paper-reconstruction.md for reconstruction benchmarks"
    }
    if ($paperSkillText -notmatch "references/powerlit-evidence-strength\.md") {
        Add-Failure "paper-writing skill must load references/powerlit-evidence-strength.md for PowerLit evidence-strength learning"
    }
    if ($paperSkillText -notmatch "references/internal-readiness-writing\.md") {
        Add-Failure "paper-writing skill must load references/internal-readiness-writing.md for readiness drafting"
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
    foreach ($technicalGateToken in @("mechanism-honesty status pass", "model-consistency blocker", "figures-only read test", "contribution significance gate")) {
        if ($paperSkillText -notmatch [regex]::Escape($technicalGateToken)) {
            Add-Failure "paper-writing skill missing always-run technical gate: $technicalGateToken"
        }
    }
    if ($paperSkillText -notmatch "Never trade a physical-intuition") {
        Add-Failure "paper-writing skill must forbid trading technical gates for prose-polish gates under budget pressure"
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

$preDraftingConfirmation = Join-Path $repoRoot "skills\powerlit-power-systems-paper-writing\references\pre-drafting-confirmation.md"
if (Test-Path -LiteralPath $preDraftingConfirmation) {
    $preDraftingConfirmationText = Read-Utf8 -Path $preDraftingConfirmation
    if ($preDraftingConfirmationText -notmatch "Pre-Drafting Innovation and Title Confirmation") {
        Add-Failure "pre-drafting-confirmation.md must define the pre-drafting confirmation gate"
    }
    if ($preDraftingConfirmationText -notmatch "Pain Point First") {
        Add-Failure "pre-drafting-confirmation.md must require pain-point-first confirmation"
    }
    if ($preDraftingConfirmationText -notmatch "technical-level research significance") {
        Add-Failure "pre-drafting-confirmation.md must require technical-level research significance"
    }
    foreach ($requiredPreDraftingToken in @("Innovation Level Ladder", "Discovery or conjecture verification", "Method-level contribution", "Engineering-problem contribution", "Evidence Maturity And Manuscript Use", "Mainline innovation", "Conditional contribution", "Observed phenomenon", "Boundary evidence", "Uncovered evidence need", "Professional Problem Statement")) {
        if ($preDraftingConfirmationText -notmatch [regex]::Escape($requiredPreDraftingToken)) {
            Add-Failure "pre-drafting-confirmation.md missing innovation-level/professional-wording token: $requiredPreDraftingToken"
        }
    }
    foreach ($requiredValuePositioningToken in @("PowerLit Theoretical And Engineering Value Positioning", "theoretical value positioning", "engineering value positioning", "metric-level evidence", "Metrics demonstrate value; they do not define it", "Corpus-near role")) {
        if ($preDraftingConfirmationText -notmatch [regex]::Escape($requiredValuePositioningToken)) {
            Add-Failure "pre-drafting-confirmation.md missing theoretical/engineering value-positioning token: $requiredValuePositioningToken"
        }
    }
    foreach ($requiredEngineeringFirstToken in @("Relative Evidence Advantage", "relative evidence advantage", "final claim-strength calibration", "do not force boundary language into every load-bearing section", 'Route directly to `chinese-major-revision.md` without the full')) {
        if ($preDraftingConfirmationText -notmatch [regex]::Escape($requiredEngineeringFirstToken)) {
            Add-Failure "pre-drafting-confirmation.md missing engineering-first routing token: $requiredEngineeringFirstToken"
        }
    }
    if ($preDraftingConfirmationText -match [regex]::Escape("evidence boundary that must appear in abstract, introduction, result discussion, and conclusion")) {
        Add-Failure "pre-drafting-confirmation.md must treat evidence boundaries as final calibration, not mandatory narrative content in every load-bearing section"
    }
    if ($preDraftingConfirmationText -notmatch "binary `"supports X / does not support Y`"" -or $preDraftingConfirmationText -notmatch "the current evidence is best used as") {
        Add-Failure "pre-drafting-confirmation.md must avoid binary support language for innovation mining"
    }
    if ($preDraftingConfirmationText -notmatch "Search project files before writing") {
        Add-Failure "pre-drafting-confirmation.md must require project-file search"
    }
    if ($preDraftingConfirmationText -notmatch "PowerLit or literature retrieval") {
        Add-Failure "pre-drafting-confirmation.md must allow PowerLit or literature retrieval support"
    }
    if ($preDraftingConfirmationText -notmatch "Do not continue into full manuscript drafting") {
        Add-Failure "pre-drafting-confirmation.md must block full drafting before user confirmation"
    }
} else {
    Add-Failure "Missing pre-drafting-confirmation.md"
}

$prewritingInnovationChain = Join-Path $repoRoot "skills\powerlit-power-systems-prewriting-review\references\innovation-chain.md"
if (Test-Path -LiteralPath $prewritingInnovationChain) {
    $prewritingInnovationChainText = Read-Utf8 -Path $prewritingInnovationChain
    foreach ($requiredInnovationChainToken in @("Innovation level", "Evidence maturity", "Value position", "theoretical value", "engineering value", "metric gain", "discovery or conjecture verification", "method-level contribution", "engineering-problem contribution", "Non-Binary Innovation Framing", "mainline innovation", "conditional contribution", "observed phenomenon", "boundary evidence", "uncovered evidence need", "Professional Problem Naming")) {
        if ($prewritingInnovationChainText -notmatch [regex]::Escape($requiredInnovationChainToken)) {
            Add-Failure "innovation-chain.md missing innovation-level/professional-wording token: $requiredInnovationChainToken"
        }
    }
} else {
    Add-Failure "Missing innovation-chain.md"
}

$innovationAssessment = Join-Path $repoRoot "skills\powerlit-power-systems-prewriting-review\references\innovation-narrative-assessment.md"
$innovationRouter = Join-Path $repoRoot "skills\powerlit-power-systems-paper-writing\references\innovation-narrative-router.md"
$caseContracts = Join-Path $repoRoot "skills\powerlit-power-systems-paper-writing\references\case-design-contracts.md"
$innovationDoiMap = Join-Path $repoRoot "skills\powerlit-power-systems-paper-writing\references\innovation-exemplar-doi-map.md"
$chineseMajorRevision = Join-Path $repoRoot "skills\powerlit-power-systems-paper-writing\references\chinese-major-revision.md"
$submissionConsistency = Join-Path $repoRoot "skills\powerlit-power-systems-paper-writing\references\submission-consistency-check.md"
$revisionResponse = Join-Path $repoRoot "skills\powerlit-power-systems-paper-writing\references\revision-response.md"
$handoffContract = Join-Path $repoRoot "contracts\project-template-handoff.schema.yaml"
foreach ($requiredWorkflowFile in @($innovationAssessment, $innovationRouter, $caseContracts, $innovationDoiMap, $chineseMajorRevision, $submissionConsistency, $revisionResponse, $handoffContract)) {
    if (-not (Test-Path -LiteralPath $requiredWorkflowFile -PathType Leaf)) {
        Add-Failure "Missing innovation/handoff workflow file: $requiredWorkflowFile"
    }
}
if (Test-Path -LiteralPath $innovationDoiMap) {
    $doiMapText = Read-Utf8 -Path $innovationDoiMap
    foreach ($token in @("New Research Object", "New Variable or Scenario", "New Method", "New Discovery or Observation", "New Mechanism", "New Framework or Decision Loop", "10.1109/TPWRS.2017.2692268", "10.1109/TSG.2019.2935736", "retrieval index, not a citation list")) {
        if ($doiMapText -notmatch [regex]::Escape($token)) { Add-Failure "innovation DOI map missing token: $token" }
    }
}
if (Test-Path -LiteralPath $innovationAssessment) {
    $assessmentText = Read-Utf8 -Path $innovationAssessment
    foreach ($token in @("Research object", "Discovery / mechanism", "Technical object", "Engineering decision loop", "zero-to-one", "one-to-hundred")) {
        if ($assessmentText -notmatch [regex]::Escape($token)) { Add-Failure "innovation assessment missing token: $token" }
    }
}
$figureFirstReference = Join-Path $repoRoot "skills\powerlit-power-systems-paper-writing\references\figures-tables-results.md"
if (Test-Path -LiteralPath $figureFirstReference) {
    $figureFirstText = Read-Utf8 -Path $figureFirstReference
    foreach ($token in @("expectedTrend", "keyFeatureToInspect", "mechanismToTest", "advantageCriterion", "boundaryTest", "Quantitative difference", "Engineering implication")) {
        if ($figureFirstText -notmatch [regex]::Escape($token)) { Add-Failure "Figure-first workflow missing token: $token" }
    }
}
$evidenceVerbReference = Join-Path $repoRoot "skills\powerlit-power-systems-paper-writing\references\prose-quality-gates.md"
if (Test-Path -LiteralPath $evidenceVerbReference) {
    if ((Read-Utf8 -Path $evidenceVerbReference) -notmatch "Power-System Evidence-to-Verb Ladder") {
        Add-Failure "prose-quality-gates.md must define the evidence-to-verb ladder"
    }
}

foreach ($fixtureName in @("innovation-narrative-cases.json", "figure-first-evidence-cases.json")) {
    $fixturePath = Join-Path $repoRoot "evaluation\$fixtureName"
    if (-not (Test-Path -LiteralPath $fixturePath -PathType Leaf)) {
        Add-Failure "Missing workflow regression fixture: $fixtureName"
        continue
    }
    try {
        $fixtureData = Read-Utf8 -Path $fixturePath | ConvertFrom-Json
        foreach ($case in @($fixtureData)) {
            if (-not $case.id -or -not $case.prompt -or -not $case.expected) {
                Add-Failure "$fixtureName cases must contain id, prompt, and expected"
            }
        }
    } catch {
        Add-Failure "${fixturePath}: invalid JSON: $($_.Exception.Message)"
    }
}

$prewritingInsightDiscovery = Join-Path $repoRoot "skills\powerlit-power-systems-prewriting-review\references\insight-discovery.md"
if (Test-Path -LiteralPath $prewritingInsightDiscovery) {
    $prewritingInsightDiscoveryText = Read-Utf8 -Path $prewritingInsightDiscovery
    foreach ($requiredInsightToken in @("innovation level separation", "discovery or conjecture verification", "method-level contribution", "engineering-problem contribution", "mainline innovation", "conditional contribution", "observed phenomenon", "boundary evidence", "uncovered evidence need", "internal project names", "Higher-Level Value Positioning", "theoretical value", "engineering value", "metric gain", "metric-level evidence")) {
        if ($prewritingInsightDiscoveryText -notmatch [regex]::Escape($requiredInsightToken)) {
            Add-Failure "insight-discovery.md missing innovation-level/professional-wording token: $requiredInsightToken"
        }
    }
} else {
    Add-Failure "Missing insight-discovery.md"
}

$manuscriptSectionQuality = Join-Path $repoRoot "skills\powerlit-power-systems-paper-writing\references\manuscript-section-quality.md"
if (Test-Path -LiteralPath $manuscriptSectionQuality) {
    $manuscriptSectionQualityText = Read-Utf8 -Path $manuscriptSectionQuality
    if ($manuscriptSectionQualityText -notmatch "Manuscript Section Quality Gate") {
        Add-Failure "manuscript-section-quality.md must define the section quality gate"
    }
    foreach ($requiredSectionToken in @("Title and Keywords", "Abstract", "Introduction", "Case Analysis", "Conclusion", "no more than five", "recent high-level literature", "parameter sensitivity")) {
        if ($manuscriptSectionQualityText -notmatch [regex]::Escape($requiredSectionToken)) {
            Add-Failure "manuscript-section-quality.md missing token: $requiredSectionToken"
        }
    }
    foreach ($requiredNonBinarySectionToken in @("binary opposition", "supported vs unsupported", "non-binary framing")) {
        if ($manuscriptSectionQualityText -notmatch [regex]::Escape($requiredNonBinarySectionToken)) {
            Add-Failure "manuscript-section-quality.md missing non-binary manuscript token: $requiredNonBinarySectionToken"
        }
    }
    if ($manuscriptSectionQualityText -notmatch "Contribution Significance Gate") {
        Add-Failure "manuscript-section-quality.md must define the contribution significance gate"
    }
    foreach ($significanceToken in @("Primary insight type", "Non-trivial claim", "Reader consequence", "Largest remaining defect", "story defect")) {
        if ($manuscriptSectionQualityText -notmatch [regex]::Escape($significanceToken)) {
            Add-Failure "manuscript-section-quality.md missing significance gate token: $significanceToken"
        }
    }
} else {
    Add-Failure "Missing manuscript-section-quality.md"
}

if (Test-Path -LiteralPath $chineseMajorRevision) {
    $chineseMajorRevisionText = Read-Utf8 -Path $chineseMajorRevision
    foreach ($requiredMajorRevisionToken in @("Chinese Major-Revision Practice", "Build a Source-Authority Map", "Portability Boundary", "clean-room writing functions", "Lock Promises and Body Landings", "why -> what it means -> how it connects", "Separate Observation From Causal Explanation", "Colon discipline", "formula references that point forward", "malformed LaTeX")) {
        if ($chineseMajorRevisionText -notmatch [regex]::Escape($requiredMajorRevisionToken)) {
            Add-Failure "chinese-major-revision.md missing token: $requiredMajorRevisionToken"
        }
    }
} else {
    Add-Failure "Missing chinese-major-revision.md"
}

$proseQualityGates = Join-Path $repoRoot "skills\powerlit-power-systems-paper-writing\references\prose-quality-gates.md"
if (Test-Path -LiteralPath $proseQualityGates) {
    $proseQualityGatesText = Read-Utf8 -Path $proseQualityGates
    foreach ($requiredNonBinaryProseToken in @("Non-Binary Manuscript Framing Gate", "positive technical scope", "conditional applicability", "observed phenomenon", "boundary evidence", "future-work need")) {
        if ($proseQualityGatesText -notmatch [regex]::Escape($requiredNonBinaryProseToken)) {
            Add-Failure "prose-quality-gates.md missing non-binary manuscript token: $requiredNonBinaryProseToken"
        }
    }
} else {
    Add-Failure "Missing prose-quality-gates.md"
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
    if ($methodModelText -notmatch "Mechanism Honesty") {
        Add-Failure "method-model.md must include the mechanism honesty pass"
    }
    if ($methodModelText -notmatch "Model Consistency Blocker") {
        Add-Failure "method-model.md must include the model consistency blocker"
    }
    foreach ($mechanismToken in @("model-derivable", "consistent-with-model", "unverified interpretation")) {
        if ($methodModelText -notmatch [regex]::Escape($mechanismToken)) {
            Add-Failure "method-model.md missing mechanism status token: $mechanismToken"
        }
    }
    if ($methodModelText -notmatch "Physical Story Before Mathematics") {
        Add-Failure "method-model.md must require physical story before mathematics"
    }
    if ($methodModelText -notmatch "uncommon mathematical theory") {
        Add-Failure "method-model.md must guide uncommon mathematical theory introduction"
    }
    if ($methodModelText -notmatch "Corpus-Derived Main-Body Construction") {
        Add-Failure "method-model.md must include corpus-derived main-body construction"
    }
} else {
    Add-Failure "Missing method-model.md"
}

$caseConclusionReference = Join-Path $repoRoot "skills\powerlit-power-systems-paper-writing\references\case-conclusion.md"
if (Test-Path -LiteralPath $caseConclusionReference) {
    $caseConclusionText = Read-Utf8 -Path $caseConclusionReference
    if ($caseConclusionText -notmatch "Neighbor Case-Study Learning") {
        Add-Failure "case-conclusion.md must include neighbor case-study learning"
    }
    if ($caseConclusionText -notmatch "figure/table roles") {
        Add-Failure "case-conclusion.md must require figure/table role extraction"
    }
} else {
    Add-Failure "Missing case-conclusion.md"
}

$figuresTablesResultsReference = Join-Path $repoRoot "skills\powerlit-power-systems-paper-writing\references\figures-tables-results.md"
if (Test-Path -LiteralPath $figuresTablesResultsReference) {
    $figuresTablesResultsText = Read-Utf8 -Path $figuresTablesResultsReference
    if ($figuresTablesResultsText -notmatch "PowerLit Neighbor Evidence Plan") {
        Add-Failure "figures-tables-results.md must include PowerLit neighbor evidence planning"
    }
    if ($figuresTablesResultsText -notmatch "figure/table argument map") {
        Add-Failure "figures-tables-results.md must require figure/table argument maps"
    }
    if ($figuresTablesResultsText -notmatch "Project-Template Figure Plan Bridge") {
        Add-Failure "figures-tables-results.md must include the project-template figure plan bridge"
    }
    if ($figuresTablesResultsText -notmatch "01_IDEA/figure_plan\.md" -or $figuresTablesResultsText -notmatch "save_figure") {
        Add-Failure "figures-tables-results.md must reference the template figure plan and save_figure metadata gate"
    }
    if ($figuresTablesResultsText -notmatch "physicsReproduction" -or $figuresTablesResultsText -notmatch "sciQuestion") {
        Add-Failure "figures-tables-results.md must include template figure metadata fields"
    }
    if ($figuresTablesResultsText -notmatch "Case-Section Figure Storyboard") {
        Add-Failure "figures-tables-results.md must define the case-section figure storyboard"
    }
    if ($figuresTablesResultsText -notmatch "Figures-Only Read Test") {
        Add-Failure "figures-tables-results.md must define the figures-only read test"
    }
    foreach ($storyboardToken in @("storyboardAct", "figureOnlyReadable", "Engineering scene", "Physical contradiction", "intermediate quantity")) {
        if ($figuresTablesResultsText -notmatch [regex]::Escape($storyboardToken)) {
            Add-Failure "figures-tables-results.md missing figure storyboard token: $storyboardToken"
        }
    }
} else {
    Add-Failure "Missing figures-tables-results.md"
}

$reviewClosedLoopReference = Join-Path $repoRoot "skills\powerlit-power-systems-paper-writing\references\review-closed-loop.md"
if (Test-Path -LiteralPath $reviewClosedLoopReference) {
    $reviewClosedLoopText = Read-Utf8 -Path $reviewClosedLoopReference
    if ($reviewClosedLoopText -notmatch "Required review references") {
        Add-Failure "review-closed-loop.md must name the review references it loads"
    }
    foreach ($closureToken in @("innovation-logic.md", "model-math.md", "evidence-case-conclusion.md", "expert-reader-experience.md", "decision-rubric.md", "本地审稿建议", "致命项清单", "专家级阅读体验")) {
        if ($reviewClosedLoopText -notmatch [regex]::Escape($closureToken)) {
            Add-Failure "review-closed-loop.md missing closure verdict token: $closureToken"
        }
    }
} else {
    Add-Failure "Missing review-closed-loop.md"
}

$aepsVenueReference = Join-Path $repoRoot "skills\powerlit-power-systems-paper-writing\references\aeps.md"
if (Test-Path -LiteralPath $aepsVenueReference) {
    $aepsVenueText = Read-Utf8 -Path $aepsVenueReference
    if ($aepsVenueText -notmatch "验证了") {
        Add-Failure "aeps.md must keep the measured AEPS validation closing convention"
    }
    if ($aepsVenueText -notmatch "prose-quality-gates\.md") {
        Add-Failure "aeps.md must point the validation closing sentence at its section-scope rule"
    }
} else {
    Add-Failure "Missing aeps.md"
}

$corpusDrafting = Join-Path $repoRoot "skills\powerlit-power-systems-paper-writing\references\corpus-grounded-drafting.md"
if (Test-Path -LiteralPath $corpusDrafting) {
    $corpusDraftingText = Read-Utf8 -Path $corpusDrafting
    if ($corpusDraftingText -notmatch "Writing-Time Corpus Reference") {
        Add-Failure "corpus-grounded-drafting.md must include Writing-Time Corpus Reference"
    }
    if ($corpusDraftingText -notmatch "Corpus Pattern Extraction Pass") {
        Add-Failure "corpus-grounded-drafting.md must include corpus pattern extraction"
    }
    if ($corpusDraftingText -notmatch "sentence_payload_sequence") {
        Add-Failure "corpus-grounded-drafting.md must extract sentence payload sequences"
    }
    if ($corpusDraftingText -notmatch "Terminology Learning Pass") {
        Add-Failure "corpus-grounded-drafting.md must include terminology learning from PowerLit"
    }
    if ($corpusDraftingText -notmatch "Corpus terminology map") {
        Add-Failure "corpus-grounded-drafting.md must require a corpus terminology map"
    }
    if ($corpusDraftingText -notmatch "Case-Evidence and Main-Body Learning Pass") {
        Add-Failure "corpus-grounded-drafting.md must include case-evidence and main-body learning"
    }
    if ($corpusDraftingText -notmatch "Corpus case-evidence plan" -or $corpusDraftingText -notmatch "Corpus main-body pattern") {
        Add-Failure "corpus-grounded-drafting.md must define case-evidence and main-body internal artifacts"
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
    if ($decisionRubricText -notmatch "PowerLit Internal Readiness Index") {
        Add-Failure "decision-rubric.md must define the PowerLit Internal Readiness Index"
    }
    if ($decisionRubricText -notmatch "Readiness Output") {
        Add-Failure "decision-rubric.md must define readiness output"
    }
    $forbiddenProbabilityPhrase = "acceptance " + "probability"
    if ($decisionRubricText -match [regex]::Escape($forbiddenProbabilityPhrase)) {
        Add-Failure "decision-rubric.md must not contain forbidden publication-probability wording"
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

$readinessWritingReference = Join-Path $repoRoot "skills\powerlit-power-systems-paper-writing\references\internal-readiness-writing.md"
if (Test-Path -LiteralPath $readinessWritingReference) {
    $readinessWritingText = Read-Utf8 -Path $readinessWritingReference
    if ($readinessWritingText -notmatch "Internal Readiness Writing Gate") {
        Add-Failure "internal-readiness-writing.md must define the internal readiness writing gate"
    }
    if ($readinessWritingText -notmatch "Full-Manuscript Readiness Minimum") {
        Add-Failure "internal-readiness-writing.md must define the full-manuscript readiness minimum"
    }
    if ($readinessWritingText -notmatch "Case-analysis evidence alone") {
        Add-Failure "internal-readiness-writing.md must preserve the case-data boundary"
    }
    if ($readinessWritingText -notmatch "Full-Paper Completeness Gate") {
        Add-Failure "internal-readiness-writing.md must define the full-paper completeness gate"
    }
    if ($readinessWritingText -notmatch "BLOCKED") {
        Add-Failure "internal-readiness-writing.md must define the compressed-package blocked status"
    }
} else {
    Add-Failure "Missing internal-readiness-writing.md"
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
    if ($proseQualityText -notmatch "Progression And Non-Repetition Gate") {
        Add-Failure "prose-quality-gates.md must include progression and non-repetition gate"
    }
    if ($proseQualityText -notmatch "Adjective replacement rule") {
        Add-Failure "prose-quality-gates.md must include adjective replacement rule"
    }
    if ($proseQualityText -notmatch "Scope preservation") {
        Add-Failure "prose-quality-gates.md must forbid claim widening when defensive posture is removed"
    }
    if ($proseQualityText -notmatch "Venue-licensed closing summary") {
        Add-Failure "prose-quality-gates.md must scope the venue-licensed validation closing sentence instead of banning it outright"
    }
} else {
    Add-Failure "Missing prose-quality-gates.md"
}

$lexiconReference = Join-Path $repoRoot "skills\powerlit-power-systems-paper-writing\references\lexicon.md"
if (Test-Path -LiteralPath $lexiconReference) {
    $lexiconText = Read-Utf8 -Path $lexiconReference
    if ($lexiconText -notmatch "Corpus-Derived Terminology Consistency") {
        Add-Failure "lexicon.md must include corpus-derived terminology consistency rules"
    }
    if ($lexiconText -notmatch "forbidden aliases") {
        Add-Failure "lexicon.md must require forbidden aliases for terminology drift control"
    }
    if ($lexiconText -notmatch "alias drift") {
        Add-Failure "lexicon.md must require final alias drift scanning"
    }
} else {
    Add-Failure "Missing lexicon.md"
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
    if ($reviewSkillText -notmatch "references/section-quality-review\.md") {
        Add-Failure "paper-review skill must load references/section-quality-review.md"
    }
    if ($reviewSkillText -notmatch "Section quality") {
        Add-Failure "paper-review skill must output title/keyword and section quality review"
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

$sectionQualityReview = Join-Path $repoRoot "skills\powerlit-power-systems-paper-review\references\section-quality-review.md"
if (Test-Path -LiteralPath $sectionQualityReview) {
    $sectionQualityReviewText = Read-Utf8 -Path $sectionQualityReview
    if ($sectionQualityReviewText -notmatch "Section Quality Review") {
        Add-Failure "section-quality-review.md must define section quality review"
    }
    foreach ($requiredReviewSectionToken in @("Title and Keywords", "Abstract", "Introduction", "Case Analysis", "Conclusion", "no more than five", "mainly from the last five years", "sensitivity, ablation, or boundary tests")) {
        if ($sectionQualityReviewText -notmatch [regex]::Escape($requiredReviewSectionToken)) {
            Add-Failure "section-quality-review.md missing token: $requiredReviewSectionToken"
        }
    }
} else {
    Add-Failure "Missing section-quality-review.md"
}

$prewritingSkill = Join-Path $repoRoot "skills\powerlit-power-systems-prewriting-review\SKILL.md"
if (Test-Path -LiteralPath $prewritingSkill) {
    $prewritingSkillText = Read-Utf8 -Path $prewritingSkill
    if ($prewritingSkillText -notmatch "references/insight-discovery\.md") {
        Add-Failure "prewriting-review skill must load references/insight-discovery.md"
    }
    if ($prewritingSkillText -notmatch "references/minimum-research-object\.md") {
        Add-Failure "prewriting-review skill must load references/minimum-research-object.md"
    }
    if ($prewritingSkillText -notmatch "references/prewriting-scorecard\.md") {
        Add-Failure "prewriting-review skill must load references/prewriting-scorecard.md"
    }
    if ($prewritingSkillText -notmatch "scientificity, industry pain-point accuracy, correctness, reasonableness, innovation, and engineering feasibility") {
        Add-Failure "prewriting-review skill must score required readiness dimensions"
    }
    if ($prewritingSkillText -notmatch "maximum defect") {
        Add-Failure "prewriting-review skill must identify the maximum defect"
    }
    if ($prewritingSkillText -notmatch "return to the innovation-chain gate") {
        Add-Failure "prewriting-review skill must route insight discovery back to the innovation-chain gate"
    }
    if ($prewritingSkillText -notmatch "real-innovation repositioning" -or $prewritingSkillText -notmatch "physical storytelling") {
        Add-Failure "prewriting-review skill must require real-innovation repositioning and a physics-first story"
    }
    if ($prewritingSkillText -notmatch "Mathematics should define the model, explain the mechanism, expose the physical intuition, or delimit the claim") {
        Add-Failure "prewriting-review skill must keep mathematics subordinate to the physical story"
    }
    if ($prewritingSkillText -notmatch "multi-act engineering story" -or $prewritingSkillText -notmatch "math role") {
        Add-Failure "prewriting-review skill must require a multi-act engineering story with math role"
    }
    if ($prewritingSkillText -notmatch "minimum research object" -or $prewritingSkillText -notmatch "small peer group") {
        Add-Failure "prewriting-review skill must lock the minimum research object and small peer group"
    }
} else {
    Add-Failure "Missing prewriting-review SKILL.md"
}

$minimumResearchObject = Join-Path $repoRoot "skills\powerlit-power-systems-prewriting-review\references\minimum-research-object.md"
if (Test-Path -LiteralPath $minimumResearchObject) {
    $minimumObjectText = Read-Utf8 -Path $minimumResearchObject
    foreach ($requiredMinimumObjectToken in @("Minimum Research Object Gate", "smallest expert community", "minimum_research_object", "small_peer_group", "Pain-Point Alignment", "analytical AC probabilistic load flow")) {
        if ($minimumObjectText -notmatch [regex]::Escape($requiredMinimumObjectToken)) {
            Add-Failure "minimum-research-object.md missing token: $requiredMinimumObjectToken"
        }
    }
} else {
    Add-Failure "Missing minimum-research-object.md"
}

$prewritingScorecard = Join-Path $repoRoot "skills\powerlit-power-systems-prewriting-review\references\prewriting-scorecard.md"
if (Test-Path -LiteralPath $prewritingScorecard) {
    $prewritingScorecardText = Read-Utf8 -Path $prewritingScorecard
    if ($prewritingScorecardText -notmatch "Prewriting Scorecard") {
        Add-Failure "prewriting-scorecard.md must define the prewriting scorecard"
    }
    foreach ($requiredScorecardToken in @("Scientificity", "Industry pain-point accuracy", "Correctness", "Reasonableness", "Innovation", "Engineering feasibility", "overall 1-10 score", "Maximum Defect", "not publication probabilities")) {
        if ($prewritingScorecardText -notmatch [regex]::Escape($requiredScorecardToken)) {
            Add-Failure "prewriting-scorecard.md missing token: $requiredScorecardToken"
        }
    }
} else {
    Add-Failure "Missing prewriting-scorecard.md"
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
    if ($insightText -notmatch "Physics-First Repositioning") {
        Add-Failure "insight-discovery.md must define physics-first repositioning"
    }
    if ($insightText -notmatch "Multi-Act Engineering Story") {
        Add-Failure "insight-discovery.md must define multi-act engineering story"
    }
    if ($insightText -notmatch "physical mechanism before mathematical structure") {
        Add-Failure "insight-discovery.md must prioritize physical mechanism before mathematical structure"
    }
    if ($insightText -notmatch "real innovation" -or $insightText -notmatch "story logic") {
        Add-Failure "insight-discovery.md must output real-innovation repositioning and physics story"
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
            if (-not $case.id -or -not $case.project -or -not $case.target_venue -or -not $case.target_readiness_state -or -not $case.paper_type -or -not $case.evidence_sources -or -not $case.evidence_packet -or -not $case.readiness_gate -or -not $case.write_prompt -or -not $case.review_prompt) {
                Add-Failure "${actualEvidencePackets}: each actual evidence packet must contain all readiness fields"
            }
            if ($case.PSObject.Properties.Name -contains "target_score_band") {
                Add-Failure "$actualEvidencePackets case $($case.id): target_score_band must be migrated to target_readiness_state"
            }
            if ($case.target_readiness_state -notin @("BLOCKED", "SECTION_READY", "MANUSCRIPT_REVIEW_READY", "SUBMISSION_CANDIDATE")) {
                Add-Failure "$actualEvidencePackets case $($case.id): invalid target_readiness_state"
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
            if (-not $case.readiness_gate.required_dimensions -or -not $case.readiness_gate.blocking_conditions -or -not $case.readiness_gate.must_not_fail) {
                Add-Failure "$actualEvidencePackets case $($case.id): readiness_gate must define required_dimensions, blocking_conditions, and must_not_fail"
            }
            if ($case.readiness_gate.PSObject.Properties.Name -contains "minimum_average" -or $case.readiness_gate.PSObject.Properties.Name -contains "minimum_core_category") {
                Add-Failure "$actualEvidencePackets case $($case.id): minimum score fields must be migrated"
            }
            if ($case.write_prompt -notmatch "readiness") {
                Add-Failure "$actualEvidencePackets case $($case.id): write_prompt must invoke the readiness gate"
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

$ruleSources = Join-Path $repoRoot "references\rule-sources.yaml"
if (Test-Path -LiteralPath $ruleSources -PathType Leaf) {
    $ruleSourcesText = Read-Utf8 -Path $ruleSources
    foreach ($requiredRuleSourceToken in @("source_type: official", "source_type: literature", "source_type: heuristic", "checked_at:", "effective_date:", "ieee_pes_letter_initial_revision_page_limit", "powerlit_internal_readiness_index")) {
        if ($ruleSourcesText -notmatch [regex]::Escape($requiredRuleSourceToken)) {
            Add-Failure "rule-sources.yaml missing token: $requiredRuleSourceToken"
        }
    }
} else {
    Add-Failure "Missing references\rule-sources.yaml"
}

$independentReviewerPrompt = Join-Path $repoRoot "evaluation\behavior\independent-reviewer-prompt.md"
if (Test-Path -LiteralPath $independentReviewerPrompt -PathType Leaf) {
    $independentReviewerText = Read-Utf8 -Path $independentReviewerPrompt
    foreach ($requiredReviewerToken in @("Independent Reviewer Prompt", "Every judgment must cite evidence", "PowerLit Internal Readiness Index", "BLOCKED", "MANUSCRIPT_REVIEW_READY", "not an editor decision")) {
        if ($independentReviewerText -notmatch [regex]::Escape($requiredReviewerToken)) {
            Add-Failure "independent-reviewer-prompt.md missing token: $requiredReviewerToken"
        }
    }
    $forbiddenReviewerTokens = @(
        ("D" + ":\"),
        ("D" + ":/"),
        ("\\" + "One" + "Drive"),
        ("直接录用" + " / 小修 / 大修 / 拒稿")
    )
    foreach ($forbiddenReviewerToken in $forbiddenReviewerTokens) {
        if ($independentReviewerText -match [regex]::Escape($forbiddenReviewerToken)) {
            Add-Failure "independent-reviewer-prompt.md must not contain local path or legacy verdict token: $forbiddenReviewerToken"
        }
    }
} else {
    Add-Failure "Missing evaluation\behavior\independent-reviewer-prompt.md"
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
