# Focused composition smoke test for four skills-only research plugins.
# Run from repository root: Rscript --vanilla tests/research-methods-composition.R
# Synthetic inputs only; no user data, package installation or output files.
library(dplyr)
library(tidyr)

# 1. Data import/reshape -> ordinary applied regression.
input <- readr::read_csv(I("id,arm,baseline,followup\n0001,A,6,8\n0002,A,4,5\n0003,A,5,\n0004,B,7,8\n0005,B,8,7\n0006,B,9,10"),
  col_types = readr::cols(id = readr::col_character(), arm = readr::col_character(),
    baseline = readr::col_double(), followup = readr::col_double()),
  na = "", show_col_types = FALSE)
stopifnot(identical(input$id, sprintf("%04d", 1:6)))
long <- tidyr::pivot_longer(input, c(baseline, followup),
                            names_to = "occasion", values_to = "score")
counted <- long |> group_by(arm, occasion) |>
  summarise(n_eligible = n(), n_observed = sum(!is.na(score)), .groups = "drop")
stopifnot(nrow(long) == 12L, sum(is.na(long$score)) == 1L,
          sum(counted$n_eligible) == 12L, sum(counted$n_observed) == 11L)
fit_lm <- stats::lm(followup ~ baseline + arm, data = input)
reported_lm <- as.data.frame(parameters::model_parameters(fit_lm))
stopifnot(stats::nobs(fit_lm) == 5L,
  isTRUE(all.equal(reported_lm$Coefficient[reported_lm$Parameter == "baseline"],
                   unname(stats::coef(fit_lm)[["baseline"]]), tolerance = 1e-10)))
cat("PASS 1: data preparation -> regression, cases and estimate\n")

# 2. One-to-one integration -> complex survey domain inference.
frame <- tibble::tibble(
  id = sprintf("%04d", 1:8), stratum = rep(c("S1", "S2"), each = 4),
  psu = rep(c(1L, 1L, 2L, 2L), 2), weight = rep(c(1, 2), 4),
  domain = rep(c("A", "B"), 4))
outcomes <- tibble::tibble(id = sprintf("%04d", 1:8),
                           score = c(10, 12, 14, 16, 20, 22, 24, 26))
sample_data <- left_join(frame, outcomes, by = join_by(id), relationship = "one-to-one")
stopifnot(nrow(sample_data) == 8L, !anyNA(sample_data$score))
design <- survey::svydesign(ids = ~psu, strata = ~stratum, weights = ~weight,
                            data = sample_data, nest = TRUE)
domain_mean <- survey::svymean(~score, subset(design, domain == "A"))
stopifnot(is.finite(unname(coef(domain_mean))),
          is.finite(unname(survey::SE(domain_mean))),
          unname(survey::SE(domain_mean)) > 0)
cat("PASS 2: prepared data -> survey design and domain uncertainty\n")

# 3. Joined ordered-item table -> ordinal CFA and scaled reporting.
set.seed(29071)
n <- 320L
latent <- rnorm(n)
items <- as.data.frame(lapply(seq_len(5), function(j) {
  values <- 0.8 * latent + rnorm(n, sd = 0.6)
  ordered(cut(values, breaks = quantile(values, probs = seq(0, 1, 0.25)),
              labels = FALSE, include.lowest = TRUE))
}))
names(items) <- paste0("item", 1:5)
item_table <- tibble::tibble(id = sprintf("R%04d", seq_len(n))) |>
  left_join(tibble::tibble(id = sprintf("R%04d", seq_len(n)), items),
            by = join_by(id), relationship = "one-to-one")
ordinal <- dplyr::select(item_table, starts_with("item"))
stopifnot(nrow(ordinal) == n, all(vapply(ordinal, is.ordered, logical(1))))
fit_cfa <- lavaan::cfa("F =~ item1 + item2 + item3 + item4 + item5",
                      data = ordinal, ordered = names(ordinal), estimator = "WLSMV")
stopifnot(lavaan::lavInspect(fit_cfa, "converged"),
          lavaan::lavInspect(fit_cfa, "post.check"))
fit_indices <- as.data.frame(psymetrics::model_fit(fit_cfa))
stopifnot(isTRUE(all.equal(fit_indices$CFI,
  as.numeric(lavaan::fitMeasures(fit_cfa, "cfi.scaled")), tolerance = 1e-10)))
cat("PASS 3: ordered research items -> CFA and scaled-fit extraction\n")

# 4. SimDesign execution -> native applied regression, fixed attempts.
Design <- SimDesign::createDesign(n = c(20L, 40L), prevalence = 0.2)
fixed_objects <- list(beta = 0.5)
Generate <- function(condition, fixed_objects) {
  x <- rbinom(condition$n, 1, condition$prevalence)
  data.frame(x = x, y = fixed_objects$beta * x + rnorm(condition$n))
}
Analyse <- function(condition, dat, fixed_objects) {
  if (length(unique(dat$x)) < 2L) return(c(estimate = NA_real_, identified = 0))
  fit <- stats::lm(y ~ x, data = dat)
  c(estimate = unname(stats::coef(fit)[["x"]]), identified = 1)
}
Summarise <- function(condition, results, fixed_objects) {
  usable <- is.finite(results$estimate)
  c(n_attempt = nrow(results), n_identified = sum(usable),
    bias = if (any(usable)) mean(results$estimate[usable]) - fixed_objects$beta else NA_real_)
}
sim <- SimDesign::runSimulation(
  Design, replications = 16L, generate = Generate, analyse = Analyse,
  summarise = Summarise, fixed_objects = fixed_objects,
  seed = SimDesign::genSeeds(Design, iseed = 29071),
  save = FALSE, store_results = TRUE, max_errors = 1L,
  progress = FALSE, verbose = FALSE,
  control = list(allow_na = TRUE, allow_nan = TRUE, stop_on_fatal = TRUE))
raw <- SimDesign::SimResults(sim)
stopifnot(nrow(raw) == 32L, sum(sim$n_attempt) == 32L,
          sum(sim$n_identified) <= 32L,
          nrow(SimDesign::SimErrors(sim)) == 0L)
cat("PASS 4: simulation with native regression and fixed attempts\n")
cat("ALL FOUR CROSS-PLUGIN COMPOSITION CHECKS PASSED\n")
