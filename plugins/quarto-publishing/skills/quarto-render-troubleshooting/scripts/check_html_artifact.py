#!/usr/bin/env python3
"""Read-only structural checks for one local rendered HTML artifact."""

from __future__ import annotations

import json
import re
import sys
from collections import Counter
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import unquote, urljoin, urlsplit


MAX_ITEMS = 25
MAX_PREVIEW = 180
HTML_IN_CODE = re.compile(r"<\s*/?\s*[A-Za-z][^>]{0,240}>")


def preview(value: object) -> str:
    text = " ".join(str(value).split())
    return text if len(text) <= MAX_PREVIEW else text[: MAX_PREVIEW - 1] + "…"


def split_url(value: str):
    try:
        return urlsplit(value)
    except ValueError:
        return None


class ArtifactParser(HTMLParser):
    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)
        self.ids: dict[str, list[int]] = {}
        self.targets: set[str] = set()
        self.anchor_refs: list[tuple[int, str]] = []
        self.asset_refs: list[tuple[int, str, str]] = []
        self.base_href: str | None = None
        self.code_depth = 0
        self.code_line = 0
        self.code_tail = ""
        self.code_match: str | None = None
        self.review_candidates: list[dict[str, object]] = []
        self.review_count = 0

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        tag = tag.lower()
        values = {name.lower(): value for name, value in attrs}
        line = self.getpos()[0]
        if tag == "code":
            if self.code_depth == 0:
                self.code_line, self.code_tail, self.code_match = line, "", None
            self.code_depth += 1
        identifier = values.get("id")
        if identifier is not None:
            self.ids.setdefault(identifier, []).append(line)
            self.targets.add(identifier)
        if tag == "a" and values.get("name") is not None:
            self.targets.add(values["name"] or "")
        if tag == "base" and self.base_href is None and values.get("href"):
            self.base_href = values["href"]
        if tag in {"a", "area"} and values.get("href"):
            self.anchor_refs.append((line, values["href"] or ""))
        if tag == "img" and values.get("src"):
            self.asset_refs.append((line, "image", values["src"] or ""))
        elif tag == "script" and values.get("src"):
            self.asset_refs.append((line, "script", values["src"] or ""))
        elif tag == "link" and values.get("href"):
            rel = (values.get("rel") or "").lower().split()
            if "stylesheet" in rel:
                self.asset_refs.append((line, "stylesheet", values["href"] or ""))

    def handle_data(self, data: str) -> None:
        if not self.code_depth or self.code_match is not None:
            return
        combined = self.code_tail + data
        match = HTML_IN_CODE.search(combined)
        if match:
            start, end = max(0, match.start() - 50), min(len(combined), match.end() + 80)
            self.code_match = preview(combined[start:end])
        self.code_tail = combined[-260:]

    def handle_endtag(self, tag: str) -> None:
        if tag.lower() == "code" and self.code_depth:
            self.code_depth -= 1
            if self.code_depth == 0:
                self._finish_code()

    def finish(self) -> None:
        if self.code_depth:
            self._finish_code()
            self.code_depth = 0

    def _finish_code(self) -> None:
        if self.code_match is None:
            return
        self.review_count += 1
        if len(self.review_candidates) < MAX_ITEMS:
            self.review_candidates.append(
                {
                    "type": "escaped_html_in_code",
                    "line": self.code_line,
                    "preview": self.code_match,
                    "advisory": "Review whether the rendered code block is intentional.",
                }
            )


def base_uri(artifact: Path, base_href: str | None) -> str | None:
    if not base_href:
        return artifact.as_uri()
    parsed = split_url(base_href.strip())
    if parsed is None or base_href.startswith("//") or (not parsed.scheme and parsed.path.startswith("/")):
        return None
    try:
        return urljoin(artifact.as_uri(), base_href)
    except ValueError:
        return None


def local_target(raw: str, artifact: Path, resolved_base: str | None) -> Path | None:
    raw = raw.strip()
    parsed = split_url(raw)
    if parsed is None or not raw or raw.startswith("//"):
        return None
    if parsed.scheme and parsed.scheme.lower() != "file":
        return None
    if not parsed.scheme and parsed.path.startswith("/"):
        return None
    if parsed.scheme.lower() == "file":
        path = unquote(parsed.path)
        return None if parsed.netloc not in {"", "localhost"} or "\0" in path else Path(path)
    if resolved_base is None:
        return None
    try:
        resolved = urlsplit(urljoin(resolved_base, raw))
    except ValueError:
        return None
    if resolved.scheme != "file" or resolved.netloc not in {"", "localhost"}:
        return None
    path = unquote(resolved.path)
    return None if "\0" in path else Path(path)


def same_document_fragment(raw: str, artifact: Path, resolved_base: str | None) -> str | None:
    parsed = split_url(raw)
    if parsed is None or not parsed.fragment:
        return None
    decoded = unquote(parsed.fragment)
    if decoded.lower() == "top" or ":~:text=" in decoded:
        return None
    target = local_target(raw, artifact, resolved_base)
    if target is None or target.resolve() != artifact.resolve():
        return None
    return decoded


def inspect(artifact: Path) -> dict[str, object]:
    parser = ArtifactParser()
    parser.feed(artifact.read_text(encoding="utf-8", errors="replace"))
    parser.close()
    parser.finish()
    resolved_base = base_uri(artifact, parser.base_href)
    errors: list[dict[str, object]] = []
    counts: Counter[str] = Counter()

    def add_error(issue: dict[str, object]) -> None:
        counts[str(issue["type"])] += 1
        if len(errors) < MAX_ITEMS:
            errors.append(issue)

    for identifier, lines in parser.ids.items():
        if len(lines) > 1:
            add_error({"type": "duplicate_id", "id": preview(identifier),
                       "occurrences": len(lines), "lines": lines[:5]})
    checked_anchors = 0
    for line, href in parser.anchor_refs:
        fragment = same_document_fragment(href, artifact, resolved_base)
        if fragment is None:
            continue
        checked_anchors += 1
        if fragment not in parser.targets:
            add_error({"type": "broken_same_document_anchor", "line": line,
                       "href": preview(href), "fragment": preview(fragment)})
    checked_assets = 0
    for line, kind, reference in parser.asset_refs:
        target = local_target(reference, artifact, resolved_base)
        if target is None:
            continue
        checked_assets += 1
        if not target.is_file():
            add_error({"type": "missing_local_asset", "line": line, "asset_kind": kind,
                       "reference": preview(reference), "resolved_path": preview(target)})

    error_count = sum(counts.values())
    return {
        "artifact": str(artifact),
        "status": "definite_structural_errors_found" if error_count else "no_definite_structural_errors",
        "summary": {
            "definite_error_count": error_count,
            "error_type_counts": dict(sorted(counts.items())),
            "review_candidate_count": parser.review_count,
            "asset_reference_count": len(parser.asset_refs),
            "checked_local_asset_count": checked_assets,
            "skipped_asset_reference_count": len(parser.asset_refs) - checked_assets,
            "anchor_reference_count": len(parser.anchor_refs),
            "checked_same_document_anchor_count": checked_anchors,
            "skipped_anchor_reference_count": len(parser.anchor_refs) - checked_anchors,
        },
        "errors": {"items": errors, "omitted_count": max(0, error_count - len(errors))},
        "review_candidates": {
            "items": parser.review_candidates,
            "omitted_count": max(0, parser.review_count - len(parser.review_candidates)),
        },
        "unverified": {
            "visual": "Layout, clipping, legibility, and appearance were not inspected.",
            "interactive": "Navigation, scripts, widgets, lightboxes, and controls were not exercised.",
            "asset_scope": "Remote, root-relative, malformed, inline/data, srcset, dynamic, and CSS-contained asset URLs were not checked.",
            "anchor_scope": "External, root-relative, malformed, #top, text-fragment, and dynamically created targets were not checked.",
        },
        "exit_code": 1 if error_count else 0,
    }


def main(argv: list[str]) -> int:
    if len(argv) != 2:
        result = {"status": "input_error", "message": "Provide exactly one local HTML path.",
                  "exit_code": 2}
    else:
        artifact = Path(argv[1]).expanduser().resolve()
        if artifact.suffix.lower() not in {".html", ".htm"} or not artifact.is_file():
            result = {"artifact": str(artifact), "status": "input_error",
                      "message": "Path must be a readable local HTML file.", "exit_code": 2}
        else:
            try:
                result = inspect(artifact)
            except (OSError, UnicodeError, ValueError) as exc:
                result = {"artifact": str(artifact), "status": "input_error",
                          "message": preview(exc), "exit_code": 2}
    json.dump(result, sys.stdout, indent=2, ensure_ascii=False, sort_keys=True)
    sys.stdout.write("\n")
    return int(result["exit_code"])


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
