# Presentation refinement review

Date: 2026-09-10. Source baseline: `7e2e053`, released plugin `0.2.1`. The reviewed changes are included in release `0.2.2`. Browser environment: Quarto 1.10.18, Chromium 152.0.7977.82, Playwright CLI 0.1.19.

## Evidence and scope

This review follows the reader's successive corrections to a principal executive-academic report through version 14. Three read-only subagent reviews covered the correction history, report design, and HTML configuration/verification. The parent inspected the current QMD/CSS and selected rendered sections in Chromium, then integrated reusable changes into the existing skills. The analytical report, its estimates, and its sources were not modified or re-executed.

The principal report is the main evidence. A separate synthetic fixture from 8 September supplies additional browser regressions. It does not reconstruct the earlier 19-trial campaign or establish that every report has the same problems. The real principal uses a native text-based method schematic, not Mermaid.

## Findings and instruction changes

| Reader difficulty or observed defect | Reusable correction | Boundary |
|---|---|---|
| Repeated sections and methods were difficult to locate in the argument | A selective linked guide explains each section's question and contribution; navigation follows meaningful comparison dimensions | No mandatory outline or fixed section count |
| Several procedures looked like different underlying classifications | Show their shared inputs, what each retains or changes, and their output using a didactic comparison | Method definitions remain project-specific |
| Classification certainty, adjusted association, fit, and validation were conflated | Explain the distinct questions and interpretation limits before presenting each result | Do not invent thresholds, prerequisites, or a required sign/significance |
| A contrast or score reduction was misread as an unadjusted comparison or original score | State adjustment, reference, units, direction, neutral value, and uncertainty; retain original values when useful | Do not reestimate or switch the estimand for appearance |
| Model inventories and coefficient tables were difficult to compare | Align variables and models; use grouped statistic headers, reference categories, explicit unavailable statuses, and consistent typography | No universal statistic set; missing is not zero |
| Central comparisons were hidden among optional details | Keep decision-relevant evidence visible; use oriented disclosures for supporting material | Preserve the requested reader profile and code-visibility choice |
| Wide tables and figure labels failed on a phone-sized viewport | Inspect actual reading widths; recompose figures and provide discoverable local table scrolling or coherent smaller tables | Local scrolling is distinct from page overflow and unreadable shrinking |
| Generated figures had captions but empty alternatives | Author and verify meaningful alternative text or accessible descriptions | Decorative images may intentionally use empty alt text |
| A native-looking disclosure was only clickable | Traverse controls with Tab and test keyboard activation; use a supported accessible component when necessary | No universal JavaScript patch |
| Lightbox opened but its initial focus remained outside the settled dialog | Check focus entry, containment, Escape, and return separately | A functioning lightbox is not a complete accessibility pass |

Local choices about decimal punctuation, dash usage, method IDs, exact statistics, and actor/outcome order were retained as case constraints, not promoted to universal plugin policy.

## Direct browser observations

The principal report's linked guide and three-path explanation work and are readable on desktop; the explanation stacks cleanly on narrow screens. Its score-reduction axis and surrounding text correctly distinguish the baseline difference from the original error score.

At 390 CSS px, the principal document's measured width is 663 px: some static tables overflow beyond the page, while other table wrappers deliberately scroll locally. The guide's first column breaks links into very short fragments, the score plot becomes too small, and wide coefficient tables need a more discoverable scrolling route. Four meaningful figures have no supplied image alternative (their DOM `alt` values are empty). These are report-level findings recorded to improve the plugin; they were not silently repaired in the analytical workspace.

Selected section captures and link checks cover the guide, method schematic, score comparison, and a grouped coefficient table. They do not certify the whole long report, its statistical computations, or its publication readiness. Chromium viewport emulation is not a physical-device test.

## Auxiliary regression correction

A derived synthetic fixture preserves the original one. It uses a more compact bar figure, two small diagrams with preserved branch meaning, supported Quarto Mermaid color variables, and a native `details`/`summary` disclosure.

- The corrected diagram node-text contrast is approximately 12.61:1 versus the earlier 3.52:1.
- At 390 px, figure labels increase from about 9.04 to 18.49 CSS px. At 320 px they remain about 14.67 px. Diagram labels remain approximately 16 px at the tested widths.
- Seventeen explicit functional/layout conditions pass across 1440, 390, and 320 px: page width, figure/diagram size checks, section navigation, disclosure traversal/Enter/Space, and lightbox opening/closing. The 14 px figure-label criterion is fixture-specific, not a WCAG rule.
- Initial lightbox focus remains outside the settled dialog in this runtime. It is recorded separately as an unresolved runtime limitation; the seventeen passing checks are not an overall accessibility pass.
- Full-page and detail screenshots were opened for visual inspection; image decoding and finite animation completion were awaited before lightbox captures.

The palette correction uses [Quarto's Mermaid theme controls](https://quarto.org/docs/authoring/diagrams.html#mermaid-themes). Contrast interpretation follows [W3C text-contrast guidance](https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html); modal behavior is assessed against the [W3C dialog pattern](https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/).

## Independent transfer test

A fresh subagent, without the previous conversation or reviewer conclusions, received a short request and synthetic service-planning evidence. It used an immutable snapshot of the first revised candidate and produced a new QMD/HTML. The parent independently reviewed the generated source, DOM, and desktop/mobile figures.

The first pass preserved supplied coefficients and intervals, labeled relative error reductions as within-sample, and explained shared groups and membership uncertainty. Nevertheless, it was **not visually accepted**: tables reached 706 px on a 390 px viewport, figure text shrank to only a few pixels, image alternatives were empty, and its reading guide was unlinked. Source CSS declared a scroll wrapper but the rendered tables did not use it. A passing structural check did not detect these issues.

This prompted narrow source clarifications about applying scroll wrappers in the rendered DOM, linking HTML reading guides, and authoring/verifying image alternatives. A follow-up correction uses the updated skills and the same estimates. It is a feedback-assisted repair, not a new blind trial; it cannot establish two clean waves or general reliability. The first pass is preserved separately from the repair.

The correction removes page overflow at 390 px (390 px document width), adds six guide links and meaningful alternatives to both images, and exposes all eight coefficient rows in a visible native data table. The parent opened the narrow-screen data-table capture: its body text is 15.3 px and the table has no internal overflow. The original SVG labels still shrink excessively (approximately 4.1–4.5 px on mobile); the readable coefficient view and reflowed error table provide the values, but the plots themselves are not visually accepted. This residual makes explicit why an accessible alternative and a readable plot are separate checks.

## Validation and limits

Plugin validation, all six skill validators, the ten existing HTML-checker regression tests, and whitespace checks pass. The structural helper retains its original scope: CSS, responsive legibility, keyboard behavior, and analytical meaning remain outside its guarantees.

Local reproducibility material is under `output/playwright/2026-09-10-presentation-refinement/`: baseline/source hashes, QMD/SVG/CSS, browser scripts and results, screenshots, and the independent transfer case. Screenshots and private source pointers are local audit material, not bundled plugin examples. This document retains the sanitized findings needed to understand the change.

No release, marketplace update, installation, independent-discovery certification, PDF/DOCX validation, or unqualified campaign-saturation claim is part of this refinement.
