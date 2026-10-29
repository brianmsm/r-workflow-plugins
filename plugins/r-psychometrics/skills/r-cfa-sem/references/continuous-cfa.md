# Continuous CFA

Use for conventional single-group CFA with continuous indicators. State the indicator metric, factor scale, residual assumptions and target sample before fitting.

## Identification, estimation and missingness

A factor's marker loading or variance sets its scale. In the example, `std.lv = FALSE` leaves the usual first-loading marker identification explicit; factor variances are estimated. Do not also constrain extra loadings/variances without a substantive reason. Parameter counting is necessary but not sufficient for identification.

MLR retains ML point estimation with robust uncertainty and an adjusted test. It does not repair dependence, a wrong factor structure or missingness assumptions. For a defensible MCAR/MAR likelihood analysis, `missing = "fiml"` uses observed data under the specified model. Missingness tests cannot establish MAR. Here missingness is generated independently, and there are no observed exogenous covariates. In SEM with `fixed.x = TRUE`, missing covariates may still cause deletion; inspect the actual used cases and decide whether conditional, joint or supported `fiml.x` treatment is warranted. Changing `fixed.x` changes modeling assumptions.

## Runnable synthetic example

The population includes a residual association to make misspecification visible. The two candidate models differ by that one prespecified association, representing shared item wording in this invented example. This is a controlled comparison, not permission to add the largest modification index in real data.

```r
library(lavaan)
library(dplyr)

# Synthetic population and transparent missingness ----
set.seed(20331)
population_cfa <- '
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
continuous_complete <- simulateData(
  population_cfa, sample.nobs = 700, meanstructure = TRUE
) |> as_tibble()
continuous_items <- continuous_complete
continuous_items$a1[sample.int(700, 60)] <- NA_real_
continuous_items$b4[sample.int(700, 45)] <- NA_real_

# Model 1: two correlated factors, independent indicator residuals ----
model_continuous <- '
  domain_a =~ a1 + a2 + a3 + a4
  domain_b =~ b1 + b2 + b3 + b4
'
fit_continuous <- cfa(
  model_continuous, data = continuous_items,
  estimator = "MLR", missing = "fiml",
  std.lv = FALSE, meanstructure = TRUE
)
summary(fit_continuous, fit.measures = TRUE, standardized = TRUE,
        ci = TRUE, rsquare = TRUE)
lavInspect(fit_continuous, "converged")
lavInspect(fit_continuous, "post.check")
lavInspect(fit_continuous, "nobs")
lavInspect(fit_continuous, "coverage")
lavInspect(fit_continuous, "theta")
lavInspect(fit_continuous, "cor.lv")
lavResiduals(fit_continuous, type = "cor.bentler")

# Compact reporting after the native diagnostics ----
fit_continuous_table <- psymetrics::model_fit(fit_continuous)
est_continuous_raw <- psymetrics::model_estimates(
  fit_continuous, standardized = FALSE, ci = 0.95
)
est_continuous_std <- psymetrics::model_estimates(
  fit_continuous, standardized = "std.all", ci = 0.95
)
fit_continuous_table
est_continuous_raw
est_continuous_std

# Model 2: the prespecified residual association ----
model_continuous_residual <- '
  domain_a =~ a1 + a2 + a3 + a4
  domain_b =~ b1 + b2 + b3 + b4
  a2 ~~ a4
'
fit_continuous_residual <- cfa(
  model_continuous_residual, data = continuous_items,
  estimator = "MLR", missing = "fiml",
  std.lv = FALSE, meanstructure = TRUE
)
summary(fit_continuous_residual, fit.measures = TRUE, standardized = TRUE,
        ci = TRUE, rsquare = TRUE)
lavInspect(fit_continuous_residual, "converged")
lavInspect(fit_continuous_residual, "post.check")

# Descriptive comparisons keep both native objects ----
compare_continuous_fit <- psymetrics::compare_model_fit(
  independent = fit_continuous, residual = fit_continuous_residual
)
compare_continuous_estimates <- psymetrics::compare_model_estimates(
  independent = fit_continuous, residual = fit_continuous_residual,
  standardized = "std.all", ci = 0.95
)
compare_continuous_fit
compare_continuous_estimates

# Explicit test of the single nested restriction, with MLR correction ----
continuous_difference <- lavTestLRT(
  fit_continuous_residual, fit_continuous,
  method = "satorra.bentler.2001"
)
continuous_difference
```

Check convergence, admissibility and parameter meaning before using tables or the test. These two models share observed variables, cases, missing-data treatment, estimator and identification; the first is obtained by setting a2 ~~ a4 to zero in the second. Ordinary comparisons between unrelated models, samples or outcomes do not inherit this justification. AIC/BIC can describe compatible likelihood models, but are not nested-model tests.

## Interpretation and reporting

Report the adjusted test, chosen fit-index family, df, sample and residual evidence alongside standardized and original-metric coefficients with uncertainty. A df-zero model provides no global test of its substantive assumptions. The MLR table default is scaled; if an explicit robust fit-index alternative is requested, label it separately as described in [reporting-and-comparisons.md](reporting-and-comparisons.md).

`summary()` is intentionally retained and lavaan is attached so its native summary method is available in the tested runtime. The `standardized = TRUE` summary columns do not mean the adjacent SE/CI columns are standardized. Use `standardizedSolution()` or the verified standardized psymetrics path when standardized inference is required.

Raw off-diagonal `~~` rows are covariances, even when psymetrics labels them “Correlation” in the known [issue #55](https://github.com/brianmsm/psymetrics/issues/55). Native parameter operators and metric take precedence over the display label.

## Sources and checked API

- [lavaan CFA](https://lavaan.ugent.be/tutorial/cfa.html) and [estimators/missingness](https://lavaan.ugent.be/tutorial/est.html): specification, MLR and supported likelihood handling.
- [lavaan Compendium, factor models](https://tdjorgensen.github.io/SEM-in-Ed-compendium/ch14.html): scale identification and measurement assumptions.
- [lavTestLRT documentation](https://search.r-project.org/CRAN/refmans/lavaan/html/lavTestLRT.html): estimator-specific difference tests.
- [psymetrics scope](https://brianmsm.github.io/psymetrics/): CFA/SEM reporting for supported lavaan objects.

Executed with lavaan 0.7.3 and psymetrics 0.5.0. A continuous ML case and native estimate/uncertainty checks are also included in the [validation record](https://github.com/brianmsm/r-workflow-plugins/blob/r-psychometrics-v0.1.0/plugins/r-psychometrics/docs/validation.md).
