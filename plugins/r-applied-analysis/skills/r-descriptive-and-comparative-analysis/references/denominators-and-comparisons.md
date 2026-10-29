# Denominators and prespecified comparisons

Read for ordinary sample descriptions, mean contrasts and independent contingency tables. These recipes assume independent sampling units unless pairing is explicitly specified. Probability samples need the survey skill.

## Summaries and an independent mean contrast

Distinguish eligible N, observed N and missing N for each variable and group. A percentage among observed responses and a percentage among all eligible records answer different questions. Report the denominator beside the result; do not count a missing binary outcome as "no." Empty/all-missing groups have no estimable mean or proportion and must remain explicitly unestimable.

This synthetic example targets **A minus B** among observed scores. Available-case summaries and a complete-case test do not correct selection bias from missingness.

```r
library(dplyr)
library(ggplot2)

comparison_data <- tibble::tibble(
  participant = 1:12,
  group = factor(rep(c("A", "B"), each = 6), levels = c("A", "B")),
  score = c(8, 11, 9, 13, 10, NA, 10, 14, 12, 16, 15, NA)
)

score_summary <- comparison_data |>
  group_by(group) |>
  summarise(
    n_eligible = n(),
    n_observed = sum(!is.na(score)),
    n_missing = sum(is.na(score)),
    mean = mean(score, na.rm = TRUE),
    sd = sd(score, na.rm = TRUE),
    median = median(score, na.rm = TRUE),
    q1 = quantile(score, 0.25, na.rm = TRUE),
    q3 = quantile(score, 0.75, na.rm = TRUE),
    .groups = "drop"
  )
score_summary

observed_scores <- comparison_data |>
  filter(!is.na(group), !is.na(score))

welch_fit <- stats::t.test(
  score ~ group, data = observed_scores,
  var.equal = FALSE, alternative = "two.sided", conf.level = 0.95
)
welch_fit
mean_difference <- unname(welch_fit$estimate[1] - welch_fit$estimate[2])
mean_difference
welch_fit$conf.int

distribution_plot <- ggplot(observed_scores, aes(group, score)) +
  geom_boxplot(width = 0.35, outlier.shape = NA) +
  geom_point(position = position_jitter(width = 0.07, height = 0, seed = 41)) +
  labs(x = "Group", y = "Score", caption = "Observed outcomes; 5 of 6 per group") +
  theme_minimal()
distribution_plot
```

Welch inference uses separate variances and approximate df. A pooled-variance t-test needs its substantive assumptions; a preliminary variance test is not a selection algorithm. Examine skew, extremes, sample sizes and sampling before trusting a small-sample interval. An SD describes dispersion; the t-test SE describes uncertainty in the mean difference.

If a standardized contrast is useful, specify the standardizer and small-sample correction before using `effectsize::hedges_g()` or a related method. With unequal variances, pooled SD, reference-group SD and other standardizers define different quantities. Keep the raw difference and do not silently substitute a standardized effect's interval for the Welch interval. No standardized-effect API is required by the example.

## Paired outcomes

Pair by verified participant identity, retain incomplete-pair counts and define the direction. The denominator is the number of complete pairs, not the number of separate measurements. The model concerns the within-pair differences.

```r
paired_data <- tibble::tibble(
  participant = 1:8,
  baseline = c(10, 12, 9, 14, 11, 13, NA, 16),
  followup = c(12, 13, 12, 15, 13, NA, 16, 18)
)
pair_counts <- paired_data |>
  summarise(
    n_eligible = n(),
    n_complete_pairs = sum(!is.na(baseline) & !is.na(followup))
  )
complete_pairs <- paired_data |>
  filter(!is.na(baseline), !is.na(followup))
paired_fit <- stats::t.test(
  complete_pairs$followup, complete_pairs$baseline,
  paired = TRUE, conf.level = 0.95
)
pair_counts
paired_fit
```

For more than two independent groups, `stats::oneway.test(..., var.equal = FALSE)` supplies a Welch omnibus mean test. It does not supply the requested pairwise estimates. For prespecified adjusted contrasts use an explicit model and a compatible covariance/contrast method; do not mix a Welch omnibus test with unexamined homoskedastic pairwise inference. Repeated occasions require the dependence structure, not an independent one-way test.

## Independent categorical outcomes

Check the counts, unit of independence, expected cells and row/column orientation. A chi-square statistic is not an effect size. For two independent binomial proportions, report their difference or another prespecified effect with its interval. Sparse 2-by-2 tables may use Fisher inference, whose odds-ratio estimate is conditional and need not equal the cross-product ratio. Paired binary outcomes require a paired procedure, not these independent tests.

```r
response_counts <- matrix(
  c(18, 32, 30, 20), nrow = 2, byrow = TRUE,
  dimnames = list(group = c("A", "B"), response = c("Yes", "No"))
)
categorical_fit <- stats::chisq.test(response_counts, correct = FALSE)
categorical_fit$expected
categorical_fit

proportion_fit <- stats::prop.test(
  x = response_counts[, "Yes"],
  n = rowSums(response_counts),
  correct = FALSE, conf.level = 0.95
)
proportion_fit
fisher_fit <- stats::fisher.test(response_counts, conf.level = 0.95)
fisher_fit
```

The proportion contrast is A minus B. Continuity correction is an explicit choice here. Neither ordinary test handles stratification or clustering. Do not infer population totals from these sample counts without a justified sampling design.

## Sources and checks

Native R documentation: [t.test](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/t.test.html), [oneway.test](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/oneway.test.html), [chisq.test](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/chisq.test.html), [prop.test](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/prop.test.html), [fisher.test](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/fisher.test.html). See [effectsize standardizers](https://easystats.github.io/effectsize/reference/cohens_d.html) only when that quantity is requested. [R for Data Science: missing values](https://r4ds.hadley.nz/missing-values.html) distinguishes explicit and implicit missingness; it does not establish an inferential missing-data strategy.

Executable examples are checked with R 4.6.1; package versions and numerical/behavioral evidence are in [validation](../../../docs/validation.md). Optional standardizers and publication tables are not numerically certified by these tests.
