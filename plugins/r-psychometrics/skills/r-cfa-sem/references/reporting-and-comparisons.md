# Reporting, Fit Families and Model Comparisons

Read when extracting fit/parameters with psymetrics or comparing fitted CFA/SEM models. The executable continuous and ordinal references retain native model calls, summaries and all four reporting functions.

## Supported surface

This delivery validates psymetrics 0.5.0 on conventional single-group lavaan CFA and basic SEM. Its website marks psych/mirt support as development work. Neither a generic function name nor a shared class establishes support for EFA lists, IRT, multilevel, mixtures, invariance or multiply imputed analyses.

A valid extraction can still describe an inadmissible model. Inspect convergence and native post-checks first. Do not interpret the table's `converged` field as proof of positive variances, identification or substantive adequacy.

| Function | Role | Consequential arguments |
| --- | --- | --- |
| `model_fit(fit)` | Compact fit summary | `type = NULL`, `metrics = "essential"`, `test = "default"`, `standard_test = FALSE`, `test_details = FALSE` |
| `compare_model_fit(first = fit1, second = fit2)` | Stack fit summaries with model labels | Same family/test-selection controls; no inferential difference test |
| `model_estimates(fit)` | Extract coefficients and their uncertainty | `standardized = FALSE`, `ci = 0.95`, `component = "all"` |
| `compare_model_estimates(first = fit1, second = fit2)` | Align corresponding parameters side by side | Same metric/CI controls; `select = "ci"` or `"se_p"` affects display |

**Choose the shortest supported output path.** For one model, a native `lavaan` summary may be enough; use `model_fit()` or `model_estimates()` when focused tables help. For comparing two or more fitted models, prefer `compare_model_fit()` or `compare_model_estimates()` instead of manual `fitMeasures()`/`parameterEstimates()` extraction, joins and table formatting. Keep native extraction for diagnostics, unsupported quantities or deliberate instruction in the lower-level API. Do not print several equivalent representations by default.

The comparison function aligns structural identities, not just row positions. Missing parameters in one model remain absent. A table of two estimates is not a test of their difference; estimates from the same respondents are generally dependent.

## Preserve the intended fit family

| Requested family | Example selection | Native targets for CFI/TLI/RMSEA |
| --- | --- | --- |
| Ordinary | `type = "standard"` | `cfi`, `tli`, `rmsea` |
| Scaled, the WLSMV default | Omit `type`, or explicitly `type = "scaled"` | `cfi.scaled`, `tli.scaled`, `rmsea.scaled` |
| Separately corrected robust alternative | Explicit `type = "robust"` | `cfi.robust`, `tli.robust`, `rmsea.robust`, where available |

WLSMV parameter estimation uses DWLS while its standard errors and test statistic are adjusted. That does **not** require switching the reported fit-index family to `.robust`. Preserve the scaled default, explain the family in the table note, and change it only for an explicit, justified analysis choice.

Scaled indices substitute adjusted test quantities into their definitions; separately named robust indices use additional corrections. Their numerical difference depends on estimator, baseline model and data. The latter can be unavailable under problematic ordinal correlation information; an unavailable index is not evidence of good fit. Do not silently substitute another family. SRMR does not acquire a `.scaled` or `.robust` suffix in these examples.

The tested package's essential output uses generic display names such as `CFI` and `RMSEA`, so preserve the family in prose or table metadata. The native summary may display several families at once. RMSEA intervals and parameter intervals also have separate levels: native RMSEA defaults to 90%, while `model_estimates(ci = 0.95)` requests 95% parameter intervals.

`test` selects an existing fitted-object test; it does not perform a new test between models. Multiple requested tests can create multiple rows per model. Inspect `test_details = TRUE` when test provenance is ambiguous. `standard_test = TRUE` can add an ordinary row, which must not be confused with the primary adjusted row. Explicit ordinary extraction from a WLSMV fit is a sensitivity/reporting choice, not the recommended default.

### Read the estimator, uncertainty and test separately

In psymetrics 0.5.0, the compact `ESTIMATOR` column can show the test name for a noncanonical combination. With `test_details = TRUE`, the detailed row exposes `ESTIMATOR`, `TEST` and `SE` separately. These labels describe the display convention for the same extracted fit measures.

| Fitted options in lavaan 0.7.3 | Compact `ESTIMATOR` | Detailed `ESTIMATOR` / `TEST` / `SE` |
| --- | --- | --- |
| ML, bootstrap SEs, Yuan–Bentler Mplus test | `yuan.bentler.mplus` | `ML_variant` / `yuan.bentler.mplus` / `bootstrap` |
| DWLS, bootstrap SEs, scaled-shifted test | `scaled.shifted` | `DWLS_variant` / `scaled.shifted` / `bootstrap` |

Retrieve the effective fitting options with `lavaan::lavInspect(fit, "options")` and the available tests with `lavaan::lavInspect(fit, "test")`. Report the estimation method, SE method, test and index family from those settings and the selected row. A hybrid bootstrap SE configuration can coexist with a scaled test statistic. In the verified hybrid examples the compact and detailed tables both retained the native scaled indices. A conventional WLSMV fit uses DWLS with robust SEs and the scaled-shifted test. Check those options before assigning an estimator name to a hybrid fit.

## Match parameter metric and uncertainty

| Choice | Native reference | Interpretation |
| --- | --- | --- |
| `standardized = FALSE` | `parameterEstimates(fit, ci = TRUE, level = ...)` | Original metric and native raw SE/CI |
| `TRUE` or `"std.all"` | `standardizedSolution(fit, type = "std.all", ...)` | Standardizes latent and observed quantities |
| `"std.lv"` | `standardizedSolution(fit, type = "std.lv", ...)` | Standardizes latent variables while retaining observed metrics |
| `"std.nox"` | `standardizedSolution(fit, type = "std.nox", ...)` | Leaves observed exogenous covariates unstandardized |

In a native summary, the SE/z/CI alongside extra standardized columns ordinarily describe raw parameters. Do not attach those raw intervals to standardized coefficients. The psymetrics standardized route calls `standardizedSolution()`, so its uncertainty must be compared with that native function, not with raw `parameterEstimates()`.

For verification, retain parameter identity (`lhs/op/rhs`, and group/level if applicable). psymetrics uses `To/Operator/From` with `Coefficient/SE/CI_low/CI_high/z/p`. Display rounding is separate from the underlying numerical values. Fixed/derived rows can legitimately have zero or unavailable inferential fields; diagnose the actual parameter status before calling them estimation failures.

### Read covariance labels by row

psymetrics 0.5.0 assigns the “Correlation” component to every off-diagonal `~~` row based on the operator and variable names. Check the native metric for both variables, including the following verified cases. [psymetrics issue #55](https://github.com/brianmsm/psymetrics/issues/55)

| Requested metric | How to read an off-diagonal `~~` row |
| --- | --- |
| Raw | A covariance in the product of the two variables' units. |
| `std.lv` | An observed–observed row retains the raw covariance. A latent–latent row can be a correlation when both variables are scaled by the relevant SDs. A row with just one scaled variable is in mixed units. |
| `std.nox` | A pair of observed exogenous variables kept at their native scales retains the raw covariance. A row with one unscaled variable requires row-specific interpretation. In lavaan 0.7.3, `std.nox` and `std.all` coincide with no observed exogenous covariates or with `fixed.x = FALSE`. |
| `std.all` | With the default `cov_std = TRUE`, modeled residual covariances are divided by the corresponding residual SDs. Label these as residual correlations. `cov_std = FALSE` uses model-implied total-variable SDs instead, yielding a differently scaled residual covariance. |

For a table containing different scales, use a neutral heading such as “Covariances and correlations” and label each row's metric. A fixed-exogenous sample covariance or correlation may have zero SE and no test. Consult the native output and fitted options before assigning a label or interpreting the uncertainty.

### Record interval provenance for defined parameters

`ci = 0.95` in psymetrics specifies a confidence level. The fit and the native extractor determine how the interval is computed. The following behavior was checked with lavaan 0.7.3 and psymetrics 0.5.0 on continuous, single-level models.

| Fit or calculation | Raw `:=` interval | Standardized `:=` interval |
| --- | --- | --- |
| Default analytic inference | `parameterEstimates()` uses first-order delta SEs from the fit's parameter covariance and symmetric normal-reference limits. | `standardizedSolution()` uses delta SEs for the requested transformation and symmetric normal-reference limits. |
| Native Monte Carlo | Fit with `se_def = "monte.carlo"` and a `monte_carlo` list. The raw extractor uses the simulated definition's spread for SEs and its percentiles for limits. | For the checked fit, `standardizedSolution()` took percentiles after standardization within each draw. The displayed standardized SE/z/p still matched the delta output in lavaan 0.7.3. Cite the interval procedure separately and verify the inference columns before presenting them together. |
| Ordinary ML bootstrap | Fit with `se = "bootstrap"`, then extract on the original metric. The default `boot_ci_type = "perc"` uses percentile bounds of the refitted definition. | In lavaan 0.7.3, `standardizedSolution()` transforms the stored free-coefficient draws under the fitted model’s scaling assumptions and defaults to percentile bounds. Check installed support before applying this to an earlier version. |

With observed exogenous X and `fixed.x = TRUE`, the native transformation can retain the original X variance across draws. Recomputing sample SDs in every bootstrap refit can therefore give a different interval despite matching raw indirects. State whether the target conditions on the observed predictor moments or includes their sampling variation and verify the standardization against that target.

Use the native extractor when requesting nondefault bootstrap intervals or covariance scaling. In psymetrics 0.5.0, the lavaan method accepts `...` without forwarding these extraction arguments. A bootstrap or Monte Carlo interval can be asymmetric. The reported z and p use a normal-reference calculation and can yield a different decision from the interval. Verify the definition on the standardized metric before reporting its output. A simple product of fully standardized linear paths gives the indirect association in outcome SDs per predictor SD. In more general expressions, standardizing the labeled paths can change the meaning of a sum, contrast or fixed moderator value. State the interval level, method, estimator/covariance basis, and metric in the report.

`semTools::monteCarloCI()` calculates intervals separately from the lavaan extractors. Its `standardized = TRUE` route evaluates the definition on fully standardized path estimates using their joint asymptotic covariance. Native lavaan Monte Carlo draws raw estimates then standardizes within each draw, so verify the target and expect possible differences in bounds. For setting draws and seeds, judging interval stability and choosing a compatible resampling design, see [inference for derived effects](indirect-effects-inference.md).

## Separate descriptive and inferential comparison

Before a nested test, establish that both models are admissible, use the same observed variables/categories and respondents, and have compatible estimators, mean/threshold treatment and identification. Show how the restricted model follows from constraints in the less restricted model. A different item set changes the model's data and is not a routine nested comparison.

- Ordinary ML: an appropriate unadjusted likelihood-ratio test is available for eligible nested models.
- MLR: use the appropriate scaled difference procedure; the continuous example explicitly uses `lavTestLRT(..., method = "satorra.bentler.2001")`. If its approximation is problematic (including a negative statistic), investigate nesting/identification and an appropriate alternative, not manual truncation.
- WLSMV: the validated same-sample covariance-restriction example uses `lavTestLRT(..., method = "satorra.2000")`. Preserve the native correction and note; do not subtract the separately scaled model chi-squares.
- Unrelated or nonnested models: fit tables remain descriptive. Likelihood criteria require compatible likelihoods/data; ordinary AIC/BIC are unavailable for WLSMV.
- Invariance: a series of fit tables or delta-CFI values is not by itself evidence of comparable measurement. Threshold/scale/mean constraints need the separately planned invariance workflow.

## Primary sources and evidence

- [psymetrics scope](https://brianmsm.github.io/psymetrics/) and [fit comparison reference](https://brianmsm.github.io/psymetrics/reference/compare_model_fit.html).
- Versioned source: [fit extraction](https://github.com/brianmsm/psymetrics/blob/v0.5.0/R/model_fit-lavaan.R), [parameter extraction](https://github.com/brianmsm/psymetrics/blob/v0.5.0/R/model_estimates-lavaan.R), [parameter comparison](https://github.com/brianmsm/psymetrics/blob/v0.5.0/R/compare_model_estimates.R).
- [lavaan fitMeasures](https://search.r-project.org/CRAN/refmans/lavaan/html/fitMeasures.html), [standardizedSolution](https://search.r-project.org/CRAN/refmans/lavaan/html/standardizedSolution.html) and [lavTestLRT](https://search.r-project.org/CRAN/refmans/lavaan/html/lavTestLRT.html).
- [lavaan mediation tutorial](https://lavaan.ugent.be/tutorial/mediation.html), [lavaan 0.7-3 extraction source](https://github.com/cran/lavaan/blob/0.7-3/R/lav_object_methods.R) and [semTools Monte Carlo reference](https://search.r-project.org/CRAN/refmans/semTools/html/monteCarloCI.html).
- [Satorra and Bentler (2001)](https://doi.org/10.1007/BF02296192): scaled difference testing.

Package-source inspection and numerical checks used lavaan 0.7.3 and psymetrics 0.5.0. [Reporting metric validation](../../../tests/reporting-metric-validation.R) checks the hybrid fit labels, covariance metrics and raw/standardized interval provenance. The [original validation record](https://github.com/brianmsm/r-workflow-plugins/blob/r-psychometrics-v0.1.0/plugins/r-psychometrics/docs/validation.md) covers the initial fit and comparison checks. Check the installed version against online manuals before applying a version-specific procedure.
