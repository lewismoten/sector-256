"""Focused acceptance checks for the new PATTERNS programs."""
import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PATTERNS = ROOT / "programs" / "PATTERNS"
EXPECTED = {"DRAGON", "PLOTFN", "TIMESTBL", "JULIA"}


class PatternExpansionTests(unittest.TestCase):
    def test_requested_programs_have_complete_launcher_assets(self):
        for name in EXPECTED:
            with self.subTest(name=name):
                folder = PATTERNS / name
                self.assertTrue(folder.is_dir())
                self.assertTrue((folder / "main.asm").is_file())
                self.assertTrue((folder / "readme.md").is_file())
                self.assertTrue((folder / "icon.png").is_file())
                self.assertTrue((folder / "preview.png").is_file())
                metadata = json.loads((folder / "program.json").read_text())
                self.assertIn("description", metadata)
                source = (folder / "main.asm").read_text()
                self.assertIn("*=$c000", source.replace(" ", ""))
                self.assertTrue("jsr POLLKEY" in source or "jsr WAITKEY" in source)


if __name__ == "__main__":
    unittest.main()
