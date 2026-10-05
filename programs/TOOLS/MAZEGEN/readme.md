# MAZEGEN

A **183-byte** maze generator for Sector 256. Open **TOOLS**, select **MAZEGEN**, and
press RETURN. Press **SPACE** for a new maze; **RUN/STOP** returns to the launcher.

Each maze has 19 x 10 rooms inside a 39 x 21 character grid. The entrance is
at the bottom left and the exit at the top right. The binary-tree algorithm
connects every room to its north or east neighbor, with boundary exceptions.
Its 189 links form a tree: all 190 rooms are reachable, with exactly one route
between any two rooms. This algorithm has a directional bias and long
corridors along the top and right edges.

The program draws directly into standard C64 text-screen RAM using inverse
spaces for walls. All maze generation code and its prompt count toward the
256-byte budget. Only the shared clear-screen, keyboard, character output,
and random-byte services come from the launcher. This is a generator to view
or use as puzzle material; it does not include a player or solver.

Four 16x16 green maze icons cycle at a requested 192 ms per frame. Regenerate
them with `python3 scripts/seed_art.py`.

![Four-frame maze icon](icon-preview.gif)

![Generated maze](preview.png)
