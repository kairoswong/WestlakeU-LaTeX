param(
    [ValidateSet("all", "report", "cover", "letter", "beamer", "poster", "clean")]
    [string]$Target = "all"
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ScriptDir = (Get-Item $ScriptDir).Parent.FullName
$BuildDir = Join-Path $ScriptDir "scripts/.build"

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
    $dir = Join-Path $ScriptDir "src" $Name
    $mainTex = Join-Path $dir "main.tex"
    if (-not (Test-Path $mainTex)) {
        Write-Warn "Skipping '$Name': $mainTex not found."
        return
    }

    $templateBuildDir = Join-Path $BuildDir $Name
    New-Item -ItemType Directory -Force $templateBuildDir | Out-Null

    Write-Info "Building $Name ..."

    $env:TEXINPUTS = "$([System.IO.Path]::GetFullPath((Join-Path $ScriptDir 'style'))//;$env:TEXINPUTS"

    $outDirArg = "-outdir=$($templateBuildDir -replace '\\', '/')"
    & latexmk @LatexmkOptions -cd $outDirArg "$dir\main.tex"

    $pdf = Join-Path $templateBuildDir "main.pdf"
    $outputDir = Join-Path $ScriptDir "output"
    $destination = Join-Path $outputDir "$Name.pdf"
    if (Test-Path $pdf) {
        New-Item -ItemType Directory -Force $outputDir | Out-Null
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

    # Remove generated PDFs from output directory
    $outputDir = Join-Path $ScriptDir "output"
    if (Test-Path $outputDir) {
        Remove-Item (Join-Path $outputDir "*.pdf") -Force -ErrorAction SilentlyContinue
    }

    $patterns = @(
        "*.aux", "*.log", "*.out", "*.toc", "*.nav", "*.snm", "*.bbl", "*.bcf",
        "*.blg", "*.run.xml", "*.fls", "*.fdb_latexmk", "*.synctex.gz", "*.vrb"
    )

    $srcDir = Join-Path $ScriptDir "src"
    if (Test-Path $srcDir) {
        Get-ChildItem $srcDir -Recurse -File -Depth 3 -Include $patterns |
            Remove-Item -Force -ErrorAction SilentlyContinue
    }

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
    "letter" {
        Test-Prerequisites
        Build-Template "letter"
    }
    "cover" {
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
