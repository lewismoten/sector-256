import json
import unittest
from pathlib import Path

from PIL import Image


ROOT = Path(__file__).resolve().parents[1]
PROGRAM = ROOT / "programs" / "TOOLS" / "DISKFREE"


class DiskfreeProgramTests(unittest.TestCase):
    def test_program_files_and_metadata_are_complete(self):
        self.assertTrue(PROGRAM.is_dir())
        for name in ("main.asm", "program.json", "readme.md", "icon.png", "preview.png"):
            self.assertTrue((PROGRAM / name).is_file(), name)

        metadata = json.loads((PROGRAM / "program.json").read_text())
        self.assertEqual(metadata, {
            "description": "DISPLAY FREE BLOCKS ON DEVICE 8. ANY KEY:REFRESH. STOP:RETURN.",
            "animation_speed": 8,
        })

        source = (PROGRAM / "main.asm").read_text()
        self.assertIn('.include "api.inc"', source)
        self.assertIn("*=$c000", source)
        self.assertIn("WAITKEY", source)

        readme = (PROGRAM / "readme.md").read_text()
        self.assertIn("any key", readme.lower())
        self.assertIn("run/stop", readme.lower())

        with Image.open(PROGRAM / "icon.png") as icon:
            self.assertEqual(icon.size, (16, 16))
            self.assertEqual(icon.mode, "RGB")

        with Image.open(PROGRAM / "preview.png") as preview:
            self.assertGreater(preview.size[0], 16)
            self.assertGreater(preview.size[1], 16)


if __name__ == "__main__":
    unittest.main()
