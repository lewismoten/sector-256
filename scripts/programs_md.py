#!/usr/bin/env python3
"""Regenerate programs/readme.md from program metadata and optional preview.png files."""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def generate(root=ROOT):
    root = Path(root)
    manifest = root / "build" / "manifest.json"
    sizes = {p["name"]: p["size"] for p in json.loads(manifest.read_text())["programs"]} if manifest.exists() else {}
    lines = [
        "# Sector 256 programs", 
        "", 
        "Every program here runs from the [Sector 256](../README.md) ",
        "Commodore 64 launcher, and each one's stored payload fits in ",
        "**256 bytes or less**. That's one disk block. Press RUN/STOP ",
        "in any program to return to the launcher.",
        ""
        ]
    for folder in sorted((root / "programs").iterdir(), key=lambda p: p.name.upper()):
        if not folder.is_dir():
            continue
        data = json.loads((folder / "program.json").read_text())
        name = folder.name.upper()
        lines += [f"## {name}", "", data["description"], "",
                  f"Category: {data['category']}. " + (f"Stored payload: **{sizes[name]} bytes**." if name in sizes else "Build to calculate size."), "",
                  f"[Assembly source]({folder.name}/main.asm)", ""]
        if (folder / "preview.png").exists():
            lines += [f"![{name} preview]({folder.name}/preview.png)", ""]
    lines += [
        "---",
        "**7 programs · 1,685 bytes total · 107 bytes to spare across ",
        "the whole set**",
        "",
        "Want to add one? See [Add a program](../docs/add_program.md) ",
        "and the [program interface](../docs/program-api.md). ",
        "The build rejects any payload over 256 bytes.",
        "",
        "Regenerate this page with `python scripts/programs_md.py`.",
        ]
    (root / "programs/readme.md").write_text("\n".join(lines))
    readme = root / "readme.md"
    if readme.exists() and "(programs/readme.md)" not in readme.read_text():
        readme.write_text(readme.read_text() + "\n[Browse the programs](programs/readme.md).\n")


if __name__ == "__main__":
    generate()
