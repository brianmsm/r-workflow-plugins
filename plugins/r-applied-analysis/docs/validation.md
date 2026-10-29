# Validation record

Date: 2026-10-29. Scope: the first unreleased `r-applied-analysis` implementation.

Base commit: `8068a4740976d77561fbd2750ebb48b309e0221b`.
Implementation branch: `epic/research-applied-20261029`.

## Evidence levels

| Evidence | What it establishes | What it does not establish |
| --- | --- | --- |
| Creator/structure checks | Valid skill frontmatter, names, real references and repository-format manifests | Correct methodology or host discovery |
| Primary documentation/source review | Supported native APIs, meaningful defaults and uncertainty definitions | Runtime correctness of every documented package combination |
| Synthetic R execution | All R fences in six references execute; affected quantities agree with independent/native calculations | Adequacy for a private study, coverage guarantees or general real-data robustness |
| Bounded independent task review | Recorded decisions and usability for the specific task | Universal natural-language activation or cross-host installation |
| Privacy/scope review | New synthetic examples and a plugin-only diff | A numerical audit of private research sources |

The root contract, coding principles and local creator guidance were read before creating components. The implementation preserves the repository's compatibility manifests instead of migrating to a root Agent Plugins manifest. No account upload, installation, package update, publication or release is part of this record.

## Runtime actually used

| Component | Executed version |
| --- | --- |
| R / stats | 4.6.1 |
| dplyr | 1.2.1 |
| tidyr | 1.3.2 |
| tibble | 3.3.1 |
| ggplot2 | 4.0.3 |
| parameters | 0.30.0 |
| performance | 0.18.2 |
| emmeans | 2.0.4 |
| sandwich | 3.1-3 |
| lmtest | 0.9-40 |
| survey | 4.5 |

Other locally available packages are not thereby validated. `marginaleffects` was absent and was not installed. Optional effect-size/table APIs, MI and mixed-model packages are design/reference choices, not executed capability claims.

The public documentation can describe development versions different from these installed versions. The local native objects and the executed calls determine the numerical evidence.

## Reproducible developer check

From the repository root:

```bash
Rscript --vanilla plugins/r-applied-analysis/tests/numerical-validation.R plugins/r-applied-analysis
```

The test reads only the six named plugin references, executes their R fences and checks the resulting synthetic objects. It does not read or execute private source scripts. Assertions and mechanical iteration are confined to this developer test; the researcher-facing examples retain separate explicit analyses.

Result: **62 numerical/plot-construction checks passed**, in addition to successful execution of every documented R fence. Five checks build ggplot layers; no claim is made about rendered appearance or host previews.

| Case | Independent/native reference | Observed result |
| --- | --- | --- |
| Missing denominators and Welch contrast | Explicit observed counts, separate-variance SE, Satterthwaite df and t interval | 6 eligible / 5 observed per group; A minus B = -3.2; SE 1.3784049; df 7.627298 |
| Paired means | Complete-pair differences and their SE | 6 complete pairs; follow-up minus baseline = 1.8333333 |
| Categorical comparisons | Expected-cell chi-square and exact fixed-margin hypergeometric probability | Native chi-square/Fisher results agree; proportions 0.36 and 0.60 |
| Correlation and ranks | Centered-product Pearson coefficient, Fisher interval, ranked correlation and tie-adjusted U | 9 complete pairs; no fabricated Spearman interval |
| Linear interaction | Known coefficients and explicit OLS covariance | Coefficients 40, 3, 4 and 1.5 |
| HC3 and adjusted contrasts | Direct sandwich formula and linear contrast covariance | Contrasts 2.5, 4.0 and 5.5; common Bonferroni family and covariance preserved |
| Binary reporting | Known odds/probabilities, fitted information and delta-method contrast | OR 2.6666667; probabilities 0.20/0.40; risk difference 0.20 |
| Poisson/quasi-Poisson | Count/exposure totals, information/working-weight covariance and dispersion | Offset and rate interpretation preserved; quasi-likelihood AIC remains unavailable |
| Survey domain mean | Weighted ratio and stratum/PSU influence totals, including zero-domain PSUs | Mean 14.8; Taylor SE 1.4151351 |
| Domain denominators | Explicit observed records and weighted totals | 12 eligible / 10 observed; weight sums 30 / 25 |
| Stratified jackknife | Actual replicate weights, scale/rscales and full-estimate centering | Mean 14.8; JKn SE 1.4939726 |
| Gaussian survey regression | PSU estimating-function sandwich and native summary/CI | Slope SE 0.2487014; residual df 5 |
| Weighted-lm negative control | Same weighted normal equations, different covariance/df | Same slope; ordinary weighted-lm SE 0.5654179 and df 30 |
| Survey binary reporting | Native quasibinomial coefficients, design covariance, df and Wald intervals | Exponentiated coefficients/SEs/intervals and p-values agree |

A second negative control reconstructs a design after filtering to the domain. Its point estimate agrees, but its variance differs, demonstrating why point-estimate agreement alone is insufficient. Finite JKn and Taylor variances for the ratio mean are intentionally not asserted equal.

### Test-development corrections

Initial independent-information checks exposed small differences between final fitted means and the last IRLS working weights retained by native `glm`: maximum covariance differences were approximately `3.14e-8` for the binary fixture and `1.34e-7` for Poisson. The checks now distinguish solver-level approximation (explicit relative tolerances) from strict agreement with the actual fitted object's reporting covariance. The documented fitting calls were not changed to force a test.

The first hand-built survey covariance check used the default deviance residuals from a weighted Gaussian GLM. Correcting that test to response residuals recovered the native PSU sandwich covariance. This was a test-reference error, not a demonstrated defect in `survey` or `parameters`.

General numerical comparisons use `1e-8`; the binary final-information comparison uses `1e-6`, and Poisson/quasi final-iteration comparisons use `1e-4`. Native extraction and stored working-covariance comparisons retain the stricter tolerance.

## Structural and distribution checks

The available local Codex `skill-creator` `quick_validate.py` passed for all three skills. JSON parsing and targeted checks verified matching names/versions and skills directories in both manifests. All directories contain substantive files; no sibling-plugin paths, private inputs, local cache paths or runtime dependencies are bundled.

Manifest checks use this repository's Codex/Claude convention. No Codex/Claude/Gemini installation, marketplace registration, cross-host rendering or automatic selection is claimed.

## Independent review and behavior

Two independent read-only reviewers inspected the actual draft. The regression reviewer read its skill and both full regression references, plus the descriptive skill. The survey reviewer read both full survey references. Neither found a blocking methodological defect. Their concrete wording refinements were applied:

- Construct the survey design before expressing analytic eligibility as a domain, rather than potentially filtering eligible cases first.
- Describe standardization by refit as transformed-variable refitting/reparameterization; equivalent fitted means do not make coefficient interpretations interchangeable.

Their earlier combined tool calls returned no completion evidence before being aborted. Consequently these reviews establish independent source-level methodological assessment, **not independent numerical replication**. The executed numerical evidence above belongs to the implementation owner.

### Authorized historical sources

A separate historical-source reviewer completed the repository-contract reading but its broad inventory did not return evidence; that attempted pass is not counted as a private-source review. The implementation owner then performed bounded direct reads of **four complete analytical/teaching text files across the three authorized collections**. Three were selected for pre-2025 context (older project organization and 2024 file metadata); one later teaching source informed missing-data boundaries. Folder context and modification dates guide selection, not proof of original authorship or creation date.

Reusable observations concern visible model blocks, inspectable grouped summaries, explicit missingness and editable ggplot layers. Historical test-selection, automated model-selection, workspace-reset, installation and missing-data choices were not adopted as defaults. No private dataset or source script was executed, and no private path, filename, variable/object name, result, code fragment or identifiable study context was transferred into the plugin. All executable examples were independently authored synthetic cases.

### Bounded end-user tasks

Two fresh reviewers received new synthetic tasks without expected numerical answers or access to the test harness/validation record. The regression reviewer was given an explicit skill invocation and successfully read the regression entry point and its linear-model reference. Its terminal execution returned no completion evidence before interruption. The implementation owner then executed the supplied statistical code through R stdin, with exit status 0.

The descriptive/survey reviewer's initial direct source-read attempt also returned no content before interruption. The owner supplied the current three frontmatters and selected public instruction excerpts. The reviewer selected the descriptive and survey skills from that supplied text, generated explicit analyses and identified the joint-method boundary. This is content-based task selection under a manual handoff, not host-installed discovery. Its revised code was executed by the owner through R stdin, with exit status 0.

| Fresh task | Input and requested behavior | Observed outcome |
| --- | --- | --- |
| Independent scores with missing outcomes | A = 4, 7, 5, NA, 9, 6; B = 8, 9, 6, 10, NA, 12; describe each group and estimate A minus B | 6 eligible / 5 observed / 1 missing per group; means 6.2 and 9.0; Welch difference -2.8; 95% CI [-5.8536910, 0.2536910]; df 7.8252779 |
| Survey domain | Two strata, four schools per stratum, three pupils per school; repeated school IDs; weights 3/5; no FPC; outcome = 20 + 2 school + pupil + 4 I(second stratum); domain school <= 3 and pupil <= 2 | Full design before domain subset; 24 sampled records / 8 PSUs, domain 12 records / 6 PSUs; domain weight sum 48; mean 28.0; Taylor SE 0.9082632; t CI [25.4782570, 30.5217430] with domain df 4 |
| Interaction and separately editable sensitivity model | Independent Cartesian grid of Control/Program, baseline -2:2 and unit 1:6; score = 25 + 2 baseline + 3 I(Program) - 0.75 baseline I(Program) + (-3,-2,-1,1,2,3)[unit] (1 + 0.15 baseline); request HC3 Program-minus-Control contrasts at -1, 0, 1 as one family | 60 observations; coefficients 25, 2, 3, -0.75; residual df 56; contrasts 3.75, 3.00, 2.25; Bonferroni 95% intervals [2.2856862, 5.2143138], [1.4885686, 4.5114314], [0.0377377, 4.4622623] |
| Joint-method routing only | Multiply imputed longitudinal/clustered observations with complex-survey weights | Routed sampling metadata/inference to survey, missingness descriptions to descriptive analysis and ordinary specification principles to regression; explicitly withheld a supported end-to-end MI-plus-multilevel-plus-survey claim |

The fresh regression solution retained the HC3 covariance in the contrasts, used `by = NULL` for one family and matched its native coefficient/contrast estimates, SEs, df and intervals. The separate additive sensitivity model recovered coefficients 25, 1.625 and 3, with residual df 57. Model scores were descriptive, not an automated selection rule. A residual plot was defined in memory; no rendered visual inspection is claimed for that response.

The first task responses also exposed two style issues: an unnecessary package-availability inventory and base-R-only preparation despite the tidyverse preference. The three entry points now state the preparation/estimation split and exclude unsolicited inventories, environment scaffolding and opaque wrappers more explicitly. The descriptive/survey reviewer revised preparation to tidyverse before execution. No analytical formula changed in this refinement.

These executions supplement, and are not included in, the 62 reference checks. Independent generation/source review and owner execution are different evidence levels. Automatic natural-language activation, host installation and cross-host composition remain integration checks.

## Boundaries

The examples and tests certify a bounded first slice. They do not certify optional table/standardizer/marginaleffects APIs; all survey providers or replicate schemes; causal identification; ordinal/multinomial/negative-binomial/survival/mixture models; MI or mixed-model implementations; or survey-plus-MI-plus-multilevel/latent combinations.

The next two skills have explicit procedures and acceptance cases in [roadmap](roadmap.md), with no placeholder directories. Integration should review the plugin commit, reconcile root documentation/catalog decisions and sample composition with the separately developed plugins. Root files, other plugins, shared branches and sealed historical evidence remain outside this worker's edit scope.
