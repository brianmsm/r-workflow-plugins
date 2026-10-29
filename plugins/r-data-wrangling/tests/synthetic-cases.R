# Synthetic behavioral/API checks for the initial research-data slice.
# Run with Rscript --vanilla from any working directory.
# Assertions and captured expected errors belong to this test file only.
# All data are new synthetic fixtures; no project/source data are read.
library(dplyr)
library(tidyr)
library(readr)

cat(R.version.string, "\n")
print(tibble::tibble(
  package = c("dplyr", "tidyr", "readr", "readxl", "haven", "labelled",
              "stringr", "forcats", "lubridate", "writexl"),
  version = c(as.character(packageVersion("dplyr")),
              as.character(packageVersion("tidyr")),
              as.character(packageVersion("readr")),
              as.character(packageVersion("readxl")),
              as.character(packageVersion("haven")),
              as.character(packageVersion("labelled")),
              as.character(packageVersion("stringr")),
              as.character(packageVersion("forcats")),
              as.character(packageVersion("lubridate")),
              as.character(packageVersion("writexl")))
))

# 1. Character IDs, decimal comma, dates, literal NA status ----
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
stopifnot(
  identical(imported$record_id, c("0007", "0042", "0100")),
  identical(imported$reading, c(1.5, NA_real_, 0)),
  identical(imported$status, c("NA", "active", "active")),
  identical(imported$visit_date, as.Date(c("2024-01-31", "2024-02-01", "2024-02-02"))),
  nrow(problems(imported)) == 0L
)
whitespace_ids <- read_csv(
  I("record_id\n 0007 \n0042\n"),
  col_types = cols(record_id = col_character()),
  trim_ws = FALSE, na = "", show_col_types = FALSE
)
stopifnot(identical(whitespace_ids$record_id, c(" 0007 ", "0042")))
cat("PASS 01: CSV IDs, locale, dates, missing tokens and deliberate whitespace\n")

# 2. Excel: text identity differs from numeric storage ----
excel_path <- tempfile(fileext = ".xlsx")
excel_input <- tibble::tibble(
  record_id = c("0007", "0042"),
  numeric_id = c(7, 42),
  reading = c(1.5, NA_real_),
  visit_date = as.Date(c("2024-01-31", "2024-02-01"))
)
writexl::write_xlsx(list(observations = excel_input), excel_path)
excel_import <- readxl::read_excel(
  excel_path,
  sheet = "observations",
  col_types = c("text", "text", "numeric", "date")
)
stopifnot(
  identical(excel_import$record_id, c("0007", "0042")),
  identical(excel_import$numeric_id, c("7", "42")),
  identical(excel_import$reading, c(1.5, NA_real_)),
  identical(as.Date(excel_import$visit_date), excel_input$visit_date)
)
# Supplied dictionary width, not inferred from the largest ID.
stopifnot(identical(
  stringr::str_pad(excel_import$numeric_id, width = 4, pad = "0"),
  excel_import$record_id
))
cat("PASS 02: Excel text IDs preserved; numeric IDs require a declared width\n")

# 3. SPSS round-trip, incomplete labels and user-missing values ----
original <- tibble::tibble(
  record_id = c("0007", "0042", "0100", "0210", "0350", "0480"),
  response = haven::labelled_spss(
    c(1, 2, 7, 97, 99, NA_real_),
    labels = c(low = 1, high = 7, not_applicable = 97, not_recorded = 99),
    na_values = c(97, 99),
    label = "Recorded category"
  )
)
sav_path <- tempfile(fileext = ".sav")
haven::write_sav(original, sav_path)
retained <- haven::read_sav(sav_path, user_na = TRUE)
collapsed_on_import <- haven::read_sav(sav_path, user_na = FALSE)
stopifnot(
  identical(as.character(retained$record_id), original$record_id),
  identical(attr(retained$record_id, "format.spss"), "A4"),
  identical(as.double(retained$response), c(1, 2, 7, 97, 99, NA_real_)),
  identical(attr(retained$response, "na_values"), c(97, 99)),
  identical(labelled::var_label(retained$response), "Recorded category"),
  identical(labelled::val_labels(retained$response), labelled::val_labels(original$response)),
  sum(is.na(retained$response)) == 3L,
  sum(is.na(as.double(retained$response))) == 1L,
  identical(as.double(collapsed_on_import$response), c(1, 2, 7, NA, NA, NA))
)
dictionary <- labelled::look_for(retained)
stopifnot(nrow(dictionary) == 2L)
prepared <- retained |>
  mutate(
    response_code = as.double(response),
    missing_reason = case_when(
      response_code == 97 ~ "not_applicable",
      response_code == 99 ~ "not_recorded",
      is.na(response_code) ~ "system_missing",
      .default = NA_character_
    ),
    response_numeric = as.double(haven::zap_missing(response))
  )
category_default <- haven::as_factor(haven::zap_missing(retained$response), levels = "default")
category_labels <- haven::as_factor(haven::zap_missing(retained$response), levels = "labels")
stopifnot(
  identical(prepared$response_numeric, c(1, 2, 7, NA, NA, NA)),
  identical(prepared$missing_reason, c(NA, NA, NA, "not_applicable", "not_recorded", "system_missing")),
  identical(as.character(category_default), c("low", "2", "high", NA, NA, NA)),
  sum(is.na(category_default)) == 3L,
  sum(is.na(category_labels)) == 4L
)
range_example <- haven::labelled_spss(c(1, 90, 94, NA_real_), na_range = c(90, 99))
stopifnot(identical(as.double(haven::zap_missing(range_example)), c(1, NA, NA, NA)))
cat("PASS 03: SPSS codes/labels preserved; 3 missings; label-only conversion loses code 2\n")

# 4. Tagged missing reasons and RDS/CSV metadata contrast ----
tagged <- haven::labelled(
  c(2, haven::tagged_na("a"), haven::tagged_na("b"), NA_real_),
  labels = c(refused = haven::tagged_na("a"), unavailable = haven::tagged_na("b")),
  label = "Synthetic measurement"
)
tag_reason <- haven::na_tag(tagged)
stopifnot(
  identical(tag_reason, c(NA, "a", "b", NA)),
  sum(haven::is_tagged_na(tagged)) == 2L,
  !any(haven::is_tagged_na(haven::zap_missing(tagged))),
  sum(is.na(haven::zap_missing(tagged))) == 3L
)
rds_path <- tempfile(fileext = ".rds")
saveRDS(list(original = original, tagged = tagged, category = category_default), rds_path)
stopifnot(identical(readRDS(rds_path), list(original = original, tagged = tagged, category = category_default)))
csv_path <- tempfile(fileext = ".csv")
export_ready <- prepared |> select(record_id, response_numeric, missing_reason)
labelled::var_label(export_ready$response_numeric) <- "Analysis response code"
write_csv(export_ready, csv_path, na = "")
csv_roundtrip <- read_csv(
  csv_path,
  col_types = cols(record_id = col_character(), response_numeric = col_double(), missing_reason = col_character()),
  na = "",
  show_col_types = FALSE
)
stopifnot(
  identical(csv_roundtrip$record_id, as.character(prepared$record_id)),
  identical(csv_roundtrip$response_numeric, prepared$response_numeric),
  identical(csv_roundtrip$missing_reason, prepared$missing_reason),
  identical(labelled::var_label(export_ready$response_numeric), "Analysis response code"),
  is.null(attr(csv_roundtrip$response_numeric, "label"))
)
cat("PASS 04: tagged reasons captured; RDS exact; CSV values survive with explicit schema\n")

# 5. Declared reversal, unexpected values and auxiliary types ----
responses <- tibble::tibble(response = c(1, 3, 5, NA_real_, 8))
recoded <- responses |>
  mutate(
    unexpected = !is.na(response) & !(response %in% 1:5),
    reversed = case_when(
      is.na(response) ~ NA_real_,
      response %in% 1:5 ~ 6 - response,
      .default = NA_real_
    )
  )
reference_factor <- forcats::fct_relevel(
  factor(c("routine", "priority", NA_character_), levels = c("routine", "priority")),
  "priority"
)
stopifnot(
  identical(recoded$reversed, c(5, 3, 1, NA, NA)),
  sum(recoded$unexpected) == 1L,
  identical(responses$response, c(1, 3, 5, NA, 8)),
  identical(levels(reference_factor), c("priority", "routine")),
  identical(lubridate::dmy(c("13/02/2024", "01/03/2024")), as.Date(c("2024-02-13", "2024-03-01")))
)
uniform <- tibble::tibble(record_id = c("0007", "0042"), item_a = c(1, 99), item_b = c(99, 3)) |>
  mutate(across(c(item_a, item_b), ~ na_if(.x, 99)))
stopifnot(
  identical(uniform$record_id, c("0007", "0042")),
  identical(uniform$item_a, c(1, NA_real_)),
  identical(uniform$item_b, c(NA_real_, 3))
)
cat("PASS 05: specified recodes, missing branches, factor reference and date order\n")

# 6. Join coverage, native cardinality failure and unused duplicates ----
visits <- tibble::tibble(
  record_id = c("0007", "0007", "0042", "0100", NA_character_),
  occasion = c(1L, 2L, 1L, 1L, 1L)
)
registry <- tibble::tibble(record_id = c("0007", "0042", "0999"), group = c("A", "B", "C"))
unmatched_visits <- anti_join(visits, registry, by = join_by(record_id), na_matches = "never")
unused_registry <- anti_join(registry, visits, by = join_by(record_id), na_matches = "never")
integrated <- left_join(
  visits, registry |> mutate(registry_match = TRUE),
  by = join_by(record_id), relationship = "many-to-one", na_matches = "never"
)
stopifnot(
  nrow(integrated) == 5L,
  sum(!is.na(integrated$registry_match)) == 3L,
  identical(unmatched_visits$record_id, c("0100", NA_character_)),
  identical(unused_registry$record_id, "0999"),
  nrow(count(visits, record_id, occasion) |> filter(n > 1)) == 0L
)
conflicting_registry <- bind_rows(registry, tibble::tibble(record_id = "0007", group = "D"))
cardinality_error <- tryCatch(
  left_join(visits, conflicting_registry, by = join_by(record_id),
            relationship = "many-to-one", na_matches = "never"),
  error = identity
)
stopifnot(inherits(cardinality_error, "dplyr_error_join_relationship_many_to_one"))
unused_duplicates <- bind_rows(registry, tibble::tibble(record_id = "0999", group = "E"))
unused_duplicate_keys <- unused_duplicates |> count(record_id) |> filter(n > 1)
not_global_uniqueness <- left_join(
  visits, unused_duplicates, by = join_by(record_id),
  relationship = "many-to-one", na_matches = "never"
)
stopifnot(
  identical(unused_duplicate_keys$record_id, "0999"),
  nrow(not_global_uniqueness) == 5L,
  nrow(conflicting_registry) == 4L
)
cat("PASS 06: 5 rows, 3 matches, 2 unmatched; conflicting matched key rejected\n")

# 7. Direction of unmatched='error' and deliberate NA matching ----
left_keys <- tibble::tibble(record_id = c("0007", "0100"))
right_keys <- tibble::tibble(record_id = "0007", registry_match = TRUE)
left_unmatched_survives <- left_join(
  left_keys, right_keys, by = join_by(record_id),
  unmatched = "error", relationship = "many-to-one"
)
right_extra_error <- tryCatch(
  left_join(left_keys, bind_rows(right_keys, tibble::tibble(record_id = "0999", registry_match = TRUE)),
            by = join_by(record_id), unmatched = "error", relationship = "many-to-one"),
  error = identity
)
stopifnot(
  nrow(left_unmatched_survives) == 2L,
  is.na(left_unmatched_survives$registry_match[2]),
  inherits(right_extra_error, "dplyr_error_join_matches_remaining")
)
right_na <- bind_rows(registry, tibble::tibble(record_id = NA_character_, group = "unknown"))
na_matches <- left_join(visits, right_na, by = join_by(record_id),
                        relationship = "many-to-one", na_matches = "na")
na_never <- left_join(visits, right_na, by = join_by(record_id),
                      relationship = "many-to-one", na_matches = "never")
stopifnot(
  identical(na_matches$group[5], "unknown"),
  is.na(na_never$group[5])
)
cat("PASS 07: unmatched right keys rejected; unmatched left retained; NA-key policy verified\n")

# 8. Binding conflicting labels requires explicit harmonization ----
wave_a <- tibble::tibble(record_id = "0007", category = haven::labelled(1, c(active = 1)))
wave_b <- tibble::tibble(record_id = "0042", category = haven::labelled(1, c(inactive = 1)))
label_warnings <- character()
conflicted_bind <- withCallingHandlers(
  bind_rows(wave_a, wave_b),
  warning = function(w) {
    label_warnings <<- c(label_warnings, conditionMessage(w))
    invokeRestart("muffleWarning")
  }
)
stopifnot(length(label_warnings) > 0L)
# Supplied wave dictionaries establish distinct meanings for the same code.
wave_a_derived <- wave_a |> mutate(category_text = "active")
wave_b_derived <- wave_b |> mutate(category_text = "inactive")
harmonized <- bind_rows(
  list(wave_a = select(wave_a_derived, record_id, category_text),
       wave_b = select(wave_b_derived, record_id, category_text)),
  .id = "source"
)
stopifnot(
  identical(harmonized$category_text, c("active", "inactive")),
  identical(harmonized$source, c("wave_a", "wave_b")),
  identical(as.double(wave_a$category), 1),
  identical(as.double(wave_b$category), 1)
)
cat("PASS 08: conflicting label maps detected; explicit harmonization keeps source and meaning\n")

# 9. Longitudinal round-trip and changed-unit denominators ----
wide <- tibble::tibble(
  record_id = c("0007", "0042", "0100"),
  reading_w1 = c(10, NA, NA),
  reading_w2 = c(12, 8, NA)
)
long <- wide |>
  pivot_longer(
    cols = starts_with("reading_w"),
    names_to = "occasion", names_prefix = "reading_w",
    names_transform = list(occasion = as.integer),
    values_to = "reading", values_drop_na = FALSE
  )
reconstructed <- long |>
  pivot_wider(id_cols = record_id, names_from = occasion,
              names_prefix = "reading_w", values_from = reading)
summary_by_person <- long |>
  summarise(
    records = n(), observed = sum(!is.na(reading)),
    reading_mean = if (all(is.na(reading))) NA_real_ else mean(reading, na.rm = TRUE),
    .by = record_id
  )
stopifnot(
  nrow(long) == 6L,
  sum(is.na(long$reading)) == 3L,
  identical(long$occasion, rep(1:2, 3)),
  nrow(count(long, record_id, occasion) |> filter(n > 1)) == 0L,
  identical(arrange(reconstructed, record_id), arrange(wide, record_id)),
  identical(summary_by_person$records, c(2L, 2L, 2L)),
  identical(summary_by_person$observed, c(2L, 1L, 0L)),
  identical(summary_by_person$reading_mean, c(11, 8, NA_real_)),
  sum(c(NA_real_, NA_real_), na.rm = TRUE) == 0,
  is.nan(mean(c(NA_real_, NA_real_), na.rm = TRUE))
)
cat("PASS 09: 6 longitudinal rows; usable counts 2/1/0; participant means 11/8/NA\n")

# 10. Multiple measures retain their types and occasion identity ----
multiple_wide <- wide |>
  mutate(elapsed_w1 = c(1L, 2L, 3L), elapsed_w2 = c(4L, 5L, 6L))
multiple_long <- multiple_wide |>
  pivot_longer(
    cols = -record_id, names_to = c(".value", "occasion"),
    names_pattern = "^(reading|elapsed)_w([0-9]+)$",
    names_transform = list(occasion = as.integer),
    values_drop_na = FALSE
  )
stopifnot(
  nrow(multiple_long) == 6L,
  identical(multiple_long$reading, c(10, 12, NA, 8, NA, NA)),
  identical(multiple_long$elapsed, c(1L, 4L, 2L, 5L, 3L, 6L)),
  is.integer(multiple_long$occasion), is.integer(multiple_long$elapsed)
)
multiple_long_drop <- multiple_wide |>
  pivot_longer(
    cols = -record_id, names_to = c(".value", "occasion"),
    names_pattern = "^(reading|elapsed)_w([0-9]+)$",
    names_transform = list(occasion = as.integer),
    values_drop_na = TRUE
  )
stopifnot(nrow(multiple_long_drop) == 6L, sum(is.na(multiple_long_drop$reading)) == 3L)
cat("PASS 10: multi-measure pivot preserves 6 keys and separate value types\n")

# 11. Recorded NA, absent visit, completion and duplicate pivot cells ----
recorded <- tibble::tibble(
  record_id = c("0007", "0007", "0042"),
  occasion = c(1L, 2L, 1L), reading = c(10, NA_real_, 8)
)
scheduled <- recorded |>
  mutate(record_present = TRUE) |>
  complete(record_id, occasion = 1:2,
           fill = list(record_present = FALSE), explicit = FALSE)
stopifnot(
  nrow(scheduled) == 4L,
  sum(!scheduled$record_present) == 1L,
  sum(is.na(scheduled$reading)) == 2L,
  identical(filter(scheduled, record_id == "0007", occasion == 2)$record_present, TRUE),
  identical(filter(scheduled, record_id == "0042", occasion == 2)$record_present, FALSE)
)
# These negative examples demonstrate why fill semantics must be deliberate.
widened_zero <- recorded |>
  pivot_wider(id_cols = record_id, names_from = occasion, names_prefix = "w",
              values_from = reading, values_fill = 0)
completed_zero <- complete(recorded, record_id, occasion = 1:2, fill = list(reading = 0))
stopifnot(
  is.na(widened_zero$w2[1]), widened_zero$w2[2] == 0,
  !anyNA(completed_zero$reading)
)
duplicated_long <- bind_rows(long, tibble::tibble(record_id = "0007", occasion = 1L, reading = 99))
duplicate_cells <- duplicated_long |> count(record_id, occasion) |> filter(n > 1)
pivot_warnings <- character()
duplicate_wide <- withCallingHandlers(
  pivot_wider(duplicated_long, id_cols = record_id, names_from = occasion,
              names_prefix = "w", values_from = reading),
  warning = function(w) {
    pivot_warnings <<- c(pivot_warnings, conditionMessage(w))
    invokeRestart("muffleWarning")
  }
)
stopifnot(
  nrow(duplicate_cells) == 1L,
  duplicate_cells$n == 2L,
  length(pivot_warnings) > 0L,
  is.list(duplicate_wide$w1),
  identical(duplicate_wide$w1[[1]], c(10, 99))
)
cat("PASS 11: absence differs from recorded NA; duplicate pivot cells remain visible\n")
cat("ALL 11 SYNTHETIC CASE GROUPS PASSED\n")
