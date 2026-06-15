# Executive Report Structure

Use this reference when the report is meant to support decisions, summarize analytical implications, or communicate findings to readers who should not need to inspect technical machinery.

## Default Structure

1. Executive summary.
2. Decision context.
3. Key findings.
4. Evidence by analytical question.
5. Recommendations or next steps.
6. Technical appendix or optional methodological notes.

## Section Design

Each major section should answer:

- What is being evaluated?
- Why does it matter?
- What does the evidence suggest?
- What decision or next step does it support?

The first sentence should orient the reader toward the central idea. The final sentence should state an implication, decision, limitation, or transition.

## Analytical Blocks

Use a question-evidence-implication pattern:

1. State the practical question.
2. Show only the evidence needed to understand the answer.
3. Interpret the evidence in plain analytical language.
4. State what changes for the decision, recommendation, or next step.

Avoid presenting numbers before explaining what they are meant to answer.

## Tables and Figures

- Prefer tables and figures that communicate one main idea.
- Use a few key numbers in the body when they clarify the decision.
- Move dense model output, long diagnostics, and extended tables to appendices or collapsed notes.
- Do not place a table or figure in the body without explaining its role.

## Callouts and Appendices

Use callouts for key decisions, warnings, recommendations, and optional technical notes. Collapsed callouts must not contain information required to understand the main report narrative.

Golden rule: if the report cannot be understood without opening a collapsed callout, move the central idea into the body.

Technical appendices can hold model details, diagnostics, sensitivity checks, code notes, and extended tables unless they affect the main decision.

For mixed executive/technical deliverables, keep the body readable while moving dense diagnostics, file-path traceability, model details, and extended evidence into notes, appendices, or sidecar documents. Do not hide information needed for the main decision.

## Raw Outputs

Avoid raw software output in the body. Convert central results into readable tables, figures, or interpreted statements.

## Voice

Prefer direct analytical prose. Avoid interface-like phrasing such as "click", "you can see", or "the report will show". Avoid meta commentary about the report style.
