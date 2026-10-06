"""Static GitHub Pages emulator UI contract."""
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PAGES = ROOT / "pages"


class PagesIndexTests(unittest.TestCase):
    def test_pages_index_exposes_disk_and_program_emulator_controls(self):
        page = (PAGES / "index.html").read_text()
        self.assertIn('id="launch-disk"', page)
        self.assertIn('id="category-list"', page)
        self.assertIn('id="program-list"', page)
        self.assertIn('fetch("catalog.json")', page)
        self.assertIn('ty64Tab.postMessage', page)
        self.assertIn('sector-256.d64', page)
        self.assertIn('new URL(TY64_URL).origin', page)
        self.assertNotIn('postMessage(arrayOfBytes, "*")', page)
        self.assertNotIn('button.innerHTML', page)


if __name__ == "__main__":
    unittest.main()
