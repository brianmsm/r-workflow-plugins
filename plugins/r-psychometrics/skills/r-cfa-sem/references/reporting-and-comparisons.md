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

## Match parameter metric and uncertainty

| Choice | Native reference | Interpretation |
| --- | --- | --- |
| `standardized = FALSE` | `parameterEstimates(fit, ci = TRUE, level = ...)` | Original metric and native raw SE/CI |
| `TRUE` or `"std.all"` | `standardizedSolution(fit, type = "std.all", ...)` | Standardizes latent and observed quantities |
| `"std.lv"` | `standardizedSolution(fit, type = "std.lv", ...)` | Standardizes latent variables while retaining observed metrics |
| `"std.nox"` | `standardizedSolution(fit, type = "std.nox", ...)` | Leaves observed exogenous covariates unstandardized |

In a native summary, the SE/z/CI alongside extra standardized columns ordinarily describe raw parameters. Do not attach those raw intervals to standardized coefficients. The psymetrics standardized route calls `standardizedSolution()`, so its uncertainty must be compared with that native function, not with raw `parameterEstimates()`.

For verification, retain parameter identity (`lhs/op/rhs`, and group/level if applicable). psymetrics uses `To/Operator/From` with `Coefficient/SE/CI_low/CI_high/z/p`. Display rounding is separate from the underlying numerical values. Fixed/derived rows can legitimately have zero or unavailable inferential fields; diagnose the actual parameter status before calling them estimation failures.

The known [issue #55](https://github.com/brianmsm/psymetrics/issues/55) labels some raw off-diagonal `~~` rows “Correlation”. Their coefficients remain raw covariances in the checked case. Identify the metric using native operators/values and correct the presentation in the report if needed; do not edit the package. With `std.all`, distinguish total-variable scaling from residual-covariance standardization conventions and inspect native `standardizedSolution()` options before interpretation.

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
- [Satorra and Bentler (2001)](https://doi.org/10.1007/BF02296192): scaled difference testing.

Package-source inspection and numerical checks used lavaan 0.7.3 and psymetrics 0.5.0. The [validation record](https://github.com/brianmsm/r-workflow-plugins/blob/r-psychometrics-v0.1.0/plugins/r-psychometrics/docs/validation.md) distinguishes exact native equivalence, documented limitations and behavioral tests. Online manuals can describe another release; the executed version is the API evidence.
