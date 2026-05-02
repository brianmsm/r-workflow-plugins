# Quarto Render Troubleshooting Reference

Use these compact patterns when diagnosing and fixing concrete Quarto render failures or rendered-output defects. Start from the exact command, error message, input file, output format, active profile, and environment.

## Failure Triage

Classify the failure before editing:

- Command/environment: Quarto, R, Python, Jupyter, LaTeX, Typst, Pandoc, or system dependency problem.
- YAML/metadata: parse error, indentation, invalid key, unsupported option, or wrong layer.
- Execution: chunk error, missing package, missing object, bad parameter, wrong working directory, stale cache.
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

## R And Chunk Execution Errors

Common failure signs:

- package not found
- object not found
- file not found
- parameter missing
- working directory differs between interactive work and render

Check:

```r
getwd()
.libPaths()
sessionInfo()
```

Review chunk labels and options only as needed to fix the failure. Ordinary chunk cleanup belongs to `quarto-authoring-core`.

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

Use browser automation or screenshots when visual output matters. Say exactly what was opened, clicked, or captured.

Do not perform broad visual design or accessibility review here. Deep accessibility belongs to future `quarto-accessibility-quality`.

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

Avoid claims like "works now", "all links work", "the PDF is fixed", or "the screenshot looks good" unless those checks were actually performed.

## Official Sources

- Quarto troubleshooting: https://quarto.org/docs/troubleshooting/
- Quarto check command: https://quarto.org/docs/cli/check.html
- Quarto render command: https://quarto.org/docs/cli/render.html
- Quarto project execution: https://quarto.org/docs/projects/code-execution.html
- Quarto computations with R: https://quarto.org/docs/computations/r.html
- Quarto caching: https://quarto.org/docs/computations/caching.html
- Quarto citations: https://quarto.org/docs/authoring/citations.html
- Quarto cross-references: https://quarto.org/docs/authoring/cross-references
- Quarto PDF basics: https://quarto.org/docs/output-formats/pdf-basics.html
- Quarto PDF engine: https://quarto.org/docs/output-formats/pdf-engine.html
- Quarto Typst output: https://quarto.org/docs/output-formats/typst.html
- Pandoc user guide: https://pandoc.org/MANUAL.html
- knitr options: https://yihui.org/knitr/options/
- Typst bibliography: https://typst.app/docs/reference/model/bibliography/
