# Quarto-Bento Plugin Roadmap

## Guidance-only Agent Plugin Patch (`0.1.1`, 2026-10-26)

The independently versioned **agent plugin** adds optional composition with
Quarto presentation pedagogy and destination-specific motion guidance, while
continuing to target the installed **application** `qbento 0.1.1`.

Synthetic CLI tests found that Reveal.js `auto-animate`/`data-id` declarations
are preserved in a Quarto intermediate but are **not translated** into native
Bento `morph` or shared `morphId`; checked native motion saves do not sync into
Reveal.js animation attributes. An additional same-identity QMD wording edit
preserved a saved `morph` on re-render **without** the optional `.qbento-design`
annotation. These bounded results justify source-preserving migration, explicit
fidelity warnings and static or native-motion alternatives, **not** claiming a
new native converter or universal cross-platform playback.

The stricter historical H2 adjudication remains unchanged. This patch is an
instruction/compatibility update with structural checks and synthetic product
experiments, **not** a new native-agent evaluation wave. See
[qbento issue #1](https://github.com/brianmsm/quarto-bento/issues/1) for the
product codec/diagnostic request.

## Scoped First-Release Acceptance (`0.1.0`, 2026-10-25)

The owner selected a prospective **trusted-local, reviewed-source Linux** acceptance policy for preparing the first release, deliberately narrower than the earlier two-CLEAN-round H2 gate. That historical strict gate remains **not met**: R1-NEW is formally `NOT_CLEAN`; R2-LOCAL passed its pragmatic local protocol but is not H2-qualifying; R2-NEW was preparation-only. None is retrospectively relabeled CLEAN. Earlier documentation below records the strict default rule at the time; this prospective owner decision **does not rewrite the historical outcomes**.

One new first-render QMD with a table initially failed on `UNSUPPORTED_TABLE_LAYOUT` due to a long header (a documented native width refusal). A single targeted authoring-reference correction then underwent a **separate new Codex authoring case**, with complete model-visible skill/reference delivery, independent nonexecuting review, one local one-shot host render, and physical native-state/HTML verification: two slides, correct 3-column table and saved document identity. The F02 local S/T/A/H matrix passed; the older failed F01 evidence remains immutable. Static package checks passed on the corrected candidate. **F02 exercised correction commit `61aacaa`.** Later `0.1.0` preparation and editorial refinement changed metadata and runtime instructions while retaining the supported table-authoring boundaries tested in F02. The final instruction bytes have **not** undergone a new native agent wave; static checks do not upgrade historical H2 or F02 behavioral results. Chromium could not measure text bounds (`TEXT_MEASUREMENT_UNAVAILABLE`), so output semantics are verified but visual text fit is not.

This scoped acceptance is not a general-purpose safety certification or unrestricted distribution claim. Scope remains Linux with installed application `qbento 0.1.1`, local trusted/known-source operation and explicit review before QMD execution or HTML publication. **Not validated:** native Claude behavior, Windows/macOS, arbitrary untrusted input, universal negative triggering, advanced rich/wrapped tables, reliable browser text measurement, full Studio/visual UI workflows, or recovery of app backup-only N01. At this acceptance decision, public release required a separate owner go/no-go, plugin-specific tag/push and later pinned catalogs; manifest version `0.1.0` alone **does not** publish the plugin.

## Historical Local Initial Scope (`0.0.0`)

Create one operational skill and three references, with independent Codex/Claude manifests. Keep the application external. Record app/JSON/source compatibility and avoid assumptions about unsupported platforms, new source syntax, or parity between API and Studio.

## Validation Before a First Release

Validate naming, metadata, references, embedded examples and native plugin installation. Use the real CLI on isolated synthetic projects; then test fresh agents using the installed skill, recording actual file reads and resulting source/state/output. Distinguish a product test-suite pass from agent behavior.

Cover new-project initialization, visual-only changes, authorized semantic sync, changed-data regeneration, stale revisions, computed-content conflicts, unrelated-document binding, no-execution constraints and false-positive triggers. Test at least one composition with `quarto-publishing` without copying its content. Use [validation-cases.md](validation-cases.md) as a reviewer rubric, not as the acting agent's answer key.

A release gate should include fresh independent trials with inspected artifacts, resolved material findings and explicit residual limits. The default field-test stopping rule is two clean post-fix waves with at least three distinct cases per wave, plus successful structural/product checks. A small initial smoke is not that release gate. The initial draft stayed at `0.0.0`/`[Unreleased]` pending a release decision. In the owner-approved prospective preparation branch, manifest version `0.1.0` and a release-candidate changelog section may be staged without a public tag or catalog pin.

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

## Restricted Chromium Render Handoff (2026-10-19)

Independent R1 on plugin commit `4b104fe` was **NOT_CLEAN** because the agent executed QMD under an incompatible Codex Linux sandbox without a demonstrably elevated tool call; Chromium failed after R computed, so saved and published output remained stale. R2 was CLEAN for its four scoped cases. A separate control showed `--approve-for-me` can approve a one-off trusted render, but relying on model phrasing proved inconsistent, and an instruction-only A/B did not repair that reliability.

A fresh synthetic end-to-end experiment instead separated a **nonexecuting agent preflight**, an explicitly authorized, one-shot **external host render**, and a **read-only second-agent verification**. The published and saved mean moved from 21.00 to 31.00; source/data hashes, docId, retained design and execution count (1 -> 2) were verified independently. The external operator is **not a new qbento API or a portable plugin dependency**. Preserve this distinction in release trials. This positive example is not two new clean independent post-fix waves, a Chromium sandbox fix, or approval to run arbitrary QMD outside a sandbox.

## HTML Publication Scope and Trigger Follow-up (2026-10-20)

Independent R3 on candidate `7b0136b` remained **REMEDIATION_REQUIRED**. R1/R2 correctly selected QMD sync IDs, but a separately authorized render could expose excluded *native* pending authored text in actual HTML. A public-output prohibition is distinct from source-synchronization selection; installed `qbento 0.1.1` has no documented selective HTML-publish switch. A focused update now requires pre-render inspection of the complete saved deck and pending content, with a safe stop for forbidden or unclear published text. Legitimately authorized native pending text may still be included. Do not hide slides or rewrite the generated HTML to claim confidential removal.

Coordinator-run native Codex A/B cases with real installed skill body reads and project-local rendered fixtures preserved both pending IDs and the original private QMD text in 8/8 actor sessions. An independent operator **refused** all four forbidden-publication cases without execution and completed all four explicitly authorized host renders, verifying actual saved/native and HTML outcomes. A separate one-line frontmatter comparison initially reduced observed ordinary-Quarto negative-trigger skill reads from **2/4 to 0/4** with a provisional unquoted description that failed YAML validation. The final **valid quoted description** was then retested in six new native Codex sessions: **1/4** negative-control false reads and **2/2** correct positive skill reads with persisted geometry. One false-positive activation remains observed. A preceding implicit/harness-calibration attempt without skill reads is not counted as skill evidence. These small samples do **not** establish universal agent behavior or supersede the two fresh independent CLEAN waves and final adjudication required for release `0.1.0`.
