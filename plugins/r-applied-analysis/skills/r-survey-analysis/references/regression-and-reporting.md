# Survey regression and reporting

Read for associations or contrasts under an already established probability-sample design. Use [design-and-domains.md](design-and-domains.md) to construct/check the design; its synthetic setup supplies `survey_design` for these examples.

## Fit on the design

`svyglm()` uses the design and a design-based covariance. It is not an ordinary weighted GLM with a cosmetic label. A model can have the same point estimates as weighted least squares while its SEs, df and inference differ.

```r
survey_linear_fit <- survey::svyglm(
  score ~ x, design = survey_design,
  family = gaussian(), na.action = na.exclude
)
summary(survey_linear_fit)
survey_linear_ci <- confint(survey_linear_fit, level = 0.95, method = "Wald")
survey_linear_ci
stats::nobs(survey_linear_fit)
df.residual(survey_linear_fit)

survey_linear_parameters <- parameters::model_parameters(
  survey_linear_fit, ci_method = "residual",
  ci = 0.95, standardize = NULL
)
survey_linear_parameters

survey_x_test <- survey::regTermTest(
  survey_linear_fit, ~x, method = "Wald"
)
survey_x_test
```

The native default residual df uses the design and model rank; it is not ordinary records minus parameters. The example's df are 5 although there are 32 records. Normal-reference inference or an alternative df rule is a deliberate analytic choice, especially with few PSUs or individual-level covariates. Do not change the native summary's df and then assume a generic extractor inherited that override.

The checked `parameters` call agrees with native coefficients, SEs, df, Wald intervals and p-values for this fitted class. Preserve the native output when changing class, covariance, df or survey method until agreement is established. Extraction is not a justification for a new standardization/refit procedure.

## A binary model

For a 0/1 event use a logit mean model. `quasibinomial()` avoids a warning about non-integer weighted successes; it does not justify treating sampling weights as frequency counts. Survey robust covariance still determines uncertainty.

```r
survey_binary_fit <- survey::svyglm(
  event ~ x, design = survey_design,
  family = quasibinomial(link = "logit"), na.action = na.exclude
)
summary(survey_binary_fit)
survey_binary_ci <- confint(survey_binary_fit, level = 0.95, method = "Wald")
survey_binary_odds <- exp(cbind(
  estimate = coef(survey_binary_fit),
  survey_binary_ci
))
survey_binary_odds

survey_binary_parameters <- parameters::model_parameters(
  survey_binary_fit, exponentiate = TRUE,
  ci_method = "residual", ci = 0.95, standardize = NULL
)
survey_binary_parameters
```

The slope reports an odds ratio per unit of `x`; the exponentiated intercept is baseline odds. It is not a risk ratio or an average probability effect. Probability contrasts require a specified covariate distribution, averaging weights and design covariance. Separate support for `emmeans`/`marginaleffects` and `svyglm` does not establish that a chosen averaging operation preserves the intended population estimand.

For a domain model, use the established subset design. Count model-complete cases within that domain and state which nonresponse assumptions support interpretation. Do not use ordinary Pearson chi-square or t-tests for survey comparisons; use the relevant native `svychisq()`, `svyttest()` or `regTermTest()` procedure with its documented correction.

## Diagnose the actual problem

Inspect convergence, event coding, separation, influential PSUs, domain support, effective df and mean-model form. Residual plots may help identify a pattern, but iid residual-test p-values do not validate a design. Survey regression does not cure measurement error, confounding or informative outcome nonresponse.

Report model sample N separately from unweighted descriptive/domain N and estimated population totals. Keep sampling design, variance method, coefficient/contrast scale and uncertainty choice in the table or accompanying text. Do not infer causality from adjustment alone.

For requested publication tables, `gtsummary::tbl_svysummary()` can summarize a supported design and `tbl_regression()` may format a model. Verify the actual statistic, denominator and SE/interval used; weighted N and unweighted N must have distinguishable labels. These optional table APIs are not part of the numerical support claim. Likewise, survey AIC and model tests have design-specific definitions; do not feed them into an ordinary-model ranking pipeline without checking comparability.

## Sources and checks

The primary [survey manual](https://cran.r-project.org/web/packages/survey/refman/survey.html) documents `svyglm`, `confint.svyglm`, `regTermTest`, `svychisq` and `svyttest`. Also see [parameters class-specific extraction](https://easystats.github.io/parameters/reference/model_parameters.html) and [gtsummary survey summaries](https://www.danieldsjoberg.com/gtsummary/reference/tbl_svysummary.html).

R 4.6.1, survey 4.5 and parameters 0.30.0 were used for the executable Gaussian and quasibinomial cases. [Validation](https://github.com/brianmsm/r-workflow-plugins/blob/r-applied-analysis-v0.1.0/plugins/r-applied-analysis/docs/validation.md) documents native/extracted agreement and a counterexample to substituting weighted `lm()`. No ordinary iid diagnostic suite, complex prediction averaging or survey-plus-imputation/multilevel combination is certified here.
