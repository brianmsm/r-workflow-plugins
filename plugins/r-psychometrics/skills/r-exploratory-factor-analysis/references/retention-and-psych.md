# Retention and EFA with psych

Use for common-factor exploration with approximately continuous indicators, or adapt the correlation model deliberately for categorical items. The example uses independent respondents and complete synthetic data.

## Retention is a judgment supported by evidence

Define the item domain before using numerical screens. Inspect sparse categories, variance, pairwise coverage and positive definiteness. A significant Bartlett test only rejects an identity correlation matrix; KMO and sample-size rules do not certify a solution.

Use common-factor parallel analysis (`fa = "fa"`) and a defensible extraction method, not the PCA default from another function. Match the parallel-analysis correlation choice to the response model: `cor = "cor"` for Pearson or `cor = "poly"` for an ordinal latent-response argument. Report the null-generation/resampling method, number of replications and quantile. Sparse ordinal cells can destabilize polychorics; smoothing or continuity corrections are substantive decisions, not invisible repairs.

Consider adjacent plausible counts using scree, residual correlations, content coverage, sufficiently defined factors and replication. Do not turn `fa.parallel()`'s suggested number into a compulsory answer. A small Monte Carlo run tests the API, not retention uncertainty in a real application.

## Runnable continuous example

The invented population has two correlated domains with four indicators each. It is a known synthetic fixture; knowing its generating structure is not evidence for selecting two factors in a new study.

```r
library(dplyr)

# Transparent population for a small numerical example ----
set.seed(20311)
population_efa <- '
  domain_a =~ 0.8*a1 + 0.7*a2 + 0.9*a3 + 0.6*a4
  domain_b =~ 0.9*b1 + 0.7*b2 + 0.8*b3 + 0.6*b4
  domain_a ~~ 1*domain_a
  domain_b ~~ 1*domain_b
  domain_a ~~ 0.35*domain_b
  a1 ~~ 0.36*a1
  a2 ~~ 0.51*a2
  a3 ~~ 0.19*a3
  a4 ~~ 0.64*a4
  b1 ~~ 0.19*b1
  b2 ~~ 0.51*b2
  b3 ~~ 0.36*b3
  b4 ~~ 0.64*b4
'
efa_items <- lavaan::simulateData(
  population_efa, sample.nobs = 600, meanstructure = TRUE
) |> as_tibble()

# Retention evidence; use a larger justified run for a final analysis ----
set.seed(20312)
parallel_fit <- psych::fa.parallel(
  efa_items,
  fa = "fa", fm = "minres", cor = "cor",
  n.iter = 50, quant = 0.95, use = "complete.obs", plot = FALSE
)
parallel_fit$nfact
parallel_fit$fa.values

# Candidate with one common factor ----
efa_one <- psych::fa(
  efa_items, nfactors = 1, fm = "minres",
  rotate = "none", cor = "cor", use = "complete.obs",
  residuals = TRUE
)
print(efa_one, cut = 0, sort = FALSE)

# Candidate with two correlated common factors ----
efa_two <- psych::fa(
  efa_items, nfactors = 2, fm = "minres",
  rotate = "oblimin", cor = "cor", use = "complete.obs",
  residuals = TRUE
)
print(efa_two, cut = 0, sort = FALSE)
efa_two$Phi
efa_two$Structure
efa_two$uniquenesses
efa_two$residual
```

Oblimin permits the theoretically plausible domain association. Show the complete pattern matrix and factor correlations; a display cutoff would hide small coefficients but would not set them to zero. The structure matrix equals the pattern matrix times the factor-correlation matrix. With oblique factors, squared pattern coefficients alone do not give communalities: use the diagonal of Lambda Phi Lambda-transpose. Factor signs and column order can change across equivalent solutions.

`psych::fa()` can use a matrix input with an appropriate `n.obs`, but a single sample size does not represent heterogeneous pairwise coverage. A polychoric matrix passed to minres is not the same estimator/inference as ordinal WLSMV; use the [lavaan ordinal reference](ordinal-lavaan.md) for that route. MINRES is not maximum likelihood, so its displayed approximations must not be promoted to a general likelihood comparison.

## Diagnostics and interpretation

Inspect negative or boundary uniquenesses, unstable/extreme factor correlations, residual patterns, weakly defined factors and convergence. If a matrix is not positive definite, investigate items, sparse cells and pairwise missingness before altering it. Data-driven deletion can sacrifice construct coverage and capitalize on sampling error.

Factor-score methods have different targets and determinacy. If scores will enter another model, state the scoring method and uncertainty limitations; an EFA score is not an error-free observed variable. Bootstrap/loading stability, rotation sensitivity or an independent confirmation sample may be justified, but are not replaced by one synthetic recovery result.

## Sources and checked API

- [psych fa manual](https://personality-project.org/r/psych/help/fa.html): extraction, rotations, pattern/structure and diagnostics.
- [psych fa.parallel manual](https://personality-project.org/r/psych/help/fa.parallel.html): common-factor/PCA distinction and correlation/null choices.
- [Fabrigar et al. (1999)](https://doi.org/10.1037/1082-989X.4.3.272): consequential EFA design and analysis decisions.
- [MacCallum et al. (1999)](https://doi.org/10.1037/1082-989X.4.1.84): sample adequacy depends on model conditions, not a universal ratio.

Checked with psych 2.6.9 and lavaan 0.7.3. Native loading/structure/residual relationships are tested in the [validation record](https://github.com/brianmsm/r-workflow-plugins/blob/r-psychometrics-v0.1.0/plugins/r-psychometrics/docs/validation.md); this does not establish population recovery for arbitrary applications.
