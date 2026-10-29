---
name: r-survey-analysis
description: "Use to estimate population summaries, domain contrasts or regressions from probability samples in R with sampling weights, strata, clusters or replicate weights. Preserve design-based uncertainty with survey; ordinary weighted regression is insufficient."
---

# Survey Analysis

Use `survey` as the inferential reference. Preserve the design from sample declaration through the reported estimate and uncertainty.

## Recover the design

Establish the target population and observational unit; sampling stages; PSU/cluster IDs; strata; final analysis weight; finite-population information if relevant; and any provider-supplied replicate-weight specification. Distinguish inverse-probability/calibrated weights from frequency, precision or arbitrary importance weights.

Use available documentation and existing design objects. If crucial design metadata are unavailable, describe what can be estimated and what uncertainty remains unidentified; do not invent `ids = ~1`, strata, replicate scales or a lonely-PSU remedy. Do not automatically install packages or change the project environment.

## Declare and analyze

- Read [design-and-domains.md](references/design-and-domains.md) for design construction, means/proportions/totals, domain subsetting, missing denominators and a bounded replicate-weight example.
- Read [regression-and-reporting.md](references/regression-and-reporting.md) for design-based regression, contrasts, degrees of freedom and output verification.
- Define the design on the full sampled records covered by the sampling documentation, with valid design metadata; express analytic eligibility and domains using `subset(design, ...)`. Filtering records before rebuilding a design can change its variance calculation.
- Use `svymean()`, `svytotal()`, `svyciprop()`, `svyby()` and `svyglm()` as appropriate. State the Taylor/replicate variance method, df and interval procedure. A weight sum is not an effective sample size.
- Inspect PSUs per stratum, valid design variables, missing outcomes and domain support. A lonely-PSU policy is a substantive variance choice, not a warning-suppression switch.

Keep each model, design/subpopulation choice, native summary, diagnostic and result together. Use tidyverse (`dplyr`/`tidyr`) for preparation and ggplot2 for displays of already design-correct estimates. Optional `srvyr`, `parameters` or `gtsummary` must preserve the chosen quantity and variance method. Compose with `r-analytic-coding-principles` when available; this workflow remains usable independently. Load the packages actually used; avoid package inventories, installation/environment scaffolding, model factories and opaque statistical wrappers unless the task specifically requires them.

## Report and hand off

Separate unweighted records, weighted population estimates, observed-outcome denominators and model sample size. Report weight meaning, stages/strata/clusters, domain definition, variance/df/CI method and missing-data treatment. Inspect native `coef()`, `SE()`, `vcov()`, `confint()` and `summary()` before trusting a formatted table.

Do not replace design inference with `lm(weights = ...)`, ordinary chi-square/t-tests, generic iid diagnostics or an unverified prediction wrapper. Sampling inference does not remove nonresponse, measurement error, confounding or ecological-interpretation problems.

This slice covers Taylor designs and a checked stratified jackknife example; provider-specific replicate schemes need their documented settings. Weight construction/calibration, PPS without-replacement special cases and combinations with imputation, multilevel or latent models require additional joint validation. No dedicated MI or mixed-model skill is implemented yet.
