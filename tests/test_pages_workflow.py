"""GitHub Pages deployment workflow contract."""
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class PagesWorkflowTests(unittest.TestCase):
    def test_pages_workflow_builds_catalog_and_deploys_artifact(self):
        workflow = (ROOT / ".github" / "workflows" / "pages.yml").read_text()
        self.assertIn("actions/configure-pages@v5", workflow)
        self.assertIn("actions/upload-pages-artifact@v4", workflow)
        self.assertIn("actions/deploy-pages@v4", workflow)
        self.assertIn("pages: write", workflow)
        self.assertIn("id-token: write", workflow)
        self.assertIn("python scripts/pages_catalog.py", workflow)
        self.assertIn("release/programs", workflow)
        self.assertIn("cp pages/index.html site/index.html", workflow)


if __name__ == "__main__":
    unittest.main()
