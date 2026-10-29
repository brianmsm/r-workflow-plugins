# R Applied Analysis

Portable, research-editable R instructions for descriptive/comparative analysis, ordinary regression and complex-survey inference.

**Status:** an unreleased first implementation. The manifests remain at `0.0.0` until a separately authorized release commit. This plugin has not been added to a public catalog, installed across hosts or published.

## Implemented skills

| Skill | Main task | Bounded initial support |
| --- | --- | --- |
| [r-descriptive-and-comparative-analysis](skills/r-descriptive-and-comparative-analysis/SKILL.md) | Describe distributions, compare groups and estimate simple associations | Explicit denominators; independent/paired means; independent categorical comparisons; Pearson/Spearman and rank methods |
| [r-regression-analysis](skills/r-regression-analysis/SKILL.md) | Specify, diagnose and interpret ordinary models | Linear models, HC3 covariance, interactions, binary logit, Poisson and quasi-Poisson, named contrasts/predictions |
| [r-survey-analysis](skills/r-survey-analysis/SKILL.md) | Preserve sampling-design inference | Taylor designs, domains, means/proportions/totals, Gaussian/quasibinomial survey regression and a stratified jackknife example |

Use a skill explicitly by name or provide a matching research task. Natural-language selection is host-dependent; the validation record distinguishes bounded agent task selection from actual host discovery. Each skill links its conditional references; there is no mandatory router or installation dependency on another plugin.

## Working style and package roles

Keep each model's formula, consequential arguments, estimation, inspection and results together. Use tidyverse for visible preparation and ggplot2 for researcher-authored displays. Native `stats` and `survey` functions own estimation; `parameters` and `performance` provide class-appropriate extraction/diagnostics. The optional `r-analytic-coding-principles` capability complements this workflow.

Use `emmeans`, `effectsize`, `marginaleffects` or a table package when its quantity/output is needed. An odds ratio, probability difference, standardized effect and weighted population estimate are not interchangeable. A polished table must preserve the native sample, scale, variance and interval method.

No automatic package installation, model factories or environment bootstrap is included. Examples are synthetic. The numerical tests require the packages they exercise to be present; see the tested versions in [validation](docs/validation.md).

## Verification

From the repository root:

```bash
Rscript --vanilla plugins/r-applied-analysis/tests/numerical-validation.R plugins/r-applied-analysis
```

The developer test executes the R fences in the references and compares results with independent formulas and native outputs. It is not an analysis orchestrator and never reads user/private inputs. The references remain the editable analysis surface.

See [validation](docs/validation.md) for the actual execution, methodological review, behavioral cases and remaining evidence limits. Manifests follow this repository's Codex/Claude compatibility convention; schema checks alone do not establish host installation.

## Boundaries and next stage

[Architecture](docs/architecture.md) defines task handoffs. [Roadmap](docs/roadmap.md) specifies procedures and validation requirements for `r-missing-data` and `r-mixed-models`; neither has a placeholder skill directory.

Measurement/SEM, Monte Carlo execution, document publishing and data-import semantics have separate homes. Ordinal/multinomial models, advanced causal methods, survival, spatial/small-area analysis and survey-plus-imputation/multilevel/latent combinations are outside the initial support claim. These boundaries describe tested plugin capabilities, not a reason to refuse an otherwise valid user request.
