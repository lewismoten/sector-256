# Validation

The supplied release was assembled with 64tass 1.59.3120 and verified with
py65 1.2.0 and VICE 3.7.1.

- HANGMAN stored machine-code/data payload: **253 bytes**.
- TICTACTO stored machine-code/data payload: **253 bytes**.
- CUBE3D stored machine-code/data payload: **238 bytes**, including its 64-entry sine table and all cube geometry.
- Launcher PRG payload: **5769 bytes**, including reusable bitmap/line services.
- D64 image: **174848 bytes**, standard 35-track layout.
- `c1541` recognizes every file and reports **632 blocks free**.
- Fourteen unittest checks pass. They execute the assembled launcher and programs,
  verify win/loss/draw and rejected inputs, exercise a 700-entry index including
  an entry beyond 255, check category/page/letter navigation, check four-frame
  fast/slow timing, check nonblocking input/exit, and verify oversize rejection
  plus red UI flags.
- CUBE3D has four distinct 16x16 icon bitmaps. The executed launcher cycles
  through all four and wraps at its requested 128 ms per-frame interval.
- Additional cube tests cover pixel-exact Bresenham lines in every octant,
  eight projected vertices, changing orientation, alternating display buffers,
  and RUN/STOP return to the selected DEMOS page. Cube-specific bytes count
  toward the limit; general drawing and input routines live in the launcher.
- VICE ran ten rendered CUBE3D frames and returned to DEMOS/CUBE3D after
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

The screenshot files in this source archive reconstruct executed C64 screen
or bitmap RAM with C64 glyphs. They are not AI-generated artwork. Real-device
colors and timing can vary. Physical hardware was not tested.

## Technical references

- [Commodore 1541 user manual](https://www.commodore.ca/wp-content/uploads/2018/11/commodore_vic_1541_floppy_drive_users_manual.pdf): sequential I/O and maximum 254-byte REL record size.
- [D64 layout](https://www.theflatnet.de/pub/cbm/65xx/text/d64.html): sectors, file chains, directory, and BAM.
- [Commodore programmer's reference](https://commodore.ca/manuals/c64_programmers_reference/c64-programmers_reference.htm): VIC-II bitmap mode and KERNAL calls.
