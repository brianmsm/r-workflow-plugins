# Numerical validation of documented synthetic examples.
# From the repository root:
# Rscript --vanilla plugins/r-applied-analysis/tests/numerical-validation.R plugins/r-applied-analysis
# This developer-only runner reads only these six plugin references.
# Assertions belong to this test, not to generated researcher analysis scripts.

plugin_root <- commandArgs(trailingOnly = TRUE)[1]
if (is.na(plugin_root)) stop("Supply the plugin directory as the only argument.")
reference_paths <- c(
  "skills/r-descriptive-and-comparative-analysis/references/denominators-and-comparisons.md",
  "skills/r-descriptive-and-comparative-analysis/references/correlation-and-rank-methods.md",
  "skills/r-regression-analysis/references/linear-models-and-contrasts.md",
  "skills/r-regression-analysis/references/binary-and-count-models.md",
  "skills/r-survey-analysis/references/design-and-domains.md",
  "skills/r-survey-analysis/references/regression-and-reporting.md"
)
for (path in reference_paths) {
  lines <- readLines(file.path(plugin_root, path), warn = FALSE)
  starts <- which(lines == "```r")
  for (start in starts) {
    end <- which(seq_along(lines) > start & lines == "```")[1]
    if (is.na(end)) stop("Unclosed R fence in ", path)
    eval(parse(text = lines[seq.int(start + 1L, end - 1L)]), envir = .GlobalEnv)
  }
}
cat("PASS: all documented R fences execute\n")

checks <- 0L
check_equal <- function(label, observed, expected, tolerance = 1e-8) {
  if (!isTRUE(all.equal(unname(observed), unname(expected),
                       tolerance = tolerance, check.attributes = FALSE))) {
    stop(label, ": numerical disagreement")
  }
  checks <<- checks + 1L
  cat("PASS:", label, "\n")
}
check_true <- function(label, value) {
  if (!isTRUE(value)) stop(label)
  checks <<- checks + 1L
  cat("PASS:", label, "\n")
}

# Denominators, independent and paired mean contrasts.
check_equal("eligible, observed and missing denominators",
            as.matrix(score_summary[, c("n_eligible", "n_observed", "n_missing")]),
            matrix(c(6, 6, 5, 5, 1, 1), nrow = 2))
a <- observed_scores$score[observed_scores$group == "A"]
b <- observed_scores$score[observed_scores$group == "B"]
v_a <- var(a) / length(a)
v_b <- var(b) / length(b)
welch_se <- sqrt(v_a + v_b)
welch_df <- (v_a + v_b)^2 / (v_a^2 / (length(a) - 1) + v_b^2 / (length(b) - 1))
check_equal("Welch point, SE and df",
            c(mean_difference, welch_fit$stderr, welch_fit$parameter),
            c(-3.2, welch_se, welch_df))
check_equal("Welch interval", as.numeric(welch_fit$conf.int),
            -3.2 + c(-1, 1) * qt(0.975, welch_df) * welch_se)
pair_differences <- complete_pairs$followup - complete_pairs$baseline
check_equal("paired denominator and mean difference",
            c(pair_counts$n_complete_pairs, paired_fit$estimate), c(6, 11 / 6))
check_equal("paired SE", paired_fit$stderr,
            sd(pair_differences) / sqrt(length(pair_differences)))

# Categorical effects and independent calculations of the test statistics.
expected_cells <- outer(rowSums(response_counts), colSums(response_counts)) /
  sum(response_counts)
check_equal("Pearson contingency statistic", categorical_fit$statistic,
            sum((response_counts - expected_cells)^2 / expected_cells))
check_equal("two proportions and their direction", proportion_fit$estimate, c(0.36, 0.60))
hyper_prob <- dhyper(0:48, 48, 52, 50)
observed_prob <- dhyper(18, 48, 52, 50)
check_equal("Fisher two-sided fixed-margin probability", fisher_fit$p.value,
            sum(hyper_prob[hyper_prob <= observed_prob * (1 + 1e-7)]))
x_centered <- association_pairs$x - mean(association_pairs$x)
y_centered <- association_pairs$y - mean(association_pairs$y)
r_manual <- sum(x_centered * y_centered) /
  sqrt(sum(x_centered^2) * sum(y_centered^2))
check_equal("Pearson N and coefficient", c(association_n, pearson_fit$estimate), c(9, r_manual))
check_equal("Pearson Fisher-transform interval", as.numeric(pearson_fit$conf.int),
            tanh(atanh(r_manual) + c(-1, 1) * qnorm(0.975) / sqrt(association_n - 3)))
check_equal("Spearman ranks", spearman_fit$estimate,
            cor(rank(association_pairs$x), rank(association_pairs$y)))
check_true("native Spearman interval is not fabricated", is.null(spearman_fit$conf.int))
rank_u <- sum(outer(rank_b, rank_a, ">")) + 0.5 * sum(outer(rank_b, rank_a, "=="))
check_equal("Wilcoxon U with ties", rank_fit$statistic, rank_u)

# OLS and explicit HC3 formulas, distinct from the extraction APIs.
X <- model.matrix(linear_fit)
bread <- solve(crossprod(X))
resid_lm <- residuals(linear_fit)
variance_ols <- sum(resid_lm^2) / df.residual(linear_fit) * bread
check_equal("known interaction coefficients", coef(linear_fit), c(40, 3, 4, 1.5))
check_equal("OLS covariance", vcov(linear_fit), variance_ols)
linear_table <- as.data.frame(linear_parameters)
check_equal("OLS extraction coefficients and SE",
            c(linear_table$Coefficient, linear_table$SE),
            c(coef(linear_fit), sqrt(diag(variance_ols))))
check_equal("OLS extraction df and intervals",
            c(linear_table$df_error, linear_table$CI_low, linear_table$CI_high),
            c(rep(df.residual(linear_fit), ncol(X)),
              coef(linear_fit) - qt(0.975, df.residual(linear_fit)) * sqrt(diag(variance_ols)),
              coef(linear_fit) + qt(0.975, df.residual(linear_fit)) * sqrt(diag(variance_ols))))
h <- rowSums((X %*% bread) * X)
hc3_manual <- bread %*% crossprod(X, X * (resid_lm / (1 - h))^2) %*% bread
check_equal("HC3 covariance formula", linear_vcov_hc3, hc3_manual)
hc3_table <- as.data.frame(linear_hc3_parameters)
check_equal("HC3 reporting keeps coefficients and changes SE",
            c(hc3_table$Coefficient, hc3_table$SE),
            c(coef(linear_fit), sqrt(diag(hc3_manual))))
check_equal("HC3 native versus extracted p-values",
            hc3_table$p, linear_hc3_native[, 4])
check_equal("R-squared and RMSE definitions",
            c(linear_performance$R2, linear_performance$RMSE),
            c(1 - sum(resid_lm^2) / sum((linear_sample$score - mean(linear_sample$score))^2),
              sqrt(mean(resid_lm^2))))
L <- cbind(0, 0, 1, c(-1, 0, 1))
contrast_se <- sqrt(diag(L %*% hc3_manual %*% t(L)))
check_equal("specified interaction contrasts and SE",
            c(linear_contrast_table$estimate, linear_contrast_table$SE),
            c(2.5, 4, 5.5, contrast_se))
check_equal("one-family simultaneous contrast intervals",
            c(linear_contrast_table$lower.CL, linear_contrast_table$upper.CL),
            c(c(2.5, 4, 5.5) - qt(1 - 0.05 / 6, 36) * contrast_se,
              c(2.5, 4, 5.5) + qt(1 - 0.05 / 6, 36) * contrast_se))

# Binary coefficient, odds, delta SE and probability contrast are different scales.
check_equal("known binary coefficients", coef(binary_fit), c(log(0.25), log(8 / 3), 0))
X_bin <- model.matrix(binary_fit)
p_bin <- fitted(binary_fit)
V_bin <- solve(crossprod(X_bin, X_bin * p_bin * (1 - p_bin)))
# glm stores QR covariance from the last IRLS working weights; allow its convergence tolerance.
check_equal("binomial information covariance", vcov(binary_fit), V_bin, tolerance = 1e-6)
# Reporting must reproduce the actual fitted object, not recompute a new covariance.
V_bin <- vcov(binary_fit)
binary_table <- as.data.frame(binary_parameters)
check_equal("odds ratios and transformed SE",
            c(binary_table$Coefficient, binary_table$SE),
            c(exp(coef(binary_fit)), exp(coef(binary_fit)) * sqrt(diag(V_bin))))
check_equal("explicit normal intervals on odds scale",
            c(binary_table$CI_low, binary_table$CI_high),
            c(exp(coef(binary_fit) - qnorm(0.975) * sqrt(diag(V_bin))),
              exp(coef(binary_fit) + qnorm(0.975) * sqrt(diag(V_bin)))))
check_equal("probabilities at x zero", binary_predictions$probability, c(0.2, 0.4))
risk_gradient <- 0.4 * 0.6 * c(1, 1, 0) - 0.2 * 0.8 * c(1, 0, 0)
risk_se <- sqrt(drop(t(risk_gradient) %*% V_bin %*% risk_gradient))
check_equal("probability contrast delta variance",
            c(binary_risk_table$estimate, binary_risk_table$SE), c(0.2, risk_se))
check_equal("probability contrast interval",
            c(binary_risk_table$asymp.LCL, binary_risk_table$asymp.UCL),
            0.2 + c(-1, 1) * qnorm(0.975) * risk_se)

# Poisson rates, offsets and quasi-likelihood variance.
count_rates <- count_data |>
  group_by(group) |>
  summarise(rate = sum(events) / sum(exposure), .groups = "drop")
check_equal("Poisson coefficients from count/exposure totals", coef(count_fit),
            c(log(count_rates$rate[1]), log(count_rates$rate[2] / count_rates$rate[1])))
check_equal("exposure-one predictions", predict(count_fit, count_newdata, type = "response"),
            count_rates$rate)
exposure_four <- count_newdata |> mutate(exposure = 4)
check_equal("exposure scales expected counts", predict(count_fit, exposure_four, type = "response"),
            4 * count_rates$rate)
X_count <- model.matrix(count_fit)
V_count <- solve(crossprod(X_count, X_count * fitted(count_fit)))
check_equal("Poisson information covariance", vcov(count_fit), V_count, tolerance = 1e-4)
# Validate the stored last-iteration covariance separately at the stricter reporting tolerance.
count_working_covariance <- solve(crossprod(X_count, X_count * weights(count_fit, type = "working")))
check_equal("Poisson native working-weight covariance", vcov(count_fit), count_working_covariance)
V_count <- vcov(count_fit)
count_table <- as.data.frame(count_parameters)
check_equal("Poisson transformed uncertainty",
            c(count_table$Coefficient, count_table$SE),
            c(exp(coef(count_fit)), exp(coef(count_fit)) * sqrt(diag(V_count))))
quasi_phi_final <- sum(residuals(count_quasi_fit, type = "pearson")^2) / df.residual(count_quasi_fit)
quasi_phi <- sum(count_quasi_fit$weights * count_quasi_fit$residuals^2) / df.residual(count_quasi_fit)
check_equal("quasi-Poisson dispersion and IRLS tolerance", quasi_phi, quasi_phi_final, tolerance = 1e-4)
check_equal("quasi-Poisson same mean and scaled covariance",
            c(coef(count_quasi_fit), vcov(count_quasi_fit)),
            c(coef(count_fit),
              solve(crossprod(X_count, X_count * weights(count_quasi_fit, type = "working"))) * quasi_phi))
quasi_table <- as.data.frame(count_quasi_parameters)
check_equal("quasi-Poisson residual-df intervals",
            c(quasi_table$CI_low, quasi_table$CI_high),
            c(exp(coef(count_quasi_fit) - qt(0.975, df.residual(count_quasi_fit)) *
                    sqrt(diag(vcov(count_quasi_fit)))),
              exp(coef(count_quasi_fit) + qt(0.975, df.residual(count_quasi_fit)) *
                    sqrt(diag(vcov(count_quasi_fit))))))
check_true("quasi-likelihood has no ordinary AIC", is.na(AIC(count_quasi_fit)))

# Survey domain Taylor variance retains zero-domain PSUs.
domain_weight <- sum(survey_data$weight * survey_data$domain)
domain_ratio <- sum(survey_data$weight * survey_data$domain * survey_data$score) / domain_weight
psu_influence <- survey_data |>
  mutate(u = weight * as.numeric(domain) * (score - domain_ratio) / domain_weight) |>
  group_by(stratum, psu) |>
  summarise(u = sum(u), .groups = "drop")
stratum_variances <- psu_influence |>
  group_by(stratum) |>
  summarise(variance = n() / (n() - 1) * sum((u - mean(u))^2), .groups = "drop")
domain_variance <- sum(stratum_variances$variance)
check_equal("domain mean and Taylor variance",
            c(coef(domain_mean), vcov(domain_mean)), c(domain_ratio, domain_variance))
check_equal("known domain counts",
            unlist(domain_counts), c(12, 10, 2, 30, 25))
check_equal("domain t interval with stated df", as.numeric(domain_mean_ci),
            domain_ratio + c(-1, 1) * qt(0.975, survey::degf(domain_design)) * sqrt(domain_variance))
check_equal("domain population totals", coef(domain_totals), c(30, 10, 25))
observed_domain <- survey_data |> filter(domain, !is.na(score_observed))
check_equal("observed-outcome weighted denominator",
            coef(domain_observed_mean),
            sum(observed_domain$weight * observed_domain$score_observed) /
              sum(observed_domain$weight))
check_equal("domain proportion", as.numeric(coef(domain_proportion)), 1 / 3)
# Rebuild only as an intentional negative control.
filtered_design <- survey::svydesign(
  ids = ~psu, strata = ~stratum, weights = ~weight,
  data = filter(survey_data, domain), nest = TRUE
)
filtered_mean <- survey::svymean(~score, filtered_design)
check_equal("filtered negative control preserves only the point", coef(filtered_mean), coef(domain_mean))
check_true("filtered rebuilding changes domain variance",
           abs(drop(vcov(filtered_mean) - vcov(domain_mean))) > 1e-4)

# Direct replicate formula, with the documented mse=TRUE centering.
rep_weights <- weights(domain_replicates, type = "analysis")
rep_values <- colSums(rep_weights * domain_replicates$variables$score) / colSums(rep_weights)
rep_variance <- domain_replicates$scale *
  sum(domain_replicates$rscales * (rep_values - domain_ratio)^2)
check_equal("JKn point and replicate variance",
            c(coef(domain_replicate_mean), vcov(domain_replicate_mean)),
            c(domain_ratio, rep_variance))
check_true("nonlinear JKn and Taylor variance need not match",
           abs(rep_variance - domain_variance) > 1e-4)

# Design-based linear covariance calculated from PSU score totals.
X_svy <- model.matrix(survey_linear_fit)
w_svy <- survey_data$weight
bread_svy <- solve(crossprod(X_svy, X_svy * w_svy))
score_svy <- X_svy * (w_svy * residuals(survey_linear_fit, type = "response"))
cluster_scores <- rowsum(score_svy, interaction(survey_data$stratum, survey_data$psu))
cluster_strata <- sub("\\..*$", "", rownames(cluster_scores))
meat_svy <- matrix(0, ncol(X_svy), ncol(X_svy))
for (stratum in unique(cluster_strata)) {
  scores_h <- cluster_scores[cluster_strata == stratum, , drop = FALSE]
  centered_h <- sweep(scores_h, 2, colMeans(scores_h))
  meat_svy <- meat_svy + nrow(scores_h) / (nrow(scores_h) - 1) * crossprod(centered_h)
}
V_svy <- bread_svy %*% meat_svy %*% bread_svy
check_equal("survey linear PSU covariance", vcov(survey_linear_fit), V_svy)
survey_table <- as.data.frame(survey_linear_parameters)
check_equal("survey linear extractor estimate SE df",
            c(survey_table$Coefficient, survey_table$SE, survey_table$df_error),
            c(coef(survey_linear_fit), sqrt(diag(V_svy)), rep(5, 2)))
check_equal("survey linear extraction CI and p",
            c(survey_table$CI_low, survey_table$CI_high, survey_table$p),
            c(survey_linear_ci[, 1], survey_linear_ci[, 2],
              coef(summary(survey_linear_fit))[, 4]))
naive_fit <- stats::lm(score ~ x, data = survey_data, weights = weight)
check_equal("weighted lm can agree in coefficients", coef(naive_fit), coef(survey_linear_fit))
check_true("weighted lm does not reproduce design SE or df",
           abs(vcov(naive_fit)[2, 2] - V_svy[2, 2]) > 1e-4 &&
             df.residual(naive_fit) != df.residual(survey_linear_fit))
survey_bin_table <- as.data.frame(survey_binary_parameters)
check_equal("survey binary extractor odds and CI",
            c(survey_bin_table$Coefficient, survey_bin_table$CI_low, survey_bin_table$CI_high),
            c(survey_binary_odds[, 1], survey_binary_odds[, 2], survey_binary_odds[, 3]))
check_equal("survey binary extractor transformed SE df and p",
            c(survey_bin_table$SE, survey_bin_table$df_error, survey_bin_table$p),
            c(exp(coef(survey_binary_fit)) * sqrt(diag(vcov(survey_binary_fit))),
              rep(df.residual(survey_binary_fit), 2), coef(summary(survey_binary_fit))[, 4]))

# Check plot data construction; this is not rendered appearance/host validation.
for (plot in list(distribution_plot, association_plot, residual_plot, contrast_plot, probability_plot)) {
  check_true("ggplot layers build", length(ggplot2::ggplot_build(plot)$data) > 0)
}
cat("\n", checks, "substantive numerical/plot checks passed.\n")
print(c(
  welch_difference = mean_difference,
  welch_se = welch_fit$stderr,
  logistic_or = exp(coef(binary_fit)[2]),
  probability_difference = binary_risk_table$estimate,
  domain_mean = coef(domain_mean),
  domain_se = survey::SE(domain_mean),
  domain_jkn_se = survey::SE(domain_replicate_mean),
  survey_slope_se = sqrt(V_svy[2, 2]),
  naive_weighted_slope_se = sqrt(vcov(naive_fit)[2, 2])
))
