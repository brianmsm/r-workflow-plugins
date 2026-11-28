# R Analytic Core Roadmap

Read with [architecture.md](architecture.md) for the scope and [pilot findings](pilot-findings.md) for historical validation.

## Current Scope

One skill covers locally editable analytical R code, classroom scripts, package conflicts and proportionate verification. Keep researcher-modifiable decisions visible at the point of use, preserve substantive intermediate objects and outputs, and favor native or established package reporting. The [changelog](../CHANGELOG.md) records release changes.

## Scoped Maintenance

Fix observed activation errors, unnecessary abstraction, package namespace inconsistencies, misplaced diagnostics, and false claims of verification. Prefer corrections to `SKILL.md` and its existing references over new scripts/skills. Summarize reusable, non-sensitive findings in the plugin docs; keep raw case data local.

## Conditional Specialized Skills

After varied real trials, decide whether independent repeated tasks justify extracting any candidates named in [architecture.md](architecture.md). Split only with clear triggers and fewer routing ambiguities. Avoid creating a generic router just because the number of references grows.

## Optional External Quality Tools

Consider standalone read-only consistency checks only if actual cases recur: mismatched repeated specifications, mislabeled model sections, output references to wrong objects, or join cardinality drift. Evaluate false positives, costs and the need for intentional exceptions. Hooks/CI are optional consumer integrations, **not** a dependency of this plugin; never add them to user projects unrequested.

## Verification and Distribution

Use the [validation scenarios](validation-cases.md) to test affected behavior in fresh sessions when practical. Check actual skill loading, preservation of analytical meaning and researcher editability, and the match between verification claims and executed checks. Include a negative or composition case where a change affects routing. The first release's scoped behavioral validation and the later updates' evidence are documented separately in the pilot findings and changelog.

The plugin follows the repository's independent version/tag process. The marketplace source pin determines the installed release.
