# R Psychometrics Architecture

## Current responsibility

The plugin owns measurement decisions, not general data engineering or a new statistical API. Three task-oriented skills separate item/score reliability, exploratory factor structure and confirmatory/basic structural modeling.

Each skill has concise activation instructions and conditional references. References keep substantive assumptions, native calls and interpretation together. Necessary instructions remain inside the plugin; consumers do not need root contributor documents, private collections or a sibling plugin's filesystem path.

The technical SEM home is `r-cfa-sem`. An observed-path model can use it without pretending to contain a measurement model. Research design, covariate rationale and causal interpretation remain substantive applied-analysis questions.

## Components that exist

- Three skills and eight method references.
- Codex and Claude compatibility manifests using the repository's existing layout.
- Plugin documentation separating support, roadmap, validation and integration handoff.
- A main synthetic verification script that executes documented examples and checks native numerical identities, plus a separately designed ordinal regression check.

No generic router, custom estimator/extractor, external server, empty skill directory, generated analysis scaffold or automatic environment setup is included. Verification helpers are test mechanics, not an analysis API.

## Composition

| Neighboring capability | Boundary |
| --- | --- |
| R coding principles | Optional support for local editability; this plugin's examples already preserve native model blocks |
| Data preparation | Import, type/label integrity and implementing declared recodes; measurement validity and score rules remain here |
| Applied analysis | Sampling/design, covariate/causal arguments and general missing-data strategy; actual CFA/SEM estimator capabilities remain here |
| Simulation | Repeated DGP/execution/performance machinery; measurement assumptions and estimators can come from this plugin |
| Publishing | Document structure, tables/figures as artifacts and render delivery; not estimator selection |

Standalone examples use synthetic data and already-installed public R packages. The plugin validates only supported combinations rather than inferring combined support from separate packages.

## Growth boundary

Standard multigroup invariance and basic unidimensional IRT are the next bounded delivery. Their distinct identification, constraints, diagnostics and scoring questions justify additional skills when real content and tests exist. Advanced rotated/structural, mixture, multilevel, linking and network methods remain a roadmap, not installed placeholders.

The native package is always the estimation source of truth. psymetrics support is checked by fitted class and metric, and does not expand the plugin's methodological scope.
