import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
PROGRAM = ROOT / 'programs' / 'ARCADE' / 'STACKER'


class StackerProgramTests(unittest.TestCase):
    def test_stacker_program_metadata_and_source_exist(self):
        self.assertTrue(PROGRAM.is_dir())
        metadata = json.loads((PROGRAM / 'program.json').read_text())
        self.assertIn('description', metadata)
        self.assertTrue((PROGRAM / 'main.asm').is_file())
        self.assertTrue((PROGRAM / 'README.md').is_file())
        self.assertTrue((PROGRAM / 'icon.png').is_file())


if __name__ == '__main__':
    unittest.main()
