# build.ps1 — Assembles the public site by embedding sources.json into the HTML pages.
# Run after each biweekly source-approval cycle:  pwsh ./scripts/build.ps1
# Single source of truth: ../sources/sources.json  ->  embedded into ../output/*.html

$ErrorActionPreference = "Stop"
$root      = Split-Path $PSScriptRoot -Parent
$dataPath  = Join-Path $root "sources\sources.json"
$outputDir = Join-Path $root "output"

if (-not (Test-Path $dataPath)) { throw "sources.json not found at $dataPath" }

# Read + validate JSON (also pretty-checks it parses)
$raw     = Get-Content $dataPath -Raw -Encoding UTF8
$sources = $raw | ConvertFrom-Json
$count   = @($sources).Count
# Compact the JSON onto one line for embedding
$compact = ($sources | ConvertTo-Json -Depth 10 -Compress)

# Pages that carry the embedded dataset (between the /*__SOURCES_DATA__*/ ... /*__END__*/ markers)
$pages = @("index.html")
foreach ($page in $pages) {
    $p = Join-Path $outputDir $page
    if (-not (Test-Path $p)) { Write-Host "  skip (missing): $page"; continue }
    $html = Get-Content $p -Raw -Encoding UTF8
    $pattern = '/\*__SOURCES_DATA__\*/.*?/\*__END__\*/'
    $replacement = "/*__SOURCES_DATA__*/$compact/*__END__*/"
    $html = [System.Text.RegularExpressions.Regex]::Replace($html, $pattern, { param($m) $replacement }, [System.Text.RegularExpressions.RegexOptions]::Singleline)
    Set-Content -Path $p -Value $html -Encoding UTF8 -NoNewline
    Write-Host "  embedded $count sources -> $page"
}

Write-Host "Build complete: $count sources embedded. Open output/index.html to view."
