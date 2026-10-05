# COLORRAM

`COLORRAM` is a tiny Commodore 64 color-memory experiment. Press a key to write a fresh random set of low-nibble color values to the text screen; RUN/STOP returns to the Sector 256 launcher.

## Build

Run `python3 scripts/build.py` from the repository root to assemble and package `COLORRAM` in the Sector 256 D64 image. Its stored payload stays within 256 bytes.
