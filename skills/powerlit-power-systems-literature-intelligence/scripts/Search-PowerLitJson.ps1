param(
    [Parameter(Mandatory = $true)]
    [string]$Query,

    [string[]]$Terms,

    [string]$PowerLitJsonRoot,

    [string[]]$VenueFolder,

    [int]$Top = 20,

    [int]$CandidateFileLimit = 300,

    [switch]$IncludeAnalysis
)

function Resolve-PowerLitJsonRoot {
    param([string]$Root)

    $candidates = New-Object System.Collections.Generic.List[string]
    if ($Root) { $candidates.Add($Root) }
    if ($env:POWERLIT_JSON_ROOT) { $candidates.Add($env:POWERLIT_JSON_ROOT) }
    if ($env:POWERLIT_LOCAL_CACHE) { $candidates.Add($env:POWERLIT_LOCAL_CACHE) }
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
        $parts = $QueryText -split "[^\p{L}\p{Nd}_\-\+]+"
        foreach ($part in $parts) {
            $t = $part.Trim()
            if ($t.Length -ge 3) {
                $result.Add($t)
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

function Get-Snippet {
    param([string]$Text, [string[]]$Terms)
    if (-not $Text) { return "" }
    foreach ($term in $Terms) {
        $pos = $Text.IndexOf($term, [System.StringComparison]::OrdinalIgnoreCase)
        if ($pos -ge 0) {
            $start = [Math]::Max(0, $pos - 140)
            $length = [Math]::Min(420, $Text.Length - $start)
            return (($Text.Substring($start, $length)) -replace "\s+", " ").Trim()
        }
    }
    return (($Text.Substring(0, [Math]::Min(300, $Text.Length))) -replace "\s+", " ").Trim()
}

function Test-WeakTitle {
    param([string]$Title, [string]$SourceTitle)

    if (-not $Title -or $Title.Trim().Length -lt 8) { return $true }
    $normalizedTitle = ($Title -replace "\s+", " ").Trim().ToLowerInvariant()
    $normalizedSource = ($SourceTitle -replace "\s+", " ").Trim().ToLowerInvariant()
    if ($normalizedSource -and $normalizedTitle -eq $normalizedSource) { return $true }
    if ($normalizedTitle -match "^(ieee transactions|proceedings|journal|transactions on|power systems|smart grid)") { return $true }
    return $false
}

function Get-TitleFromContentHead {
    param([string]$Content)

    if (-not $Content) { return $null }
    $head = if ($Content.Length -gt 12000) { $Content.Substring(0, 12000) } else { $Content }
    $lines = $head -split "\r?\n"
    foreach ($line in ($lines | Select-Object -First 80)) {
        $candidate = ($line -replace "^\s*#+\s*", "" -replace "^\s*[-*]\s*", "").Trim()
        $candidate = ($candidate -replace "\s+", " ").Trim()
        if ($candidate.Length -lt 8 -or $candidate.Length -gt 220) { continue }
        if ($candidate -match "^(abstract|index terms|keywords|introduction|references|doi\b|copyright\b)" ) { continue }
        if ($candidate -match "^(ieee transactions|ieee trans\.|vol\.|volume\b|no\.|arxiv\b)" ) { continue }
        if ($candidate -match "^[0-9\s,.;:()/-]+$") { continue }
        if ($candidate -notmatch "\p{L}") { continue }
        return $candidate
    }
    return $null
}

function Get-CandidateJsonFiles {
    param(
        [string[]]$Roots,
        [string[]]$SearchTerms,
        [int]$Limit,
        [switch]$IncludeAnalysis
    )

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
            $remaining = [Math]::Max(0, $Limit - $files.Count)
            if ($remaining -le 0) {
                break
            }
            $rgOutput = & rg @rgArgs $pattern $searchRoot 2>$null | Select-Object -First $remaining
            foreach ($path in $rgOutput) {
                if ($path -and -not $files.Contains($path)) {
                    $files.Add($path)
                    if ($files.Count -ge $Limit) {
                        return [pscustomobject]@{
                            files = @($files)
                            source = "rg"
                        }
                    }
                }
            }
        }
        return [pscustomobject]@{
            files = @($files)
            source = "rg"
        }
    }

    foreach ($searchRoot in $Roots) {
        Get-ChildItem -LiteralPath $searchRoot -Recurse -File -Filter "*.json" -ErrorAction SilentlyContinue | ForEach-Object {
            if (-not $IncludeAnalysis -and $_.Name -like "*-analysis.json") {
                return
            }
            $files.Add($_.FullName)
            if ($files.Count -ge $Limit) {
                return
            }
        }
        if ($files.Count -ge $Limit) {
            break
        }
    }
    return [pscustomobject]@{
        files = @($files)
        source = "filesystem"
    }
}

$timer = [System.Diagnostics.Stopwatch]::StartNew()
$root = Resolve-PowerLitJsonRoot -Root $PowerLitJsonRoot
if (-not $root) {
    [pscustomobject]@{
        available = $false
        message = "PowerLit unavailable; using fallback non-corpus workflow"
        results = @()
        elapsed_ms = $timer.ElapsedMilliseconds
    } | ConvertTo-Json -Depth 6
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

$candidateInfo = Get-CandidateJsonFiles -Roots @($searchRoots) -SearchTerms $termsToUse -Limit $CandidateFileLimit -IncludeAnalysis:$IncludeAnalysis
$candidateFiles = @($candidateInfo.files)
$parsedCount = 0
$results = New-Object System.Collections.Generic.List[object]

foreach ($filePath in $candidateFiles) {
    if (-not $filePath) { continue }
    try {
        $record = Get-Content -LiteralPath $filePath -Raw -ErrorAction Stop | ConvertFrom-Json -ErrorAction Stop
        $parsedCount += 1
    } catch {
        continue
    }

    $title = [string]$record.title
    $source = [string]$record.source_title
    $doi = [string]$record.doi
    $content = [string]$record.content
    $contentHead = if ($content.Length -gt 200000) { $content.Substring(0, 200000) } else { $content }
    $titleSource = "record"
    if (Test-WeakTitle -Title $title -SourceTitle $source) {
        $contentTitle = Get-TitleFromContentHead -Content $contentHead
        if ($contentTitle) {
            $title = $contentTitle
            $titleSource = "content_head"
        }
    }

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
        $relative = $filePath.Substring($root.Length).TrimStart("\", "/")
        $results.Add([pscustomobject]@{
            score = $score
            title = $title
            title_source = $titleSource
            source_title = $source
            doi = $doi
            path = $filePath
            relative_path = $relative
            matched_terms = @($matched | Select-Object -Unique)
            snippet = Get-Snippet -Text $contentHead -Terms $termsToUse
        })
    }
}

$timer.Stop()
[pscustomobject]@{
    available = $true
    root = $root
    query = $Query
    terms = $termsToUse
    candidate_source = $candidateInfo.source
    candidate_count = $candidateFiles.Count
    candidate_file_limit = $CandidateFileLimit
    parsed_count = $parsedCount
    elapsed_ms = $timer.ElapsedMilliseconds
    count = $results.Count
    results = @($results | Sort-Object -Property score -Descending | Select-Object -First $Top)
} | ConvertTo-Json -Depth 8
