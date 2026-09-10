---
name: quarto-render-troubleshooting
description: Use when diagnosing, fixing, or verifying Quarto render failures or rendered-output problems, including failed renders; YAML, execution, dependency, path, LaTeX, Typst, citation, cross-reference, asset, extension, theme, or CSS problems; generated HTML inspection; Mermaid or lightbox behavior; DOCX or PDF checks; screenshots or browser review; links, anchors, navigation, post-render output, local-versus-CI differences, and honest structural, visual, or interactive verification claims. Use source or static checks only when the user says not to render. Do not use as the primary skill for ordinary .qmd authoring, planned project architecture, output-format design, cache or performance strategy, report design, deployment, accessibility review, or broad refactoring unless the main task is to fix or verify rendered output.
---

# Quarto Render Troubleshooting

Use this skill to diagnose, fix, and verify Quarto render failures or rendered-output defects. A successful render and a verified artifact are different claims.

## Core Role

Start from the observed failure or questionable output, isolate the smallest likely cause, apply a targeted fix when tools are available, and verify only what was actually checked.

Never claim that a render, screenshot, browser path, link, anchor, or output was checked unless it was actually checked.

## First Triage

Classify the problem before changing files:

1. Command or environment failure: Quarto, R, Python, Jupyter, LaTeX, Typst, Pandoc, or missing dependencies.
2. YAML or metadata failure: invalid indentation, wrong key placement, unsupported option, or profile mismatch.
3. Execution failure: cell or chunk error, missing package, missing object, bad parameter, or wrong working directory.
4. File/path failure: missing data, bibliography, CSL, image, include, extension, theme, or resource.
5. Format failure: LaTeX/PDF, Typst/PDF, DOCX/PPTX, revealjs, HTML asset, or CSS issue.
6. Output verification issue: rendered file exists but links, anchors, navigation, images, tables, citations, or layout are wrong.
7. Local-vs-CI issue: different Quarto/R/Python/TeX/Typst versions, missing system dependency, different working directory, missing files, or profile differences.

## Preferred Workflow

When tools are available:

1. Inspect the exact command, file, format, profile, and error message.
2. Prefer a targeted render over a full project render when sufficient.
3. Use diagnostic commands proportionally: `quarto check`, `quarto check all`, `quarto render <file>`, `quarto render <file> --to <format>`, `quarto render <file> --log-level debug`, `quarto render <file> --log <path>`, `quarto render <file> --execute-debug`, and `quarto render <file> --debug` when intermediate files are needed.
4. Read the first meaningful error, not only the final failure line.
5. Fix the smallest relevant source of failure.
6. Re-run the smallest render or verification check needed.
7. Report exactly what was verified and what remains unverified.

## Rendered Artifact Verification

When the output exists but correctness matters, verify only the relevant artifact surface:

- HTML: open the generated file or served page; inspect visual layout, assets, links, anchors, navigation, figures, tables, collapsed sections, and screenshots when needed. Test configured interactions such as lightbox behavior rather than inferring them from markup.
- For a local HTML artifact, run `python3 <skill-dir>/scripts/check_html_artifact.py <output.html>` when checking structural integrity. Adjudicate review candidates against the document's purpose, especially escaped markup in custom component subtrees: a successful render can still display a component's source. When edits are authorized, correct the source and repeat the relevant render/checks. The helper requires a local file and does not validate prose, CSS contrast, browser behavior, or visual quality.
- DOCX: check generated text, package/XML structure, citation output, table and figure readability, captions, section behavior, and Word/LibreOffice/OnlyOffice behavior when the user reports application-specific problems.
- PDF: inspect produced pages, figure/table placement, pagination, references, and any LaTeX or Typst-specific visual issue.
- Citations and references: check for raw citation keys, bibliography heading language, CSL/citeproc behavior, DOI/link output, and rendered reference formatting when relevant.
- Post-render scripts: confirm the script ran on the intended artifact, did not affect other formats, and produced the expected bounded transformation.

Always state which formats were rendered and which artifacts were inspected.

Keep verification levels distinct:

1. Source/static: source, paths, configuration, and references were inspected without rendering.
2. Rendered: the requested command completed and produced the expected artifact.
3. Structural: relevant DOM, anchors, resources, or package structure were inspected.
4. Visual: the artifact was opened or captured and relevant pages, sections, figures, tables, and rendered diagrams were reviewed at appropriate viewports or zoom levels.
5. Interactive: configured controls such as links, navigation, collapsed sections, or lightbox were exercised.

Do not combine these levels into a single pass claim. If a required level cannot be checked, report it as unverified.

## No Render Requested Or Unavailable

If the user explicitly says not to render, says they will render themselves, or render tools are unavailable, perform source/static checks only. Do not invoke render commands, do not imply layout verification, and state that rendered outputs were not verified.

## Common Fix Areas

Check, as applicable:

- YAML syntax, indentation, nesting, quoting, and option placement.
- Project vs document metadata placement.
- Active profile and selected output format.
- Execution engine: R/knitr, Python/Jupyter, Julia, prose-only, or mixed.
- `execute-dir`, relative paths, `here`, `getwd()`, and `QUARTO_PROJECT_DIR`.
- R/knitr: package availability, `.libPaths()`, `sessionInfo()`, and environment mismatch.
- Python/Jupyter: `jupyter`, kernels, virtual environments, `quarto check jupyter`, Python path issues, and notebook execution settings.
- Julia: whether the document uses `engine: julia` or Jupyter/IJulia, Julia installation, package environments, and kernel availability.
- Bibliography and CSL file paths, citation keys, and cite processor behavior.
- Cross-reference labels, prefixes, captions, duplicate labels, and section numbering.
- Image paths, generated figure paths, static assets, includes, and project resources.
- LaTeX installation, missing packages, Unicode/font issues, `keep-tex`, and intermediate `.tex`.
- Typst format options, bibliography handling, and Typst syntax errors.
- HTML assets, CSS/SCSS, theme/extension effects, links, anchors, and navigation.
- Mermaid diagrams for rendered SVG output, visible error placeholders, clipping, and legibility when they are part of the artifact.
- Lightbox activation, target resources, captions, enlargement, closing behavior, and keyboard access when lightbox is configured and interactive verification is required.

For HTML presentation changes, use the browser checks in `references/render-troubleshooting.md#html-verification`: intended reading widths, displayed label size and contrast, meaningful axis/reference labels, reachable table columns, and real keyboard operation. A successful click or full-page screenshot alone does not establish all of these.

## Boundary Rules

Use other skills when the main task is not troubleshooting:

- `quarto-authoring-core`: writing or reviewing ordinary `.qmd` content.
- `quarto-project-configuration`: designing `_quarto.yml`, `_metadata.yml`, profiles, render targets, or project structure.
- `quarto-format-configuration`: choosing or configuring output formats before a failure occurs.
- `quarto-computation-performance`: reducing expensive recomputation, cache/freeze strategy, precomputed artifacts, or pipeline escalation.
- `quarto-report-design`: report structure, audience, and communication design.
- Future `quarto-publishing-deployment`: publishing targets, hosting, and CI/CD setup.
- Future `quarto-accessibility-quality`: accessibility and publication-readiness review beyond failure verification.

## Verification Discipline

Say "verified" only for checks actually performed.

Acceptable wording:

- "I rendered `report.qmd` to HTML successfully."
- "I inspected the generated `report.html` and confirmed the figure appears."
- "I checked the internal link to `#sec-methods`."
- "I did not run the PDF render, so the LaTeX fix is not verified."
- "I checked source-level citations only; I did not render the DOCX, so reference formatting is not verified."

Do not say:

- "This should render now" as if it was verified.
- "The links work" without checking them.
- "The screenshot looks good" without actually opening or capturing the output.

## References

For compact diagnosis patterns for render failures, YAML errors, execution errors, paths/assets, LaTeX/Typst failures, citations, cross-references, HTML verification, and local-vs-CI differences, read `references/render-troubleshooting.md` when fixing or verifying concrete Quarto render/output problems.
