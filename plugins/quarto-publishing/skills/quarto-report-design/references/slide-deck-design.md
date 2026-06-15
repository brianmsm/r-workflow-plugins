# Quarto Slide Deck Design Patterns

## Purpose

Use this reference for communication design in Quarto slide decks. Focus on audience, purpose, argument, sequence, slide density, evidence, and delivery readiness. This is not a format-configuration guide; use the `quarto-format-configuration` skill and its `presentations.md` reference for revealjs, PowerPoint, Beamer, YAML, themes, templates, slide numbers, speaker notes, and format-specific behavior.

## First Decide the Communication Situation

Before restructuring a report into slides or designing a deck, identify:

- Audience: disciplinary experts, mixed academic audience, executives, technical reviewers, students, stakeholders, or collaborators.
- Purpose: inform, persuade, teach, defend, decide, update, troubleshoot, or invite feedback.
- Delivery mode: live oral talk, asynchronous deck, teaching session, defense, technical review, stakeholder briefing, conference talk, or internal progress meeting.
- Time limit and expected pace.
- Whether the deck is projected, read asynchronously, or expected to function like a handout.
- Expected level of technical detail.
- Whether a companion report, appendix, handout, or backup slide section is needed.

A projected deck should usually be lighter and more visual than a standalone deck. A handout-like or asynchronous deck can carry more context, but it still needs clear hierarchy, scannable messages, and restraint.

## Choose the Deck Type

- Academic or research deck: prioritize the research question, argument, evidence chain, methods needed for credibility, limitations, and contribution.
- Executive or stakeholder deck: prioritize the decision, recommendation, risk, implication, confidence level, and next action.
- Technical or reproducibility deck: prioritize assumptions, diagnostics, model behavior, implementation detail, reproducibility, and evidence that supports technical review.
- Teaching or training deck: prioritize concept progression, examples, worked steps, pauses, checks for understanding, and progressive reveal of complexity.
- Progress or update deck: prioritize what changed, what was learned, what is blocked, what decisions are needed, and what comes next.

Mixed decks should keep the main path readable and move secondary detail into backup slides, appendices, handouts, or a companion report.

## Build the Deck Around Messages

Use message-oriented slide titles whenever possible:

- Prefer titles that state the claim, result, takeaway, question, or decision.
- Avoid generic section labels such as "Results", "Methods", or "Discussion" when a more informative title is available.
- Make each slide carry one main message.
- Support that message with visual or compact evidence: a figure, diagram, plot, model summary, equation, short table, or structured comparison.
- Split complex points across several slides rather than making one crowded slide.
- Use bullets sparingly and only when they genuinely structure the message.
- Avoid using projected slides as the speaker's script.

Good message titles should let a skimming audience understand the argument. For example, prefer "The indirect pathway was stable across robustness checks" over "Robustness Checks" when that is the actual takeaway.

## Convert Reports or Manuscripts into Slides

When converting a report, thesis section, manuscript, or technical note into slides:

- Extract the argument, not the prose.
- Preserve objectives, hypotheses, analytical intent, and the evidence chain.
- Convert paragraphs into message titles plus supporting evidence.
- Simplify methods to the level the audience needs without distorting what was done.
- Organize results by argument, research question, decision, or teaching sequence rather than by analysis script order.
- Convert dense tables into visual summaries when pattern recognition matters.
- Keep exact-value tables only when the values are central and readable.
- Move full model tables, diagnostics, derivations, robustness checks, and secondary results into backup slides, appendices, handouts, or companion reports.
- Do not oversimplify results in ways that change the meaning, uncertainty, limitation, or evidentiary support of the original analysis.

Avoid mechanical section-to-slide mapping. A report section may become several slides, one slide, a backup slide, or no slide at all depending on the audience task.

## Manage Slide Density

Use density as a design decision, not as an accident:

- Avoid overcrowded slides.
- Prefer fewer elements arranged with clear visual hierarchy.
- Use whitespace intentionally.
- Keep text large enough to read when projected.
- Avoid small tables, excessive coefficients, dense diagnostics, or manuscript figures copied directly into slides.
- Avoid unnecessary animations, decorative images, special effects, and visual clutter.
- Avoid long bullet lists and long sentences that compete with the speaker.
- Use color, emphasis, and layout to guide attention rather than decorate.
- Put details the audience does not need to read into speaker notes, backup slides, appendices, or a companion report.
- Add backup slides for expected questions rather than interrupting the main narrative with every caveat.

If a slide takes too long to explain in practice, it probably contains more than one message or too much evidence.

## Use Figures, Tables, Code, and Equations

- Figures should support the slide title's message. Redesign dense manuscript figures when needed.
- Prefer figures over tables when the goal is pattern recognition.
- Use tables only when exact values matter and the table remains legible.
- Break dense tables into smaller tables, key-number callouts, visual summaries, or backup material.
- Code should usually be short, pedagogical, or diagnostic. Do not put long production code on projected slides unless code review is the point.
- Equations should be introduced progressively when possible. Show only the terms needed for the audience's current task.
- Diagnostics belong in the main deck only when they are central to the argument, decision, or technical review. Otherwise, place them in technical or backup slides.
- Captions on projected slides should usually be shorter than manuscript captions. Use notes, backup slides, or companion reports for extended explanation.

## Organize the Narrative

Design the main path as a talk, not as a file dump:

1. Open with the problem, motivation, decision, or teaching need.
2. State a roadmap or promise of the talk when it helps the audience track the sequence.
3. Include methods only as much as the audience needs to trust and understand the results.
4. Order results by the argument, not necessarily by the chronology of the analysis.
5. Make implications, limitations, and uncertainty visible at the right level of detail.
6. End the main deck with takeaways, recommendation, contribution, next actions, or a teaching synthesis.
7. Put backup slides after the main ending so expected questions can be answered without bloating the main path.

For academic decks, the narrative should preserve the research logic. For executive decks, it should preserve the decision logic. For technical decks, it should preserve the inspection logic. For teaching decks, it should preserve the learning progression.

## Design for Delivery and Failure

Before treating a deck as ready:

- Practice transitions between slides.
- Check timing against the time limit.
- Confirm each slide has one main message.
- Identify slides that are slow to explain and split or simplify them.
- Create static fallbacks for videos, animations, embedded web content, or fragile interactive elements.
- Consider a PDF or static backup for live presentations.
- Avoid relying on internet access, external runtime dependencies, or live computation during a presentation unless the event explicitly supports it.
- Use speaker notes for prompts, transitions, caveats, and details the audience should not read on the slide.
- Verify projected readability, including text size, contrast, figure labels, tables, equations, and color meaning.

Do not claim visual review, projected-readability review, or backup export checks unless those artifacts were actually opened or inspected.

## Handoffs

- Use the `quarto-format-configuration` skill and its `presentations.md` reference for revealjs, PowerPoint, Beamer, YAML, themes, templates, slide numbers, speaker notes, and format-specific behavior.
- Use `quarto-authoring-core` for writing or editing the slide `.qmd` content.
- Use `quarto-render-troubleshooting` for rendering, opening, inspecting, or verifying generated presentation artifacts.
- Use `quarto-computation-performance` when slide decks execute expensive analyses or consume generated artifacts.
- Use `quarto-format-configuration` when presentation design choices require a specific output format.

## Official and Authoritative Sources Checked

Last reviewed: 2026-06-15

- [Harvard Catalyst: Slides](https://catalyst.harvard.edu/writing-communication-center/visualize-science/slides/)
- [Harvard T.H. Chan School of Public Health: Strategies for Clear, Engaging Slides](https://hsph.harvard.edu/research/health-communication/resources/strategies-for-clear-engaging-slides/)
- [Penn State Engineering Communication: Presenting as an Engineer or Scientist](https://www.writing.engr.psu.edu/speaking.html)
- [Penn State Assertion-Evidence Tutorial](https://www.assertion-evidence.org/tutorial.html)
- [Garner and Alley, 2013: How the design of presentation slides affects audience comprehension](https://pure.psu.edu/en/publications/how-the-design-of-presentation-slides-affects-audience-comprehens/)
- [Naegle, 2021: Ten simple rules for effective presentation slides](https://journals.plos.org/ploscompbiol/article?id=10.1371%2Fjournal.pcbi.1009554)
- [Nielsen Norman Group: Creating Engaging Reports and Asynchronous Presentations](https://www.nngroup.com/articles/engaging-reports-presentations/)
- [Quarto Presentations documentation](https://quarto.org/docs/presentations/)
