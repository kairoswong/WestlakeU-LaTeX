# Makefile for WestlakeU-LaTeX
#
# Templates are located under src/ (e.g. src/report/).
# Generated PDFs are placed in the output/ directory.
#
# Targets:
#   make          — Build all templates (default)
#   make report   — Build report only
#   make beamer   — Build beamer only
#   make poster   — Build poster only
#   make letter   — Build letter only
#   make clean    — Remove auxiliary files and build artifacts
#   make help     — Show this usage message

# Detect OS and select appropriate build script
ifeq ($(OS),Windows_NT)
    BUILD_SCRIPT := powershell -ExecutionPolicy Bypass -File scripts/build.ps1
    RM := Remove-Item -Force
    RMDIR := Remove-Item -Recurse -Force
    DETECT_OS := Windows
else
    BUILD_SCRIPT := ./scripts/build.sh
    RM := rm -f
    RMDIR := rm -rf
    DETECT_OS := $(shell uname -s)
endif

export DETECT_OS

.PHONY: all report beamer poster letter clean help

# ---- Build all ----
all: report beamer poster letter

# ---- Individual template targets ----
report:
	@$(BUILD_SCRIPT) report

beamer:
	@$(BUILD_SCRIPT) beamer

poster:
	@$(BUILD_SCRIPT) poster

letter:
	@$(BUILD_SCRIPT) letter

# ---- Clean ----
clean:
	@$(BUILD_SCRIPT) clean

# ---- Help ----
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  all       Build all templates (default)"
	@echo "  report    Build report template"
	@echo "  beamer    Build beamer presentation"
	@echo "  poster    Build poster"
	@echo "  letter    Build letter"
	@echo "  clean     Remove auxiliary files and build artifacts"
	@echo "  help      Show this usage message"
