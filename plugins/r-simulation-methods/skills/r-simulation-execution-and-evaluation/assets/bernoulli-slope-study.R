# A small ADEMP study: slope estimation and t versus normal intervals.
# Run from the plugin directory; inspect the design before adapting it.
library(SimDesign)
library(dplyr)
library(tidyr)
library(ggplot2)

# Aims / DGP / estimand ----------------------------------------------------
# Evaluate beta1 under random binary-predictor sampling. A constant predictor
# is a legitimate sample with an unidentified slope, not a rejected DGP draw.
Design <- createDesign(
  n = c(20L, 80L),
  prevalence = c(0.05, 0.50)
)
fixed_objects <- list(
  beta0 = 0.5, beta1 = 0.7, sigma = 1,
  confidence = 0.95
)
planned_replications <- 500L
base_seed <- 87105L
condition_seeds <- genSeeds(Design, iseed = base_seed)

Generate <- function(condition, fixed_objects) {
  x <- rbinom(condition$n, size = 1, prob = condition$prevalence)
  y <- fixed_objects$beta0 + fixed_objects$beta1 * x +
    rnorm(condition$n, mean = 0, sd = fixed_objects$sigma)
  tibble(x = x, y = y)
}

# Methods ----------------------------------------------------------------
# Both interval rules use exactly the same fitted slope and simulated data.
# OLS has no iterative convergence flag: full rank is the relevant criterion.
Analyse <- function(condition, dat, fixed_objects) {
  fit <- lm(y ~ x, data = dat)
  full_rank <- fit$rank == 2L
  estimate <- unname(coef(fit)["x"])
  se <- if (full_rank) {
    unname(coef(summary(fit))["x", "Std. Error"])
  } else {
    NA_real_
  }
  estimate_ok <- full_rank && is.finite(estimate)
  se_ok <- estimate_ok && is.finite(se) && se > 0
  probability <- 1 - (1 - fixed_objects$confidence) / 2
  t_critical <- qt(probability, df = df.residual(fit))
  z_critical <- qnorm(probability)
  t_lower <- if (se_ok) estimate - t_critical * se else NA_real_
  t_upper <- if (se_ok) estimate + t_critical * se else NA_real_
  z_lower <- if (se_ok) estimate - z_critical * se else NA_real_
  z_upper <- if (se_ok) estimate + z_critical * se else NA_real_

  c(
    n_exposed = sum(dat$x),
    fit_returned = 1, full_rank = full_rank,
    estimate_ok = estimate_ok, se_ok = se_ok,
    rank_failure = !full_rank,
    nonfinite_estimate = !is.finite(estimate),
    invalid_se = !is.finite(se) || se <= 0,
    estimate = estimate, se = se,
    t_lower = t_lower, t_upper = t_upper,
    z_lower = z_lower, z_upper = z_upper
  )
}

# Performance measures ---------------------------------------------------
# This callback deliberately returns denominators as scientific results.
# Undefined metrics are NA; no mean(..., na.rm=TRUE) can hide failed attempts.
Summarise <- function(condition, results, fixed_objects) {
  n_attempt <- nrow(results)
  estimate_set <- results[, "estimate_ok"] == 1 &
    is.finite(results[, "estimate"])
  se_set <- estimate_set & results[, "se_ok"] == 1 &
    is.finite(results[, "se"]) & results[, "se"] > 0
  t_set <- se_set & is.finite(results[, "t_lower"]) &
    is.finite(results[, "t_upper"]) &
    results[, "t_lower"] <= results[, "t_upper"]
  z_set <- se_set & is.finite(results[, "z_lower"]) &
    is.finite(results[, "z_upper"]) &
    results[, "z_lower"] <= results[, "z_upper"]
  n_est <- sum(estimate_set)
  n_se <- sum(se_set)
  n_ci_t <- sum(t_set)
  n_ci_z <- sum(z_set)
  errors <- results[estimate_set, "estimate"] - fixed_objects$beta1
  bias <- if (n_est > 0) mean(errors) else NA_real_
  rmse <- if (n_est > 0) sqrt(mean(errors^2)) else NA_real_
  bias_mcse <- if (n_est > 1) sd(errors) / sqrt(n_est) else NA_real_
  rmse_mcse <- if (n_est > 1 && is.finite(rmse) && rmse > 0) {
    sd(errors^2) / (2 * rmse * sqrt(n_est))
  } else {
    NA_real_
  }
  covered_t <- t_set & results[, "t_lower"] <= fixed_objects$beta1 &
    results[, "t_upper"] >= fixed_objects$beta1
  covered_z <- z_set & results[, "z_lower"] <= fixed_objects$beta1 &
    results[, "z_upper"] >= fixed_objects$beta1
  coverage_t <- if (n_ci_t > 0) sum(covered_t) / n_ci_t else NA_real_
  coverage_z <- if (n_ci_z > 0) sum(covered_z) / n_ci_z else NA_real_
  joint_t <- sum(covered_t) / n_attempt
  joint_z <- sum(covered_z) / n_attempt
  failure_rate <- sum(results[, "rank_failure"]) / n_attempt
  paired_set <- t_set & z_set
  n_pair <- sum(paired_set)
  coverage_difference <- as.numeric(covered_t[paired_set]) -
    as.numeric(covered_z[paired_set])

  c(
    n_attempt = n_attempt,
    n_fit = sum(results[, "fit_returned"]),
    n_full_rank = sum(results[, "full_rank"]),
    n_rank_failure = sum(results[, "rank_failure"]),
    n_nonfinite_estimate = sum(results[, "nonfinite_estimate"]),
    n_invalid_se = sum(results[, "invalid_se"]),
    n_est = n_est, n_se = n_se, n_ci_t = n_ci_t, n_ci_z = n_ci_z,
    failure_rate = failure_rate,
    failure_mcse = sqrt(failure_rate * (1 - failure_rate) / n_attempt),
    bias = bias, bias_mcse = bias_mcse,
    empirical_se = if (n_est > 1) sd(errors) else NA_real_,
    mean_model_se = if (n_se > 0) mean(results[se_set, "se"]) else NA_real_,
    rmse = rmse, rmse_mcse = rmse_mcse,
    coverage_t = coverage_t,
    coverage_mcse_t = if (n_ci_t > 0) {
      sqrt(coverage_t * (1 - coverage_t) / n_ci_t)
    } else NA_real_,
    coverage_z = coverage_z,
    coverage_mcse_z = if (n_ci_z > 0) {
      sqrt(coverage_z * (1 - coverage_z) / n_ci_z)
    } else NA_real_,
    joint_t = joint_t, joint_mcse_t = sqrt(joint_t * (1 - joint_t) / n_attempt),
    joint_z = joint_z, joint_mcse_z = sqrt(joint_z * (1 - joint_z) / n_attempt),
    n_pair = n_pair,
    coverage_t_minus_z = if (n_pair > 0) mean(coverage_difference) else NA_real_,
    difference_mcse = if (n_pair > 1) {
      sd(coverage_difference) / sqrt(n_pair)
    } else NA_real_
  )
}

# Tiny serial pilot ------------------------------------------------------
# Expected failures stay in the returned numeric records. An unexpected
# thrown error stops at the first attempt, instead of drawing a replacement.
pilot <- runSimulation(
  Design[1:2, , drop = FALSE],
  replications = 3L,
  generate = Generate, analyse = Analyse, summarise = Summarise,
  fixed_objects = fixed_objects, packages = c("dplyr"),
  seed = condition_seeds[1:2],
  parallel = FALSE, save = FALSE, store_results = TRUE,
  max_errors = 1L, progress = FALSE, verbose = FALSE,
  control = list(
    allow_na = TRUE, allow_nan = TRUE, stop_on_fatal = TRUE,
    store_Random.seeds = TRUE
  )
)
print(pilot |> select(n, prevalence, n_attempt, n_est, n_rank_failure))
print(SimErrors(pilot))
print(SimWarnings(pilot))

# Small complete study --------------------------------------------------
# 500 attempts per cell demonstrate the workflow, not publication precision.
# No clock-derived seeds, seeding inside callbacks, or parallel layer.
study <- runSimulation(
  Design, replications = planned_replications,
  generate = Generate, analyse = Analyse, summarise = Summarise,
  fixed_objects = fixed_objects, packages = c("dplyr"),
  seed = condition_seeds,
  parallel = FALSE, save = FALSE, store_results = TRUE,
  max_errors = 1L, progress = FALSE, verbose = FALSE,
  control = list(
    allow_na = TRUE, allow_nan = TRUE, stop_on_fatal = TRUE,
    store_Random.seeds = TRUE
  )
)
engine_errors <- SimErrors(study)
engine_warnings <- SimWarnings(study)
print(engine_errors)
print(engine_warnings)

replications <- SimResults(study) |>
  group_by(n, prevalence) |>
  mutate(replication = row_number(), .before = 1) |>
  ungroup()

# Stable reporting tables; raw engine metadata remain in 'study'.
performance <- as_tibble(study) |>
  select(n, prevalence, n_attempt:difference_mcse) |>
  mutate(n_planned = planned_replications, .before = n_attempt)

# Independent analytical benchmarks -------------------------------------
# K ~ Binomial(n, p); slope exists only for 0 < K < n.
# Conditional Var(beta_hat | K) = sigma^2 * n / (K * (n-K)).
# t intervals cover with the nominal probability given a full-rank design.
oracle <- Design |>
  rowwise() |>
  mutate(
    failure_truth = prevalence^n + (1 - prevalence)^n,
    rmse_truth = sqrt(sum(
      dbinom(1:(n - 1), size = n, prob = prevalence) *
        fixed_objects$sigma^2 * n / ((1:(n - 1)) * (n - (1:(n - 1))))
    ) / (1 - failure_truth)),
    coverage_truth_t = fixed_objects$confidence,
    coverage_truth_z = 2 * pt(
      qnorm((1 + fixed_objects$confidence) / 2), df = n - 2
    ) - 1
  ) |>
  ungroup()

comparison <- performance |>
  left_join(oracle, by = c("n", "prevalence"), relationship = "one-to-one")

# Editable display: conditional coverage and its Monte Carlo uncertainty.
coverage_display <- comparison |>
  select(
    n, prevalence, n_ci_t, n_ci_z, coverage_t, coverage_z,
    coverage_mcse_t, coverage_mcse_z, coverage_truth_t, coverage_truth_z
  ) |>
  pivot_longer(
    cols = -c(n, prevalence),
    names_to = c(".value", "method"), names_pattern = "(.*)_(t|z)"
  ) |>
  mutate(method = factor(method, levels = c("t", "z"),
                         labels = c("t interval", "Normal interval")))

coverage_plot <- ggplot(
  coverage_display, aes(x = method, y = coverage, colour = method)
) +
  geom_hline(yintercept = fixed_objects$confidence, linetype = 2, colour = "grey55") +
  geom_errorbar(
    aes(
      ymin = pmax(0, coverage - 1.96 * coverage_mcse),
      ymax = pmin(1, coverage + 1.96 * coverage_mcse)
    ),
    width = 0.12
  ) +
  geom_point(size = 2.6) +
  geom_point(aes(y = coverage_truth), shape = 4, size = 3, stroke = 1) +
  facet_grid(n ~ prevalence, labeller = label_both) +
  scale_y_continuous(labels = scales::label_percent(accuracy = 1)) +
  labs(
    x = NULL, y = "Coverage among available intervals",
    title = "Small Monte Carlo study: slope intervals",
    subtitle = "Points: simulation; bars: +/- 1.96 MCSE; crosses: analytical values",
    caption = "Failures remain in attempt counts. These bars show Monte Carlo uncertainty."
  ) +
  theme_minimal(base_size = 11) +
  theme(legend.position = "none")

# Preserve the experiment and its traceability ---------------------------
# Outputs are local, synthetic study artifacts; they are ignored by Git.
output_dir <- "output/bernoulli-slope-study"
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
saveRDS(
  list(
    design = Design, fixed_objects = fixed_objects,
    planned_replications = planned_replications, base_seed = base_seed,
    condition_seeds = condition_seeds, study = study,
    replication_seeds = SimExtract(study, "random.seeds"),
    replications = replications, performance = performance,
    oracle = oracle, engine_errors = engine_errors, engine_warnings = engine_warnings,
    rng_kind = RNGkind(), session = sessionInfo(),
    source_md5 = tools::md5sum("skills/r-simulation-execution-and-evaluation/assets/bernoulli-slope-study.R")
  ),
  file.path(output_dir, "study.rds")
)
readr::write_csv(comparison, file.path(output_dir, "performance.csv"))
readr::write_csv(replications, file.path(output_dir, "replications.csv"))
ggsave(file.path(output_dir, "coverage.png"), coverage_plot, width = 8, height = 5, dpi = 160)
print(comparison |>
  select(n, prevalence, n_planned, n_attempt, n_rank_failure, n_est, bias,
         rmse, coverage_t, coverage_z, joint_t))
