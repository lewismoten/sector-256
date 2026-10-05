# SNOW

A **253-byte** C64 snowfall demo. Open DEMOS, select SNOW, and press RETURN.
Thirty-two tiny flakes fall at two speeds. Brighter two-pixel flakes fall every
frame; one-pixel flakes fall every other frame. Some shift gently between
neighboring columns. Each landing joins a solid two-pixel-wide white stack in
its own column, building an uneven skyline without gaps beneath the flakes.
RUN/STOP returns to the launcher.

The program draws directly into a high-resolution C64 bitmap. Each column's
stack height is kept in RAM; settled pixels stay on screen while new flakes
keep falling. The animated 16x16 launcher icon shows the snowfall too.

![Snowfall preview captured from the assembled program](preview.gif)
