# Research Methods EPIC 01

Status: design proposal, 2026-10-29. The proposed plugins and skills below are not implemented or released by this document.

## Decision Summary

Develop four independently usable domain plugins around the existing research coding core:

- `r-data-wrangling`: prepare research data while preserving meaning, identifiers and units of observation.
- `r-applied-analysis`: estimate and interpret common research analyses with explicit estimands and sampling designs.
- `r-psychometrics`: evaluate measurement and fit factor, latent-variable and basic item-response models.
- `r-simulation-methods`: design, execute and evaluate Monte Carlo experiments.

Keep `r-analytic-core` in scoped maintenance. Its current single skill already supplies the intended coding behavior. Do not expand it into a method catalog or split it into several style skills without a demonstrated activation or workflow problem.

The first EPIC should deliver a small complete slice from each new plugin, then add bounded methodological extensions. It should not attempt to encode every method encountered in the source corpus. Use native R fitting functions, tidyverse data operations, editable ggplot2 figures and established extraction packages. The primary deliverable is expert procedural guidance with concise references, not a new statistical software layer.

Read the [package matrix](research-methods-package-matrix.md) for method-specific recommendations, [evidence review](research-methods-evidence-review.md) for what was inspected, and [parallel work plan](research-methods-parallel-work.md) for session ownership and dispatch.

## 1. Research Coding as the Default

For this EPIC and its dispatched sessions, explicitly compose `r-analytic-coding-principles` with the domain skill unless the user requests another working style. Preserve native formulas, estimators and diagnostic calls beside each model. Keep shared preparation upstream and final cross-model comparisons downstream. Use short meaningful sections rather than a setup block containing the whole analysis.

An explicit tidyverse preference applies coherently to newly written imports, transformations and ordinary iteration. It does not justify rewriting unrelated code or converting a model family into an opaque factory. Repeated native calls remain appropriate when the researcher will modify models or plots independently. Functions and loops remain appropriate for stable mechanics and systematic simulation.

This default does not create a hard installation dependency:

1. Repository policy defines the common research profile and the examples are reviewed against it.
2. Development/session instructions explicitly request the core skill when available, rather than assuming that implicit activation always works.
3. Installed domain skills identify the optional core capability by name, without assuming another plugin's filesystem path.
4. Each domain skill remains understandable and usable on its own. Its own model examples must already be locally editable and methodologically complete.

Root documentation and `AGENTS.md` govern contributors. They are not automatically loaded by consumers of a single plugin subdirectory. Do not rely on a link outside the installed plugin to supply necessary runtime instructions, or use symlinks into sibling plugins. A concise capability handoff is sufficient; copying the whole core policy into every skill is unnecessary.

No automatic package installation, universal environment bootstrap, generated package-loading loop, global missing-value override, or speculative preflight framework is part of the default. Preserve established project requirements and meaningful diagnostics. Add persistent safeguards only for consequential risks demonstrated in the actual workflow, such as known join cardinality.

## 2. Responsibilities and Handoffs

| Plugin | Primary researcher task | Owns | Handoff |
| --- | --- | --- | --- |
| `r-analytic-core` | Make analytical R code understandable and editable | Locality, intentional repetition, namespaces, proportional verification, preservation of meaning | Statistical decisions to domain skills; documents to publishing |
| `r-data-wrangling` | Turn known inputs into a correctly defined analysis table | Import semantics, labels/types, declared recodes, keys, joins, reshaping, deterministic aggregation | Missing-data inference to applied; score validity to psychometrics; survey inference to applied |
| `r-applied-analysis` | Describe a population/sample or estimate an association or contrast | Estimands, ordinary models, comparisons, missing-data inference, survey design and basic dependence models | Measurement and latent-model details to psychometrics; replication design to simulation |
| `r-psychometrics` | Study measurement and latent-variable models | Item analysis, reliability, EFA, CFA/SEM, measurement invariance, basic IRT and score uncertainty | General sampling/causal questions to applied; Monte Carlo execution to simulation |
| `r-simulation-methods` | Evaluate a method under controlled conditions | DGPs, condition grids, replication, RNG, failures, performance measures and Monte Carlo uncertainty | Domain-specific estimators and interpretation to applied/psychometrics |

`quarto-publishing` continues to own document structure, rendering, cross-references and publication delivery. Statistical packages can prepare tables and plots without turning the analysis plugin into a publishing plugin. R Markdown support and package development remain separate roadmap areas.

### SEM ownership

Use one technical home for the initial native `lavaan` and `psymetrics` workflow: the psychometrics plugin's proposed `r-cfa-sem` skill. This is an organizational choice to keep measurement specification, estimator handling, model-fit inspection and model comparison coherent. SEM is not conceptually synonymous with psychometrics.

The applied plugin owns the research question, target association/contrast, covariate rationale, design and interpretation of structural relations. It may use ordinary regression-based mediation/moderation examples within its existing regression reference. For a latent-variable SEM, combine that applied reasoning with the CFA/SEM skill. An observed-variable path model can use the same technical SEM skill without pretending that it contains a measurement model.

Keep the initial SEM scope to single-level, conventional observed-path and confirmatory latent-variable models. A working `lavaan` call does not establish causal identification. Do not automatically interpret an indirect effect from cross-sectional associations as a causal mechanism.

This arrangement avoids two independently maintained collections of lavaan estimator rules and psymetrics examples. It can be revisited if real standalone tasks show that a separate structural-analysis skill substantially improves activation and reduces unnecessary context.

### Missing data ownership

The data plugin identifies and preserves missing-value meanings and computes visible missingness counts. The applied missing-data skill owns inferential strategy, imputation-model construction and pooling. The model-owning skill documents and validates its actual likelihood-based implementation, including CFA/SEM-specific missing-data capabilities. Ordinary imputation support does not automatically imply support for multilevel imputation, ordinal SEM with imputation or complex-survey imputation.

### Scores and aggregation

The data plugin can implement an explicitly specified recode, sum, mean or aggregation rule. The domain plugin decides whether the score is interpretable, which missing-item rule is defensible, and whether aggregation supports the intended inference. A computationally correct average does not justify treating a score as error-free or converting an ecological association into an individual-level conclusion.

## 3. Proposed Skill Map

Names are provisional until the first implementation review. Do not create a directory for a future row before writing real content and a validation case. Prefer one focused skill with conditional references over several nearly identical entry points.

### r-data-wrangling

| Skill | Activation task | Conditional references | Initial assets |
| --- | --- | --- | --- |
| `r-data-import-and-types` | Import tabular research data; retain identifiers, labels and valid analysis types | Import/locale; labelled and user-missing values; identifiers and factor levels; export metadata | None |
| `r-data-transform-and-integrate` | Recode, combine, reshape or aggregate known tables | Declared recoding and missingness; join keys/cardinality; repeated observations and pivots; grouped transformations | None |

Two skills are enough initially. Do not split one skill per tidyverse package or create a generic data-quality framework. A separate joins/longitudinal skill is justified only if repeated tasks make the combined activation boundary unwieldy.

### r-applied-analysis

| Skill | Activation task | Conditional references | Delivery |
| --- | --- | --- | --- |
| `r-descriptive-and-comparative-analysis` | Describe distributions, compare prespecified groups, estimate simple correlations | Denominators/missingness; mean/rank/categorical comparisons; effect sizes/intervals; multiplicity and displays | First slice |
| `r-regression-analysis` | Fit and interpret ordinary linear/GLM models and contrasts | Linear models; binary/count models; interactions; robust inference; predictions and contrasts; simple observed mediation | First slice |
| `r-survey-analysis` | Analyze probability samples with weights, strata, clusters or replicate weights | Design declaration; domains; means/proportions/totals; design-based regression; reporting and variance choices | First slice |
| `r-missing-data` | Investigate missingness, conduct ordinary MI and choose a supported likelihood-based strategy | Mechanisms and sensitivity; mice specification; scalar-estimate pooling; likelihood implementation handoffs | Second slice |
| `r-mixed-models` | Model clustered or repeated observations with a clear dependence structure | Random intercept/slopes; ML/REML and justified comparisons; prediction targets/scales; singularity and residual diagnostics | Second slice |

A reporting skill is not needed solely because several methods use `parameters` and `performance`. Reporting guidance belongs near each model class. Final document/table layout belongs to publishing. Add ordinal or multinomial regression references only after their class-specific tests pass; the broad phrase GLM does not promise every outcome family.

### r-psychometrics

| Skill | Activation task | Conditional references | Delivery |
| --- | --- | --- | --- |
| `r-item-and-reliability-analysis` | Inspect items, declared scoring and reliability evidence | Item distributions/keying; internal consistency; model-based reliability; score uncertainty | First slice |
| `r-exploratory-factor-analysis` | Explore dimensional structure with appropriate correlations/extraction/rotation | Retention; `psych::fa()`, ordinal WLSMV with `lavaan::efa()`, rotation/interpretation; uncertainty and replication | First slice |
| `r-cfa-sem` | Fit and inspect confirmatory measurement and basic structural/path models | Continuous versus ordinal estimation; identification; native summaries; psymetrics; admissibility; simple SEM | First slice |
| `r-measurement-invariance` | Evaluate comparable measurement across groups with a specified identification strategy | Continuous constraints; ordinal thresholds/identification; partial invariance; model comparison | Second slice |
| `r-irt-analysis` | Fit and evaluate basic unidimensional IRT models | Dichotomous/polytomous models; information; item/global fit; local dependence; scoring | Second slice |

EFA and CFA have materially different questions and decision sequences, so separate activation is useful. The EFA skill includes `lavaan::efa(..., ordered = TRUE, estimator = "WLSMV")` for ordinal items, alongside `psych::fa()`. EFA-only rotated measurement models are in scope; ESEM with structural regressions remains deferred. CFA and simple SEM share enough technical machinery to begin together. Invariance deserves a separate skill because constraint construction and comparability are a distinct task, particularly for ordered items.

### r-simulation-methods

| Skill | Activation task | Conditional references | Initial assets |
| --- | --- | --- | --- |
| `r-simulation-design` | Design a Monte Carlo or simulation-based precision/power study | ADEMP; realistic DGPs; conditions and estimands; Monte Carlo precision; pilot planning | A short design worksheet only if it proves repeatedly useful |
| `r-simulation-execution-and-evaluation` | Implement, run, resume or summarize a specified simulation | SimDesign pattern; RNG and parallelism; failure accounting; operating characteristics and plots | One small synthetic SimDesign starter, after execution-based validation |

Design and execution can be requested independently. Keep them composable rather than creating separate skills for seed setup, checkpointing, bias, coverage and each simulation package. A previously authored local SimDesign skill was inspected read-only for small pilots, `fixed_objects`, per-condition RNG seeds, failure diagnostics and replay. Transfer only independently validated principles, not the original templates, host-specific source paths or advanced distributed-execution catalog.

The proposed EPIC has 14 new skills across four plugins, delivered incrementally. This is a task map, not a quota or a prerequisite for releasing a smaller useful plugin.

## 4. Instructions, References and Templates

### SKILL.md

Keep the body concise and decision-oriented. It should establish the user's immediate task, the required design information, the preferred native path, substantive failure signals, what to inspect/report and where to read details. Put concrete activation language in the description. Do not make a skill a package encyclopedia or an introductory statistics textbook.

Only request additional user input when an unresolved decision materially changes the analysis. Do not impose a sequence of mandatory approval stops when the user has already specified or delegated the decisions.

### References

Give each reference a specific condition for reading it. A useful reference contains:

- The supported question, data structure and model class.
- Choices that change statistical meaning, with a brief rationale.
- A small new example using the native API and preferred reporting packages.
- Diagnostics, interpretation limits and unsupported combinations.
- Primary sources and a checked API/version note.

Keep detailed material in one location. Shared repo policy belongs in root docs; method-specific instructions needed by an installed plugin belong inside that plugin. Do not add a router whose only job is to re-list every file.

### Assets and scripts

Most initial model examples fit better in references than in full templates. Avoid an analysis master script, generic formula factory, catch-all model runner, universal result extractor or automatic report generator. They obscure precisely the decisions this project wants the researcher to edit.

A small simulation starter is justified because condition/replication machinery is genuinely recurrent. A simple worksheet can help preregister its estimands and Monte Carlo precision. Other templates should follow actual reuse, not precede it. Do not create empty `assets/`, `references/` or `scripts/` directories.

## 5. Package and Communication Policy

The [package matrix](research-methods-package-matrix.md) is central to this EPIC, not an optional appendix. Prefer a compact stack with clear roles:

1. **Native estimation and meaningful diagnostics:** the model's original R package remains visible.
2. **Convenient extraction:** `parameters` and `performance` are usual choices where their class-specific behavior is appropriate. Inspect the relevant method rather than assuming a generic call supports every class.
3. **SEM reporting:** retain the native lavaan summary, then use verified psymetrics operations for compact summaries and descriptive cross-model reports. Scaled fit indices are the **intentional default** for WLSMV; do not automatically switch to the separately named `.robust` variants. Explain the difference and allow explicit alternatives. The inspected psymetrics 0.5.0 support is centered on lavaan; do not promise stable psych/mirt extraction or interpret a comparison table as an inferential test.
4. **Graphics:** use `ggplot2` for researcher-authored displays; retain valuable native diagnostic plots supplied by model packages.
5. **Publication tables:** choose `gtsummary`, `gt`, `flextable` or `modelsummary` only when the requested output needs them. Avoid adding several table systems to a simple analysis.

Default packages are defaults for supported tasks, not a requirement to attach all of them. A table's polished appearance does not establish the correctness of its estimator, denominator, uncertainty or model comparison.

Package documentation may describe development builds. Record the version actually used in validation. Preserve the project's environment unless a demonstrated API requirement or a user decision calls for a change. Do not rewrite all old native calls solely to enforce the newest syntax.

## 6. First EPIC Scope

### First complete slices

- Data import/type/label integrity, declared transformations, joins and long/wide manipulation.
- Descriptives, common comparisons/correlations, ordinary linear/binary/count regression and complex-survey descriptives/regression.
- Item analysis, basic reliability, EFA (including ordinal WLSMV with `lavaan::efa()`) and conventional continuous/ordinal CFA; simple SEM using the same native workflow.
- One transparent Monte Carlo study, from design to estimates, failures, uncertainty and an interpretable performance display.

### Bounded second slices within this EPIC

- Ordinary `mice` workflows for supported analyses, initially pooling scalar estimates and their uncertainties with diagnostic evidence. Joint tests, model comparisons and pooled fit indices require their own validated procedure.
- Basic linear/generalized mixed models with explicit dependence and prediction targets.
- Standard multigroup measurement invariance for supported continuous and ordered-item configurations.
- Basic unidimensional IRT, including model/item diagnostics and uncertainty in scoring.

These extensions require their own small validation cases. They do not all have to be in the first `0.1.0` tag of their plugin. A plugin can release a useful smaller slice while another continues development.

### Deferred to the roadmap

| Area | Reason for deferral / future home |
| --- | --- |
| Machine learning, automated tuning and predictive pipelines | Define a separate research-oriented predictive workflow later; do not import an industrial architecture by default |
| Psychometric networks | Distinct estimation/stability/interpretation problems; future psychometrics scope |
| ESEM | Rotation, identification and estimator-specific comparisons deserve a separate evidenced procedure |
| DIF | Requires explicit matching, anchor, group and purification decisions beyond initial IRT/invariance support |
| Bifactor and S-1 variants | Valuable advanced measurement work, but not an extension to apply automatically after ordinary CFA |
| Linking/equating, multidimensional IRT, CAT and plausible-value workflows | Separate scale/comparability and uncertainty requirements |
| Latent classes/profiles, mixture SEM and growth mixtures | Local solutions, class selection, distal outcomes and classification uncertainty need their own design |
| Multilevel/longitudinal SEM, latent interactions and advanced growth models | Substantial additional identification and estimator choices |
| Survey + MI + multilevel/latent combinations | Support must be established jointly; separate package support does not certify the combination |
| Full Bayesian, advanced causal inference, survival, time series, meta-analysis and spatial/small-area models | Useful future tasks, but extending the initial EPIC to all of them would dilute validation |
| Large-data/database backends, distributed computation and production orchestration | Add when memory/performance or delivery requirements demonstrate a need; preserve the research interface |
| Package engineering and automated release infrastructure | Separate `r-package-development` scope and existing repository release policy |

Deferral is a statement about what this plugin release claims to support, not a judgment that the method is unsuitable or that an agent must refuse unrelated user requests.

## 7. Validation and Acceptance

Validate transferable behavior, not wording or file counts. Use public/synthetic fixtures whose expected values and failure conditions are known. Keep raw private cases out of release artifacts.

| Dimension | Question | Evidence |
| --- | --- | --- |
| Method | Is the estimand, model, sampling unit and uncertainty calculation appropriate? | Method review plus native numerical reference |
| API/execution | Do the documented calls run and return the stated quantities? | Small actual R execution with recorded versions |
| Research usability | Can the researcher edit one model or figure without rewriting a wrapper? | Source review and a realistic agent editing task |
| Activation/composition | Does the skill activate for its task and respect neighboring responsibilities? | Fresh explicit, natural-language and selected negative/composition cases |

Important initial failure cases include a duplicated join key, altered missingness denominator, a weighted model treated as a survey design, an ordinal CFA sent to an unsupported missing-data path, a nonadmissible model with a polished report, pooled data instead of pooled estimates, and simulations that silently exclude failures. Select the minimal case set that exposes these risks; do not build a new general harness before it is needed.

An isolated plugin must work without private files, another plugin's installation path or a particular R MCP server. A composed task must retain the domain method and core coding behavior. Do not reinterpret an unsuccessful activation as a statistical defect or a source-only review as an executed result.

The first EPIC is complete when the agreed slices are usable, documented, numerically checked, behaviorally sampled and integrated with explicit remaining limits. Core maintenance only needs new checks for affected behavior and composition. Historical sealed evidence remains historical.

## 8. Execution Order and Decisions

1. Establish the proposed boundaries, the research-default composition and package support claims in this planning branch.
2. Develop the four first slices in parallel, with exclusive plugin ownership and separately authorized private reference inputs.
3. Integrate through one coordinator; fix root release-state documentation once and add the new candidates to the canonical roadmap when their scope is accepted.
4. Run the small cross-plugin tasks and revise only demonstrated gaps.
5. Deliver bounded second slices, then release plugins independently through the existing version/tag/pin process.

Recommended starting decisions are: keep the core small; name the data plugin `r-data-wrangling`; maintain one technical CFA/SEM home; prefer native APIs with parameters/performance and verified psymetrics reporting; include standard invariance and basic IRT as second slices; defer the advanced areas listed above. No plugin code or marketplace change is implied by this proposal alone.
