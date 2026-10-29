# Ordinal EFA with lavaan WLSMV

Use for a measurement-only exploratory factor model of ordered responses. This is supported EFA, not a claim of support for ESEM with structural regressions.

## Measurement and estimator choices

An ordinal model treats categories as thresholds on underlying responses. Polychoric correlations rely on a latent response distribution; check category frequencies, empty bivariate cells and sample coverage. Avoid choosing Pearson versus ordinal treatment solely from the number of categories.

With `ordered = TRUE, estimator = "WLSMV"`, lavaan estimates parameters by DWLS and uses adjusted SEs and a mean/variance-adjusted test. This is more than fitting a polychoric matrix with ordinary ML or MINRES. The input below contains only the intended item columns. An ID or continuous covariate must not be included in that shortcut.

Oblimin is justified here because the domains may correlate. The version-tested rotation-list syntax exposes the oblique assumption and starts. A fixed seed supports replay of stochastic starts; plausible alternative solutions still require inspection. The default nonnegative-variance bounds can hold an estimate at the boundary, so convergence with a zero uniqueness is not automatically reassuring.

## Runnable synthetic example

```r
library(lavaan)
library(dplyr)
library(tidyr)

# Independent synthetic respondents with two correlated domains ----
set.seed(20321)
latent_a <- rnorm(800)
latent_b <- 0.35 * latent_a + sqrt(1 - 0.35^2) * rnorm(800)
ordinal_items <- tibble(
  a1 = 0.8 * latent_a + 0.6 * rnorm(800),
  a2 = 0.7 * latent_a + sqrt(0.51) * rnorm(800),
  a3 = 0.9 * latent_a + sqrt(0.19) * rnorm(800),
  a4 = 0.6 * latent_a + 0.8 * rnorm(800),
  b1 = 0.9 * latent_b + sqrt(0.19) * rnorm(800),
  b2 = 0.7 * latent_b + sqrt(0.51) * rnorm(800),
  b3 = 0.8 * latent_b + 0.6 * rnorm(800),
  b4 = 0.6 * latent_b + 0.8 * rnorm(800)
) |>
  mutate(across(everything(), ~ as.integer(cut(
    .x, breaks = c(-Inf, -0.9, -0.1, 0.6, Inf), labels = FALSE
  ))))
ordinal_counts <- ordinal_items |>
  pivot_longer(everything(), names_to = "item", values_to = "category") |>
  count(item, category)
ordinal_counts

# Ordinal retention evidence; resampling preserves marginal categories ----
set.seed(20322)
parallel_ordinal <- psych::fa.parallel(
  ordinal_items, cor = "poly", fa = "fa", fm = "minres",
  n.iter = 50, quant = 0.95, sim = FALSE, plot = FALSE
)
parallel_ordinal$nfact

# Compare plausible counts descriptively with the native EFA summary ----
set.seed(20323)
efa_ordinal_overview <- lavaan::efa(
  data = ordinal_items, nfactors = 1:2,
  ordered = TRUE, estimator = "WLSMV",
  rotation = list("oblimin", orthogonal = FALSE, rstarts = 30),
  bounds = "pos.var", missing = "listwise"
)
summary(efa_ordinal_overview)

# One selected count as a native lavaan object for explicit inspection ----
set.seed(20323)
efa_ordinal <- lavaan::efa(
  data = ordinal_items, nfactors = 2,
  ordered = TRUE, estimator = "WLSMV",
  rotation = list("oblimin", orthogonal = FALSE, rstarts = 30),
  bounds = "pos.var", missing = "listwise", output = "lavaan"
)
summary(efa_ordinal, fit.measures = TRUE, standardized = TRUE, ci = TRUE)
lavaan::lavInspect(efa_ordinal, "converged")
lavaan::lavInspect(efa_ordinal, "post.check")
lavaan::lavInspect(efa_ordinal, "theta")
lavaan::lavInspect(efa_ordinal, "cor.lv")
efa_ordinal_parameters <- lavaan::standardizedSolution(efa_ordinal)
efa_ordinal_parameters
efa_ordinal_scaled <- lavaan::fitMeasures(
  efa_ordinal,
  c("chisq.scaled", "df.scaled", "pvalue.scaled",
    "cfi.scaled", "tli.scaled", "rmsea.scaled",
    "rmsea.ci.lower.scaled", "rmsea.ci.upper.scaled", "srmr")
)
efa_ordinal_scaled
```

The example is complete data; `missing = "listwise"` makes the choice explicit rather than endorsing deletion for incomplete studies. With missing data, inspect the pattern and used N and choose a supported strategy; ordinal FIML is not supported in this route. Pairwise ordinal handling is a separate choice, not MAR full-information estimation. Do not choose it automatically because FIML is unavailable; incomplete-data EFA estimation/comparison is outside this recipe's executed validation.

The EFA-list overview can show a different fit-index family than the intended report. The explicit native vector above selects **scaled** indices. WLSMV's adjusted inference is distinct from selecting `cfi.robust`, `tli.robust` or `rmsea.robust`; those are separate optional alternatives. SRMR has no parallel `.scaled` variant in this recipe. Do not calculate ordinary likelihood AIC/BIC or subtract adjusted chi-square values for factor-count tests.

## Interpretation and support

Check native convergence/admissibility and residual structure. Compare rotated solutions after acknowledging factor permutations and sign changes; compare implied correlations when testing equivalent representations. Report pattern coefficients, factor correlations and threshold/uniqueness behavior. Investigate substantive reasons for weak factors or cross-loadings before deleting items. Combine category-appropriate parallel analysis, residuals, factor definition and replication; do not import a delta-CFI threshold from invariance testing as a factor-count acceptance rule.

The default return class is `efaList`; `output = "lavaan"` is available for one count. This recipe uses native EFA/lavaan reporting. It does not claim psymetrics support for `efaList` or a broadly validated EFA extractor, even if a converted object has class `lavaan`.

## Sources and checked API

- [lavaan EFA tutorial](https://lavaan.ugent.be/tutorial/efa.html) and [efa manual](https://search.r-project.org/CRAN/refmans/lavaan/html/efa.html): measurement-only EFA, return classes and rotations.
- [lavaan categorical tutorial](https://lavaan.ugent.be/tutorial/cat.html): ordered outcomes, DWLS/adjusted inference and FIML boundary.
- [Flora and Curran (2004)](https://pmc.ncbi.nlm.nih.gov/articles/PMC3153362/): ordinal factor-estimation assumptions and finite-sample behavior.
- [psych parallel analysis](https://personality-project.org/r/psych/help/fa.parallel.html): category-aware retention evidence.

Executed with lavaan 0.7.3 and psych 2.6.9. In lavaan 0.7.3, rotation options in `rotation = list(...)` replace the deprecated `rotation_args` interface; inspect help for the actual installed version instead of changing an established environment. Validation is recorded [here](https://github.com/brianmsm/r-workflow-plugins/blob/r-psychometrics-v0.1.0/plugins/r-psychometrics/docs/validation.md).
