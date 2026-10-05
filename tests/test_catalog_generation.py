import json
import shutil
import sys
import tempfile
import unittest
from unittest import mock
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))

from programs_md import generate
from render_launcher_screenshots import render
import build as builder


class CatalogGenerationTests(unittest.TestCase):
    def test_catalog_updates_root_total_and_omits_spare_byte_claims(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "programs" / "TOOLS" / "ALPHA").mkdir(parents=True)
            (root / "programs" / "TOOLS" / "BETA").mkdir()
            (root / "programs" / "TOOLS" / "category.json").write_text(
                json.dumps({"description": "TOOLS.", "order": 0}))
            for name in ("ALPHA", "BETA"):
                folder = root / "programs" / "TOOLS" / name
                (folder / "program.json").write_text(json.dumps({"description": f"{name}."}))
                (folder / "main.asm").write_text("; source\n")
            (root / "build").mkdir()
            (root / "build" / "manifest.json").write_text(json.dumps({"programs": [
                {"name": "ALPHA", "size": 7}, {"name": "BETA", "size": 8}
            ]}))
            (root / "README.md").write_text(
                "# Demo\n\n<!-- program-count: 0 -->\nThe catalog contains **0 programs**.\n")

            generate(root)

            root_readme = (root / "README.md").read_text()
            catalog = (root / "programs" / "readme.md").read_text()
            category = (root / "programs" / "TOOLS" / "readme.md").read_text()
            self.assertIn("<!-- program-count: 2 -->", root_readme)
            self.assertIn("The catalog contains **2 programs**.", root_readme)
            self.assertNotIn("bytes to spare", catalog + category)
            self.assertIn("2 programs · 15 bytes total", catalog)
            self.assertIn("Stored payload: **7 bytes**.", category)

    def test_normal_build_preserves_existing_animated_gif_previews(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory) / "repo"
            shutil.copytree(ROOT, root, ignore=shutil.ignore_patterns("build", "release", ".git", ".venv", "__pycache__"))
            preview = root / "programs/SHOWS/CUBE3D/icon-preview.gif"
            before = b"user-owned-preview-bytes"
            preview.write_bytes(before)
            with mock.patch.object(builder, "build_standalones", return_value={}):
                builder.build(root=root)
            self.assertEqual(preview.read_bytes(), before)

    def test_renderer_writes_native_machine_harness_screenshots(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory)
            render(ROOT, output)
            for filename in ("categories.png", "launcher.png"):
                with Image.open(output / filename) as image:
                    self.assertEqual(image.size, (320, 200))


if __name__ == "__main__":
    unittest.main()
