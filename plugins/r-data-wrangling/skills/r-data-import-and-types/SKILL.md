---
name: r-data-import-and-types
description: "Use when importing research tables into R or correcting identifiers, column types, value labels, factor levels, dates, or missing-value codes; also when exporting a derived table with its metadata. For joins, reshaping or grouped aggregation, use the transformation skill."
---

# R Data Import and Types

Produce an inspectable imported table and a deliberate analysis representation without losing the meaning of the original columns. Default to native tidyverse readers and visible, locally editable R calls. The optional `r-analytic-coding-principles` skill supplies broader coding conventions; this skill works independently.

## Establish the Input Meaning

- Identify the format, relevant worksheet/range or delimiter, expected row unit and identifiers. Use the available dictionary or supplied rules to distinguish identifiers, measurements, nominal/ordinal categories, dates and missing reasons. Numeric storage and value labels do not establish measurement level.
- Preserve original files and an unmodified imported object. Derive new columns or a named analysis table; retain a mapping when renaming columns. A path or schema that the user has not supplied is an unresolved input, not something to invent.
- Ask only for ambiguities that would change meaning and cannot be resolved from authorized inputs. Continue the unambiguous work.

## Import and Convert Deliberately

1. Choose `readr` for delimited text, `readxl` for Excel and `haven` for statistical formats. Specify consequential types, locale/date interpretation and missing tokens at the read call. Inspect parsing problems and unexpected repaired names; a completed import is not proof of correct values.
2. Read identifiers as character **before** numeric inference can remove zeros or precision. Do not reconstruct a fixed width, trim meaningful characters, or normalize case without a documented rule. Text import cannot recover digits already lost in a spreadsheet.
3. For labelled inputs, inspect variable labels, value-label coverage, SPSS missing values/ranges and tagged missings before conversion. Preserve missing reasons before collapsing them to ordinary `NA`. Do not factorize every labelled column or strip attributes indiscriminately.
4. Choose numeric, character, nominal factor or ordered factor from the variable's meaning and downstream API. Declare substantive level/reference order; `as.numeric(factor)` returns internal level positions, not original codes. Review unseen categories rather than silently losing them.
5. Keep raw and derived metadata consistent. A recoded value, changed unit or new factor can make an old label misleading.

## Read Only the Relevant Reference

- [Import, identifiers and export](references/import-and-export.md): delimited/Excel parsing, zeros, locale, dates, names or an output format decision.
- [Labels and missing values](references/labels-and-missing-values.md): labelled data, incomplete labels, SPSS user missings, tagged `NA` or analysis-type conversion.

## Inspect and Hand Off

Check the affected values, classes, identifiers, label coverage and missingness using a small targeted execution when authorized. Keep meaningful missingness counts and dictionaries; do not add package installers, environment scaffolds, automatic complete-case filtering or a generic validation framework.

For an export, use a declared derived destination and verify a small read-back of consequential fields. RDS retains ordinary R classes/attributes; CSV alone does not retain the dictionary. Report the row unit, key, consequential conversions, missing-value policy, retained metadata and unresolved semantics.

Use `r-data-transform-and-integrate` for joins, recoding across tables, reshaping and aggregation. Inferential missing-data treatment belongs to applied analysis; scoring validity and item treatment belong to psychometrics. Recognizing a missing code does not choose an imputation or scoring rule.
