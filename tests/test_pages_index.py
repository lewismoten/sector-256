"""Static GitHub Pages emulator UI contract."""
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PAGES = ROOT / "pages"


class PagesIndexTests(unittest.TestCase):
    def test_pages_index_explains_disk_download_and_links_to_ty64(self):
        page = (PAGES / "index.html").read_text()
        script = (PAGES / "index.js").read_text()
        self.assertIn('href="sector-256.d64"', page)
        self.assertIn('id="inspect-disk"', page)
        self.assertIn('Inspect Disk', page)
        self.assertIn('STORAGE_D64_URL', script)
        self.assertIn('storage-d64:ready', script)
        self.assertIn('storage-d64:load', script)
        self.assertIn('new URL(STORAGE_D64_URL).origin', script)
        self.assertIn('id="disk-help"', page)
        self.assertIn('id="disk-instructions-dialog"', page)
        self.assertNotIn('id="disk-instructions"', page)
        self.assertIn('id="repository-footer"', page)
        self.assertIn('Github: ', page)
        self.assertIn('id="category-list"', page)
        self.assertIn('Open URL', page)
        self.assertNotIn('id="launch-disk"', page)
        self.assertNotIn('sendToTy64("sector-256.d64"', script)

    def test_pages_index_gives_each_program_run_and_download_controls(self):
        page = (PAGES / "index.html").read_text()
        script = (PAGES / "index.js").read_text()
        self.assertIn('id="program-info"', page)
        self.assertIn('id="program-screenshot"', page)
        self.assertIn('id="program-readme"', page)
        self.assertIn('id="selected-program-bytes"', page)
        self.assertIn('id="selected-program-source"', page)
        self.assertIn('https://github.com/lewismoten/sector-256', page)
        self.assertIn('selectedProgram.source', script)
        self.assertIn('className = "program-icon"', script)
        self.assertIn('description.textContent = program.description', script)
        self.assertNotIn('`${program.bytes} B`', script)
        self.assertIn('Run in TY64', script)
        self.assertIn('Download PRG', script)
        self.assertIn('download = `${program.name}.PRG`', script)
        self.assertIn('download.href = program.prg', script)

    def test_pages_index_exposes_catalog_and_safe_ty64_message_controls(self):
        page = (PAGES / "index.html").read_text()
        script = (PAGES / "index.js").read_text()
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
