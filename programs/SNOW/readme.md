# SNOW

A **241-byte** C64 snowfall demo. Open DEMOS, select SNOW, and press RETURN.
Twenty-four white flakes fall downward. Each landing adds to a snowbank that
gradually fills the bottom of the screen. The bank reaches a fixed height and
remains there while the snow keeps falling. RUN/STOP returns to the launcher.

The program uses both bitmap buffers for smooth motion. It redraws the growing
bank each frame, including the right edge beyond the shared line routine's
8-bit X range. The animated 16x16 launcher icon shows falling flakes too.

![Snowfall preview captured from the assembled program](preview.gif)
