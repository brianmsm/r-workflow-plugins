---
name: quarto-report-design
description: Use when designing, reviewing, reducing, or restructuring Quarto reports or manuscripts so analytical results are communicated coherently for a specific audience, purpose, profile, and deliverable type. Use for executive, executive-academic, technical, academic, public or institutional, reproducible, applied, psychometric, simulation, teaching, and slide-oriented reports; Results/Discussion boundaries; objective or hypothesis alignment; public-versus-internal terminology; analytical narrative; result placement; evidence-linked tables and figures; appendices; supplements; reviewer or advisor comments; local writing guidelines; and contractual objectives. Do not use as the primary skill for ordinary .qmd syntax, output-format YAML, project-level configuration, render failures, computation or cache strategy, deployment, accessibility audits, or general prose editing unless the main task is report structure and communication design.
---

# Quarto Report Design

Use this skill to turn analytical content into a coherent Quarto deliverable. Focus on report purpose, reader task, section hierarchy, narrative flow, technical density, placement of results, appendices, callouts, tables, figures, diagnostics, and executive, technical, or academic framing.

Do not treat this as a generic writing skill. The main question is whether the report structure helps the reader understand what was evaluated, why it matters, what the evidence suggests, and what follows from it.

## Operating Workflow

1. Establish a communication brief: report goal, intended reader task, deliverable type, public or internal status, current-state or change-history voice, expected technical depth, and local style or terminology constraints. Infer this brief from even a short request and the available project context; do not require the user to supply a detailed outline or repeat known preferences.
2. Select a primary profile and any secondary layer: executive, executive-academic, technical, academic, or another mixed profile.
3. For public-facing work, distinguish substantive reader-facing labels, necessary technical terms that need explanation, and operational identifiers that belong in an appendix, sidecar, audit record, or delivery note.
4. Map the reader's main questions and central claims to the evidence, tables, figures, citations, or technical sections that support them.
5. Propose a hierarchy ordered by the reader's questions rather than by software steps, pipeline phases, or editorial history.
6. For each analytical block, present the object, comparison, or candidate before the evidence that evaluates it; then connect evidence, interpretation, limits, implication, and the route to supporting detail.
7. Define uncommon or consequential technical terms at or before first substantive use. Explain what a diagnostic measures, why it matters, what was observed, and what it does and does not support.
8. Decide which content belongs in the body, oriented collapsed callouts, appendices, supplements, technical notes, or sidecars. The main argument must remain understandable with optional sections closed.
9. Classify each planned visual as observed evidence, transformed evidence, diagnostic, didactic illustration, or process diagram, and verify that its scope matches what was actually estimated or observed.
10. When figures, tables, or generated artifacts change, revisit captions, alt text, surrounding prose, Results, Discussion, objectives, hypotheses, and evidence links.
11. Before delivery, compare central claims, numerical summaries, and decision rules back to the supplied evidence. Preserve the user's analytical intent. Do not invent findings, aggregates, subgroups, or other results for narrative symmetry, and do not claim rendered-output inspection unless it actually happened.
12. Apply basic accessibility and readability checks only at a transitional level, then hand off format configuration and rendered-artifact verification to their responsible skills.

## Profile Defaults

- Executive: Use when the report supports decisions or non-specialist interpretation. Prioritize plain language, key findings, implications, recommendations, and readable tables or figures. Technical details may go in collapsed callouts or appendices, but the main argument must be understandable without opening them.
- Executive-academic: Use when the body must remain decision-oriented or accessible while the evidence must meet scholarly or methodological expectations. Keep the body executive; preserve academic precision through first-use definitions, citations, inferential cautions, evidence links, and inspectable appendices or collapsed sections. Include source code only when reproducibility is part of the reader's task.
- Technical: Use when the report supports analytical review, audit, reproducibility, debugging, or methodological inspection. Include assumptions, diagnostics, validation checks, model details, and inspectable outputs when useful. Raw outputs are acceptable only when they improve technical inspection.
- Academic: Use when the report supports a thesis, manuscript, research report, methodological evaluation, or scholarly deliverable. Organize around research questions, objectives, hypotheses, or analytical aims. Connect analyses into a coherent argument and keep routine technical checks outside the main body unless they affect interpretation.
- Mixed: Use when signals conflict or the report must serve more than one reader task not covered by the executive-academic pattern. Name the primary reader task, keep the main narrative readable, and retain secondary technical detail in clearly marked sections. For HTML mixed reports that need auditability, prefer folded source code over hidden source code.

When the user does not specify a profile, infer the lightest reasonable profile from the task. Decision, recommendation, stakeholder, or summary language usually points to executive. Diagnostics, assumptions, reproducibility, model checks, or validation usually points to technical. Thesis, manuscript, research questions, objectives, hypotheses, methods, or academic evaluation usually points to academic. For ambiguous R/Quarto analytical reports without a decision-making signal, prefer an academic-technical mixed profile and ask before major restructuring.

## Cross-Profile Rules

- Contextualize before reporting numbers.
- Each major section should open with its central idea and close with an implication, decision, limitation, or transition.
- The body should explain what is evaluated, why it matters, what the result suggests, and what decision or next step it enables.
- Use final-product voice for public reports. Keep version history, editorial changes, pipeline states, receipts, hashes, and operational identifiers in the delivery note or technical traceability layer unless they are part of the reader's task.
- Use substantive labels before technical identifiers. Preserve exact technical names as supporting detail when they matter for auditability.
- Define uncommon terms in the point-of-need context rather than relying on a distant glossary alone.
- When a supplied method or criterion is underspecified, separate a general explanation or possible design from the procedure actually documented. Do not silently choose a particular validation design, threshold, or interpretation and attribute it to the study.
- Introduce variables and derived measures before interpreting model results. For a consequential derived measure, identify its reader-facing label, source variables or codes, transformation, missing-value treatment, scale, and analytical role; use a diagram only when the construction has meaningful branching or sequence.
- When several populations or specifications could be confused, orient the reader with a compact scope map: units, variable roles, what varies, and which analyses were actually run. Preserve the observational unit, population, and denominators across summaries, recommendations, tables, and visuals; do not silently replace the measured unit with its parent organization or territory. Preserve readable labels with a consistent mapping to analytical identifiers and coding in supporting detail.
- Explain how consequential criteria combine, not just what each measures: whether they are sequential, necessary, sufficient, or non-compensatory. Distinguish a failed check from one not evaluated; favorable evidence on one criterion cannot automatically offset another. Attribute decision rules to their actual source and distinguish supplied requirements from additional recommendations; do not invent a protocol or promote a diagnostic into a mandatory criterion.
- Make each central conclusion traceable to its supporting evidence through descriptive cross-references or links. In a long comparison report, a short linked reading guide can explain which question each section answers and how it contributes to the decision; a table of contents alone does not explain that logic.
- Distinguish didactic illustrations from observed or estimated results in titles, captions, alt text, and surrounding prose.
- Review visuals as a sequence: introduce what to look for, connect each display to its interpretation, and reconcile labels, direction, and scales between didactic and empirical displays. For transformed scores and contrasts, identify the reference, units, direction, and meaning of zero in the display; retain original values when needed for interpretation.
- Do not present combined, national, subgroup, or average views without supporting evidence. A new derivation is appropriate when it is within the authorized analytical scope, can be computed and verified from available evidence, and its method, population, weighting where relevant, and interpretive limits are explicit. Do not expand the analysis solely for narrative symmetry; distinguish a display of existing estimates from a newly computed result.
- With incomplete observation or classification, distinguish recorded counts from complete population totals. Unknown status is not absence: qualify lower bounds and the known subset behind conditional percentages, rather than treating sums of classified states as exhaustive event totals.
- Avoid raw console output in executive and polished academic bodies unless it directly supports understanding; do not confuse this with hiding source code that should remain inspectable.
- Use inline computed values only when they support a substantive sentence.
- Do not use generic boilerplate around inline values when rendered results can be inspected.
- Prefer clean ASCII names for code-facing objects and columns. Reserve accents, spaces, and reader-facing labels for final tables, figures, captions, and prose.
- Avoid hiding the core argument in collapsed callouts or appendices.
- Treat local writing guidelines, reviewer notes, advisor feedback, and contractual objectives as report-design constraints before cutting, moving, or deleting analytical content.
- Preserve stated terminology, punctuation, labeling, and visual conventions across later revisions and across prose, headings, captions, tables, legends, alt text, and navigation.
- When reducing length, preserve the argument sequence, objectives or hypotheses, and the role of central figures and tables; remove redundancy before removing evidence.
- Do not change captions, chunks, cross-references, or generated artifacts while doing prose-only design work unless the user asks for those edits.

## Code Visibility

Distinguish source code from raw console output. Avoiding raw output does not mean hiding all executable source code.

For technical, reproducible, debug-oriented, or mixed executive-technical reports, keep source code inspectable by default when the medium supports it. For HTML, prefer visible-but-folded code with `echo: true` and `code-fold: true`, while hiding messages and warnings unless they are diagnostically relevant.

Use global `echo: false` mainly for reader-only executive, executive-academic, or polished academic deliverables, or when source code is intentionally moved to appendices, supplements, or a separate technical version.

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

- For decision-oriented reports, including reading guides, method comparisons, grouped tables, and interpretation of contrasts or transformed metrics, read `references/executive-report-structure.md`.
- For technical review, audit, reproducibility, and diagnostic reports, read `references/technical-report-structure.md`.
- For research, thesis, manuscript, methodological, and scholarly reports, read `references/academic-report-structure.md`.
- For **slide organization and delivery** (titles, hierarchy, density, visuals, timing), read `references/slide-deck-design.md`.
- For **teaching explanations or learning activities** (examples, misconceptions, controlled contrasts, interpretation), read `references/pedagogical-communication.md`. Read **both only when both types of decisions are in scope**; neither is required for an ordinary report.
- For basic transitional accessibility checks, read `references/accessibility-basic-checklist.md`.

## Boundaries

Use `quarto-authoring-core` for Quarto Markdown syntax, cell or chunk labels/options, citations, cross-references, captions, equations, callout syntax, or ordinary `.qmd` authoring mechanics.

Use `quarto-project-configuration` for `_quarto.yml`, `_metadata.yml`, shared metadata, profiles, parameters, render targets, resources, output directories, or project-level organization.

Use `quarto-format-configuration` for output-format YAML, HTML/PDF/DOCX/revealjs/PowerPoint/Beamer/Typst settings, themes, CSS/SCSS, reference documents, templates, includes, or extensions.

Use `quarto-computation-performance` for cache, freeze, long renders, externalized computation, seeds, precomputed artifacts, or pipeline escalation.

Use `quarto-render-troubleshooting` for failed renders, logs, YAML errors, cell or chunk errors, LaTeX or Typst errors, missing files, broken links, screenshots, browser inspection, rendered artifact checks, or verification claims.

Do not use this skill as the primary guide for scripts, assets, reusable templates, full accessibility audits, deployment workflows, or broad academic-writing guidance. If the user asks for those while designing a report, keep the report-design part limited and route the rest to the appropriate skill boundary.
