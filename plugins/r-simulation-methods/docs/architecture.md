# Architecture

## Two Tasks, Two Skills

The design skill turns a substantive question into an implementable ADEMP protocol. The execution/evaluation skill applies a defined protocol, preserving the mapping from attempts to method outcomes and performance summaries. Either can be requested separately; a simulation project can compose both.

A one-page design or one debugged replication does not require a new project framework. There is no mandatory router, custom statistical package, universal estimator wrapper or orchestration dependency.

| Resource | Responsibility |
| --- | --- |
| Design SKILL.md | Define the experiment, required scientific choices and handoff |
| Design precision reference | ADEMP detail, fixed versus re-sampled truth, replication planning and benchmarks |
| Execution SKILL.md | Pilot, preserve outcomes, inspect diagnostics, reproduce and report |
| Workflow reference | Validated native SimDesign route and return structure |
| Failure/performance reference | Eligibility, denominator definitions, MCSE and edge cases |
| RNG/storage reference | Seed mapping, exact replay, provenance and conditional scaling |
| Synthetic R asset | One editable, complete original study with known targets |
| Targeted validation script | Developer checks exposing scientific and engine failure risks |
| Validation document | Sanitized evidence, tested versions, behavioral sample and limits |

SKILL.md entry points remain short; references load when their specific decision arises. The asset is an example to adapt, not an executable dependency of every simulation task. No folders exist for deferred methods.

## Scientific Data Flow

The condition table defines the DGP settings. Fixed population quantities pass through `fixed_objects`. Each generated dataset is analyzed once by the specified methods. Raw records preserve the outcome of each attempt, including unavailable estimates and intervals. Summaries declare which records contribute to each statistic.

The starter uses a single OLS fit and two interval constructions. This keeps the comparison paired and the native model visible. It evaluates natural rank failure without pretending OLS has an iterative convergence status. Expected failures are retained; unexpected engine errors stop the strict run.

The same responsibility split supports a domain estimator later, but the estimator's identification, convergence and admissibility rules need separate verification. A finite coefficient alone is not a universal success criterion.

## Composition and Distribution

Use applied or psychometric expertise when the scientific method needs it. Use the optional research-coding core for code organization and publishing expertise for document rendering. This plugin does not depend on another plugin's installation or copy its policy.

The plugin directory remains the distribution/versioning unit with `.codex-plugin/plugin.json`, `.claude-plugin/plugin.json` and `.antigravity-plugin/plugin.json` adapters. All record release 0.1.0 and follow the existing independent tag/catalog process. The plugin introduces no MCP server or statistical package installation.

Synthetic runtime artifacts stay under the ignored plugin `output/` directory. Public evidence consists of new code, formulas, test procedures and summarized numerical results. Private source scripts, templates, identifiers and data are not part of the plugin.
