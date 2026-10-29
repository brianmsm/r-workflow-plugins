# R Psychometrics

Research-editable measurement workflows for R: item diagnostics and reliability, exploratory factor analysis, and conventional CFA/basic SEM.

**Status:** first functional development slice, unreleased. Manifest version `0.0.0` is development metadata, not a public release or a marketplace entry. No invariance or IRT skill is included yet. See the [integration handoff](docs/integration-handoff.md) for the commit identity, verification commands and coordination work.

## Implemented skills

| Skill | Use it for | Detailed support |
| --- | --- | --- |
| [r-item-and-reliability-analysis](skills/r-item-and-reliability-analysis/SKILL.md) | Declared item keys/scores, distributions and reliability evidence | Raw/standardized alpha, item-rest diagnostics, conventional CFA-based reliability on continuous and ordinal score metrics |
| [r-exploratory-factor-analysis](skills/r-exploratory-factor-analysis/SKILL.md) | Dimensional exploration, retention and rotation | `psych::fa()`/`fa.parallel()`; ordinal `lavaan::efa(ordered = TRUE, estimator = "WLSMV")` |
| [r-cfa-sem](skills/r-cfa-sem/SKILL.md) | Confirmatory measurement and basic structural/path models | Continuous ML/MLR, ordinal WLSMV, native diagnostics, supported psymetrics extraction and explicit nested tests |

Invoke a skill explicitly, for example `$r-cfa-sem`, or request its task in ordinary language. Host-specific namespacing and discovery depend on the agent. These instructions can operate independently; `r-analytic-coding-principles` is an optional companion, not an installation dependency.

## Working principles

Keep each model's syntax, native fitting call and `summary(..., fit.measures = TRUE, standardized = TRUE)` together. Preserve item/score definitions, identification, estimators, missing-data handling and uncertainty. Use concise on-demand references with runnable synthetic examples; there is no model factory, automatic installer or statistical wrapper layer.

Native model objects and diagnostics are primary. The verified psymetrics layer uses `model_fit()`, `compare_model_fit()`, `model_estimates()` and `compare_model_estimates()` for supported lavaan classes. Comparison tables are descriptive; inferential model comparisons use explicit valid native procedures.

**WLSMV reports scaled indices by default.** Adjusted tests/SEs and the separately named `.robust` fit-index variants are distinct. The known [psymetrics covariance-label issue #55](https://github.com/brianmsm/psymetrics/issues/55) is documented; this plugin does not modify that package.

## Packages and evidence

Examples were executed with R 4.6.1, psych 2.6.9, lavaan 0.7.3, semTools 0.5.10 and psymetrics 0.5.0. dplyr/tidyr support transparent data work. These are tested versions, not commands to change an existing environment. `mirt` belongs to the next bounded IRT slice and is not required for this delivery.

See [validation](docs/validation.md) for numerical comparisons, negative cases, actual behavioral evidence and remaining limitations. Synthetic checks execute the R blocks in the references, then compare meaningful quantities with native results/formulas:

```sh
Rscript --vanilla plugins/r-psychometrics/tests/synthetic-validation.R plugins/r-psychometrics
Rscript --vanilla plugins/r-psychometrics/tests/independent-ordinal-validation.R
```

The second script uses a separately designed ordinal fixture to check fit families, standardized uncertainty and corrected nesting. Run both commands from the monorepo root, with the listed packages already available. The tests do not install packages or read external datasets. Test assertions belong to this verification script, not to the researcher-facing analysis examples.

## Boundaries

[Architecture](docs/architecture.md) defines ownership and [roadmap](docs/roadmap.md) separates the next delivery from advanced deferred methods. Standard invariance and basic unidimensional IRT require additional validated procedures. ESEM, DIF, networks, bifactor/S-1, linking, mixtures, advanced SEM and survey/MI/latent combinations are not covered by the initial support claim.

Source examples are newly written synthetic cases. Private source collections informed reusable workflow requirements only and are not bundled. Host manifests follow this monorepo's Codex/Claude layout; structural validation is not a claim of end-to-end host installation.
