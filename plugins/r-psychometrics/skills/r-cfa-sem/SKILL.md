---
name: r-cfa-sem
description: "Use when diagramming, specifying, fitting, diagnosing or comparing continuous or ordinal CFA and basic single-level SEM/path models in R with lavaan, including mediation, conditional effects, derived-parameter uncertainty and supported psymetrics reporting. Multigroup invariance, ESEM and advanced latent models require separate workflows."
---

# CFA and Basic SEM

Keep the scientific specification and native estimation visible. This is the technical home for conventional single-group CFA and basic observed-path/latent SEM; the research design still determines what structural coefficients mean.

## Specify Before Interpreting

- Establish the sampling unit, indicator/outcome scales, latent versus observed variables, covariate coding, prespecified paths, missing-data handling and target parameters.
- Identify each latent scale (e.g. a marker loading or `std.lv = TRUE`) and inspect model degrees of freedom, information and parameter plausibility. Positive df alone does not prove identification. A one-indicator or two-indicator factor needs defensible additional information/constraints; do not add arbitrary restrictions to make it run.
- Keep each model's syntax string, `lavaan::cfa()` or `lavaan::sem()` call, and `summary(..., fit.measures = TRUE, standardized = TRUE)` adjacent. Add `ci = TRUE` and `rsquare = TRUE` where relevant, using arguments supported by the installed version.

For creating, interpreting or auditing a path diagram, read [path-diagrams.md](references/path-diagrams.md). A conceptual or diagram-only request can start from the supplied hypotheses or specification without fitting a model.

## Select the Estimation Path

- For continuous CFA, read [continuous-cfa.md](references/continuous-cfa.md). Choose ML/MLR from the analysis assumptions and inference needs; make any likelihood-based missing-data strategy explicit. FIML relies on a defensible missingness/model argument, and missing exogenous covariates require special attention.
- For ordered endogenous indicators, read [ordinal-cfa.md](references/ordinal-cfa.md). Declare their names, use `estimator = "WLSMV"` when appropriate, and retain the identification/parameterization and missing-data policy. Do not request unsupported ordinal FIML or silently apply continuous assumptions. If missingness is unresolved, inspect it before selecting a strategy; an unsupported FIML request does not authorize an automatic switch to pairwise deletion.
- For basic structural equations or indirect effects, read [basic-sem.md](references/basic-sem.md). Specify structural coefficients and derived parameters explicitly. An observed-path model may be saturated; its perfect global fit cannot validate causal assumptions.

For uncertainty in a product, sum, difference or conditional effect defined in a SEM, read [indirect-effects-inference.md](references/indirect-effects-inference.md). Identify the target function and metric before choosing delta, Monte Carlo or bootstrap inference. For moderation in a standalone observed regression, use the ordinary regression workflow.

## Diagnose Before Reporting

- **Verify admissibility:** inspect native warnings, `lavInspect(fit, "converged")`, `lavInspect(fit, "post.check")`, residual/latent variances, covariance matrices and standardized solutions before substantive interpretation. Investigate nonconvergence, inadmissibility, extreme correlations, missing SEs, sparse categories and residual dependence.
- **Check parameter extraction correctly:** `parTable(fit)` has `free` and `se` fields; `parameterEstimates()` does not expose `free`. An empty selection or a working extractor is not evidence of an acceptable solution.
- **Separate verification from reporting:** run one-time diagnostic checks outside the delivered script when possible. Retain the calls when diagnostics are being taught, are substantive research outputs or guard against demonstrated ongoing risks. Explain estimation problems and their consequences instead of showing bare TRUE/FALSE flags.

Report global and local diagnostics with model size, df, sample, estimator and uncertainty. Do not accept/reject a model using universal CFI/RMSEA/SRMR cutoffs. Modification indices and expected parameter changes are exploratory diagnostic information; changes require substantive justification and later validation, not automatic correlated residuals or item deletion.

## Report and Compare on the Correct Metric

Read [reporting-and-comparisons.md](references/reporting-and-comparisons.md) when using psymetrics, distinguishing fit-index families, extracting standardized uncertainty or comparing models.

- **Inspect with lavaan first:** its native `summary(..., fit.measures = TRUE, standardized = TRUE)` is often sufficient. Use `psymetrics::model_fit()` or `psymetrics::model_estimates()` for concise single-model tables only when helpful.
- **Prefer prepared comparisons:** use `psymetrics::compare_model_fit()` to align fit results and `psymetrics::compare_model_estimates()` to align parameters across supported fitted models, instead of manually extracting, joining and formatting equivalent tables. These comparisons are descriptive, not formal model-difference tests or invariance analyses.
- **Distinct communication roles:** retain the native summary for comprehensive model inspection and add a focused `psymetrics` table when it helps report or compare particular results. They may coexist without redundancy; avoid repeating equivalent tables automatically.
- **Keep scaled fit indices as the WLSMV default.** WLSMV's robust SEs and adjusted test statistic do not mean that `cfi.robust`/`rmsea.robust` were reported. Label the chosen family and use those distinct alternatives only deliberately.
- Distinguish raw estimates, `std.lv`, `std.all` and `std.nox`, including their SEs/intervals. In psymetrics 0.5.0, an unstandardized off-diagonal covariance may be labeled “Correlation” ([issue #55](https://github.com/brianmsm/psymetrics/issues/55)); verify the native metric and correct the presentation without modifying the package.
- A side-by-side table is not a test of equality or invariance. Establish nesting, identical observed variables/cases, compatible estimation, constraints and correction before an explicit native difference test. Never subtract scaled chi-square statistics manually. WLSMV does not supply ordinary likelihood AIC/BIC.

## Scope and Delivery

Deliver editable code, native fit objects, the actual sample/estimation choices, estimates and uncertainty, diagnostic findings and supported comparison conclusions. Use optional `r-analytic-coding-principles` for research organization; no sibling installation path is required. Applied expertise owns design/covariate/causal arguments; publishing owns document layout.

Standard continuous/ordinal multigroup invariance and basic unidimensional IRT are a second delivery with separate validation. ESEM, DIF, networks, bifactor/S-1, linking, multilevel/longitudinal SEM, latent interactions, mixtures and survey/MI/latent combinations are deferred. Do not manufacture support for these from a generic reporting API.
