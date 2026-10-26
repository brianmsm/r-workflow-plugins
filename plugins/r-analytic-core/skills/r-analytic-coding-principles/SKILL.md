---
name: r-analytic-coding-principles
description: "Use when editing analytical or classroom R code (.R, .Rmd, .qmd) to keep models and figures locally editable, support understandable student scripts, resolve package conflicts, or simplify checks without changing results."
---

# R Analytic Coding Principles

Make R code easy for a researcher to inspect, edit at the point of use, rerun selectively, and reason about. Optimize for **researcher editability and analytical transparency**, not minimum line count or pipeline-style abstraction.

## Choose the Working Style

1. Follow explicit user requirements first, then project conventions and the existing file's style. When none is established and the task is iterative research analysis, default to **research-first, locally editable code**.
2. Identify whether the immediate task is exploratory/interactive analysis, a reproducible analytical handoff, or a genuinely automated/production-oriented workflow. These modes are not mandatory stages of maturity.
3. Respect the existing R idiom (base R, tidyverse, `data.table`, or a justified mix), editor cell conventions, and object naming. Do not convert an entire file to a new style unless requested.
4. Apply these principles to **R computation inside `.R`, `.Rmd`, and `.qmd`**. Leave document syntax, formatting, render behavior, and publication decisions to the relevant authoring or publishing workflow.

## Core Coding Rules

- **Keep analysis local.** Put each independently revised model's **formula or syntax (including a CFA model string)**, estimation, immediate inspection, and case-specific diagnostics or plots in its own section. Keep genuinely shared data preparation upstream and cross-model comparisons downstream. Do not move only the fit while leaving all editable model definitions in an earlier batch.
- **Prefer explicit analytical repetition.** If separate models, contrasts, or figures are likely to be revised independently, keep their native calls and arguments visible even when they repeat substantially. Do not automatically replace them with `map()`, loops, dynamically generated formulas, or custom wrappers merely to reduce duplicated lines.
- **Abstract stable mechanics, not evolving decisions.** A small, well-understood helper may handle truly invariant recoding, extraction, or display logic. Do not hide model formulas, estimators, grouping choices, or figure-specific `ggplot2` options behind convenience functions by default. Systematic simulation or deliberately batch-oriented tasks are valid exceptions.
- **Keep plots editable.** Preserve the figure's `ggplot()`, geoms, scales, `labs()`, and `theme()` near the figure it produces. Reuse a common theme or palette if desired, but keep meaningful per-figure choices inspectable.
- **Resolve package conflicts by actual use.** Use `pkg::fun()` for occasional functions from otherwise unused packages; attach frequently used packages. When two important packages conflict, choose which function should remain unqualified and resolve the collision once at setup if practical (for example, `library(MASS, exclude = "select")` to retain plain `dplyr::select` semantics as `select()`). **Before removing any existing `pkg::`, verify the effective search path and attachment order; if uncertain, keep the qualification.** Do not install an extra conflict-management package by default.
- **Keep semantics and reported outputs intact.** Treat formulas, estimator arguments, case selection, missing-value handling, joins, factor levels, random seeds, **diagnostic counts, table fields, and result definitions** as analytical decisions. Removing temporary checks must not remove, rename, or replace the substantive statistics they support. Before using a new data-frame field, establish where it is created; never treat a syntax-only pass as evidence of unchanged values.
- **Preserve analytical intermediates.** Data aggregations, joins, derived datasets, diagnostics, and named working objects are inspectable research work products even if no current report table references them. Do not delete them as “unused” while simplifying guards or reorganizing code; ask before removing any substantive computation.

Choose **one primary reference by audience**: for research analyses or editable research reports, use [research-first-coding-style.md](references/research-first-coding-style.md); for **student-facing scripts**, use [classroom-r-scripts.md](references/classroom-r-scripts.md). Read both only if the task also edits substantive research code. For attachment order, collisions, or requests to simplify `pkg::`, read [package-conflicts.md](references/package-conflicts.md) **before editing**.

## Validation Without Boilerplate

- Inspect available data, objects, and targeted results directly with authorized tools (e.g., an existing R session, `Rscript`, or an R-connected MCP). Establish whether they represent the actual target session/input before drawing conclusions.
- Treat exploratory checks as **agent work**, not automatic additions to the user's `.R`, `.Rmd`, or `.qmd`. Do not insert speculative `stopifnot()`, `tryCatch()`, `*_safe()` wrappers, or hidden diagnostic chunks for facts already checked and stable in the task context. **Do not confuse checks used only by an agent with calculations that justify a join, document a denominator, or appear in a reported table.**
- Keep substantive diagnostics in the analysis when they explain a research choice, and add persistent guards when a concrete risk warrants them (e.g., changing sources, joins that can silently multiply rows, unattended execution, or irreversible outputs).
- Prefer the smallest useful verification: inspect source, parse code, run a local section, compare affected results, or perform a clean execution when necessary and permitted. **For changed diagnostic code, verify field provenance and output invariants; a missing `$column` can yield `NULL` and `sum(NULL, na.rm = TRUE)` silently returns zero.** Respect requests not to run analyses; avoid expensive reruns without a reason.
- Distinguish **source review**, **live-object inspection**, **targeted execution**, **clean-session reproducibility**, and **statistical equivalence**. Never imply a stronger check than was actually done.

For validation examples, data-join exceptions, and optional external guardrails, read [verification-and-guardrails.md](references/verification-and-guardrails.md) when a task involves data integrity, refactoring, execution safety, or claims about unchanged results.

## Editing and Handoff

1. Inspect the relevant code and nearby sections before editing; identify the analytical units and user-modifiable decisions.
2. Make changes locally, without rearchitecting unrelated files or introducing dependencies merely to enforce a preferred style. In `.qmd`/`.Rmd`, preserve frontmatter, prose, existing chunk labels and options, citations, and output behavior while relocating only the requested R calculations. Do not wrap raw document YAML in a Markdown fence or lose chunk identifiers.
3. Verify the smallest affected behavior available under the user's execution constraints; report unverified assumptions and any legitimate risks of intentional repetition.
4. Explain consequential choices briefly, including any change in analytical meaning or any deferred consistency check. If a different, more automated architecture would help, propose it separately instead of imposing it.

## Boundaries

This skill governs **how R analysis code is organized and changed**, not which statistical method is scientifically warranted. For model specification or interpretation, use the relevant statistical domain expertise; for Quarto source/render issues, use publishing expertise; for package API design, use package-development expertise. Those other skills need not be installed for this one to function.
