param(
    [ValidateSet("all", "report", "cover", "letter", "beamer", "poster", "clean")]
    [string]$Target = "all"
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$BuildDir = Join-Path $ScriptDir ".build"

$LatexmkOptions = @(
    "-xelatex",
    "-g",
    "-silent",
    "-interaction=nonstopmode",
    "-halt-on-error",
    "-synctex=1"
)

function Write-Info($Message) { Write-Host "[INFO]  $Message" -ForegroundColor Blue }
function Write-Ok($Message) { Write-Host "[OK]    $Message" -ForegroundColor Green }
function Write-Warn($Message) { Write-Warning $Message }

function Test-Prerequisites {
    $latexmk = Get-Command latexmk -ErrorAction SilentlyContinue
    if (-not $latexmk) {
        throw "latexmk not found. Please install TeX Live, MacTeX, or MiKTeX first."
    }
    Write-Info "Using latexmk: $($latexmk.Source)"
}

function Build-Template([string]$Name) {
    $dir = Join-Path $ScriptDir $Name
    $mainTex = Join-Path $dir "main.tex"
    if (-not (Test-Path $mainTex)) {
        Write-Warn "Skipping '$Name': $mainTex not found."
        return
    }

    $templateBuildDir = Join-Path $BuildDir $Name
    New-Item -ItemType Directory -Force $templateBuildDir | Out-Null

    Write-Info "Building $Name ..."
    Push-Location $dir
    try {
        $outDirArg = "-outdir=$($templateBuildDir -replace '\\', '/')"
        & latexmk @LatexmkOptions $outDirArg "main.tex"
    }
    finally {
        Pop-Location
    }

    $pdf = Join-Path $templateBuildDir "main.pdf"
    $destination = Join-Path $dir "$Name.pdf"
    if (Test-Path $pdf) {
        Copy-Item $pdf $destination -Force
        Write-Ok "Created: $destination"
    }
    else {
        throw "Failed to find $pdf"
    }
}

function Clean {
    Write-Info "Cleaning auxiliary files ..."

    Remove-Item $BuildDir -Recurse -Force -ErrorAction SilentlyContinue

    foreach ($dir in @("report", "letter", "beamer", "poster")) {
        Remove-Item (Join-Path $ScriptDir "$dir\$dir.pdf") -Force -ErrorAction SilentlyContinue
    }

    $patterns = @(
        "*.aux", "*.log", "*.out", "*.toc", "*.nav", "*.snm", "*.bbl", "*.bcf",
        "*.blg", "*.run.xml", "*.fls", "*.fdb_latexmk", "*.synctex.gz", "*.vrb"
    )

    Get-ChildItem $ScriptDir -Recurse -File -Depth 3 -Include $patterns |
        Remove-Item -Force -ErrorAction SilentlyContinue

    Write-Ok "Cleanup completed."
}

switch ($Target) {
    "all" {
        Test-Prerequisites
        foreach ($template in @("report", "letter", "beamer", "poster")) {
            Build-Template $template
        }
    }
    "report" {
        Test-Prerequisites
        Build-Template "report"
    }
    { $_ -in @("cover", "letter") } {
        Test-Prerequisites
        Build-Template "letter"
    }
    "beamer" {
        Test-Prerequisites
        Build-Template "beamer"
    }
    "poster" {
        Test-Prerequisites
        Build-Template "poster"
    }
    "clean" {
        Clean
    }
}
