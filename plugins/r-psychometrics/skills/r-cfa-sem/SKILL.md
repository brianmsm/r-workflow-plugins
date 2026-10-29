---
name: r-cfa-sem
description: "Use when specifying, fitting, diagnosing or comparing continuous or ordinal CFA and basic single-level SEM/path models in R with lavaan, including supported psymetrics reporting. Multigroup invariance, ESEM and advanced latent models require separate workflows."
---

# CFA and Basic SEM

Keep the scientific specification and native estimation visible. This is the technical home for conventional single-group CFA and basic observed-path/latent SEM; the research design still determines what structural coefficients mean.

## Specify Before Interpreting

- Establish the sampling unit, indicator/outcome scales, latent versus observed variables, covariate coding, prespecified paths, missing-data handling and target parameters.
- Identify each latent scale (e.g. a marker loading or `std.lv = TRUE`) and inspect model degrees of freedom, information and parameter plausibility. Positive df alone does not prove identification. A one-indicator or two-indicator factor needs defensible additional information/constraints; do not add arbitrary restrictions to make it run.
- Keep each model's syntax string, `lavaan::cfa()` or `lavaan::sem()` call, and `summary(..., fit.measures = TRUE, standardized = TRUE)` adjacent. Add `ci = TRUE` and `rsquare = TRUE` where relevant, using arguments supported by the installed version.

## Select the Estimation Path

- For continuous CFA, read [continuous-cfa.md](references/continuous-cfa.md). Choose ML/MLR from the analysis assumptions and inference needs; make any likelihood-based missing-data strategy explicit. FIML relies on a defensible missingness/model argument, and missing exogenous covariates require special attention.
- For ordered endogenous indicators, read [ordinal-cfa.md](references/ordinal-cfa.md). Declare their names, use `estimator = "WLSMV"` when appropriate, and retain the identification/parameterization and missing-data policy. Do not request unsupported ordinal FIML or silently apply continuous assumptions. If missingness is unresolved, inspect it before selecting a strategy; an unsupported FIML request does not authorize an automatic switch to pairwise deletion.
- For basic structural equations or indirect effects, read [basic-sem.md](references/basic-sem.md). Specify structural coefficients and derived parameters explicitly. An observed-path model may be saturated; its perfect global fit cannot validate causal assumptions.

## Diagnose Before Reporting

Inspect native warnings, `lavInspect(fit, "converged")`, `lavInspect(fit, "post.check")`, residual/latent variances, covariance matrices and standardized solutions. Diagnose nonconvergence, inadmissibility, extreme correlations, unavailable SEs, sparse categories and residual dependence before substantive inference. For free-parameter SE checks use `parTable(fit)` fields `free` and `se`; `parameterEstimates()` has no `free` column. An empty selection is not a successful diagnostic. A returned object or successful extractor is insufficient evidence of an acceptable solution.

Report global and local diagnostics with model size, df, sample, estimator and uncertainty. Do not accept/reject a model using universal CFI/RMSEA/SRMR cutoffs. Modification indices and expected parameter changes are exploratory diagnostic information; changes require substantive justification and later validation, not automatic correlated residuals or item deletion.

## Report and Compare on the Correct Metric

Read [reporting-and-comparisons.md](references/reporting-and-comparisons.md) when using psymetrics, distinguishing fit-index families, extracting standardized uncertainty or comparing models.

- Retain the native summary, then use `psymetrics::model_fit()` and `model_estimates()` for supported lavaan objects. Use `compare_model_fit()` and `compare_model_estimates()` for compact descriptive comparisons.
- **Keep scaled fit indices as the WLSMV default.** WLSMV's robust SEs and adjusted test statistic do not mean that `cfi.robust`/`rmsea.robust` were reported. Label the chosen family and use those distinct alternatives only deliberately.
- Distinguish raw estimates, `std.lv`, `std.all` and `std.nox`, including their SEs/intervals. In psymetrics 0.5.0, an unstandardized off-diagonal covariance may be labeled “Correlation” ([issue #55](https://github.com/brianmsm/psymetrics/issues/55)); verify the native metric and correct the presentation without modifying the package.
- A side-by-side table is not a test of equality or invariance. Establish nesting, identical observed variables/cases, compatible estimation, constraints and correction before an explicit native difference test. Never subtract scaled chi-square statistics manually. WLSMV does not supply ordinary likelihood AIC/BIC.

## Scope and Delivery

Deliver editable code, native fit objects, the actual sample/estimation choices, estimates and uncertainty, diagnostic findings and supported comparison conclusions. Use optional `r-analytic-coding-principles` for research organization; no sibling installation path is required. Applied expertise owns design/covariate/causal arguments; publishing owns document layout.

Standard continuous/ordinal multigroup invariance and basic unidimensional IRT are a second delivery with separate validation. ESEM, DIF, networks, bifactor/S-1, linking, multilevel/longitudinal SEM, latent interactions, mixtures and survey/MI/latent combinations are deferred. Do not manufacture support for these from a generic reporting API.
