# Behavioral Validation Cases

These are **test scenarios**, not bundled automated tests or evidence of success on their own. The initial `v0.1.0` release was validated independently; see [pilot findings](pilot-findings.md). Present only the request and an isolated synthetic fixture to an evaluating agent; keep the expected observations with the reviewer. Compare without/with the skill in fresh sessions when practical, and inspect the generated code and actual diffs. Do not copy private sample reports into the released plugin.

## Positive Cases

| ID | Fresh request / fixture | Required observations |
| --- | --- | --- |
| C01 | An `.R` file starts with ten `glm()` fits, while ten later headings display only `summary(model_n)`. Reorganize it for iterative research. | Each fit moves beside its own heading/inspection; shared preparation stays upstream; final comparison is not accidentally refit. |
| C02 | Five CFA blocks have separate `lavaan` model syntax strings and different estimators/ordered variables. Simplify without changing the models. | Colocate **both syntax string and fit** in its own section; preserve arguments/differences; no `cfa_safe()`/`map()` refactor; do not imply numerical equivalence without execution. |
| C03 | Generate three ggplot figures intended for independent custom styling. | Per-figure `ggplot`, geoms, scales, `labs`, and `theme` remain editable; no `make_plot` wrapper. |
| C04 | A fixed, identical coefficient extraction pattern is repeated for 12 established `lm` objects. | A small helper can be proposed or used only after confirming stable extraction semantics; do not wrap the model fits themselves. |
| C05 | A script attaches `dplyr`, `ggplot2`, **then `MASS`**, uses `dplyr::select()` safely, and imports one Excel file. Simplify its namespace style. | Do not silently turn `dplyr::select()` into masked `select()`. If `MASS` is genuinely used often, propose/test a base R `exclude` policy; if unused, dropping it requires checking project scope. Keep `readxl::read_excel()` for the one-off. |
| C06 | A clean `.qmd` or `.Rmd` contains separate discussion sections for three models but fits all models in setup. Change only the R computation layout. | Put model definitions and fits in their substantive sections; preserve frontmatter **as raw document source**, prose, original result chunk labels/options, output behavior, citations, and source order. For a real edit, verify the file itself rather than a Markdown-escaped chat reply. |
| C07 | An analysis contains many `stopifnot()` key checks **and a reported count of matching keys**; an agent wants to shorten its code. | Inspect relevant keys/types/cardinalities with R when accessible. Remove only transient guards that are justified as removable; preserve the original matching count, row/column provenance, and reported field names. Regression-test that new `$` references do not silently evaluate as `NULL`. |
| C08 | A repeated block changes an outcome variable and a figure caption; reviewer asks for style cleanup. | Preserve scientific scope and intended differences; update references consistently; warn about accidental divergences without normalizing all blocks. |
| C09 | Two connected R sessions disagree about whether a column exists; one is a separate `Rscript` process. | Clarify environment identity; make no unsupported live-state or clean-run claims. |

| C10 | `dplyr` and `MASS` are both used in many places; the researcher wants plain `select()` to mean `dplyr::select` without adding dependencies or dozens of `::`. | Use `library(MASS, exclude = "select")` or an equivalently verified base R rule **before** MASS attaches; retain `MASS::select()` if needed; execute a clean-session search-path and sample-call check. |
| C11 | `MASS` is needed broadly but the only `dplyr` call is one `select()`; in a complementary script `dplyr` is broad but `MASS::rlm()` is called once. | Keep the infrequent package un-attached and use `pkg::fun()`. Do not introduce extra `library()` or `{conflicted}` needlessly. |
| C12 | A diagnostic refactor uses `sum(docentes$n_docentes, na.rm = TRUE)` although only `docentes_agrupados` has `n_docentes`. | Detect the wrong object, avoid reporting a misleading zero from `sum(NULL, ...)`, and preserve all original report-facing quantities. |
| C13 | A key-diagnostic script creates `staff_by_site` and a joined `site_staff` object, but the current printed table uses only match counts. Simplify excessive guards. | Keep the aggregation and joined object as legitimate, inspectable analytical intermediates even if the current table does not reference them; change only redundant checks, and preserve reported match counts. |

## Negative / Exception Cases

| ID | Request / fixture | Required observations |
| --- | --- | --- |
| N01 | An established `targets` production workflow is to be optimized for unattended daily execution. | Respect pipeline architecture; do not expand it into copy-pasted research cells. |
| N02 | A Monte Carlo experiment must fit the same model in 5,000 replications under predefined conditions. | Allow functions/loops with clear parameterization; do not duplicate 5,000 fits. |
| N03 | A reusable R package API needs argument validation and error handling. | Favor package engineering conventions; no presumption that input guards are excessive. |
| N04 | `MASS` and `dplyr` expose a conflicting function name in the active environment. | Preserve targeted `pkg::fun()` if effective resolution is unknown; allow a deliberately verified one-time `exclude` or `conflictRules` policy when both packages are heavily used. |
| N05 | Source files cannot be executed; user asks only for static style changes. | No fabricated result or environment verification; perform source/parse-level review only. |
| N06 | An upstream file schema changes monthly and a wrong join can multiply observations. | A narrow durable invariant/check is appropriate; 'no stopifnot' is not a blanket ban on guarding actual risk. |

## Review Protocol

1. Use realistic short requests with actual synthetic file attachments, or name exact fixture filenames when the evaluator exposes only a file-read tool; otherwise, classify file-discovery failures as a harness problem. Hold back this answer key from the acting agent.
2. For each run, record the environment and agent, whether the skill actually loaded, code diff, observed effects, and which checks were run.
3. Judge behavior on the artifact: model locality, exposed arguments, faithful semantics, unwanted wrappers, check placement, and appropriate use of tools.
4. Classify each case as **pass**, **partial**, **fail**, or **not observable** with evidence. Record *skill advertised*, *SKILL.md actually read*, and *instructions demonstrably applied* separately; do not count advertised-but-unread skills as verified activation. A metadata validator pass is not a behavioral pass.
5. Independently run short R checks on changed package conflicts, joins, and diagnostic outputs where permitted. Parsing alone cannot detect masking or `sum(NULL)`.
6. Correct the smallest demonstrated issue; rerun that case plus one neighboring negative case. Do not claim broad reliability from a single model/session.
