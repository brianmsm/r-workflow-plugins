# Correlation, ranks and multiplicity

Read when the question concerns association or a rank/distribution contrast. State the observational unit, usable paired N and target parameter. These procedures assume independent units; repeated measurements, probability samples and covariate-adjusted questions need their own models.

## Pearson and Spearman

Pearson targets linear association; Spearman targets association between ranks. Inspect a scatterplot for nonlinear structure, range restriction, outliers and subgroups. A monotone association need not be linear. Do not select a correlation solely from a normality-test p-value.

```r
library(dplyr)
library(ggplot2)

association_data <- tibble::tibble(
  x = 1:10,
  y = c(2, 3, 3, 5, 6, 7, 7, 9, 10, NA)
)
association_pairs <- association_data |>
  filter(!is.na(x), !is.na(y))
association_n <- nrow(association_pairs)

pearson_fit <- stats::cor.test(
  association_pairs$x, association_pairs$y,
  method = "pearson", conf.level = 0.95
)
association_n
pearson_fit

spearman_fit <- stats::cor.test(
  association_pairs$x, association_pairs$y,
  method = "spearman", exact = FALSE
)
spearman_fit

association_plot <- ggplot(association_pairs, aes(x, y)) +
  geom_point() +
  labs(x = "Predictor", y = "Outcome", caption = "9 complete observation pairs") +
  theme_minimal()
association_plot
```

The native Pearson interval uses Fisher's transformation under its assumptions. `cor.test()` does not supply a Spearman confidence interval; do not relabel the Pearson interval or infer one from a generic extractor. The example uses approximate Spearman inference because there are ties. A requested rank-correlation interval needs a justified, separately checked method (for example, a resampling scheme matching the independent sampling unit). Report when an interval is unavailable.

In a matrix of correlations, pairwise deletion can change N across cells and need not yield a positive-semidefinite matrix. Name the missing-data policy and the family of tests; do not present every cell as if it came from one common sample.

## Rank comparisons

The independent Wilcoxon rank-sum/Mann-Whitney procedure concerns distributions/ranks. Interpreting it as a median difference requires additional equal-shape/location-shift assumptions. A shift interval is for the Hodges-Lehmann location quantity, not automatically the difference between the two sample medians. Signed-rank inference additionally relies on a suitable symmetric distribution of within-pair differences; it is not the independent rank-sum test.

```r
rank_a <- c(1, 2, 2, 4, 5, 6)
rank_b <- c(2, 3, 4, 4, 6, 8)
rank_fit <- stats::wilcox.test(
  rank_b, rank_a, paired = FALSE,
  exact = FALSE, correct = TRUE, conf.int = TRUE, conf.level = 0.95
)
rank_fit
```

This is B relative to A, with ties and an explicitly approximate, continuity-corrected procedure. Inspect warnings and attainable coverage for small or degenerate samples. A standardized rank effect, a probability-of-superiority effect and a shift estimate are different estimands.

## Multiplicity

Declare the family before adjustment: several planned group contrasts, multiple outcomes or a correlation matrix are different families. Use an appropriate familywise or false-discovery procedure according to the research aim, and distinguish confirmatory from exploratory work. `stats::p.adjust()` adjusts p-values; it does not automatically adjust confidence intervals.

For model-based simultaneous contrasts, keep the family, `by` groups and interval procedure explicit in `emmeans`. Treating each subgroup as a separate family can change the inference. Do not invent a multiplicity family from unrelated analyses just to apply a uniform correction.

## Sources and checks

See native [cor.test](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/cor.test.html), [wilcox.test](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/wilcox.test.html), [p.adjust](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/p.adjust.html) and [emmeans confidence intervals and tests](https://rvlenth.github.io/emmeans/articles/confidence-intervals.html).

R 4.6.1 executes these examples. Pearson coefficients/intervals and the Wilcoxon statistic are checked against independent calculations in [validation](../../../docs/validation.md); Spearman interval estimation is outside this slice.
