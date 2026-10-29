---
name: r-data-transform-and-integrate
description: "Use when recoding, joining, stacking, reshaping or aggregating research tables in R, especially when keys, repeated observations, missingness or the unit of observation could change. Implements declared data rules; does not choose imputation, score validity or inferential models."
---

# R Data Transform and Integrate

Create the intended analysis table with explicit operations and inspectable intermediate objects. Default to `dplyr`, `tidyr` and relevant tidyverse helpers; keep recodes, keys and denominators visible at the point of use. The optional `r-analytic-coding-principles` skill adds broader coding guidance without being required.

## Establish What a Row Means

Identify the input and target units, composite keys, repeated observations and intended inclusion rules. Establish which table defines the retained population and which columns describe individuals, occasions or higher-level groups. Inspect types, missing codes and labels before transforming; use `r-data-import-and-types` for unresolved import semantics.

Preserve original tables. Distinguish exact duplicate rows, repeated keys, repeat measurements and conflicting records; their resolutions are substantive choices. Do not deduplicate simply to make a join or pivot succeed.

## Apply the Relevant Operation

- **Recode:** implement the declared mapping, cut points, units and level order in visible `mutate()` / `case_when()` calls. Handle missing and unexpected values explicitly. Check before/after counts; use `across()` only for columns that genuinely share a rule.
- **Join:** specify keys and the intended relationship. Inspect duplicates on both sides, unmatched rows and missing keys using the same matching policy as the join. A native `relationship` constraint checks multiplicity of matches, not coverage or universal key uniqueness. In a left join, `unmatched = "error"` checks right-side rows that would be dropped; use `anti_join(left, right)` to find unmatched left records.
- **Stack:** harmonize schemas, units, code/label maps and occasion identifiers before `bind_rows()`. Retain a source indicator where it matters. `bind_cols()` uses position, not participant identity.
- **Reshape:** state the participant/occasion/item key and the columns encoding it. Preserve substantive missing observations; diagnose duplicate cells before widening. Do not add an average or zero fill merely to remove warnings.
- **Aggregate:** declare the new unit, inclusion rule, denominator, weighting if supplied, and all-missing behavior. Keep usable counts beside results. Aggregation changes the research question; a group summary is not an independent individual observation.

## Conditional References

- [Recoding and aggregation](references/recoding-and-aggregation.md): mappings, factors, dates, uniform transformations, denominators or a change of unit.
- [Joins and binding](references/joins-and-binding.md): keys, cardinality, unmatched rows, missing identifiers or stacking inputs.
- [Repeated observations](references/repeated-observations.md): long/wide data, multi-measure names, absent occasions, duplicate cells or completion.

Read only references relevant to the requested operations.

## Verify and Hand Off

Check targeted row/key counts, match coverage, values, missingness and the resulting unit with small authorized executions. Retain substantive diagnostics and derived intermediate tables. Prefer meaningful native argument constraints over generic wrappers or persistent environment checks.

Report how rows were retained/expanded/collapsed, consequential recodes and denominators, and unresolved conflicts. Do not globally remove incomplete rows, modify default NA behavior or invent a missing-item threshold. Inferential missing-data methods and sampling variances belong to applied analysis; score validity belongs to psychometrics. The researcher can supply a deterministic rule without requiring those companion plugins.
