# WestlakeU-LaTeX

This repository contains LaTeX templates for creating documents related to Westlake University. The templates are designed to be user-friendly and customizable, helping you maintain a consistent and professional look across common academic documents.

## Preview

| Template | Preview |
|:--------:|:-------:|
| **📊 Beamer** | <img src="assets/preview/beamer.jpg" width="50%" /> |
| **✉️ Letter** | <img src="assets/preview/letter.jpg" width="50%" /> |
| **🖼️ Poster** | <img src="assets/preview/poster.jpg" width="50%" /> |
| **📝 Report** | <img src="assets/preview/report.jpg" width="50%" /> |

## Project Structure

```
WestlakeU-LaTeX/
├── beamer/          # Beamer presentation template
├── letter/          # Letter template
├── poster/          # Poster template
├── report/          # Report template
├── style/           # Shared style files (.sty)
├── assets/          # Logos, images, and previews
├── build.sh         # Bash build helper
└── build.ps1        # PowerShell build helper
```

P.S. Feel free to contribute more templates!

## Requirements

- A LaTeX distribution (TeX Live, MacTeX, or MiKTeX)
- `latexmk` (usually included with TeX Live)
- XeLaTeX, Biber, and the common LaTeX packages used by the templates
- Recommended fonts: Times New Roman, Arial, Courier New, Microsoft YaHei; plus Raleway and Lato for the poster template
- A LaTeX editor (optional but recommended)
- Basic familiarity with LaTeX syntax

## Building

All templates can be built with the provided helper scripts. Use `build.ps1` on Windows PowerShell and `build.sh` on macOS/Linux or other Bash environments.

### Windows PowerShell

```powershell
# Build all templates
.\build.ps1

# Build a specific template
.\build.ps1 report      # Build report template
.\build.ps1 letter     # Build letter template
.\build.ps1 beamer      # Build beamer presentation
.\build.ps1 poster      # Build poster

# Clean auxiliary files and generated PDFs
.\build.ps1 clean
```

### Bash

```bash
# Build all templates
./build.sh

# Build a specific template
./build.sh report      # Build report template
./build.sh letter      # Build letter template
./build.sh beamer      # Build beamer presentation
./build.sh poster      # Build poster

# Clean auxiliary files and generated PDFs
./build.sh clean
```

Generated PDFs are copied into each template directory, for example `report/report.pdf`. Temporary build files are kept under `.build/`.

## Template Usage

Each template keeps editable content in `content.tex` and project settings in `main.tex`. In most cases, you only need to:

1. Update the title, author, institute, and other metadata in `main.tex`.
2. Replace the example body in `content.tex`.
3. Put your figures under `assets/` or a local `figures/` directory and update `\includegraphics` paths.

## Acknowledgements

Special thanks to the faculty and staff at Westlake University for their valuable feedback and support throughout the development of these templates.

## Contributions

If you find any issues or have suggestions for improvements, please feel free to open an issue or submit a pull request. Contributions are always welcome!

## License

This project is licensed under the LPPL-1.3c License. See the [LICENSE](LICENSE) file for more details.
