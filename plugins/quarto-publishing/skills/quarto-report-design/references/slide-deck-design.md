# Quarto Slide Deck Design Patterns

## Purpose

Use this reference for **slide communication design**: audience, purpose, sequence, evidence, visuals, and delivery readiness. These principles are not tied to a presentation engine. For YAML, templates, animation syntax, or other format mechanics, use `quarto-format-configuration` and its `presentations.md` reference.

**Contents:** [Situation](#first-decide-the-communication-situation) · [Titles](#use-concise-descriptive-titles) · [Figures and evidence](#use-figures-tables-code-and-equations) · [Narrative](#organize-the-narrative) · [Delivery](#design-for-delivery-and-failure)

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
- Teaching or training deck: organize for concept progression and learner practice. For a **new or substantially redesigned teaching sequence**, consult [pedagogical-communication.md](pedagogical-communication.md) before composing slides; narrow visual-only revisions need it only when explanations are affected.
- Progress or update deck: prioritize what changed, what was learned, what is blocked, what decisions are needed, and what comes next.

Mixed decks should keep the main path readable and move secondary detail into backup slides, appendices, handouts, or a companion report.

### Calibrate scientific talks to the contribution

For a **research talk, conference presentation, seminar, or defense**, decide what the audience must understand about the contribution. The **contribution and audience** determine the depth; the venue label alone does not. A methodological seminar and a methodological conference talk share a communication profile but may differ in time and audience expertise.

- **Method-focused research:** introduce the methodological problem and what the method changes; show its defining assumptions or mechanism, then the comparative evidence (e.g., bias, coverage, convergence or performance across conditions) and limitations. Make a technical deep dive only where it supports the claim.
- **Application-focused research:** lead with the substantive question, population/data and main evidence; present modeling choices sufficient to judge credibility, estimates in interpretable units, substantive implications and limitations. Do not bury a decisive modeling assumption to make the talk accessible.
- **Mixed audience:** explain the terms and reference quantities necessary to read the central figure; keep extra derivations and diagnostics accessible as backup rather than making every slide elementary.

**Use time to select evidence, not to enforce a slide count.** Work from the actual speaking window after introductions, transitions and reserved discussion. Identify the one finding or methodological decision that must survive a shorter talk; protect time for its interpretation, then choose which comparisons or derivations earn deeper treatment. Rehearse the critical transitions and remove secondary content if the talk overruns; do not make all figures smaller or narrate them faster. Longer talks permit selected depth, not an obligation to cover the entire paper.

## Use Concise, Descriptive Titles

Prefer **short, nominal and descriptive titles** naming the concept, comparison, finding, or procedure. In research and methodological talks, use labels such as “Coverage by estimator”, “Bias across sample sizes” or “Measurement model”, **not sentence-like claims, slogans or chapter-style headlines**. The body, figure and spoken explanation establish the conclusion. A more assertive executive title is a genre-specific exception, not the default.

- Name the specific object: "Indirect-path stability" or "Indirect effects across robustness checks", not "Results" or "Methods".
- Avoid headings that narrate the conclusion (e.g., “The indirect pathway was stable across robustness checks”) when “Indirect-path stability” names the same finding more naturally.
- Use questions only when they serve a deliberate teaching, prediction, or discussion purpose.
- Omit title-slide subtitles or slogans when they only repeat an idea introduced on the next slide.
- Give each slide a clear **local visual or explanatory step**. A larger idea may require several consecutive slides and need not be concluded or summarized on each one.
- Split complex explanations across slides instead of shrinking text or using long prose-filled cards.
- Avoid using projected slides as the speaker's script.

Titles identify **what is being examined**; the evidence and interpretation establish **what it means**.

## Convert Reports or Manuscripts into Slides

When converting a report, thesis section, manuscript, or technical note into slides:

- Extract the argument, not the prose.
- Preserve objectives, hypotheses, analytical intent, and the evidence chain.
- Replace paragraphs with short, descriptive nominal titles and supporting evidence; put the actual finding or implication in the slide body or spoken explanation.
- Simplify methods to the level the audience needs without distorting what was done.
- Organize results by argument, research question, decision, or teaching sequence rather than by analysis script order.
- Convert dense tables into visual summaries when pattern recognition matters.
- Keep exact-value tables only when the values are central and readable.
- Move full model tables, secondary diagnostics, lengthy supporting derivations, robustness checks, and secondary results into backup material; retain essential derivation steps in the main deck when understanding them is the learning objective.
- Do not oversimplify results in ways that change the meaning, uncertainty, limitation, or evidentiary support of the original analysis.

Avoid mechanical section-to-slide mapping. A report section may become several slides, one slide, a backup slide, or no slide at all depending on the audience task. Within an authorized pedagogical redesign, reconsider the existing slides rather than merely reordering or accumulating them: merge, replace, omit, or move redundant material to backup while retaining needed evidence.

## Manage Slide Density

Design for **projection**, not for fitting a manuscript page:

- **Prefer large, readable type:** for conventional projected 16:9 slides, start around **22–28 pt for main text** and **28–36 pt for titles**. Treat these as starting points, not universal software settings; actual size and viewing conditions govern.
- **Protect essential detail:** keep figure axes, equation symbols and necessary table labels readable (preferably at least about 18–20 pt when using point-based typography). Text at 8–10 pt is not suitable for content the audience must read.
- **Split instead of shrinking:** distribute a crowded equation, table, diagram or explanation across successive slides; enlarge the relevant detail. Do not reduce the font to make everything fit.
- **Balance the usable slide area:** inspect the rendered composition, not only whether objects fit. If meaningful content is unnecessarily packed near the top with a large empty lower region, first enlarge central text, plots or diagrams to a readable scale; then adjust alignment or spacing. Center a genuinely sparse composition or combine adjacent slides only when this improves continuity without crowding. Preserve intentional whitespace and never add new elements merely to fill it.
- Use whitespace and consistent hierarchy to guide attention. Avoid ornamental effects, dense manuscript figures, long bullets and small-text boxes.
- Put secondary diagnostics and detailed evidence in backup material when not needed in the live argument; do not omit scientifically consequential limitations.
- **Keep numerical notation consistent:** follow the user/project convention for decimal symbols and thousands grouping across charts, tables, axes, text and annotations. For example, if the deck uses a decimal point and no thousands separator, render `0.835` and `7138` consistently. Do not silently change values, rounding or the underlying analysis.
- **Inspect the rendered deck:** check real screen/projection readability, visual balance and number formatting, including graph labels and equations. For web/CSS presentations, verify visual size rather than treating point values as literal CSS settings.

A dense technical subject warrants **more appropriately sequenced detail**, not smaller type. If a slide is slow to explain, first consider whether the idea should progress through several slides instead.

## Use Figures, Tables, Code, and Equations

- Figures should support the slide's main idea. Redesign dense manuscript figures when needed.
- Prefer figures over tables when the goal is pattern recognition.
- Use tables only when exact values matter and the table remains legible.
- Break dense tables into smaller tables, key-number callouts, visual summaries, or backup material.
- Code should usually be short, pedagogical, or diagnostic. Do not put long production code on projected slides unless code review is the point.
- Introduce equations progressively when useful. Across adjacent states of the same object, keep unchanged terms aligned and make additions, removals, or changed contributions perceptible; use aligned static slides or animation only when it clarifies the mechanism.
- Diagnostics belong in the main deck only when they are central to the argument, decision, or technical review. Otherwise, place them in technical or backup slides.
- Captions on projected slides should usually be shorter than manuscript captions. Use notes, backup slides, or companion reports for extended explanation.

### Plan and verify explanatory representations

For a new teaching sequence, **choose the depiction for the learning difficulty**:

- **Relationships:** an annotated model with correct variable and arrow directions.
- **Decisions:** a flow showing what evidence changes the next step.
- **Contrasts:** aligned conditions with unchanged parts visible.
- **Magnitude or uncertainty:** a quantitative plot with meaningful axes and units.
- **Exact values:** a readable small table. Use prose when clearer.

**Check meaning, not just bounds.** Match arrows, labels, axes, units, signs, denominators, estimates, and intervals to the source model, data, and code. A reversed path is wrong even if the drawing looks polished.

When teaching **scientific reporting**:

- Show a readable published table/figure or documented excerpt, then a **separately labeled** reproduction or learner-authored example.
- Distinguish an original screenshot from a transcription, adapted layout, or newly calculated result. Cite the source and respect reuse permissions.
- Follow relevant reporting conventions (e.g., APA when appropriate). Include titles, metric definitions, uncertainty, and notes; visual styling alone is insufficient.
- Crop or redraw a source responsibly when a full-page image is unreadable. Never silently change source values.

## Organize the Narrative

Design the main path as a talk, not as a file dump:

1. Open with the problem, motivation, decision, or teaching need.
2. State a roadmap only if it helps the audience follow the sequence.
3. Include methods and results at the depth needed to support the argument.
4. Close with the warranted implications, limitations, contribution or synthesis; keep secondary details in backup material.

### Build continuous blocks, not isolated mini-presentations

Treat the **communication block**, rather than each slide, as the unit that develops an idea. For example, sample size and statistical precision may progress through a problem, an enlarged plot, a controlled comparison and an interpretation across several slides. Keep the same visual reference, labels and scale when that continuity helps; use transitions that feel like one explanation. A technical talk may need more stages, not denser individual slides.

- **No takeaway on every slide:** do not append a recurring “Key message”/“Takeaway” footer, summary box or miniature conclusion to each intermediate step. The title, visual and spoken transition can carry its purpose without a separate slogan.
- **Summarize selectively:** use an explicit takeaway only when it adds value—typically after the block has developed the evidence, at a genuine decision or transition. It may be spoken rather than printed; if projected, make it a legible main element, not tiny text in a bottom rectangle.
- **Keep boundaries fluid:** do not require a question, activity, summary or forced pause on each slide. Preserve a clear narrative across as many steps as needed without imposing a fixed slide count.

For academic decks, preserve research logic; for executive decks, decision logic; for technical decks, inspection logic; for teaching decks, learning progression. The difference is **depth and evidence**, not an obligation to make each slide self-contained.

## Design for Delivery and Failure

### Decide what appears on screen versus in speaker notes

- **Project what must be seen:** a meaningful concept or definition, graph, equation, selected evidence, readable comparison, diagram or short cue. One central definition can occupy its own slide if the audience needs to examine its terms.
- **Speak what must be explained:** elaboration, examples, transitions between stages, interpretation and delivery prompts belong in speaker notes or oral narration. For a multi-slide block, note its shared objective and the transitions between stages in the presenter notes, not as repeated projected boxes. Do not copy the lecturer's paragraphs onto slides.
- **Keep necessary evidence visible:** do not move a number, assumption, qualification or source citation that the audience must inspect into notes alone. For self-study or inaccessible notes, provide an appropriate companion handout rather than turning projected slides into a transcript.

For live teaching, plan breaks and optional activities without turning the projected deck into an instructor schedule. Display instructions or timings only when the audience needs them. Keep the path flexible.

Before treating a deck as ready:

- Rehearse **transitions within each multi-slide block**, not just the order of isolated slides.
- Check the real speaking window, including activities, interpretation and pauses; adjust the block's scope if needed.
- Check that each slide introduces a readable step and that any synthesis appears at a meaningful boundary, not automatically after each step.
- Split or simplify graphics, tables, formulas and prose that become too small or take too long to explain.
- Test projected readability, including title/body sizes, figure labels, equations, contrast and color meaning.
- Provide static fallbacks for fragile animation, video or web content when relevant; avoid unapproved live runtime dependencies.
- Keep prompts, transitions and oral elaboration in speaker notes when the format supports them. Do not claim checks of notes, readability or backups that were not performed.

Do not claim visual review, projected-readability review, or backup export checks unless those artifacts were actually opened or inspected.

## Handoffs

- Use the `quarto-format-configuration` skill and its `presentations.md` reference for revealjs, PowerPoint, Beamer, YAML, themes, templates, slide numbers, speaker notes, and format-specific behavior.
- Use `quarto-authoring-core` for writing or editing the slide `.qmd` content.
- Use `quarto-render-troubleshooting` for rendering, opening, inspecting, or verifying generated presentation artifacts.
- Use `quarto-computation-performance` when slide decks execute expensive analyses or consume generated artifacts.
- Use `quarto-format-configuration` when presentation design choices require a specific output format.

## Official and Authoritative Sources Checked

Selected scientific-presentation sources reviewed: 2026-11-21

- [Harvard Catalyst: Slides](https://catalyst.harvard.edu/writing-communication-center/visualize-science/slides/)
- [Harvard T.H. Chan School of Public Health: Strategies for Clear, Engaging Slides](https://hsph.harvard.edu/research/health-communication/resources/strategies-for-clear-engaging-slides/)
- [Harvard T.H. Chan School of Public Health: Slide Design Checklist](https://hsph.harvard.edu/research/health-communication/resources/slide-checklist/)
- [Grambow and Weinfurt (2024): Effective Scientific Presentations Across Formats](https://doi.org/10.14738/assrj.119.17551)
- [Penn State Engineering Communication: Presenting as an Engineer or Scientist](https://www.writing.engr.psu.edu/speaking.html)
- [Penn State Assertion-Evidence Tutorial](https://www.assertion-evidence.org/tutorial.html)
- [Garner and Alley, 2013: How the design of presentation slides affects audience comprehension](https://pure.psu.edu/en/publications/how-the-design-of-presentation-slides-affects-audience-comprehens/)
- [Naegle, 2021: Ten simple rules for effective presentation slides](https://journals.plos.org/ploscompbiol/article?id=10.1371%2Fjournal.pcbi.1009554)
- [Nielsen Norman Group: Creating Engaging Reports and Asynchronous Presentations](https://www.nngroup.com/articles/engaging-reports-presentations/)
- [Quarto Presentations documentation](https://quarto.org/docs/presentations/)
- [Bourne (2007): Ten simple rules for making good oral presentations](https://doi.org/10.1371/journal.pcbi.0030077)
- [Sura et al. (2019): Ten simple rules for giving an effective academic job talk](https://doi.org/10.1371/journal.pcbi.1007163)
