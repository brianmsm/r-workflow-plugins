# Targeted checks for the reporting reference with lavaan 0.7-3 and psymetrics 0.5.0.
# Run from the repository root:
# Rscript --vanilla plugins/r-psychometrics/tests/reporting-metric-validation.R

expect_near <- function(actual, expected, label, tolerance = 1e-8) {
  if (!isTRUE(all.equal(as.numeric(actual), as.numeric(expected), tolerance = tolerance))) {
    stop(label, ": numerical mismatch")
  }
}

# Verify the report label independently of the fitted estimator and the fit-index family.
set.seed(1773)
factor_score <- rnorm(500)
residual_overlap <- rnorm(500)
continuous_data <- data.frame(
  y1 = factor_score + 0.5 * residual_overlap + rnorm(500, sd = 0.7),
  y2 = 0.85 * factor_score + 0.4 * residual_overlap + rnorm(500, sd = 0.7),
  y3 = 0.90 * factor_score + rnorm(500, sd = 0.7),
  y4 = 0.80 * factor_score + rnorm(500, sd = 0.7)
)
ordinal_data <- as.data.frame(lapply(continuous_data, function(x) {
  cut(x, quantile(x, seq(0, 1, by = 0.25)), include.lowest = TRUE, ordered_result = TRUE)
}))
hybrid_model <- "factor =~ y1 + y2 + y3 + y4"
ml_hybrid <- lavaan::cfa(
  hybrid_model, data = continuous_data, estimator = "ML",
  se = "bootstrap", test = "yuan.bentler.mplus", bootstrap = 20L
)
dwls_hybrid <- lavaan::cfa(
  hybrid_model, data = ordinal_data, ordered = names(ordinal_data), estimator = "DWLS",
  se = "bootstrap", test = "scaled.shifted", bootstrap = 20L
)
check_hybrid <- function(fit, estimator, test) {
  stopifnot(lavaan::lavInspect(fit, "converged"), lavaan::lavInspect(fit, "post.check"))
  options <- lavaan::lavInspect(fit, "options")
  compact <- as.data.frame(psymetrics::model_fit(fit))
  detailed <- as.data.frame(psymetrics::model_fit(fit, test_details = TRUE))
  fields <- c("Chi2", "CFI", "TLI", "RMSEA")
  native_names <- c("chisq.scaled", "cfi.scaled", "tli.scaled", "rmsea.scaled")
  stopifnot(options$estimator == estimator, options$se == "bootstrap",
            test %in% names(lavaan::lavInspect(fit, "test")),
            nrow(compact) == 1L, nrow(detailed) == 1L,
            compact$ESTIMATOR == test,
            detailed$ESTIMATOR == paste0(estimator, "_variant"),
            detailed$TEST == test, detailed$SE == "bootstrap")
  expect_near(unlist(compact[fields]), lavaan::fitMeasures(fit, native_names),
              "compact hybrid report preserves scaled index values")
  expect_near(unlist(detailed[fields]), unlist(compact[fields]),
              "detailed hybrid report preserves compact index values")
}
check_hybrid(ml_hybrid, "ML", "yuan.bentler.mplus")
check_hybrid(dwls_hybrid, "DWLS", "scaled.shifted")
cat("PASS: compact and detailed labels for ML and DWLS hybrid fits\n")

set.seed(1847)
measurement_data <- lavaan::HolzingerSwineford1939
measurement_data$x <- rnorm(nrow(measurement_data), sd = 3)
measurement_data$z <- measurement_data$x + rnorm(nrow(measurement_data), sd = 2)
measurement_model <- '
  visual =~ x1 + x2 + x3
  textual =~ x4 + x5 + x6
  visual ~ x + z
  textual ~ x + z
  x2 ~~ x3
  visual ~~ textual
'
measurement_fit <- lavaan::sem(measurement_model, data = measurement_data)
stopifnot(lavaan::lavInspect(measurement_fit, "converged"),
          lavaan::lavInspect(measurement_fit, "post.check"))

covariances <- function(metric) {
  estimates <- as.data.frame(psymetrics::model_estimates(measurement_fit, standardized = metric))
  pairs <- subset(estimates, Operator == "~~" & To != From,
                  select = c(To, From, Component, Coefficient))
  rownames(pairs) <- paste(pairs$To, pairs$From)
  stopifnot(nrow(pairs) == 3L, all(pairs$Component == "Correlation"))
  pairs
}
raw <- covariances(FALSE)
latent <- covariances("std.lv")
nox <- covariances("std.nox")
full <- covariances("std.all")
matrices <- lavaan::lavInspect(measurement_fit, "est")
observed_pair <- "x2 x3"
latent_pair <- "visual textual"
exogenous_pair <- "x z"
expect_near(latent[observed_pair, "Coefficient"], matrices$theta["x2", "x3"],
            "std.lv preserves the observed residual covariance")
expect_near(latent[latent_pair, "Coefficient"], cov2cor(matrices$psi)["visual", "textual"],
            "std.lv transforms the latent residual covariance")
expect_near(nox[exogenous_pair, "Coefficient"], raw[exogenous_pair, "Coefficient"],
            "std.nox preserves the fixed-exogenous covariance")
expect_near(full[exogenous_pair, "Coefficient"], cor(measurement_data$x, measurement_data$z),
            "std.all reports the fixed-exogenous correlation")
expect_near(nox[observed_pair, "Coefficient"],
            cov2cor(matrices$theta[c("x2", "x3"), c("x2", "x3")])["x2", "x3"],
            "std.nox reports the observed endogenous residual correlation")
cat("PASS: the generic Correlation label spans different verified metrics\n")

set.seed(241)
x <- rnorm(125, sd = 2)
m <- 0.1 * x + rnorm(125, sd = 3)
y <- 0.4 * x + 0.08 * m + rnorm(125, sd = 2.5)
path_data <- data.frame(x, m, y)
path_model <- '
  m ~ a*x
  y ~ b*m + d*x
  indirect := a*b
'
fit_delta <- lavaan::sem(path_model, data = path_data, estimator = "ML")
fit_mc <- lavaan::sem(
  path_model, data = path_data, estimator = "ML",
  se_def = "monte.carlo", monte_carlo = list(R = 1000L, seed = 251L)
)
set.seed(252)
fit_boot <- lavaan::sem(
  path_model, data = path_data, estimator = "ML", se = "bootstrap", bootstrap = 100L
)
for (fit in list(fit_delta, fit_mc, fit_boot)) {
  stopifnot(lavaan::lavInspect(fit, "converged"), lavaan::lavInspect(fit, "post.check"))
}

level <- 0.90
tail_probabilities <- c(0.05, 0.95)
native_intervals <- c("ci.lower", "ci.upper")
raw_delta <- subset(lavaan::parameterEstimates(fit_delta, level = level), op == ":=")
paths <- lavaan::coef(fit_delta)[c("a", "b")]
gradient <- rev(unname(paths))
path_covariance <- lavaan::vcov(fit_delta)[c("a", "b"), c("a", "b")]
delta_se <- sqrt(drop(gradient %*% path_covariance %*% gradient))
expect_near(raw_delta$se, delta_se, "raw first-order delta SE")
expect_near(unlist(raw_delta[native_intervals]),
            prod(paths) + qnorm(tail_probabilities) * delta_se, "raw delta limits")

raw_mc <- subset(lavaan::parameterEstimates(fit_mc, level = level), op == ":=")
mc_draws <- lavaan::lavInspect(fit_mc, "coef.mc")
mc_indirect <- mc_draws[, "a"] * mc_draws[, "b"]
expect_near(raw_mc$se, sd(mc_indirect), "raw Monte Carlo SE from joint draws")
expect_near(unlist(raw_mc[native_intervals]), quantile(mc_indirect, tail_probabilities),
            "raw Monte Carlo limits from joint draws")

std_delta <- subset(lavaan::standardizedSolution(fit_delta, level = level), op == ":=")
std_mc <- subset(lavaan::standardizedSolution(fit_mc, level = level), op == ":=")
var_x <- lavaan::lavInspect(fit_mc, "sampstat")$cov["x", "x"]
var_y_draw <- (mc_draws[, "d"] + mc_indirect)^2 * var_x +
  mc_draws[, "b"]^2 * mc_draws[, "m~~m"] + mc_draws[, "y~~y"]
expect_near(unlist(std_mc[native_intervals]),
            quantile(mc_indirect * sqrt(var_x / var_y_draw), tail_probabilities),
            "standardized Monte Carlo limits scale the product within each draw")
expect_near(unlist(std_mc[c("se", "z", "pvalue")]),
            unlist(std_delta[c("se", "z", "pvalue")]), "standardized Monte Carlo row's delta tests")
stopifnot(max(abs(unlist(std_mc[native_intervals] - std_delta[native_intervals]))) > 1e-5)

report_fields <- c("Coefficient", "SE", "CI_low", "CI_high", "z", "p")
for (fit in list(fit_delta, fit_mc, fit_boot)) {
  for (metric in list(FALSE, "std.all")) {
    reported <- subset(as.data.frame(psymetrics::model_estimates(
      fit, standardized = metric, ci = level,
      component = "defined", boot_ci_type = "basic"
    )), To == "indirect" & Operator == ":=")
    original_metric <- identical(metric, FALSE)
    native <- if (original_metric) {
      lavaan::parameterEstimates(fit, level = level)
    } else {
      lavaan::standardizedSolution(fit, type = metric, level = level)
    }
    native <- subset(native, lhs == "indirect" & op == ":=")
    native_fields <- c(if (original_metric) "est" else "est.std",
                       "se", native_intervals, "z", "pvalue")
    stopifnot(nrow(reported) == 1L, nrow(native) == 1L)
    expect_near(unlist(reported[report_fields]), unlist(native[native_fields]),
                "psymetrics defined row matches the native metric and default interval type")
  }
}

raw_boot <- subset(lavaan::parameterEstimates(fit_boot, level = level), op == ":=")
raw_basic <- subset(lavaan::parameterEstimates(
  fit_boot, level = level, boot_ci_type = "basic"
), op == ":=")
std_boot <- subset(lavaan::standardizedSolution(fit_boot, level = level), op == ":=")
# Fixed-exogenous standardization uses the original X moment with each draw.
boot_paths <- lavaan::lavInspect(fit_boot, "boot")
boot_product <- boot_paths[, "a"] * boot_paths[, "b"]
boot_y_var <- (boot_paths[, "d"] + boot_product)^2 * var_x +
  boot_paths[, "b"]^2 * boot_paths[, "m~~m"] + boot_paths[, "y~~y"]
boot_standardized <- sort(boot_product * sqrt(var_x / boot_y_var))
ranks <- seq_along(boot_standardized) / (length(boot_standardized) + 1L)
fixed_x_limits <- approx(qnorm(ranks), boot_standardized,
                         xout = qnorm(tail_probabilities))$y
expect_near(unlist(std_boot[native_intervals]), fixed_x_limits,
            "native bootstrap standardization retains fixed predictor variance")
std_basic <- subset(lavaan::standardizedSolution(
  fit_boot, level = level, boot_ci_type = "basic"
), op == ":=")
expect_near(unlist(raw_boot[native_intervals]),
            2 * raw_boot$est - rev(unlist(raw_basic[native_intervals])),
            "native raw percentile/basic identity")
expect_near(unlist(std_boot[native_intervals]),
            2 * std_boot$est.std - rev(unlist(std_basic[native_intervals])),
            "native standardized percentile/basic identity")
stopifnot(max(abs(unlist(raw_boot[native_intervals] - raw_basic[native_intervals]))) > 1e-5,
          max(abs(unlist(std_boot[native_intervals] - std_basic[native_intervals]))) > 1e-5)
cat("PASS: raw/standardized defined rows preserve delta, Monte Carlo and bootstrap provenance\n")
