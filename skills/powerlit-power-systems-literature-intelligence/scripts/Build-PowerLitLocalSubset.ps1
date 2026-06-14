param(
    [Parameter(Mandatory = $true)]
    [string]$Query,

    [string[]]$Terms,

    [string]$SourcePowerLitJsonRoot,

    [string[]]$VenueFolder,

    [int]$Top = 100,

    [int]$CandidateFileLimit = 1200,

    [string]$Destination,

    [switch]$IncludeAnalysis
)

function Resolve-SourcePowerLitJsonRoot {
    param([string]$Root)

    $candidates = New-Object System.Collections.Generic.List[string]
    if ($Root) { $candidates.Add($Root) }
    if ($env:POWERLIT_JSON_ROOT) { $candidates.Add($env:POWERLIT_JSON_ROOT) }
    if ($env:POWERLIT_LITERATURE_JSON) { $candidates.Add($env:POWERLIT_LITERATURE_JSON) }
    $candidates.Add("\\WHome\PowerLit\literature\json")

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

function Get-RepoRoot {
    $skillDir = Split-Path -Parent $PSScriptRoot
    $skillsDir = Split-Path -Parent $skillDir
    return (Split-Path -Parent $skillsDir)
}

function New-Slug {
    param([string]$Text)
    $slug = ([regex]::Replace($Text.ToLowerInvariant(), "[^a-z0-9]+", "-")).Trim("-")
    if (-not $slug) { $slug = "powerlit-subset" }
    if ($slug.Length -gt 60) { $slug = $slug.Substring(0, 60).Trim("-") }
    return $slug
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

function Get-CandidateJsonFiles {
    param([string[]]$Roots, [string[]]$SearchTerms, [int]$Limit, [switch]$IncludeAnalysis)

    $files = New-Object System.Collections.Generic.List[string]
    $rg = Get-Command rg -ErrorAction SilentlyContinue
    if ($rg) {
        $escapedTerms = @($SearchTerms | Where-Object { $_ } | ForEach-Object { [regex]::Escape($_) })
        $pattern = if ($escapedTerms.Count -gt 0) { ($escapedTerms -join "|") } else { "." }
        foreach ($searchRoot in $Roots) {
            $rgArgs = @("-l", "-i", "--glob", "*.json")
            if (-not $IncludeAnalysis) {
                $rgArgs += @("--glob", "!*-analysis.json")
            }
            $rgOutput = & rg @rgArgs $pattern $searchRoot 2>$null
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
            if (-not $IncludeAnalysis -and $_.Name -like "*-analysis.json") {
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

$sourceRoot = Resolve-SourcePowerLitJsonRoot -Root $SourcePowerLitJsonRoot
if (-not $sourceRoot) {
    [pscustomobject]@{
        available = $false
        message = "PowerLit source unavailable; no local subset was built"
        copied_count = 0
    } | ConvertTo-Json -Depth 6
    exit 2
}

$termsToUse = Normalize-Terms -QueryText $Query -ProvidedTerms $Terms
if ($termsToUse.Count -eq 0) {
    $termsToUse = @($Query)
}

if (-not $Destination) {
    $repoRoot = Get-RepoRoot
    $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $Destination = Join-Path $repoRoot (Join-Path ".cache\powerlit-subsets" ("$(New-Slug -Text $Query)-$stamp"))
}
$destinationRoot = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Destination)
New-Item -ItemType Directory -Force -Path $destinationRoot | Out-Null

$searchRoots = New-Object System.Collections.Generic.List[string]
if ($VenueFolder) {
    foreach ($venue in $VenueFolder) {
        $candidate = Join-Path $sourceRoot $venue
        if (Test-Path -LiteralPath $candidate -PathType Container) {
            $searchRoots.Add($candidate)
        }
    }
}
if ($searchRoots.Count -eq 0) {
    $searchRoots.Add($sourceRoot)
}

$candidateFiles = Get-CandidateJsonFiles -Roots @($searchRoots) -SearchTerms $termsToUse -Limit $CandidateFileLimit -IncludeAnalysis:$IncludeAnalysis
$ranked = New-Object System.Collections.Generic.List[object]
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
    $contentHead = if ($content.Length -gt 200000) { $content.Substring(0, 200000) } else { $content }

    $score = 0
    $matched = New-Object System.Collections.Generic.List[string]
    foreach ($term in $termsToUse) {
        $titleHits = Count-Contains -Text $title -Term $term
        $sourceHits = Count-Contains -Text $source -Term $term
        $bodyHits = Count-Contains -Text $contentHead -Term $term
        if (($titleHits + $sourceHits + $bodyHits) -gt 0) {
            $matched.Add($term)
        }
        $score += 10 * $titleHits + 3 * $sourceHits + $bodyHits
    }

    if ($score -gt 0) {
        $relative = $item.FullName.Substring($sourceRoot.Length).TrimStart("\", "/")
        $ranked.Add([pscustomobject]@{
            score = $score
            title = $title
            source_title = $source
            doi = $doi
            source_path = $item.FullName
            relative_path = $relative
            matched_terms = @($matched | Select-Object -Unique)
        })
    }
}

$selected = @($ranked | Sort-Object -Property score -Descending | Select-Object -First $Top)
foreach ($paper in $selected) {
    $target = Join-Path $destinationRoot $paper.relative_path
    $targetDir = Split-Path -Parent $target
    New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
    Copy-Item -LiteralPath $paper.source_path -Destination $target -Force
}

$manifest = [pscustomobject]@{
    available = $true
    source_root = $sourceRoot
    destination = $destinationRoot
    query = $Query
    terms = $termsToUse
    venue_folders = $VenueFolder
    candidate_file_limit = $CandidateFileLimit
    candidate_file_count = $candidateFiles.Count
    matched_count = $ranked.Count
    copied_count = $selected.Count
    created_at = (Get-Date).ToString("o")
    set_env_hint = "`$env:POWERLIT_LOCAL_SUBSET='$destinationRoot'"
    papers = $selected
}

$manifestPath = Join-Path $destinationRoot "powerlit_subset_manifest.json"
$manifest | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $manifestPath -Encoding UTF8
$manifest | ConvertTo-Json -Depth 10
