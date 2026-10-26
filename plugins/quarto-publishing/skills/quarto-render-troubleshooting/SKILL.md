---
name: quarto-render-troubleshooting
description: "Use to diagnose Quarto render failures or verify rendered HTML, DOCX, PDF or slide artifacts: YAML/execution/dependency issues, links, assets, citations, layout and browser interactions. Distinguish source, rendered, structural, visual and interactive evidence; use static review when execution is forbidden, unsafe or unavailable. Not for ordinary authoring, planned format/project design, report structure or cache strategy."
---

# Quarto Render Troubleshooting

Diagnose and verify Quarto render or artifact defects; a successful render command alone does not establish a sound output.

## Core Role

Start from the observed failure or questionable output, isolate the smallest likely cause, apply a targeted fix when tools are available, and verify only what was actually checked.

Never claim that a render, screenshot, browser path, link, anchor, or output was checked unless it was actually checked.

## First Triage

Classify the observed problem before changing files: **command/environment**, **YAML/metadata**, **execution/data**, **assets/paths**, **format**, or **rendered-output defect**. Identify the actual engine and first meaningful error; local-versus-CI mismatches may change which explanation fits. For failure signatures and diagnostic commands, consult `references/render-troubleshooting.md`.

## Preferred Workflow

1. Inspect the exact user-requested operation, QMD, output format, profile and relevant error/claim.
2. **Before running Quarto**, check whether the render would execute source code or other side effects. A rendering/verification request permits only its authorized, trusted scope; do not execute untrusted or unapproved computation to test a visual fix. If execution is forbidden, unsafe or unavailable, stay with source/static review and state the limit.
3. Prefer the smallest authorized render or output inspection that can answer the question. Use `quarto check` for engine problems and escalate to logs, `--debug` or `--execute-debug` only when the initial error is insufficient; exact commands are in the reference.
4. Fix the smallest relevant cause, then repeat only the affected verification under the same permission boundary.
5. Report source, render, structural, visual and interactive outcomes **separately**, including what was not checked.

## Rendered Artifact Verification

When the output exists but correctness matters, verify only the relevant artifact surface:

- HTML: open the generated file or served page; inspect visual layout, assets, links, anchors, navigation, figures, tables, collapsed sections, and screenshots when needed. Test configured interactions such as lightbox behavior rather than inferring them from markup.
- For a local HTML artifact, run `python3 <skill-dir>/scripts/check_html_artifact.py <output.html>` when checking structural integrity. Adjudicate review candidates against the document's purpose, especially escaped markup in custom component subtrees: a successful render can still display a component's source. When edits are authorized, correct the source and repeat the relevant render/checks. The helper requires a local file and does not validate prose, CSS contrast, browser behavior, or visual quality.
- DOCX: check generated text, package/XML structure, citation output, table and figure readability, captions, section behavior, and Word/LibreOffice/OnlyOffice behavior when the user reports application-specific problems.
- PDF: inspect produced pages, figure/table placement, pagination, references, and any LaTeX or Typst-specific visual issue.
- Citations and references: check for raw citation keys, bibliography heading language, CSL/citeproc behavior, DOI/link output, and rendered reference formatting when relevant.
- Post-render scripts: confirm the script ran on the intended artifact, did not affect other formats, and produced the expected bounded transformation.

Always state which formats were rendered and which artifacts were inspected.

Keep verification levels distinct:

1. Source/static: source, paths, configuration, and references were inspected without rendering.
2. Rendered: the requested command completed and produced the expected artifact.
3. Structural: relevant DOM, anchors, resources, or package structure were inspected.
4. Visual: the artifact was opened or captured and relevant pages, sections, figures, tables, and rendered diagrams were reviewed at appropriate viewports or zoom levels.
5. Interactive: configured controls such as links, navigation, collapsed sections, or lightbox were exercised.

Do not combine these levels into a single pass claim. If a required level cannot be checked, report it as unverified.

## No Render Requested Or Unavailable

If the user explicitly says not to render, says they will render themselves, or render tools are unavailable, perform source/static checks only. Do not invoke render commands, do not imply layout verification, and state that rendered outputs were not verified.

## Common Fix Areas

Diagnose the specific failing layer rather than running a universal checklist:

- **Source/configuration:** YAML placement, profile, engine and document-versus-project metadata.
- **Execution/inputs:** cell and package errors, working-directory/paths, input assets, bibliography/CSL and generated files; inspect `.libPaths()` or runtime versions only when an observed environment failure requires it.
- **Output engines:** LaTeX/Typst PDF, DOCX sections/tables/captions, presentation navigation, HTML themes and assets.
- **Rendered fidelity:** anchor targets, citations, Mermaid SVG, lightbox and readable labels/contrast at actual display widths; verify configured browser interactions when warranted.

Use `references/render-troubleshooting.md` for format-specific procedures. Do not create environment checks, caches or wrappers inside the user's QMD as a default response to troubleshooting.

## Boundary Rules

Use other skills when the main task is not troubleshooting:

- `quarto-authoring-core`: writing or reviewing ordinary `.qmd` content.
- `quarto-project-configuration`: designing `_quarto.yml`, `_metadata.yml`, profiles, render targets, or project structure.
- `quarto-format-configuration`: choosing or configuring output formats before a failure occurs.
- `quarto-computation-performance`: reducing expensive recomputation, cache/freeze strategy, precomputed artifacts, or pipeline escalation.
- `quarto-report-design`: report structure, audience, and communication design.

Hosting/CI deployment and comprehensive accessibility audits are outside the currently implemented skills; do not route work to nonexistent skills.

## Verification Discipline

Use **"verified" only for actions performed**. A successful `quarto render` does not establish readable figures, resolved links or working interactive controls. Distinguish source/static, rendered, structural, visual and interactive evidence; explicitly name any untested format or medium rather than implying it passed.

## References

For compact diagnosis patterns for render failures, YAML errors, execution errors, paths/assets, LaTeX/Typst failures, citations, cross-references, HTML verification, and local-vs-CI differences, read `references/render-troubleshooting.md` when fixing or verifying concrete Quarto render/output problems.
