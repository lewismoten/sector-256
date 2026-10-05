import json
import sys
import tempfile
import unittest
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'scripts'))
from build import assemble, encode_icon

VISUALS = ROOT / 'programs' / 'VISUALS'
NEW_VISUALS = {'BOUNCER', 'CLOUDS', 'COMET', 'FADE', 'RAINDROP', 'SPIRAL', 'STARFLD'}


class VisualExpansionTests(unittest.TestCase):
    def test_requested_live_visuals_have_complete_compact_assets(self):
        self.assertEqual(
            {path.name for path in VISUALS.iterdir() if path.is_dir()} & NEW_VISUALS,
            NEW_VISUALS,
        )
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory)
            for name in NEW_VISUALS:
                folder = VISUALS / name
                source = (folder / 'main.asm').read_text()
                metadata = json.loads((folder / 'program.json').read_text())
                self.assertIn('.include "api.inc"', source)
                self.assertEqual(source.count('jsr POLLKEY'), 1, name)
                self.assertLessEqual(len(metadata['description']), 64)
                self.assertTrue((folder / 'readme.md').is_file())
                with Image.open(folder / 'preview.png') as preview:
                    self.assertEqual(preview.size, (320, 200))
                encode_icon(folder / 'icon.png')
                address, payload = assemble('64tass', folder / 'main.asm', output / f'{name}.prg')
                self.assertEqual(address, 0xc000)
                self.assertLessEqual(len(payload), 256, name)


if __name__ == '__main__':
    unittest.main()
