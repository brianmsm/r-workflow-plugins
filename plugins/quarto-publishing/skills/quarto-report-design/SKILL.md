---
name: quarto-report-design
description: Use when designing, reviewing, reducing, or restructuring Quarto reports or manuscripts so analytical results are communicated coherently for a specific purpose, profile, and deliverable type. Use for executive, technical, academic, reproducible, applied, psychometric, simulation, teaching, and slide-oriented reports; Results/Discussion boundaries; objective or hypothesis alignment; model hierarchy; analytical narrative; result placement; figure/table interpretation; appendices; supplements; reviewer/advisor comments; local writing guidelines; and contractual objectives. Do not use as the primary skill for ordinary .qmd syntax, output-format YAML, project-level configuration, render failures, computation/cache strategy, deployment, accessibility audits, or general prose editing unless the main task is report structure and communication design.
---

# Quarto Report Design

Use this skill to turn analytical content into a coherent Quarto deliverable. Focus on report purpose, reader task, section hierarchy, narrative flow, technical density, placement of results, appendices, callouts, tables, figures, diagnostics, and executive, technical, or academic framing.

Do not treat this as a generic writing skill. The main question is whether the report structure helps the reader understand what was evaluated, why it matters, what the evidence suggests, and what follows from it.

## Operating Workflow

1. Identify the report goal, intended reader task, deliverable type, expected level of technical detail, and any local design constraints such as writing guidelines, reviewer notes, advisor comments, style guides, or contractual objectives.
2. Select or infer a report profile: executive, technical, academic, or mixed.
3. Propose a section hierarchy that makes the report navigable.
4. For each analytical block, check the sequence: context, evidence, interpretation, implication, transition.
5. Decide which results belong in the body, collapsed callouts, appendices, supplements, or technical notes.
6. When figures, tables, or generated artifacts have changed, check whether captions, surrounding prose, Results, Discussion, objectives, or hypotheses need to change with them.
7. Preserve the user's analytical intent. Do not invent findings or claim rendered-output inspection unless it actually happened.
8. Apply basic accessibility and readability checks only at a transitional level.

## Profile Defaults

- Executive: Use when the report supports decisions or non-specialist interpretation. Prioritize plain language, key findings, implications, recommendations, and readable tables or figures. Technical details may go in collapsed callouts or appendices, but the main argument must be understandable without opening them.
- Technical: Use when the report supports analytical review, audit, reproducibility, debugging, or methodological inspection. Include assumptions, diagnostics, validation checks, model details, and inspectable outputs when useful. Raw outputs are acceptable only when they improve technical inspection.
- Academic: Use when the report supports a thesis, manuscript, research report, methodological evaluation, or scholarly deliverable. Organize around research questions, objectives, hypotheses, or analytical aims. Connect analyses into a coherent argument and keep routine technical checks outside the main body unless they affect interpretation.
- Mixed: Use when signals conflict or the report must serve more than one reader task. Keep the main narrative readable while retaining technical detail in clearly marked sections. For HTML mixed reports that need auditability, prefer folded source code over hidden source code.

When the user does not specify a profile, infer the lightest reasonable profile from the task. Decision, recommendation, stakeholder, or summary language usually points to executive. Diagnostics, assumptions, reproducibility, model checks, or validation usually points to technical. Thesis, manuscript, research questions, objectives, hypotheses, methods, or academic evaluation usually points to academic. For ambiguous R/Quarto analytical reports without a decision-making signal, prefer an academic-technical mixed profile and ask before major restructuring.

## Cross-Profile Rules

- Contextualize before reporting numbers.
- Each major section should open with its central idea and close with an implication, decision, limitation, or transition.
- The body should explain what is evaluated, why it matters, what the result suggests, and what decision or next step it enables.
- Avoid raw console output in executive and polished academic bodies unless it directly supports understanding; do not confuse this with hiding source code that should remain inspectable.
- Use inline computed values only when they support a substantive sentence.
- Do not use generic boilerplate around inline values when rendered results can be inspected.
- Prefer clean ASCII names for code-facing objects and columns. Reserve accents, spaces, and reader-facing labels for final tables, figures, captions, and prose.
- Avoid hiding the core argument in collapsed callouts or appendices.
- Treat local writing guidelines, reviewer notes, advisor feedback, and contractual objectives as report-design constraints before cutting, moving, or deleting analytical content.
- When reducing length, preserve the argument sequence, objectives or hypotheses, and the role of central figures and tables; remove redundancy before removing evidence.
- Do not change captions, chunks, cross-references, or generated artifacts while doing prose-only design work unless the user asks for those edits.

## Code Visibility

Distinguish source code from raw console output. Avoiding raw output does not mean hiding all executable source code.

For technical, reproducible, debug-oriented, or mixed executive-technical reports, keep source code inspectable by default when the medium supports it. For HTML, prefer visible-but-folded code with `echo: true` and `code-fold: true`, while hiding messages and warnings unless they are diagnostically relevant.

Use global `echo: false` mainly for reader-only executive or polished academic deliverables, or when source code is intentionally moved to appendices, supplements, or a separate technical version.

Do not set global `echo: false` for mixed, technical, reproducible, or debug-oriented reports unless the user explicitly asks for a reader-only document or the source code is exposed elsewhere.

## User-Supervised Decisions

When working autonomously, state the assumption before editing; ask only when the change would alter the report purpose, claims, reader task, or evidentiary meaning. Apply that rule before changing:

- The primary report profile or intended reader task.
- The amount of technical detail exposed in the body.
- Whether diagnostics, assumptions, code, or raw outputs move to collapsed callouts, appendices, supplements, or unlisted sections.
- Removing, merging, summarizing, or substantially shortening analytical sections, results, diagnostics, or appendices.
- The order of analyses when it affects the analytical argument.
- Research questions, objectives, hypotheses, substantive claims, recommendations, or decisions.
- Separate deliverable versions, such as executive and technical variants.
- The deliverable medium when switching between report, slides, website, manuscript, PDF, DOCX, or HTML materially changes the communication.

## References

- For decision-oriented reports, read `references/executive-report-structure.md`.
- For technical review, audit, reproducibility, and diagnostic reports, read `references/technical-report-structure.md`.
- For research, thesis, manuscript, methodological, and scholarly reports, read `references/academic-report-structure.md`.
- For basic transitional accessibility checks, read `references/accessibility-basic-checklist.md`.

## Boundaries

Use `quarto-authoring-core` for Quarto Markdown syntax, cell or chunk labels/options, citations, cross-references, captions, equations, callout syntax, or ordinary `.qmd` authoring mechanics.

Use `quarto-project-configuration` for `_quarto.yml`, `_metadata.yml`, shared metadata, profiles, parameters, render targets, resources, output directories, or project-level organization.

Use `quarto-format-configuration` for output-format YAML, HTML/PDF/DOCX/revealjs/PowerPoint/Beamer/Typst settings, themes, CSS/SCSS, reference documents, templates, includes, or extensions.

Use `quarto-computation-performance` for cache, freeze, long renders, externalized computation, seeds, precomputed artifacts, or pipeline escalation.

Use `quarto-render-troubleshooting` for failed renders, logs, YAML errors, cell or chunk errors, LaTeX or Typst errors, missing files, broken links, screenshots, browser inspection, rendered artifact checks, or verification claims.

Do not use this skill as the primary guide for scripts, assets, reusable templates, full accessibility audits, deployment workflows, or broad academic-writing guidance. If the user asks for those while designing a report, keep the report-design part limited and route the rest to the appropriate skill boundary.
