# Executive Report Structure

Use this reference when the report is meant to support decisions, summarize analytical implications, or communicate findings to readers who should not need to inspect technical machinery.

## Default Structure

1. Executive summary.
2. Decision context.
3. Key findings.
4. Evidence by analytical question.
5. Recommendations or next steps.
6. Technical appendix or optional methodological notes.

## Communication Brief

Before drafting, identify the reader's decision or interpretation task, whether the deliverable is public or internal, whether it should describe the current analytical state or a change history, and which local terminology or style constraints apply.

For public-facing reports, distinguish:

- Substantive labels that belong in the main narrative.
- Necessary technical terms that require a plain-language definition near first use.
- Operational identifiers, workflow states, receipts, hashes, and editorial history that belong in an appendix, sidecar, audit record, or delivery note unless the reader needs them.

Apply this distinction across prose, headings, captions, tables, legends, alt text, navigation, and other rendered text.

## Executive-Academic Pattern

Treat executive-academic as a layered profile, not an accumulation of executive and technical content:

- Keep the body focused on the question, evidence, interpretation, limitation, and implication.
- Preserve academic precision through definitions, citations, inferential cautions, and explicit statements of what evidence does and does not support.
- Put extended diagnostics, specifications, codes, and model inventories in oriented collapsed sections or appendices.
- Keep every central conclusion linked to inspectable supporting evidence.
- Make the report understandable with optional sections closed.

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
2. Introduce the object, comparison, or candidate being evaluated before its diagnostics.
3. Show only the evidence needed to understand the answer.
4. Interpret the evidence in plain analytical language.
5. State what the evidence supports and what it does not establish.
6. State what changes for the decision, recommendation, or next step, with a descriptive link to supporting detail when needed.

Avoid presenting numbers before explaining what they are meant to answer.

For reports with several populations or specifications, provide an early, compact scope map when prose alone would be ambiguous: unit/population, variable set and analytical role, what changes between specifications, execution status, reason for asymmetry, and route to results. Do not expand the analysis to fill missing cells.

When the conclusion depends on several diagnostics, explain their relationship. A short decision table or diagram can show which checks are necessary, which come next, and why success in one does not compensate for failure elsewhere. Separate unfavorable evidence from unavailable or unevaluated evidence. Present the supported interpretation before its limits, without burying a limit that changes the decision.

## Tables and Figures

- Prefer tables and figures that communicate one main idea.
- Use a few key numbers in the body when they clarify the decision.
- Move dense model output, long diagnostics, and extended tables to appendices or collapsed notes.
- Do not place a table or figure in the body without explaining its role.
- Introduce what the reader should notice and connect it to the claim after the display. Check the sequence as well as individual figures: didactic and observed displays need compatible labels, direction, and scales, or an explicit explanation of the difference. Remove redundant or conflicting displays.
- Distinguish interpretive class or group names from estimated variables. Keep one consistent mapping to identifiers and value codes in supporting detail. For standardized or otherwise transformed displays, state the transformation, reference population, units, and direction, and retain a consultable table of original values where needed.
- Make technical tables usable for lookup: label units and populations, separate paired variables when comparison needs separate columns, and retain uncertainty that is actually available. A short worked example can clarify a difficult interpretation; do not invent estimates or uncertainty to populate a table.
- Identify whether a visual presents observed evidence, transformed evidence, a diagnostic, a didactic illustration, or a process. Do not let a teaching example appear to be an empirical result.
- Use overview before detail when the available evidence supports a truthful overview. Explain analytical asymmetry instead of manufacturing a combined view.
- Do not present an aggregate, subgroup, or comparison without supporting evidence. A joint display of existing estimates is not a pooled estimate. New summaries may be computed and verified within the authorized analytical scope, with their method, population, weighting where relevant, and limits stated; otherwise explain the missing evidence rather than inventing a symmetric panel.
- For HTML executive or executive-academic reports with figures that benefit from close inspection, prefer lightbox treatment by default. The figure must remain legible in the page without opening the lightbox.

## Callouts and Appendices

Use callouts for key decisions, warnings, recommendations, and optional technical notes. Collapsed callouts must not contain information required to understand the main report narrative, and should open with a short explanation of what the supporting detail contains and why it matters.

Golden rule: if the report cannot be understood without opening a collapsed callout, move the central idea into the body.

Technical appendices can hold model details, diagnostics, sensitivity checks, code notes, and extended tables unless they affect the main decision.

For mixed executive/technical deliverables, keep the body readable while moving dense diagnostics, file-path traceability, model details, and extended evidence into notes, appendices, or sidecar documents. Do not hide information needed for the main decision.

## Raw Outputs

Avoid raw software output in the body. Convert central results into readable tables, figures, or interpreted statements.

## Voice

Prefer direct analytical prose. Avoid interface-like phrasing such as "click", "you can see", or "the report will show". Avoid meta commentary about the report style.

Write a final report as the intended current account of the evidence. Do not narrate version-by-version edits, software operations, or internal workflow states unless the report is explicitly about that process.
