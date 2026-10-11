# Package Use and Search-Path Conflicts in Research R

Read this reference **before changing `library()`, `pkg::fun()`, or function qualification** when a script attaches multiple R packages. The goal is plain, convenient code for the investigator **without silently selecting the wrong function**.

## Choose by Actual Use, Then Resolve Conflicts

| Situation | Preferred starting point | Why |
| --- | --- | --- |
| One or two occasional calls from an otherwise unused package | `pkg::fun()`; no `library(pkg)` | Keeps the source explicit without a new attachment |
| A package supplies functions throughout the analysis | `library(pkg)` at setup; plain calls where resolution is known | Avoids repetitive namespace syntax |
| `MASS` is heavily used but only `dplyr::select()` is needed once | Attach `MASS`; use `dplyr::select()` at that call | Do not attach `dplyr` solely for one call |
| `dplyr` is heavily used but `MASS` is needed only occasionally | Attach `dplyr`; use `MASS::fun()` for those calls | No `MASS` search-path collision is introduced |
| **Both** `dplyr` and `MASS` are used throughout | Attach `dplyr`, then `library(MASS, exclude = "select")`; use `select()` for `dplyr` and `MASS::select()` when the latter is specifically required | One local base-R conflict resolution; no new dependency |
| Multiple recurrent collisions or strict team requirements | Consider base R `conflictRules()` or the opt-in `{conflicted}` package | A project-level policy may be clearer than repeated qualification |

These are **contextual defaults**, not permission to delete an existing package or refactor other files. In an established project, honor deliberate conflict rules and qualify names whose resolution remains uncertain.

## Preferred One-Time Resolution for `dplyr` and `MASS`

```r
library(dplyr)
library(MASS, exclude = "select")

# Uses dplyr::select without repeated namespace qualification.
vars <- select(data_frame, outcome, predictor)

# If the MASS generic is intentionally required, it remains available.
# method <- MASS::select(ridge_fit)
```

Base R's `library()` `exclude` argument omits the named export **from the attached package environment**, not from the package namespace. Therefore `MASS::select()` still works. Other exported `MASS` functions can be called normally without `MASS::` if there is no separate collision.

**Important:** pass `exclude` on the **first attachment** of `MASS` in that R session (or explicitly manage detach/reattach in a controlled context). Repeating `library(MASS, exclude = "select")` after `MASS` is already attached does **not** retroactively remove `select` from the existing attachment. A script designed for clean execution must set its attachment policy in setup.

## Base R Rule for Future Attachments

For a workflow with repeated or indirect `MASS` loading, define the rule **before** attaching it:

```r
conflictRules("MASS", exclude = "select")
library(dplyr)
library(MASS)

vars <- select(data_frame, outcome, predictor)
```

`conflictRules()` sets package-specific default attachment rules in the **current R session**. It does not rewrite the package itself or automatically repair previously attached packages. Do not insert it into the user's global `.Rprofile` unless explicitly authorized.

This is not automatically better than one `library(MASS, exclude = "select")` for a short script: choose the smallest solution fitting actual attachment behavior.

## Optional `{conflicted}` for Multiple Ongoing Conflicts

When `{conflicted}` is already part of the environment or the user requests rigorous conflict management:

```r
library(dplyr)
library(MASS)
library(conflicted)

conflicted::conflicts_prefer(dplyr::select)

vars <- select(data_frame, outcome, predictor)
```

`{conflicted}` introduces an **additional package dependency** and treats other unresolved conflicts as errors. Declare further preferences only if needed and approved; avoid adding it to a simple research script just for one `select` collision. The current API also supports preferring several functions in one `conflicts_prefer(...)` call.

## Avoid Relying Only on Attachment Order

```r
library(MASS)
library(dplyr)
```

This makes `dplyr::select()` the unqualified winner *at that moment*, but later attaching `MASS` may reverse it. Load order alone is fragile in long interactive sessions. Prefer a deliberate exclusion or retained `pkg::fun()` when collision matters.

## Verification When Editing Existing Code

1. Determine which package is central versus occasional, and whether each conflicting function is actually needed.
2. Inspect the **complete** relevant setup and subsequent `library()` calls, including implicit attachments and active session state, rather than inferring resolution from one excerpt.
3. If R execution is allowed, test the effective binding in an equivalent **clean R session** with the project's load order: `find("select")` or `identical(select, dplyr::select)` after attachment; execute a small representative call when a change risks behavior.
4. Keep targeted `pkg::fun()` qualification when a conflict cannot be excluded or the environment is not available. Do not add `library(readxl)` just to replace an isolated `readxl::read_excel()`.
5. Explain only consequential changes: which function wins, how that is guaranteed, and what was actually tested. Never assert collision-free behavior from `Rscript` parsing alone.

## Documentation

- Base R: [Loading/attaching packages (`library`, `conflictRules`, `exclude`)](https://search.r-project.org/R/refmans/base/html/library.html).
- R Core: [Managing Search Path Conflicts](https://developer.r-project.org/Blog/public/2019/03/19/managing-search-path-conflicts/).
- Optional package: [{conflicted} `conflicts_prefer()`](https://conflicted.r-lib.org/reference/conflicts_prefer.html).
