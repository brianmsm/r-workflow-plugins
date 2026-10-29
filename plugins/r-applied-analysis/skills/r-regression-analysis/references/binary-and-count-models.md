# Binary and count models

Read for ordinary independent-observation binary logit or Poisson models. Validate outcome coding and the response process before fitting. This reference does not certify ordinal, multinomial, negative-binomial, zero-inflated, hurdle or survey models.

## Binary logistic regression

For a 0/1 outcome, 1 is the modeled event. A factor outcome's first level represents failure in native binomial GLMs; make this choice explicit. Check events/non-events, sample selection, separation, convergence, functional form on the link scale and influential observations. A finite output table alone does not rule out separation. Penalized separation remedies require a separately justified estimator.

The synthetic data contain 200 independent-observation records: observed event proportions are 0.20 and 0.40, balanced over `x`. The fitted coefficient is a conditional log odds ratio; exponentiation is an odds ratio, not a risk ratio.

```r
library(dplyr)
library(ggplot2)

binary_data <- tidyr::expand_grid(
  group = factor(c("Control", "Program"), levels = c("Control", "Program")),
  x = c(-1, 1), row = 1:50
) |>
  mutate(event = as.integer(row <= if_else(group == "Control", 10, 20)))

binary_counts <- binary_data |>
  group_by(group) |>
  summarise(n = n(), events = sum(event), nonevents = sum(1 - event), .groups = "drop")

binary_fit <- stats::glm(
  event ~ group + x, data = binary_data,
  family = binomial(link = "logit"), na.action = na.exclude
)
summary(binary_fit)
binary_counts
stats::nobs(binary_fit)
binary_fit$converged

binary_parameters <- parameters::model_parameters(
  binary_fit, exponentiate = TRUE, standardize = NULL,
  ci_method = "normal", ci = 0.95
)
binary_parameters

binary_newdata <- tibble::tibble(
  group = factor(c("Control", "Program"), levels = levels(binary_data$group)),
  x = 0
)
binary_link <- predict(
  binary_fit, newdata = binary_newdata, type = "link", se.fit = TRUE
)
binary_predictions <- binary_newdata |>
  mutate(
    probability = plogis(binary_link$fit),
    lower = plogis(binary_link$fit - qnorm(0.975) * binary_link$se.fit),
    upper = plogis(binary_link$fit + qnorm(0.975) * binary_link$se.fit)
  )
binary_predictions

probability_plot <- ggplot(binary_predictions, aes(group, probability)) +
  geom_pointrange(aes(ymin = lower, ymax = upper)) +
  coord_cartesian(ylim = c(0, 1)) +
  labs(x = "Group", y = "Event probability", caption = "At x = 0; link-Wald 95% intervals") +
  theme_minimal()
probability_plot
```

These are confidence intervals for modeled probabilities at named covariate values, not individual prediction intervals. Exponentiated `parameters` intervals transform the link-scale endpoints; its exponentiated SE is delta-method transformed and is **not** the log-coefficient SE. Native `confint(glm)` may use profiling, while this example explicitly uses normal/Wald inference. Different interval procedures are not necessarily extraction bugs.

Avoid treating in-sample classification accuracy or a nonsignificant fit test as adequate validation. Calibration and out-of-sample evaluation matter for a predictive task. Independent Bernoulli observations have variance fixed by their mean; an ordinary binomial dispersion p-value is not a general diagnostic for omitted clustering.

### A probability difference, rather than an odds ratio

Back-transforming a logit contrast yields an odds ratio. To compare probabilities at `x = 0`, first regrid the means to the response scale, then form the contrast. Its delta-method normal interval can extend outside the logical range; this is a property to report, not silently clip.

```r
binary_grid <- emmeans::emmeans(binary_fit, ~ group, at = list(x = 0))
binary_risk_grid <- emmeans::regrid(binary_grid, transform = "response")
binary_risk_contrast <- emmeans::contrast(
  binary_risk_grid, method = list("Program - Control" = c(-1, 1))
)
binary_risk_table <- as.data.frame(summary(
  binary_risk_contrast, infer = c(TRUE, TRUE), adjust = "none"
))
binary_risk_table
```

This is one prespecified contrast. It is not automatically a population-average risk difference over a different covariate distribution, nor a causal treatment effect. Non-collapsibility means conditional and marginal odds ratios can differ without confounding.

## Poisson counts and exposure

A count is not a continuous score. For a rate model require positive exposure and retain its units in `offset(log(exposure))`; the offset coefficient is fixed at one. Modeling a precomputed rate with an ordinary Poisson likelihood loses the count/exposure structure.

```r
set.seed(6301)
count_data <- tidyr::expand_grid(
  group = factor(c("Control", "Program"), levels = c("Control", "Program")),
  exposure = c(1, 2, 3), replicate = 1:12
) |>
  mutate(events = rpois(n(), lambda = exposure * if_else(group == "Control", 2, 3)))

count_fit <- stats::glm(
  events ~ group + offset(log(exposure)),
  data = count_data, family = poisson(link = "log"), na.action = na.exclude
)
summary(count_fit)
count_parameters <- parameters::model_parameters(
  count_fit, exponentiate = TRUE, ci_method = "normal", ci = 0.95
)
count_parameters
count_dispersion <- performance::check_overdispersion(count_fit)
count_dispersion

count_newdata <- tibble::tibble(
  group = factor(c("Control", "Program"), levels = levels(count_data$group)),
  exposure = 1
)
predict(count_fit, newdata = count_newdata, type = "response")
```

The group coefficient exponentiates to an incidence-rate ratio; at exposure one the prediction is a count per that exposure unit. Inspect dispersion, residual pattern, zeros and influence against the sampling process. Extra zeros alone do not demonstrate a separate zero-generating mechanism.

If the research analysis chooses a quasi-Poisson variance model, keep it as an explicit alternative. It retains the log mean/offset while estimating a dispersion multiplier; there is no ordinary likelihood AIC to compare with the Poisson fit.

```r
count_quasi_fit <- stats::glm(
  events ~ group + offset(log(exposure)),
  data = count_data, family = quasipoisson(link = "log"), na.action = na.exclude
)
summary(count_quasi_fit)
count_quasi_parameters <- parameters::model_parameters(
  count_quasi_fit, exponentiate = TRUE, ci_method = "residual", ci = 0.95
)
count_quasi_parameters
```

A dispersion test does not automatically choose this alternative, negative binomial or a hurdle model. Preserve theoretical mean/variance assumptions and explain the changed uncertainty procedure.

## Sources and validation

See native [glm](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/glm.html), [families](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/family.html), [predict.glm](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/predict.glm.html), [parameters transformations](https://easystats.github.io/parameters/reference/model_parameters.default.html), [emmeans transformations](https://rvlenth.github.io/emmeans/articles/transformations.html) and [performance dispersion](https://easystats.github.io/performance/reference/check_overdispersion.html).

Checked with R 4.6.1, parameters 0.30.0, performance 0.18.2 and emmeans 2.0.4. [Validation](https://github.com/brianmsm/r-workflow-plugins/blob/r-applied-analysis-v0.1.0/plugins/r-applied-analysis/docs/validation.md) compares known logistic odds/probabilities, native covariance/intervals, Poisson count-to-exposure rates and quasi-Poisson dispersion scaling. These synthetic calculations do not establish adequacy for a real dataset.
