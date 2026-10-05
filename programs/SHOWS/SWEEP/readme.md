# SWEEP

`SWEEP` is a compact SID sound experiment for the Commodore 64. Each key press raises the frequency of a gated sawtooth voice; after the octave wraps, the sweep restarts. RUN/STOP returns to the Sector 256 launcher.

## Build

Run `python3 scripts/build.py` from the repository root to assemble and package `SWEEP` in the Sector 256 D64 image. Its stored payload remains below 256 bytes.
