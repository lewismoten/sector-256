"""GitHub Pages catalog-data generation tests."""
import json
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))

from pages_catalog import build_catalog  # noqa: E402


class PagesCatalogTests(unittest.TestCase):
    def test_catalog_contains_category_navigation_and_standalone_prg_paths(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "programs" / "TOOLS" / "ALPHA").mkdir(parents=True)
            (root / "programs" / "PLAY" / "BETA").mkdir(parents=True)
            (root / "programs" / "TOOLS" / "category.json").write_text(json.dumps({
                "description": "TOOLS.", "order": 1,
            }))
            (root / "programs" / "PLAY" / "category.json").write_text(json.dumps({
                "description": "PLAY.", "order": 0,
            }))
            (root / "programs" / "TOOLS" / "ALPHA" / "program.json").write_text(json.dumps({
                "description": "AN ALPHA TOOL.",
            }))
            (root / "programs" / "PLAY" / "BETA" / "program.json").write_text(json.dumps({
                "description": "A BETA GAME.",
            }))
            (root / "build").mkdir()
            (root / "build" / "manifest.json").write_text(json.dumps({"programs": [
                {"name": "ALPHA", "size": 12, "category": 1},
                {"name": "BETA", "size": 34, "category": 0},
            ]}))
            output = root / "site" / "catalog.json"

            build_catalog(root, output)

            catalog = json.loads(output.read_text())
            self.assertEqual([item["name"] for item in catalog["categories"]], ["PLAY", "TOOLS"])
            self.assertEqual(catalog["categories"][1]["count"], 1)
            alpha = next(item for item in catalog["programs"] if item["name"] == "ALPHA")
            self.assertEqual(alpha["prg"], "programs/TOOLS/ALPHA/ALPHA.PRG")
            self.assertEqual(alpha["bytes"], 12)


if __name__ == "__main__":
    unittest.main()
