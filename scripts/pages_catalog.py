#!/usr/bin/env python3
"""Generate the category/program metadata and assets for the GitHub Pages launcher."""
import argparse
from html import escape
import json
from pathlib import Path
import shutil

ROOT = Path(__file__).resolve().parents[1]


def markdown_to_html(markdown):
    """Render the project's compact README subset without another dependency."""
    lines = markdown.strip().splitlines()
    rendered = []
    paragraph = []

    def flush_paragraph():
        if paragraph:
            rendered.append(f"<p>{escape(' '.join(part.strip() for part in paragraph))}</p>")
            paragraph.clear()

    for line in lines:
        if line.startswith("# "):
            flush_paragraph()
            rendered.append(f"<h1>{escape(line[2:].strip())}</h1>")
        elif line.startswith("## "):
            flush_paragraph()
            rendered.append(f"<h2>{escape(line[3:].strip())}</h2>")
        elif not line.strip():
            flush_paragraph()
        else:
            paragraph.append(line)
    flush_paragraph()
    return "\n".join(rendered) or "<p>No project README is available.</p>"


def write_program_assets(folder, asset_folder, description):
    """Copy preview assets and convert the program README into a Pages fragment."""
    asset_folder.mkdir(parents=True, exist_ok=True)
    icon_source = folder / "icon-preview.gif"
    if not icon_source.is_file():
        icon_source = folder / "icon.png"
    screenshot_source = folder / "icon-preview.gif"
    if not screenshot_source.is_file():
        screenshot_source = folder / "preview.png"
    if not screenshot_source.is_file():
        screenshot_source = icon_source
    if icon_source.is_file():
        shutil.copy2(icon_source, asset_folder / icon_source.name)
    if screenshot_source.is_file():
        shutil.copy2(screenshot_source, asset_folder / screenshot_source.name)
    readme_path = folder / "README.md"
    if not readme_path.is_file():
        readme_path = folder / "readme.md"
    readme = readme_path.read_text() if readme_path.is_file() else description
    (asset_folder / "README.html").write_text(markdown_to_html(readme) + "\n")
    return {
        "icon": f"assets/{folder.parent.name}/{folder.name}/{icon_source.name}",
        "screenshot": f"assets/{folder.parent.name}/{folder.name}/{screenshot_source.name}",
        "readme": f"assets/{folder.parent.name}/{folder.name}/README.html",
    }


def build_catalog(root=ROOT, output=None):
    """Write ordered category and standalone-PRG metadata for the Pages UI."""
    root = Path(root)
    output = Path(output) if output else root / "site" / "catalog.json"
    entries = []
    for metadata_path in (root / "programs").glob("*/category.json"):
        metadata = json.loads(metadata_path.read_text())
        entries.append((metadata["order"], metadata_path.parent, metadata))
    entries.sort(key=lambda entry: entry[0])
    categories = [
        {"name": folder.name.upper(), "description": metadata["description"], "count": 0}
        for _, folder, metadata in entries
    ]
    category_names = [category["name"] for category in categories]
    manifest = json.loads((root / "build" / "manifest.json").read_text())
    programs = []
    for record in manifest["programs"]:
        category = category_names[record["category"]]
        folder = root / "programs" / category / record["name"]
        metadata = json.loads((folder / "program.json").read_text())
        assets = write_program_assets(
            folder,
            output.parent / "assets" / category / record["name"],
            metadata["description"],
        )
        programs.append({
            "name": record["name"],
            "category": category,
            "description": metadata["description"],
            "bytes": record["size"],
            "prg": f"programs/{category}/{record['name']}/{record['name']}.PRG",
            **assets,
        })
    programs.sort(key=lambda program: (category_names.index(program["category"]), program["name"]))
    for category in categories:
        category["count"] = sum(program["category"] == category["name"] for program in programs)
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps({"categories": categories, "programs": programs}, indent=2) + "\n")
    return output


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=ROOT)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    print(build_catalog(args.root, args.output))


if __name__ == "__main__":
    main()
