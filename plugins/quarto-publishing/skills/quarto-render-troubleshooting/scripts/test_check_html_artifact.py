#!/usr/bin/env python3
"""Tests for check_html_artifact.py."""

from __future__ import annotations

import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path


CHECKER = Path(__file__).with_name("check_html_artifact.py")


class CheckHtmlArtifactTests(unittest.TestCase):
    def run_checker(self, html: str, assets: dict[str, str] | None = None):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            artifact = root / "report.html"
            artifact.write_text(html, encoding="utf-8")
            for relative, content in (assets or {}).items():
                target = root / relative
                target.parent.mkdir(parents=True, exist_ok=True)
                target.write_text(content, encoding="utf-8")
            process = subprocess.run(
                [sys.executable, str(CHECKER), str(artifact)],
                check=False,
                capture_output=True,
                text=True,
            )
            return process.returncode, json.loads(process.stdout)

    def test_definite_errors_and_encoded_fragment(self):
        html = """<!doctype html><html><head>
        <link rel="stylesheet" href="missing.css"><script src="missing.js"></script>
        </head><body><div id="café"></div><div id="duplicate"></div>
        <div id="duplicate"></div><a href="#caf%C3%A9">encoded target</a>
        <a href="#absent">broken</a><img src="missing.png"></body></html>"""
        code, result = self.run_checker(html)
        self.assertEqual(code, 1)
        self.assertEqual(result["status"], "definite_structural_errors_found")
        self.assertEqual(
            result["summary"]["error_type_counts"],
            {"broken_same_document_anchor": 1, "duplicate_id": 1, "missing_local_asset": 3},
        )

    def test_valid_relative_assets_and_same_file_anchor(self):
        html = """<html><head><link rel="stylesheet" href="assets/site.css"></head>
        <body id="café"><a href="report.html#caf%C3%A9">target</a>
        <img src="assets/plot.png"><script src="https://example.org/app.js"></script>
        </body></html>"""
        code, result = self.run_checker(
            html, {"assets/site.css": "body {}", "assets/plot.png": "image"}
        )
        self.assertEqual(code, 0)
        self.assertEqual(result["status"], "no_definite_structural_errors")
        self.assertEqual(result["summary"]["definite_error_count"], 0)
        self.assertIn("visual", result["unverified"])
        self.assertIn("interactive", result["unverified"])

    def test_external_base_skips_unverifiable_relative_urls(self):
        html = """<html><head><base href="https://cdn.example.org/reports/">
        <link rel="stylesheet" href="site.css"></head><body>
        <a href="#runtime-target">remote fragment</a><img src="plot.png">
        <script src="app.js"></script></body></html>"""
        code, result = self.run_checker(html)
        self.assertEqual(code, 0)
        self.assertEqual(result["summary"]["checked_local_asset_count"], 0)
        self.assertEqual(result["summary"]["definite_error_count"], 0)
        self.assertEqual(result["summary"]["skipped_asset_reference_count"], 3)

    def test_relative_base_is_used_for_local_assets(self):
        html = """<html><head><base href="bundle/"><link rel="stylesheet" href="ok.css">
        </head><body><img src="missing.png"></body></html>"""
        code, result = self.run_checker(html, {"bundle/ok.css": "body {}"})
        self.assertEqual(code, 1)
        self.assertEqual(result["summary"]["error_type_counts"], {"missing_local_asset": 1})
        self.assertEqual(result["errors"]["items"][0]["reference"], "missing.png")

    def test_intentional_html_example_is_advisory_only(self):
        html = """<html><body><pre><code>&lt;section class=&quot;example&quot;&gt;
        Tutorial markup&lt;/section&gt;</code></pre></body></html>"""
        code, result = self.run_checker(html)
        self.assertEqual(code, 0)
        self.assertEqual(result["summary"]["review_candidate_count"], 1)
        self.assertEqual(result["review_candidates"]["items"][0]["type"],
                         "escaped_html_in_code")

    def test_escaped_card_reproduction_has_bounded_preview(self):
        payload = "x" * 500 + "&lt;div class=&quot;card&quot;&gt;Escaped card&lt;/div&gt;" + "y" * 500
        code, result = self.run_checker(f"<pre class='sourceCode'><code>{payload}</code></pre>")
        candidate = result["review_candidates"]["items"][0]
        self.assertEqual(code, 0)
        self.assertIn("card", candidate["preview"])
        self.assertLessEqual(len(candidate["preview"]), 180)

    def test_browser_top_and_text_fragments_are_outside_static_errors(self):
        html = """<html><body><a href="#top">top</a>
        <a href="#:~:text=hello">text fragment</a></body></html>"""
        code, result = self.run_checker(html)
        self.assertEqual(code, 0)
        self.assertEqual(result["summary"]["checked_same_document_anchor_count"], 0)
        self.assertEqual(result["summary"]["skipped_anchor_reference_count"], 2)

    def test_malformed_urls_do_not_crash_or_create_definite_errors(self):
        html = """<html><body><a href="https://[invalid#target">bad link</a>
        <img src="https://[invalid"></body></html>"""
        code, result = self.run_checker(html)
        self.assertEqual(code, 0)
        self.assertEqual(result["summary"]["definite_error_count"], 0)
        self.assertEqual(result["summary"]["skipped_asset_reference_count"], 1)
        self.assertIn("malformed", result["unverified"]["asset_scope"])

    def test_encoded_null_urls_do_not_break_json_output(self):
        code, result = self.run_checker(
            '<a href="report%00.html#target">invalid path</a>'
            '<img src="image%00.png"><img src="file:///image%00.png">'
        )
        self.assertEqual(code, 0)
        self.assertEqual(result["summary"]["checked_local_asset_count"], 0)
        self.assertEqual(result["summary"]["skipped_asset_reference_count"], 2)
        self.assertEqual(result["summary"]["skipped_anchor_reference_count"], 1)

    def test_invalid_input_has_distinct_exit_code_and_json(self):
        process = subprocess.run(
            [sys.executable, str(CHECKER), "/definitely/not/a/report.html"],
            check=False,
            capture_output=True,
            text=True,
        )
        self.assertEqual(process.returncode, 2)
        self.assertEqual(json.loads(process.stdout)["status"], "input_error")


if __name__ == "__main__":
    unittest.main()
