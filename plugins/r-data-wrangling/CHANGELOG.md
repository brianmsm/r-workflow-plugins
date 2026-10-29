# Changelog

## [Unreleased]

### Added

- Two focused skills for research-data import/types and transformation/integration.
- Conditional references for delimited/Excel import and export metadata, labelled and missing-value semantics, declared recodes and aggregation, equality joins and stacking, and repeated-observation reshaping.
- Small synthetic numerical cases covering leading-zero identifiers, partial value labels and SPSS user missings, cardinality and unmatched joins, recorded versus absent occasions, and usable aggregation denominators.
- Compatible Codex and Claude skills-only manifests, with no catalog changes or new runtime dependencies.

### Scope

- Initial functional draft toward `0.1.0`; manifests remain `0.0.0` pending the release decision.
- In-memory research tables and supplied deterministic rules. Imputation, score validity, sampling variances, inferential models, database backends and production orchestration remain outside the initial support claim.
- Structural, numerical and bounded agent evidence are reported separately in `docs/validation.md`.
