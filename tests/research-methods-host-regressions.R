# Focused synthetic regressions for findings from native-host evaluations.
library(dplyr)
library(lavaan)

# Named numerical checks preserve alignment before ignoring attributes.
expected <- c(age30 = 2.5, age50 = 4.5)
reported <- c(age50 = 4.5, age30 = 2.5)
stopifnot(!isTRUE(all.equal(unname(expected), expected)))
aligned <- reported[names(expected)]
stopifnot(identical(names(aligned), names(expected)),
          isTRUE(all.equal(as.numeric(aligned), as.numeric(expected))))
cat("PASS: comparison attributes and term alignment\n")

# Domain degrees of freedom and scalar SE extraction are separate decisions.
sample_data <- expand.grid(person = 1:2, psu = 1:3, stratum = 1:2) |>
  mutate(weight = 2 + person, one = 1, domain = psu <= 2,
         outcome = 3 * psu + person + 2 * stratum)
full <- survey::svydesign(ids = ~psu, strata = ~stratum, weights = ~weight,
                         data = sample_data, nest = TRUE)
domain <- subset(full, domain)
total <- survey::svytotal(~one, domain)
se_native <- survey::SE(total)
se_safe <- sqrt(diag(vcov(total)))
stopifnot(survey::degf(full) == 4, survey::degf(domain) == 2,
          isTRUE(all.equal(as.numeric(se_native), as.numeric(se_safe))))
unsafe <- tryCatch(se_native[["one"]], error = identity)
stopifnot(inherits(unsafe, "error"))
cat("PASS: survey SE extraction; full/domain df = 4/2\n")

# Actual lavaan table fields, plus a deliberately missing free-parameter SE.
set.seed(21907)
f1 <- rnorm(600)
f2 <- 0.4 * f1 + sqrt(1 - 0.4^2) * rnorm(600)
latent_items <- data.frame(
  q1 = .8 * f1 + rnorm(600, sd = .6),
  q2 = .7 * f1 + rnorm(600, sd = .7),
  q3 = .9 * f1 + rnorm(600, sd = .5),
  q4 = .8 * f2 + rnorm(600, sd = .6),
  q5 = .7 * f2 + rnorm(600, sd = .7),
  q6 = .9 * f2 + rnorm(600, sd = .5))
ordinal <- latent_items |>
  mutate(across(everything(), ~ as.integer(cut(.x,
    breaks = c(-Inf, -1, -.3, .3, 1, Inf), labels = FALSE))))
model <- 'first =~ q1 + q2 + q3
          second =~ q4 + q5 + q6'
fit <- cfa(model, data = ordinal, ordered = names(ordinal),
           estimator = "WLSMV", std.lv = TRUE)
stopifnot(lavInspect(fit, "converged"), lavInspect(fit, "post.check"))
pe <- parameterEstimates(fit)
pt <- tibble::as_tibble(parTable(fit))
stopifnot(!"free" %in% names(pe), all(c("free", "se") %in% names(pt)))
first_loading <- which(pe$op == "=~")[1]
pe$se[first_loading] <- NA_real_
pt$se[which(pt$op == "=~" & pt$free > 0)[1]] <- NA_real_
stopifnot(!any(is.na(pe$se[pe$free > 0])),
          nrow(filter(pt, free > 0, !is.finite(se))) == 1L)
cat("PASS: unavailable free-parameter SE detected from parTable\n")

collapsed <- ordinal |> mutate(q6 = if_else(q6 == 5L, 4L, q6))
fit_collapsed <- cfa(model, data = collapsed, ordered = names(collapsed),
                     estimator = "WLSMV", std.lv = TRUE)
stopifnot(lavInspect(fit_collapsed, "converged"),
          sum(parTable(fit)$op == "|") - sum(parTable(fit_collapsed)$op == "|") == 1,
          lavInspect(fit, "npar") - lavInspect(fit_collapsed, "npar") == 1,
          as.numeric(fitMeasures(fit, "df")) == as.numeric(fitMeasures(fit_collapsed, "df")))
cat("PASS: free thresholds can decrease without changing model df\n")

# Valid categories and constant items must be checked on the used rows.
item_data <- tibble(q1 = c(1, 2, 9, NA), q2 = c(3, 3, 3, NA))
invalid <- item_data |> summarise(across(everything(), ~ sum(!is.na(.x) & !.x %in% 1:5)))
used <- item_data |> filter(complete.cases(item_data))
stopifnot(invalid$q1 == 1, var(used$q2) == 0)
cat("PASS: impossible responses and analysis-sample constants remain visible\n")

# SimDesign argument names/nesting, tested without any output file.
Design <- SimDesign::createDesign(n = c(6L, 8L))
Generate <- function(condition, fixed_objects) rnorm(condition$n)
Analyse <- function(condition, dat, fixed_objects) c(estimate = mean(dat))
Summarise <- function(condition, results, fixed_objects) c(attempts = nrow(results))
stopifnot("design" %in% names(formals(SimDesign::runSimulation)),
          !"Design" %in% names(formals(SimDesign::runSimulation)),
          "store_results" %in% names(formals(SimDesign::runSimulation)))
wrong_design <- tryCatch(SimDesign::runSimulation(Design = Design,
  replications = 2L, generate = Generate, analyse = Analyse, summarise = Summarise,
  save = FALSE, progress = FALSE), error = identity)
wrong_storage <- tryCatch(SimDesign::runSimulation(design = Design,
  replications = 2L, generate = Generate, analyse = Analyse, summarise = Summarise,
  save = FALSE, progress = FALSE, control = list(store_results = TRUE)), error = identity)
stopifnot(inherits(wrong_design, "error"), inherits(wrong_storage, "error"))
small <- SimDesign::runSimulation(design = Design, replications = 3L,
  generate = Generate, analyse = Analyse, summarise = Summarise,
  seed = SimDesign::genSeeds(Design, iseed = 21907),
  save = FALSE, store_results = TRUE, max_errors = 1L,
  progress = FALSE, verbose = FALSE,
  control = list(allow_na = TRUE, allow_nan = TRUE, stop_on_fatal = TRUE))
stopifnot(nrow(SimDesign::SimResults(small)) == 6L, sum(small$attempts) == 6)
cat("PASS: SimDesign lowercase design and top-level storage\n")

coverage_truth <- 2 * pt(qnorm(.975), df = 18) - 1
stopifnot(abs(coverage_truth - .9343315) < 1e-7)
cat("PASS: computed normal-critical-value coverage =", coverage_truth, "\n")
cat("ALL SEVEN NATIVE-HOST REGRESSION GROUPS PASSED\n")
