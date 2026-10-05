import json
import subprocess
import tempfile
import unittest
from pathlib import Path

from PIL import Image


ROOT = Path(__file__).resolve().parents[1]
PLAY = ROOT / 'programs' / 'PLAY'


class PlayExpansionTests(unittest.TestCase):
    EXPECTED = {
        'TWENTY1': ('COUNT TO 21', '1-3', 'CPU'),
        'ROULETTE': ('ROULETTE', 'BET', 'RED'),
        'SQUASH': ('SQUASH', 'A/D', 'WALL'),
    }

    def test_new_play_programs_are_compact_runnable_and_described(self):
        for name, phrases in self.EXPECTED.items():
            folder = PLAY / name
            source = folder / 'main.asm'
            metadata = folder / 'program.json'
            icon = folder / 'icon.png'
            readme = folder / 'readme.md'

            self.assertTrue(source.is_file(), name)
            self.assertTrue(metadata.is_file(), name)
            self.assertTrue(icon.is_file(), name)
            self.assertTrue(readme.is_file(), name)
            text = source.read_text()
            self.assertIn('.include "api.inc"', text)
            self.assertIn('* = $c000', text)
            self.assertTrue('WAITKEY' in text or 'POLLKEY' in text)
            for phrase in phrases:
                self.assertIn(phrase, text)

            data = json.loads(metadata.read_text())
            self.assertIn('description', data)
            self.assertLessEqual(len(data['description'].encode('ascii')), 64)
            self.assertEqual(data['description'], data['description'].upper())

            with Image.open(icon) as image:
                self.assertEqual(image.size, (16, 16))
                self.assertNotIn('A', image.getbands())

            with tempfile.TemporaryDirectory() as directory:
                output = Path(directory) / f'{name}.prg'
                subprocess.run(
                    ['64tass', '--m6502', '--case-sensitive', '--long-branch',
                     '--cbm-prg', '-I', str(ROOT / 'src'), '-o', str(output),
                     str(source)],
                    check=True, capture_output=True, text=True,
                )
                payload = output.read_bytes()[2:]
                self.assertLessEqual(len(payload), 256, name)


if __name__ == '__main__':
    unittest.main()
