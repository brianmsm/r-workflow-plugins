# Items, Declared Scoring and Internal Consistency

Use for observed item distributions, a known scoring key and a classical internal-consistency coefficient. The unit here is an independently sampled respondent. Clustered samples, repeated measures and rater agreement require an appropriate dependence/uncertainty method.

## Decisions that change the score

Confirm the instrument's valid endpoints and reverse key before looking at correlations. Preserve the original responses, and distinguish omitted responses from structural not-applicable values. Missing-item rules must come from the instrument or a stated analysis rationale; neither `rowMeans(..., na.rm = TRUE)` nor alpha's defaults establish a defensible rule.

Raw alpha describes a unit-weighted sum on the original metric; standardized alpha describes standardized items. For covariance matrix S and k items, raw alpha is k/(k - 1) times [1 - trace(S)/sum(S)]. Its interpretation as reliability needs assumptions such as essential tau equivalence and uncorrelated errors. Under violations it need not be a dependable lower bound. Alpha alone cannot establish dimensionality, content coverage or validity.

Item-rest correlations use the other items, avoiding item-total overlap. Inspect them together with item wording, response distributions and the intended subscale. Alpha-if-deleted does not decide whether an item should be removed.

## Runnable synthetic example

These six invented items have response categories 1 to 5; q3 and q6 have a declared reverse key. The example requires all six responses for a score and estimates alpha on the same complete cases. This is a transparent illustration, not a recommended missing-item rule for other instruments. The missing pattern is artificial.

```r
library(dplyr)
library(tidyr)

# Synthetic responses and original key direction ----
set.seed(20301)
trait <- rnorm(480)
items_positive <- tibble(
  q1 = 0.8 * trait + rnorm(480),
  q2 = 0.7 * trait + rnorm(480),
  q3 = 0.9 * trait + rnorm(480),
  q4 = 0.6 * trait + rnorm(480),
  q5 = 0.8 * trait + rnorm(480),
  q6 = 0.7 * trait + rnorm(480)
) |>
  mutate(across(everything(), ~ as.integer(cut(
    .x, breaks = c(-Inf, -1, -0.3, 0.4, 1.2, Inf), labels = FALSE
  ))))

items_raw <- items_positive |>
  mutate(q3 = 6L - q3, q6 = 6L - q6)
items_raw$q2[1:30] <- NA_integer_
items_raw$q5[21:50] <- NA_integer_
items_raw[51, ] <- NA_integer_

# Apply the documented key; retain items_raw ----
items_scored <- items_raw |>
  mutate(q3 = 6L - q3, q6 = 6L - q6)
item_names <- names(items_scored)

item_counts <- items_scored |>
  pivot_longer(everything(), names_to = "item", values_to = "response") |>
  count(item, response, name = "n") |>
  complete(item, response = 1:5, fill = list(n = 0L)) |>
  group_by(item) |>
  mutate(
    n_total = sum(n),
    n_valid = sum(n[!is.na(response)]),
    proportion_all = n / n_total,
    proportion_valid = if_else(is.na(response), NA_real_, n / n_valid)
  ) |>
  ungroup()
item_counts

# Complete-score rule and its denominator ----
scores <- items_scored |>
  mutate(
    n_answered = rowSums(!is.na(pick(all_of(item_names)))),
    total = if_else(
      n_answered == length(item_names),
      rowSums(pick(all_of(item_names))),
      NA_real_
    )
  )
score_counts <- scores |>
  summarise(n_respondents = n(), n_scored = sum(!is.na(total)))
score_counts

items_complete <- items_scored |> drop_na()

# Alpha for the original metric, not a dimensionality test ----
set.seed(20302)
alpha_fit <- psych::alpha(
  items_complete,
  check.keys = FALSE, delete = FALSE, use = "complete.obs",
  n.iter = 200
)
alpha_fit$total
alpha_fit$item.stats[, c("n", "mean", "sd", "r.drop")]
alpha_fit$alpha.drop
alpha_fit$boot.ci
```

The 200 bootstrap resamples make this a bounded executable example, not evidence of sufficiently stable interval endpoints for a substantive report. State the resampling unit, interval method and successful resamples; choose enough resamples for the precision needed. Here the native `boot.ci` is the percentile summary of respondent resamples. Analytical intervals printed by `alpha()` are different calculations.

All-missing respondents remain missing scores. Counts are reported before complete-case selection, so item and score denominators can be reconstructed. Complete-case analysis can be biased under realistic missingness; do not present this convenient synthetic choice as a solution to missing-data inference. Pairwise covariance estimates may use different respondents and need not form a positive-definite matrix.

Constant items and impossible values should be investigated before running alpha. `delete = FALSE` prevents silent item removal; it does not make a constant item informative. A coefficient for arbitrary ordinal numeric scores is a coefficient for that observed scoring rule. Alpha computed from polychoric correlations concerns underlying responses and is not automatically the reliability of the observed ordinal sum.

## Sources and checked API

- [psych alpha documentation](https://personality-project.org/r/psych/help/alpha.html): key checking, raw/standardized coefficients, item-rest correlations and bootstrap output.
- [McNeish (2018), Thanks coefficient alpha, we'll take it from here](https://doi.org/10.1037/met0000144): reliability assumptions and alternatives.
- [Raykov and Marcoulides (2019), Thanks coefficient alpha, we still need you!](https://pmc.ncbi.nlm.nih.gov/articles/PMC6318747/): conditions under which alpha remains useful.
- [semTools composite reliability](https://rdrr.io/cran/semTools/man/compRelSEM.html): a distinct model-based path, developed in the companion reference.

Executable API checked with psych 2.6.9, dplyr 1.2.1 and tidyr 1.3.2. Numerical evidence and its limits are in the plugin's [validation record](../../../docs/validation.md).
