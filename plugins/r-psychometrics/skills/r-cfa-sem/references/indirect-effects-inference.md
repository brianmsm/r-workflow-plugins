# Inference for Indirect Effects and Other Defined Parameters

Use with [basic SEM](basic-sem.md) for linear, single-level models. Define each target on its intended scale with `:=` before selecting an interval. The examples use independent, complete rows and the unstandardized model coefficients.

[Delta and Monte Carlo](#delta-and-monte-carlo-intervals) · [Bootstrap and global fit](#ordinary-bootstrap-and-the-global-fit-test) · [Interval selection and audit](#choose-and-audit-the-interval) · [Conditional effects and contrasts](#conditional-indirect-effects-and-contrasts)

## Delta and Monte Carlo intervals

The first-order delta method is the default for `:=` when fitting with conventional or robust coefficient SEs. For `g(a, b) = a*b`, its variance estimate is `b^2 Var(a) + a^2 Var(b) + 2*a*b Cov(a, b)`, evaluated at the fitted coefficients. The covariance comes from the fitted model's `vcov()`, so, for example, MLR uses its robust covariance matrix. The normal-reference interval is symmetric around the fitted product. At `a = b = 0` the gradient vanishes. Assess coverage near this part of the composite null before relying on delta, ordinary bootstrap or Monte Carlo intervals.

A Monte Carlo interval draws the coefficient vector jointly from a multivariate normal distribution centered on the estimates, using their estimated covariance matrix. Evaluate the entire expression in each draw, then take its empirical quantiles. The product distribution can be asymmetric even when the coefficients are approximately normal. This method assumes that the joint normal approximation and fitted covariance are adequate. The simulation uses one model fit. Choose the number of draws for the endpoint precision needed and check stability with another seed or a larger draw count. Increasing draws reduces numerical variation while the sample information and the joint approximation stay the same. Use the same row of draws for every term in a sum or contrast.

The example retains a latent measurement model with positive df so that it can also illustrate global fit tests. The outcome and the predictor are continuous here. The marker loading sets the mediator's metric.

```r
library(lavaan)

set.seed(20354)
n <- 450L
x <- rnorm(n)
middle <- 0.40 * x + 0.7 * (rchisq(n, df = 3) - 3) / sqrt(6)
y <- 0.35 * middle + 0.15 * x + rnorm(n)
dat <- data.frame(
  x, y,
  m1 = middle + 0.65 * rnorm(n),
  m2 = 0.8 * middle + 0.60 * rnorm(n),
  m3 = 1.1 * middle + 0.65 * rnorm(n)
)

model <- '
  middle =~ m1 + m2 + m3
  middle ~ a*x
  y ~ b*middle + direct*x
  indirect := a*b
  total := direct + a*b
'
fit_delta <- sem(model, data = dat, estimator = "MLR", fixed_x = FALSE)
fit_mc <- sem(
  model, data = dat, estimator = "MLR", fixed_x = FALSE,
  se_def = "monte_carlo", monte_carlo = list(R = 20000L, seed = 20355L)
)

subset(parameterEstimates(fit_delta), op == ":=")
subset(parameterEstimates(fit_mc), op == ":=")
```

Check the installed lavaan API before relying on `se_def` and `monte_carlo`. With older lavaan releases, `semTools::monteCarloCI()` can evaluate defined parameters from a fitted object's coefficient estimates and covariance. Native `lavInspect(fit_mc, "mc")` provides the coefficient draws in the checked version.

## Ordinary bootstrap and the global fit test

For a sample of N independent units, each ordinary nonparametric bootstrap replicate draws N rows with replacement, refits the model and recomputes the target. A unit may appear several times or be absent in a replicate. A resampling unit follows the study design. Clustered, stratified, repeated-measures and survey data need a resampling scheme that retains the applicable dependence and design structure. Case resampling needs raw data and the same analysis, coding and missing-data policy in each replicate.

The estimator for coefficients, the method for their SEs, the global fit test and the interval for a defined effect are separate choices. In lavaan 0.7-3, adding `se = "bootstrap"` to the `MLR` or `WLSMV` shortcut produces an error. The following configurations fit the corresponding ML or DWLS objective with bootstrap SEs and an explicitly requested scaled global test.

| Data | Robust reference fit | Fit with ordinary bootstrap SEs |
| --- | --- | --- |
| Continuous | `estimator = "MLR"` | `estimator = "ML", test = "yuan.bentler.mplus", se = "bootstrap"` |
| Ordered endogenous variables | `estimator = "WLSMV"` | `estimator = "DWLS", test = "scaled.shifted", se = "bootstrap"` |

Use `yuan.bentler.mplus` to match the MLR test, since lavaan also provides a distinct `yuan.bentler` variant. Compare the original-data solutions and the actual scaled statistics at positive df under the same modeling options. The scaled tests and coefficients agreed in these examples. Bootstrap SEs replace the robust analytic SEs. For other designs or missing-data settings, inspect warnings and effective options. For example, requesting `scaled.shifted` with continuous ML and FIML switched the checked fit to listwise deletion and warned. Multiple adjusted tests can change the information matrix used for the tests. Inspect `lavInspect(fit, "options")` and `lavInspect(fit, "test")` when reproducing an adjusted result. When `se = "bootstrap"` is combined with `se_def = "monte_carlo"`, the bootstrap supplies the defined-parameter inference even if the effective options still list the requested Monte Carlo setting. Fit separately to compare the two approaches.

```r
set.seed(20356)
fit_boot <- sem(
  model, data = dat, estimator = "ML", fixed_x = FALSE,
  test = "yuan.bentler.mplus", se = "bootstrap", bootstrap = 499L
)

ord <- dat
ordered_names <- c("m1", "m2", "m3", "y")
ord[ordered_names] <- lapply(ord[ordered_names], function(z) {
  ordered(cut(z, breaks = c(-Inf, -0.7, 0, 0.8, Inf), labels = FALSE))
})
fit_ordinal <- sem(
  model, data = ord, ordered = ordered_names, estimator = "WLSMV",
  fixed_x = FALSE, conditional_x = FALSE
)
set.seed(20357)
fit_ordinal_boot <- sem(
  model, data = ord, ordered = ordered_names, estimator = "DWLS",
  fixed_x = FALSE, conditional_x = FALSE, test = "scaled.shifted",
  se = "bootstrap", bootstrap = 99L
)

fit_fields <- c("chisq.scaled", "df.scaled", "pvalue.scaled")
rbind(
  mlr = fitMeasures(fit_delta, fit_fields),
  ml_boot = fitMeasures(fit_boot, fit_fields),
  wlsmv = fitMeasures(fit_ordinal, fit_fields),
  dwls_boot = fitMeasures(fit_ordinal_boot, fit_fields)
)
```

Check convergence and admissibility before interpreting any fit. The ordered outcome uses an underlying continuous response scale. Its indirect effect refers to that scale for the specified ordered model and parameterization. A probability contrast for a category requires an explicit calculation for the covariate profile and thresholds. Treat standardized effects as separate estimands with their own uncertainty on the chosen metric. See [reporting and comparisons](reporting-and-comparisons.md) for standardized interval and extractor behavior.

### Bollen–Stine test of global fit

Bollen–Stine resampling transforms continuous data so the fitted model is the null of the resampling distribution. It estimates a global goodness-of-fit p-value by comparing the original chi-square statistic to the transformed-sample reference distribution. An informative global test requires positive df and addresses model fit overall. Use a separate fit for this test and an ordinary bootstrap fit for effect intervals. In lavaan 0.7-3, requesting `test = "bollen.stine"` and `se = "bootstrap"` in one fit uses Bollen–Stine draws for the SEs too. The example uses complete continuous data, as required by the tested Bollen–Stine implementation.

```r
set.seed(20358)
fit_bollen_stine <- sem(
  model, data = dat, estimator = "ML", fixed_x = FALSE,
  test = "bollen.stine", se = "standard", bootstrap = 99L
)
lavInspect(fit_bollen_stine, "test")$bollen.stine[c(
  "stat", "df", "pvalue", "boot.length"
)]
```

## Choose and audit the interval

For a bootstrap fit, `parameterEstimates()` reports the original-data estimate and uses the requested `boot_ci_type` for the interval. When shown, its z and p columns use a normal reference based on estimate divided by SE. An asymmetric interval can give a different conclusion at the corresponding confidence level. Report the inference from the chosen interval and identify the method.

| `boot_ci_type` | Bootstrap interval |
| --- | --- |
| `"norm"` | Symmetric interval using a bias-adjusted center and the bootstrap SE. For a nonlinear `:=` in lavaan 0.7-3, the bias adjustment evaluates the expression at the mean of the bootstrapped free coefficients and subtracts the original estimate. This can differ from the empirical mean of the transformed draws minus the original estimate. |
| `"basic"` | Reflects the bootstrap quantiles through the full-sample estimate. |
| `"perc"` | Uses quantiles of the bootstrap effect draws directly. |
| `"bca_simple"` | Adjusts the percentile levels for median bias. Its acceleration term is zero. |
| `"bca"` | Adjusts for both bias and acceleration. Availability and requirements depend on the version and design. The checked implementation needs sufficient successful draws relative to sample size and a recoverable resampling design. |

Older lavaan code may use the dotted spellings `boot.ci.type` and `"bca.simple"`. Specify the interval type and level before inspecting results. The table below illustrates how the interval choice can change the endpoints for the same fitted effect.

```r
ci_types <- c("norm", "basic", "perc", "bca_simple", "bca")
ci_comparison <- do.call(rbind, lapply(ci_types, function(method) {
  est <- parameterEstimates(fit_boot, level = 0.95, boot_ci_type = method)
  cbind(method = method, subset(
    est, op == ":=" & lhs == "indirect", select = c(est, se, ci.lower, ci.upper)
  ))
}))
ci_comparison
```

Keep the full-sample product as the point estimate. The mean of the replicate effects and its difference from the point estimate are separate diagnostics. Subtracting this estimated bias from the original estimate would give the explicitly bias-corrected point estimate `2 * original - bootstrap_mean`. Choosing a bias-adjusted interval in lavaan leaves its reported point estimate unchanged. Record the requested count, failed or nonconvergent refits, converged but flagged nonadmissible fits, nonfinite target values and the number contributing to the interval. In the checked version, native unstandardized `parameterEstimates()` drops refits in `error.idx` and can retain finite draws flagged as `nonadmissible`. A high failure rate, frequent inadmissibility, sparse categories or a warning about extreme order statistics calls for diagnosis. If using a custom admissibility rule, predefine and report it, and identify the resulting interval as a custom analysis.

```r
boot_coef <- lavInspect(fit_boot, "boot")
row <- seq_len(nrow(boot_coef))
failed <- row %in% attr(boot_coef, "error.idx")
inadmissible <- row %in% attr(boot_coef, "nonadmissible")
boot_indirect <- boot_coef[, "a"] * boot_coef[, "b"]
finite_effect <- is.finite(boot_indirect)
used <- !failed & finite_effect
audit <- c(
  requested = lavInspect(fit_boot, "options")$bootstrap$R,
  stored = nrow(boot_coef),
  failed = sum(failed),
  nonadmissible_after_convergence = sum(!failed & inadmissible),
  nonfinite_after_convergence = sum(!failed & !finite_effect),
  finite_effect_after_convergence = sum(used),
  finite_admissible_effect = sum(used & !inadmissible)
)

point_indirect <- unname(coef(fit_boot)["a"] * coef(fit_boot)["b"])
bootstrap_mean <- mean(boot_indirect[used])
c(estimate = point_indirect, bootstrap_mean = bootstrap_mean,
  empirical_bias = bootstrap_mean - point_indirect)
audit
```

Use the teaching counts here to run the example quickly. For reporting, select enough usable draws to resolve the tails to the required precision and check the endpoints with a larger count or independent seeds. A 95% percentile interval uses ranks near `0.025 * B` and `0.975 * B` among `B` usable draws. With 99 usable draws, there are only about two or three draws in each tail. Report the CI method, level, draw count, resampling unit and seed where relevant.

## Conditional indirect effects and contrasts

For a continuous moderator `w` on the first leg, with `xw = x * w` and a constant second-leg slope, the conditional indirect effect is `(a0 + aw*w)*b`. Include the interaction and constituent main effects in the moderated equation. Choose meaningful fixed values of `w` in its supported range and describe the original or centered units. The example uses −1, 0 and 1 in the simulated moderator's units. The index `aw*b` expresses the change in the indirect effect per unit increase in the moderator for this linear first-leg interaction.

```r
set.seed(20359)
w <- rnorm(n)
xw <- x * w
m <- 0.4 * x + 0.2 * w + 0.25 * xw + rnorm(n)
outcome <- 0.5 * m + 0.15 * x + 0.1 * w + 0.1 * xw + rnorm(n)
moderation_data <- data.frame(x, w, xw, m, outcome)
moderation_model <- '
  m ~ a0*x + w + aw*xw
  outcome ~ b*m + direct*x + w + xw
  indirect_low := (a0 - aw)*b
  indirect_zero := a0*b
  indirect_high := (a0 + aw)*b
  index_moderated := aw*b
  high_minus_low := indirect_high - indirect_low
'
fit_moderated <- sem(moderation_model, data = moderation_data, estimator = "MLR")
subset(parameterEstimates(fit_moderated), op == ":=")
```

Directly estimate `high_minus_low`. Its variance depends on `Var(high) + Var(low) - 2 Cov(high, low)`. Apply the delta gradient to the full coefficient covariance or evaluate the entire contrast within each Monte Carlo or bootstrap draw. Individual intervals omit the covariance needed for the contrast. When both legs vary linearly with `w`, their product can be quadratic. In that case estimate the conditional product or targeted contrasts at the moderator values of interest. The conditional associations require design and identification assumptions for a causal interpretation.

## Sources and checked API

- [lavaan options, bootstrap, and parameter estimates](https://cran.r-project.org/web/packages/lavaan/refman/lavaan.html)
- [lavaan 0.7-3 implementation of parameter estimates and intervals](https://github.com/cran/lavaan/blob/0.7-3/R/lav_object_methods.R)
- [Preacher and Selig (2012), Monte Carlo confidence intervals for indirect effects](https://doi.org/10.1080/19312458.2012.679848)
- [Bollen and Stine (1992), bootstrapping global goodness-of-fit](https://doi.org/10.1177/0049124192021002004)
- [Preacher, Rucker and Hayes (2007), conditional indirect effects](https://doi.org/10.1080/00273170701341316)
- [semTools Monte Carlo intervals](https://search.r-project.org/CRAN/refmans/semTools/html/monteCarloCI.html)

The synthetic examples are checked against lavaan 0.7-3 by [the inference validation script](../../../tests/indirect-effects-inference.R).
