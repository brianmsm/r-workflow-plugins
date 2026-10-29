# Research Methods EPIC 01: Evidence Review

Review date: 2026-10-29. This document records inspected evidence and design implications. It does not claim that the proposed plugins are implemented, that all private reference material was read, or that package examples were executed during this planning review.

## Repository Snapshot

The local source checkout was on `main` at `61b41dd5c0a4f8ecdcc32e72cd9f55869b7ec516`. The remote `main` observed through a read-only Git query was `4a18ff2611592fa89e4f4d0a7aa9c8485333eb9d`. There were three local commits ahead of that remote and one unrelated untracked ZIP under `plugins/r-analytic-core/`. The primary checkout and existing worktrees were preserved.

The root `AGENTS.md`, `README.md`, architecture, roadmap, naming and release documents were read. The core plugin's README, architecture, roadmap, changelog, skill and references were inspected, together with its manifest and the local marketplace. Remote existence was verified for the current core and Quarto plugin tags.

Findings:

- `r-analytic-core` is a real, independently tagged `0.1.1` plugin with one skill and four conditional references. Its existing scope is coding organization and preservation of analytical meaning, not method selection.
- The working tree contains small post-tag guidance changes in four core files: 13 insertions and three deletions relative to `r-analytic-core-v0.1.1`. These concern conditional reference reading and classroom/style guidance, not an additional analytical-method skill.
- The core's documentation distinguishes the scoped `0.1.0` behavioral evidence from the structural and synthetic R/Quarto checks used for `0.1.1`. This review does not reinterpret the latter as a new independent behavioral validation wave.
- `r-applied-analysis`, `r-psychometrics` and `r-simulation-methods` remain planned candidates, without implemented plugin directories. A data-wrangling plugin is a new scope proposal.
- The root README still describes older release states, while the manifests, catalogs and roadmap describe newer releases. Aligning the README is a coordinator-owned follow-up; this planning review does not silently rewrite release history.
- The architecture already supports independent plugins and task-based composition, and explicitly discourages hard dependency chains, duplicated cross-cutting guidance and speculative scaffolds.

Canonical local source documents remain authoritative. See [architecture](architecture.md), [roadmap](roadmap.md), [core architecture](../plugins/r-analytic-core/docs/architecture.md), [core roadmap](../plugins/r-analytic-core/docs/roadmap.md), and [core changelog](../plugins/r-analytic-core/CHANGELOG.md).

## Private Reference Review Method

Authorized reference collections were used only to learn reusable analytical procedures and researcher-facing organization. Inventory searched R, R Markdown and Quarto text-code files; directed reading then selected analytical and teaching material. Source data were not needed for this design task. No source scripts were executed and no files were changed in those collections.

Selection was purposive rather than a census reading: seek variation in methods, older research organization and newer analysis requirements. Full reads of shorter scripts were combined with bounded excerpts from longer reports. Inventory candidates can include duplicates, supplementary third-party work and administrative scripts; reading excluded unrelated administration, dependencies, generated artifacts, tool histories and caches. Filename or folder years are context, not proof of authorship. Filesystem modification times are not treated as reliable creation dates.

Public evidence consists of generalized methodological observations and new synthetic cases. Private paths, filenames, object/variable names, source snippets, data and study results are excluded from repository content. Future private provenance, if required, must remain outside every public checkout and worktree; `.gitignore` alone is not a privacy boundary.

The reference material is evidence of user needs and workflow preferences. It does not override current methodological sources or supported package APIs. Older code can preserve an excellent analytical sequence while using APIs or statistical shortcuts that need replacement. Recent automation can be useful for systematic replication while being unsuitable as the default shape of an ordinary research analysis.

### Generalized design implications

- Preserve the sequence from question and explicit specification to native fitting, inspection and interpretation. Repeated model blocks are useful when they are independently revised.
- Keep types, labels, item keys, observation identity and denominator choices visible before fitting. A compact transformation can still change the scientific meaning of a variable.
- Distinguish distributional summaries, model estimates, uncertainty, fit and publication formatting. Package convenience should simplify communication without erasing those distinctions.
- Treat ordinal measurement identification and equality constraints as substantive content. Generated syntax can help, but should remain inspectable and compatible with the fitting call.
- Preserve the substantive structure in incomplete-data analysis, including interactions and clustering where relevant. Single completed-data analyses and general-purpose extraction do not establish a valid MI workflow.
- Separate a simulation's population specification, random generation, fitted method and recovery metrics. Clarify what is held fixed across replications and how failures affect denominators.
- Teach plain R operations and native diagnostic output when they reveal the mechanism. Modern tidyverse operations can coexist with this organization; automated model factories are not implied by pipe syntax.

These are abstract methodological requirements, independently expressed for public development. Private source inventories, identifiers, snippets and study-specific findings are not included here. The planning review did not perform a numerical audit of the private analyses or treat their choices as universally valid recipes.

## psymetrics Source Review

The public psymetrics website and source were inspected at version 0.5.0, with observed `master` commit `85cd7b7e24d112ecd8c93e8a1b49f59e8680d30c`. Its stable scope is centered on lavaan; psych/mirt support and measurement-invariance helpers are marked as development work. The four requested extraction/comparison functions exist. Their defaults, descriptive comparison semantics, standardization behavior and a covariance/correlation labeling concern are recorded in the [package matrix](research-methods-package-matrix.md).

This was source and documentation review, not execution or confirmation of the locally installed package. No psymetrics code was changed, no issue was published, and no package release is part of this EPIC planning work.

## Other Skills Reviewed

Four external skill sources were read directly. Their current source commits were observed immediately after reading. They are comparison material, not dependencies and not validation evidence for this repository.

| Source | Observed commit | Useful design lesson | Adaptation boundary |
| --- | --- | --- | --- |
| [statzhero/tidy-r-skill](https://github.com/statzhero/tidy-r-skill) | `114967ca9ca0fb9303464826fecf9f33a5406dce` | Short task instructions with topic-specific references and current tidyverse vocabulary | Its strict syntax/version preferences, global NA convenience package, automatic join logging and seed prescriptions do not become this project's defaults |
| [jeremy-allen/claude-skills, writing-tidyverse-r](https://github.com/jeremy-allen/claude-skills/tree/main/writing-tidyverse-r) | `f3a6573966bae0e239f5250592035f6064bd69a4` | Separating tidy selection, grouping, joins and migration examples | Recheck examples against current APIs: join cardinality and unmatched-key behavior need more precise treatment than the inspected summary provides |
| [nealcaren/social-data-analysis, r-analyst](https://github.com/nealcaren/social-data-analysis/tree/main/plugins/r-analyst) | `527018ce8d13fcb2eec5d1d53744137b391da35b` | Establish the research question, estimand and assumptions before interpreting estimates; maintain an analysis narrative | Its causal-econometric emphasis, fixed phase pauses, project scaffold and host/model-specific orchestration are not required for this EPIC |
| [K-Dense-AI/scientific-agent-skills, statistical-analysis](https://github.com/K-Dense-AI/scientific-agent-skills/blob/main/skills/statistical-analysis/SKILL.md) | `5f2bc0341354fd5590aef76a533ada1e1e5b4e62` | Explicit sampling units, uncertainty, planned versus exploratory analysis and careful interpretation of diagnostic screens | Its Python environment, bundled diagnostic automation and broad statistical surface are not an R implementation or a ready-made method policy |

These sources show that useful research-oriented skills already exist. The proposed contribution is the combination of researcher-editable R code, bounded methodological procedures, native R reporting, explicit package choices and portable composition. It is not a claim that all other skills target industrial ML workflows.

No third-party skill text or code was copied into this proposal. General lessons can be independently implemented from primary documentation. If a future implementation actually reuses third-party material, inspect its applicable license and retain required attribution.

## Public Primary Sources

### Data and graphics

- [R for Data Science, second edition](https://r4ds.hadley.nz/): selected import, missing-value and join chapters as a research-readable explanation source, not an imported workflow framework.
- [readr delimited import](https://readr.tidyverse.org/reference/read_delim.html) and [readxl types](https://readxl.tidyverse.org/articles/cell-and-column-types.html): types, locale and input interpretation.
- [haven conversion semantics](https://haven.tidyverse.org/articles/semantics.html) and [labelled introduction](https://larmarange.github.io/labelled/articles/labelled.html): distinguish labels, analysis types and different missing-value representations.
- [dplyr joins](https://dplyr.tidyverse.org/reference/mutate-joins.html), [summaries](https://dplyr.tidyverse.org/reference/summarise.html) and [across](https://dplyr.tidyverse.org/reference/across.html): current operation semantics.
- [tidyr pivot_longer](https://tidyr.tidyverse.org/reference/pivot_longer.html) and [pivot_wider](https://tidyr.tidyverse.org/reference/pivot_wider.html): observation keys and reshaping choices.
- [purrr list combining](https://purrr.tidyverse.org/reference/list_c.html): ordinary uniform iteration without dynamic model factories.
- [ggplot2](https://ggplot2.tidyverse.org/): researcher-authored graphics with editable mappings and layers.

### Reporting and method-specific follow-up

- [parameters model-class index](https://easystats.github.io/parameters/reference/model_parameters.html): extraction options depend on the fitted class.
- [performance model-class index](https://easystats.github.io/performance/reference/model_performance.html) and [check_model](https://easystats.github.io/performance/reference/check_model.html): select diagnostics that apply to the actual model.
- [gtsummary survey summaries](https://www.danieldsjoberg.com/gtsummary/reference/tbl_svysummary.html): publication tables can retain a supported survey design rather than flattening it into ordinary unweighted summaries.
- [A lavaan Compendium for SEM in Educational Research](https://tdjorgensen.github.io/SEM-in-Ed-compendium/): a methodological and teaching reference to consult by relevant chapter alongside current lavaan and semTools documentation.
- [Morris, White and Crowther (2019)](https://doi.org/10.1002/sim.8086): ADEMP, performance measures and Monte Carlo precision for a simulation study.
- [SimDesign execution](https://philchalmers.github.io/SimDesign/reference/runSimulation.html) and [error handling](https://philchalmers.github.io/SimDesign/articles/Catch_errors.html): replication management and redraw semantics must match the evaluation target.
- [rsimsum](https://ellessenne.github.io/rsimsum/) and [future.apply RNG](https://future.apply.futureverse.org/reference/future_lapply.html): Monte Carlo summaries, effective denominators and an explicit reproducibility contract.

The [package matrix](research-methods-package-matrix.md) contains the method-specific source links and support restrictions. Packages are recommended task by task; the list is not a mandatory environment or an instruction to install them all.

## Evidence Standards for Implementation

Every packaged method recipe should identify:

1. Its primary task, estimand, sampling unit and supported data/model class.
2. The native fitting or transformation API and consequential arguments.
3. The extraction/reporting API, including what scale and uncertainty it returns.
4. Methodological assumptions and meaningful unsupported combinations.
5. A primary source plus the API version actually checked.
6. A new small synthetic or legitimately public example and a numerical reference result.
7. The behavioral case that tests activation, code editability and method preservation.

Documentation/source review establishes what to test. It does not by itself establish runtime correctness, scientific adequacy or successful agent behavior. Keep these evidence levels separate in future release notes.
