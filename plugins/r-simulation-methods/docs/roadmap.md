# Roadmap

This is an incremental capability map, not a release announcement.

## Implemented Initial Slice

- ADEMP protocol and meaningful condition grids.
- Fixed versus condition-specific or replicate-varying truth.
- Replication planning from Monte Carlo precision.
- One small complete serial SimDesign experiment with explicit failure retention.
- Bias, empirical/model uncertainty, RMSE, conditional coverage, joint available-and-covering rates and paired coverage differences.
- Attempt, estimate, SE and interval denominators; Monte Carlo SE and boundary cases.
- Native engine diagnostics, strict unexpected-error handling, RDS traceability and successful/failed replication replay.
- A bounded two-worker PSOCK check after serial validation, with actual backend limits documented.
- Concise task entry points, four on-demand references and one original synthetic asset.

The first study is an implementation and validation example. A substantive simulation requires a domain-specific DGP, estimator assumptions and a sufficient precision budget.

## Next Extensions Only When Needed

| Extension | Evidence needed before claiming support |
| --- | --- |
| More domain estimators or multiple analysis callbacks | Known truth, convergence/admissibility rules, stable raw records and paired comparisons |
| rsimsum summaries | Installed-version verification, count/interval semantics and agreement with transparent calculations |
| Disk-backed results and automatic interruption recovery | Actual saved-state interruption, compatible resume, extraction and re-summary without dropped/duplicated attempts |
| Additional local backends or worker counts | Same-backend repetition, worker exports, stream behavior and requested cross-backend guarantees |
| Adaptive precision/power search or nested simulation | Correct stopping/estimand specification and an uncertainty calculation that reflects dependence |
| Stochastic population preparation | Preserved population realization, preparation seeds and valid conditional/unconditional interpretation |

HPC/SLURM, multi-machine execution, Mplus, Stan and external automation remain conditional extensions requiring demonstrated demand and their own execution/storage contracts. They are not empty skill folders or implied capabilities of the current starter.

## Integration

The coordinator reviews this plugin's evidence, reconciles shared root documentation and determines whether/when to release it. No catalog, root-policy, other-plugin, main-branch or release changes are required to review this first slice.
