param(
    [Parameter(Mandatory = $true)]
    [string]$Query,

    [string[]]$Terms,

    [string]$PowerLitJsonRoot,

    [string[]]$VenueFolder,

    [int]$Top = 5,

    [int]$CandidateFileLimit = 600,

    [int]$ContentLimit = 350000
)

function Resolve-PowerLitJsonRoot {
    param([string]$Root)

    $candidates = New-Object System.Collections.Generic.List[string]
    if ($Root) { $candidates.Add($Root) }
    if ($env:POWERLIT_JSON_ROOT) { $candidates.Add($env:POWERLIT_JSON_ROOT) }
    if ($env:POWERLIT_LITERATURE_JSON) { $candidates.Add($env:POWERLIT_LITERATURE_JSON) }

    $seen = @{}
    foreach ($candidate in $candidates) {
        if (-not $candidate) { continue }
        $key = $candidate.ToLowerInvariant()
        if ($seen.ContainsKey($key)) { continue }
        $seen[$key] = $true
        if (Test-Path -LiteralPath $candidate -PathType Container) {
            return (Resolve-Path -LiteralPath $candidate).ProviderPath
        }
    }
    return $null
}

function Normalize-Terms {
    param([string]$QueryText, [string[]]$ProvidedTerms)

    $result = New-Object System.Collections.Generic.List[string]
    if ($ProvidedTerms) {
        foreach ($term in $ProvidedTerms) {
            if ($term -and $term.Trim().Length -gt 0) {
                $result.Add($term.Trim())
            }
        }
    }
    if ($result.Count -eq 0) {
        foreach ($part in ($QueryText -split "[^\p{L}\p{Nd}_\-\+]+")) {
            $term = $part.Trim()
            if ($term.Length -ge 3) {
                $result.Add($term)
            }
        }
    }
    return @($result | Select-Object -Unique)
}

function Count-Contains {
    param([string]$Text, [string]$Term)
    if (-not $Text -or -not $Term) { return 0 }
    $index = 0
    $count = 0
    while ($true) {
        $found = $Text.IndexOf($Term, $index, [System.StringComparison]::OrdinalIgnoreCase)
        if ($found -lt 0) { break }
        $count += 1
        $index = $found + [Math]::Max($Term.Length, 1)
        if ($count -ge 20) { break }
    }
    return $count
}

function Count-Regex {
    param([string]$Text, [string]$Pattern)
    if (-not $Text) { return 0 }
    try {
        return ([regex]::Matches($Text, $Pattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)).Count
    } catch {
        return 0
    }
}

function Select-Matches {
    param([string]$Text, [string]$Pattern, [int]$Limit = 8)
    if (-not $Text) { return @() }
    try {
        $matches = [regex]::Matches($Text, $Pattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    } catch {
        return @()
    }
    return @($matches | Select-Object -First $Limit | ForEach-Object {
        ($_.Value -replace "\s+", " ").Trim()
    } | Select-Object -Unique)
}

function Measure-EvidenceSignals {
    param([string]$Text)

    $patterns = [ordered]@{
        headings = "(?m)^#{1,4}\s+"
        tables = "(?m)^\s*(Table|TABLE)\s*\S{0,12}"
        figures = "(?m)^\s*(Fig\.|Figure|FIGURE)\s*\S{0,12}"
        systems = "(IEEE\s*\d+\s*[- ]?\s*(bus|node)|case\d+|RTS|PEGASE|CIGRE|MATPOWER|feeder|distribution system|配电网|节点系统|母线系统)"
        baselines = "(compared with|comparison|benchmark|baseline|state-of-the-art|existing method|对比|相比|基准|传统方法|已有方法)"
        metrics = "(RMSE|MAE|MAPE|MSE|KS|Wasserstein|cost|runtime|CPU time|voltage deviation|voltage violation|probability|error|误差|成本|电压偏差|越限|运行时间|概率|精度)"
        sensitivity = "(sensitivity|ablation|parameter|robustness|scalability|different cases|varying|消融|敏感性|参数|鲁棒|规模|不同场景|不同参数)"
        reproducibility = "(solver|tolerance|hardware|CPU|GPU|MATLAB|Python|CVX|CPLEX|Gurobi|seed|iteration|求解器|容差|硬件|随机种子|迭代)"
        boundary = "(limitation|future work|however|while|although|nevertheless|局限|边界|未来工作|然而|同时|尽管)"
    }

    $counts = [ordered]@{}
    $examples = [ordered]@{}
    foreach ($name in $patterns.Keys) {
        $counts[$name] = Count-Regex -Text $Text -Pattern $patterns[$name]
        if ($name -in @("systems", "baselines", "metrics", "sensitivity", "reproducibility", "boundary")) {
            $examples[$name] = Select-Matches -Text $Text -Pattern $patterns[$name] -Limit 8
        }
    }

    return [pscustomobject]@{
        counts = [pscustomobject]$counts
        examples = [pscustomobject]$examples
    }
}

function Get-CandidateJsonFiles {
    param([string[]]$Roots, [string[]]$SearchTerms, [int]$Limit)

    $files = New-Object System.Collections.Generic.List[string]
    $rg = Get-Command rg -ErrorAction SilentlyContinue
    if ($rg) {
        $escapedTerms = @($SearchTerms | Where-Object { $_ } | ForEach-Object { [regex]::Escape($_) })
        $pattern = if ($escapedTerms.Count -gt 0) { ($escapedTerms -join "|") } else { "." }
        foreach ($searchRoot in $Roots) {
            $rgOutput = & rg -l -i --glob "*.json" --glob "!*-analysis.json" $pattern $searchRoot 2>$null
            foreach ($path in $rgOutput) {
                if ($path -and -not $files.Contains($path)) {
                    $files.Add($path)
                    if ($files.Count -ge $Limit) {
                        return @($files)
                    }
                }
            }
        }
        return @($files)
    }

    foreach ($searchRoot in $Roots) {
        Get-ChildItem -LiteralPath $searchRoot -Recurse -File -Filter "*.json" -ErrorAction SilentlyContinue | ForEach-Object {
            if ($_.Name -like "*-analysis.json") {
                return
            }
            $files.Add($_.FullName)
            if ($files.Count -ge $Limit) {
                return @($files)
            }
        }
    }
    return @($files)
}

$root = Resolve-PowerLitJsonRoot -Root $PowerLitJsonRoot
if (-not $root) {
    [pscustomobject]@{
        available = $false
        message = "PowerLit unavailable; using fallback non-corpus workflow"
        papers = @()
    } | ConvertTo-Json -Depth 8
    exit 2
}

$termsToUse = Normalize-Terms -QueryText $Query -ProvidedTerms $Terms
if ($termsToUse.Count -eq 0) {
    $termsToUse = @($Query)
}

$searchRoots = New-Object System.Collections.Generic.List[string]
if ($VenueFolder) {
    foreach ($venue in $VenueFolder) {
        $candidate = Join-Path $root $venue
        if (Test-Path -LiteralPath $candidate -PathType Container) {
            $searchRoots.Add($candidate)
        }
    }
}
if ($searchRoots.Count -eq 0) {
    $searchRoots.Add($root)
}

$candidates = New-Object System.Collections.Generic.List[object]
$candidateFiles = Get-CandidateJsonFiles -Roots @($searchRoots) -SearchTerms $termsToUse -Limit $CandidateFileLimit
foreach ($filePath in $candidateFiles) {
        try {
            $item = Get-Item -LiteralPath $filePath -ErrorAction Stop
            $record = Get-Content -LiteralPath $item.FullName -Raw -ErrorAction Stop | ConvertFrom-Json -ErrorAction Stop
        } catch {
            continue
        }

        $title = [string]$record.title
        $source = [string]$record.source_title
        $doi = [string]$record.doi
        $content = [string]$record.content
        $head = if ($content.Length -gt $ContentLimit) { $content.Substring(0, $ContentLimit) } else { $content }

        $score = 0
        $matched = New-Object System.Collections.Generic.List[string]
        foreach ($term in $termsToUse) {
            $titleHits = Count-Contains -Text $title -Term $term
            $sourceHits = Count-Contains -Text $source -Term $term
            $bodyHits = Count-Contains -Text $head -Term $term
            if (($titleHits + $sourceHits + $bodyHits) -gt 0) {
                $matched.Add($term)
            }
            $score += 10 * $titleHits + 3 * $sourceHits + $bodyHits
        }

        if ($score -gt 0) {
            $relative = $item.FullName.Substring($root.Length).TrimStart("\", "/")
            $signals = Measure-EvidenceSignals -Text $head
            $candidates.Add([pscustomobject]@{
                score = $score
                title = $title
                source_title = $source
                doi = $doi
                path = $item.FullName
                relative_path = $relative
                matched_terms = @($matched | Select-Object -Unique)
                evidence_signals = $signals
            })
        }
}

$papers = @($candidates | Sort-Object -Property score -Descending | Select-Object -First $Top)
$coverage = [ordered]@{
    systems = 0
    baselines = 0
    metrics = 0
    sensitivity = 0
    reproducibility = 0
    boundary = 0
}
foreach ($paper in $papers) {
    foreach ($key in @($coverage.Keys)) {
        if ([int]$paper.evidence_signals.counts.$key -gt 0) {
            $coverage[$key] += 1
        }
    }
}

[pscustomobject]@{
    available = $true
    root = $root
    query = $Query
    venue_folders = $VenueFolder
    terms = $termsToUse
    candidate_file_limit = $CandidateFileLimit
    candidate_file_count = $candidateFiles.Count
    candidate_count = $candidates.Count
    sampled_paper_count = $papers.Count
    coverage_in_sample = [pscustomobject]$coverage
    use_guidance = "Use these signals to build an evidence-strength profile; inspect the selected papers before making manuscript-specific claims."
    papers = $papers
} | ConvertTo-Json -Depth 12
