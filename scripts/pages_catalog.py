#!/usr/bin/env python3
"""Generate the category/program metadata consumed by the GitHub Pages launcher."""
import argparse
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


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
        {
            "name": folder.name.upper(),
            "description": metadata["description"],
            "count": 0,
        }
        for _, folder, metadata in entries
    ]
    category_names = [category["name"] for category in categories]
    manifest = json.loads((root / "build" / "manifest.json").read_text())
    programs = []
    for record in manifest["programs"]:
        category = category_names[record["category"]]
        folder = root / "programs" / category / record["name"]
        metadata = json.loads((folder / "program.json").read_text())
        programs.append({
            "name": record["name"],
            "category": category,
            "description": metadata["description"],
            "bytes": record["size"],
            "prg": f"programs/{category}/{record['name']}/{record['name']}.PRG",
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
