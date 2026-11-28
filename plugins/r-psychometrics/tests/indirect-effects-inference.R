# Run from the repository root:
# Rscript --vanilla plugins/r-psychometrics/tests/indirect-effects-inference.R

args <- commandArgs(trailingOnly = TRUE)
plugin_root <- if (length(args)) args[[1L]] else "plugins/r-psychometrics"
reference <- file.path(
  plugin_root, "skills/r-cfa-sem/references/indirect-effects-inference.md"
)
lines <- readLines(reference, warn = FALSE)
starts <- which(lines == "```r")
ends <- which(lines == "```")
stopifnot(length(starts) > 0L, length(starts) == length(ends), all(starts < ends))
code <- unlist(Map(function(start, end) lines[(start + 1L):(end - 1L)], starts, ends))
suppressPackageStartupMessages(library(lavaan))
invisible(eval(parse(text = code)))

for (fit in list(fit_delta, fit_mc, fit_boot, fit_ordinal, fit_ordinal_boot,
                 fit_bollen_stine, fit_moderated)) {
  stopifnot(lavInspect(fit, "converged"), lavInspect(fit, "post.check"))
}

near <- function(actual, expected, tolerance = 1e-8) {
  isTRUE(all.equal(as.numeric(actual), as.numeric(expected), tolerance = tolerance))
}

indirect_row <- function(fit) {
  subset(parameterEstimates(fit), op == ":=" & lhs == "indirect")
}

bounds <- function(row) unlist(row[c("ci.lower", "ci.upper")], use.names = FALSE)
ci_probability <- c(.025, .975)
ci_normal <- qnorm(ci_probability)

theta <- coef(fit_delta)[c("a", "b")]
V <- vcov(fit_delta)[names(theta), names(theta)]
point <- prod(theta)
variance <- theta[["b"]]^2 * V["a", "a"] + theta[["a"]]^2 * V["b", "b"] +
  2 * prod(theta) * V["a", "b"]
delta <- indirect_row(fit_delta)
stopifnot(near(delta$est, point), near(delta$se, sqrt(variance)),
          near(bounds(delta), point + sqrt(variance) * ci_normal))
cat("PASS: delta product with the robust coefficient covariance and normal limits\n")

draws <- lavInspect(fit_mc, "mc")[, names(theta)]
effects <- draws[, "a"] * draws[, "b"]
mc <- indirect_row(fit_mc)
stopifnot(
  nrow(draws) == 20000L, near(coef(fit_mc), coef(fit_delta)),
  near(mc$est, point), near(mc$se, sd(effects)),
  near(bounds(mc), quantile(effects, ci_probability)),
  max(abs(cov2cor(cov(draws)) - cov2cor(V))) < .03,
  abs(V["a", "b"]) / sqrt(V["a", "a"] * V["b", "b"]) > .03,
  abs(mean(bounds(mc)) - point) > 1e-4
)
cat("PASS: joint Monte Carlo draws preserve dependence and yield asymmetric limits\n")

check_scaled_pair <- function(robust, boot, name, boot_estimator, robust_se) {
  first <- lavInspect(robust, "test")[[name]]
  second <- lavInspect(boot, "test")[[name]]
  boot_options <- lavInspect(boot, "options")
  stopifnot(
    is.list(first), is.list(second),
    first$df > 0, second$df > 0, all(is.finite(unlist(first[c("stat", "df", "pvalue")]))),
    near(coef(robust), coef(boot)),
    near(unlist(first[c("stat", "df", "pvalue", "scaling.factor", "shift.parameter")]),
         unlist(second[c("stat", "df", "pvalue", "scaling.factor", "shift.parameter")])),
    near(first$pvalue, pchisq(first$stat, first$df, lower.tail = FALSE)),
    near(fitMeasures(robust, fit_fields), fitMeasures(boot, fit_fields)),
    identical(lavInspect(robust, "options")$se, robust_se),
    identical(boot_options$estimator, boot_estimator),
    identical(boot_options$se, "bootstrap"),
    abs(indirect_row(robust)$se - indirect_row(boot)$se) > 1e-5
  )
}

check_scaled_pair(fit_delta, fit_boot, "yuan.bentler.mplus", "ML", "robust.huber.white")
check_scaled_pair(fit_ordinal, fit_ordinal_boot, "scaled.shifted", "DWLS", "robust.sem")
cat("PASS: ML/Yuan-Bentler Mplus and DWLS/scaled-shifted parity at positive df\n")

# Independently interpolate the order statistics on the normal probability scale.
bootstrap_percentile <- function(values, probabilities) {
  values <- sort(values)
  positions <- seq_along(values) / (length(values) + 1L)
  approx(x = qnorm(positions), y = values, xout = qnorm(probabilities), rule = 2)$y
}

boot_effect <- boot_indirect[used]
boot_se <- sd(boot_effect) * sqrt((length(boot_effect) - 1L) / length(boot_effect))
norm_center <- 2 * point_indirect - prod(colMeans(boot_coef[used, c("a", "b")]))
percentiles <- bootstrap_percentile(boot_effect, ci_probability)
median_bias <- qnorm(mean(boot_effect < point_indirect))
bias_percentiles <- bootstrap_percentile(
  boot_effect, pnorm(2 * median_bias + ci_normal)
)
expected_ci <- rbind(
  norm_center + boot_se * ci_normal,
  2 * point_indirect - rev(percentiles),
  percentiles,
  bias_percentiles
)
stopifnot(
  identical(ci_comparison$method, ci_types),
  audit[["requested"]] == 499L, audit[["stored"]] == 499L,
  audit[["finite_effect_after_convergence"]] == length(boot_effect),
  near(ci_comparison$est, rep(point_indirect, length(ci_types))),
  near(ci_comparison$se, rep(boot_se, length(ci_types))),
  near(as.matrix(ci_comparison[1:4, c("ci.lower", "ci.upper")]), expected_ci),
  all(is.finite(bounds(ci_comparison[5L, ]))),
  !near(bounds(ci_comparison[5L, ]), bounds(ci_comparison[4L, ])),
  near(bootstrap_mean, mean(boot_effect)),
  abs(bootstrap_mean - point_indirect) > 1e-5,
  abs(bootstrap_mean - prod(colMeans(boot_coef[used, c("a", "b")]))) > 1e-5
)
cat("PASS: bootstrap interval definitions, full BCa availability and original point estimate\n")

expect_error <- function(expr, text) {
  caught <- tryCatch(force(expr), error = identity)
  stopifnot(inherits(caught, "error"), grepl(text, conditionMessage(caught), fixed = TRUE))
}
expect_error(
  sem(model, data = dat, estimator = "MLR", se = "bootstrap"),
  "use ML estimator for bootstrap"
)
expect_error(
  sem(model, data = ord, ordered = ordered_names, estimator = "WLSMV", se = "bootstrap"),
  "use (D)WLS estimator for bootstrap"
)

collect_warnings <- function(expr) {
  messages <- character()
  value <- withCallingHandlers(force(expr), warning = function(w) {
    messages <<- c(messages, conditionMessage(w))
    invokeRestart("muffleWarning")
  })
  list(value = value, warnings = messages)
}

some_missing <- dat
some_missing$y[1:5] <- NA_real_
changed_missing <- collect_warnings(sem(
  model, data = some_missing, estimator = "ML", fixed_x = FALSE,
  missing = "fiml", test = "scaled.shifted"
))
stopifnot(
  any(grepl("missing will be set", changed_missing$warnings, fixed = TRUE)),
  identical(lavInspect(changed_missing$value, "options")$missing, "listwise"),
  lavInspect(changed_missing$value, "nobs") == n - 5L
)

multiple_tests <- collect_warnings(sem(
  model, data = dat, estimator = "ML", fixed_x = FALSE, information = "observed",
  test = c("yuan.bentler.mplus", "satorra.bentler")
))
stopifnot(
  any(grepl("observed_information for ALL test statistics", multiple_tests$warnings, fixed = TRUE)),
  lavInspect(multiple_tests$value, "options")$observed.information[2L] == "h1",
  lavInspect(fit_boot, "options")$observed.information[2L] == "hessian"
)

set.seed(20360)
both <- sem(
  model, data = dat, estimator = "ML", fixed_x = FALSE,
  test = "yuan.bentler.mplus", se = "bootstrap", bootstrap = 79L,
  se_def = "monte_carlo", monte_carlo = list(R = 200L, seed = 20354L)
)
both_draws <- lavInspect(both, "boot")
both_effect <- both_draws[, "a"] * both_draws[, "b"]
stopifnot(
  is.null(lavInspect(both, "mc")), nrow(both_draws) == 79L,
  near(bounds(indirect_row(both)), bootstrap_percentile(both_effect, ci_probability))
)
cat("PASS: shortcuts reject bootstrap, warnings expose changed options, bootstrap takes precedence\n")

# Stress the draw accounting with a smaller weak-indicator fixture.
set.seed(20360)
n_small <- 85L
x_small <- rnorm(n_small)
middle_small <- .6 * x_small + rnorm(n_small)
weak <- data.frame(
  x = x_small,
  m1 = .5 * middle_small + rnorm(n_small),
  m2 = .5 * middle_small + rnorm(n_small),
  m3 = .5 * middle_small + rnorm(n_small),
  y = .4 * middle_small + .15 * x_small + rnorm(n_small)
)
stress <- collect_warnings(sem(
  model, data = weak, estimator = "ML", fixed_x = FALSE,
  se = "bootstrap", bootstrap = 59L
))
stress_draws <- lavInspect(stress$value, "boot")
stress_rows <- seq_len(nrow(stress_draws))
stress_failed <- stress_rows %in% attr(stress_draws, "error.idx")
stress_nonadmissible <- stress_rows %in% attr(stress_draws, "nonadmissible")
stress_effect <- stress_draws[, "a"] * stress_draws[, "b"]
stress_used <- !stress_failed & is.finite(stress_effect)
stopifnot(
  lavInspect(stress$value, "converged"), lavInspect(stress$value, "post.check"),
  nrow(stress_draws) == 59L, any(stress_failed), any(stress_used & stress_nonadmissible),
  any(grepl("failed or did not converge", stress$warnings, fixed = TRUE)),
  any(grepl("nonadmissible solutions", stress$warnings, fixed = TRUE)),
  near(bounds(indirect_row(stress$value)),
       bootstrap_percentile(stress_effect[stress_used], ci_probability)),
  !near(bounds(indirect_row(stress$value)),
        bootstrap_percentile(stress_effect[stress_used & !stress_nonadmissible], ci_probability))
)
cat("PASS: draw flags distinguish errors from converged nonadmissible results\n")
print(c(requested = nrow(stress_draws), failed = sum(stress_failed),
        used = sum(stress_used), used_nonadmissible = sum(stress_used & stress_nonadmissible)))

null_test <- lavInspect(fit_bollen_stine, "test")$bollen.stine
stopifnot(
  null_test$df > 0, null_test$boot.length == 99L,
  near(null_test$pvalue, mean(null_test$boot.T > null_test$stat)),
  near(null_test$stat, fitMeasures(fit_delta, "chisq"))
)
set.seed(20358)
fit_bollen_both <- sem(
  model, data = dat, estimator = "ML", fixed_x = FALSE,
  test = "bollen.stine", se = "bootstrap", bootstrap = 99L
)
bollen_draws <- lavInspect(fit_bollen_both, "boot")
bollen_effect <- bollen_draws[, "a"] * bollen_draws[, "b"]
ordinary_same_seed <- lavBootstrap(
  fit_delta, r = 99L, type = "ordinary", iseed = attr(bollen_draws, "seed")
)
stopifnot(
  near(lavInspect(fit_bollen_both, "test")$bollen.stine$boot.T, null_test$boot.T),
  near(bounds(indirect_row(fit_bollen_both)),
       bootstrap_percentile(bollen_effect, ci_probability)),
  !near(bollen_draws[, "a"], ordinary_same_seed[, "a"])
)
cat("PASS: Bollen-Stine global null and the transformed draws in the combined fit\n")

moderated <- subset(parameterEstimates(fit_moderated), op == ":=")
moderated_theta <- coef(fit_moderated)[c("a0", "aw", "b")]
moderated_V <- vcov(fit_moderated)[names(moderated_theta), names(moderated_theta)]
a0 <- moderated_theta[["a0"]]
aw <- moderated_theta[["aw"]]
b <- moderated_theta[["b"]]
moderator_levels <- c(-1, 0, 1)
conditional <- (a0 + aw * moderator_levels) * b
G <- cbind(b, b * moderator_levels, a0 + aw * moderator_levels)
conditional_V <- G %*% moderated_V %*% t(G)
contrast_se <- sqrt(conditional_V[3, 3] + conditional_V[1, 1] - 2 * conditional_V[1, 3])
stopifnot(
  identical(moderated$lhs,
            c("indirect_low", "indirect_zero", "indirect_high", "index_moderated", "high_minus_low")),
  near(moderated$est, c(conditional, aw * b, 2 * aw * b)),
  near(moderated$se[1:3], sqrt(diag(conditional_V))),
  near(moderated$se[4:5], c(contrast_se / 2, contrast_se)),
  !near(contrast_se, sqrt(conditional_V[3, 3] + conditional_V[1, 1]))
)
cat("PASS: conditional effects, moderated index and contrast covariance\n")
