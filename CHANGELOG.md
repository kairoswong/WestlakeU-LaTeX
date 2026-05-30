# Changelog

All notable changes to the WestlakeU-LaTeX templates are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v1.0.0] — 2026-05-30

### Added
- Refactored font system with OS auto-detection; Western/CJK/Math fonts configured independently with graceful fallbacks
- Added three-tier logging (error/warning/info) for better diagnostics
- Added package conflict warnings (e.g., unicode-math vs. amsfonts)
- Added engine detection (XeLaTeX and LuaLaTeX only)

### Changed
- Deferred font detection to end-of-preamble to avoid interference with user packages
- Removed duplicate font loading from beamer and poster templates; fonts are now managed centrally by the base style package


## [v1.0.1] — 2026-05-30

### Added
- Added `Makefile` with targets for all, report, beamer, poster, letter, clean, and help

### Changed
- Moved build scripts into `scripts/` directory; simplified README build section to prioritize `make`