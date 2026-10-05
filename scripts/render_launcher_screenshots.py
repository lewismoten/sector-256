#!/usr/bin/env python3
"""Render native 320x200 launcher screenshots from the machine harness."""
import argparse
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def render(root=ROOT, output_dir=None):
    """Write the category and program launcher screens without resizing."""
    root = Path(root)
    output_dir = Path(output_dir) if output_dir else root / "docs"
    output_dir.mkdir(parents=True, exist_ok=True)
    tests = root / "tests"
    if str(tests) not in sys.path:
        sys.path.insert(0, str(tests))
    from machine import Machine, preview_charset

    machine = Machine(root)
    machine.boot()
    machine.memory[0x5800:0x6000] = preview_charset()
    machine.call("draw_page")
    machine.screenshot(output_dir / "categories.png")
    machine.key(13)
    machine.screenshot(output_dir / "launcher.png")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output-dir", type=Path,
                        help="directory for categories.png and launcher.png")
    args = parser.parse_args()
    render(output_dir=args.output_dir)


if __name__ == "__main__":
    main()
