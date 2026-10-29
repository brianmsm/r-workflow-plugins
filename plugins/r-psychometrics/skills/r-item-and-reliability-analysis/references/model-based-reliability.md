# Model-Based Reliability

Use after a conventional single-group CFA has been substantively justified and found admissible. The supported examples concern a unit-weighted sum of one factor's indicators. Reliability of factor scores, an arbitrary total across distinct domains, hierarchical omega and test-retest stability are different targets.

## Declare the metric and assumptions

For a unidimensional congeneric measurement model, the common variance of the sum is the sum of all elements of Lambda Phi Lambda-transpose. A model-implied denominator also includes residual variances and any modeled residual covariances. Correlated residuals are not automatically reliable trait variance.

`semTools::compRelSEM(..., tau.eq = FALSE)` computes a model-based coefficient. With `obs.var = TRUE`, the denominator uses observed covariance information; `FALSE` uses model-implied covariance information. The choice matters under misspecification. Do not mix standardized loadings with raw residual variances or silently compute a coefficient from a nonadmissible model.

For ordinal indicators, `ord.scale = TRUE` targets the observed category-score composite using the Green-Yang correction. `ord.scale = FALSE` concerns the underlying continuous responses. Those values need not match. The observed ordinal route does not validate arbitrary unequal category weights; the example uses consecutive category scores and equal item weights. The current function does not support a composite mixing continuous and ordinal indicators.

## Runnable synthetic examples

```r
library(lavaan)
library(dplyr)

set.seed(20305)
population_reliability <- '
  trait =~ 0.8*q1 + 0.7*q2 + 0.65*q3 + 0.9*q4 + 0.6*q5 + 0.75*q6
  trait ~~ 1*trait
  q1 ~~ 0.36*q1
  q2 ~~ 0.51*q2
  q3 ~~ 0.5775*q3
  q4 ~~ 0.19*q4
  q5 ~~ 0.64*q5
  q6 ~~ 0.4375*q6
'
reliability_continuous <- simulateData(
  population_reliability, sample.nobs = 650, meanstructure = TRUE
) |> as_tibble()

# Congeneric CFA for the continuous unit-weighted sum ----
model_reliability <- 'trait =~ q1 + q2 + q3 + q4 + q5 + q6'
fit_reliability_continuous <- cfa(
  model_reliability, data = reliability_continuous,
  estimator = "MLR", std.lv = TRUE, missing = "listwise"
)
summary(fit_reliability_continuous, fit.measures = TRUE,
        standardized = TRUE, ci = TRUE)
lavInspect(fit_reliability_continuous, "converged")
lavInspect(fit_reliability_continuous, "post.check")

reliability_observed_denominator <- semTools::compRelSEM(
  fit_reliability_continuous, tau.eq = FALSE, obs.var = TRUE
)
reliability_model_denominator <- semTools::compRelSEM(
  fit_reliability_continuous, tau.eq = FALSE, obs.var = FALSE
)
reliability_observed_denominator
reliability_model_denominator

# Ordered categories, still with the declared unit-weighted sum ----
reliability_ordinal <- reliability_continuous |>
  mutate(across(everything(), ~ as.integer(cut(
    .x, breaks = c(-Inf, -1, -0.2, 0.7, Inf), labels = FALSE
  ))))

model_reliability_ordinal <- 'trait =~ q1 + q2 + q3 + q4 + q5 + q6'
fit_reliability_ordinal <- cfa(
  model_reliability_ordinal, data = reliability_ordinal,
  ordered = names(reliability_ordinal),
  estimator = "WLSMV", parameterization = "delta",
  std.lv = TRUE, missing = "listwise"
)
summary(fit_reliability_ordinal, fit.measures = TRUE,
        standardized = TRUE, ci = TRUE)
lavInspect(fit_reliability_ordinal, "converged")
lavInspect(fit_reliability_ordinal, "post.check")

reliability_ordinal_score <- semTools::compRelSEM(
  fit_reliability_ordinal, tau.eq = FALSE, obs.var = TRUE, ord.scale = TRUE
)
reliability_latent_response <- semTools::compRelSEM(
  fit_reliability_ordinal, tau.eq = FALSE, obs.var = TRUE, ord.scale = FALSE
)
reliability_ordinal_score
reliability_latent_response

# Explicit scaled fit selection for the ordinal measurement model ----
fitMeasures(fit_reliability_ordinal,
            c("cfi.scaled", "tli.scaled", "rmsea.scaled", "srmr"))
```

The example reports point estimates. `compRelSEM()` does not automatically provide confidence intervals. A bootstrap or other validated interval procedure must refit the measurement model, respect the sampling unit and account for failed/nonadmissible resamples; it is not supplied by treating alpha's interval as an omega interval. Point estimates should be labeled as such.

For multiple domains, report subscale-specific coefficients when those are the intended scores. A total-score coefficient needs its own substantive interpretation and composite definition. A high coefficient cannot resolve a misspecified factor model or justify causal use of a score.

## Sources and checked API

- [semTools compRelSEM](https://rdrr.io/cran/semTools/man/compRelSEM.html): coefficient targets, denominator choice, ordinal-scale correction and supported model classes.
- [Green and Yang (2009), Reliability of summed item scores using structural equation modeling](https://doi.org/10.1007/s11336-008-9099-3): observed ordinal score reliability.
- [McNeish (2018)](https://doi.org/10.1037/met0000144): model assumptions and reliability alternatives.
- [lavaan categorical estimation](https://lavaan.ugent.be/tutorial/cat.html): the ordinal measurement model.

Executed with semTools 0.5.10 and lavaan 0.7.3. The [validation record](https://github.com/brianmsm/r-workflow-plugins/blob/r-psychometrics-v0.1.0/plugins/r-psychometrics/docs/validation.md) separates direct covariance-formula checks from the ordinal correction's API execution.
