# Synthetic checks for the documented r-psychometrics slice.
# Run from the repository root:
# Rscript --vanilla plugins/r-psychometrics/tests/synthetic-validation.R plugins/r-psychometrics
# Assertions/helpers are verification mechanics, not user-analysis scaffolding.

args <- commandArgs(trailingOnly = TRUE)
plugin_root <- if (length(args)) args[[1]] else "plugins/r-psychometrics"

# Execute the actual documented R blocks, not a separately maintained recipe.
run_reference <- function(relative_path) {
  lines <- readLines(file.path(plugin_root, relative_path), warn = FALSE)
  code <- character()
  in_r <- FALSE
  for (line in lines) {
    if (!in_r && identical(line, "```r")) {
      in_r <- TRUE
    } else if (in_r && identical(line, "```")) {
      in_r <- FALSE
    } else if (in_r) {
      code <- c(code, line)
    }
  }
  stopifnot(length(code) > 0L, !in_r)
  result <- new.env(parent = globalenv())
  invisible(capture.output(eval(parse(text = code), envir = result)))
  result
}

expect_near <- function(actual, expected, label, tolerance = 1e-8) {
  if (!isTRUE(all.equal(as.numeric(actual), as.numeric(expected),
                       tolerance = tolerance, check.attributes = FALSE))) {
    stop(label, ": numerical mismatch")
  }
  cat("PASS:", label, "\n")
}

# Known single-group parameter identity; no general-purpose extractor.
check_estimates <- function(fit, reported, metric = FALSE, ci = 0.95) {
  native <- if (identical(metric, FALSE)) {
    lavaan::parameterEstimates(fit, ci = TRUE, level = ci)
  } else {
    lavaan::standardizedSolution(
      fit, type = if (identical(metric, TRUE)) "std.all" else metric,
      ci = TRUE, level = ci
    )
  }
  reported <- as.data.frame(reported)
  native_key <- paste(native$lhs, native$op, native$rhs, sep = "\r")
  report_key <- paste(reported$To, reported$Operator, reported$From, sep = "\r")
  stopifnot(!anyDuplicated(native_key), !anyDuplicated(report_key),
            nrow(native) == nrow(reported))
  ix <- match(report_key, native_key)
  stopifnot(!anyNA(ix))
  native_estimate <- if (identical(metric, FALSE)) "est" else "est.std"
  report_fields <- c("Coefficient", "SE", "CI_low", "CI_high", "z", "p")
  native_fields <- c(native_estimate, "se", "ci.lower", "ci.upper", "z", "pvalue")
  expect_near(as.matrix(reported[, report_fields]),
       as.matrix(native[ix, native_fields]),
       paste("parameter/SE/CI/z/p equivalence:", metric))
}

check_fit <- function(fit, reported, family) {
  index_suffix <- switch(family, standard = "", scaled = ".scaled", robust = ".robust")
  test_suffix <- if (family == "standard") "" else ".scaled"
  native_names <- c(
    paste0(c("chisq", "df", "pvalue"), test_suffix),
    paste0(c("cfi", "tli", "rmsea", "rmsea.ci.lower", "rmsea.ci.upper"), index_suffix),
    "srmr"
  )
  report_names <- c("Chi2", "Chi2_df", "p_Chi2", "CFI", "TLI", "RMSEA",
                    "RMSEA_CI_low", "RMSEA_CI_high", "SRMR")
  reported <- as.data.frame(reported)
  stopifnot(nrow(reported) == 1L, all(report_names %in% names(reported)))
  native <- lavaan::fitMeasures(fit, native_names)
  stopifnot(identical(names(native), native_names))
  expect_near(unlist(reported[1, report_names]), native,
       paste("fit-family equivalence:", family))
  expect_near(reported$NOBS, sum(lavaan::lavInspect(fit, "nobs")), "reported sample size")
}

check_comparison <- function(fit1, fit2, fit_table, estimate_table, family) {
  fit_table <- as.data.frame(fit_table)
  stopifnot(identical(as.character(fit_table$MODEL), c("independent", "residual")))
  check_fit(fit1, fit_table[fit_table$MODEL == "independent", ], family)
  check_fit(fit2, fit_table[fit_table$MODEL == "residual", ], family)
  estimate_table <- as.data.frame(estimate_table)
  for (label in c("independent", "residual")) {
    fit <- if (label == "independent") fit1 else fit2
    present <- !is.na(estimate_table[[paste0("Coefficient.", label)]])
    columns <- paste0(c("Coefficient", "SE", "CI_low", "CI_high", "z", "p"), ".", label)
    one <- estimate_table[present, c("To", "Operator", "From", columns)]
    names(one)[4:9] <- c("Coefficient", "SE", "CI_low", "CI_high", "z", "p")
    check_estimates(fit, one, "std.all")
  }
  cat("PASS: comparison parameter alignment and fit preservation\n")
}

# Item key, denominators, alpha and item-rest correlations ----
item <- run_reference("skills/r-item-and-reliability-analysis/references/items-and-consistency.md")
stopifnot(item$score_counts$n_respondents == 480L,
          item$score_counts$n_scored == 429L,
          is.na(item$scores$total[51]),
          all(item$item_counts$n_total == 480L))
expect_near(item$items_scored$q3, 6 - item$items_raw$q3, "declared q3 key")
expect_near(item$items_scored$q6, 6 - item$items_raw$q6, "declared q6 key")
S <- stats::cov(item$items_complete)
R <- stats::cor(item$items_complete)
k <- ncol(S)
alpha_formula <- k / (k - 1) * (1 - sum(diag(S)) / sum(S))
alpha_standardized_formula <- k / (k - 1) * (1 - k / sum(R))
expect_near(item$alpha_fit$total$raw_alpha, alpha_formula, "raw alpha covariance formula")
expect_near(item$alpha_fit$total$std.alpha, alpha_standardized_formula, "standardized alpha formula")
rest <- vapply(seq_len(k), function(j) {
  stats::cor(item$items_complete[[j]], rowSums(item$items_complete[, -j]))
}, numeric(1))
expect_near(item$alpha_fit$item.stats$r.drop, rest, "item-rest correlations")
stopifnot(nrow(item$alpha_fit$boot) == 200L,
          all(is.finite(item$alpha_fit$boot.ci)))
cat("EVIDENCE alpha =", format(alpha_formula, digits = 10),
    "; scored N =", item$score_counts$n_scored, "\n")

# CFA-based reliability and native covariance denominators ----
rel <- run_reference("skills/r-item-and-reliability-analysis/references/model-based-reliability.md")
stopifnot(lavaan::lavInspect(rel$fit_reliability_continuous, "post.check"),
          lavaan::lavInspect(rel$fit_reliability_ordinal, "post.check"))
mat <- lavaan::lavInspect(rel$fit_reliability_continuous, "est")
common <- mat$lambda %*% mat$psi %*% t(mat$lambda)
expect_near(unlist(rel$reliability_observed_denominator),
     sum(common) / sum(lavaan::lavInspect(rel$fit_reliability_continuous, "sampstat")$cov),
     "continuous reliability, observed denominator")
expect_near(unlist(rel$reliability_model_denominator),
     sum(common) / sum(common + mat$theta),
     "continuous reliability, model-implied denominator")
mat_ord <- lavaan::lavInspect(rel$fit_reliability_ordinal, "est")
common_ord <- mat_ord$lambda %*% mat_ord$psi %*% t(mat_ord$lambda)
expect_near(unlist(rel$reliability_latent_response),
     sum(common_ord) / sum(lavaan::lavInspect(rel$fit_reliability_ordinal, "sampstat")$cov),
     "ordinal latent-response reliability formula")
ordinal_score_reliability <- as.numeric(unlist(rel$reliability_ordinal_score))
latent_response_reliability <- as.numeric(unlist(rel$reliability_latent_response))
stopifnot(is.finite(ordinal_score_reliability),
          ordinal_score_reliability > 0, ordinal_score_reliability < 1,
          abs(ordinal_score_reliability - latent_response_reliability) > 0.005)
cat("EVIDENCE ordinal score reliability =", ordinal_score_reliability,
    "; latent-response reliability =", latent_response_reliability, "\n")

# Continuous EFA: rotation-invariant covariance and structure relationships ----
efa <- run_reference("skills/r-exploratory-factor-analysis/references/retention-and-psych.md")
pattern <- unclass(efa$efa_two$loadings)
factor_cov <- efa$efa_two$Phi
common_efa <- pattern %*% factor_cov %*% t(pattern)
expect_near(efa$efa_two$Structure, pattern %*% factor_cov, "oblique pattern to structure")
expect_near(efa$efa_two$communality, diag(common_efa), "oblique communalities")
expect_near(efa$efa_two$uniquenesses, 1 - diag(common_efa), "EFA uniquenesses")
expect_near(efa$efa_two$residual, stats::cor(efa$efa_items) - common_efa,
     "psych native residual matrix, including diagonal uniquenesses")
stopifnot(efa$efa_two$dof == 13L, all(efa$efa_two$uniquenesses > 0),
          efa$parallel_fit$nfact == 2L)
cat("EVIDENCE continuous parallel-analysis suggestion =", efa$parallel_fit$nfact, "\n")

# Ordinal EFA: return classes, estimator/inference and native representation ----
efa_ord <- run_reference("skills/r-exploratory-factor-analysis/references/ordinal-lavaan.md")
stopifnot(inherits(efa_ord$efa_ordinal_overview, "efaList"),
          inherits(efa_ord$efa_ordinal, "lavaan"),
          lavaan::lavInspect(efa_ord$efa_ordinal, "converged"),
          lavaan::lavInspect(efa_ord$efa_ordinal, "post.check"))
opt <- lavaan::lavInspect(efa_ord$efa_ordinal, "options")
stopifnot(opt$estimator == "DWLS", "scaled.shifted" %in% opt$test,
          grepl("robust", opt$se))
overview_metrics <- lavaan::fitMeasures(
  efa_ord$efa_ordinal_overview, c("chisq.scaled", "cfi.scaled", "rmsea.scaled")
)
expect_near(overview_metrics[, 2],
     lavaan::fitMeasures(efa_ord$efa_ordinal, rownames(overview_metrics)),
     "EFA list and selected lavaan scaled fit", tolerance = 1e-6)
expect_near(lavaan::lavInspect(efa_ord$efa_ordinal_overview$nf2, "implied")$cov,
     lavaan::lavInspect(efa_ord$efa_ordinal, "implied")$cov,
     "EFA return forms implied covariance", tolerance = 1e-6)
ordinal_summary <- summary(efa_ord$efa_ordinal, fit.measures = TRUE, standardized = TRUE)
stopifnot(inherits(ordinal_summary, "lavaan.summary"),
          length(ordinal_summary$fit) > 0L, nrow(ordinal_summary$pe) > 0L)
cat("PASS: native lavaan summary dispatch with fit and parameter content\n")
cat("EVIDENCE ordinal EFA scaled fit\n")
print(efa_ord$efa_ordinal_scaled)

# Continuous MLR/FIML CFA and all four psymetrics operations ----
cont <- run_reference("skills/r-cfa-sem/references/continuous-cfa.md")
stopifnot(lavaan::lavInspect(cont$fit_continuous, "converged"),
          lavaan::lavInspect(cont$fit_continuous, "post.check"),
          lavaan::lavInspect(cont$fit_continuous_residual, "post.check"),
          lavaan::lavInspect(cont$fit_continuous, "nobs") == 700L)
check_fit(cont$fit_continuous, cont$fit_continuous_table, "scaled")
check_estimates(cont$fit_continuous, cont$est_continuous_raw)
check_estimates(cont$fit_continuous, cont$est_continuous_std, "std.all")
check_comparison(cont$fit_continuous, cont$fit_continuous_residual,
                 cont$compare_continuous_fit, cont$compare_continuous_estimates, "scaled")
for (metric in c("std.lv", "std.nox")) {
  check_estimates(
    cont$fit_continuous,
    psymetrics::model_estimates(cont$fit_continuous, standardized = metric, ci = 0.90),
    metric, ci = 0.90
  )
}
check_estimates(cont$fit_continuous,
                psymetrics::model_estimates(cont$fit_continuous, standardized = TRUE), TRUE)
stopifnot(cont$continuous_difference[2, "Df diff"] == 1,
          is.finite(cont$continuous_difference[2, "Chisq diff"]),
          cont$continuous_difference[2, "Chisq diff"] > 0)
cont_scaled <- lavaan::fitMeasures(cont$fit_continuous, "chisq.scaled")
cont_scaled_less <- lavaan::fitMeasures(cont$fit_continuous_residual, "chisq.scaled")
stopifnot(abs(cont$continuous_difference[2, "Chisq diff"] -
              (cont_scaled - cont_scaled_less)) > 1e-3)
cat("PASS: adjusted MLR difference is not naive scaled subtraction\n")

# Ordinary ML and the same complete-data point-estimation target as MLR.
model_ml_check <- '
  domain_a =~ a1 + a2 + a3 + a4
  domain_b =~ b1 + b2 + b3 + b4
  a2 ~~ a4
'
fit_ml_check <- lavaan::cfa(
  model_ml_check, data = cont$continuous_complete, estimator = "ML",
  std.lv = FALSE, meanstructure = TRUE, missing = "listwise"
)
summary_ml <- summary(fit_ml_check, fit.measures = TRUE, standardized = TRUE)
stopifnot(inherits(summary_ml, "lavaan.summary"),
          lavaan::lavInspect(fit_ml_check, "post.check"))
check_fit(fit_ml_check, psymetrics::model_fit(fit_ml_check), "standard")
check_estimates(fit_ml_check, psymetrics::model_estimates(fit_ml_check))
fit_mlr_complete_check <- lavaan::cfa(
  model_ml_check, data = cont$continuous_complete, estimator = "MLR",
  std.lv = FALSE, meanstructure = TRUE, missing = "listwise"
)
expect_near(lavaan::coef(fit_ml_check), lavaan::coef(fit_mlr_complete_check),
     "ML and MLR point estimates on identical complete data")

# Ordinal CFA: exact scaled default, distinct optional alternatives and tables.
ord <- run_reference("skills/r-cfa-sem/references/ordinal-cfa.md")
stopifnot(lavaan::lavInspect(ord$fit_ordinal, "converged"),
          lavaan::lavInspect(ord$fit_ordinal, "post.check"),
          lavaan::lavInspect(ord$fit_ordinal_residual, "post.check"))
check_fit(ord$fit_ordinal, ord$ordinal_fit_table, "scaled")
for (family in c("standard", "scaled", "robust")) {
  check_fit(ord$fit_ordinal,
            psymetrics::model_fit(ord$fit_ordinal, type = family, verbose = FALSE),
            family)
}
check_estimates(ord$fit_ordinal, ord$ordinal_raw)
check_estimates(ord$fit_ordinal, ord$ordinal_standardized, "std.all")
check_comparison(ord$fit_ordinal, ord$fit_ordinal_residual,
                 ord$compare_ordinal_fit, ord$compare_ordinal_estimates, "scaled")
compare_ord_default <- psymetrics::compare_model_fit(
  independent = ord$fit_ordinal, residual = ord$fit_ordinal_residual
)
expect_near(compare_ord_default$CFI, ord$compare_ordinal_fit$CFI,
     "comparison default preserves explicit scaled CFI")
expect_near(compare_ord_default$RMSEA, ord$compare_ordinal_fit$RMSEA,
     "comparison default preserves explicit scaled RMSEA")
families <- lavaan::fitMeasures(
  ord$fit_ordinal, c("cfi.scaled", "cfi.robust", "rmsea.scaled", "rmsea.robust")
)
stopifnot(abs(families["cfi.scaled"] - families["cfi.robust"]) > 1e-3,
          abs(families["rmsea.scaled"] - families["rmsea.robust"]) > 1e-3)
stopifnot(ord$ordinal_difference[2, "Df diff"] == 1,
          ord$ordinal_difference[2, "Chisq diff"] > 0)
naive_ordinal_diff <- lavaan::fitMeasures(ord$fit_ordinal, "chisq.scaled") -
  lavaan::fitMeasures(ord$fit_ordinal_residual, "chisq.scaled")
stopifnot(abs(ord$ordinal_difference[2, "Chisq diff"] - naive_ordinal_diff) > 1e-3)
cat("PASS: adjusted WLSMV difference is not naive scaled subtraction\n")
cat("EVIDENCE distinct WLSMV index families\n")
print(families)

# Known labeling issue: verify the numerical metric, not a package fix.
raw_table <- as.data.frame(cont$est_continuous_raw)
cov_row <- raw_table$To == "domain_a" & raw_table$Operator == "~~" &
  raw_table$From == "domain_b"
stopifnot(sum(cov_row) == 1L)
native_covariance <- lavaan::lavInspect(cont$fit_continuous, "cov.lv")[1, 2]
native_correlation <- lavaan::lavInspect(cont$fit_continuous, "cor.lv")[1, 2]
expect_near(raw_table$Coefficient[cov_row], native_covariance,
     "raw covariance preserved despite issue 55 label")
stopifnot(abs(native_covariance - native_correlation) > 0.01)
cat("EVIDENCE issue 55 component =", raw_table$Component[cov_row],
    "; covariance =", native_covariance, "; correlation =", native_correlation, "\n")

# Basic SEM: native regression reference and a direct delta-method identity.
sem_case <- run_reference("skills/r-cfa-sem/references/basic-sem.md")
check_estimates(sem_case$fit_path, sem_case$path_estimates)
check_estimates(sem_case$fit_latent_path, sem_case$latent_path_raw)
check_estimates(sem_case$fit_latent_path, sem_case$latent_path_standardized, "std.all")
check_fit(sem_case$fit_latent_path, sem_case$latent_path_fit, "scaled")
stopifnot(lavaan::lavInspect(sem_case$fit_latent_path, "post.check"),
          lavaan::fitMeasures(sem_case$fit_path, "df") == 0L)
path_coef <- lavaan::coef(sem_case$fit_path)
lm_a <- stats::lm(mediator ~ predictor, data = sem_case$path_data)
lm_b <- stats::lm(outcome ~ mediator + predictor, data = sem_case$path_data)
expect_near(path_coef["a"], stats::coef(lm_a)["predictor"], "path a versus native lm")
expect_near(path_coef[c("b", "direct")], stats::coef(lm_b)[c("mediator", "predictor")],
     "path b/direct versus native lm")
indirect <- sem_case$path_native[sem_case$path_native$lhs == "indirect" &
                                 sem_case$path_native$op == ":=", ]
V <- lavaan::vcov(sem_case$fit_path)
a <- path_coef["a"]
b <- path_coef["b"]
delta_se <- sqrt(b^2 * V["a", "a"] + a^2 * V["b", "b"] + 2 * a * b * V["a", "b"])
expect_near(indirect$est, a * b, "defined indirect effect")
expect_near(indirect$se, delta_se, "indirect delta-method SE")
check_estimates(sem_case$fit_latent_path,
                psymetrics::model_estimates(sem_case$fit_latent_path, standardized = "std.nox"),
                "std.nox")
cat("EVIDENCE observed-path indirect =", indirect$est, "; delta SE =", indirect$se, "\n")

# Negative cases: deliberately invalid inputs/solutions are not reported as success.
fiml_error <- tryCatch(
  lavaan::cfa(ord$model_ordinal, data = ord$ordinal_cfa_items,
              ordered = names(ord$ordinal_cfa_items),
              estimator = "WLSMV", missing = "fiml"),
  error = identity
)
stopifnot(inherits(fiml_error, "error"))
cat("PASS: unsupported ordinal FIML fails natively\n")

# Positive-definite covariance input with an exact one-factor Heywood solution.
heywood_cov <- matrix(c(1, .8, .8, .8, 1, .5, .8, .5, 1), 3, 3)
dimnames(heywood_cov) <- list(c("z1", "z2", "z3"), c("z1", "z2", "z3"))
stopifnot(min(eigen(heywood_cov, symmetric = TRUE)$values) > 0)
fit_heywood <- suppressWarnings(lavaan::cfa(
  "trait =~ z1 + z2 + z3", sample.cov = heywood_cov, sample.nobs = 500,
  estimator = "ML", std.lv = TRUE
))
stopifnot(lavaan::lavInspect(fit_heywood, "converged"),
          !suppressWarnings(lavaan::lavInspect(fit_heywood, "post.check")),
          any(diag(lavaan::lavInspect(fit_heywood, "theta")) < 0))
heywood_report <- suppressWarnings(psymetrics::model_estimates(fit_heywood, verbose = FALSE))
stopifnot(all(heywood_report$converged),
          any(heywood_report$Coefficient[heywood_report$Operator == "~~" &
                                          heywood_report$To == heywood_report$From] < 0))
cat("PASS: converged reporting object can still be inadmissible\n")

fit_unfinished <- suppressWarnings(lavaan::cfa(
  cont$model_continuous, data = cont$continuous_complete,
  estimator = "ML", std.lv = FALSE, control = list(iter.max = 1)
))
stopifnot(!lavaan::lavInspect(fit_unfinished, "converged"))
cat("PASS: nonconvergence is visible before substantive reporting\n")

cat("\nExecuted package versions\n")
print(R.version.string)
print(vapply(c("psych", "lavaan", "semTools", "psymetrics", "dplyr", "tidyr"),
             function(package) as.character(utils::packageVersion(package)), character(1)))
cat("\nPASS: all documented synthetic checks completed\n")
