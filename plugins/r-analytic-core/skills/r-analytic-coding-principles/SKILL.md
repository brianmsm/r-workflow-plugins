---
name: r-analytic-coding-principles
description: "Use when editing analytical or classroom R code (.R, .Rmd, .qmd) to keep models and figures locally editable, support understandable student scripts, resolve package conflicts, or simplify checks without changing results."
---

# R Analytic Coding Principles

Make R code easy for a researcher to inspect, edit at the point of use, rerun selectively, and reason about. Optimize for **researcher editability and analytical transparency**, not minimum line count or pipeline-style abstraction.

## Choose the Working Style

1. Follow explicit user requirements first, then project conventions and the existing file's style. When none is established and the task is iterative research analysis, default to **research-first, locally editable code**.
2. Identify whether the immediate task is exploratory/interactive analysis, a reproducible analytical handoff, or a genuinely automated/production-oriented workflow. These modes are not mandatory stages of maturity.
3. Respect the chosen R idiom (base R, tidyverse, `data.table`, or a justified mix), editor cell conventions, and object naming. An explicit tidyverse preference applies consistently to **new or edited** imports, transformations, and ordinary iteration, not merely to `dplyr` verbs; see the [style reference](references/research-first-coding-style.md#apply-a-tidyverse-preference-consistently). Preserve an explicit preference for `for` loops or mixed idioms. Do not restyle untouched code or change input semantics without review.
4. Apply these principles to **R computation inside `.R`, `.Rmd`, and `.qmd`**. Leave document syntax, formatting, render behavior, and publication decisions to the relevant authoring or publishing workflow.

## Core Coding Rules

- **Keep analysis local; no mega-setup.** Put each independently revised model's **formula or syntax (including a CFA model string)**, estimation, immediate inspection, and case-specific diagnostics or plots in its own section. Keep genuinely shared inputs/packages upstream and comparisons downstream; do not place per-section models, plots and derived results in an initial `.R` setup or `.qmd`/`.Rmd` mega-chunk. Do not move only the fit while leaving its editable definition far away.
- **Prefer explicit analytical repetition.** If separate models, contrasts, or figures are likely to be revised independently, keep their native calls and arguments visible even when they repeat substantially. Do not automatically replace them with `map()`, loops, dynamically generated formulas, or custom wrappers merely to reduce duplicated lines.
- **Abstract stable mechanics, not evolving decisions.** A small, well-understood helper may handle truly invariant recoding, extraction, or display logic. Do not hide model formulas, estimators, grouping choices, or figure-specific `ggplot2` options behind convenience functions by default. Systematic simulation or deliberately batch-oriented tasks are valid exceptions.
- **Keep plots editable.** Preserve the figure's `ggplot()`, geoms, scales, `labs()`, and `theme()` near the figure it produces. Reuse a common theme or palette if desired, but keep meaningful per-figure choices inspectable.
- **Keep package use ordinary.** Attach repeatedly used packages with separate literal `library(pkg)` lines; use `pkg::fun()` for an occasional call (`readr::read_csv()` if that is the only `readr` use). Never add a generated package-loading loop or automatic installation merely for convenience. Resolve real name conflicts deliberately (e.g., `library(MASS, exclude = "select")` alongside `dplyr`). **Before removing an existing `pkg::`, verify effective function resolution; if uncertain, keep it.**
- **No environment scaffolding by default.** In exploratory scripts and `.qmd`/`.Rmd` setups, omit automatic `install.packages()`, `requireNamespace()` preflights, `.libPaths()` discovery, `renv` activation/restoration, `setwd()`/working-directory guessing, OS/locale probes and generic missing-file/function wrappers unless the user or project's actual execution contract requires them. A brief manual `# install.packages("pkg")` note is optional only when useful for onboarding. Prefer ordinary R errors and debug actual failures with tools; see [setup details](references/research-first-coding-style.md#keep-setup-minimal-and-native).
- **Keep semantics and reported outputs intact.** Treat formulas, estimator arguments, case selection, missing-value handling, joins, factor levels, random seeds, **diagnostic counts, table fields, and result definitions** as analytical decisions. Removing temporary checks must not remove, rename, or replace the substantive statistics they support. Before using a new data-frame field, establish where it is created; never treat a syntax-only pass as evidence of unchanged values.
- **Preserve analytical intermediates.** Data aggregations, joins, derived datasets, diagnostics, and named working objects are inspectable research work products even if no current report table references them. Do not delete them as “unused” while simplifying guards or reorganizing code; ask before removing any substantive computation.

Choose **one primary reference by audience**: for research analyses, explicit tidyverse preferences or `.qmd`/`.Rmd` setup design, use [research-first-coding-style.md](references/research-first-coding-style.md); for student-executed R in scripts or notebooks, use [classroom-r-scripts.md](references/classroom-r-scripts.md). Read both only if student and research code decisions overlap. For actual attachment-order conflicts or namespace edits, consult [package-conflicts.md](references/package-conflicts.md) **before editing**.

## Validation Without Boilerplate

- Inspect available data, objects, and targeted results directly with authorized tools (e.g., an existing R session, `Rscript`, or an R-connected MCP). Establish whether they represent the actual target session/input before drawing conclusions.
- Treat exploratory checks as **agent work**, not additions to the user's `.R`, `.Rmd`, or `.qmd`. **Do not add `stopifnot()` or custom missing-package/file/object checks by default**: `library()`, `pkg::fun()` and normal reads/calls already report many such failures. Inspect and diagnose actual errors with tools instead of embedding `tryCatch()`, `*_safe()` wrappers or hidden diagnostic chunks. **Do not confuse temporary checks with substantive joins, denominators or reported diagnostics.**
- Keep substantive diagnostics when they explain a research choice. Add a **targeted persistent invariant only by exception** when a verified risk could fail *silently* despite native R errors (e.g., an unintended many-to-many join or an unattended irreversible write), and the actual project/user scope calls for such protection. Favor native argument constraints and useful reported checks over `stopifnot()` boilerplate; do not remove existing safeguards blindly.
- Prefer the smallest useful verification: inspect source, parse code, run a local section, compare affected results, or perform a clean execution when necessary and permitted. **For changed diagnostic code, verify field provenance and output invariants; a missing `$column` can yield `NULL` and `sum(NULL, na.rm = TRUE)` silently returns zero.** Respect requests not to run analyses; avoid expensive reruns without a reason.
- Distinguish **source review**, **live-object inspection**, **targeted execution**, **clean-session reproducibility**, and **statistical equivalence**. Never imply a stronger check than was actually done.

For validation examples, data-join exceptions, and optional external guardrails, read [verification-and-guardrails.md](references/verification-and-guardrails.md) when a task involves data integrity, refactoring, execution safety, or claims about unchanged results.

## Editing and Handoff

1. Inspect the relevant code and nearby sections before editing; identify the analytical units and user-modifiable decisions.
2. Make changes locally, without rearchitecting unrelated files or introducing dependencies merely to enforce a preferred style. In `.qmd`/`.Rmd`, preserve frontmatter, prose, existing chunk labels and options, citations, and output behavior while relocating only the requested R calculations. Keep shared setup short; preserve actual environment requirements rather than deleting them under a style rule. Do not wrap document YAML in a Markdown fence or lose chunk identifiers. Document syntax/visibility belongs to the relevant Quarto skill.
3. Verify the smallest affected behavior available under the user's execution constraints; report unverified assumptions and any legitimate risks of intentional repetition.
4. Explain consequential choices briefly, including any change in analytical meaning or any deferred consistency check. If a different, more automated architecture would help, propose it separately instead of imposing it.

## Boundaries

This skill governs **how R analysis code is organized and changed**, not which statistical method is scientifically warranted. For model specification or interpretation, use the relevant statistical domain expertise; for Quarto source/render issues, use publishing expertise; for package API design, use package-development expertise. Those other skills need not be installed for this one to function.
