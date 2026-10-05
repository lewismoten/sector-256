# LFSR

`LFSR` is a small Commodore 64 laboratory program that visualizes an eight-bit feedback shift-register state. Press a key to advance the register and see the next sequence value. RUN/STOP returns to the Sector 256 launcher.

## Build

Run `python3 scripts/build.py` from the repository root to assemble and package `LFSR` into the Sector 256 D64 image. Its stored payload is kept below 256 bytes.
