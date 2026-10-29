# Joins and Binding

Read when combining in-memory research tables. Establish both row units and complete keys before choosing an operation. These examples concern equality joins; database, fuzzy, rolling and interval joins are outside this initial validation.

## Check Identity and Coverage Separately

Inspect key types/formats, missing components and duplicate key combinations on **both** sides. A repeated participant ID can be legitimate in visits, while participant plus occasion should identify a visit. A lookup may have unused duplicate keys that a join's match constraint never encounters.

Choose which rows must remain. Use `left_join()` to retain left records, `inner_join()` only for an intentional matched population and `full_join()` for both populations. Record losses/expansions. Use explicit `by`, never all shared column names by accident.

```r
library(dplyr)

visits <- tibble::tibble(
  record_id = c("0007", "0007", "0042", "0100", NA_character_),
  occasion = c(1L, 2L, 1L, 1L, 1L)
)
registry <- tibble::tibble(
  record_id = c("0007", "0042", "0999"),
  group = c("A", "B", "C")
)
visit_key_duplicates <- visits |>
  count(record_id, occasion) |>
  filter(n > 1)
registry_key_duplicates <- registry |>
  count(record_id) |>
  filter(n > 1)
unmatched_visits <- anti_join(
  visits, registry, by = join_by(record_id), na_matches = "never"
)
unused_registry <- anti_join(
  registry, visits, by = join_by(record_id), na_matches = "never"
)
integrated <- left_join(
  visits,
  registry |> mutate(registry_match = TRUE),
  by = join_by(record_id),
  relationship = "many-to-one",
  na_matches = "never"
)
match_counts <- integrated |>
  summarise(
    records = n(),
    matched_records = sum(!is.na(registry_match)),
    unmatched_records = sum(is.na(registry_match))
  )
```

There are five retained visit records, three matched records, two unmatched records (`0100` and a missing ID), and one unused registry record (`0999`). This is record coverage, not the number of distinct matched people. The added marker detects a match even when a matched descriptive field is itself missing.

## Native Constraints Have Specific Meanings

| Control | What it checks or changes | What it does not establish |
| --- | --- | --- |
| `relationship = "many-to-one"` | Each left row matches at most one right row | Complete coverage or globally unique right keys |
| `relationship = "one-to-one"` | At most one match per row on both sides | Correct substantive identity or complete coverage |
| `relationship = "many-to-many"` | Allows multiplicity without a relationship check | That the expansion is intended |
| Left join `unmatched = "error"` | Rejects unmatched **right** rows that would be dropped | That every left row found a match |
| `na_matches = "never"` | Missing keys do not match each other | That missing identifiers have been repaired |

For missing person/record IDs, `"never"` is often appropriate; use the same deliberate policy in anti-joins. Cardinality constraints are available in dplyr 1.1.1 and later; verify the installed API instead of adding a hidden fallback.

If a key repeats unexpectedly, examine conflicting records and the actual unit. Add a missing key component, aggregate under a declared rule, or apply a justified record-selection policy. Do not use `distinct(..., .keep_all = TRUE)`, `multiple = "first"` or arbitrary row order to hide conflicts. Inspect overlapping non-key columns before coalescing suffixed fields.

## Row Binding Is Schema Work

Before `bind_rows()`, align column names, types, units, factor schemes, missing codes and label dictionaries. Matching names and compatible R types do not establish matching meanings. An absent column becomes `NA`; record whether it was not collected or merely missing in that input.

`bind_rows(list(wave_a = table_a, wave_b = table_b), .id = "source")` can retain a source indicator for authorized nonidentifying source labels. Keep substantive occasion keys too. Haven may warn about conflicting value labels and keep a left-side assignment; resolve the dictionary before stacking rather than accepting order-dependent metadata.

Use `purrr::map()` with `list_rbind()` for genuinely uniform collections only when useful. Do not build a reader/cleaner framework for two differently documented inputs. `bind_cols()` aligns positions and must not substitute for an identity join.

Checked: dplyr 1.2.1 and haven 2.5.5, including deliberately failing multiplicity and unmatched-direction cases. See [validation](../../../docs/validation.md).

Sources: [dplyr joins](https://dplyr.tidyverse.org/reference/mutate-joins.html), [binding rows](https://dplyr.tidyverse.org/reference/bind_rows.html), [R4DS joins](https://r4ds.hadley.nz/joins.html), [haven labelled coercion source](https://github.com/tidyverse/haven/blob/main/R/labelled.R).
