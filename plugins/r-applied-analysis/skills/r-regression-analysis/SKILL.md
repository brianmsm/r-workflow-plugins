---
name: r-regression-analysis
description: "Use to specify, diagnose and interpret ordinary linear, binary logistic or count regression in R, including interactions and adjusted contrasts. Route probability samples to r-survey-analysis and latent-variable models to a measurement/SEM workflow."
---

# Regression Analysis

Keep the estimand, fitted model and reported quantity distinct and inspectable.

## Specify the analysis

1. Establish the research question, observational unit and target contrast or prediction. Record outcome coding, predictor units/reference levels, adjustment rationale and whether the purpose is descriptive, associational, predictive or causal.
2. Check dependence and sampling. Repeated/clustered records are not automatically independent; sampling weights in `lm()` do not reproduce a complex design.
3. Define the analysis sample and missing-data choice explicitly. Count exclusions for the actual model variables. Do not select covariates by univariate significance, dichotomize continuous predictors for convenience, or let a generic model search replace substantive specification.
4. Choose the family/link and any offset from the outcome and exposure process. Keep interactions and plausible functional form visible. A working fit does not establish causal identification.

## Fit model by model

Use `stats::lm()` or `stats::glm()` with the formula, family, sample, estimation, inspection and outputs adjacent. Use tidyverse preparation (`dplyr`/`tidyr`) and ggplot2 displays; compose with `r-analytic-coding-principles` when available. Keep independently revised models as explicit blocks. Load the packages actually used; avoid package inventories, installation/environment scaffolding, model factories and opaque statistical wrappers unless the task specifically requires them.

- Read [linear-models-and-contrasts.md](references/linear-models-and-contrasts.md) for ordinary linear models, HC3 covariance, interactions and specified adjusted contrasts.
- Read [binary-and-count-models.md](references/binary-and-count-models.md) for binary logit, Poisson/exposure models, a quasi-Poisson alternative and response-scale predictions.

Use `parameters::model_parameters()` and class-appropriate `performance` functions as usual inspection tools. Declare CI method, standardization, exponentiation and covariance choice. Verify estimates, SEs, df and intervals against the native fitted object when introducing an extractor or changing reporting options. Standardizing by refitting is an analytical change; robust covariance changes uncertainty, not the fitted mean.

## Diagnose and communicate

Inspect convergence, rank deficiency/separation, residual structure, influence, dispersion where applicable and the adequacy of the chosen functional form. Diagnostic p-values inform investigation; they do not automatically select or certify a model.

Report the model sample, formula/family/link, adjustment set, coefficient or contrast scale, uncertainty method and material limitations. Distinguish conditional coefficients from adjusted predictions and averages over a stated population. For `emmeans` or `marginaleffects`, specify the reference grid/averaging distribution, weights and link/response scale first. AIC/R-squared cannot rank incompatible outcomes, samples or likelihood definitions.

## Boundaries

Probability-sample inference belongs to `r-survey-analysis`. Basic mixed models and multiple imputation are a documented second stage, not installed skills. Ordinal/multinomial, negative-binomial, zero-inflated/hurdle, survival and advanced causal workflows need their own validated cases before extending this support claim.

Moderation is covered through explicit interactions. Mediation additionally needs temporal/causal assumptions and an interval for the indirect quantity; separate significant regressions do not validate it. Use the technical CFA/SEM capability for path/latent models when available. Measurement modeling and Monte Carlo execution remain separate responsibilities.
