# Quarto Publishing Plugin Architecture

## Purpose

The `quarto-publishing` plugin provides reusable agent skills for working with Quarto as a publishing system for analytical, academic, technical, and executive outputs.

The plugin is not limited to writing `.qmd` files. It should help an AI agent reason about Quarto as a complete workflow that includes authoring, project configuration, format-specific rendering, multi-format compatibility, report design, computation strategy, migration from R Markdown, deployment, accessibility, quality review, and troubleshooting.

The plugin should be useful when the user wants to create, review, refactor, diagnose, or improve Quarto documents and projects, especially in research-oriented computational workflows using R/knitr, Python/Jupyter, Julia, or prose-only Quarto documents.

## General Scope

The plugin should cover:

* General Quarto authoring and Markdown syntax.
* Executable code cells, inline computations, cell or chunk options, figures, tables, equations, theorems, cross-references, citations, callouts, div blocks, shortcodes, and reusable document patterns.
* Quarto projects, `_quarto.yml`, `_metadata.yml`, shared metadata, project profiles, project-level execution, parameters, and project organization.
* Format-specific configuration for HTML, PDF, Typst, DOCX, revealjs, PowerPoint, Beamer, websites, books, manuscripts, and other supported outputs.
* Multi-format rendering strategies, including conditional content, fallbacks for HTML-only artifacts, tables and figures that work across formats, and format-specific profiles.
* Communicative report design for executive, technical, academic, educational, and reproducible research outputs.
* Long-running renders, cache, freeze, externalized computation, precomputed artifacts, and the distinction between Quarto as an authoring system and Quarto as part of a computational pipeline.
* Migration from R Markdown, Bookdown, Distill, Blogdown, Xaringan, ioslides, Beamer, and related R Markdown-based ecosystems.
* Publication and distribution through static files, self-contained HTML, GitHub Pages, Netlify, Posit Connect, Posit Connect Cloud, institutional delivery, and CI/CD workflows.
* Accessibility and quality practices, including alt text, heading structure, semantic tables, link text, language metadata, PDF accessibility, output review, and editorial consistency.
* Render troubleshooting, logs, YAML errors, chunk errors, LaTeX errors, Typst errors, bibliography problems, missing assets, broken links, screenshot review, browser-based inspection, and verification of rendered outputs.

## Architectural Principles

The plugin should follow these principles:

* Keep skills broad enough to represent meaningful workflows, but not so broad that a single skill becomes an encyclopedia.
* Prefer a small number of high-level skills with internal references over many overly specific skills.
* Use references for detailed technical material that would otherwise bloat `SKILL.md`.
* Use assets only for reusable templates, skeletons, examples, or design resources.
* Use scripts only for deterministic and repeatable checks, not for replacing methodological or publishing judgment.
* Avoid creating one skill per Quarto feature unless that feature becomes a recurring task with a clear activation pattern.
* Separate authoring, project configuration, format configuration, multi-format compatibility, performance, migration, deployment, accessibility, and troubleshooting because they represent different agent behaviors.
* Keep R/knitr support strong because the monorepo is R-oriented, but avoid making R the default assumption when the user's Quarto project uses Python, Julia, Jupyter, or prose-only documents.
* Preserve the user’s analytical and communicative intent when editing Quarto documents.
* Avoid claiming that a render, screenshot, link, or output has been checked unless the agent actually performed that check.

## Target Skill Architecture

The target architecture of the plugin should include the following skills:

1. `quarto-authoring-core`
2. `quarto-project-configuration`
3. `quarto-format-configuration`
4. `quarto-multiformat-compatibility`
5. `quarto-report-design`
6. `quarto-computation-performance`
7. `quarto-rmarkdown-migration`
8. `quarto-publishing-deployment`
9. `quarto-accessibility-quality`
10. `quarto-render-troubleshooting`

This represents the intended mature structure of the plugin. Early versions may implement only a subset of these skills and temporarily keep some future skills as references inside broader skills.

## Skill 1: `quarto-authoring-core`

### Purpose

Provide core guidance for writing, reviewing, and refactoring Quarto `.qmd` content.

This skill focuses on the document body and authoring layer, rather than project-level configuration, output deployment, or render debugging.

### Covers

* Quarto Markdown syntax.
* Headings and document structure.
* Executable code cells or chunks.
* Inline computations, including inline R where applicable.
* Recommended cell or chunk options for ordinary analytical documents.
* Figures and figure captions.
* Tables and table captions.
* Equations.
* Theorems, proofs, definitions, lemmas, and related formal blocks.
* Cross-references for figures, tables, equations, sections, listings, and theorems.
* Citations and bibliographies.
* Callouts.
* Div blocks.
* Shortcodes.
* Basic layout elements.
* Authoring patterns for academic, technical, and analytical documents.

### Should Evaluate

* Whether the `.qmd` structure is readable and maintainable.
* Whether labels and cross-references are correctly named.
* Whether figures and tables have meaningful captions.
* Whether citations are represented consistently.
* Whether cell or chunk options are proportional to the task.
* Whether the document body is portable enough for the intended output.
* Whether the authoring choices preserve the user’s statistical and analytical intent.

### Should Not Cover as Primary Focus

* Project-level `_quarto.yml` architecture.
* Advanced format-specific YAML.
* Publication and deployment.
* Long-running computation strategies.
* Deep troubleshooting of render failures.
* Migration from legacy R Markdown projects.

These topics may be referenced briefly, but they belong primarily to other skills.

### Possible References

Early versions may keep these topics in one compact reference such as `qmd-authoring-patterns.md`. If authoring guidance grows large enough, it can later split into focused references such as:

* `markdown-syntax.md`
* `chunk-options-defaults.md`
* `figures-and-tables.md`
* `cross-references.md`
* `citations.md`
* `equations-and-theorems.md`
* `callouts-divs-and-shortcodes.md`

## Skill 2: `quarto-project-configuration`

### Purpose

Guide the design and review of Quarto projects and shared configuration.

This skill focuses on the project layer: `_quarto.yml`, `_metadata.yml`, shared options, project profiles, parameters, project types, directory structure, and configuration reuse.

### Covers

* Quarto project types.
* `_quarto.yml`.
* `_metadata.yml`.
* Shared YAML configuration.
* Directory-level metadata.
* Project profiles.
* Parameters.
* Project-level render behavior.
* Project-level `freeze`.
* Website, book, and manuscript project structure.
* Shared bibliography and citation configuration.
* Shared format options.
* Includes and reusable metadata.
* Project organization for multiple reports.
* Separation between document-level YAML and project-level YAML.

### Should Evaluate

* Whether configuration belongs in the document YAML or in `_quarto.yml`.
* Whether repeated YAML should be centralized.
* Whether profiles are needed for different audiences or outputs.
* Whether parameters are appropriate for repeated reports.
* Whether project structure is clear and scalable.
* Whether project-level execution settings are safe.
* Whether shared metadata makes the project easier to maintain.
* Whether `_metadata.yml` could simplify directory-specific configuration.

### Important Use Cases

* A website with many pages.
* A book with chapters.
* A manuscript with shared metadata.
* A reporting system with repeated reports.
* A project that needs `dev`, `draft`, `production`, `html-only`, `pdf-submission`, `executive`, or `technical` profiles.
* A project where document YAML has become repetitive or difficult to maintain.

### Possible References

* `quarto-projects.md`
* `_quarto-yml-patterns.md`
* `_metadata-yml-patterns.md`
* `project-profiles.md`
* `parameters.md`
* `project-organization.md`
* `shared-metadata.md`

## Skill 3: `quarto-format-configuration`

### Purpose

Configure and review Quarto output formats.

This skill focuses on format-specific YAML and rendering behavior for outputs such as HTML, PDF, Typst, DOCX, revealjs, PowerPoint, Beamer, websites, books, manuscripts, and ePub.

### Covers

* HTML output.
* PDF output through LaTeX.
* PDF output through Typst.
* DOCX output.
* Revealjs presentations.
* PowerPoint presentations.
* Beamer presentations.
* Websites.
* Books.
* Manuscripts.
* ePub and other secondary formats when needed.
* Format-specific YAML.
* Templates.
* `reference-doc`.
* CSS, SCSS, Bootstrap, and themes.
* HTML options.
* PDF options.
* LaTeX includes.
* Typst configuration.
* `include-in-header`.
* `include-before-body`.
* `include-after-body`.
* Custom formats.
* Quarto extensions.
* Lua filters when relevant to output behavior.
* Format-specific limitations.

### Should Evaluate

* Whether the selected output format matches the user’s goal.
* Whether YAML options are placed at the right level.
* Whether format-specific options are valid for the selected output.
* Whether HTML-only features are being used in a static format.
* Whether PDF requirements are correctly handled.
* Whether DOCX output needs a reference document.
* Whether presentations should use revealjs, PowerPoint, or Beamer.
* Whether Typst is a better option than LaTeX for the user’s PDF needs.
* Whether a custom format or extension is justified.

### Should Not Cover as Primary Focus

* General authoring syntax.
* Multi-format compatibility strategy across several outputs.
* Communicative structure of the report.
* Render troubleshooting after failure.
* Deployment to hosting platforms.

### Possible References

* `html-output.md`
* `pdf-latex-output.md`
* `pdf-typst-output.md`
* `docx-output.md`
* `presentations.md`
* `websites-books-manuscripts.md`
* `themes-branding-and-scss.md`
* `extensions-and-custom-formats.md`
* `yaml-patterns.md`
* `lua-filters.md`

## Skill 4: `quarto-multiformat-compatibility`

### Purpose

Help design Quarto documents and projects that render correctly across multiple output formats.

This skill focuses on compatibility between formats, not just configuring each format separately.

### Naming Decision

Use `quarto-multiformat-compatibility`, not `quarto-multiformat-portability`.

Rationale:

* `compatibility` better describes the problem of making one document work across HTML, PDF, DOCX, PPTX, and other outputs.
* `portability` may suggest moving a project between systems or environments.
* The central concern is cross-format behavior, graceful degradation, and valid rendering across output targets.

### Covers

* Multi-format rendering.
* Conditional content by format.
* Format-specific includes.
* Format links.
* Project profiles by output.
* HTML-only content and static fallbacks.
* HTML widgets and non-HTML alternatives.
* Interactive tables and static tables.
* Interactive figures and static figures.
* Tables that work across HTML, PDF, DOCX, and PPTX.
* Figures that work across HTML, PDF, DOCX, and PPTX.
* Callouts and div behavior across formats.
* Cross-reference behavior across formats.
* CSS or HTML features that do not translate to static outputs.
* Output-specific limitations.
* Strategies for testing multiple outputs.

### Should Evaluate

* Whether the requested outputs are realistically compatible.
* Whether a single `.qmd` should produce all outputs or whether separate profiles/files are needed.
* Whether HTML-only artifacts need static fallbacks.
* Whether conditional content is necessary.
* Whether tables and figures are generated with tools appropriate for the target formats.
* Whether a feature will silently degrade or fail in non-HTML outputs.
* Whether format-specific branches are becoming too complex.
* Whether the user should prioritize one canonical output and secondary exports.

### Important Use Cases

* A report that must render to HTML and PDF.
* A document that must render to HTML, DOCX, and PDF.
* A slide deck that also needs a printable handout.
* A report with `plotly`, `DT`, `gt`, `flextable`, `kableExtra`, or `htmlwidgets`.
* A manuscript that needs both HTML preview and PDF submission.
* A teaching document that needs website and PDF outputs.

### Possible References

* `conditional-content.md`
* `format-links.md`
* `project-profiles-by-output.md`
* `html-widget-fallbacks.md`
* `tables-across-formats.md`
* `figures-across-formats.md`
* `cross-format-limitations.md`
* `multi-output-testing.md`

## Skill 5: `quarto-report-design`

### Purpose

Translate a reporting goal and audience into a coherent Quarto deliverable structure.

This skill should not be a generic writing skill. It should focus on how to structure Quarto outputs according to audience, purpose, medium, and level of technical detail.

### Covers

* Executive reports.
* Technical reports.
* Academic manuscripts.
* Reproducible research reports.
* Psychometric reports.
* Simulation study reports.
* Applied analysis reports.
* Teaching handouts.
* Slide decks.
* Appendices and supplements.
* Executive summaries.
* Technical methods sections.
* Results narratives.
* Tables and figures as communication devices.
* Report density.
* Section hierarchy.
* Navigation structure.
* Callout use for interpretation, warnings, notes, and recommendations.
* Placement of code, diagnostics, tables, and appendices.
* Choosing between HTML, PDF, DOCX, slides, website, book, or manuscript format based on audience.

### Should Evaluate

* Who the intended audience is.
* Whether the output is meant for decision-making, technical review, academic evaluation, teaching, or reproducibility.
* Whether the current structure matches the audience.
* Whether technical details should be in the main text, appendix, collapsible sections, or supplementary files.
* Whether the report needs an executive summary.
* Whether results are overexplained or underexplained.
* Whether tables and figures are placed strategically.
* Whether the chosen Quarto format supports the intended communication style.
* Whether a template or reusable report skeleton would help.

### Pros of Having This as a Separate Skill

* It has clear activation patterns.
* It is not merely YAML configuration.
* It supports audience-aware publishing.
* It bridges analytical plugins and Quarto outputs.
* It can help turn raw analyses into structured deliverables.
* It avoids overloading `quarto-format-configuration`.

### Risks

* It could become too close to a general writing or editing skill.
* It may overlap with future reporting or academic writing plugins.
* It could become too subjective if boundaries are not clear.

### Boundary Rule

This skill should focus on the structure of Quarto deliverables, not general prose editing. It should answer questions such as:

* What sections should this report have?
* What should go in the appendix?
* Should this be a website, PDF, manuscript, or slide deck?
* How should technical and executive versions differ?
* How should Quarto features support the intended communication?

### Possible References

* `executive-report-structure.md`
* `technical-report-structure.md`
* `academic-manuscript-structure.md`
* `reproducible-report-structure.md`
* `teaching-handouts.md`
* `slide-deck-design.md`
* `appendices-and-supplements.md`
* `audience-format-mapping.md`

## Skill 6: `quarto-computation-performance`

### Purpose

Guide Quarto workflows that involve expensive computation, long renders, caching, freezing, or pipeline-like execution.

This skill focuses on the distinction between Quarto as an authoring tool and Quarto as one component of a computational pipeline.

### Covers

* Long-running renders.
* Chunk cache.
* Project-level freeze.
* Document-level freeze.
* Externalized computation.
* Precomputed artifacts.
* `.rds`, `.qs`, `.parquet`, Arrow, DuckDB, and related storage formats when appropriate.
* Separation between analysis scripts and publication documents.
* Avoiding expensive recomputation.
* Rendering only what needs to be rendered.
* Simulation outputs.
* Model fitting outputs.
* Data preprocessing outside `.qmd`.
* Reproducible pipelines.
* Integration with `targets`, `drake`, `Make`, or similar tools when appropriate.
* Validation proportional to task size.
* Agent behavior when render time is expected to be long.

### Should Evaluate

* Whether the `.qmd` is doing too much computation.
* Whether expensive analysis should be precomputed.
* Whether chunk cache is sufficient or too fragile.
* Whether `freeze` is appropriate.
* Whether the render process is reproducible.
* Whether random seeds and intermediate artifacts are handled correctly.
* Whether the document can be validated without full recomputation.
* Whether the render time is acceptable for the workflow.
* Whether outputs can be regenerated from source when needed.
* Whether a pipeline should exist outside Quarto.

### Practical Rule

A `.qmd` should not routinely require very long render times unless the design is deliberate and justified. For heavy simulations, large models, repeated reports, or expensive preprocessing, Quarto should usually consume prepared artifacts rather than recompute everything during every render.

### Possible References

* `cache-and-freeze.md`
* `long-running-renders.md`
* `externalized-computation.md`
* `precomputed-artifacts.md`
* `simulation-reporting.md`
* `pipeline-integration.md`
* `proportional-validation.md`

## Skill 7: `quarto-rmarkdown-migration`

### Purpose

Support migration from R Markdown and related ecosystems to Quarto.

This skill should help agents identify legacy patterns, preserve working behavior, and convert projects gradually when appropriate.

### Covers

* R Markdown to Quarto migration.
* Bookdown to Quarto book migration.
* Distill to Quarto website migration.
* Blogdown to Quarto website migration when appropriate.
* Xaringan to revealjs migration.
* ioslides or Slidy to Quarto presentations.
* Beamer R Markdown to Quarto Beamer or PDF workflows.
* `_output.yml` to `_quarto.yml`.
* `_bookdown.yml` to Quarto book configuration.
* R Markdown YAML differences.
* Chunk option differences.
* Cross-reference migration.
* Bibliography and CSL migration.
* Themes and CSS migration.
* Output path changes.
* Figure and table label changes.
* Parameters.
* Legacy templates.
* Deciding whether to migrate or keep existing `.Rmd` files.

### Should Evaluate

* Whether migration is actually needed.
* Whether the old project currently renders.
* Whether a gradual migration is safer than a full rewrite.
* Which features are R Markdown-specific.
* Which features have direct Quarto equivalents.
* Which features need redesign.
* Whether cross-references will break.
* Whether output paths and deployment targets will change.
* Whether the project structure should be reorganized.
* Whether the user needs compatibility with existing institutional templates.

### Important Use Cases

* Converting an old R Markdown report to Quarto.
* Migrating a Bookdown thesis or report.
* Migrating Xaringan slides to revealjs.
* Moving a Distill site to Quarto.
* Cleaning a mixed `.Rmd` and `.qmd` project.
* Helping an agent avoid unnecessary rewrites.

### Possible References

* `rmarkdown-to-quarto.md`
* `bookdown-to-quarto.md`
* `xaringan-to-revealjs.md`
* `distill-blogdown-migration.md`
* `legacy-yaml-migration.md`
* `crossref-migration.md`
* `migration-checklist.md`

## Skill 8: `quarto-publishing-deployment`

### Purpose

Guide publication and distribution of Quarto outputs.

This skill focuses on what happens after the document or project renders: where the output goes, how it is served, how it is delivered, and how it remains usable.

### Covers

* Self-contained HTML.
* Static HTML outputs.
* Websites.
* Books.
* Manuscripts.
* GitHub Pages.
* Netlify.
* Quarto Pub.
* Posit Connect.
* Posit Connect Cloud.
* Institutional hosting.
* Local file delivery.
* PDF, DOCX, and PPTX delivery.
* Output directories.
* `_site`.
* `_book`.
* Resource paths.
* Assets.
* Images.
* Downloads.
* CI/CD with GitHub Actions or similar tools.
* Publish profiles.
* Environment variables for deployment.
* Reproducible publication workflows.
* Versioned outputs.
* Public vs private publishing.

### Should Evaluate

* Whether the output is meant for local use, institutional delivery, or public web publishing.
* Whether the project structure supports the deployment target.
* Whether relative paths will work after publishing.
* Whether assets are included correctly.
* Whether downloadable files are linked correctly.
* Whether the output should be self-contained.
* Whether CI/CD is necessary.
* Whether publishing requires authentication or secrets.
* Whether publication should happen from the project root or a subdirectory.
* Whether rendered outputs should be committed to Git.

### Important Use Cases

* Publishing a Quarto website to GitHub Pages.
* Publishing a report to Posit Connect.
* Preparing a self-contained HTML report for email or institutional delivery.
* Delivering PDF and DOCX versions of a report.
* Publishing a book or documentation site.
* Automating report publishing in CI.

### Possible References

* `github-pages.md`
* `netlify.md`
* `posit-connect.md`
* `self-contained-html.md`
* `static-site-deployment.md`
* `ci-cd-publishing.md`
* `output-directories-and-assets.md`
* `versioned-publication.md`

## Skill 9: `quarto-accessibility-quality`

### Purpose

Review Quarto outputs for accessibility, quality, and publication readiness.

This skill should not be limited to visual polish. It should address whether the output is usable, navigable, semantically clear, and appropriate for its target audience and distribution context.

### Covers

* Alt text for figures.
* Meaningful captions.
* Heading hierarchy.
* Link text.
* Semantic tables.
* Tables that are not purely visual.
* Language metadata.
* Metadata completeness.
* Navigation clarity.
* Readability of long documents.
* Accessibility of HTML outputs.
* Accessibility of PDF outputs when possible.
* PDF/A and PDF/UA considerations.
* Contrast and visual hierarchy.
* Avoiding color-only encoding.
* Appendix and supplement structure.
* Broken or ambiguous links.
* Editorial consistency.
* Reproducibility cues.
* Output review before delivery.

### Should Evaluate

* Whether images have meaningful alt text.
* Whether headings are logically nested.
* Whether links make sense out of context.
* Whether tables are accessible and interpretable.
* Whether figures rely only on color.
* Whether navigation is clear.
* Whether language and metadata are defined.
* Whether the output is suitable for public or institutional delivery.
* Whether the document has avoidable quality problems.
* Whether accessibility requirements differ by output format.

### Important Use Cases

* Preparing public-facing reports.
* Publishing institutional documents.
* Reviewing HTML outputs for accessibility.
* Reviewing PDFs for basic accessibility considerations.
* Improving educational materials.
* Reviewing websites, books, or manuscripts before delivery.

### Possible References

* `alt-text.md`
* `heading-structure.md`
* `accessible-tables.md`
* `links-and-navigation.md`
* `pdf-accessibility.md`
* `visual-quality-checklist.md`
* `publication-readiness.md`

## Skill 10: `quarto-render-troubleshooting`

### Purpose

Diagnose and fix Quarto render failures or output verification problems.

This skill should cover troubleshooting, not only diagnostics. The agent should identify the problem, isolate likely causes, propose fixes, and verify results when tools are available.

### Naming Decision

Use `quarto-render-troubleshooting`, not `quarto-render-diagnostics`.

Rationale:

* `troubleshooting` is the natural English term for solving technical problems.
* `diagnostics` emphasizes identifying the problem, but not necessarily fixing and verifying it.
* `threshold` should not be used here. It means an evaluation cutoff or boundary, not problem solving.

### Covers

* Failed `quarto render`.
* YAML errors.
* Chunk execution errors.
* Missing packages.
* Missing files.
* Working directory problems.
* Path problems.
* LaTeX errors.
* Typst errors.
* Bibliography and CSL errors.
* Citation rendering errors.
* Cross-reference errors.
* Image and asset errors.
* Extension errors.
* Theme or CSS errors.
* HTML output inspection.
* Screenshot-based review.
* Browser-based review through Playwright or similar tools.
* Link checking.
* Anchor checking.
* Navigation checking.
* Logs and diagnostic commands.
* CI render failures.
* Differences between local and CI rendering.

### Should Evaluate

* Whether the error is caused by Quarto, R, Python, YAML, LaTeX, Typst, Pandoc, paths, missing dependencies, or project configuration.
* Whether a minimal reproducible render can isolate the issue.
* Whether the problem is document-level or project-level.
* Whether the output was actually generated.
* Whether screenshots or browser inspection are needed.
* Whether links and anchors work.
* Whether the agent has enough access to claim that the render was verified.
* Whether a partial render or targeted render is safer than rendering the full project.
* Whether logs are sufficient for diagnosis.

### Required Agent Behavior

The agent must not claim that a render, screenshot, navigation path, link, or output was checked unless it actually performed that check.

When tools are available, the agent should prefer direct verification:

* Run `quarto render` when possible.
* Inspect logs when render fails.
* Open generated HTML when available.
* Use screenshots for visual review when appropriate.
* Use browser automation when available.
* Check relevant sections through internal links if the document includes anchors.
* Avoid full expensive renders when a targeted check is enough.

When tools are not available, the agent should be explicit about limitations and provide a reproducible troubleshooting plan.

### Possible References

* `render-failure-checklist.md`
* `yaml-errors.md`
* `chunk-errors.md`
* `latex-errors.md`
* `typst-errors.md`
* `bibliography-errors.md`
* `paths-and-assets.md`
* `html-verification.md`
* `screenshot-review.md`
* `browser-review.md`
* `ci-render-failures.md`

## Additional Dimensions to Include in the Plugin

The plugin should also account for the following dimensions. Some belong inside the skills above as references, while others may become future skills if they become large enough.

## Quarto Projects and Shared Configuration

Should be included under `quarto-project-configuration`.

Consider:

* `_quarto.yml`.
* `_metadata.yml`.
* Project type.
* Shared format options.
* Shared execution options.
* Directory-level metadata.
* Website navigation.
* Book chapters.
* Manuscript configuration.
* Project-level bibliography.
* Project-level resources.
* Profiles for development and production.

## Project Profiles

Should be included under `quarto-project-configuration`, with secondary relevance for `quarto-multiformat-compatibility` and `quarto-publishing-deployment`.

Possible profiles:

* `dev`
* `draft`
* `production`
* `executive`
* `technical`
* `html-only`
* `pdf-submission`
* `fast-render`
* `full-render`
* `public`
* `private`

Profiles should be used when the same project needs different behavior depending on audience, output, execution cost, deployment target, or publication stage.

## Parameters

Should be included under `quarto-project-configuration`, with secondary relevance for `quarto-computation-performance`.

Use cases:

* Repeated reports by group.
* Reports by country, region, institution, date, cohort, or sample.
* Sensitivity analyses.
* Executive and technical versions.
* Automated report generation.
* Teaching examples with variable inputs.
* Simulation summaries by condition.

The skill should help decide whether parameters belong in YAML, command-line rendering, profile configuration, or an external pipeline.

## Accessibility

Should be included under `quarto-accessibility-quality`.

Accessibility should not be treated as a purely cosmetic concern. It should be part of publication readiness.

Consider:

* Alt text.
* Captions.
* Heading hierarchy.
* Semantic tables.
* Link text.
* Color use.
* Language metadata.
* Navigation.
* PDF accessibility.
* Reader-friendly structure.
* Public-facing quality checks.

## Publishing and Distribution

Should be included under `quarto-publishing-deployment`.

Consider:

* GitHub Pages.
* Netlify.
* Posit Connect.
* Posit Connect Cloud.
* Static hosting.
* Self-contained HTML.
* PDF delivery.
* DOCX delivery.
* PPTX delivery.
* Websites.
* Books.
* Manuscripts.
* CI/CD.
* Output directories.
* Asset paths.
* Public vs private publishing.

## Typst

Should be included under `quarto-format-configuration`.

Typst should not dominate the early plugin, but it should be recognized as an important modern PDF route.

Evaluate:

* Whether Typst is preferable to LaTeX for the user’s PDF needs.
* Whether the requested PDF features are supported.
* Whether institutional or journal requirements require LaTeX instead.
* Whether the user needs faster PDF rendering.
* Whether the user needs highly customized academic PDF templates.

## Quarto as Authoring vs Quarto as Pipeline

Should be included under `quarto-computation-performance`.

The plugin should help agents decide when a `.qmd` should contain computation and when it should consume precomputed results.

Evaluate:

* Cost of rendering.
* Reproducibility.
* Debuggability.
* Size of data.
* Model fitting time.
* Simulation time.
* Need for intermediate artifacts.
* Whether a pipeline tool is more appropriate.
* Whether validation can be proportional rather than exhaustive.

## HTML-Specific Features

Should be distributed across several skills:

* General HTML syntax and HTML blocks: `quarto-authoring-core`.
* HTML output options, themes, CSS, SCSS, Bootstrap: `quarto-format-configuration`.
* HTML widgets and fallbacks: `quarto-multiformat-compatibility`.
* HTML deployment: `quarto-publishing-deployment`.
* HTML inspection and screenshot review: `quarto-render-troubleshooting`.
* HTML accessibility: `quarto-accessibility-quality`.

## Themes, Branding, and Visual Identity

Should initially live under `quarto-format-configuration`.

Consider a future skill only if the topic becomes large and recurring.

Possible future skill:

* `quarto-branding-theming`

Potential scope:

* Bootstrap themes.
* SCSS.
* Brand YAML if used.
* Logos.
* Favicons.
* Navigation styling.
* Dark mode.
* Institutional identity.
* CSS variables.
* Reusable visual templates.

## Extensions and Custom Formats

Should initially live under `quarto-format-configuration`.

Consider:

* Installing extensions.
* Using extensions.
* Evaluating whether an extension is necessary.
* Custom formats.
* Lua filters.
* Extension-specific limitations.
* Portability and reproducibility of extension-dependent projects.

A future advanced skill could be considered only if extension authoring becomes a major use case.

Possible future skill:

* `quarto-extensions-customization`

## Screenshots, Browser Review, and Render Verification

Should live under `quarto-render-troubleshooting`, with links to `quarto-accessibility-quality`.

The plugin should define when an agent should:

* Run `quarto render`.
* Open the generated HTML.
* Use screenshots.
* Use Playwright or browser automation.
* Navigate to specific anchors or subsections.
* Check internal links.
* Check visual layout.
* Check whether figures and tables appear correctly.
* Avoid claiming verification when no output was inspected.

## Scripts and Assets Strategy

The plugin should not start with many scripts or assets.

### Scripts Should Exist Only When They Are Deterministic

Possible future scripts:

* Check whether a Quarto project has `_quarto.yml`.
* Extract output formats from YAML.
* Check whether expected rendered files exist.
* Run targeted `quarto render` commands.
* Validate internal links in HTML.
* Check for missing figure files.
* Check for missing bibliography files.
* Detect long-running executable cells or chunks heuristically.
* Summarize render logs.

Scripts should not replace expert judgment about structure, audience, or analytical reporting.

### Assets Should Exist Only When Reusable

Possible future assets:

* Minimal report template.
* Executive report template.
* Technical report template.
* Academic manuscript template.
* Quarto website skeleton.
* Quarto book skeleton.
* Revealjs slide template.
* PDF submission template.
* Multi-format report skeleton.
* CSS or SCSS starter files.
* Reference DOCX templates.

Assets should be added only when the plugin repeatedly needs to create the same structure.

## Relationship Between Skills

The skills should be conceptually separate but able to work together.

Common combinations:

* `quarto-authoring-core` + `quarto-format-configuration`: writing a document for a specific output.
* `quarto-project-configuration` + `quarto-publishing-deployment`: building and publishing a website or book.
* `quarto-format-configuration` + `quarto-multiformat-compatibility`: configuring HTML, PDF, and DOCX outputs from the same source.
* `quarto-report-design` + `quarto-authoring-core`: turning analytical content into a coherent report.
* `quarto-computation-performance` + `quarto-project-configuration`: managing expensive project-level rendering.
* `quarto-rmarkdown-migration` + `quarto-project-configuration`: converting a legacy R Markdown project into a Quarto project.
* `quarto-render-troubleshooting` + `quarto-accessibility-quality`: verifying that a rendered output works and is publication-ready.
* `quarto-publishing-deployment` + `quarto-render-troubleshooting`: diagnosing deployment problems after render.

## Target Skill Structure

The mature plugin may eventually have this structure:

```text
plugins/quarto-publishing/
├── .codex-plugin/
│   └── plugin.json
├── README.md
├── CHANGELOG.md
└── skills/
    ├── quarto-authoring-core/
    │   ├── SKILL.md
    │   ├── agents/
    │   │   └── openai.yaml
    │   └── references/
    │
    ├── quarto-project-configuration/
    │   ├── SKILL.md
    │   ├── agents/
    │   │   └── openai.yaml
    │   └── references/
    │
    ├── quarto-format-configuration/
    │   ├── SKILL.md
    │   ├── agents/
    │   │   └── openai.yaml
    │   └── references/
    │
    ├── quarto-multiformat-compatibility/
    │   ├── SKILL.md
    │   ├── agents/
    │   │   └── openai.yaml
    │   └── references/
    │
    ├── quarto-report-design/
    │   ├── SKILL.md
    │   ├── agents/
    │   │   └── openai.yaml
    │   └── references/
    │
    ├── quarto-computation-performance/
    │   ├── SKILL.md
    │   ├── agents/
    │   │   └── openai.yaml
    │   └── references/
    │
    ├── quarto-rmarkdown-migration/
    │   ├── SKILL.md
    │   ├── agents/
    │   │   └── openai.yaml
    │   └── references/
    │
    ├── quarto-publishing-deployment/
    │   ├── SKILL.md
    │   ├── agents/
    │   │   └── openai.yaml
    │   └── references/
    │
    ├── quarto-accessibility-quality/
    │   ├── SKILL.md
    │   ├── agents/
    │   │   └── openai.yaml
    │   └── references/
    │
    └── quarto-render-troubleshooting/
        ├── SKILL.md
        ├── agents/
        │   └── openai.yaml
        └── references/
```

## Future Candidate Skills

These should not be part of the initial target architecture unless the plugin becomes large enough to justify them.

Possible future skills:

* `quarto-branding-theming`
* `quarto-extensions-customization`
* `quarto-template-authoring`
* `quarto-ci-cd`
* `quarto-website-navigation`
* `quarto-academic-manuscripts`
* `quarto-slide-decks`
* `quarto-pdf-production`

These should remain references at first unless they develop independent activation patterns.

## Target Skill Summary

The target architecture should treat `quarto-publishing` as a complete publishing workflow plugin, not only as a Quarto syntax helper.

The core skills should be:

1. `quarto-authoring-core`
2. `quarto-project-configuration`
3. `quarto-format-configuration`
4. `quarto-multiformat-compatibility`
5. `quarto-report-design`
6. `quarto-computation-performance`
7. `quarto-rmarkdown-migration`
8. `quarto-publishing-deployment`
9. `quarto-accessibility-quality`
10. `quarto-render-troubleshooting`

This architecture is broad enough to cover the mature scope of the plugin, while still allowing early versions to implement only the most essential skills and keep advanced topics as references until they justify becoming independent skills.
