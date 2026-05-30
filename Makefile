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

.PHONY: all report beamer poster letter clean help

SHELL := /bin/bash

# ---- Build all ----
all: report beamer poster letter

# ---- Individual template targets ----
report:
	@./scripts/build.sh report

beamer:
	@./scripts/build.sh beamer

poster:
	@./scripts/build.sh poster

letter:
	@./scripts/build.sh letter

# ---- Clean ----
clean:
	@./scripts/build.sh clean

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
