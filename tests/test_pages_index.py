"""Static GitHub Pages emulator UI contract."""
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PAGES = ROOT / "pages"


class PagesIndexTests(unittest.TestCase):
    def test_pages_index_exposes_disk_and_program_emulator_controls(self):
        page = (PAGES / "index.html").read_text()
        script = (PAGES / "index.js").read_text()
        self.assertIn('id="launch-disk"', page)
        self.assertIn('id="category-list"', page)
        self.assertIn('id="program-list"', page)
        self.assertIn('src="index.js"', page)
        self.assertIn('fetch("catalog.json")', script)
        self.assertIn('ty64Tab.postMessage', script)
        self.assertIn('sector-256.d64', page + script)
        self.assertIn('new URL(TY64_URL).origin', script)
        self.assertNotIn('postMessage(arrayOfBytes, "*")', script)
        self.assertNotIn('button.innerHTML', script)


if __name__ == "__main__":
    unittest.main()
