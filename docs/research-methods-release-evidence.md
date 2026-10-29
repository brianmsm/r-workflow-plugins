# Research Methods 0.1.0 Release Evidence

Date: 2026-10-29. Scope: the first releases of `r-data-wrangling`, `r-applied-analysis`, `r-psychometrics` and `r-simulation-methods` (ten skills). The [integration record](research-methods-integration-evidence.md) preserves the earlier frozen-candidate results. This record does not certify every model-generated script or every methodological combination.

## Native Host Evidence Reviewed

Three separate host evaluations examined candidate `56151e9b095a358661ec09c43cb3e1cc2b7effea` without changing its source. Their raw transcripts, credentials context and local machine metadata are not release artifacts.

| Host | Distribution/discovery evidence | Behavioral coverage | Limit |
| --- | --- | --- | --- |
| Codex CLI 0.165.0 | Four plugins installed and enabled through an isolated marketplace; ten skills available | Nine authorized fresh cases, seven different skills actually read; positive/negative boundaries respected | Three skills were available but not directly exercised; responses were reviewed, not R-executed |
| Claude Code 2.1.312 | Four plugins loaded through `--plugin-dir`; ten skills available | Explicit and natural invocation of four representatives, resource reads and two negative controls | Original evaluation did not install from the global marketplace; some generated diagnostic code was wrong |
| Antigravity CLI 1.4.10 | Ten standalone skills loaded; temporary native adapters loaded four plugins and ten skills | Ten explicit standalone invocations, five natural tasks, four adapted-plugin representatives and negative cases | Original Codex/Claude-only manifests did not support direct native loading; generated R had specific adaptation errors |

A skill being available, being read, being followed and producing numerically correct code are different evidence levels. The original Codex authentication obstacle was resolved in its authorized follow-up; it was not a plugin defect.

## Corrections Adopted

- Add a three-field `.antigravity-plugin/plugin.json` per new plugin. Keep the original Codex and Claude adapters, independent versions and shared skill bodies.
- Replace 20 developer-evidence links leaving standalone skill folders with plugin-tag-pinned public source links. All local operational resources remain inside the respective skill.
- Narrow the regression description to the implemented linear, binary logistic, Poisson and quasi-Poisson families.
- Align coefficient/contrast identifiers before numerical comparisons; distinguish mismatched attributes from different values. Clarify HC3 leverage contributions without claiming every SE necessarily increases.
- Make survey extraction respect the return shape of `SE()` and retain the coefficient order of `vcov()`. Obtain degrees of freedom from the actual domain, not an assumed copy of the full-design value.
- Use `parTable()` for free-parameter SE diagnostics; `parameterEstimates()` has no `free` column. Include a native diagnostic table in the ordinal CFA example.
- Explain that reducing category thresholds need not change df when free parameters decrease in step. Retain scaled WLSMV reporting and native corrected model tests.
- Distinguish EFA factor retention from invariance delta-fit heuristics; interpret loading magnitudes, indicator counts and factor correlations contextually.
- Make valid-category and analysis-sample constant-item inspection explicit, while preserving the declared scoring key.
- Keep `runSimulation(design = Design, ...)` argument spelling and top-level `store_results` visible. Compute theoretical benchmarks and return claimed MCSEs rather than merely calculating and dropping them.

These are narrow responses to observed risks. No methods outside the initial scope, custom estimation wrappers, automatic package installation, duplicated host-specific skills or mandatory core dependency were added. The existing psymetrics covariance-label issue remains [upstream issue #55](https://github.com/brianmsm/psymetrics/issues/55); the package itself was not modified.

## Executed Checks After Corrections

```sh
Rscript --vanilla tests/research-methods-host-regressions.R
Rscript --vanilla plugins/r-applied-analysis/tests/numerical-validation.R plugins/r-applied-analysis
Rscript --vanilla plugins/r-psychometrics/tests/synthetic-validation.R plugins/r-psychometrics
Rscript --vanilla tests/research-methods-composition.R
```

All four commands exited 0. The new regression suite has seven groups: aligned named values; survey SE and df (4 full versus 2 domain); an injected unavailable free-parameter SE; unchanged df after threshold reduction; impossible responses/constant items; SimDesign argument spelling/nesting; and the computed normal-critical-value coverage benchmark (0.9343315 at 18 df). The applied suite passed 62 numerical/plot-construction checks, the psychometric suite executed its documented recipes, and all four cross-plugin composition checks passed.

All ten skills pass the available structural validator. Every bundled relative resource resolves inside its standalone skill root. All four new Antigravity manifests pass `agy plugin validate --strict --json` without errors or warnings; missing decorative logos are nonblocking notes. No statistical package or agent binary was installed or updated for these tests.

## Focused Model Follow-ups

A new Claude session demonstrably loaded the CFA skill and both relevant references, returned the `parTable()` SE check, retained scaled indices, and correctly explained why category reduction need not change df.

New Antigravity sessions loaded the adapted simulation/EFA skills and references. The simulation response corrected both argument-placement defects; its six-replication synthetic script was subsequently executed with exit 0. The EFA response rejected a delta-CFI retention rule, but still introduced overly rigid indicator/loading heuristics; the final instruction makes their contextual role explicit. This final wording clarification was source-reviewed, not advertised as a further independent behavior success.

An initial survey follow-up returned no answer after a denied attempt to inspect a guessed R library location. It is not a passing behavior result. A separate workspace-only follow-up then returned a complete synthetic example: its executable R block passed with total 19.6, SE 7.089429, domain df 2 and full-design df 4. Its displayed console-output block was excluded from execution. Permissions were not broadened to obtain that answer.

## Release Boundary

Each plugin has its own `0.1.0` manifest set, changelog and immutable `<plugin>-v0.1.0` tag. Catalog entries follow the tags; release commits and catalogs are separate from raw testing. Installation must preserve other plugins, runtime versions, authentication and existing user settings.

The supported scientific slice remains bounded. Missing-data and mixed-model skills, measurement invariance and basic IRT are still planned. ESEM, DIF, networks, advanced latent models and combined survey/MI/multilevel inference remain outside this release. Successful loading and sampled follow-ups do not remove the need to execute and review generated research code.

## Immutable Release Targets

| Plugin | Tag | Release commit |
| --- | --- | --- |
| `r-data-wrangling` | `r-data-wrangling-v0.1.0` | `714f7ff3c4dbb79fc7429436d88867601b1f045a` |
| `r-applied-analysis` | `r-applied-analysis-v0.1.0` | `2f0fe3a29f8404adf8b005aff31cd1b8279fd2aa` |
| `r-psychometrics` | `r-psychometrics-v0.1.0` | `3c28a1e2e0ffea58d2ca3020aaaf6c65ebc3c4cc` |
| `r-simulation-methods` | `r-simulation-methods-v0.1.0` | `93f59c0864b448557b0dbb552b25ebedbd38c548` |

The catalog commit follows these release commits. Codex CLI 0.165.0 refreshes a marketplace with `plugin marketplace upgrade`; Claude Code uses `plugin marketplace update`. Consult the current agent setup guide for host-specific command spelling.

## Publication and User-Scope Installation

The integration was fast-forwarded onto main without rewriting the pre-existing local commits. The catalog commit and all four annotated tags were pushed atomically, and the remote peeled tag targets were checked against the release-commit table above. Four non-draft GitHub releases were then created.

| Host | Global/user installation | Enabled new plugins | Installed skills | Payload verification |
| --- | --- | ---: | ---: | --- |
| Codex CLI 0.165.0 | Native marketplace installation from tag-pinned Git subdirectories | 4 | 10 | Every tracked plugin file matches its published tag |
| Claude Code 2.1.312 | Native marketplace installation with user scope | 4 | 10 | Every tracked plugin file matches its published tag |
| Antigravity CLI 1.4.10 | Native install from directories extracted from exact release tags | 4 | 10 | Every tracked plugin file matches its published tag |

Each installation contains 75 tracked files in total across the four plugins (15, 19, 23 and 18). Byte comparisons covered all 225 installed copies across the three hosts. Existing plugin inventories and their activation/version fields were preserved. The global mise configuration hash remained unchanged; no agent binary or statistical package was updated.

A stale Codex marketplace snapshot existed without its source entry in user configuration. Native registration rejected the cached source and native refresh could not find a configured source. Restoring only that documented marketplace definition allowed native refresh and installation; unrelated parsed settings, including authentication, were unchanged by the repair. Claude required registration of the repository marketplace before installation. No credentials were copied or published.

These are installation and integrity checks. The behavioral evidence above remains the sampled native-session evidence; installation does not guarantee every generated analysis. Detailed per-machine logs and installation receipts remain private rather than being bundled in the public repository.
