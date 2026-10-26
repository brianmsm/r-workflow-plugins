# Research-First R Coding Style

Use this reference when a researcher needs to **understand, revise, or rerun an individual analytical decision** in `.R`, `.Rmd`, or `.qmd`. These rules concern R code, not how reports should be formatted. Apply explicit user/project style choices before the defaults here.

## Contents

- [Researcher editability](#organize-by-the-researchers-next-edit) · [Minimal setup](#keep-setup-minimal-and-native) · [Intentional repetition](#copy-and-adapt-is-often-intentional)
- [Stable helpers](#helpers-stable-mechanism-versus-research-choice) · [Editable figures](#graphs-are-independent-analytical-displays)
- [Tidyverse preference](#apply-a-tidyverse-preference-consistently) · [Packages](#packages-and-namespace-style) · [Working modes](#modes-and-authoring-surfaces) · [Review](#review-questions)

## Organize by the Researcher's Next Edit

The unit of organization is a meaningful analytical step: a question, a model/specification, a diagnostic, or an independently editable figure. Each model's **formula or syntax + fit + immediate inspection** normally appear together, including an independently revised `lavaan` CFA syntax string; move both, not only the `cfa()` call. In notebooks/reports, its code should be adjacent to the relevant analysis narrative; in scripts, use the project's section/cell conventions.

**Not preferred for iterative work:**

```r
# All model fitting ----
m1 <- glm(y ~ x1, data = dat, family = binomial())
m2 <- glm(y ~ x1 + x2, data = dat, family = binomial())
m3 <- glm(y ~ x1 + x2 + x3, data = dat, family = binomial())

# Model 1 ----
summary(m1)

# Model 2 ----
summary(m2)
```

**Prefer when models are examined independently:**

```r
# Model 1: initial specification ----
m1 <- glm(
  y ~ x1,
  data = dat,
  family = binomial()
)
summary(m1)

# Model 2: additional covariate ----
m2 <- glm(
  y ~ x1 + x2,
  data = dat,
  family = binomial()
)
summary(m2)

# Model comparison ----
AIC(m1, m2)
```

For example, if `modelo_2 <- "F1 =~ ..."` is the CFA specification to be revised with `fit_2 <- cfa(modelo_2, ...)`, keep both in **Model 2**, not all `modelo_*` strings in a distant setup chunk. Shared measurement syntax used identically by several models can remain centralized when that reuse is intentional.

A shared import, cleaning step, or input data object still belongs upstream when the same definition applies to several analyses. A final combined model table should ordinarily use existing model objects rather than refit them. Keep definitions and diagnostics together without forcing a single large chunk; use several adjacent chunks when better for interactive execution.

**Avoid accidental dependencies on interactive history:** write objects in source order so the document/script can be run from the beginning when required. A local, re-runnable section may use shared, clearly defined upstream objects. Do not promise each section runs from an empty session unless it truly does.

## Keep Setup Minimal and Native

For `.R` scripts and `.Rmd`/`.qmd` notebooks, **setup is shared context, not a warehouse for analysis**. A small opening section may attach repeatedly used packages, read common inputs and define a genuinely reusable constant or helper. Put per-section recodings, model definitions/fits, tables, plots and interpretation-adjacent calculations where they are first needed. Split meaningful activities into named chunks; do not create extra chunks solely for formatting or for one trivial line. Keep source order executable without relying on forgotten interactive objects.

Use ordinary, separately written R calls rather than an invented environment/bootstrap framework:

```r
library(dplyr)

# One-time readr use: no library(readr) needed.
datos <- readr::read_csv("datos.csv", show_col_types = FALSE)
```

In ordinary researcher-controlled work, **do not add** package-presence loops, automatic package installers, `renv::restore()`, `.libPaths()` guessing, OS/locale probing, `setwd()`, file-location search helpers, or generic `file.exists()`/`stopifnot()` preflights. `library()`, qualified calls and file reads already supply informative errors for common missing dependencies. Investigate them through the agent's tools rather than embedding a second error framework. A brief commented `# install.packages("pkg")` can help first-time students when appropriate; it must never execute on source/run. Honor an *existing, required* project environment configuration or a deliberately automated handoff instead of deleting it for stylistic reasons.

## Copy-and-Adapt Is Often Intentional

When a researcher may want to change variables, estimator options, factor structure, axes, or visual emphasis separately, repeating native function calls gives them an immediately visible editing surface. Duplication is therefore not automatically a refactoring defect.

Default to explicit, named objects over one opaque list of models created with `lapply()`, `purrr::map()`, a dynamic formula factory, `cfa_safe()`, or `invariance_loop()` solely to eliminate near-identical code. This is particularly important when a model's formula and arguments are part of what the researcher is deciding.

When editing repeated blocks:

- Preserve meaningful differences rather than normalizing everything to one parameter set.
- Use descriptive, stable object and section names; avoid overwriting a previous model's object while comparing alternatives.
- If the same correction must apply to several blocks, inspect **every** affected block; warn about consequential divergence rather than assuming all differences are errors.
- If 30 outputs really are generated systematically and are not individually designed, loops and parameterized generation may be more appropriate. The criterion is **independent future editing**, not a fixed limit on repetition.

## Helpers: Stable Mechanism Versus Research Choice

A helper is usually a good trade when all of the following hold:

1. Its operation is truly stable across uses, not a convenient wrapper for specifications still being investigated.
2. Its interface is short, transparent, and easier to understand than the duplicated implementation.
3. The researcher is unlikely to need different behavior at each call site.
4. It does not conceal consequential model settings, selections, recodings, or display choices.

For example, a known, consistently structured coefficient extractor **for a specified model class** can be useful:

```r
extract_lm_coefs <- function(fit) {
  b <- coef(summary(fit))
  data.frame(
    term = rownames(b),
    estimate = unname(b[, 1]),
    std_error = unname(b[, 2]),
    row.names = NULL
  )
}
```

This example assumes the column structure of `coef(summary(fit))` has been checked for the intended `lm` objects; it is **not** a universal extractor for every model class. For a fixed recoding, confirm the missing-value and level semantics before wrapping it. For a contrast/table extractor, make sure identical extraction really is wanted across analyses.

By contrast, avoid a convenience wrapper that hides `cfa(..., estimator = ..., ordered = ..., std.lv = ...)` when those choices are likely to vary. A researcher should not need to jump to the helper definition to discover what estimator was used.

**Exceptions:** production APIs, scheduled reporting with an explicit stable specification, Monte Carlo replication machinery, and intentionally exhaustive grids may benefit from functions, iteration, or declarative configurations. Follow the primary workflow instead of forcing research-first defaults into those tasks.

## Graphs Are Independent Analytical Displays

If each plot serves a distinct communication task, leave its `ggplot()`, geometries, scales, `labs()`, `theme()`, faceting, and annotation near the plot. A shared theme is compatible with per-plot edits; a wrapper hiding all aesthetics is not the default.

```r
# Figure: raw association ----
fig_raw <- ggplot(dat, aes(x = age, y = score)) +
  geom_point(alpha = 0.5) +
  labs(x = "Age", y = "Score") +
  theme_minimal()

fig_raw

# Figure: group comparison ----
fig_group <- ggplot(dat, aes(x = group, y = score)) +
  geom_boxplot() +
  labs(x = "Group", y = "Score") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 30, hjust = 1))

fig_group
```

Do not replace such displays with `make_plot(kind = ..., ...)` unless the researcher actually wants a consistent, automated family of figures. Distinguish shared constants from independent design decisions.

## Apply a Tidyverse Preference Consistently

When the user or project says **"prefer tidyverse"**, apply that idiom coherently to **new or modified** imports, column operations, joins, reshaping and routine iteration. Do not use `dplyr` only for a few verbs while silently reverting to `read.csv()` or repeated `for` loops elsewhere. This is a preference, not permission to rewrite unrelated established code or alter results.

| Analytical intent | Tidyverse-preferred starting point |
| --- | --- |
| Read a CSV | `readr::read_csv()` if used occasionally; `library(readr)` and `read_csv()` if frequent |
| Transform the same set of columns | `mutate(across(...))` when semantics are genuinely uniform |
| Uniform repeated work over a collection | `purrr::map()` / `map2()` / `imap()` as fits the inputs; `walk()` for side effects |
| Ordinary data selection, joins and reshaping | Existing project conventions using `dplyr` / `tidyr` |

Do not replace independently designed models or editable plots with `map()` solely to reduce repeated calls; uniform batch iteration and distinct analytical decisions are different tasks. Prefer clear, native base R where it is simpler or its behavior is specifically required (e.g., `rowSums()`, `weighted.mean()`, stateful/early-exit loops), and **honor an explicit `for`-loop preference**. If a user expressly asks for consistent/strict tidyverse style, use the applicable tidyverse functions throughout without creating custom adapters for APIs that do not exist. No global "full" or "balanced" toggle is needed: read the actual project preference and explain any material exceptions.

`read.csv()` and `readr::read_csv()` can produce different classes, inferred types, column names and missing-value behavior; a style request does **not** establish that an existing import is equivalent after replacement. Verify affected inputs/results or preserve the existing call when equivalence is uncertain.

## Packages and Namespace Style

Choose `library()` versus `pkg::fun()` from **actual package use**: attach packages used widely with **one explicit `library(package)` call per line**; keep one-off functions qualified instead of loading an entire package. Do not generate package lists plus loops over `library()`/`require()` or insert `requireNamespace()` checks before every attachment. For already attached packages, prefer unqualified calls **only after confirming no package masks the intended function**. This is a heuristic, not a fixed threshold of exactly two calls.

```r
library(dplyr)
library(ggplot2)

summaries <- dat |> group_by(group) |> summarise(n = n(), .groups = "drop")
dat <- readxl::read_excel("input.xlsx")  # One-off, no library(readxl)
```

A project may use `MASS` and `dplyr` extensively and want `select()` to mean **dplyr** without repeated `dplyr::` prefixes. In that case, **select a deliberate conflict-resolution policy**, not merely a different package load order. Base R's `library(MASS, exclude = "select")` and `conflictRules("MASS", exclude = "select")` are available without a new dependency. `MASS::select()` remains available; other non-conflicting `MASS` functions stay usable after attachment. Do not use `conflictRules()` after attachment and expect it to repair the already attached environment.

**Before changing an existing namespace or load order, read [package-conflicts.md](package-conflicts.md)** for options, when each is appropriate, and how to test function resolution. Preserve an intentional `dplyr::select` if you cannot establish the active conflict policy. Do not attach `readxl` or introduce `{conflicted}` automatically for one-off calls.

The choice between base R, tidyverse, `data.table`, and a mix is a **separate axis** from research-first organization. Do not mistake piping syntax for either interactivity or pipeline architecture.

## Modes and Authoring Surfaces

| Situation | Sensible default |
| --- | --- |
| Iterative research/exploration | Local models, editable arguments, transparent objects, short feedback loops |
| Reproducible research handoff | Same local editability plus a dependable source order, identifiable inputs, controlled stochastic execution where material |
| Scheduled/production workflow | Favor tested interfaces, repeatability, and guarded automation where justified by the task |

For `.R`, use existing editor-compatible section markers (`# Model 1 ----`, for example). Use `# %%` only if the workspace already adopts it or the editor requires it. For `.Rmd`/`.qmd`, keep R calculations adjacent to their narrative **without changing frontmatter, prose, labels, chunk options, visibility, or cross-references incidentally**. Preserve existing named result chunks and add or move fit code within/near them in source order. If moving code from a hidden setup chunk would alter output visibility, choose an approach that keeps output behavior or explain the trade-off; formatting/rendering decisions belong to the relevant publishing skill.

## Review Questions

- Can the researcher find and change a particular model's formula/estimator without opening another helper?
- Does a model's specification **and** calculation appear where its results are being evaluated?
- Can each important figure be customized where it is defined?
- Are repeated blocks genuinely independent, and are intentional differences preserved?
- Is any proposed abstraction stable enough to offset the cost of obscuring original function arguments?
- Does the analysis still run in the necessary order, not only in an already-populated interactive session?
- Have original output fields, statistical meanings, Quarto/Rmd identifiers, and package function resolution remained intact?
