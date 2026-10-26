# Proportionate Verification and External Guardrails

Read when checking live R objects, editing potentially consequential statistical code, reviewing joins/inputs, or deciding whether checks belong in the analysis source. The aim is **evidence-based verification without permanent defensive scaffolding for every possibility**.

## Distinguish Four Kinds of Check

| Question | Preferred placement | Why |
| --- | --- | --- |
| Does a column or object exist **right now**? | Inspect with R tools or available session access | One-time agent fact-finding is not necessarily research output |
| Are joins, exclusions, or duplicates part of the research justification or **reported result**? | Retain the supplied descriptive statistic in the analysis | Supports a methodological decision or reported denominator; not merely a throwaway guard |
| Could an input change **silently** corrupt later results? | Inspect with tools first; consider a native argument constraint or targeted check only for a demonstrated ongoing risk | A missing file/package normally fails naturally; the check must protect something R would not detect |
| Do duplicated model sections remain mutually consistent where intended? | Review affected sections and, if needed, test using external tooling | Intentional differences must not be overwritten mechanically |

**Removing a temporary guard never authorizes dropping or replacing an analytical step or a report-facing statistic.** Preserve names, meanings, and values of requested tables/results unless the user authorizes a substantive change. Different quantities (number of distinct matching keys, number of matched rows, total records) are not interchangeable.

**Do not use downstream usage as a deletion criterion.** A grouped source table, a joined dataset, or a calculated diagnostic may be intentionally kept for interactive inspection, later exploratory decisions, or manual reruns even if the present report prints only a small coverage table. When asked to simplify validation, change only the validations that warrant change; preserve independent aggregations, joins and named intermediate objects. If removal might be useful, propose it explicitly instead of performing it silently.

**Never conflate one-time live inspection with a permanent guarantee.** A column observed today may disappear with updated data, but this does **not** justify adding `stopifnot()` to ordinary researcher-controlled `.R`, `.Rmd` or `.qmd` by default. A missing package called by `library()` or `pkg::fun()`, a missing file read by ordinary input functions, or an undefined function already commonly produces a useful R error. Prefer debugging that actual error in the agent's inspection session to permanently adding `file.exists()`, `requireNamespace()`, `tryCatch()` or custom environment-stop wrappers. Some data changes **do not** raise errors (e.g., a missing `$column` returning `NULL`); assess those with proportionate inspection instead of assuming all failures are naturally caught.

## Inspect Through Tools Before Writing Defensive Code

When user authorization and tools permit, inspect the actual object/inputs using a connected R session or an appropriately scoped `Rscript` run. Examples of **temporary inspection commands**, not blocks to inject automatically into a report:

```r
names(staff)
str(staff$site_id)
sum(is.na(staff$site_id))
anyDuplicated(staff$site_id)
```

For joins, inspect key type/format, distinct counts, expected uniqueness, match coverage, and unmatched rows as relevant. `dplyr` joins can express known cardinality constraints directly:

```r
joined <- left_join(
  schools,
  summarized_staff,
  by = "site_id",
  relationship = "many-to-one"
)
```

This is a **substantive constraint** only when each `schools` row is expected to match at most one row of `summarized_staff`; it does not assert complete matching, correct identifiers, or the absence of missing keys. Never add it as generic boilerplate without confirming the intended relationship. Use native R errors and warnings where they already expose failures clearly.

A call via `Rscript` usually starts a different process and may not share live objects or package state with an interactive R session. First establish whether the command is checking the current in-memory object, reconstructing it from known files, or merely parsing source. If inputs are unavailable, report the gap; don't invent a passing diagnostic.

## When Persistent Guards Are Justified

Consider a small persistent check **at the point of risk** only if native R/API behavior would not already reveal a **known consequential failure**, such as:

- An observed changing schema that could silently change variable definitions or records.
- A join whose unexpected cardinality would multiply rows (prefer a justified native `relationship` constraint).
- An unattended, irreversible write or a specific previously observed silent defect.

An ordinary missing package, file, path or function does **not** meet this threshold. Project-specified production/pipeline safeguards remain valid; do not remove them merely because a researcher-oriented default is lighter.

When a guard is genuinely required, express the **specific known invariant** with a native operation or a small check and an actionable failure. Do not insert `stopifnot()` as a generic availability/preflight ritual. Keep a check inside the source only when the user's/project's ongoing execution needs it; prefer external inspection for one-time facts. Avoid catch-all `tryCatch()` that returns `NULL`, `NA`, or a default model and silently changes what is reported.

By default, avoid injecting `*_safe()` wrappers around native modelling functions solely to suppress or recover from ordinary model errors. Failures during exploratory fitting often need direct diagnosis, not hidden fallback behavior.

## Verify Analytical Equivalence After Edits

Stylistic changes can silently alter conclusions. **Confirm that every newly referenced data-frame field exists at the point of use and in the actual object**, not only in a different summarized object. In R, a missing field accessed with `$` may return `NULL` rather than immediately raising an error; for example `sum(NULL, na.rm = TRUE)` returns `0`, falsely appearing valid. Before claiming an unchanged analysis, compare the relevant aspects when feasible:

- Model formulas, estimator, arguments, ordered/categorical treatment, optimization or convergence settings.
- Data filtering, joins, row counts, variable definitions, missingness treatment, and factor/reference levels.
- Random seeds, stochastic estimation settings, simulation conditions and iteration order where material.
- Output values, **field names, their provenance and units/denominators**, table structure, and graphical encodings likely to have been affected. Preserve existing coverage/matching metrics when simplifying data-key diagnostics.

Use the least expensive sufficient method:

1. **Source inspection:** confirm scope and formulas; useful, but not proof of equal results.
2. **Parse/static inspection:** identify syntax defects; does not execute analysis.
3. **Live object inspection:** check known existing objects in their session; not proof of a clean run.
4. **Targeted execution:** run only the affected step when dependencies are available and permitted.
5. **Clean-session run:** establish that the documented source order reconstructs the analysis, when the deliverable requires it.
6. **Numerical comparison:** check actual results with stated tolerances and known stochastic variability when claiming equivalence.

When data are available and execution is allowed, compare the smallest old/new calculation on existing or clearly labeled synthetic fixture inputs. If results or reported fields diverge unexpectedly, do not present the edit as style-only. Without data, preserve the original expressions and report what was not verified.

Do not automatically execute expensive CFA/SEM models, bootstraps, long Monte Carlo studies, or heavy renders to validate a formatting-only edit. If a full rerun is necessary and cannot be done, state that limitation rather than asserting success. If the user has prohibited execution, do source-only checks.

## Intentional Repetition and Consistency

Repeated, individually editable blocks can drift. That is an **accepted trade-off**, not a reason to replace the whole analysis with a loop. Instead:

- Identify which settings are intentionally shared (e.g., dataset, confidence level) versus intentionally different (formula, items, annotations).
- Compare only settings that should be shared; flag ambiguities for the researcher without rewriting differences by assumption.
- When copying a block, update object names, section headings, references, captions, and directly relevant arguments together.
- Avoid silent reuse of a previous model object when a section claims to estimate a new model.

For recurrent projects, an **optional external audit script** could report duplicated names, unresolved objects, or discrepancies between a declared comparison table and model definitions. Such a tool must permit intentional divergence and clearly state what it cannot infer. It should be introduced only after real cases justify maintenance cost.

## Hooks and CI Are Not the Default

Do not install hooks, `pre-commit`, CI jobs, `lintr`, `styler`, schema contracts, or runtime wrappers merely to comply with this skill. They may be suitable for team-maintained or regularly rerun projects, but a Git hook cannot by itself establish the methodological correctness of several model specifications. If requested, design non-destructive, opt-in checks external to the working analytical script and document their limitations.

## Evidence Report

For any consequential edit, briefly distinguish:

- What was changed and what analytical choices were preserved.
- What was actually inspected or run, using which available environment.
- What remains unverified (missing data, unavailable live R session, prohibitively expensive run, or deliberate non-execution).
- Whether a persistent check was added and the **specific** risk that justified it.
