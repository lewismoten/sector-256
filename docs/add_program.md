## Add a program

Create a uniquely named folder under its category in `programs/`, using 1–8
characters from `A-Z`, `0-9`, `_`, and `-`, starting with a letter. The parent
folder assigns the category. Program names are normalized to uppercase, sorted
globally, and space-padded to eight bytes in the index.

```text
programs/
  UTILS/
    MYTOOL/
      main.asm
      program.json
      icon.png
      icon-2.png   optional
      icon-3.png   optional
      icon-4.png   optional
      preview.png  optional, used only in programs/readme.md
```

Example metadata:

```json
{
  "description": "A HANDY TOOL. RUN/STOP RETURNS TO THE LAUNCHER.",
  "animation_speed": 8
}
```

Descriptions are printable ASCII, at most 64 bytes, converted to uppercase and
space-padded. The launcher displays them in two 32-character lines; embedded
spaces can be used to arrange the line break. Each category in `categories.json`
has a matching program folder in `programs/` and icon folder in `categories/`.
Configure up to twelve categories.

`main.asm` must assemble for the 6502 with entry address `$c000` and use the
[program interface](program-api.md). Only its actual machine-code/data
payload counts toward 256 bytes. Index records, names, descriptions, icons,
shared launcher routines, and container/PRG metadata are separate disk costs.
These starter games depend on the launcher's shared input/exit interface.

The build fails if a payload exceeds 256 bytes. To deliberately include larger
programs and flag them in the UI:

```sh
python scripts/build.py --allow-oversize
```

The bypass supports payloads up to 4096 bytes, the reserved execution area.
It does not bypass palette, metadata, memory, or total disk-capacity checks.

## Pixel icons and animation

Icons must be exactly 16×16 opaque pixels. Each of their four 8×8 cells may use
one or two colors, independently chosen from the palette below. This is actual
VIC-II high-resolution bitmap coloring, including independent cell backgrounds.
The palette's RGB values are an authoring convention; real C64 displays vary.

| Index | RGB | Index | RGB |
| --- | --- | --- | --- |
| 0 black | `#000000` | 8 orange | `#8E5029` |
| 1 white | `#FFFFFF` | 9 brown | `#553800` |
| 2 red | `#813338` | 10 light red | `#C46C71` |
| 3 cyan | `#75CEC8` | 11 dark gray | `#4A4A4A` |
| 4 purple | `#8E3C97` | 12 gray | `#7B7B7B` |
| 5 green | `#56AC4D` | 13 light green | `#A9FF9F` |
| 6 blue | `#2E2C9B` | 14 light blue | `#706DEB` |
| 7 yellow | `#EDF171` | 15 light gray | `#B2B2B2` |

Frames must be contiguous, beginning with `icon.png`. Up to four are supported;
the fourth file is `icon-4.png`. Each disk frame contains 32 bitmap bytes and
four color bytes. The builder never silently resizes or approximates colors.

The animation byte stores `(frame_count - 1)` in bits 7–6 and speed in bits 5–0.
Speed 1–63 means **16–1008 ms per frame**; speed 0 requests the fastest safe
color/frame swapping, once per video frame. A four-frame loop at speed 63 is
**4032 ms**. Timing is synchronized to video refresh: PAL updates every 20 ms,
NTSC approximately 16.7 ms. Requested deadlines accumulate, so transitions are
rounded to video frames; rapid blending/flicker depends on the display.
Icon preview GIFs represent speed 0 with 20 ms frames so the rapid swapping and
its intended perceptual color mixing remain visible.

`python scripts/seed_art.py` regenerates the supplied hand-coded pixel art.
`python scripts/icon_previews.py` regenerates every animated program's native
16×16 `icon-preview.gif` from its icon frames and `animation_speed`. The normal
build and the program catalog generator run it automatically.

[Home](../readme.md)
