---
name: quarto-computation-performance
description: Use when designing or reviewing Quarto workflows where execution cost, render time, caching, freezing, precomputed artifacts, externalized computation, simulations, model fitting, repeated or parameterized renders, pipeline-like execution, random seeds, engine-specific execution behavior for R/knitr, Python/Jupyter, or Julia, or proportional validation are central. Use for deciding whether computation belongs inside .qmd files, scripts, stored artifacts, or an external pipeline. Do not use for ordinary .qmd authoring, general cell-option cleanup, project YAML architecture unrelated to execution cost, format styling, report writing/design, deployment/CI, accessibility, or deep render troubleshooting except when the main issue is excessive recomputation or unsafe long renders.
---

# Quarto Computation Performance

Use this skill to reduce unnecessary recomputation and make Quarto workflows safer, faster, and easier to validate.

## Core Judgment

Decide whether the `.qmd` should compute results directly, consume precomputed artifacts, or sit downstream from an external pipeline.

A `.qmd` may contain lightweight, transparent computation. Heavy simulations, expensive model fitting, large preprocessing steps, or repeated report generation should usually be externalized or cached deliberately.

## Decision Sequence

1. Identify the expensive parts: data import, preprocessing, model fitting, simulation, figure/table generation, repeated renders, or multi-document project rendering.
2. Decide the appropriate execution strategy: ordinary execution for cheap computations, document/project-level `execute: cache`, cell-level `cache: true`, document/project-level `execute: freeze`, precomputed artifacts, external scripts, or a pipeline tool.
3. Preserve reproducibility by keeping source code for generated artifacts, recording random seeds for stochastic results, avoiding hidden manual artifacts, and ensuring outputs can be regenerated.
4. Validate proportionally by inspecting code/YAML first, rendering the smallest relevant target, and refreshing cache only when invalidation is uncertain.
5. State verification honestly: do not claim a full render, cache refresh, or artifact regeneration unless it actually ran.

## Quarto Mechanisms

- Use document/project-level `execute: cache` or cell-level `cache: true` for reusable execution results, but check the execution engine before assuming cache behavior.
- Use document/project-level `execute: freeze` mainly for global project renders; do not present `freeze` as chunk-level cache.
- Remember that incremental renders of a single document or subdirectory execute code by default, even in projects that use `freeze`.
- Treat R/knitr, Python/Jupyter, and Julia execution as engine-specific when cache, environments, kernels, or invalidation are part of the task.
- Use render flags such as `--cache`, `--no-cache`, `--cache-refresh`, `--execute`, `--no-execute`, `--execute-param`, `--execute-params`, `--execute-dir`, `--use-freezer`, and `--profile` only when they support targeted validation or a clear workflow.
- Treat `targets`, `drake`, Make, Arrow, DuckDB, Parquet, `.rds`, `.qs`, and similar tools as workflow choices, not default requirements.

## Boundaries

Use `quarto-project-configuration` for general `_quarto.yml`, profiles, parameters, render targets, output directories, and project structure.

Use `quarto-authoring-core` for ordinary cell options, inline computations, figures, tables, citations, cross-references, and `.qmd` structure.

Use `quarto-format-configuration` for output-format YAML, styling, templates, PDF/Typst/DOCX/revealjs/PowerPoint behavior, and format-specific rendering behavior.

Use `quarto-render-troubleshooting` for failed renders, logs, LaTeX/Typst errors, missing files, broken links, or output inspection unless the core issue is long-running recomputation.

Use future `quarto-publishing-deployment` for CI, hosting, publishing, and release automation.

## References

For compact decision rules and examples for cache/freeze, artifacts, externalized computation, pipeline escalation, random seeds, and proportional validation, read `references/computation-performance.md` when editing or reviewing concrete computation-heavy Quarto workflows.
