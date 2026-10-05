"""Acceptance coverage for the eleven requested STUDY programs."""
from pathlib import Path
import unittest


ROOT = Path(__file__).resolve().parents[1]
STUDY = ROOT / "programs" / "STUDY"
PROGRAMS = {
    "ANGLES": "ESTIMATE THE ANGLE",
    "CLOCKQZ": "READ THE ANALOG CLOCK",
    "INTERVAL": "IDENTIFY MUSICAL INTERVALS",
    "MONEY": "COUNT COINS",
    "MORSEQZ": "MORSE LETTER",
    "NOTEREAD": "NAME THE NOTE",
    "OPCODES": "6502 OPCODE",
    "PIANOQZ": "NAME THE NOTE YOU HEAR",
    "RHYTHM": "TAP BACK",
    "TYPETUT": "HOME-ROW",
    "CALENDAR": "MONTH CALENDAR",
}


class StudyExpansionTests(unittest.TestCase):
    def test_requested_study_programs_have_complete_program_assets(self):
        for name, lesson in PROGRAMS.items():
            with self.subTest(name=name):
                folder = STUDY / name
                self.assertTrue(folder.is_dir())
                for filename in ("main.asm", "program.json", "readme.md", "icon.png", "preview.png"):
                    self.assertTrue((folder / filename).is_file(), filename)
                source = (folder / "main.asm").read_text()
                self.assertIn('.include "api.inc"', source)
                self.assertIn('*=$c000', source.replace(' ', ''))
                self.assertIn(lesson, (folder / "program.json").read_text().upper())


if __name__ == "__main__":
    unittest.main()
