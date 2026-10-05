#!/usr/bin/env python3
"""Compile every program, validate artwork, pack the catalog, and create a D64."""
import argparse
import json
import re
import shutil
import struct
import subprocess
from pathlib import Path
from PIL import Image
from d64 import make_disk
from standalone import build_standalones

ROOT = Path(__file__).resolve().parents[1]
PALETTE = ["000000", "ffffff", "813338", "75cec8", "8e3c97", "56ac4d", "2e2c9b", "edf171", "8e5029", "553800", "c46c71", "4a4a4a", "7b7b7b", "a9ff9f", "706deb", "b2b2b2"]
RGB = [tuple(bytes.fromhex(c)) for c in PALETTE]
RECORD_SIZE = 96
PACK_SIZE = 8192


def fixed_text(text, length, label):
    try:
        data = text.upper().encode("ascii")
    except UnicodeEncodeError as exc:
        raise ValueError(f"{label}: use printable ASCII") from exc
    if len(data) > length or any(c < 32 or c > 126 for c in data):
        raise ValueError(f"{label}: maximum {length} printable ASCII bytes")
    return data.ljust(length, b" ")


def encode_icon(path):
    image = Image.open(path).convert("RGBA")
    if image.size != (16, 16):
        raise ValueError(f"{path}: icon must be exactly 16x16")
    pixels = []
    for pixel in (image.getpixel((x, y)) for y in range(16) for x in range(16)):
        if pixel[3] != 255 or pixel[:3] not in RGB:
            raise ValueError(f"{path}: use opaque project C64 palette colors")
        pixels.append(RGB.index(pixel[:3]))
    bits, colors = bytearray(), bytearray()
    for cy, cx in ((0, 0), (0, 8), (8, 0), (8, 8)):
        cell = [pixels[y * 16 + x] for y in range(cy, cy + 8) for x in range(cx, cx + 8)]
        unique = sorted(set(cell))
        if len(unique) > 2:
            raise ValueError(f"{path}: cell ({cx // 8},{cy // 8}) has more than two colors")
        background = 0 if 0 in unique else unique[0]
        foreground = next((c for c in unique if c != background), background)
        for y in range(8):
            bits.append(sum((cell[y * 8 + x] != background) << (7 - x) for x in range(8)))
        colors.append((foreground << 4) | background)
    return bytes(bits + colors)


def collect_frames(folder, speed):
    frames = []
    missing = False
    for number in range(1, 5):
        path = folder / ("icon.png" if number == 1 else f"icon-{number}.png")
        if not path.exists():
            missing = True
        elif missing:
            raise ValueError(f"{folder}: icon frames must be contiguous, starting at icon.png")
        else:
            frames.append(encode_icon(path))
    if not frames:
        raise ValueError(f"{folder}: missing icon.png")
    if not isinstance(speed, int) or not 0 <= speed <= 63:
        raise ValueError(f"{folder}: animation_speed must be 0..63")
    return frames, ((len(frames) - 1) << 6) | speed


def record(name, description, category, flags, size, pack, offset, icon, animation):
    return (fixed_text(name, 8, "name") + fixed_text(description, 64, "description")
            + struct.pack("<BBHBHHB", category, flags, size, pack, offset, icon, animation)
            + bytes(14))


def assemble(assembler, source, output, labels=None, include=ROOT / "src"):
    command = [assembler, "--m6502", "--case-sensitive", "--long-branch", "--cbm-prg", "-I", str(include), "-o", str(output)]
    if labels:
        command += ["--labels", str(labels)]
    subprocess.run(command + [str(source)], check=True, capture_output=True, text=True)
    binary = output.read_bytes()
    return int.from_bytes(binary[:2], "little"), binary[2:]


def validate_category_count(categories):
    if not 1 <= len(categories) <= 256:
        raise ValueError("use 1..256 categories")


def build(allow_oversize=False, root=ROOT, assembler="64tass"):
    root = Path(root)
    assembler = shutil.which(assembler) or assembler
    out = root / "build"
    out.mkdir(exist_ok=True)
    program_root = root / "programs"
    category_folders = [folder for folder in program_root.iterdir() if folder.is_dir()]
    validate_category_count(category_folders)
    category_entries = []
    for folder in category_folders:
        metadata_path = folder / "category.json"
        if not metadata_path.is_file():
            raise ValueError(f"{folder}: missing category.json")
        metadata = json.loads(metadata_path.read_text())
        if "name" in metadata:
            raise ValueError(f"{folder.name}: remove name from category.json; its parent folder defines it")
        order = metadata.pop("order", None)
        if not isinstance(order, int) or isinstance(order, bool) or order < 0:
            raise ValueError(f"{folder.name}: category order must be a nonnegative integer")
        category_entries.append((order, folder, {"name": folder.name.upper(), **metadata}))
    category_entries.sort(key=lambda entry: entry[0])
    if [entry[0] for entry in category_entries] != list(range(len(category_entries))):
        raise ValueError("category order values must be unique and contiguous from zero")
    categories = [entry[2] for entry in category_entries]
    ids = {c["name"].upper(): i for i, c in enumerate(categories)}
    if len(ids) != len(categories):
        raise ValueError("category names must be unique")
    program_folders = []
    for _, category_folder, category in category_entries:
        category_name = category["name"]
        for folder in category_folder.iterdir():
            if folder.is_dir():
                if not (folder / "program.json").is_file():
                    raise ValueError(f"{folder}: missing program.json")
                program_folders.append((folder, ids[category_name]))
    program_folders.sort(key=lambda item: item[0].name.upper())
    icon_data = bytearray()
    category_frames = []
    for i, cat in enumerate(categories):
        frames, animation = collect_frames(root / "programs" / cat["name"], cat.get("animation_speed", 8))
        category_frames.append((len(icon_data) // 36, animation))
        icon_data.extend(b"".join(frames))
    programs = []
    packs = [bytearray()]
    names = set()
    for folder, category in program_folders:
        name = folder.name.upper()
        if not re.fullmatch(r"[A-Z][A-Z0-9_-]{0,7}", name) or name in names:
            raise ValueError(f"{folder.name}: unique 1..8 character name required")
        names.add(name)
        metadata = json.loads((folder / "program.json").read_text())
        if "category" in metadata:
            raise ValueError(f"{name}: remove category from program.json; its parent folder defines it")
        source = folder / "main.asm"
        address, binary = assemble(assembler, source, out / f"{name}.prg",
                                   labels=out / f"{name}.labels", include=root / "src")
        if address != 0xc000:
            raise ValueError(f"{name}: entry/load address must be $c000")
        if not binary or len(binary) > 4096:
            raise ValueError(f"{name}: supported payload range is 1..4096 bytes")
        oversize = len(binary) > 256
        if oversize and not allow_oversize:
            raise ValueError(f"{name}: {len(binary)} stored game bytes exceeds 256; use --allow-oversize to flag and include it")
        if len(packs[-1]) + len(binary) > PACK_SIZE:
            packs.append(bytearray())
        if len(packs) > 1000:
            raise ValueError("too many pack files")
        pack_id, offset = len(packs) - 1, len(packs[-1])
        if pack_id > 255:
            raise ValueError("pack ID exceeds format limit")
        packs[-1].extend(binary)
        frames, animation = collect_frames(folder, metadata.get("animation_speed", 8))
        icon = len(icon_data) // 36
        icon_data.extend(b"".join(frames))
        programs.append(dict(name=name, description=metadata["description"], category=category,
                             flags=int(oversize), size=len(binary), pack=pack_id, offset=offset,
                             icon=icon, animation=animation))
    if not programs:
        raise ValueError("no programs found")
    if len(programs) > 65535 or len(icon_data) // 36 > 65535:
        raise ValueError("catalog or icon count exceeds 16-bit limit")
    index = b"S256" + bytes((1, RECORD_SIZE)) + struct.pack("<H", len(programs))
    index += b"".join(record(**p) for p in programs)
    cat_index = b"S256" + bytes((1, RECORD_SIZE)) + struct.pack("<H", len(categories))
    for i, cat in enumerate(categories):
        icon, animation = category_frames[i]
        count = sum(p["category"] == i for p in programs)
        cat_index += record(cat["name"], cat["description"], i, 0, count, 0, 0, icon, animation)
    icons = b"SICO" + bytes((1, 36)) + struct.pack("<H", len(icon_data) // 36) + icon_data
    address, launcher = assemble(assembler, root / "src" / "launcher.asm", out / "LOADER.prg", out / "launcher.labels", include=root / "src")
    # The loader opens the category index and category icons before it needs
    # the much larger program index. Keep that startup/return-home path first
    # so the D64 allocator can place it beside track 18.
    files = [("LOADER", address.to_bytes(2, "little") + launcher, "PRG"),
             ("CATS.DAT", cat_index, "SEQ"), ("ICONS.DAT", icons, "SEQ"),
             ("INDEX.DAT", index, "SEQ")]
    for i, pack in enumerate(packs):
        filename = f"P{i:03}.DAT"
        files.append((filename, b"\x00\xa0" + pack, "PRG"))
    for filename, payload, _ in files:
        (out / filename).write_bytes(payload)
    disk = make_disk(files)
    release = root / "release"
    release.mkdir(exist_ok=True)
    (release / "sector-256.d64").write_bytes(disk)
    standalone_release = release / "programs"
    shutil.rmtree(standalone_release, ignore_errors=True)
    standalone_report = build_standalones(standalone_release, root=root, group_by_category=True)
    standalone_release.mkdir(parents=True, exist_ok=True)
    (standalone_release / "README.TXT").write_text(
        "SECTOR 256 STANDALONE PROGRAMS\n\n"
        "Each PROGRAM.PRG contains its program plus the Sector 256 API.\n"
        "Load one file and type RUN. RUN/STOP returns to BASIC.\n"
    )
    shutil.make_archive(str(release / "sector-256-programs"), "zip", release, "programs")
    (out / "sector-256.d64").unlink(missing_ok=True)
    report = dict(programs=programs, categories=categories, pack_bytes=[len(p) for p in packs],
                  launcher_bytes=len(launcher), disk_bytes=len(disk), disk_files=[f[0] for f in files],
                  standalone_count=len(standalone_report))
    (out / "manifest.json").write_text(json.dumps(report, indent=2) + "\n")
    return report


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--allow-oversize", action="store_true")
    parser.add_argument("--assembler", default="64tass")
    args = parser.parse_args()
    try:
        result = build(args.allow_oversize, assembler=args.assembler)
    except (ValueError, OSError, subprocess.CalledProcessError) as exc:
        parser.exit(1, f"Build failed: {getattr(exc, 'stderr', None) or exc}\n")
    for p in result["programs"]:
        print(f"{p['name']:<8} {p['size']:4} bytes" + ("  ! OVER 256" if p["flags"] else ""))
    print(f"Built release/sector-256.d64 ({result['disk_bytes']} bytes)")


if __name__ == "__main__":
    main()
