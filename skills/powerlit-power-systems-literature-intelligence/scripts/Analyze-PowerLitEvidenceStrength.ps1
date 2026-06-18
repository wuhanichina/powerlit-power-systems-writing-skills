param(
    [Parameter(Mandatory = $true)]
    [string]$Query,
    [string[]]$Terms,
    [string]$PowerLitIndexRoot,
    [string[]]$VenueFolder,
    [int]$Top = 5
)

$python = Get-Command python -ErrorAction SilentlyContinue
$prefix = @()
if (-not $python) {
    $python = Get-Command python3 -ErrorAction SilentlyContinue
}
if (-not $python) {
    $python = Get-Command py -ErrorAction SilentlyContinue
    if ($python) { $prefix = @("-3") }
}
if (-not $python) { throw "Python 3 is required." }

$args = New-Object System.Collections.Generic.List[string]
foreach ($item in $prefix) { $args.Add($item) }
$args.Add((Join-Path $PSScriptRoot "Analyze-PowerLitEvidenceStrength.py"))
$args.Add("--query")
$args.Add($Query)
$args.Add("--top")
$args.Add([string]$Top)
if ($PowerLitIndexRoot) {
    $args.Add("--index-dir")
    $args.Add($PowerLitIndexRoot)
}
if ($Terms) {
    $args.Add("--terms")
    foreach ($term in $Terms) { if ($term) { $args.Add($term) } }
}
foreach ($venue in @($VenueFolder | Where-Object { $_ })) {
    $args.Add("--venue-folder")
    $args.Add($venue)
}

& $python.Source @args
exit $LASTEXITCODE
