# Quarto-Bento Pilot Findings

**Historical test record.** Version and release statements in each section describe the test or decision at the time. See the [roadmap](roadmap.md) and the skill references for current scope and planned validation.

## Initial Sample (2026-10-17)

This is evidence for the local **agent plugin draft `0.0.0`**, not a release announcement. Application baseline: installed `qbento 0.1.0`, JSON protocol v1, Linux; product checkout `a1b8025f522a5c4c70d10e613f9a7923dc6f761c`. The application's version and the companion plugin's version are independent.

## Checks and Their Meaning

- **Underlying application:** eight focused source-repository API tests passed (get/patch/sync/render, creation, atomicity, bounded inputs and identity/revision checks). This confirms the product baseline, not agent behavior.
- **Embedded examples:** all three QMD examples in `authoring-components.md` rendered with the installed CLI and passed native-envelope validation. A real geometry patch preserved QMD bytes; a stale request was rejected and a later invalid batch operation left earlier edits unapplied.
- **Native Codex behavior:** fifteen fresh sessions, using GPT-6 Luna and GPT-6 Sol, exercised new projects, visual-only editing, source edits, data-driven rerender, stale revisions, incompatible computed edits, wrong-document binding, source components, an ordinary revealjs negative case and optional Quarto performance composition. No Astra model was used.
- **Actual loading:** the skill body was observed in 13 of the 14 Bento-related sessions. One initial computed-value refusal attempted nonexistent skill paths and then correctly refused based on the source without loading the skill; do not attribute that successful refusal to the skill. An explicit follow-up did load it and preserved the whole project. The ordinary revealjs task did not load Bento or create a sidecar.

## Corrected Finding: Optional Sync Is Still a Source Mutation

One initial data-only request asked to preserve QMD. The agent updated data and retained design correctly, but also applied a valid, optional annotation-only sync plan, adding `.qbento-design` classes to QMD. The initial wording did not adequately distinguish a valid plan from an authorized/necessary source change.

The core skill and synchronization reference now state: data/design-only tasks do **not** authorize source sync; a no-source-edit request preserves the QMD bytes, including IDs, comments and annotations. Sidecar design retention does not require applying optional annotations. Two fresh Luna/Sol tests of changed-data regeneration passed afterwards with identical source hashes, changed computed mean/figure, stable `docId` and retained geometry/background.

An additional post-fix pending-text test inspected the actual sync plan, applied it within already authorized scope, generated a receipt and rerendered successfully. This confirms that the correction does not indiscriminately prohibit legitimate synchronization or impose another confirmation when the user has already approved the change.

## Environment and Composition Observations

The default native Codex workspace sandbox prevented Chromium's debugging endpoint from starting. Ordinary text/figure renders could continue with `TEXT_MEASUREMENT_UNAVAILABLE`; a component render was blocked. Agents disclosed that limitation rather than claiming visual validation. The identical component source rendered successfully outside the actor sandbox. A new agent run permitting network access **only for that isolated invocation** completed the local-browser-dependent render with no diagnostics. No machine/global sandbox settings were changed; arbitrary visual/UI workflows remain unverified.

In a combined installation, the agent read both `quarto-bento-workflow` and `quarto-computation-performance`. It saved a background change without executing QMD or synchronizing another author's pending text, and explained that saving state did not require a cache or render. This supports optional composition for the tested case; it does not establish every cross-plugin handoff. No companion skill source was changed.

### Initial Results and Limits

The initial ten trials yielded eight independently passing task artifacts, one material source-scope failure (corrected), and one environment-blocked component render. Five fresh follow-ups passed after the correction or environment adjustment. Do **not** combine these into a misleading all-tests-pass count or a universal reliability claim.

This is initial validation, **not the final release gate**: there has been one post-fix follow-up set, not two qualifying independent clean waves. Studio-only UI actions, capture/reconstruction/interrupted-operation recovery, broader mixed-skill tasks and visual presentation quality need further validation before a first public release claim. The plugin stays local `0.0.0`; no public catalogs, tags, commits, `AGENTS.md` routing rules, bundled scripts or automatic app installation were added.

Full synthetic evidence is retained outside the distributable plugin under the monorepo's ignored `output/field-tests/quarto-bento/2026-10-17-initial/`. The shared instruction body is agent-neutral; native runtime testing here was Codex/Linux, not Claude or other platforms.

## Adversarial R5 Remediation (2026-10-17)

R2-C001, confirmed and dynamically reproduced in the second R5 adjudication, identified a missing execution warning: `reconcile --apply resolution.json` runs Quarto again to verify the reviewed reconciliation plan. The previous instructions emphasized execution during preview but omitted the apply phase. The core skill, operation-effects table, Studio decision-save description and recovery procedure now explicitly require execution authorization for **both phases**. An unchanged QMD hash is not evidence that computation did not occur. An already-authorized decision and its execution do not require redundant reconfirmation. No application code was changed.

The three reported monorepo-only contributor links, plus the same issue in the roadmap, were replaced with immutable external repository-document links. The isolated 13-file plugin payload was reinstalled and its local references and external Git blob targets checked. The plugin remains independently installable with one skill and three references.

A separate implementer-run validation used ten fresh native Codex sessions, five GPT-6 Luna and five GPT-6 Sol, on synthetic workspaces. It does **not** substitute for the independent R4 review or revise the existing R5 verdict. A direct installed-CLI execution-counter probe reproduced `1 -> 1 -> 2 -> 3` after initial render, patch, reconciliation preview and valid apply. Six focused product reconciliation tests passed; these are product evidence, distinct from actor behavior.

The new actors covered a preprepared reconciliation plan under a no-execution instruction, authorized semantic sync without execution, recomputation while retaining exact QMD bytes, read-only pending-state/performance inspection, an authorized reconciliation apply, a stale payload with another author's edits, an uninitialized QMD, impossible literal alteration of computed content, and a Reveal.js-only negative control. The critical no-execution actor did not run reconcile apply; the authorized actor did run it once, incremented the execution counter, saved the selected state and kept QMD bytes intact. The source-only uninitialized-QMD task also succeeded without rendering when the corrected installed skill was explicitly loaded; an unnecessary first-render/refusal defect was not reproduced.

**Loading limitation:** one natural-language source-only task searched a wrong installed path, then read an older local snapshot instead. Its artifact was correct, but it does not validate the corrected candidate. Raw traces show returned old content even though a later command made the compound shell exit nonzero. A fresh explicit follow-up read the correct skill and completed the source-only task safely. Overall, eight Bento-related runs demonstrably returned the corrected body, one returned the old body, and the ordinary Reveal.js control did not load Bento. Nine of ten runs satisfy both task and expected-loading checks; do not label these ten uniform candidate passes.

All runs used the normal per-process Codex workspace sandbox without broadening network policy. One allowed render disclosed unavailable Chromium text measurement; no visual/UI-quality acceptance is claimed. These are new remediation observations, not two newly certified clean independent audit waves. The independent R4/R5 completion and release decision remain pending. Studio, real edited-HTML capture, interrupted recovery, Claude and non-Linux operation remain explicitly outside the validated behavioral scope.

New evidence is stored separately under ignored `output/field-tests/quarto-bento/2026-10-17-r5-remediation/`; the original reviews and test evidence remain unchanged. A font-free, text-only derivative of R2 evidence is included for future archival use, without rewriting R2's original record.

## Installed CLI 0.1.1 Contract Update (2026-10-17)

The **current installed CLI is `qbento 0.1.1`**, selected through mise on Linux; the application is publicly published at that version, while its JSON agent protocol remains v1 and the companion plugin is still local `0.0.0`. This section supersedes earlier 0.1.0 *compatibility assumptions* without rewriting historical 0.1.0 test outcomes. The application checkout was clean at `1b7e265bda07c060215051302f252a7289f4a1f9` when the update began; reviewed functional corrections were in `78c1641` and later publication notes do not resolve backup-only N01.

**New installed-CLI checks, with synthetic workspaces only:**

- Checked `get → patch` of two authored paragraphs → `sync --select selection.json` using an exact `pending[].id` → inspected plan → Apply → explicit render. The selected text reached QMD, the excluded source text stayed intact, both saved positions and `docId` remained stable, and the excluded pending semantic edit survived render. In this explicit-ID fixture, Apply retained both pending entries but needed no `sync-approved.json` marker; a new premature sync preview refused `SOURCE_CONFLICT`. Do not claim that every Apply creates an approval marker or returns the same follow-up diagnostic.
- Replayed the earlier weak-source-binding **synthetic selection fixture** with the installed 0.1.1 executable (rather than the old checkout runner). The complete preview added three auxiliary identity patches; the successful Apply left a real `sync-approved.json` marker and retained two pending edits. A second preview, Apply and reconciliation respectively refused `RECOVERY_OR_BUSY`, `APPROVAL_PENDING` and `SYNC_APPROVAL_PENDING`. Authorized render consumed the approval, retained one excluded pending change and kept the original design/identity. This is a repeated known fixture under a newly selected executable, not an independent blind agent trial.
- Reproduced `PROJECT_SOURCE_MISMATCH` for a sibling QMD through CLI `status`/`diff`/`get`/`edit` and `PROJECT_BINDING_MISSING` after removing the binding only in a disposable copied fixture. No source or state was overwritten.
- Reconstructed the **residual N01 backup-only condition** in a separate disposable directory: valid `project.json`, genuine `state.previous.json` containing two pending edits, no current `state.json` or HTML. Installed 0.1.1 `get`/`status`/`diff` all reported `NO_BASELINE` without writes. **No automatic `edit`/render was attempted on this recovery fixture**; the earlier independent review already documents its destructive follow-on. The skill now warns against bootstrap while recoverable evidence remains. This is a risk mitigation, not an app fix.
- Tested a valid synthetic reconciliation preview and apply with an R execution counter. Initial render, preview and valid apply caused **three executions total**; apply returned `resolved`, `remaining`, `renderNeeded: true`, preserved the QMD bytes and did not forge a computed result.
- Extracted **six actual QMD snippets** from the updated authoring reference (plain deck, card layout, KPI, table, native bar chart and math), then rendered and validated each with installed CLI 0.1.1. A seventh fixture validated a three-column named registry layout and selected `activeTheme`; all seven produced valid native HTML with no render diagnostics in those fixtures. Annotation levels `none`, `minimal`, `detailed` were tested separately with successful render and non-mutating sync previews: no optional update for `none`, `.qbento-design` for `minimal`, and a controlled descriptive comment for `detailed`.
- As a separate **application source-suite** check, 16 targeted tests passed across `sync_selection_test.ts` and `project_binding_test.ts`, including deletion dependencies, binding and selective CLI validation. These are product tests, **not agent skill behavior or independent visual acceptance**.

**Remaining limitations:** no fresh autonomous agent campaign was conducted against these updated instruction bytes; existing R4/R5 release decisions are not automatically upgraded. Studio selection and browser workflows, native PDF/print, Plotly viewer, real edited HTML capture, interrupted recovery, visually inspected diagnostics, native Claude and other operating systems were not accepted end-to-end in this update. One arbitrary saved-geometry synthetic example rendered with `OVERFLOW`; successful structural HTML is not evidence of suitable placement. The plugin remains `0.0.0`, untagged and outside the public marketplaces. Full command/fixture logs are separate under ignored `output/field-tests/quarto-bento/2026-10-17-011-contract-update/`.

## Agent Plugin `0.2.0` Advance Release: Application `0.2.0` Candidate (2026-10-27)

**Historical snapshot:** the pre-publication restrictions in this section applied before the
application's npm and Git release. See the [roadmap](roadmap.md) for current installation status.

The owner explicitly authorized publishing **agent-plugin `0.2.0` ahead of the
application's independent release**. The reviewed application is still only a
dirty-source local `0.2.0` Linux candidate: product HEAD `b52772e` does not
capture its uncommitted files; the tested npm archive SHA-256 is `ae96fc64…`.
**Do not represent the application as publicly tagged, npm-released, or
verified from a clean final package.** The agent plugin must gate 0.2-only
commands on the actual installed app version and keep app `0.1.1` workflows.

An isolated installation (`qbento 0.2.0`, ordinary CLI still `0.1.1`) rendered
two trusted synthetic projects: theme/style/slot + executable 3D Plotly,
scrollable code/stdout/tables + SVG figures, and bounded local widget data.
`get`/`validate`, exact QMD input hashes, state/HTML docIds, role-style code
font, full `ROW120`/`CELL040`/`INSTALLED120` output and app's 14-page PDF
receipt passed **43/43** checks. The product's reported 705 passing tests and
UI/camera evidence were reviewed but **not rerun** as fresh agent behavior
trials. Original project files, global mise/npm and app source were preserved.

The plugin's **existing** three references now gate 0.2-only features:
reusable theme role/named styles, slide variants/slots and checked
`qbento design` imports; chunk-local source/result columns, multi-result
layout and opt-in output scroll; offline 2D/3D widgets, explicit Save view,
static SVG/PNG fallback, inert widget-src inputs and full PDF continuations.
No claim of arbitrary widgets/CSS/HTML execution, cross-platform fidelity,
new QMD reverse chart-data sync or unconditional access to the app release.

**Post-release follow-up (not a precondition for this owner-authorized
agent-plugin release):** after the app's own `0.2.0` release is committed and
immutable, compare its actual published bytes with the reviewed dirty-tree
tarball, update product links to the app tag, repeat focused render/camera
checks and run independent agent task samples as evidence for any broader
compatibility claim or later plugin correction. Historical strict H2 remains
unmet and must not be retroactively relabeled CLEAN.

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

## Initial Validation Plan

Validate naming, metadata, references, embedded examples and native plugin installation. Use the real CLI on isolated synthetic projects; then test fresh agents using the installed skill, recording actual file reads and resulting source/state/output. Distinguish a product test-suite pass from agent behavior.

Cover new-project initialization, visual-only changes, authorized semantic sync, changed-data regeneration, stale revisions, computed-content conflicts, unrelated-document binding, no-execution constraints and false-positive triggers. Test at least one composition with `quarto-publishing` without copying its content. Use [validation-cases.md](validation-cases.md) as a reviewer rubric, not as the acting agent's answer key.

A release gate should include fresh independent trials with inspected artifacts, resolved material findings and explicit residual limits. The default field-test stopping rule is two clean post-fix waves with at least three distinct cases per wave, plus successful structural/product checks. A small initial smoke is not that release gate. The initial draft stayed at `0.0.0`/`[Unreleased]` pending a release decision. In the owner-approved prospective preparation branch, manifest version `0.1.0` and a release-candidate changelog section may be staged without a public tag or catalog pin.

## Early Release-Gate Evidence (2026-10-17)

The implementation, eight focused product API tests, three rendered reference examples, and native Codex field trials are recorded in [pilot-findings.md](pilot-findings.md). The first trials exposed unauthorized annotation-only synchronization during a data-only update; a targeted instruction correction and five passing follow-ups are documented. This is not a claim of two clean post-fix waves or complete Studio/recovery coverage. The public release gate remains open.

## Historical R3 Adjudication

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
