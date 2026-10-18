# Quarto-Bento Plugin Roadmap

## Local Initial Scope (`0.0.0`)

Create one operational skill and three references, with independent Codex/Claude manifests. Keep the application external. Record app/JSON/source compatibility and avoid assumptions about unsupported platforms, new source syntax, or parity between API and Studio.

## Validation Before a First Release

Validate naming, metadata, references, embedded examples and native plugin installation. Use the real CLI on isolated synthetic projects; then test fresh agents using the installed skill, recording actual file reads and resulting source/state/output. Distinguish a product test-suite pass from agent behavior.

Cover new-project initialization, visual-only changes, authorized semantic sync, changed-data regeneration, stale revisions, computed-content conflicts, unrelated-document binding, no-execution constraints and false-positive triggers. Test at least one composition with `quarto-publishing` without copying its content. Use [validation-cases.md](validation-cases.md) as a reviewer rubric, not as the acting agent's answer key.

A release gate should include fresh independent trials with inspected artifacts, resolved material findings and explicit residual limits. The default field-test stopping rule is two clean post-fix waves with at least three distinct cases per wave, plus successful structural/product checks. A small initial smoke is not that release gate. Keep `0.0.0`/`[Unreleased]` until an explicit release decision; do not add a public catalog pin to an unpublished tag.

## Initial Evidence (2026-10-17)

The implementation, eight focused product API tests, three rendered reference examples, and native Codex field trials are recorded in [pilot-findings.md](pilot-findings.md). The first trials exposed unauthorized annotation-only synchronization during a data-only update; a targeted instruction correction and five passing follow-ups are documented. This is not a claim of two clean post-fix waves or complete Studio/recovery coverage. The public release gate remains open.

## Follow-up, Not Initial Dependencies

- Verify Studio-only operations and real browser interactions where tools are available, separately from the API tests.
- Expand capture/reconstruction/interrupted-transaction cases before advertising complete recovery validation.
- Evaluate optional companion-skill activation with more varied tasks; add short generic-plugin handoffs only for a demonstrated gap.
- Revalidate reference contracts as the app changes; different app, source docs and plugin versions must remain distinguishable.
- Consider standalone visual-design or advanced recovery skills only after evidence shows a reference is insufficient. Do not scaffold future skills or hooks speculatively.

The [repository release process](https://github.com/brianmsm/r-workflow-plugins/blob/feeaf6c71b70a1f5cac46b5f723d3ba613ac32e0/docs/release-process.md) handles later version commits, tags and publication. Published companion plugins are not modified just to expose this draft. The independent R3 agent-release adjudication on candidate `2cb1e5c` was **BLOCKED**: both waves had material/non-clean cases. Subsequent experimental Codex hook reviews ended **REVISE_AND_RETEST**; hooks were archived on a separate local research branch rather than added as a dependency. Updated skill guidance must itself pass two **new** independent clean post-fix agent waves on a frozen new commit. Neither hooks trials nor static validation replace that gate.

## Adversarial Remediation Follow-up (2026-10-17)

R2-C001/R5-F01 was corrected with an explicit execution warning for both reconciliation phases, without changing the application. Four non-relocatable contributor links were repaired. New native Codex actor observations and a direct execution-counter probe are documented in [pilot-findings.md](pilot-findings.md), including an old-snapshot lookup contamination and its explicit follow-up. The initial report's passing cases are not counted as tests of the new bytes.

The next independent review must use the corrected candidate receipt and new evidence, not the obsolete original 13-file hash. Do not declare R4 complete, change R5's historic verdict or publish on the strength of implementer-led tests alone. Keep local `0.0.0` until the agreed independent behavioral and clean-wave release gates are met. No `AGENTS.md` rule or companion-plugin source change is needed for these corrections.

## Installed Application 0.1.1 Adaptation (2026-10-17)

Product `0.1.1` is published and selected by the local mise `qbento` shim; agent protocol remains v1. The product's selective sync, source binding checks and post-Apply pending lifecycle are supported behaviors, not missing product features. The plugin updates its existing three references to teach those contracts. The backup-only `NO_BASELINE` loss window (N01) remains a **product P2 recovery gap**, mitigated here by conservative read-only preflight; do not claim the application repairs it.

Current implementation/CLI tests are distinct from independently observed skill behavior. Future field tests should cover exact selected vs excluded pending IDs and supporting QMD identity edits, Apply without immediate render, the following approved render, `PROJECT_SOURCE_MISMATCH`/`PROJECT_BINDING_MISSING`, and a synthetic N01 preservation case. Keep full QA recordings under ignored `output/` rather than the distributable skill. No extra skills, routers, scripts or mandatory companion plugins are needed.
