# Technical Report Structure

Use this reference when the report is meant for analysts, technical reviewers, methodologists, developers, statisticians, or collaborators who need to inspect assumptions, diagnostics, model behavior, code decisions, or reproducibility.

## Default Structure

1. Analytical purpose and scope.
2. Data inputs and assumptions.
3. Processing or model specification.
4. Validation and diagnostics.
5. Main results.
6. Sensitivity checks when relevant.
7. Technical limitations.
8. Reproducibility notes or appendix.

## Section Design

Each technical section should make clear:

- What was checked, estimated, transformed, or compared.
- Why the check matters.
- What result was obtained.
- Whether the result affects interpretation, validity, reproducibility, or next steps.

Keep the prose explanatory, not merely procedural.

## Tables, Figures, and Raw Outputs

- Use readable tables and figures for central deliverables.
- Preserve raw outputs only when they improve inspection, debugging, auditability, reproducibility, or code review.
- Avoid over-formatting outputs when rapid technical inspection is more important than presentation polish.
- Move very long, secondary, or purely mechanical outputs to appendices or collapsed sections.

For technical audit reports, raw outputs may be appropriate in the body when they are the object of inspection. For technical deliverable reports, central results should usually be summarized in readable tables or figures, with raw outputs kept as supporting evidence.

## Diagnostics and Validation

Include diagnostics in the body when they affect interpretation. Move long or mechanical checks to appendices or collapsed sections.

Useful diagnostic sections often include data quality checks, missingness, assumptions, model fit, convergence, sensitivity checks, version or seed notes, and known limitations. Do not add a diagnostic section only to fill a template.

## Glossary and Definitions

Define uncommon, project-specific, or high-stakes technical terms near first use. For long reports, prefer local definitions by section rather than one large glossary.

## Code-Facing Names

Keep code-facing objects, helper functions, and intermediate column names clean and ASCII. Apply reader-facing labels near the presentation layer, such as final tables, figure labels, captions, and prose.
