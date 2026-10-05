"""Release build emits grouped standalone program artifacts."""
import shutil
import sys
import tempfile
import unittest
from pathlib import Path
from unittest import mock

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))
import build as builder


class ReleaseLayoutTests(unittest.TestCase):
    def test_build_requests_grouped_standalones_under_release_programs(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory) / "repo"
            shutil.copytree(ROOT, root, ignore=shutil.ignore_patterns("build", "release", ".git", ".venv", "__pycache__"))
            with mock.patch.object(builder, "build_standalones") as standalone_builder:
                builder.build(root=root)

            standalone_builder.assert_called_once_with(
                root / "release" / "programs",
                root=root,
                group_by_category=True,
            )


if __name__ == "__main__":
    unittest.main()
