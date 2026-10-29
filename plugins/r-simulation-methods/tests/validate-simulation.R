# Targeted validation for the synthetic study and SimDesign's failure policy.
# Run from the plugin directory. Assertions live here, not in user analyses.
source("skills/r-simulation-execution-and-evaluation/assets/bernoulli-slope-study.R")

# Accounting and independent analytical targets --------------------------
stopifnot(
  nrow(replications) == nrow(Design) * planned_replications,
  all(performance$n_attempt == planned_replications),
  all(performance$n_est + performance$n_rank_failure == performance$n_attempt),
  all(performance$n_se == performance$n_est),
  all(performance$n_ci_t == performance$n_se),
  all(performance$n_ci_z == performance$n_se),
  nrow(engine_errors) == 0L, nrow(engine_warnings) == 0L
)
# Stochastic agreement is a diagnostic, distinct from the exact checks below.
benchmark_z <- comparison |>
  transmute(
    n, prevalence,
    bias_z = bias / bias_mcse,
    rmse_z = (rmse - rmse_truth) / rmse_mcse,
    coverage_t_z = (coverage_t - coverage_truth_t) / coverage_mcse_t,
    coverage_z_z = (coverage_z - coverage_truth_z) / coverage_mcse_z,
    failure_z = (failure_rate - failure_truth) /
      sqrt(failure_truth * (1 - failure_truth) / n_attempt)
  )
stopifnot(all(abs(as.matrix(select(benchmark_z, ends_with("_z")))) < 4))
cat("PASS: fixed attempts, eligibility counts, analytical benchmark agreement.\n")

# A hand-computable summary with different estimate and interval sets -----
fixture <- matrix(
  c(
    1, 1, 1, 1, 0, 0, 0, fixed_objects$beta1 - 1, .2, -.5, .4, -.4, .3,
    1, 1, 1, 1, 0, 0, 0, fixed_objects$beta1,     .3,  .4, 1,   .5, .9,
    1, 1, 1, 0, 0, 0, 1, fixed_objects$beta1 + 1, NA,  NA, NA,  NA, NA,
    1, 0, 0, 0, 1, 1, 1, NA,                    NA,  NA, NA,  NA, NA
  ),
  nrow = 4, byrow = TRUE,
  dimnames = list(NULL, c(
    "fit_returned", "full_rank", "estimate_ok", "se_ok", "rank_failure",
    "nonfinite_estimate", "invalid_se", "estimate", "se",
    "t_lower", "t_upper", "z_lower", "z_upper"
  ))
)
manual <- Summarise(Design[1, ], fixture, fixed_objects)
stopifnot(
  manual["n_attempt"] == 4, manual["n_est"] == 3,
  manual["n_se"] == 2, manual["n_ci_t"] == 2, manual["n_pair"] == 2,
  abs(manual["bias"]) < 1e-14,
  abs(manual["rmse"] - sqrt(2 / 3)) < 1e-14,
  abs(manual["bias_mcse"] - 1 / sqrt(3)) < 1e-14,
  abs(manual["rmse_mcse"] - 1 / sqrt(24)) < 1e-14,
  manual["coverage_t"] == .5, manual["joint_t"] == .25,
  abs(manual["coverage_mcse_t"] - sqrt(.25 / 2)) < 1e-14
)
all_failed <- Summarise(Design[1, ], fixture[c(4, 4), ], fixed_objects)
one_valid <- Summarise(Design[1, ], fixture[1, , drop = FALSE], fixed_objects)
zero_error <- Summarise(Design[1, ], fixture[c(2, 2), ], fixed_objects)
stopifnot(
  all_failed["n_est"] == 0, all_failed["n_ci_t"] == 0,
  is.na(all_failed["bias"]), is.na(all_failed["rmse"]),
  is.na(all_failed["coverage_t"]), all_failed["joint_t"] == 0,
  !any(is.nan(all_failed)), is.na(one_valid["bias_mcse"]),
  is.na(one_valid["rmse_mcse"]), zero_error["rmse"] == 0,
  is.na(zero_error["rmse_mcse"])
)
cat("PASS: manual denominators/MCSE, zero/one eligible result, zero RMSE.\n")

# Independent fit check using a closed-form two-group slope and variance --
set.seed(7301)
check_data <- Generate(Design[3, ], fixed_objects)
check_fit <- Analyse(Design[3, ], check_data, fixed_objects)
group1 <- check_data$y[check_data$x == 1]
group0 <- check_data$y[check_data$x == 0]
pooled_var <- ((length(group1) - 1) * var(group1) +
                (length(group0) - 1) * var(group0)) / (nrow(check_data) - 2)
stopifnot(
  abs(check_fit["estimate"] - (mean(group1) - mean(group0))) < 1e-12,
  abs(check_fit["se"] - sqrt(pooled_var * (1 / length(group1) + 1 / length(group0)))) < 1e-12
)
cat("PASS: native lm agrees with a separate two-group calculation.\n")

# Exact replay after reading the preserved RDS, including a failed record --
saved <- readRDS("output/bernoulli-slope-study/study.rds")
first_cell <- saved$replications |>
  filter(n == saved$design$n[1], prevalence == saved$design$prevalence[1])
replay_ids <- c(which(first_cell$estimate_ok == 1)[1],
                which(first_cell$rank_failure == 1)[1])
for (rep_id in replay_ids) {
  replay <- runSimulation(
    saved$design[1, , drop = FALSE], replications = 1L,
    generate = Generate, analyse = Analyse, summarise = Summarise,
    fixed_objects = saved$fixed_objects, packages = c("dplyr"),
    load_seed = as.integer(saved$replication_seeds[[1]][rep_id, ]),
    parallel = FALSE, save = FALSE, store_results = TRUE,
    max_errors = 1L, progress = FALSE, verbose = FALSE,
    control = list(allow_na = TRUE, allow_nan = TRUE, stop_on_fatal = TRUE)
  )
  observed <- SimResults(replay)
  expected <- first_cell[rep_id, names(observed)]
  stopifnot(isTRUE(all.equal(observed, expected, check.attributes = FALSE, tolerance = 0)))
}
cat("PASS: RDS round trip and exact successful/failed replication replay.\n")

# Probe native redraw behavior independently of the study -----------------
ProbeDesign <- createDesign(cell = 1L)
ProbeGenerate <- function(condition, fixed_objects) {
  fixed_objects$counter$n <- fixed_objects$counter$n + 1L
  runif(1)
}
ProbeAnalyse <- function(condition, dat, fixed_objects) {
  c(draw = dat, estimate = if (dat < .5) NA_real_ else dat)
}
ProbeSummary <- function(condition, results, fixed_objects) {
  c(n_record = nrow(results), n_missing = sum(is.na(results[, "estimate"])))
}
counter <- new.env(parent = emptyenv())
counter$n <- 0L
redraw <- runSimulation(
  ProbeDesign, replications = 12L,
  generate = ProbeGenerate, analyse = ProbeAnalyse, summarise = ProbeSummary,
  fixed_objects = list(counter = counter), seed = genSeeds(ProbeDesign, iseed = 4107L),
  parallel = FALSE, save = FALSE, store_results = TRUE,
  progress = FALSE, verbose = FALSE, control = list(stop_on_fatal = TRUE)
)
stopifnot(
  nrow(SimResults(redraw)) == 12L, redraw$ERRORS > 0,
  counter$n == 12L + redraw$ERRORS, redraw$n_missing == 0
)
redraw_attempts <- counter$n
error_seeds <- SimExtract(redraw, "error_seeds")
counter$n <- 0L
recovered_error <- runSimulation(
  ProbeDesign, replications = 1L,
  generate = ProbeGenerate, analyse = ProbeAnalyse, summarise = ProbeSummary,
  fixed_objects = list(counter = counter),
  load_seed = as.integer(error_seeds[[1]]), save = FALSE,
  max_errors = 1L, progress = FALSE, verbose = FALSE,
  control = list(allow_na = TRUE, stop_on_fatal = TRUE)
)
stopifnot(
  counter$n == 1L,
  SimResults(recovered_error)$draw < .5,
  is.na(SimResults(recovered_error)$estimate)
)
counter$n <- 0L
retained <- runSimulation(
  ProbeDesign, replications = 12L,
  generate = ProbeGenerate, analyse = ProbeAnalyse, summarise = ProbeSummary,
  fixed_objects = list(counter = counter), seed = genSeeds(ProbeDesign, iseed = 4107L),
  parallel = FALSE, save = FALSE, store_results = TRUE,
  max_errors = 1L, progress = FALSE, verbose = FALSE,
  control = list(allow_na = TRUE, allow_nan = TRUE, stop_on_fatal = TRUE)
)
stopifnot(
  counter$n == 12L, retained$n_missing > 0,
  nrow(SimResults(retained)) == 12L, nrow(SimErrors(retained)) == 0L
)
cat("PASS: default NA redraws, retained NA attempts, recovered engine-error seed.\n")

# Explicit NA/NaN controls; Inf still needs a usability check -------------
NanAnalyse <- function(condition, dat, fixed_objects) c(estimate = NaN, failed = 1)
for (controls in list(
  list(allow_na = TRUE, stop_on_fatal = TRUE),
  list(allow_na = FALSE, allow_nan = TRUE, stop_on_fatal = TRUE)
)) {
  counter$n <- 0L
  rejected_nan <- try(runSimulation(
    ProbeDesign, replications = 3L,
    generate = ProbeGenerate, analyse = NanAnalyse, summarise = ProbeSummary,
    fixed_objects = list(counter = counter), seed = 1903,
    save = FALSE, max_errors = 1L, progress = FALSE, verbose = FALSE,
    control = controls
  ), silent = TRUE)
  stopifnot(inherits(rejected_nan, "try-error"), counter$n == 1L)
}
counter$n <- 0L
retained_nan <- runSimulation(
  ProbeDesign, replications = 3L,
  generate = ProbeGenerate, analyse = NanAnalyse, summarise = ProbeSummary,
  fixed_objects = list(counter = counter), seed = 1903,
  save = FALSE, max_errors = 1L, progress = FALSE, verbose = FALSE,
  control = list(allow_na = TRUE, allow_nan = TRUE, stop_on_fatal = TRUE)
)
stopifnot(counter$n == 3L, all(is.nan(SimResults(retained_nan)$estimate)))
# Omission behavior in 2.28: control$allow_na partially matches allow_nan.
stopifnot(isTRUE(list(allow_nan = TRUE)$allow_na))
omitted_na <- runSimulation(
  ProbeDesign, replications = 3L,
  generate = ProbeGenerate, analyse = NanAnalyse, summarise = ProbeSummary,
  fixed_objects = list(counter = counter), seed = 1903,
  save = FALSE, max_errors = 1L, progress = FALSE, verbose = FALSE,
  control = list(allow_nan = TRUE, stop_on_fatal = TRUE)
)
stopifnot(all(is.nan(SimResults(omitted_na)$estimate)))
InfAnalyse <- function(condition, dat, fixed_objects) c(estimate = Inf, failed = 1)
retained_inf <- runSimulation(
  ProbeDesign, replications = 3L,
  generate = ProbeGenerate, analyse = InfAnalyse, summarise = ProbeSummary,
  fixed_objects = list(counter = counter), seed = 1903,
  save = FALSE, max_errors = 1L, progress = FALSE, verbose = FALSE,
  control = list(stop_on_fatal = TRUE)
)
stopifnot(all(is.infinite(SimResults(retained_inf)$estimate)))
cat("PASS: NA/NaN control interaction and nonfinite-value behavior.\n")

# Unexpected exception and warning paths ---------------------------------
ErrorAnalyse <- function(condition, dat, fixed_objects) stop("synthetic code defect")
counter$n <- 0L
strict_error <- try(runSimulation(
  ProbeDesign, replications = 3L,
  generate = ProbeGenerate, analyse = ErrorAnalyse, summarise = ProbeSummary,
  fixed_objects = list(counter = counter), seed = 1903,
  save = FALSE, max_errors = 1L, progress = FALSE, verbose = FALSE,
  control = list(allow_na = TRUE, allow_nan = TRUE, stop_on_fatal = TRUE)
), silent = TRUE)
stopifnot(inherits(strict_error, "try-error"), counter$n == 1L)
fatal_row <- suppressWarnings(runSimulation(
  ProbeDesign, replications = 3L,
  generate = ProbeGenerate, analyse = ErrorAnalyse, summarise = ProbeSummary,
  fixed_objects = list(counter = counter), seed = 1903,
  save = FALSE, max_errors = 2L, progress = FALSE, verbose = FALSE,
  control = list(stop_on_fatal = FALSE)
))
stopifnot("FATAL_TERMINATION" %in% names(fatal_row),
          any(!is.na(fatal_row$FATAL_TERMINATION)))
WarningAnalyse <- function(condition, dat, fixed_objects) {
  warning("synthetic warning category", call. = FALSE)
  c(estimate = dat, failed = 0)
}
counter$n <- 0L
warned <- runSimulation(
  ProbeDesign, replications = 4L,
  generate = ProbeGenerate, analyse = WarningAnalyse, summarise = ProbeSummary,
  fixed_objects = list(counter = counter), seed = 1903,
  save = FALSE, max_errors = 1L, progress = FALSE, verbose = FALSE,
  control = list(stop_on_fatal = TRUE)
)
stopifnot(counter$n == 4L, warned$WARNINGS == 4L,
          nrow(SimWarnings(warned)) == 1L, nrow(SimResults(warned)) == 4L)
cat("PASS: strict unexpected-error abort, fatal field, warning counts without redraw.\n")

# Only now: bounded local PSOCK verification after serial validation -------
small_serial <- runSimulation(
  Design[1:2, , drop = FALSE], replications = 8L,
  generate = Generate, analyse = Analyse, summarise = Summarise,
  fixed_objects = fixed_objects, packages = c("dplyr"),
  seed = condition_seeds[1:2], parallel = FALSE, save = FALSE,
  max_errors = 1L, progress = FALSE, verbose = FALSE,
  control = list(allow_na = TRUE, allow_nan = TRUE, stop_on_fatal = TRUE,
                 store_Random.seeds = TRUE)
)
small_parallel <- runSimulation(
  Design[1:2, , drop = FALSE], replications = 8L,
  generate = Generate, analyse = Analyse, summarise = Summarise,
  fixed_objects = fixed_objects, packages = c("dplyr"),
  seed = condition_seeds[1:2], parallel = TRUE, ncores = 2L, save = FALSE,
  max_errors = 1L, progress = FALSE, verbose = FALSE,
  control = list(allow_na = TRUE, allow_nan = TRUE, stop_on_fatal = TRUE,
                 store_Random.seeds = TRUE, use_mirai = FALSE, type = "PSOCK")
)
small_parallel_repeat <- runSimulation(
  Design[1:2, , drop = FALSE], replications = 8L,
  generate = Generate, analyse = Analyse, summarise = Summarise,
  fixed_objects = fixed_objects, packages = c("dplyr"),
  seed = condition_seeds[1:2], parallel = TRUE, ncores = 2L, save = FALSE,
  max_errors = 1L, progress = FALSE, verbose = FALSE,
  control = list(allow_na = TRUE, allow_nan = TRUE, stop_on_fatal = TRUE,
                 store_Random.seeds = TRUE, use_mirai = FALSE, type = "PSOCK")
)
same_backend_equal <- isTRUE(all.equal(
  SimResults(small_parallel), SimResults(small_parallel_repeat), tolerance = 0
))
serial_parallel_equal <- isTRUE(all.equal(
  SimResults(small_serial), SimResults(small_parallel), tolerance = 0
))
stopifnot(same_backend_equal, nrow(SimErrors(small_parallel)) == 0L)
parallel_replay <- runSimulation(
  Design[1, , drop = FALSE], replications = 1L,
  generate = Generate, analyse = Analyse, summarise = Summarise,
  fixed_objects = fixed_objects, packages = c("dplyr"),
  load_seed = as.integer(SimExtract(small_parallel, "random.seeds")[[1]][3, ]),
  save = FALSE, max_errors = 1L, progress = FALSE, verbose = FALSE,
  control = list(allow_na = TRUE, allow_nan = TRUE, stop_on_fatal = TRUE)
)
stopifnot(isTRUE(all.equal(
  SimResults(parallel_replay), SimResults(small_parallel)[3, ],
  check.attributes = FALSE, tolerance = 0
)))
cat("PASS: two-worker PSOCK repetition and exact replication replay.\n")
cat("Observed serial/PSOCK scientific-output equality:", serial_parallel_equal, "\n")

validation <- list(
  versions = c(R = R.version.string, SimDesign = as.character(packageVersion("SimDesign"))),
  benchmark_z = benchmark_z,
  maximum_absolute_benchmark_z = max(abs(as.matrix(select(benchmark_z, ends_with("_z"))))),
  planned_attempts = sum(performance$n_planned),
  retained_attempts = nrow(replications),
  rank_failures = performance$n_rank_failure,
  default_na_engine_errors = redraw$ERRORS, default_na_generated = redraw_attempts,
  retained_na_count = retained$n_missing,
  fatal_row_error_table_rows = nrow(SimErrors(fatal_row)),
  same_backend_equal = same_backend_equal,
  serial_parallel_equal = serial_parallel_equal,
  manual_metrics = manual
)
saveRDS(validation, "output/validation.rds")
print(validation)
cat("ALL TARGETED VALIDATIONS PASSED.\n")
