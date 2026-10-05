#!/usr/bin/env python3
"""Generate native-size animated GIF previews from program icon frames."""
import argparse
import json
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]


def icon_frame_paths(folder):
    """Return the contiguous icon.png through icon-4.png frame sequence."""
    paths = []
    missing = False
    for number in range(1, 5):
        path = folder / ("icon.png" if number == 1 else f"icon-{number}.png")
        if path.exists():
            if missing:
                raise ValueError(f"{folder}: icon frames must be contiguous, starting at icon.png")
            paths.append(path)
        else:
            missing = True
    return paths


def gif_duration(speed):
    """Convert launcher timing to GIF timing, preserving speed-zero flicker."""
    if not isinstance(speed, int) or not 0 <= speed <= 63:
        raise ValueError("animation_speed must be an integer from 0 through 63")
    # Speed zero swaps every video frame so rapidly alternating colors appear
    # mixed. A 20 ms GIF frame matches PAL and is broadly honored by viewers.
    milliseconds = 20 if speed == 0 else speed * 16
    return max(20, ((milliseconds + 5) // 10) * 10)


def generate_icon_preview(folder):
    """Generate one preview, or return None when the icon is not animated."""
    folder = Path(folder)
    paths = icon_frame_paths(folder)
    if len(paths) < 2:
        return None
    metadata = json.loads((folder / "program.json").read_text())
    duration = gif_duration(metadata.get("animation_speed", 8))
    frames = []
    for path in paths:
        with Image.open(path) as image:
            if image.size != (16, 16):
                raise ValueError(f"{path}: icon must be exactly 16x16")
            frames.append(image.convert("RGB"))
    output = folder / "icon-preview.gif"
    frames[0].save(output, save_all=True, append_images=frames[1:],
                   duration=duration, loop=0, disposal=2, optimize=True)
    return output


def generate_icon_previews(programs=ROOT / "programs"):
    """Generate previews for every animated icon in the category tree."""
    programs = Path(programs)
    generated = []
    metadata_files = sorted(programs.glob("*/*/program.json"),
                            key=lambda path: (path.parent.name.upper(), str(path)))
    for metadata in metadata_files:
        output = generate_icon_preview(metadata.parent)
        if output is not None:
            generated.append(output)
    return generated


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("programs", nargs="?", type=Path, default=ROOT / "programs",
                        help="categorized programs directory (default: repository programs folder)")
    args = parser.parse_args()
    try:
        generated = generate_icon_previews(args.programs)
    except (OSError, ValueError, json.JSONDecodeError) as exc:
        parser.exit(1, f"Icon preview generation failed: {exc}\n")
    for output in generated:
        print(output)


if __name__ == "__main__":
    main()
