param(
    [string]$PowerLitJsonRoot
)

$candidates = New-Object System.Collections.Generic.List[string]

if ($PowerLitJsonRoot) {
    $candidates.Add($PowerLitJsonRoot)
}
if ($env:POWERLIT_JSON_ROOT) {
    $candidates.Add($env:POWERLIT_JSON_ROOT)
}
if ($env:POWERLIT_LOCAL_SUBSET) {
    $candidates.Add($env:POWERLIT_LOCAL_SUBSET)
}
if ($env:POWERLIT_LOCAL_CACHE) {
    $candidates.Add($env:POWERLIT_LOCAL_CACHE)
}
if ($env:POWERLIT_LITERATURE_JSON) {
    $candidates.Add($env:POWERLIT_LITERATURE_JSON)
}
$candidates.Add("\\WHome\PowerLit\literature\json")

$seen = @{}
foreach ($candidate in $candidates) {
    if (-not $candidate) {
        continue
    }
    $key = $candidate.ToLowerInvariant()
    if ($seen.ContainsKey($key)) {
        continue
    }
    $seen[$key] = $true
    if (Test-Path -LiteralPath $candidate -PathType Container) {
        [pscustomobject]@{
            available = $true
            path = (Resolve-Path -LiteralPath $candidate).ProviderPath
            source = if ($candidate -eq $PowerLitJsonRoot) { "parameter" } elseif ($candidate -eq $env:POWERLIT_JSON_ROOT) { "POWERLIT_JSON_ROOT" } elseif ($candidate -eq $env:POWERLIT_LOCAL_SUBSET) { "POWERLIT_LOCAL_SUBSET" } elseif ($candidate -eq $env:POWERLIT_LOCAL_CACHE) { "POWERLIT_LOCAL_CACHE" } elseif ($candidate -eq $env:POWERLIT_LITERATURE_JSON) { "POWERLIT_LITERATURE_JSON" } else { "default" }
        } | ConvertTo-Json -Depth 4
        exit 0
    }
}

[pscustomobject]@{
    available = $false
    path = $null
    source = $null
    tried = @($seen.Keys)
} | ConvertTo-Json -Depth 4

exit 2
