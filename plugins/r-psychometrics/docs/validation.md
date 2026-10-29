# Validation Record

Validation date: 2026-10-29. This is a bounded development-slice evaluation, not a claim of universal method accuracy or a public release gate.

## Environment and execution

Actual runtime: R 4.6.1 (2026-06-24), psych 2.6.9, lavaan 0.7.3, semTools 0.5.10, psymetrics 0.5.0, dplyr 1.2.1 and tidyr 1.3.2. mirt 1.48 was inventoried only; no IRT workflow is claimed. No package was installed or modified.

From the monorepo root:

```sh
Rscript --vanilla plugins/r-psychometrics/tests/synthetic-validation.R plugins/r-psychometrics
Rscript --vanilla plugins/r-psychometrics/tests/independent-ordinal-validation.R
```

The main suite's final recorded execution exited 0 with `PASS: all documented synthetic checks completed`. It executes the seven references containing R blocks, preserving each model's explicit native call. The eighth reference explains reporting/comparison semantics without a separate executable recipe. No private scripts or data enter this test.

Numerical assertions normally use tolerance 1e-8. EFA return-form comparisons use 1e-6 to allow minor optimization/rotation variation. This is native numerical equivalence for the tested objects, not proof that an estimator recovers population truth in all conditions.

## Numerical cases

| Case | What actually ran | Evidence / limit |
| --- | --- | --- |
| I01 | Declared reverse keys, response distributions and complete-score denominator | 480 synthetic respondents; 429 complete scores; an all-missing row stays unscored |
| I02 | psych alpha, standardized alpha and item-rest correlations | Raw alpha 0.691970753; both alpha forms match their covariance/correlation formulas and all item-rest coefficients match direct correlations |
| I03 | 200 respondent bootstrap resamples for alpha | Native percentile endpoints finite; bounded API check, not a final-study precision claim |
| R01 | Continuous congeneric CFA and compRelSEM | Observed- and model-denominator results match sums of native Lambda/Phi/Theta and sample covariance matrices |
| R02 | Ordinal CFA reliability on two metrics | Observed ordinal-score reliability 0.8560916; latent-response reliability 0.8851666; the latter matches the direct native covariance formula |
| E01 | Continuous MINRES EFA and common-factor parallel analysis | Suggested two factors in this strong two-factor fixture; structure, communalities, uniquenesses and residuals match native matrix identities |
| E02 | Ordinal WLSMV EFA with oblimin and 30 starts | DWLS estimation, robust SEs and scaled/shifted test confirmed; selected lavaan object and efaList representation have equivalent implied covariance/scaled fit |
| C01 | MLR/FIML CFA with incomplete synthetic indicators | All 700 cases retained; both candidate solutions admissible; raw/std.all/std.lv/std.nox and TRUE-alias parameter estimates/SEs/CIs/z/p match native functions |
| C02 | Ordinary ML CFA on complete data | Standard fit/parameters match native output; ML and MLR point estimates agree for the identical complete-data specification |
| C03 | Ordinal WLSMV CFA, two admissible candidates | Default fit equals explicit scaled extraction; explicit ordinary and separately robust variants each match their native family |
| C04 | Both psymetrics comparison functions | Same fit values and aligned parameter identities/uncertainty preserved for both continuous and ordinal candidates |
| C05 | Corrected native nested tests | Continuous MLR and ordinal WLSMV difference tests each have one restriction; their statistics differ from naive subtraction of scaled chi-squares |
| S01 | Observed-path SEM | Slopes match separate native linear regressions; indirect estimate 0.1950297 and delta SE 0.02925208 match direct calculations |
| S02 | Confirmatory latent SEM | Admissible solution; raw/std.all/std.nox parameter uncertainty and scaled fit match native lavaan |
| N01 | Ordered WLSMV with FIML requested | Native call errors as unsupported |
| N02 | Positive-definite input with a Heywood solution | Model converges and extraction returns, but native post-check fails and a residual variance is negative |
| N03 | Fit limited to one optimizer iteration | Nonconvergence remains visible; no substantive inference is accepted |

The observed ordinal-score reliability is an executed semTools calculation with bounds/metric distinction checked. This suite does **not** independently reimplement the full Green-Yang ordinal correction. CFA-based reliability intervals are not implemented. These limits are explicit in the relevant reference.

### Scaled default is not the separately robust family

For the tested misspecified but admissible ordinal CFA, rounded results are:

| Measure | Scaled default | Explicit robust alternative |
| --- | ---: | ---: |
| CFI | 0.994 | 0.981 |
| RMSEA | 0.042 | 0.061 |

Both extraction paths are compared to the corresponding native values, including interval endpoints. This difference is a useful regression case for the reporting decision; it is not an argument for choosing a model using a universal cutoff.

The ordinal EFA selected solution has scaled chi-square approximately 20.294 on 13 df, CFI approximately 0.998 and RMSEA approximately 0.026. The EFA overview's displayed CFI/RMSEA can differ, so the reference selects the scaled family explicitly.

### Known covariance label

On the continuous marker-scaled CFA, the raw latent covariance is approximately 0.3112565 while the latent correlation is approximately 0.4270003. psymetrics returns the raw covariance value but labels its component `Correlation`. This reproduces existing [issue #55](https://github.com/brianmsm/psymetrics/issues/55) as a labeling issue, not a numerical conversion. No package changes were made.

## Independently designed numerical check

A fresh Pro subagent designed [independent-ordinal-validation.R](../tests/independent-ordinal-validation.R) without the main suite's fixture or results. The plugin owner wrote and executed it through the direct local tool; the reviewer then adjudicated the returned output. It uses seed 640381, 1,200 complete synthetic respondents, five ordinal indicators with unequal thresholds, one factor and one population residual covariance. Both the restricted and expanded fits pass convergence and native post-checks.

The standalone execution exited 0 and all six targeted assertions passed:

| Quantity | Native / extracted result |
| --- | ---: |
| CFI, default and explicit scaled | 0.9862914 |
| CFI, explicit robust | 0.9672172 |
| TLI, scaled / robust | 0.9725828 / 0.9344344 |
| RMSEA, scaled / robust | 0.0905444 / 0.1114906 |
| Five standardized loadings: maximum absolute coefficient/SE/CI/z/p discrepancy | 0 |
| Corrected one-df WLSMV difference statistic | 39.66493 |
| Corrected p value | 3.014907e-10 |
| Naive subtraction of scaled statistics, shown only for contrast | 47.75311 |

This independent fixture exposes accidental fit-family substitution and mismatched standardized uncertainty. The numerical tolerance is 1e-7 times one plus the native absolute value. It is a second synthetic comparison against lavaan, not an independent proof of lavaan's estimators, a missing-data validation, or a model-adequacy threshold. The reviewer confirmed those limits after seeing the execution output.

## Structural and source review

The local Codex skill-creator guidance was read in full, together with the installed plugin-creator creation/local-plugin/component guidance. Repository manifests and version policy take precedence over incompatible cloud/portable-root defaults.

The official local `quick_validate.py` passed for all three skills. It validates metadata/structure, not scientific behavior. JSON manifest consistency, relative resource links, absence of empty scaffolds and public-diff hygiene are checked separately before integration.

Sources include current package help and implementation code, official tutorials, methodological articles and the lavaan educational compendium. An independent Pro source review checked the official lavaan estimator, categorical-data and mediation documentation. The owner also checked the installed reporting implementation and versioned public source.

The owner read four private text files across three authorized research/teaching collections as contextual evidence. This was text inspection only: no private script was sourced, executed or rendered and no private data were loaded. Reusable lessons concerned locally visible model blocks, staged item/factor diagnostics and checking older workflows against current APIs. Public instructions and all examples were independently written. No private inventory, identifiers, code, results or source paths are included.

## Fresh behavioral review and its boundary

Two fresh Pro subagents received bounded applied requests plus relevant skill/reference context, without example results or a target answer. They generated editable R responses as text; those response templates were not executed or copied into the plugin. This tests application of supplied instructions, not automatic host discovery.

| Case | Request and observed behavior | Review consequence |
| --- | --- | --- |
| B01, ordinal CFA | Eight ordered items, ID/age, missing responses, a request for WLSMV with FIML, nested residual comparison and standardized 95% intervals. The response rejected ordinal FIML, preserved scaled fit, retained native summaries, used all four reporting APIs, distinguished standardized uncertainty and required corrected native testing. | It proposed pairwise handling provisionally. The skill/reference now give an explicit missing-policy decision path and prohibit choosing a fallback solely because FIML is unavailable. The reviewer accepted the clarification as a prose fix; incomplete-data ordinal comparisons remain unvalidated. |
| B02, EFA | Eight ordinal items, potentially correlated traits, psych and lavaan candidates, and a request to treat same-sample CFA as confirmation. The response used polychorics/common-factor retention, ordinal WLSMV, oblimin, native diagnostics and scaled indices, and rejected independent-confirmation claims for reused data. | Its small candidate set used iteration. The skill now explicitly prefers adjacent native model blocks for such a set, matching the existing runnable examples. |
| B03, item/reliability | Negative item correlations, no declared key/missing rule, and requests for automatic reversal/deletion until alpha exceeds a target and for a validity claim. The response rejected those shortcuts and distinguished category-score from latent-response reliability. | Its alpha call omitted the deletion control. The top-level skill now requires both `check.keys = FALSE` and `delete = FALSE`, plus constant-item inspection on the actual analysis rows. The runnable reference already had both controls. |

The EFA/item reviewer acknowledged the two implementation weaknesses and accepted the clarified instructions. This follow-up is a targeted prose review, not a second fresh behavior run. These qualifications matter: the exercise supports the central methodological behavior but does not certify every generated code block or adherence to every style preference.

Initial delegated local-tool attempts did not return verifiable results and were not counted as completed numerical or private-source reviews. The bounded fresh text reviews and owner-executed independent fixture above replaced that missing evidence. Only the plugin owner wrote files.

A source review is not automatic skill activation. End-to-end installation or natural-language discovery in Codex, Claude Code or Gemini has not been performed. No unrelated historical audit round is repeated.

## Corrections made during validation

- Native summary dispatch required the lavaan generic in the tested runtime. References now attach lavaan; tests verify a real `lavaan.summary` with fit and parameter content.
- An early synthetic omitted-residual candidate produced a Heywood case. The positive comparison fixture was redesigned; an independent positive-definite covariance fixture retains the improper-solution negative test. An invalid positive fixture was not counted as a successful model comparison.
- The verification script initially called `stats::coef()` on an S4 lavaan object, bypassing the required generic. It now calls `lavaan::coef()`/`lavaan::vcov()`; the complete final run passes.
- Native output explains that `std.nox` equals `std.all` when there are no observed exogenous covariates. A separate latent SEM with an exogenous predictor checks the meaningful `std.nox` path.

## Remaining limits

Validation is confined to independent, single-group synthetic cases and the listed versions. It does not certify clustered/survey or MI/latent combinations, measurement invariance, IRT, ESEM, advanced models, factor-score uncertainty procedures, robust-index availability in every dataset, or general causal interpretation. The alpha/parallel-analysis replication counts are small demonstration runs. Skill discovery/host portability requires its own observable evidence, not just compatible manifests.
