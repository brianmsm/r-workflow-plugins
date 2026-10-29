# Basic Structural and Path Models

Use for conventional single-level observed-path or confirmatory latent-variable SEM. The applied research question determines covariates, temporal ordering and the target association. A path diagram or statistically nonzero indirect effect does not identify a causal mechanism.

## Observed-path example

This synthetic complete-data model is saturated. Its perfect global fit is a consequence of zero df, not support for its causal interpretation. Coefficients are a statistical decomposition on the specified linear scale.

```r
library(lavaan)
library(dplyr)

set.seed(20351)
path_data <- tibble(predictor = rnorm(600)) |>
  mutate(
    mediator = 0.45 * predictor + rnorm(600),
    outcome = 0.55 * mediator + 0.20 * predictor + rnorm(600)
  )

model_path <- '
  mediator ~ a*predictor
  outcome ~ b*mediator + direct*predictor
  indirect := a*b
  total := direct + a*b
'
fit_path <- sem(
  model_path, data = path_data, estimator = "MLR",
  fixed.x = TRUE, meanstructure = TRUE, missing = "fiml"
)
summary(fit_path, fit.measures = TRUE, standardized = TRUE,
        ci = TRUE, rsquare = TRUE)
lavInspect(fit_path, "converged")
lavInspect(fit_path, "post.check")
path_native <- parameterEstimates(fit_path, ci = TRUE, level = 0.95)
path_estimates <- psymetrics::model_estimates(
  fit_path, standardized = FALSE, ci = 0.95
)
path_fit_table <- psymetrics::model_fit(fit_path)
path_native
path_estimates
path_fit_table
```

The `:=` parameters use a first-order delta-method SE and symmetric interval by default in this validated example. The product's sampling distribution can be asymmetric. If the scientific task requires another interval, specify and validate a compatible procedure; for example, an ML bootstrap is a different configuration from MLR and should not be obtained by blindly adding `se = "bootstrap"` to an incompatible estimator. Bootstrap design must respect dependence and record fit failures.

## Confirmatory latent SEM example

The second example treats measurement error in two separately specified factors. It remains a linear single-group model with no cross-loadings or correlated indicator residuals. Marker indicators set the factor scales; structural coefficient units follow those scales. With `std.lv = TRUE` in other structural models, endogenous latent residual variances, not necessarily total variances, can be the scaling quantities.

```r
set.seed(20352)
latent_predictor <- rnorm(750)
latent_middle <- 0.50 * latent_predictor + rnorm(750)
latent_outcome <- 0.40 * latent_middle + 0.25 * latent_predictor + rnorm(750)
latent_data <- tibble(
  predictor = latent_predictor,
  m1 = latent_middle + 0.7 * rnorm(750),
  m2 = 0.8 * latent_middle + 0.8 * rnorm(750),
  m3 = 1.1 * latent_middle + 0.6 * rnorm(750),
  y1 = latent_outcome + 0.7 * rnorm(750),
  y2 = 0.9 * latent_outcome + 0.8 * rnorm(750),
  y3 = 0.8 * latent_outcome + 0.8 * rnorm(750)
)

model_latent_path <- '
  middle =~ m1 + m2 + m3
  result =~ y1 + y2 + y3
  middle ~ a*predictor
  result ~ b*middle + direct*predictor
  indirect := a*b
  total := direct + a*b
'
fit_latent_path <- sem(
  model_latent_path, data = latent_data,
  estimator = "MLR", missing = "fiml",
  std.lv = FALSE, fixed.x = TRUE, meanstructure = TRUE
)
summary(fit_latent_path, fit.measures = TRUE, standardized = TRUE,
        ci = TRUE, rsquare = TRUE)
lavInspect(fit_latent_path, "converged")
lavInspect(fit_latent_path, "post.check")
lavInspect(fit_latent_path, "theta")
lavInspect(fit_latent_path, "cov.lv")
lavResiduals(fit_latent_path, type = "cor.bentler")
latent_path_fit <- psymetrics::model_fit(fit_latent_path)
latent_path_raw <- psymetrics::model_estimates(
  fit_latent_path, standardized = FALSE, ci = 0.95
)
latent_path_standardized <- psymetrics::model_estimates(
  fit_latent_path, standardized = "std.all", ci = 0.95
)
latent_path_fit
latent_path_raw
latent_path_standardized
```

In a real study, defend the measurement specification before interpreting structural relations. Distinguish measurement misspecification from structural misspecification. `fixed.x = TRUE` conditions on the fully observed predictor here; inspect deletion and reconsider modeling assumptions if exogenous values are missing. A cluster ID is not just another covariate that repairs dependent observations.

Raw and standardized structural effects answer different metric questions. Keep each CI on its own metric. Treat `std.nox` separately when observed exogenous variables should retain their units. The two examples use different data/models and are **not** candidates for a nested difference test or AIC ranking against each other.

## Interpretation limits

Causal mediation additionally needs an appropriate design, temporal order and assumptions about confounding, selection and measurement. Cross-sectional associations alone do not supply these. Avoid claiming that a significant a*b explains how an intervention works.

Interaction, nonlinear, categorical-outcome and multilevel indirect effects need their own scale/identification procedures; the linear product and total formulas do not certify those extensions. Factor-score regression is not numerically or inferentially equivalent to the latent model.

## Sources and checked API

- [lavaan mediation](https://lavaan.ugent.be/tutorial/mediation.html): labeled parameters, derived quantities and delta-method inference.
- [lavaan SEM example](https://lavaan.ugent.be/tutorial/sem.html): native measurement/structural model specification.
- [lavaan estimators](https://lavaan.ugent.be/tutorial/est.html): MLR, missingness and bootstrap distinctions.
- [Maxwell and Cole (2007)](https://doi.org/10.1037/1082-989X.12.1.23): bias in cross-sectional analyses of longitudinal mediation.
- [psymetrics parameter reporting](https://brianmsm.github.io/psymetrics/reference/model_estimates.html): supported extraction.

Executed with lavaan 0.7.3 and psymetrics 0.5.0. The [validation record](../../../docs/validation.md) checks observed-path slopes against native linear regressions and the indirect estimate/SE against an explicit delta calculation; it does not validate a causal claim.
