# Repeated Observations

Read when names encode occasions/items, records are missing, or the unit changes between long and wide. Reshaping rearranges recorded data; it does not establish a missing-data strategy or independence between repeated observations.

## Preserve the Observation Key

Write down the target key, such as participant plus occasion, or participant plus occasion plus item. Inspect duplicates at that full key. A duplicate may reflect a repeated trial or rater that needs its own key component. Do not average it solely to get one pivot cell.

```r
library(dplyr)
library(tidyr)

wide <- tibble::tibble(
  record_id = c("0007", "0042", "0100"),
  reading_w1 = c(10, NA, NA),
  reading_w2 = c(12, 8, NA)
)
long <- wide |>
  pivot_longer(
    cols = starts_with("reading_w"),
    names_to = "occasion",
    names_prefix = "reading_w",
    names_transform = list(occasion = as.integer),
    values_to = "reading",
    values_drop_na = FALSE
  )
cell_duplicates <- long |>
  count(record_id, occasion) |>
  filter(n > 1)
reconstructed <- long |>
  pivot_wider(
    id_cols = record_id,
    names_from = occasion,
    names_prefix = "reading_w",
    values_from = reading
  )
```

The long table has six rows and three missing readings; it retains the participant with two missing outcomes. The reconstructed table recovers the input values. Compare rows by keys and columns by names when checking a round-trip, rather than trusting incidental order.

Specify `id_cols` deliberately: otherwise unused columns can become identifiers and split the intended output unit. Duplicate cells can produce list columns and a warning, not necessarily an error; inspect the key and output column types. `values_fn = mean` is an aggregation rule requiring a rationale.

For names such as `reading_w1, reading_w2, elapsed_w1, elapsed_w2`, use `names_to = c(".value", "occasion")` with `names_pattern = "^(reading|elapsed)_w([0-9]+)$"` and an explicit occasion conversion. Check that every selected name follows the scheme and that each measure retains its own type. `names_ptypes` / `values_ptypes` validate types; `names_transform` / `values_transform` convert them.

## Distinguish Recorded Missingness From Absence

`values_drop_na = TRUE` drops rows whose generated value columns are all missing; with a single value column, this removes its explicit missing observations. `values_fill = 0` in widening supplies absent cells; it is not evidence those outcomes were zero. Preserve a presence indicator before completing a known schedule when absence matters.

```r
recorded <- tibble::tibble(
  record_id = c("0007", "0007", "0042"),
  occasion = c(1L, 2L, 1L),
  reading = c(10, NA_real_, 8)
)
# Supplied schedule: both listed participants were eligible at both occasions.
scheduled <- recorded |>
  mutate(record_present = TRUE) |>
  complete(
    record_id,
    occasion = 1:2,
    fill = list(record_present = FALSE),
    explicit = FALSE
  )
```

The recorded missing reading at `0007/2` keeps `record_present = TRUE`; the absent `0042/2` becomes a row with `FALSE`. Both outcomes remain missing.

`complete()` defaults to `explicit = TRUE`, which can also replace pre-existing missings when `fill` is supplied. Use an eligibility roster or legitimate nested combinations when schedules differ; a Cartesian product can invent impossible records. A participant absent from every input record cannot be recovered from those records alone. Check factor levels used by expansion and the status of any ungrouped/grouped data.

Carry participant, occasion and design variables into the analysis handoff. A long-format table does not justify an independent-observation model, and a participant mean changes the target compared with a visit-level outcome.

Checked: tidyr 1.3.2 and dplyr 1.2.1. The [synthetic checks](https://github.com/brianmsm/r-workflow-plugins/blob/r-data-wrangling-v0.1.0/plugins/r-data-wrangling/tests/synthetic-cases.R) cover single/multiple measures, duplicate cells, missingness and completion. See [validation](https://github.com/brianmsm/r-workflow-plugins/blob/r-data-wrangling-v0.1.0/plugins/r-data-wrangling/docs/validation.md) for actual outcomes.

Sources: [pivot_longer](https://tidyr.tidyverse.org/reference/pivot_longer.html), [pivot_wider](https://tidyr.tidyverse.org/reference/pivot_wider.html), [complete](https://tidyr.tidyverse.org/reference/complete.html), [R4DS missing values](https://r4ds.hadley.nz/missing-values.html).
