# Independently designed ordinal reporting check, executed by the plugin owner.
# Run from the monorepo root:
# Rscript --vanilla plugins/r-psychometrics/tests/independent-ordinal-validation.R
# This synthetic fixture is independent of the documented-example suite.

suppressPackageStartupMessages(library(lavaan))

set.seed(640381L)
n <- 1200L
lambda <- c(.73, .76, .64, .71, .68)
theta <- diag(1 - lambda^2)
theta[1, 2] <- theta[2, 1] <-
  .50 * sqrt(theta[1, 1] * theta[2, 2])

ystar <- tcrossprod(rnorm(n), lambda) +
  matrix(rnorm(n * 5L), n, 5L) %*% chol(theta)
cuts <- list(c(-.9, -.1, .75), c(-.6, .25, 1.1),
             c(-1, -.3, .6), c(-.7, .15, .9), c(-.8, .05, 1.25))
dat <- as.data.frame(setNames(lapply(seq_len(5L), function(j)
  ordered(cut(ystar[, j], c(-Inf, cuts[[j]], Inf), labels = FALSE))),
  paste0("y", seq_len(5L))))

syntax <- "F =~ y1 + y2 + y3 + y4 + y5"
restricted <- cfa(syntax, data = dat, ordered = names(dat),
                  estimator = "WLSMV")
expanded <- cfa(paste(syntax, "y1 ~~ y2", sep = "\n"),
                data = dat, ordered = names(dat), estimator = "WLSMV")

health <- vapply(list(restricted = restricted, expanded = expanded),
  function(f) isTRUE(lavInspect(f, "converged")) &&
              isTRUE(lavInspect(f, "post.check")), logical(1))
print(data.frame(model = names(health), convergence_and_postcheck = health))
if (!all(health)) stop("Fit-health check failed; equivalence checks not run.")

near <- function(a, b) length(a) == length(b) &&
  all(is.finite(a)) && all(is.finite(b)) &&
  all(abs(a - b) <= 1e-7 * (1 + abs(b)))

indices <- c("CFI", "TLI", "RMSEA")
extract_fit <- function(x) {
  x <- as.data.frame(x)
  stopifnot(nrow(x) == 1L, all(indices %in% names(x)))
  as.numeric(unlist(x[1L, indices], use.names = FALSE))
}
default <- extract_fit(psymetrics::model_fit(restricted))
scaled <- extract_fit(psymetrics::model_fit(restricted, type = "scaled"))
robust <- extract_fit(psymetrics::model_fit(restricted, type = "robust"))
native_scaled <- unname(fitMeasures(
  restricted, paste0(tolower(indices), ".scaled")))
native_robust <- unname(fitMeasures(
  restricted, paste0(tolower(indices), ".robust")))

print(data.frame(index = indices, default, scaled, native_scaled,
                 robust, native_robust), digits = 7)
checks <- c(
  default_equals_scaled = near(default, native_scaled),
  explicit_scaled_matches = near(scaled, native_scaled),
  explicit_robust_matches = near(robust, native_robust),
  fixture_distinguishes_families =
    all(is.finite(c(native_scaled, native_robust))) &&
    max(abs(native_scaled - native_robust)) > 1e-5
)

out <- as.data.frame(psymetrics::model_estimates(
  expanded, standardized = "std.all", ci = .95))
ref <- standardizedSolution(expanded, type = "std.all", level = .95)
ref <- ref[ref$lhs == "F" & ref$op == "=~", ]
stopifnot(nrow(ref) == 5L)

# Match factor/indicator identity; allow either To/From display convention.
rows <- vapply(ref$rhs, function(v) {
  hit <- which(out$Operator == "=~" &
    ((out$To == "F" & out$From == v) |
     (out$From == "F" & out$To == v)))
  if (length(hit) != 1L) stop("Missing or ambiguous loading: ", v)
  as.integer(hit)
}, integer(1))
actual <- as.matrix(out[rows,
  c("Coefficient", "SE", "CI_low", "CI_high", "z", "p")])
expected <- as.matrix(ref[,
  c("est.std", "se", "ci.lower", "ci.upper", "z", "pvalue")])
loading_pass <- vapply(seq_len(nrow(ref)), function(i)
  near(actual[i, ], expected[i, ]), logical(1))
print(data.frame(
  loading = paste("F =~", ref$rhs),
  estimate = actual[, 1L], SE = actual[, 2L],
  CI_low = actual[, 3L], CI_high = actual[, 4L],
  max_abs_error = apply(abs(actual - expected), 1L, max),
  PASS = loading_pass), digits = 7)
checks["standardized_estimate_and_uncertainty"] <- all(loading_pass)

lrt <- lavTestLRT(expanded, restricted, method = "satorra.2000")
row <- which(is.finite(lrt[["Df diff"]]))
stopifnot(length(row) == 1L)
stat <- lrt[row, "Chisq diff"]
df <- lrt[row, "Df diff"]
p <- lrt[row, "Pr(>Chisq)"]
naive <- unname(fitMeasures(restricted, "chisq.scaled") -
                fitMeasures(expanded, "chisq.scaled"))
print(data.frame(corrected_chisq = stat, df, corrected_p = p,
                 naive_scaled_subtraction = naive), digits = 7)
checks["corrected_nested_comparison"] <-
  is.finite(stat) && stat >= 0 && isTRUE(df == 1) &&
  near(p, pchisq(stat, df = 1, lower.tail = FALSE))

print(data.frame(check = names(checks),
                 result = ifelse(checks, "PASS", "FAIL")), row.names = FALSE)
if (!all(checks)) stop("Independent numerical check failed; see results above.")
