# Development Validation and Integration Handoff

Review date: 2026-10-29. This is evidence for the initial functional development slice, not a release announcement or certification of every format/backend.

## Identity and Scope

- Worker branch: `epic/research-data-20261029`.
- Starting commit: `8068a4740976d77561fbd2750ebb48b309e0221b`; the worktree was clean at intake.
- Repository change scope: `plugins/r-data-wrangling/`.
- Delivery: two skill entry points, five conditional references, two compatibility manifests, plugin documentation/license and one synthetic check script.
- Manifests remain `0.0.0`; the initial `0.1.0` version/tag/catalog decision belongs to the coordinator's release step.

The primary author was the sole repository writer. Independent agents reviewed public methods/draft instructions and fresh user requests. An attempted delegated private-source inventory produced no usable result; the primary author completed that reading directly. No private analysis was executed.

## Authoring and Method Evidence

The root agent instructions, architecture, roadmap, naming/release rules, all four Research Methods EPIC documents, the core R coding skill and its relevant style/verification references were read. Local `skill-creator` guidance and validator source were inspected. Installed `plugin-creator` creation, local-plugin and component guidance was applied with the repository's compatibility manifests taking precedence over cloud or root-manifest defaults.

Official package documentation and R4DS supported the decisions. Installed haven S3 method bodies were inspected for SPSS `is.na()`, `zap_missing()`, `zap_labels()` and `as_factor()`; the public review also inspected dplyr join and tidyr pivot source. The existing public [tidy-r skill](https://github.com/statzhero/tidy-r-skill/blob/main/SKILL.md) was a design comparison, not a dependency or copied source. This plugin retains the repository's task-specific missing-value decisions and editable native R style. A second public skill fetch was unreliable and is not counted as a completed review.

Primary API links and checked versions appear next to each conditional procedure. No private paths, filenames, source snippets, study values, object names or identifiable details were transferred into the plugin. All packaged fixtures were newly authored and synthetic.

## Structural Checks

- Official local `skill-creator/scripts/quick_validate.py`: both entry points returned `Skill is valid!`.
- Both JSON manifests parsed; name, version, metadata types and the local skills directory were checked against the repository's existing layout.
- Claude Code 2.1.312 `plugin validate --json`: success, no manifest errors or manifest warnings. Its separate directory advice noted a missing icon and marketplace installation line. These are deferred publication concerns; this unpublished slice does not invent a catalog entry or add decorative scaffolding.
- The installed Codex plugin command offered no validation subcommand. No Codex installation/loading claim follows from JSON validation.
- Internal Markdown links and nonempty directories were checked before committing. Skill frontmatter contains only `name` and `description`; no runtime dependency on creator tools or sibling plugins was introduced.

CLI validation is distinct from loading a plugin in a host. The fresh agent cases below do not certify native host discovery.

**Operational caveat:** querying the installed Claude launcher for help unexpectedly invoked `mise use -g` before displaying help. Its output reported zero tools installed and one already installed. The launcher may have rewritten global tool-selection configuration; there was no prior snapshot, so unchanged global configuration cannot be asserted. Subsequent validation used the existing Claude binary directly, and no configuration rollback was attempted.

## Numerical and Example Execution

Executed with `Rscript --vanilla` using only synthetic inputs. No R packages were installed, and no project startup files or private analyses were sourced. Temporary SAV/XLSX/RDS/CSV files exercised format boundaries.

| Component | Version actually run |
| --- | --- |
| R | 4.6.1 |
| dplyr / tidyr / readr | 1.2.1 / 1.3.2 / 2.2.0 |
| readxl / haven / labelled | 1.5.0.1 / 2.5.5 / 2.16.1 |
| stringr / forcats / lubridate | 1.6.0 / 1.0.1 / 1.9.5 |
| writexl, fixture construction only | 2.0.1 |

The readxl website described 1.6.0 during review. Runtime results above concern the installed 1.5.0.1, not that website build.

Reproduce from the repository root:

```bash
Rscript --vanilla plugins/r-data-wrangling/tests/synthetic-cases.R
```

Final test-script SHA-256: `385c3e2e5c23ba37cbef3bf905751e2f8d8710846a99c35dc0228fce9eaa5d8b`.

| Group | Actual evidence |
| --- | --- |
| 01. Delimited semantics | Character IDs `0007, 0042, 0100`; decimal-comma readings `1.5, NA, 0`; correct dates; literal status `NA`; zero parsing problems; significant whitespace preserved when requested. |
| 02. Excel | Text IDs retain zeros; numeric cells imported as text yield `7, 42`; padding works only under the supplied width rule. Date values survive. |
| 03. SPSS and partial labels | SAV round-trip retains codes, labels and discrete user missings. Derived values `1, 2, 7, NA, NA, NA`; 3 missing observations. Label-only factor conversion would create a fourth missing value by dropping observed code `2`. |
| 04. Tagged values and exports | Two tags retained as separate reasons; conversion leaves 3 ordinary missings. RDS restores the full labelled/tagged/factor object exactly. CSV values survive explicit reimport while the supplied variable label is lost. |
| 05. Recoding | Supplied reversal produces `5, 3, 1, NA, NA` and flags one invalid observed code. Uniform selected-column recodes preserve IDs; factor reference and date order checked. |
| 06. Cardinality and coverage | 5 visit rows retained, 3 matched, 2 unmatched and 1 unused registry record. Conflicting matched keys trigger a native many-to-one error. Unused duplicate right keys demonstrate why global key checks are separate. |
| 07. Unmatched direction and NA keys | Left-only keys survive `left_join(unmatched = "error")`; right-only keys trigger the expected native error. Missing identifiers match only under the chosen `"na"` policy. |
| 08. Binding | Conflicting label maps produce a warning; explicit synthetic dictionary harmonization preserves distinct meanings and source identity. |
| 09. Longitudinal unit | 3 participants become 6 records, with 3 missing readings. Wide/long round-trip recovers values; usable counts `2, 1, 0`, participant means `11, 8, NA`. |
| 10. Multiple measures | Six composite keys, integer occasions/elapsed values and correct readings survive `.value` pivoting. A row is retained when another generated measure is observed despite a missing reading. |
| 11. Presence and duplicate cells | A recorded missing visit differs from an absent visit. Completion preserves that distinction. Duplicate pivot cells produce inspectable list values and a warning; zero filling is shown to change meaning. |

The final run exited 0 and printed `ALL 11 SYNTHETIC CASE GROUPS PASSED`. All seven fenced R example blocks in the five references were also executed, in a fresh R process per reference, with exit 0.

Two initial **test assertion defects** were corrected before the final run: a SAV import adds a `format.spss` attribute to an otherwise preserved character ID, and the actual right-unmatched error class is `dplyr_error_join_matches_remaining`. Values and metadata are now checked separately. Independent source review of the final test file found no blocker.

## Read-only Internal Workflow Review

The primary author read six workflow sources: four from research materials and two from teaching materials. Four were read in full; the initial sections of two longer documents were read only partially. Three research sources belonged to pre-2025 collections; one later source illustrated a more automated workflow. The teaching materials supplied older instructional examples. Collection context informs this comparison; it is not a verified creation-date history or an exhaustive corpus audit.

The older materials favored short visible sequences of import, inspection, explicit recoding, labels, counts and descriptive summaries. They also showed the need to harmonize meanings separately by occasion before stacking, preserve factor/value-label distinctions, and make group denominators visible. The later material added systematic separation of missing reasons and multiple data representations alongside more extensive helpers and inferential automation.

The plugin adopts those methodological needs through native editable calls, retained originals, explicit dictionaries, coverage tables and recorded-versus-absent indicators. Historical catch-all missing categories, routine complete-case filters and automated modeling/helper architectures were not carried forward. No private script was run or edited, and no participant dataset was read. Only generalized needs informed the authored synthetic material.

## Independent Agent Behavior Cases

A fresh agent received the two skill cards and read both entry points and all five references. It did not receive the implementation discussion, numerical test script, validation report or the author's prior conclusions. The cases distinguish explicit invocation, selection from supplied descriptions and two negative requests. This is a bounded manual agent evaluation, not a host-discovery benchmark.

| Case | Request and observed response | Evidence level |
| --- | --- | --- |
| A. Explicit import | Semicolon data with IDs `00012, 00340, 00056`, decimal commas, blanks and a meaningful literal `NA`; a labelled SPSS vector with an unlabeled observed code and a user-missing code. The agent produced explicit reader types/locale, retained raw codes and labels, separated missing reasons, and left the unlabeled code's meaning unresolved. | Generated code and source review only. The attempted execution returned an aborted tool response without a usable exit result or job handle. Completion is unknown; it is not counted as a passing execution and was not replayed. |
| B. Natural selection | Repeated readings, an inconsistent registry, per-person means under a supplied rule, and coverage diagnostics. The agent selected the transformation skill from the two provided descriptions, preserved unresolved conflicting rows and produced visible joins, pivots and summaries. | The primary author executed the returned R snippet once, without changing its computational operations. Exit 0; actual outputs below. |
| C1. Negative: missing-data inference | Choose and fit multiple imputation for clustered ordinal survey data. The agent routed the methodological choice and analysis to applied analysis; these skills could only prepare supplied data definitions. | Routing response reviewed; no inferential model fitted. |
| C2. Negative: latent measurement | Choose and fit WLSMV confirmatory factor analysis. The agent routed measurement/model decisions to psychometrics; preparation would follow declared coding rules. | Routing response reviewed; no latent model fitted. |

Case B used three synthetic participants with readings `(4, 6)`, `(NA, 3)` and `(NA, NA)`. Its registry gave the first participant two conflicting groups, the second one group, omitted the third and added one registry-only participant.

Observed results: six longitudinal rows remained six after integration; the three participant summaries had usable counts `2, 1, 0` and means `5, 3, NA`. The registry conflict was reported with both original rows, and no arbitrary group was assigned. Two reading participants had registry coverage, one lacked coverage, and one registry record had no readings. A four-person inspection table retained the registry-only participant without inventing visit counts or measurements. Neither missing measurements nor unresolved group membership were turned into zero.

These results support the intended data-preparation behavior for the sampled requests. Case A's unknown execution and the absence of native host loading remain explicit limits.

## Limits and Coordinator Handoff

This slice establishes bounded in-memory procedure and API behavior, not statistical validity for a new study.

- SPSS discrete user-missing codes have a file round-trip; missing ranges and tagged missings were tested in memory. SAS/Stata file round-trips are untested.
- Excel tests cover simple cell types and date values, not every date system, custom numeric display format, timezone/DST behavior or recovery of already-rounded digits.
- Equality joins, basic row binding and deterministic aggregation are covered. Database/lazy tables, fuzzy/rolling/interval joins, large-data performance and arbitrary custom classes are not.
- Imputation choices, score validity, survey variances and model estimators remain handoffs. Separate plugin support does not certify survey-plus-imputation or latent-model combinations.
- Native Codex/Claude loading and installation were not tested. Natural-language selection among supplied skill cards is narrower than host discovery.

Integrate the plugin-only delivery commit from this branch after reviewing its diff. The coordinator owns shared README/architecture/roadmap updates, cross-plugin composition, the final `0.1.0` version decision and any later tag/catalog publication. No public tag, push, catalog change or modification of another plugin was performed by this worker.

Before release, sample the data-to-analysis and data-to-psychometrics handoffs and check native host loading in an isolated supported setup.
