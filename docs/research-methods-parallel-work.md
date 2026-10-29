# Research Methods EPIC 01: Parallel Work

Status: proposed dispatch plan, 2026-10-29. This is a development document, not an installed skill or a release announcement.

Read with [the EPIC design](research-methods-epic-01.md), [package decisions](research-methods-package-matrix.md), [evidence review](research-methods-evidence-review.md), the repository [architecture](architecture.md), and [release process](release-process.md).

## Ownership

Use one worktree and one branch for each independently edited plugin. The integration session owns cross-plugin decisions. Worktrees isolate working files; they still share Git objects, refs and configuration. They do not isolate source data, execution environments or external output directories.

| Session | Branch suffix | Exclusive implementation scope | First delivery |
| --- | --- | --- | --- |
| Coordinator | `research-methods-epic-01-20261029` | Root policy/docs, shared decisions, integration; scoped core maintenance only when demonstrated | Resolve task boundaries, approve internally coherent slices, assemble evidence |
| Data | `research-data-20261029` | `plugins/r-data-wrangling/` | Import/types/labels and visible transformations, joins and reshaping |
| Applied | `research-applied-20261029` | `plugins/r-applied-analysis/` | Descriptives/comparisons, regression, survey workflows |
| Psychometrics | `research-psychometrics-20261029` | `plugins/r-psychometrics/` | Item/reliability work and EFA/CFA; verified lavaan/psymetrics output |
| Simulation | `research-simulation-20261029` | `plugins/r-simulation-methods/` | ADEMP design and a small complete Monte Carlo workflow |

The coordinator handles root `README.md`, `AGENTS.md`, `docs/architecture.md`, `docs/roadmap.md`, catalogs and cross-plugin naming. Workers report desired root changes instead of editing those files concurrently. Do not give two sessions the same writable plugin directory.

The current source baseline is `61b41dd5c0a4f8ecdcc32e72cd9f55869b7ec516`. Worker branches should start from the subsequent planning commit containing these documents, so they share the same proposal. Record the actual starting commit in each handoff. Do not silently rebase a running worker onto a newer integration state.

## Common Dispatch Contract

Use the following text with the relevant domain assignment below. Supply the actual worktree path and any private reference locations in the session, not in this public document.

> Work only in your assigned worktree and plugin directory. Read the root `AGENTS.md`, architecture, roadmap, naming and release instructions, and the Research Methods EPIC documents. Inspect Git status and the current commit before editing. Preserve unrelated changes and existing worktrees.
>
> Apply `r-analytic-coding-principles` explicitly to R examples and generated analysis code. Read its supporting references only when needed. Default to tidyverse for data work and ggplot2 for researcher-authored graphics. Keep native models, arguments, diagnostics and figures locally editable. Preserve explicit project/user exceptions. Simulation replication is a deliberate automation task.
>
> Implement the assigned vertical slice with concise task-triggered skills, specific on-demand references and only demonstrably useful assets. Do not create empty directories, placeholder skills, a generic router or a framework of custom statistical wrappers. Do not install or change users' project environments merely to demonstrate a skill.
>
> Inspect authorized private source folders in read-only fashion. Never execute their scripts or write into them. Do not copy their paths, filenames, variable/object names, data, results, code fragments, logs or identifiable context into the public repository, commit messages or examples. Abstract a reusable procedure, verify it against public primary sources, and write a new synthetic or legitimately public example. A private index, if necessary, belongs outside every public worktree and Git directory.
>
> Use package documentation and source for API claims, methodological sources for scientific decisions, and realistic examples for researcher usability. Record versions actually tested; a development website version does not establish local or released behavior. Identify unsupported classes and combinations explicitly.
>
> Validate only the affected slice: structural skill checks, small synthetic numerical cases and fresh agent tasks with bounded runtime. Distinguish skill activation, methodological correctness, code execution and researcher editability. Report failures and unverified claims. Do not repeat a historical release gate without a demonstrated new risk.
>
> Commit only your plugin's files after reviewing the complete diff. Use English in repository files. Do not edit shared catalogs, publish releases, move tags, push unrelated commits, delete files/worktrees, clean the repository, stash other work or rewrite shared history. Return the exact commit, changed paths, validation evidence, unresolved decisions and requested integration changes.

## Domain Assignments

### Data

Build the smallest useful research-data workflow. Prioritize column semantics, identifiers, labels, missing-value codes, explicit transformations, unit-of-observation changes and merge cardinality. Use `readr`, `readxl`, `haven`, `labelled`, `dplyr`, `tidyr`, `stringr`, `forcats` and `lubridate` according to the actual task. Avoid mandatory helper packages for elementary operations.

Cover original versus derived inputs, leading-zero identifiers, incomplete value labels, SPSS user missings, deliberate factor order, duplicates with substantive meaning, keys on both sides of joins, unmatched rows, long/wide records and declared aggregation rules. Explain that `left_join(unmatched = "error")` checks the right input's potentially dropped keys, not whether every left row found a match. Use targeted `anti_join()` diagnostics where needed.

Do not choose imputation methods, scoring validity rules, sampling variances or model estimators. Those decisions belong to the relevant method skill. Keep genuine diagnostic counts and inspectable intermediate tables. Do not install global NA-handling modifications, auto-drop incomplete rows, treat all absent cells as zero, or deduplicate solely to remove warnings.

First numerical cases: a leading-zero/labelled import, a join with both unmatched and duplicated keys, and a repeated-observation reshape with substantive missing values. Use small synthetic inputs only.

### Applied Analysis

Build readable workflows organized by the research question and sampling unit. The initial slice covers descriptive distributions and denominators, common comparisons/correlations, transparent linear/GLM models and complex-survey inference. The next bounded slice adds ordinary multiple imputation and basic mixed models. Keep more elaborate combinations outside the initial support claim.

Use native `stats` model calls, `parameters` for estimates and `performance` for class-appropriate diagnostics. Add `effectsize`, `emmeans` or `marginaleffects` when they answer the actual reporting question. `survey` owns complex-sampling calculations; `srvyr` is an optional tidy interface. Preserve the sampling design, domain definition and variance method through extraction and final tables. Initial MI support combines scalar estimates and their uncertainties; other pooled tests/indices need a validated procedure. Mixed-model references distinguish random-effects conditioning, zeroing and averaging, and explain the chosen comparison procedure.

Do not use a diagnostic p-value as an automatic test selector, choose covariates through univariate significance screening, rank incompatible models by one score, label associations causal without a design argument, or treat weights in `lm()` as a substitute for complex-survey inference. Separate descriptive N, weighted population totals and model sample size.

First numerical cases: a prespecified comparison with missing denominators, linear and binary regression with interpretable effects, and a survey domain estimate compared with the native design-based calculation. Add missing-data pooling and mixed-model cases only when those slices are implemented.

### Psychometrics

Build measurement workflows that preserve visible model specifications and item decisions. The initial slice covers item/reliability diagnostics and EFA/CFA. Subsequent bounded slices cover standard measurement invariance and unidimensional IRT. Keep ESEM, DIF, networks and advanced latent structures deferred.

Use `psych`, `lavaan`, `semTools` and `mirt` for their appropriate model families. Keep `summary()` for lavaan models with explicit reporting arguments. The planning review inspected public psymetrics 0.5.0; use the matrix's verified defaults for `model_fit()`, `compare_model_fit()`, `model_estimates()` and `compare_model_estimates()`, then verify the actual runtime version. Stable extraction is centered on lavaan. Check raw/scaled/robust fit values, standardization, confidence intervals and covariance labeling. Comparison tables do not supply a nested-model test. Do not silently turn an unsupported extractor into an invented universal API.

Treat ordinal estimation, identification, threshold/intercept constraints, local dependence and model admissibility as substantive decisions. Do not infer unidimensionality from alpha, change item keys to maximize reliability, accept a model from universal cutoff rules, or delete items automatically from modification indices.

First numerical cases: item/reliability diagnostics with a deliberately keyed synthetic instrument, continuous CFA with native and extracted results, and ordinal CFA with the appropriate estimator. Add invariant/noninvariant group and small IRT fixtures when their slices are ready.

### Simulation

Build a reproducible small experiment from an explicit ADEMP specification: aims, data-generating mechanisms, estimands, methods and performance measures. Preserve native model calls inside an understandable replication function. Function boundaries and iteration are justified here by the principal task.

Prefer `SimDesign` for a systematic condition-by-replication study. Use `rsimsum` when it adds verified operating-characteristic summaries. Keep alternative `future.apply` execution conditional on an actual need; do not combine multiple parallel layers by default.

Treat replications as the unit of reproducible randomness and paired method comparisons. Record intended replications, failures, admissibility, estimate/SE/interval availability and successful denominators. Report Monte Carlo uncertainty and its assumptions. Do not silently retry until success, condition coverage on success without naming that condition, use wall-clock seeds, or hide method failures as ordinary missing estimates.

The inspected SimDesign implementation redraws after thrown errors, and rsimsum excludes missing results by default. Make estimator failure a recorded outcome when the design calls for a fixed number of attempts. Distinguish a deliberately invalid generating condition from a fitted method's failure. Declare which population parameters or latent values stay fixed across replications. An alternative future.apply runner must explicitly enable the documented RNG contract.

First numerical cases: a DGP with known truth, a tiny serial run, method-failure accounting and a bounded serial/parallel or restart reproducibility check when parallel/restart support is actually implemented. A smoke run is not evidence that an ambitious Monte Carlo study has sufficient precision.

## Integration and Review

1. Resolve shared boundaries and the initial package support claims in the coordinator session.
2. Develop the four initial slices in parallel from a common planning commit.
3. Inspect each worker's diff and evidence before applying its selected commits to the integration branch. Keep the source branch and worktree until the user decides their lifecycle.
4. Run a small composition review: data to analysis, missing-data handoff, applied structural question to measurement modeling, and simulation with a domain estimator. Include a standalone-plugin task and a clear out-of-scope task.
5. Reconcile root docs once. Recheck the primary checkout's status before any integration to `main` so unrelated work remains preserved.
6. Release each plugin only when its own supported slice is validated. Use the existing independent version/tag/pin process. An EPIC is a coordination unit, not a synchronized release requirement.

No universal CI framework, new trust infrastructure, forced project scaffold or repeated human authorization ceremony is required. The user's supervision concerns consequential methodological and scope choices. Routine reversible work proceeds within the dispatched scope.

## Handoff Format

Keep handoffs short and verifiable:

- Branch, base commit and delivered commit.
- Files changed and supported capability added.
- Package APIs and versions actually inspected/run.
- Exact tests or agent cases completed, with material failures.
- Remaining unsupported combinations and decisions requiring integration.
- Confirmation that the public diff contains no private source material.

Do not attach raw private review logs to a public PR. Sanitized findings and synthetic numerical evidence are sufficient.
