import json
from pathlib import Path
import re
import unittest


class ProgramDescriptionTests(unittest.TestCase):
    def test_descriptions_fit_launcher_and_omit_launcher_exit_controls(self):
        for metadata_path in Path("programs").glob("*/*/program.json"):
            description = json.loads(metadata_path.read_text())["description"]
            self.assertLessEqual(
                len(description.encode("ascii")),
                64,
                metadata_path,
            )
            self.assertNotRegex(
                description,
                re.compile(r"RUN/STOP|STOP:(?:RETURN|EXIT)", re.IGNORECASE),
                metadata_path,
            )
