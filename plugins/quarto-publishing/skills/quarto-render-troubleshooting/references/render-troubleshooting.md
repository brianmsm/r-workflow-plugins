# Quarto Render Troubleshooting Reference

Use these compact patterns when diagnosing and fixing concrete Quarto render failures or rendered-output defects. Start from the exact command, error message, input file, output format, active profile, and environment.

## Contents

- [Failure triage](#failure-triage) · [Diagnostic commands](#diagnostic-commands)
- [YAML](#yaml-and-metadata-errors) · [Execution/working directory](#execution-errors-and-working-directory) · [Assets/paths](#paths-assets-and-resources) · [Bibliography/references](#bibliography-citations-and-cross-references)
- Output: [LaTeX](#latex-pdf-failures) · [Typst](#typst-failures) · [HTML](#html-verification) · [DOCX](#docx-verification) · [PDF](#pdf-verification) · [Slides](#presentation-output-verification)
- [Citations/CSL](#citation-and-csl-verification) · [Post-render](#post-render-verification) · [No render](#no-render-requested-or-available) · [Local/CI](#local-vs-ci-differences) · [Verification claims](#verification-discipline)

## Failure Triage

Classify the failure before editing:

- Command/environment: Quarto, R, Python, Jupyter, LaTeX, Typst, Pandoc, or system dependency problem.
- YAML/metadata: parse error, indentation, invalid key, unsupported option, or wrong layer.
- Execution: cell or chunk error, missing package/module, missing object, bad parameter, wrong working directory, stale cache.
- Files/assets: missing data, bibliography, CSL, image, include, extension, theme, CSS, or resource.
- Format: LaTeX PDF, Typst PDF, DOCX/PPTX, revealjs, HTML asset, or CSS failure.
- Output verification: generated file exists but links, anchors, navigation, images, citations, cross-references, or layout are wrong.
- Local-vs-CI: version, path, dependency, profile, system library, or environment mismatch.

Read the first meaningful error. The final line often reports only that rendering failed.

## Diagnostic Commands

Check the Quarto installation or execution engines:

```bash
quarto check
quarto check knitr
quarto check jupyter
quarto check all
```

When diagnosing execution failures, identify the execution engine before proposing fixes:

- R/knitr: check R packages, knitr options, `renv` or library paths, and the active R session.
- Python/Jupyter: check `jupyter`, kernels, virtual environments, `quarto check jupyter`, Python path issues, and whether notebooks should execute during render.
- Julia: check whether the document uses `engine: julia` or Jupyter/IJulia, Julia installation, package environments, and kernel availability.

Prefer targeted renders:

```bash
quarto render report.qmd
quarto render report.qmd --to html
quarto render report.qmd --to pdf
quarto render report.qmd --to typst
quarto render --profile production
```

Use logs and debug output when the ordinary error is not enough:

```bash
quarto render report.qmd --log-level debug
quarto render report.qmd --log quarto-render.log
quarto render report.qmd --execute-debug
quarto render report.qmd --debug
```

Use `--debug` when intermediate files, such as generated `.tex`, are needed. Do not leave generated debug artifacts committed unless the user explicitly wants them.

Use `--execute-debug` when the failure is inside computation execution and ordinary logs are not enough.

For stale cache symptoms, a targeted cache refresh may be diagnostic:

```bash
quarto render report.qmd --cache-refresh
quarto render report.qmd --no-cache
```

Do not turn cache/freeze troubleshooting into cache/freeze architecture. Defer strategy to `quarto-computation-performance`.

## YAML And Metadata Errors

Common failure signs:

- "YAML parse exception"
- "mapping values are not allowed"
- "did not find expected key"
- option works in one file but fails in another

Check:

- indentation uses spaces and preserves nesting
- strings with special characters are quoted when needed
- `format:` options are under the correct output format
- project-level options belong in `_quarto.yml`, directory defaults in `_metadata.yml`, and local options in document YAML
- active profiles are the intended ones

If the task is to design YAML placement from scratch, use `quarto-project-configuration` or `quarto-format-configuration`. Stay here when wrong YAML is causing a failure or defective output.

## Execution Errors And Working Directory

Common failure signs:

- package/module not found
- object, variable, or name not found
- file not found
- parameter missing
- working directory differs between interactive work and render
- wrong kernel, environment, or execution engine

For R/knitr, useful checks include:

```r
getwd()
.libPaths()
sessionInfo()
```

For Python/Jupyter, check the active kernel, virtual environment, Python path, and whether `quarto check jupyter` reports the expected configuration.

For Julia, check whether the document uses `engine: julia` or Jupyter/IJulia, and verify the Julia executable, project environment, package availability, and kernel when applicable.

Review cell or chunk labels and options only as needed to fix the failure. Ordinary cell or chunk option cleanup belongs to `quarto-authoring-core`.

For project renders, code usually executes relative to the document directory unless `execute-dir: project` is configured. Avoid assuming an interactive RStudio working directory.

Prefer stable paths and project-aware code. If the existing project uses `here`, `rprojroot`, `fs`, or `QUARTO_PROJECT_DIR`, follow that pattern instead of inventing a new one.

## Paths, Assets, And Resources

Check every file path mentioned by the error:

- data files
- images and generated figures
- bibliography and CSL files
- includes and templates
- CSS/SCSS and theme files
- extension files
- files expected to be copied through project resources

For HTML or website output, distinguish "render succeeded but asset is missing in output" from "render failed before output." Missing copied resources may involve the project-level `resources` option under `project:`, but full project layout design belongs to `quarto-project-configuration`.

## Bibliography, Citations, And Cross-References

For bibliography and citation failures, check:

- bibliography path exists from the rendering context
- CSL path exists if configured
- citation keys match the bibliography
- citation processor behavior is appropriate for the output format
- Typst output is not being treated exactly like Pandoc/LaTeX output

For cross-reference failures, check:

- labels use Quarto typed prefixes such as `fig-`, `tbl-`, `eq-`, and `sec-`
- referenced figures, tables, equations, or sections have labels, and captions where applicable
- labels are unique
- cross-reference identifiers are lowercase and avoid underscores, especially for PDF/LaTeX output
- section IDs are stable when section references must not depend on generated IDs

Creating citations or cross-references from scratch belongs to `quarto-authoring-core`; fixing unresolved rendered references belongs here.

## LaTeX PDF Failures

For PDF failures through LaTeX, check:

- a TeX distribution is available
- TinyTeX or required LaTeX packages are installed
- Unicode or font errors point to a needed engine change or font configuration
- `include-in-header` or template files exist and are valid
- `keep-tex: true` or `--debug` can preserve intermediate `.tex` for inspection

Read the first substantive LaTeX error rather than only the final `PDF creation failed` line.

Do not redesign PDF styling here. Format choices and options belong to `quarto-format-configuration` unless a specific option is causing the failure.

## Typst Failures

For Typst output, check:

- Typst output is configured with `format: typst`
- Typst-specific options, templates, bibliography behavior, and syntax are not confused with LaTeX options
- referenced files exist
- Typst syntax errors point to the relevant generated or source location

Keep Typst guidance limited to diagnosis and verification. Do not turn this reference into a Typst tutorial.

## HTML Verification

When HTML output is generated but may be defective, inspect only what matters for the task:

- file exists at the expected path
- page opens without obvious missing assets
- links and anchors navigate to the intended targets
- images and generated figures appear
- navigation/sidebar/table of contents behaves as expected
- CSS/theme changes did not break readability or layout
- figures and tables are readable in the normal page view and at relevant narrow or enlarged viewports
- collapsed sections leave the main narrative understandable when closed and display usable technical detail when opened
- Mermaid blocks render as usable diagrams rather than error text, empty SVG, clipped content, or illegible labels
- configured lightbox figures open the intended resource, preserve useful caption context, close correctly, and support the interaction paths relevant to the task

Use browser automation or screenshots when visual output matters. Say exactly what was opened, clicked, or captured.

For presentation changes, choose checks from the actual reading tasks:

- Inspect the relevant full-page context and close views of changed sections at the normal column width and intended narrow widths. Viewport emulation is not a physical-device test. Record the dimensions used; do not infer phone readability from a tablet-width capture or from absence of page overflow.
- Wait for fonts, diagrams, images, and active widget transitions to settle before capturing. Open the resulting images for review; a saved screenshot path alone is not visual inspection. For lightbox, verify the displayed image and caption, not merely an inserted dialog or an early animation frame.
- Inspect figure/diagram text at its displayed scale. Check computed foreground/background pairs, compositing transparent backgrounds where needed. For ordinary text, [WCAG contrast guidance](https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html) uses 4.5:1; qualifying large text uses 3:1. Source font sizes can shrink with the graphic. A few measured pairs do not constitute a complete accessibility audit.
- Check the rendered alternative text or accessible description of meaningful figures. A caption or successful image load does not prove that an image alternative exists. For generated Quarto figures, use `fig-alt` where supported or a suitable linked textual description; distinguish meaningful figures from intentionally decorative images and verify the output, not only the chunk options.
- Cross-check visual meaning against the text/table: outcome units, adjusted versus raw quantities, baseline, direction of improvement, zero or neutral value, and uncertainty. A readable axis with the wrong interpretation is still a presentation failure.
- Test reading-guide and TOC links, including nested population/outcome sections, and confirm the destination is visible. For wide/long tables, exercise local scrolling and confirm later columns, row labels, grouped headers, and notes remain usable; a page without horizontal overflow can still hide table content.
- Use actual keyboard traversal to reach disclosure and enlargement controls; exercise activation and closing, visible focus, and focus return where applicable. For modal lightboxes, check initial focus inside the settled dialog, Tab containment, Escape, and return to the trigger; distinguish an opening animation from persistent focus failure. A clickable `div`, an ARIA label, or programmatic focus alone does not prove keyboard access. If the generated control fails, use a supported accessible component or a native `details`/`summary` disclosure for HTML when it preserves the content; then retest. Document unresolved runtime behavior rather than applying an unverified global patch. Do not hide required evidence in a failed widget.
- For scripted checks, inspect returned conditions or assert them explicitly. Record failures separately from the automation process exit code; correct stale/ambiguous locators without changing the artifact just to satisfy the test.

For structural verification when a local HTML artifact is available, run `python3 <skill-dir>/scripts/check_html_artifact.py report.html` for a read-only, standard-library check of duplicate IDs, same-document fragment targets, and local image/script/stylesheet paths. It is not required for a remote or served page without a local artifact. It reports suspicious markup inside code as review candidates: inspect the source and final subtree to decide whether this is an intended tutorial example or a broken report component. Do not automatically delete legitimate code or equate an empty error list with a verified artifact. Inspect repeated custom components, not merely the existence of a chart or table. The helper intentionally leaves CSS cascade/contrast, responsive layout, dynamic resources, and interactions unverified.

Treat source inspection, successful render, structural inspection, visual inspection, and interactive testing as separate evidence levels. Finding a lightbox class in HTML does not prove that enlargement works; finding an SVG does not prove that a Mermaid diagram is legible. If browser execution is unavailable, report the affected checks as unverified.

For public-facing reports with local terminology rules, inspect rendered headings, captions, table cells, legends, alt or ARIA text, SVG labels, navigation, and metadata when the task includes language-policy verification. A clean source-prose search does not prove that generated or hidden surfaces comply.

Do not perform broad visual design or accessibility review here. Deep accessibility belongs to future `quarto-accessibility-quality`.

## DOCX Verification

For DOCX output, distinguish "Quarto produced a `.docx` file" from "the Word artifact was verified." Depending on the task, check:

- expected text is present and obsolete text is absent
- raw citation keys, raw LaTeX symbols, or broken inline notation did not leak into the document
- tables, captions, figure wrappers, and landscape sections are readable
- headers, footers, page numbers, and section breaks behave as intended
- package/XML checks when visual tools are insufficient
- Word, LibreOffice, or OnlyOffice behavior when the user reports application-specific prompts or layout differences

Do not over-attribute DOCX repair prompts or application differences without evidence. If the cause is unclear, state the uncertainty and preserve source-of-truth files.

## PDF Verification

For PDF output, inspect pages when layout matters. Check that figures, tables, references, pagination, and symbols appear as intended. If only source or logs were checked, do not claim PDF layout verification.

## Presentation Output Verification

Distinguish "render succeeded" from "the presentation artifact was reviewed."

- Revealjs: open the generated HTML when possible; check slide navigation when relevant; verify that figures, tables, and code output fit; check speaker notes only when requested or required; claim PDF export verification only if the PDF was actually generated and inspected.
- PowerPoint: inspect the generated `.pptx` when template or layout behavior matters; check slide layouts, figures, tables, and speaker notes when relevant.
- Beamer: verify the generated PDF when possible; inspect LaTeX logs when rendering fails; check equations, blocks, figures, and overflow when relevant.

Do not claim visual review, navigation review, speaker-note review, or presentation PDF export review unless that output was opened, inspected, or generated.

## Citation and CSL Verification

Correct YAML does not prove rendered citation correctness. When citations or references are part of the task, check the relevant rendered output for:

- no unintended raw citation keys
- expected bibliography or references heading language
- CSL/citeproc activation where configured
- DOI or URL formatting when required
- obvious bibliography formatting issues in the target output

Bibliography data problems, such as title capitalization or protected braces, may surface only after render inspection. Keep fixes scoped to the reported citation/output problem.

## Post-Render Verification

When a project uses a `post-render` command, verify that it:

- ran on the intended output file
- is guarded against unrelated formats when format-specific
- is idempotent or safe to rerun
- preserved the source-of-truth `.qmd` workflow
- produced the expected bounded change in the rendered artifact

Post-render scripts can be inspected here only to explain or verify rendered-output behavior. Designing a broad post-render architecture belongs outside troubleshooting.

## No Render Requested Or Available

When the user says not to render, or render tools are unavailable, use static checks such as source inspection, scoped search, path checks, citation-key checks, or diff review. State plainly that rendered outputs were not verified.

## Local-Vs-CI Differences

For CI render failures, compare:

- Quarto version
- R/Python/Jupyter versions
- package/library installation
- TeX or Typst availability
- system dependencies
- working directory
- active profile
- checked-in data/assets/resources
- environment variables and secrets

This skill can diagnose a CI render failure. Designing CI/CD, hosting, or publishing automation belongs to future `quarto-publishing-deployment`.

## Verification Discipline

Report verification with exact scope:

- "Rendered `report.qmd` to HTML with `quarto render report.qmd --to html`."
- "Opened `_site/index.html` and checked the navbar links to `about.html` and `reports.html`."
- "Ran the PDF render and confirmed it produced `report.pdf`."
- "Did not run the full website render because the targeted page render was sufficient for this fix."
- "Checked DOCX XML/text for the expected caption, but did not visually inspect the Word pages."
- "Performed source-only checks because the user asked not to render; rendered output remains unverified."

Avoid claims like "works now", "all links work", "the PDF is fixed", or "the screenshot looks good" unless those checks were actually performed.

## Official Sources

- Quarto troubleshooting: https://quarto.org/docs/troubleshooting/
- Quarto check command: https://quarto.org/docs/cli/check.html
- Quarto render command: https://quarto.org/docs/cli/render.html
- Quarto project execution: https://quarto.org/docs/projects/code-execution.html
- Quarto lightbox figures: https://quarto.org/docs/output-formats/html-lightbox-figures.html
- Quarto computations with R: https://quarto.org/docs/computations/r.html
- Quarto computations with Python: https://quarto.org/docs/computations/python.html
- Quarto computations with Julia: https://quarto.org/docs/computations/julia.html
- Quarto caching: https://quarto.org/docs/computations/caching.html
- Quarto rendering script files: https://quarto.org/docs/computations/render-scripts.html
- Quarto citations: https://quarto.org/docs/authoring/citations.html
- Quarto cross-references: https://quarto.org/docs/authoring/cross-references
- Quarto presentations: https://quarto.org/docs/presentations/
- Quarto revealjs: https://quarto.org/docs/presentations/revealjs/
- Quarto presenting slides: https://quarto.org/docs/presentations/revealjs/presenting.html
- Quarto revealjs options: https://quarto.org/docs/reference/formats/presentations/revealjs.html
- Quarto PowerPoint: https://quarto.org/docs/presentations/powerpoint.html
- Quarto Beamer: https://quarto.org/docs/presentations/beamer.html
- Quarto PDF basics: https://quarto.org/docs/output-formats/pdf-basics.html
- Quarto PDF engine: https://quarto.org/docs/output-formats/pdf-engine.html
- Quarto Typst output: https://quarto.org/docs/output-formats/typst.html
- Pandoc user guide: https://pandoc.org/MANUAL.html
- knitr options: https://yihui.org/knitr/options/
- Typst bibliography: https://typst.app/docs/reference/model/bibliography/
