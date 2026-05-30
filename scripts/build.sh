#!/usr/bin/env bash
#
# build.sh - Build PDFs for WestlakeU-LaTeX templates
#
# Usage:
#   ./build.sh              # Build all templates
#   ./build.sh report       # Build only report
#   ./build.sh cover        # Build only cover letter
#   ./build.sh beamer       # Build only beamer
#   ./build.sh poster       # Build only poster
#   ./build.sh clean        # Remove auxiliary files
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="${SCRIPT_DIR}/scripts/.build"

# ---------- LaTeX compilation settings ----------
LATEXMK_OPTS=(
    -xelatex          # Use XeLaTeX (supports Unicode & system fonts)
    -g                # Force re-run even if up-to-date
    -silent           # Less verbose output
    -interaction=nonstopmode
    -halt-on-error
    -synctex=1
)

# ---------- Helper functions ----------
info()  { echo -e "\033[1;34m[INFO]\033[0m  $*"; }
ok()    { echo -e "\033[1;32m[OK]\033[0m    $*"; }
warn()  { echo -e "\033[1;33m[WARN]\033[0m  $*" >&2; }
err()   { echo -e "\033[1;31m[ERROR]\033[0m $*" >&2; }

# ---------- Check prerequisites ----------
check_prerequisites() {
    if ! command -v latexmk &>/dev/null; then
        err "latexmk not found. Please install TeX Live (or MacTeX / MikTeX) first."
        exit 1
    fi
    info "Using latexmk: $(command -v latexmk)"
}

# ---------- Build one template ----------
build_template() {
    local name="$1"
    local dir="${SCRIPT_DIR}/src/${name}"
    local main_tex="${dir}/main.tex"

    if [[ ! -f "${main_tex}" ]]; then
        warn "Skipping '${name}': ${main_tex} not found."
        return
    fi

    info "Building ${name} ..."
    mkdir -p "${BUILD_DIR}/${name}"

    export TEXINPUTS="${SCRIPT_DIR}/style//:${TEXINPUTS:-}"

    latexmk "${LATEXMK_OPTS[@]}" \
        -cd "${dir}/main.tex" \
        -outdir="${BUILD_DIR}/${name}"

    # Copy the final PDF to the output directory
    mkdir -p "${SCRIPT_DIR}/output"
    if [[ -f "${BUILD_DIR}/${name}/main.pdf" ]]; then
        cp "${BUILD_DIR}/${name}/main.pdf" "${SCRIPT_DIR}/output/${name}.pdf"
        ok "Created: ${SCRIPT_DIR}/output/${name}.pdf"
    else
        err "Failed to find ${BUILD_DIR}/${name}/main.pdf"
    fi
}

# ---------- Clean auxiliary files ----------
clean() {
    info "Cleaning auxiliary files ..."

    # Remove build directory
    rm -rf "${BUILD_DIR}"

    # Remove generated PDFs from output directory
    rm -f "${SCRIPT_DIR}/output"/*.pdf

    # Remove stray auxiliary files in src directories
    find "${SCRIPT_DIR}/src" -maxdepth 3 \
        \( -name "*.aux" -o -name "*.log" -o -name "*.out" \
           -o -name "*.toc" -o -name "*.nav" -o -name "*.snm" \
           -o -name "*.bbl" -o -name "*.bcf" -o -name "*.blg" \
           -o -name "*.run.xml" -o -name "*.fls" -o -name "*.fdb_latexmk" \
           -o -name "*.synctex.gz" -o -name "*.vrb" \) -delete

    ok "Cleanup completed."
}

# ---------- Main ----------
main() {
    case "${1:-all}" in
        all)
            check_prerequisites
            build_template "report"
            build_template "letter"
            build_template "beamer"
            build_template "poster"
            ;;
        report)
            check_prerequisites
            build_template "report"
            ;;
        letter)
            check_prerequisites
            build_template "letter"
            ;;
        beamer)
            check_prerequisites
            build_template "beamer"
            ;;
        poster)
            check_prerequisites
            build_template "poster"
            ;;
        clean)
            clean
            ;;
        *)
            echo "Usage: $0 [all | report | letter | beamer | poster | clean]"
            exit 1
            ;;
    esac
}

main "$@"
