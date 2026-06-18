param(
    [string]$PowerLitJsonRoot,
    [string]$PowerLitIndexRoot
)

$indexCandidates = New-Object System.Collections.Generic.List[string]
if ($PowerLitIndexRoot) { $indexCandidates.Add($PowerLitIndexRoot) }
if ($env:POWERLIT_INDEX_ROOT) { $indexCandidates.Add($env:POWERLIT_INDEX_ROOT) }
$codexHome = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $HOME ".codex" }
$indexCandidates.Add((Join-Path $codexHome "powerlit\powerlit-index"))
$skillRoot = Split-Path -Parent $PSScriptRoot
$indexCandidates.Add((Join-Path $skillRoot "assets\powerlit-index"))

$seen = @{}
foreach ($candidate in $indexCandidates) {
    if (-not $candidate) { continue }
    $key = $candidate.ToLowerInvariant()
    if ($seen.ContainsKey("index:$key")) { continue }
    $seen["index:$key"] = $true
    if ((Test-Path -LiteralPath $candidate -PathType Container) -and
        ((Test-Path -LiteralPath (Join-Path $candidate "manifest.json")) -or
         (Get-ChildItem -LiteralPath $candidate -Filter "*.sqlite" -File -ErrorAction SilentlyContinue | Select-Object -First 1))) {
        [pscustomobject]@{
            available = $true
            mode = "index"
            path = (Resolve-Path -LiteralPath $candidate).ProviderPath
            source = if ($candidate -eq $PowerLitIndexRoot) { "parameter" } elseif ($candidate -eq $env:POWERLIT_INDEX_ROOT) { "POWERLIT_INDEX_ROOT" } elseif ($candidate -like "*powerlit\powerlit-index") { "CODEX_HOME" } else { "bundled_skill_asset" }
        } | ConvertTo-Json -Depth 4
        exit 0
    }
}

$rawCandidates = New-Object System.Collections.Generic.List[string]
if ($PowerLitJsonRoot) { $rawCandidates.Add($PowerLitJsonRoot) }
if ($env:POWERLIT_JSON_ROOT) { $rawCandidates.Add($env:POWERLIT_JSON_ROOT) }
if ($env:POWERLIT_LITERATURE_JSON) { $rawCandidates.Add($env:POWERLIT_LITERATURE_JSON) }

foreach ($candidate in $rawCandidates) {
    if (-not $candidate) { continue }
    $key = $candidate.ToLowerInvariant()
    if ($seen.ContainsKey("raw:$key")) { continue }
    $seen["raw:$key"] = $true
    if (Test-Path -LiteralPath $candidate -PathType Container) {
        [pscustomobject]@{
            available = $true
            mode = "raw_corpus"
            path = (Resolve-Path -LiteralPath $candidate).ProviderPath
            source = if ($candidate -eq $PowerLitJsonRoot) { "parameter" } elseif ($candidate -eq $env:POWERLIT_JSON_ROOT) { "POWERLIT_JSON_ROOT" } else { "POWERLIT_LITERATURE_JSON" }
        } | ConvertTo-Json -Depth 4
        exit 0
    }
}

[pscustomobject]@{
    available = $false
    mode = $null
    path = $null
    source = $null
    tried = @($seen.Keys)
} | ConvertTo-Json -Depth 4
exit 2
