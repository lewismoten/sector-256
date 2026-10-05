# SNOW

A **255-byte** C64 snowfall demo. Open DEMOS, select SNOW, and press RETURN.
Sixty-four tiny flakes fall at two speeds. Brighter two-pixel flakes fall every
frame; one-pixel flakes fall every other frame. Each landing joins a solid
two-pixel-wide white stack. The closely spaced stacks build an uneven bank, with
each stack capped at eight pixels high. RUN/STOP returns to the launcher.

The program draws directly into a high-resolution C64 bitmap. Each column's
stack height is kept in RAM; settled pixels stay on screen while new flakes
keep falling. The animated 16x16 launcher icon shows the snowfall too.

![Snowfall preview captured from the assembled program](preview.gif)
