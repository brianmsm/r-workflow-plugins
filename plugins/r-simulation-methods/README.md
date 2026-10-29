# R Simulation Methods

**Release: 0.1.0.** Independently versioned as `r-simulation-methods-v0.1.0`, with Codex, Claude Code and Antigravity CLI adapters. Native discovery and sampled behavior are documented in the [release evidence](https://github.com/brianmsm/r-workflow-plugins/blob/r-simulation-methods-v0.1.0/docs/research-methods-release-evidence.md); this is not a guarantee that arbitrary generated code is correct.

## Skills

| Skill | Primary request | Resources |
| --- | --- | --- |
| [r-simulation-design](skills/r-simulation-design/SKILL.md) | Plan or review a method-evaluation, simulation-based power or precision study | ADEMP, conditions/truth, eligibility and replication planning |
| [r-simulation-execution-and-evaluation](skills/r-simulation-execution-and-evaluation/SKILL.md) | Implement, inspect, debug, replay and summarize a specified experiment | Native SimDesign workflow, failures/performance, RNG/storage and one synthetic starter |

Example requests:

- "Use `r-simulation-design` to plan a paired comparison of two confidence-interval methods with a coverage MCSE target."
- "Use `r-simulation-execution-and-evaluation` to implement a small serial SimDesign study and retain failed fits in the attempt counts."
- "Review these simulation results: which estimates and intervals enter each denominator, and can this failed replication be replayed?"

The plugin works independently. The optional `r-analytic-coding-principles` capability helps maintain editable research code; applied-analysis or psychometrics expertise supplies domain-specific estimator assumptions. No private folders, sibling-plugin paths, particular R MCP, or external simulation engine are required.

## Run the Complete Example

From this plugin directory:

```sh
Rscript --vanilla skills/r-simulation-execution-and-evaluation/assets/bernoulli-slope-study.R
```

The script runs a tiny serial pilot, then 500 independent attempts in each of four cells. It compares Student t and normal intervals for one OLS slope under a binary predictor. Samples without predictor variation remain as failed-to-identify records. Analytical failure probabilities, conditional RMSE and coverage provide independent benchmarks.

The explicit `output/bernoulli-slope-study/` destination receives a full experiment RDS, per-replication and performance CSVs, and a coverage PNG. Output artifacts are ignored by Git. When adapting the file, change its scientific inputs, output destination and source-fingerprint path locally.

Validated with R 4.6.1, SimDesign 2.28, dplyr 1.2.1, tidyr 1.3.2, ggplot2 4.0.3 and readr 2.2.0. The example also uses an occasional scales call for axis labels. It does not install or alter packages. rsimsum is an optional, documentation-reviewed extension, not a tested dependency.

## Validation and Limits

```sh
Rscript --vanilla tests/validate-simulation.R
```

The targeted validation reruns the example and checks analytical targets, manually calculable summaries, missing/failed results, engine redraws, unexpected exceptions, warning counts, fatal rows, stored-seed replay, and a bounded two-worker PSOCK case after serial validation.

See [validation evidence](docs/validation.md) for exact results and limits. Source review, executed numerical tests and sampled agent behavior are recorded separately. Local PSOCK repeated exactly within its tested configuration; serial and PSOCK outputs differed under the same condition seeds. Automatic interruption recovery, alternative parallel backends, HPC/SLURM, multi-machine execution and external Mplus/Stan orchestration are conditional future work.

See [architecture](docs/architecture.md), [roadmap](docs/roadmap.md) and [changelog](CHANGELOG.md) for the maintained scope. The Codex/Claude conventions are preserved alongside the Antigravity adapter. The original development validation and subsequent native-host evidence are distinguished in the release record.

## Installation

From the registered `r-workflow-plugins` marketplace:

```sh
codex plugin add r-simulation-methods@r-workflow-plugins
claude plugin install --scope user r-simulation-methods@r-workflow-plugins
```

For Antigravity CLI, install a local directory extracted from `r-simulation-methods-v0.1.0` with `agy plugin install <directory>`. See the [agent setup guide](https://github.com/brianmsm/r-workflow-plugins/blob/r-simulation-methods-v0.1.0/docs/agent-setup.md) for registration, exact tag extraction and native invocation.
