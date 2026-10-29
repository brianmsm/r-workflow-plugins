# Linear models, covariance and adjusted contrasts

Read for ordinary independent-observation linear models and interactions. Decide whether the target is a coefficient, a specified covariate contrast or a prediction. An adjusted association is not automatically a causal effect.

## Fit and inspect a visible model

Prespecify the adjustment set from subject knowledge and design. Check functional form instead of categorizing continuous predictors by convenience. Compare models on a common outcome/sample when comparison requires it; a different complete-case set can change the estimand. Keep the number excluded and reasons visible.

The synthetic model has a group-by-baseline interaction. `groupProgram` is the Program-minus-Control difference at baseline zero; the difference changes with baseline. The model is intentionally explicit.

```r
library(dplyr)
library(ggplot2)

linear_data <- tidyr::expand_grid(
  group = factor(c("Control", "Program"), levels = c("Control", "Program")),
  baseline = seq(-2, 2),
  replicate = 1:4
) |>
  mutate(
    score = 40 + 3 * baseline + 4 * (group == "Program") +
      1.5 * baseline * (group == "Program") +
      c(-2, -1, 1, 2)[replicate] * (1 + 0.25 * baseline)
  )

linear_sample <- linear_data |>
  filter(!is.na(score), !is.na(baseline), !is.na(group))
linear_counts <- tibble::tibble(
  n_eligible = nrow(linear_data),
  n_analyzed = nrow(linear_sample),
  n_excluded = nrow(linear_data) - nrow(linear_sample)
)

linear_fit <- stats::lm(
  score ~ baseline * group, data = linear_sample, na.action = na.exclude
)
summary(linear_fit)
linear_counts
stats::nobs(linear_fit)

linear_parameters <- parameters::model_parameters(
  linear_fit, ci = 0.95, ci_method = "residual", standardize = NULL
)
linear_parameters
linear_performance <- performance::model_performance(
  linear_fit, metrics = c("R2", "RMSE")
)
linear_performance

linear_diagnostics <- linear_sample |>
  mutate(
    fitted = fitted(linear_fit),
    residual = residuals(linear_fit),
    leverage = hatvalues(linear_fit),
    cooks_distance = cooks.distance(linear_fit)
  )
residual_plot <- ggplot(linear_diagnostics, aes(fitted, residual, colour = group)) +
  geom_point() +
  geom_hline(yintercept = 0, linetype = 2) +
  labs(x = "Fitted score", y = "Residual", colour = "Group") +
  theme_minimal()
residual_plot
```

Inspect residual pattern, tail shape, leverage and influence, and the provenance of independent sampling. Do not automatically delete influential records. Native `plot(linear_fit)` remains useful; `performance::check_model()` can add class-appropriate views when needed. R-squared and in-sample RMSE do not establish external predictive validity. RMSE is not the residual standard error: their denominators differ.

## A deliberate covariance choice

HC3 is an option for heteroskedasticity with independent units. It changes covariance and associated inference without refitting the mean model. It does not fix omitted nonlinear structure, clustering, selection bias or the sampling design. Small-sample t reference choices remain approximations for robust covariance.

```r
linear_vcov_hc3 <- sandwich::vcovHC(linear_fit, type = "HC3")
linear_hc3_native <- lmtest::coeftest(
  linear_fit, vcov. = linear_vcov_hc3, df = df.residual(linear_fit)
)
linear_hc3_parameters <- parameters::model_parameters(
  linear_fit, vcov = linear_vcov_hc3,
  ci_method = "residual", ci = 0.95, standardize = NULL
)
linear_hc3_native
linear_hc3_parameters
```

Keep this covariance in any downstream contrast that is meant to use it. Cluster-robust procedures need declared independent clusters and suitable finite-cluster inference; probability samples need the survey design. Do not silently replace either with HC3.

## Contrasts at named baseline values

Averaging an interacting effect without specifying the target can conceal the question. Here three prespecified contrasts form one family. The reference grid fixes baseline at -1, 0 and 1; there are no other factors to average over. Both intervals and p-values use a stated Bonferroni adjustment across the three contrasts.

```r
linear_grid <- emmeans::emmeans(
  linear_fit, ~ group | baseline,
  at = list(baseline = c(-1, 0, 1)),
  weights = "equal", vcov. = linear_vcov_hc3
)
linear_contrasts <- emmeans::contrast(
  linear_grid, method = list("Program - Control" = c(-1, 1))
)
linear_contrast_table <- as.data.frame(summary(
  linear_contrasts, by = NULL, infer = c(TRUE, TRUE), adjust = "bonferroni"
))
linear_contrast_table

contrast_plot <- ggplot(linear_contrast_table, aes(baseline, estimate)) +
  geom_hline(yintercept = 0, linetype = 2) +
  geom_pointrange(aes(ymin = lower.CL, ymax = upper.CL)) +
  labs(
    x = "Baseline value", y = "Program minus Control",
    caption = "HC3 covariance; simultaneous 95% Bonferroni intervals"
  ) +
  theme_minimal()
contrast_plot
```

With additional categorical covariates, equal-cell and proportional weighting differ. With continuous covariates, predictions at the mean need not equal averages of predictions. State the grid and target population instead of relying on a package default. `marginaleffects` is an alternative for averages over explicit rows and counterfactual comparisons; its installed class support, averaging weights and covariance propagation must be checked separately.

Standardization is optional. `parameters(..., standardize = "refit")` refits using transformed variables and changes coefficient interpretation. An equivalent reparameterization can preserve fitted means; inspect interactions and factor coding because standardized coefficients are not interchangeable merely because predictions agree. Do not exponentiate an ordinary identity-link coefficient.

## Sources and validation

See [lm](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/lm.html), [parameters ordinary models](https://easystats.github.io/parameters/reference/model_parameters.default.html), [performance](https://easystats.github.io/performance/reference/model_performance.html), [HC covariance](https://sandwich.r-forge.r-project.org/reference/vcovHC.html), [emmeans interactions](https://rvlenth.github.io/emmeans/articles/interactions.html) and [weighting/reference grids](https://rvlenth.github.io/emmeans/articles/basics.html). Harrell's [Regression Modeling Strategies](https://hbiostat.org/rmsc/) supplies methodological context for specification, functional form and model assessment.

Checked examples use R 4.6.1, parameters 0.30.0, performance 0.18.2, sandwich 3.1-3, lmtest 0.9-40 and emmeans 2.0.4. [Validation](../../../docs/validation.md) separates coefficient, covariance, contrast and behavior checks. No universal support claim is made for other classes or marginaleffects.
