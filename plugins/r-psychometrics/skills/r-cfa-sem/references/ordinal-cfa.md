# Ordered-Item CFA

Use for conventional single-group CFA in which the endogenous indicators are ordered categories. Preserve category meaning, thresholds, factor scaling, parameterization and the analysis sample.

## Decisions before fitting

WLSMV estimates using DWLS, with robust SEs and a mean/variance-adjusted test. It is not ordinary ML on integer codes. Check each category, sparse bivariate tables and the stability of the polychoric information. Declaring `ordered` does not fix an inappropriate latent-response assumption.

A single-group ordinal model fixes latent-response origins/scales for identification. Under delta parameterization, residual variances are derived; theta uses another scale convention. Do not freely estimate thresholds, intercepts, residual variances and latent means together without an identified model. The example explicitly chooses delta and unit factor variances. Equality constraints across groups require a distinct invariance procedure.

Ordinal FIML is not available for this WLSMV route. The complete-data example explicitly uses listwise handling; in incomplete data, justify the chosen strategy and report affected cases. Pairwise handling is available for some ordinal workflows, but is not FIML and does not establish MAR inference. Do not silently impute, collapse categories or switch estimators to make the fit succeed.

## Resolve incomplete ordinal data explicitly

A request for ordinal FIML does not determine a substitute. First inspect item/category missingness, complete-case loss, univariate and pairwise coverage, and any missing exogenous covariates. Relate those patterns to the sampling process and intended population.

| Candidate strategy | Required decision and support boundary |
| --- | --- |
| `missing = "listwise"` | Establish why a complete-case subset supports the target inference; MCAR is a sufficient missingness condition for the usual justification, not a condition established by a small missing percentage. Report retained/excluded N. The executed ordinal examples are complete data. |
| `missing = "pairwise"` | lavaan's ordinal WLS route uses available univariate information for thresholds and available pairs for correlations. Inspect unequal coverage and correlation-matrix stability. This is not FIML or a generic MAR solution. Its incomplete-data estimation/comparison behavior is not validated by this slice. |
| Ordinal imputation or another estimation framework | Specify assumptions, imputation/analysis compatibility and appropriate pooling or inference as a separate workflow. This slice provides no validated MI/latent combination or replacement estimator recipe. |

Keep any proposed incomplete-data fit conditional until that choice is justified; do not present a convenient fallback as resolved. For comparison, verify compatible analysis rows, categories and estimation inputs; separately assess identification and information adequacy within each model. Equal nominal sample sizes alone are insufficient. Missing exogenous covariates can introduce additional deletion depending on the model options. A sensitivity analysis may be needed when reasonable missingness assumptions differ.

## Runnable synthetic example

The population has a known residual association; two otherwise identical candidate models make a legitimate nested comparison possible.

```r
library(lavaan)
library(dplyr)
library(tidyr)

set.seed(20341)
population_ordinal_cfa <- '
  domain_a =~ 0.8*a1 + 0.7*a2 + 0.9*a3 + 0.6*a4
  domain_b =~ 0.9*b1 + 0.7*b2 + 0.8*b3 + 0.6*b4
  domain_a ~~ 1*domain_a
  domain_b ~~ 1*domain_b
  domain_a ~~ 0.35*domain_b
  a1 ~~ 0.36*a1
  a2 ~~ 0.51*a2
  a3 ~~ 0.19*a3
  a4 ~~ 0.64*a4
  b1 ~~ 0.19*b1
  b2 ~~ 0.51*b2
  b3 ~~ 0.36*b3
  b4 ~~ 0.64*b4
  a2 ~~ 0.20*a4
'
ordinal_cfa_items <- simulateData(
  population_ordinal_cfa, sample.nobs = 1000, meanstructure = TRUE
) |>
  as_tibble() |>
  mutate(across(everything(), ~ as.integer(cut(
    .x, breaks = c(-Inf, -0.9, -0.1, 0.6, Inf), labels = FALSE
  ))))
ordinal_cfa_counts <- ordinal_cfa_items |>
  pivot_longer(everything(), names_to = "item", values_to = "category") |>
  count(item, category)
ordinal_cfa_counts

# Model 1: threshold model with two correlated domains ----
model_ordinal <- '
  domain_a =~ a1 + a2 + a3 + a4
  domain_b =~ b1 + b2 + b3 + b4
'
fit_ordinal <- cfa(
  model_ordinal, data = ordinal_cfa_items,
  ordered = c("a1", "a2", "a3", "a4", "b1", "b2", "b3", "b4"),
  estimator = "WLSMV", parameterization = "delta",
  std.lv = TRUE, missing = "listwise"
)
summary(fit_ordinal, fit.measures = TRUE, standardized = TRUE,
        ci = TRUE, rsquare = TRUE)
lavInspect(fit_ordinal, "converged")
lavInspect(fit_ordinal, "post.check")
lavInspect(fit_ordinal, "nobs")
lavInspect(fit_ordinal, "theta")
lavInspect(fit_ordinal, "cor.lv")
lavInspect(fit_ordinal, "th")
lavResiduals(fit_ordinal, type = "cor.bentler")

# Scaled fit is the intentional reporting default ----
ordinal_scaled_native <- fitMeasures(
  fit_ordinal,
  c("chisq.scaled", "df.scaled", "pvalue.scaled",
    "cfi.scaled", "tli.scaled", "rmsea.scaled",
    "rmsea.ci.lower.scaled", "rmsea.ci.upper.scaled", "srmr")
)
ordinal_fit_table <- psymetrics::model_fit(fit_ordinal)
ordinal_raw <- psymetrics::model_estimates(
  fit_ordinal, standardized = FALSE, ci = 0.95
)
ordinal_standardized <- psymetrics::model_estimates(
  fit_ordinal, standardized = "std.all", ci = 0.95
)
ordinal_scaled_native
ordinal_fit_table
ordinal_raw
ordinal_standardized

# Model 2: the declared residual association ----
model_ordinal_residual <- '
  domain_a =~ a1 + a2 + a3 + a4
  domain_b =~ b1 + b2 + b3 + b4
  a2 ~~ a4
'
fit_ordinal_residual <- cfa(
  model_ordinal_residual, data = ordinal_cfa_items,
  ordered = c("a1", "a2", "a3", "a4", "b1", "b2", "b3", "b4"),
  estimator = "WLSMV", parameterization = "delta",
  std.lv = TRUE, missing = "listwise"
)
summary(fit_ordinal_residual, fit.measures = TRUE, standardized = TRUE,
        ci = TRUE, rsquare = TRUE)
lavInspect(fit_ordinal_residual, "converged")
lavInspect(fit_ordinal_residual, "post.check")

# Descriptive comparisons, with the same scaled family ----
compare_ordinal_fit <- psymetrics::compare_model_fit(
  independent = fit_ordinal, residual = fit_ordinal_residual,
  type = "scaled"
)
compare_ordinal_estimates <- psymetrics::compare_model_estimates(
  independent = fit_ordinal, residual = fit_ordinal_residual,
  standardized = "std.all", ci = 0.95
)
compare_ordinal_fit
compare_ordinal_estimates

# Inferential comparison uses the adjusted native procedure ----
ordinal_difference <- lavTestLRT(
  fit_ordinal_residual, fit_ordinal, method = "satorra.2000"
)
ordinal_difference
```

Read the comparison only after both fits are admissible. Here the variables, categories, sample, identification, estimator and parameterization coincide, and one residual covariance is restricted to zero. This example does not validate multigroup invariance or arbitrary comparisons of ordinal models. A difference-test table can display unscaled constituent chi-square values while calculating an adjusted difference; the native method note explains that distinction.

## Scaled versus separately named robust indices

The default report above uses `cfi.scaled`, `tli.scaled`, `rmsea.scaled` and corresponding scaled RMSEA interval endpoints. SRMR is reported on its native definition. These choices coexist with WLSMV's robust SEs and adjusted test.

The optional `cfi.robust`, `tli.robust` and `rmsea.robust` use separate corrections; they need not equal the scaled indices or even be available. Do not relabel one family as the other or replace a failed/NA index with a different family without explanation. Report RMSEA interval level separately from parameter CI level. The tested native RMSEA default is 90%; the parameter examples request 95%.

Neither family supplies a universal model-acceptance threshold. Evaluate category behavior, residual dependence, factor definition, sample information and plausible alternative explanations. WLSMV does not produce ordinary likelihood AIC/BIC for ranking these models.

## Sources and checked API

- [lavaan categorical variables](https://lavaan.ugent.be/tutorial/cat.html) and [options](https://search.r-project.org/CRAN/refmans/lavaan/html/lavOptions.html): ordered estimation, parameterization and missing-data support.
- [Flora and Curran (2004)](https://pmc.ncbi.nlm.nih.gov/articles/PMC3153362/): latent-response assumptions and robust WLS evidence.
- [lavaan fitMeasures](https://search.r-project.org/CRAN/refmans/lavaan/html/fitMeasures.html) and [lavTestLRT](https://search.r-project.org/CRAN/refmans/lavaan/html/lavTestLRT.html): index families and valid difference tests.
- [psymetrics model_fit source](https://github.com/brianmsm/psymetrics/blob/v0.5.0/R/model_fit-lavaan.R): default scaled selection.

Executed with lavaan 0.7.3 and psymetrics 0.5.0. Default, explicit standard/scaled/robust extraction and native uncertainty are checked in the [validation record](../../../docs/validation.md).
