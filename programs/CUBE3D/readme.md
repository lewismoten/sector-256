# CUBE3D

A **238-byte** rotating 3D wireframe cube for Sector 256. Open DEMOS, select
CUBE3D, and press RETURN. RUN/STOP returns to the launcher.

The launcher icon has four distinct rotation frames, `icon.png` through
`icon-4.png`, in C64 light blue on black. Animation speed 8 requests 128 ms
per frame, or a 512 ms loop, quantized to the screen refresh rate. Regenerate
the exact-palette icons with `python3 scripts/seed_art.py`.

![Four-frame launcher icon](icon-preview.gif)

The program computes eight vertices and draws twelve edges every frame. A
64-entry signed sine table supplies sine/cosine for rotation about the vertical
axis. Orthographic projection uses a fixed camera tilt. Two bitmap buffers
keep the screen intact while the next frame is cleared and drawn.

All cube-specific code, geometry, edge indexes, and trigonometric data count
toward the 238-byte payload. The launcher supplies generic bitmap clearing,
Bresenham line drawing, frame flipping, and RUN/STOP input. This program needs
the updated Sector 256 launcher; it is not a standalone PRG.

![Cube preview](preview.png)
