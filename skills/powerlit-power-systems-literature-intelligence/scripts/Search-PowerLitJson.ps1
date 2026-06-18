param(
    [Parameter(Mandatory = $true)]
    [string]$Query,

    [string[]]$Terms,
    [string]$PowerLitJsonRoot,
    [string]$PowerLitIndexRoot,
    [string[]]$VenueFolder,
    [int]$Top = 20,
    [int]$CandidateFileLimit = 1000,
    [switch]$DisableIndex,
    [switch]$IncludeAnalysis
)

$ErrorActionPreference = "Stop"

function Get-PythonCommand {
    foreach ($name in @("python", "python3")) {
        $cmd = Get-Command $name -ErrorAction SilentlyContinue
        if ($cmd) {
            return [pscustomobject]@{ command = $cmd.Source; prefix_args = @() }
        }
    }
    $py = Get-Command py -ErrorAction SilentlyContinue
    if ($py) {
        return [pscustomobject]@{ command = $py.Source; prefix_args = @("-3") }
    }
    return $null
}

function Resolve-PowerLitIndexRoot {
    param([string]$Explicit)

    $candidates = New-Object System.Collections.Generic.List[string]
    if ($Explicit) { $candidates.Add($Explicit) }
    if ($env:POWERLIT_INDEX_ROOT) { $candidates.Add($env:POWERLIT_INDEX_ROOT) }

    $codexHome = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $HOME ".codex" }
    $candidates.Add((Join-Path $codexHome "powerlit\powerlit-index"))
    $skillRoot = Split-Path -Parent $PSScriptRoot
    $candidates.Add((Join-Path $skillRoot "assets\powerlit-index"))

    $seen = @{}
    foreach ($candidate in $candidates) {
        if (-not $candidate) { continue }
        $key = $candidate.ToLowerInvariant()
        if ($seen.ContainsKey($key)) { continue }
        $seen[$key] = $true
        if ((Test-Path -LiteralPath $candidate -PathType Container) -and
            ((Test-Path -LiteralPath (Join-Path $candidate "manifest.json")) -or
             (Get-ChildItem -LiteralPath $candidate -Filter "*.sqlite" -File -ErrorAction SilentlyContinue | Select-Object -First 1))) {
            return (Resolve-Path -LiteralPath $candidate).ProviderPath
        }
    }
    return $null
}

function Resolve-PowerLitJsonRoot {
    param([string]$Explicit)

    $candidates = New-Object System.Collections.Generic.List[string]
    if ($Explicit) { $candidates.Add($Explicit) }
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

function Invoke-PythonJson {
    param([string]$Script, [System.Collections.Generic.List[string]]$Arguments)

    $python = Get-PythonCommand
    if (-not $python) {
        throw "Python 3 is required for PowerLit retrieval."
    }
    $allArgs = New-Object System.Collections.Generic.List[string]
    foreach ($arg in @($python.prefix_args)) { $allArgs.Add($arg) }
    $allArgs.Add($Script)
    foreach ($arg in $Arguments) { $allArgs.Add($arg) }
    $output = & $python.command @allArgs
    $exitCode = $LASTEXITCODE
    if ($output) { Write-Output ($output -join [Environment]::NewLine) }
    exit $exitCode
}

$commonArgs = New-Object System.Collections.Generic.List[string]
$commonArgs.Add("--query")
$commonArgs.Add($Query)
$commonArgs.Add("--top")
$commonArgs.Add([string]$Top)
if ($Terms) {
    $commonArgs.Add("--terms")
    foreach ($term in $Terms) { if ($term) { $commonArgs.Add($term) } }
}
foreach ($venue in @($VenueFolder | Where-Object { $_ })) {
    $commonArgs.Add("--venue-folder")
    $commonArgs.Add($venue)
}

if (-not $DisableIndex) {
    $indexRoot = Resolve-PowerLitIndexRoot -Explicit $PowerLitIndexRoot
    if ($indexRoot) {
        $args = New-Object System.Collections.Generic.List[string]
        foreach ($arg in $commonArgs) { $args.Add($arg) }
        $args.Add("--index-dir")
        $args.Add($indexRoot)
        Invoke-PythonJson -Script (Join-Path $PSScriptRoot "Search-PowerLitIndex.py") -Arguments $args
    }
}

$rawRoot = Resolve-PowerLitJsonRoot -Explicit $PowerLitJsonRoot
if (-not $rawRoot) {
    [pscustomobject]@{
        available = $false
        message = "PowerLit index and raw corpus are unavailable"
        results = @()
        novelty_gate = [pscustomobject]@{
            status = "UNKNOWN"
            reasons = @("no portable index and no explicit raw corpus root")
        }
    } | ConvertTo-Json -Depth 8
    exit 2
}

$rawArgs = New-Object System.Collections.Generic.List[string]
foreach ($arg in $commonArgs) { $rawArgs.Add($arg) }
$rawArgs.Add("--root")
$rawArgs.Add($rawRoot)
$rawArgs.Add("--candidate-file-limit")
$rawArgs.Add([string]$CandidateFileLimit)
if ($IncludeAnalysis) { $rawArgs.Add("--include-analysis") }
Invoke-PythonJson -Script (Join-Path $PSScriptRoot "Search-PowerLitRaw.py") -Arguments $rawArgs
