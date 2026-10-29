---
name: r-exploratory-factor-analysis
description: "Use when exploring dimensionality, choosing factor retention and rotation, or fitting continuous or ordinal EFA in R with psych or lavaan. Confirmatory models and ESEM with structural relations use other workflows."
---

# Exploratory Factor Analysis

Match the analysis to a measurement question. EFA models common variance; PCA decomposes total observed variance. Do not silently substitute one for the other.

## Choose the Input and Retention Evidence

1. Establish the item universe, sampling unit, response categories, keying, missingness and whether there is an independent confirmation sample. Inspect sparse categories, near-constant items, pairwise counts and the correlation matrix before extraction.
2. Use Pearson-based common-factor analysis for a justified approximately continuous target. Polychoric/tetrachoric approaches assume latent response distributions and thresholds; integer storage alone does not make an item continuous.
3. Read [retention-and-psych.md](references/retention-and-psych.md) for `psych::fa.parallel()`, `psych::fa()` and interpretation. Combine parallel analysis, scree, residual structure, factor definition, content and replication. Do not select solely by eigenvalues greater than one, a fit cutoff, KMO, Bartlett significance or a cases-per-item rule.
4. If categories are ordered and an ordinal WLSMV analysis is appropriate, read [ordinal-lavaan.md](references/ordinal-lavaan.md). Use the actual item columns with `lavaan::efa(..., ordered = TRUE, estimator = "WLSMV")`; exclude identifiers and covariates from that shorthand.

## Extract, Rotate and Inspect

- Keep factor count, correlation choice, estimator, missing-data rule and rotation visible in each native call. Use distinct fit objects for independently considered solutions and explicit adjacent native model blocks for a small candidate set.
- Justify rotation: correlated constructs usually warrant an oblique criterion such as oblimin. An orthogonal rotation asserts uncorrelated factors; interpretability alone is not a reason to force that assumption.
- Inspect convergence, uniquenesses/Heywood cases, factor correlations, residuals and the full loading pattern. Oblique pattern coefficients and structure correlations are different quantities. Factor sign and order are arbitrary.
- Check stability across meaningful starts or plausible rotations when local solutions are a concern. Record stochastic seeds and settings. Do not call loadings from the same exploratory sample an independent confirmation.
- A standalone `lavaan::efa()` object uses its native summary. For one factor count, `output = "lavaan"` provides a fitted lavaan object for explicit native diagnostics and `summary(..., fit.measures = TRUE, standardized = TRUE)`. Verify the actual class before using any extractor.
- WLSMV uses adjusted inference. Report **scaled** fit indices by default, and identify that family explicitly; the separately named `.robust` indices are an optional, deliberate alternative. Do not assume the EFA overview table chooses the intended family.

## Interpret and Hand Off

Describe the retained alternatives, substantive factor meaning, weak or complex indicators, local dependence, uncertainty and sample limits. Item removal must consider content and replication, not just a loading threshold. Factor scores are estimates with indeterminacy and uncertainty, not observed error-free traits.

Use locally editable native model blocks; optionally combine with `r-analytic-coding-principles`. Item keying/reliability can use `r-item-and-reliability-analysis`; a genuinely prespecified or independently tested structure can use `r-cfa-sem`. Ordinary EFA-only rotated measurement models are in scope. ESEM with structural regressions, complex-sampling/MI combinations and advanced latent structures are deferred. This plugin does not promise psymetrics support for psych objects or the lavaan EFA-list class.
