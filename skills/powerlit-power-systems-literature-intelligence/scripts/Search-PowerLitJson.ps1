param(
    [Parameter(Mandatory = $true)]
    [string]$Query,

    [string[]]$Terms,

    [string]$PowerLitJsonRoot,

    [string[]]$VenueFolder,

    [int]$Top = 20,

    [switch]$IncludeAnalysis
)

function Resolve-PowerLitJsonRoot {
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

$root = Resolve-PowerLitJsonRoot -Root $PowerLitJsonRoot
if (-not $root) {
    [pscustomobject]@{
        available = $false
        message = "PowerLit unavailable; using fallback non-corpus workflow"
        results = @()
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

$results = New-Object System.Collections.Generic.List[object]
foreach ($searchRoot in $searchRoots) {
    Get-ChildItem -LiteralPath $searchRoot -Recurse -File -Filter "*.json" -ErrorAction SilentlyContinue | ForEach-Object {
        if (-not $IncludeAnalysis -and $_.Name -like "*-analysis.json") {
            return
        }
        try {
            $record = Get-Content -LiteralPath $_.FullName -Raw -ErrorAction Stop | ConvertFrom-Json -ErrorAction Stop
        } catch {
            return
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
            $relative = $_.FullName.Substring($root.Length).TrimStart("\", "/")
            $results.Add([pscustomobject]@{
                score = $score
                title = $title
                source_title = $source
                doi = $doi
                path = $_.FullName
                relative_path = $relative
                matched_terms = @($matched | Select-Object -Unique)
                snippet = Get-Snippet -Text $contentHead -Terms $termsToUse
            })
        }
    }
}

[pscustomobject]@{
    available = $true
    root = $root
    query = $Query
    terms = $termsToUse
    count = $results.Count
    results = @($results | Sort-Object -Property score -Descending | Select-Object -First $Top)
} | ConvertTo-Json -Depth 8
