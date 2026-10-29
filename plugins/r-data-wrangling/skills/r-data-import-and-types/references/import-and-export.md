# Import, Identifiers and Export

Read for flat files, spreadsheets, date/locale decisions or derived exports. The supported workflow is an in-memory table with known column meanings. Examples are synthetic.

## Delimited Text

Make types explicit for keys and ambiguous columns; other columns can use inspected inference. If whitespace is meaningful in identifiers, set `trim_ws` deliberately; a character collector alone does not guarantee exact text preservation. Set missing tokens from the dictionary, not a universal list. If a token is valid in one column but missing in another, preserve it on import and recode the affected column. Inspect `readr::problems()` even when the reader returned a table.

```r
library(readr)

text_input <- "record_id;visit_date;reading;status
0007;31/01/2024;1,5;NA
0042;01/02/2024;;active
0100;02/02/2024;0;active"

imported <- read_delim(
  I(text_input),
  delim = ";",
  col_types = cols(
    record_id = col_character(),
    visit_date = col_date(format = "%d/%m/%Y"),
    reading = col_double(),
    status = col_character()
  ),
  locale = locale(decimal_mark = ","),
  na = "",
  show_col_types = FALSE
)
problems(imported)
imported
```

Here `"NA"` is a valid status string, the blank reading is missing, and zero is observed. IDs stay `0007, 0042, 0100`; readings are `1.5, NA, 0`. This policy is specific to this fixture. Encoding, grouping marks and date formats also require an explicit choice when ambiguous. `parse_number()` deliberately ignores surrounding text; do not use it to repair identifiers or conceal invalid measurements.

## Excel, Names and Dates

Specify the intended sheet/range and column positions/types in `read_excel()`. Its `col_types` vector is positional, unlike named readr collectors. Use `"text"` for identifier columns and `"list"` only when inspecting genuinely mixed cell types. Examine warnings and source cells before accepting coercion.

A numeric cell displayed as `0007` may store only `7`. Reading it as text cannot recover the original formatting or a long identifier already rounded by Excel. Apply `stringr::str_pad(..., width = 4, pad = "0")` only when the dictionary establishes a four-character identifier and the stored value is recoverable. Otherwise retain the observed value and report the limitation.

Inspect duplicate/empty names before accepting automatic name repair. If names change, retain an original-to-derived mapping; do not silently normalize names referenced by a dictionary or join specification.

Use `col_date(format = ...)` or a deliberate parser such as `lubridate::dmy()` for known day/month order. Retain the original text when diagnosing malformed dates. Distinguish a date from an instant: set the intended timezone for timestamps and do not reinterpret spreadsheet serial dates without establishing their date system. Filling blank spreadsheet identifiers can restore a documented layout; filling an outcome across visits is a missing-data decision.

## Export Meaning

- Keep originals unchanged. Use the requested derived destination, not a hardcoded personal path.
- Use `saveRDS()` / `readRDS()` for an R handoff requiring ordinary classes, labels, factor levels and missing metadata. This does not guarantee compatibility with every external-pointer or custom class.
- Use `readr::write_csv()` for interchange when appropriate. Supply a dictionary describing types, units, label maps, level order and missing tokens when those matter; state the read specification for character identifiers.
- Use a format-specific writer only for a requested format. Verify supported attributes and any timezone handling. CSV, Excel and statistical formats do not preserve every R attribute.
- Compare a small read-back with the intended IDs, counts, dates, category levels and missingness. A successful write establishes neither metadata preservation nor correct interpretation by another program.

Checked APIs: readr 2.2.0, readxl 1.5.0.1, stringr 1.6.0 and lubridate 1.9.5. The online readxl site described 1.6.0 during review; local evidence is for 1.5.0.1. See [validation](../../../docs/validation.md) for executed cases and limitations.

Sources: [readr readers](https://readr.tidyverse.org/reference/read_delim.html), [readxl cell/column types](https://readxl.tidyverse.org/articles/cell-and-column-types.html), [R4DS import](https://r4ds.hadley.nz/data-import.html), [R serialization](https://stat.ethz.ch/R-manual/R-devel/library/base/html/readRDS.html).
