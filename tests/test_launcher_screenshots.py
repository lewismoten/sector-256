"""Native launcher screenshots composite graphical icons and category labels."""
import tempfile
import unittest
from pathlib import Path

from PIL import Image

try:
    from .machine import Machine, preview_charset
except ImportError:  # unittest discovery imports tests as top-level modules
    from machine import Machine, preview_charset


class LauncherScreenshotTests(unittest.TestCase):
    def test_category_list_renders_labels_at_native_c64_dimensions(self):
        machine = Machine()
        machine.boot()
        machine.memory[0x5800:0x6000] = preview_charset()
        machine.call("draw_page")
        with tempfile.TemporaryDirectory() as directory:
            category_list = Path(directory) / "categories.png"
            machine.screenshot(category_list)
            with Image.open(category_list) as image:
                self.assertEqual(image.size, (320, 200))
                # The first category name is drawn on row 6, below its icon.
                self.assertTrue(any(
                    image.getpixel((x, y)) != (0, 0, 0)
                    for y in range(48, 56) for x in range(8, 72)
                ))


if __name__ == "__main__":
    unittest.main()
