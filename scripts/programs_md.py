#!/usr/bin/env python3
"""Regenerate programs/readme.md from program metadata and preview artwork."""
import json
from pathlib import Path
from icon_previews import generate_icon_previews

ROOT = Path(__file__).resolve().parents[1]


def generate(root=ROOT):
    root = Path(root)
    generate_icon_previews(root / "programs")
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
    categories = json.loads((root / "categories.json").read_text())
    category_names = {category["name"].upper() for category in categories}
    folders = sorted((path.parent for path in (root / "programs").glob("*/*/program.json")
                      if path.parent.parent.name.upper() in category_names),
                     key=lambda path: path.name.upper())
    for folder in folders:
        name = folder.name.upper()
        relative = folder.relative_to(root / "programs").as_posix()
        icon = "icon-preview.gif" if (folder / "icon-preview.gif").exists() else "icon.png"
        lines += [f"* ![{name}]({relative}/{icon}) [{name}](#{name.lower()})"]
    lines += ["---"]
    for folder in folders:
        data = json.loads((folder / "program.json").read_text())
        name = folder.name.upper()
        category = folder.parent.name.upper()
        relative = folder.relative_to(root / "programs").as_posix()
        preview = "preview.gif" if (folder / "preview.gif").exists() else "preview.png"
        lines += [f"## {name}", "", data["description"], "",
                  f"Category: {category}. " + (f"Stored payload: **{sizes[name]} bytes**." if name in sizes else "Build to calculate size."), "",
                  f"[Assembly source]({relative}/main.asm)", ""]
        if (folder / preview).exists():
            lines += [f"![{name} preview]({relative}/{preview})", ""]
    total = sum(sizes.get(folder.name.upper(), 0) for folder in folders)
    summary = (f"**{len(folders)} programs · {total:,} bytes total · "
               f"{len(folders) * 256 - total} bytes to spare across the whole set**"
               if all(folder.name.upper() in sizes for folder in folders)
               else "**Build to calculate total size and spare bytes across the whole set**")
    lines += [
        "---",
        summary,
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
