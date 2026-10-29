# Research Methods EPIC 01: Package and API Decisions

Status: proposed defaults, 2026-10-29. This is a support-design matrix, not a mandatory package installation list. Documentation and source inspection during planning do not constitute runtime validation of all combinations.

Read with [the EPIC design](research-methods-epic-01.md) and [evidence review](research-methods-evidence-review.md). Each implementation slice must record its tested versions and verify its actual fitted classes.

## Selection Rules

- Prefer the original estimator and model object, with consequential arguments visible.
- Use tidyverse for new data work and ggplot2 for researcher-authored graphics. Keep an appropriate native diagnostic rather than rebuilding it purely for stylistic uniformity.
- Treat `parameters` and `performance` as usual reporting/diagnostic tools for supported models. Their generic names do not establish identical behavior across classes.
- Retain lavaan's native summary and add psymetrics reporting according to the verified API. Do not replace meaningful diagnostics with a polished extraction table.
- Choose a marginal-effects or contrast package according to the estimand. Do not treat differently weighted marginal summaries as interchangeable.
- Attach packages used throughout an analysis; qualify occasional functions. Do not generate a loader for the entire matrix.
- Use primary documentation/source and small numerical checks to resolve API questions. Do not put environment discovery or speculative fallback code into user-facing analyses.

## Data Preparation

| Task | Preferred packages / native operations | Conditional additions | Substantive decision to preserve |
| --- | --- | --- | --- |
| CSV and other delimited text | `readr::read_csv()`, `read_delim()`, explicit types/locale where needed | Other readers only for an actual format or performance requirement | Leading-zero IDs, decimal conventions, date interpretation, missing codes and names |
| Excel | `readxl::read_excel()` | A writer only when an Excel output is required | Worksheet/range, mixed cell types and identifiers represented as numbers |
| SPSS/Stata/SAS imports | `haven` | `labelled` for dictionaries and metadata work | Numeric storage is not measurement level; labels and special missings require interpretation |
| Dictionary and labelled variables | `labelled::look_for()`, label accessors and deliberate factor conversion | Exportable dictionary for a genuine handoff | Preserve original code meanings; do not convert every labelled numeric variable to a factor |
| Selection and recoding | `dplyr`, `forcats`, `stringr`, `lubridate` | `janitor` only for a requested/justified convenience | Reference levels, units, meaningful missing categories, declared scoring keys |
| Uniform transformations | `mutate(across(...))`, explicit native operations | Small invariant helpers when clearer | Uniformity must be real; do not apply the same rule to substantively different items |
| Joins | `dplyr::*_join()`, `join_by()`, `anti_join()` | Native `relationship` constraint for a known cardinality | Correct keys, unit of observation, duplicates, match quality and denominators |
| Long/wide reshaping | `tidyr::pivot_longer()`, `pivot_wider()` | Explicit specifications for genuinely complex names | Participant/occasion/item keys, absent observations and structural versus substantive missingness |
| Deterministic aggregation | `group_by()`/`.by` with `summarise()` | Declared weighted descriptive operations | The target unit and denominator; inferential SEs belong to the appropriate statistical method |
| Uniform file/collection work | `purrr::map()` with `list_rbind()` where appropriate | Native loops for stateful or explicitly requested work | Do not turn independently designed models into a formula-generating batch |
| Derived exports | RDS when R attributes/classes must be retained; delimited output for interchange | A separate dictionary when needed | CSV alone does not retain all R metadata; preserve originals and write to the declared destination |

Primary sources: [readr import](https://readr.tidyverse.org/reference/read_delim.html), [readxl types](https://readxl.tidyverse.org/articles/cell-and-column-types.html), [haven semantics](https://haven.tidyverse.org/articles/semantics.html), [labelled](https://larmarange.github.io/labelled/articles/labelled.html), [dplyr joins](https://dplyr.tidyverse.org/reference/mutate-joins.html), [tidyr pivots](https://tidyr.tidyverse.org/reference/pivot_longer.html), [purrr list combining](https://purrr.tidyverse.org/reference/list_c.html), [R4DS](https://r4ds.hadley.nz/).

Do not establish a global `na.rm = TRUE` replacement policy. A missing-value removal changes the effective sample/denominator and sometimes the estimand. Likewise, do not automatically fill newly absent pivot cells with zero or average duplicate cells simply to make a pivot succeed. An unmatched `case_when()` branch must not silently turn a missing value into the highest or residual substantive category. Row-binding or column-binding does not establish participant/occasion identity.

## Applied Analysis

| Analysis | Native/default estimation | Preferred inspection and communication | Conditional extension / boundary |
| --- | --- | --- | --- |
| Continuous/categorical descriptives | `dplyr` summaries/counts with explicit denominators | ggplot2; `parameters::describe_distribution()` when a compact supported summary is useful | `describe_distribution()` is re-exported from datawizard; `gtsummary` for a requested table |
| Mean comparisons and ordinary ANOVA/contrasts | `stats::t.test()`, `oneway.test()`, `lm()` or the justified native test | `parameters`; `effectsize`; `emmeans` for model-based contrasts | Independent, paired and repeated designs need different procedures; do not choose a test through a normality p-value switch |
| Rank or categorical comparisons | Appropriate `stats` test | Native output plus justified effect estimate/interval | Rank tests change the question; expected-cell structure and pairing matter |
| Ordinary correlations | `stats::cor.test()` or `correlation` for a supported compact workflow | Effect estimate, interval, usable N and ggplot2 display | Pearson/Spearman answer different questions; no causal interpretation from correlation |
| Linear regression | `stats::lm()` | `parameters::model_parameters()`, `performance::model_performance()` and targeted checks | `sandwich`/`lmtest` or `clubSandwich` for a justified variance estimator |
| Binary regression | `stats::glm(..., family = binomial())` | `parameters` on a declared scale; `marginaleffects` for probabilities/contrasts; appropriate diagnostics | Odds ratios, risk contrasts and marginal probabilities are different quantities |
| Count regression | `stats::glm(..., family = poisson())` | `parameters`, `performance`, predicted rates/contrasts | `MASS::glm.nb()` for a justified negative-binomial model; offsets remain visible; zero-inflated/hurdle systems are deferred |
| Ordinal / multinomial outcomes | `ordinal::clm()` / `nnet::multinom()` when their bounded reference is validated | Class-specific `parameters` and predictions/contrasts | Conditional extensions, not implied by ordinary GLM support; check proportional-odds and category semantics |
| Interactions and adjusted comparisons | Visible model interaction terms | `emmeans` or `marginaleffects`, then editable ggplot2 | Declare the reference grid, averaging weights and outcome/link scale |
| Basic linear mixed models | `lme4::lmer()` | Native summary; `parameters`; `performance` for supported R-squared, ICC and diagnostics | `lmerTest` for justified df-based inference; `nlme` for residual covariance structures that require it |
| Basic generalized mixed models | `lme4::glmer()` | Class-specific `parameters`/`performance`; specify prediction target and link/response scale | `glmmTMB` for a justified supported family; `DHARMa` for applicable simulation-based residual checks |
| Survey means, proportions, totals and domains | `survey::svydesign()` / `svrepdesign()`, native `svy*` functions and design-aware subsetting | Native uncertainty; optional `srvyr` syntax; `gtsummary::tbl_svysummary()` for a supported table | Replicate design type, lonely PSU handling, finite-population correction and domain variance are explicit choices |
| Survey regression | `survey::svyglm()` and native inference | `summary()`, confidence intervals and verified `parameters` extraction | Do not substitute weighted `lm()` or generic iid diagnostics; survey AIC/tests retain their own interpretation |
| Ordinary multiple imputation | `mice::mice()`, per-imputation analysis, `mice::pool()` | Native pooling summary; verified `parameters` support for `mira`/`mipo` | Initial support: scalar estimates and uncertainties in validated classes; joint tests, comparisons and fit indices need their own procedure |
| Likelihood-based missing-data handling | The model's supported native likelihood approach | Method-specific diagnostics and sensitivity | It is not a universal replacement for MI; ordered CFA and complex combinations have separate constraints |
| Simple observed mediation/moderation | Explicit regression or the basic SEM workflow | Native estimates, suitable intervals and interpretable contrasts | Distinguish statistical decomposition from a causally identified mediation effect |

Primary sources: [parameters by model class](https://easystats.github.io/parameters/reference/model_parameters.html), [ordinary-model arguments](https://easystats.github.io/parameters/reference/model_parameters.default.html), [MI methods](https://easystats.github.io/parameters/reference/model_parameters.mira.html), [performance](https://easystats.github.io/performance/reference/model_performance.html), [diagnostics](https://easystats.github.io/performance/reference/check_model.html), [emmeans](https://rvlenth.github.io/emmeans/articles/basics.html), [marginaleffects supported models](https://marginaleffects.com/bonus/supported_models.html), [lme4](https://lme4.github.io/lme4/reference/lmer.html), [survey svyglm](https://r-survey.r-forge.r-project.org/pkgdown/docs/reference/svyglm.html), [survey manual](https://r-forge.r-universe.dev/survey/doc/manual.html), [mice pooling](https://amices.org/mice/reference/pool.html), [survey tables](https://www.danieldsjoberg.com/gtsummary/reference/tbl_svysummary.html).

### Reporting choices that require attention

`parameters` is a strong default because it exposes estimates, uncertainty, transformations and model-class methods in concise calls. Keep its choices visible: standardization may refit a model, exponentiation changes the reported scale, and a robust covariance choice changes inference. Verify the actual complete-case/model sample and degrees of freedom instead of treating extraction as merely cosmetic.

`performance` supplies useful model-specific indices and checks. Use it to inspect the fitted model; do not rank models with different outcomes, samples or likelihood definitions as if a single score settled the research question. A visual diagnostic collection is not proof of independence, correct design or causal identification.

`emmeans` and `marginaleffects` are complementary. Reference-grid means with equal cell weights need not equal averages over the observed covariate distribution. Select the target quantity and weighting rule first, then the convenient API. For survey data, verify how the design, weights, covariance and averaging target propagate through a particular prediction method.

Imputation and survey design each need a dedicated workflow. Their conjunction, particularly with multilevel or latent-variable models, is not certified by the separate existence of two generic methods. Keep these combinations outside the first support claim until a joint case passes.

For imputation, specify predictors and methods, inspect chains/distributions and preserve the substantive model's interactions and other structure. Pool estimates rather than stacked or averaged completed data. Visual patterns or a nonsignificant missingness test do not establish MAR. The general missing-data skill explains the strategy; the fitted-model skill owns its actual likelihood implementation and consequential choices about exogenous variables.

For mixed models, distinguish predictions conditional on estimated random effects, predictions with random effects set to zero, and averages over their distribution. These targets can differ, especially on a nonlinear response scale. State which model components change before selecting a comparison procedure, including the role of ML versus REML where relevant. Do not let a generic table label such as population-level decide the estimand.

## Psychometrics and SEM

| Analysis | Preferred computation | Communication | Initial boundary |
| --- | --- | --- | --- |
| Item distributions and declared scoring | `dplyr`, ggplot2; targeted `psych` summaries | Frequencies, missingness and declared item/score metrics | No automatic item reversal, deletion or scoring threshold to maximize a fit/reliability statistic |
| Classical internal consistency | `psych::alpha()` where its target is justified | Native estimates and uncertainty/limitations | Alpha does not establish dimensionality or construct validity |
| Factor-model reliability | `semTools::compRelSEM()` for an appropriate fitted measurement model | Model-specific reliability and assumptions | Exploratory `psych::omega()` and CFA-based reliability are not interchangeable procedures |
| EFA | `psych::fa()`, `fa.parallel()` and appropriate Pearson/polychoric input | Native loading/communality output; `parameters::model_parameters()` for supported psych objects | Separate common-factor analysis from PCA; justify retention, extraction and rotation; lavaan EFA is a conditional future reference |
| Continuous CFA | `lavaan::cfa()` | Native `summary()` plus verified psymetrics | Estimator, scale identification, missing-data policy and admissibility are visible |
| Ordered-item CFA | `lavaan::cfa(..., ordered = ...)` with the appropriate estimator | Native robust fit information and verified extraction | Thresholds and ordered treatment are not an ordinary continuous-data variation; do not request unsupported FIML |
| Basic structural/path models | `lavaan::sem()` | Native summary, structural estimates/intervals and psymetrics report | One technical home in `r-cfa-sem`; no automatic causal interpretation |
| Standard multigroup invariance | `lavaan` models and `semTools::measEq.syntax()` when useful | Native comparisons plus verified fit/estimate comparisons | Continuous and ordinal identification/constraints differ; partial invariance requires a stated rationale |
| Basic unidimensional IRT | `mirt::mirt()` | Native coefficients, fit, information and score summaries | Start with simple dichotomous and polytomous families; psymetrics 0.5.0 does not claim stable mirt support; defer DIF, linking, CAT and multidimensional extensions |
| IRT diagnostics | `mirt::M2()`, `itemfit()`, residual/local-dependence checks and score diagnostics where applicable | Interpretive item/global diagnostic summaries | Test feasibility depends on response structure, available degrees of freedom and statistic assumptions |

Primary sources: [lavaan CFA](https://lavaan.ugent.be/tutorial/cfa.html), [categorical variables](https://lavaan.ugent.be/tutorial/cat.html), [estimators/missingness](https://lavaan.ugent.be/tutorial/est.html), [lavaan Compendium](https://tdjorgensen.github.io/SEM-in-Ed-compendium/), [semTools documentation](https://cran.r-project.org/package=semTools), [psych documentation](https://cran.r-project.org/package=psych), [mirt model fitting](https://philchalmers.github.io/mirt/docs/reference/mirt.html), [mirt item fit](https://philchalmers.github.io/mirt/docs/reference/itemfit.html), [psymetrics source](https://github.com/brianmsm/psymetrics).

### Native lavaan inspection

The native summary is a primary researcher inspection surface. Include fit information, standardized results and R-squared where relevant; request intervals deliberately when needed. Use argument spelling supported by the validated version. Current online tutorials may use newer names than an installed release.

Keep a model's syntax, fitting call and summary adjacent. Show the estimator, ordered-item set, identification and missing-data choice at the fitting call. Inspect convergence, warnings, improper solutions and parameter plausibility before interpreting fit indices. Model fit alone does not settle substantive model adequacy.

### psymetrics integration: inspected 0.5.0 source

The public website and source declare version 0.5.0. The observed `master` commit was `85cd7b7e24d112ecd8c93e8a1b49f59e8680d30c`. Stable support is centered on lavaan CFA/SEM. Additional psych/mirt classes and measurement-invariance helpers are marked as development work. This review inspected source and documentation; it did not execute these functions or establish a locally installed version.

| API | Relevant verified defaults | Meaning for the skill |
| --- | --- | --- |
| `model_fit(fit, ...)` | lavaan method: `type = NULL`, `metrics = "essential"`, `test = "default"`, `standard_test = FALSE`, `test_details = FALSE` | Default type selects scaled indices for a robust estimator; this is not the same as requesting the `.robust` variants. Make the intended index type explicit. |
| `compare_model_fit(...)` | Same fit-selection controls; at least two models | Extracts and stacks model-fit results. It does not perform a likelihood-ratio test or calculate inferential evidence of invariance. |
| `model_estimates(fit, ...)` | lavaan method: `standardized = FALSE`, `ci = 0.95`, `component = "all"` | `TRUE` selects `std.all`; other supported choices include `std.lv` and `std.nox`. Standardized extraction uses `standardizedSolution()` and its inference; raw extraction uses `parameterEstimates()`. |
| `compare_model_estimates(...)` | `standardized = FALSE`, `ci = 0.95`, `component = "all"`, `select = "ci"` | Aligns parameters by structural identity including group/level. `select = "se_p"` changes displayed statistics. Side-by-side output is not a test of equality of parameters. |

All four functions are a preferred convenience layer for their supported fitted classes. Preserve the native model object, and select compact versus comprehensive reporting deliberately. Tests between models remain explicit native or semTools procedures whose nesting, sample, estimator and correction requirements have been established. The `test` argument in fit extraction selects a test already contained in a fitted object; it does not change this boundary.

One source-level interpretation issue needs a focused future check: the current component mapping labels off-diagonal `~~` relations as `Correlation` even for unstandardized extraction. Such coefficients can be covariances. Interpret their metric from the extraction mode and native object, rather than from that label alone. This observation concerns labeling; it is not evidence of an incorrect numerical transformation. Any package correction is separate from implementing these plugins.

Before shipping, execute small CFA/SEM cases comparing selected ordinary/scaled/robust values, raw/standardized estimates and uncertainty with native lavaan output. Include a nonconverged or inadmissible model. Do not treat a table of fit indices as proof of measurement invariance.

Primary evidence: [current scope](https://brianmsm.github.io/psymetrics/), [fit source](https://github.com/brianmsm/psymetrics/blob/85cd7b7e24d112ecd8c93e8a1b49f59e8680d30c/R/model_fit-lavaan.R), [fit comparison](https://github.com/brianmsm/psymetrics/blob/85cd7b7e24d112ecd8c93e8a1b49f59e8680d30c/R/compare_model_fit.R), [estimate source](https://github.com/brianmsm/psymetrics/blob/85cd7b7e24d112ecd8c93e8a1b49f59e8680d30c/R/model_estimates-lavaan.R), [estimate comparison](https://github.com/brianmsm/psymetrics/blob/85cd7b7e24d112ecd8c93e8a1b49f59e8680d30c/R/compare_model_estimates.R), [parameters structural methods](https://easystats.github.io/parameters/reference/model_parameters.principal.html).

## Simulation Methods

| Task | Preferred approach/package | Conditional alternative | Required evidence |
| --- | --- | --- | --- |
| Study specification | ADEMP written beside the intended analysis | A short reusable worksheet | Truth, estimands, assumptions, comparisons and performance definitions are explicit |
| Data generation | Native R distribution functions; `lavaan::simulateData()` or `mirt::simdata()` for their actual model class | A domain-specific generator only when its DGP is required | Declare which parameters and latent values stay fixed versus vary across replications; preserve the intended estimand |
| Condition construction and replication | `SimDesign::createDesign()` and `runSimulation()` with visible Generate/Analyse/Summarise functions | A small native/purrr loop for a genuinely tiny study | One generated dataset is evaluated consistently across the intended methods |
| Randomness and parallel execution | The chosen framework's reproducible RNG support | `future.apply` with explicit reproducible RNG when a separate runner is justified | No implicit wall-clock seeds; verify scheduling/worker/restart behavior actually promised |
| Bias, empirical SE, model SE, RMSE, coverage and rejection | SimDesign summaries or `rsimsum` for a compatible result structure | Explicit transparent formulas for the required metrics | Denominators, failure conditions and Monte Carlo uncertainty are reported |
| Failure/admissibility accounting | Explicit per-replication/method status and preserved warning categories | Framework error capture when its retry semantics match the estimand | A failed fit is an outcome to count, not silently replace until the run succeeds |
| Performance displays | `dplyr` summaries and editable ggplot2 | Specialized plots when they materially help comparison | Plot labels state the condition and uncertainty target |

Primary starting sources: [ADEMP and simulation design](https://doi.org/10.1002/sim.8086), [SimDesign](https://github.com/philchalmers/SimDesign), [runSimulation reference](https://philchalmers.github.io/SimDesign/reference/runSimulation.html), [error handling](https://philchalmers.github.io/SimDesign/articles/Catch_errors.html), [mirt generation](https://philchalmers.github.io/mirt/html/simdata.html), [rsimsum](https://ellessenne.github.io/rsimsum/), [future.apply RNG](https://future.apply.futureverse.org/reference/future_lapply.html).

The inspected SimDesign documentation regenerates data after errors and uses `max_errors` to limit consecutive failures. This is useful for debugging or rejecting a deliberately invalid DGP draw, but it must not silently redefine a fixed-attempt estimator evaluation as a study conditional on successful fits. Record method-level failure outcomes without accidentally requesting a new dataset. Test the chosen handling with a deliberately failing method. Likewise, rsimsum excludes missing estimates by default, so its useful Monte Carlo summaries need an explicit accounting of attempted, failed and usable replications.

For a future.apply alternative, declare reproducible RNG explicitly. The documented default is `future.seed = FALSE` for `future_lapply()` and `TRUE` for `future_replicate()`. Setting a master seed alone does not establish the intended parallel contract. Keep resampling uncertainty within a dataset distinct from Monte Carlo uncertainty across simulated datasets, and distinguish conditional from unconditional parameter-recovery studies.

A simulation engine is a legitimate place for functions, controlled iteration and checkpointing. Keep the scientific DGP, model calls and estimands inspectable within that structure. Do not generalize its architecture into ordinary exploratory analysis scripts.

## Packages That Are Conditional or Deferred

`data.table`, Arrow, DuckDB/dbplyr, `targets`, `drake`, tidymodels, mlr3, Bayesian stacks, advanced SEM/IRT extensions and external licensed-software execution may all be appropriate for later or explicit tasks. They are not required by this EPIC. Likewise, `broom`, `modelsummary`, `gtsummary`, `gt`, `flextable`, `see`, `DHARMa` and `semPlot` should be selected for a concrete extraction/display requirement rather than attached together by default.

Preserve an existing justified package choice when revising user work. A preference for a compact default stack is not permission to migrate models or change numerical meaning without review.
