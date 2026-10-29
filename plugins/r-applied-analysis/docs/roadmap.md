# Roadmap

## First slice: released as 0.1.0

Three skills cover descriptives/comparisons, ordinary linear/binary/count regression and complex-survey inference. Six conditional references contain the editable synthetic examples. [Validation](validation.md) records the tested APIs and evidence limits. Release, catalog registration and cross-host installation remain separate integration work.

Keep improvements driven by real tasks. The next two skills below have procedures and acceptance criteria, but **no implementation directories** in this slice.

## Second stage: r-missing-data

### Boundary

Own the inferential strategy for ordinary incomplete research data, multiple-imputation model construction and pooling of supported scalar estimates. The data-wrangling capability owns recognition/preservation of special missing codes and deterministic preparation. The model-owning capability owns its actual likelihood-based missing-data implementation, including estimator restrictions and treatment of incomplete predictors.

Start with single-level ordinary analyses using `mice`; do not imply joint support for surveys, multilevel imputation, ordinal SEM or latent-variable models. A graph of missingness or a nonsignificant test does not establish MAR. Structural non-applicability is not a value to impute automatically.

### Procedure to implement

1. Define the estimand, eligible sample, incomplete variables, reasons for missingness and scientifically plausible assumptions. Distinguish complete-case sensitivity from an automatically unbiased default.
2. Specify the imputation model visibly: variable types/methods, predictor matrix or formulas, auxiliary variables, outcome inclusion where appropriate, exclusions for identifiers, structural constraints and any passive transformations. Preserve interactions/nonlinearities of the substantive model using an appropriate compatible procedure; merely adding an interaction after imputation is not universal protection.
3. Set reproducible RNG and justify the number of imputations/iterations from stability and Monte Carlo precision. Do not turn package defaults into methodological recommendations.
4. Inspect traces, observed/imputed distributions, plausible values and logged events. Investigate collinearity, unsupported cells and unconverged chains rather than silently accepting output.
5. Fit the same explicit native analysis separately within each imputation. Pool estimates and within-imputation variances with an appropriate rule and complete-data df. For odds ratios, pool log coefficients and their uncertainty before exponentiating.
6. Explain total uncertainty, between/within-imputation components, pooled df and sensitivity to plausible missingness assumptions. Do not pool datasets, p-values or confidence-interval endpoints, or treat one completed dataset as the result.

For a scalar quantity, the first numerical contract is
`Qbar = mean(Q_i)`, `Ubar = mean(U_i)`, `B = var(Q_i)` and
`T = Ubar + (1 + 1/m) * B`, with the applicable df adjustment and interval.
Joint tests, model comparisons, pooled R-squared/fit indices and nonlinear averages each need a separate validated procedure. A generic extractor is not that procedure.

### Minimum acceptance cases

- Known sets of scalar estimates/variances reproduce manual pooling and documented df/intervals.
- A small synthetic incomplete-data analysis runs from explicit imputation settings through native estimates and pooled output.
- A binary-model case preserves the log/odds distinction and df/SE through extraction.
- A case with structural missingness or a substantive interaction exposes an inappropriate blanket-imputation recipe.
- A fresh agent task preserves model locality and does not stack/average imputed datasets for inference.

Primary references: [mice specification](https://amices.org/mice/reference/mice.html), [pooling](https://amices.org/mice/reference/pool.html) and van Buuren's [Flexible Imputation of Missing Data](https://stefvanbuuren.name/fimd/sec-whyandwhen.html). These are design sources, not an executed MI implementation in this delivery.

## Second stage: r-mixed-models

### Boundary

Own basic linear/generalized mixed models for repeated or clustered observations with a defensible dependence structure. A sampling PSU, random-intercept grouping factor, fixed stratum effect and cluster-robust variance estimator address different design/model questions. Their labels are not interchangeable.

Start with `lme4::lmer()` and a bounded `glmer()` case. Introduce `lmerTest`, `nlme`, `glmmTMB` or simulated-residual diagnostics only for a concrete class-specific need. Do not infer survey-weight support from an argument called `weights`.

### Procedure to implement

1. Establish units at each level, cluster counts/sizes, observation timing, target contrast and whether within/between-cluster associations must be separated. State centering choices and the random-intercept/slope structure next to the native formula.
2. Fit an inspectable native model with consequential family, estimator and optimizer choices visible. Check that random slopes have appropriate within-group information.
3. Inspect convergence, singularity, variance/correlation components, residual form and influence at meaningful levels. Singularity and optimization failure are different findings; neither licenses automatic model simplification.
4. Select inference deliberately: model-appropriate Wald, profile/bootstrap or justified df approximation. For comparing different fixed effects in Gaussian mixed models, use a compatible ML comparison on the same data/random structure, not differing REML likelihoods. A random-variance null lies on a boundary and requires suitable comparison logic.
5. State prediction targets separately: conditional on estimated random effects; random effects set to zero; or integrated over their distribution. In a nonlinear GLMM, zeroing random effects and averaging over them need not agree. Specify new-cluster handling, link/response scale and which uncertainty an interval contains.
6. Keep conditional/marginal R-squared and ICC definitions model-specific. No single generic performance index establishes model adequacy or causal interpretation.

### Minimum acceptance cases

- A synthetic random-intercept linear model checks native/extracted fixed effects, uncertainty and variance components; an ICC calculation agrees with its explicit definition.
- A same-sample fixed-effect comparison verifies ML/REML handling and declares its df/test procedure.
- A singular or weakly identified case is reported accurately without automatic deletion.
- A binary mixed-model case distinguishes conditional, zero-random-effect and integrated predictions, including the chosen new-cluster target.
- A fresh agent task preserves separate native model blocks and avoids replacing a complex sampling design with random effects.

Primary references: [lmer](https://lme4.github.io/lme4/reference/lmer.html), [model comparisons](https://lme4.github.io/lme4/reference/merMod-class.html), [prediction](https://lme4.github.io/lme4/reference/predict.merMod.html) and [singularity](https://lme4.github.io/lme4/reference/isSingular.html). Runtime versions may differ from online development documentation; this stage needs its own executed checks.

## Later or separate work

Ordinal/multinomial and negative-binomial references need class-specific examples and extraction checks. Zero-inflated/hurdle systems, survival, advanced causal/predictive models, spatial/small-area inference and survey-plus-MI-plus-multilevel/latent combinations remain outside the initial support claim. Cross-plugin composition and host discovery should be sampled at integration without repeating unrelated historical release gates.
