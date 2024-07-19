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

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${SCRIPT_DIR}/.build"

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
    local dir="${SCRIPT_DIR}/${name}"
    local main_tex="${dir}/main.tex"

    if [[ ! -f "${main_tex}" ]]; then
        warn "Skipping '${name}': ${main_tex} not found."
        return
    fi

    info "Building ${name} ..."
    mkdir -p "${BUILD_DIR}/${name}"

    # Run latexmk inside the template directory so relative includes (e.g., content.tex) work
    cd "${dir}"

    latexmk "${LATEXMK_OPTS[@]}" \
        -outdir="${BUILD_DIR}/${name}" \
        main.tex

    # Copy the final PDF back to the template directory
    if [[ -f "${BUILD_DIR}/${name}/main.pdf" ]]; then
        cp "${BUILD_DIR}/${name}/main.pdf" "${dir}/${name}.pdf"
        ok "Created: ${dir}/${name}.pdf"
    else
        err "Failed to find ${BUILD_DIR}/${name}/main.pdf"
    fi

    cd "${SCRIPT_DIR}"
}

# ---------- Clean auxiliary files ----------
clean() {
    info "Cleaning auxiliary files ..."

    # Remove build directory
    rm -rf "${BUILD_DIR}"

    # Remove generated PDFs from template directories
    for dir in report letter beamer poster; do
        rm -f "${SCRIPT_DIR}/${dir}/${dir}.pdf"
    done

    # Remove stray auxiliary files in template directories
    find "${SCRIPT_DIR}" -maxdepth 3 \
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
        cover|letter)
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
            echo "Usage: $0 [all | report | cover | letter | beamer | poster | clean]"
            exit 1
            ;;
    esac
}

main "$@"
