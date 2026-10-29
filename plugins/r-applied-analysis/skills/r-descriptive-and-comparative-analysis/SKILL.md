---
name: r-descriptive-and-comparative-analysis
description: "Use for research descriptives, explicit missing-value denominators, prespecified group comparisons, or simple correlations in R. For probability-sample inference use r-survey-analysis; for covariate-adjusted models use r-regression-analysis."
---

# Descriptive and Comparative Analysis

Turn the research question into an interpretable summary or contrast, with its usable sample and uncertainty visible.

## Establish the comparison

- Identify the observational unit, target population, outcome scale, group order and intended contrast. Distinguish independent groups, matched pairs and repeated/clustered observations before choosing a procedure.
- Separate eligible records, observed outcomes, complete pairs and the sample used by each test. Report missingness rather than silently treating missing responses as a category or a negative event.
- Decide whether the target is a mean difference, probability contrast, association or rank/distribution comparison. Choose from that question and the design, not from a Shapiro-Wilk or variance-test p-value switch.
- If weights describe a probability sample, carry the design into `r-survey-analysis`. A weighted descriptive mean alone supplies no design-based standard error.

## Estimate and inspect

Use tidyverse operations (`dplyr`/`tidyr`) for visible preparation and native `stats` calls for estimation. Keep each contrast's sample definition, call, result and plot together; compose with `r-analytic-coding-principles` when available, without requiring it. Load the packages actually used; avoid package inventories, installation/environment scaffolding, model factories and opaque statistical wrappers unless the task specifically requires them.

- For distributions, missing denominators, independent/paired means or contingency tables, read [denominators-and-comparisons.md](references/denominators-and-comparisons.md).
- For Pearson/Spearman associations, rank tests or multiplicity, read [correlation-and-rank-methods.md](references/correlation-and-rank-methods.md).
- Use ggplot2 for editable displays. Add `effectsize` when a defined standardized effect helps, or `gtsummary` when a requested table benefits from it. Preserve native estimates and denominators through extraction.
- Inspect shape, influential observations, sparse cells and the sampling structure. Do not delete cases or change outcome definitions merely to improve a test.

## Report and hand off

State the contrast direction, estimate, units, interval level/method, usable N, relevant missingness and any multiplicity adjustment. Distinguish a descriptive SD from an SE or confidence interval. A nonsignificant result does not demonstrate equivalence; an association does not establish causality.

Use regression for adjusted comparisons and interactions. More than two dependent occasions or substantive clustering needs a justified dependence model; the planned `r-mixed-models` skill is not implemented here. Missingness can be described now, but imputation, MAR claims and pooled inference require a separately validated missing-data procedure. Measurement/scoring validity belongs to the appropriate psychometric workflow.
