#!/usr/bin/env python3
"""Regenerate the category index and per-category program catalogs."""
import json
from pathlib import Path

from icon_previews import generate_icon_previews

ROOT = Path(__file__).resolve().parents[1]


def category_summary(folders, sizes, scope):
    total = sum(sizes.get(folder.name.upper(), 0) for folder in folders)
    if all(folder.name.upper() in sizes for folder in folders):
        return (f"**{len(folders)} programs · {total:,} bytes total · "
                f"{len(folders) * 256 - total} bytes to spare {scope}**")
    return f"**Build to calculate total size and spare bytes {scope}**"


def generate_category_readme(category_folder, metadata, folders, sizes):
    category = category_folder.name.upper()
    lines = [
        f"# {category}",
        "",
        metadata["description"],
        "",
        "[All categories](../readme.md) · [Sector 256](../../README.md)",
        "",
    ]
    if len(folders) > 5:
        lines += ["| Icon | Program | Description |", "| --- | --- | --- |"]
        for folder in folders:
            data = json.loads((folder / "program.json").read_text())
            name = folder.name.upper()
            icon = "icon-preview.gif" if (folder / "icon-preview.gif").exists() else "icon.png"
            lines += [f"| ![{name}]({folder.name}/{icon}) | [{name}](#{name.lower()}) | {data['description']} |"]
    else:
        for folder in folders:
            name = folder.name.upper()
            icon = "icon-preview.gif" if (folder / "icon-preview.gif").exists() else "icon.png"
            lines += [f"* ![{name}]({folder.name}/{icon}) [{name}](#{name.lower()})"]
    lines += ["", "---", ""]
    for folder in folders:
        data = json.loads((folder / "program.json").read_text())
        name = folder.name.upper()
        preview = "preview.gif" if (folder / "preview.gif").exists() else "preview.png"
        size = (f"Stored payload: **{sizes[name]} bytes**."
                if name in sizes else "Build to calculate size.")
        lines += [
            f"## {name}",
            "",
            data["description"],
            "",
            size,
            "",
            f"[Assembly source]({folder.name}/main.asm)",
            "",
        ]
        if (folder / preview).exists():
            lines += [f"![{name} preview]({folder.name}/{preview})", ""]
    lines += [
        "---",
        category_summary(folders, sizes, "in this category"),
        "",
        "Want to add one? See [Add a program](../../docs/add_program.md)",
        "and the [program interface](../../docs/program-api.md).",
        "",
        "Regenerate this page with `python scripts/programs_md.py`.",
    ]
    (category_folder / "readme.md").write_text("\n".join(lines))


def generate(root=ROOT):
    root = Path(root)
    program_root = root / "programs"
    generate_icon_previews(program_root)
    manifest = root / "build" / "manifest.json"
    sizes = ({p["name"]: p["size"]
              for p in json.loads(manifest.read_text())["programs"]}
             if manifest.exists() else {})
    categories = []
    for path in program_root.glob("*/category.json"):
        metadata = json.loads(path.read_text())
        categories.append((metadata["order"], path.parent, metadata))
    categories.sort(key=lambda item: item[0])

    all_folders = []
    lines = [
        "# Sector 256 categories",
        "",
        "Every program here runs from the [Sector 256](../README.md)",
        "Commodore 64 launcher, and each one's stored payload fits in",
        "**256 bytes or less**. Choose a category to browse its programs.",
        "",
    ]
    for _, category_folder, metadata in categories:
        folders = sorted((path for path in category_folder.iterdir()
                          if path.is_dir() and (path / "program.json").is_file()),
                         key=lambda path: path.name.upper())
        all_folders.extend(folders)
        category = category_folder.name.upper()
        lines += [
            f"* ![{category}]({category}/icon.png) "
            f"[{category}]({category}/readme.md) — {metadata['description']} "
            f"({len(folders)} programs)"
        ]
        generate_category_readme(category_folder, metadata, folders, sizes)
    lines += [
        "",
        "---",
        category_summary(all_folders, sizes, "across the whole set"),
        "",
        "Want to add one? See [Add a program](../docs/add_program.md)",
        "and the [program interface](../docs/program-api.md).",
        "The build rejects any payload over 256 bytes.",
        "",
        "Regenerate these pages with `python scripts/programs_md.py`.",
    ]
    (program_root / "readme.md").write_text("\n".join(lines))
    readme = root / "README.md"
    if readme.exists() and "(programs/readme.md)" not in readme.read_text():
        readme.write_text(readme.read_text() + "\n[Browse the programs](programs/readme.md).\n")


if __name__ == "__main__":
    generate()
