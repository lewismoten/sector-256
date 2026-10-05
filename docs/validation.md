# Validation

The supplied release was assembled with 64tass 1.59.3120 and verified with
py65 1.2.0 and VICE 3.7.1.

- HANGMAN stored machine-code/data payload: **253 bytes**.
- TICTACTO stored machine-code/data payload: **253 bytes**.
- CUBE3D stored machine-code/data payload: **238 bytes**, including its 64-entry sine table and all cube geometry.
- MAZEGEN stored machine-code/data payload: **183 bytes**.
- SWATCH stored machine-code/data payload: **256 bytes**, within the inclusive payload limit.
- Launcher PRG payload: **5769 bytes**, including reusable bitmap/line services.
- D64 image: **174848 bytes**, standard 35-track layout.
- `c1541` recognizes every file and reports **319 blocks free** in the current 288-program image.
- Seventy-five unittest checks pass. They execute the assembled launcher and programs,
  verify win/loss/draw and rejected inputs, exercise a 700-entry index including
  an entry beyond 255, check category/page/letter navigation, check four-frame
  fast/slow timing, check nonblocking input/exit, and verify oversize rejection
  plus red UI flags.
- CUBE3D has four distinct 16x16 icon bitmaps. The executed launcher cycles
  through all four and wraps at its requested 128 ms per-frame interval.
- SWATCH tests execute all 120 unique pairs at all three ratios, check the
  blank duplicate half, and record memory writes to prove there are exactly
  120 color-RAM writes per redraw and none on the 16 native diagonal cells.
  Rate 1/2/9, ignored keys, pause/resume and RUN/STOP return are covered.
- Steady SWATCH drawing uses 2230–2231 CPU cycles in the 6502 harness, down
  from 6183–6695 in the original full matrix (about 65% less drawing work).
- VICE measured rates 1, 2 and 9 on both PAL and NTSC before and after this
  change. Rate 1 remains one video frame per phase and rate 2 two video frames;
  observed timing jitter stays well below one video frame.
- Additional cube tests cover pixel-exact Bresenham lines in every octant,
  eight projected vertices, changing orientation, alternating display buffers,
  and RUN/STOP return to the selected SHOWS page. Cube-specific bytes count
  toward the limit; general drawing and input routines live in the launcher.
- VICE ran ten rendered CUBE3D frames and returned to SHOWS/CUBE3D after
  RUN/STOP. Both 8 KB bitmap buffers and the sixteen projected coordinate bytes
  match the deterministic 6502 harness byte-for-byte at that frame.
- VICE boots the disk through real C64 and 1541 ROMs. Category selection,
  program selection/loading, both starter games, and RUN/STOP return have
  been exercised. The release's page/bitmap/color/icon/font memory was compared
  byte-for-byte against the deterministic 6502 harness and matches.
- Icon animation accumulates deadlines in thirds of a millisecond and updates
  below the visible screen at raster line 256. PAL/NTSC refresh quantizes the
  requested speed. Tests check both immediate swapping and the 4032 ms
  four-frame-loop deadline (4040 ms at PAL frame granularity).

The screenshot files in this source archive reconstruct executed C64 bitmap RAM
with a deterministic preview charset when a C64 ROM is not supplied. They are
not AI-generated artwork. Real-device colors, glyph shapes, and timing can vary;
physical hardware was not tested.

`python scripts/render_launcher_screenshots.py` regenerates the launcher
captures directly from the machine harness at native 320×200 resolution, with
no resizing.

The 256-byte rule measures stored catalog payload only. It does not limit what
a running program can do with the C64 execution area or documented shared API.
The API's fixed vector table is 30 bytes from `$1000` through `$101d`; this is
not a measurement of the shared API implementation as a whole. The current
release build also verifies 288 standalone PRGs under `release/programs/` and
packs the same 288 artifacts into `release/sector-256-programs.zip`; each
embeds a 795-byte standalone API implementation.

SWATCH's `preview.png` is a labeled arithmetic RGB-average reference rather
than a hardware color measurement. Its native-frame PNGs and `preview.gif`
reconstruct the executed program's screen and color RAM.

## Technical references

- [Commodore 1541 user manual](https://www.commodore.ca/wp-content/uploads/2018/11/commodore_vic_1541_floppy_drive_users_manual.pdf): sequential I/O and maximum 254-byte REL record size.
- [D64 layout](https://www.theflatnet.de/pub/cbm/65xx/text/d64.html): sectors, file chains, directory, and BAM.
- [Commodore programmer's reference](https://commodore.ca/manuals/c64_programmers_reference/c64-programmers_reference.htm): VIC-II bitmap mode and KERNAL calls.
