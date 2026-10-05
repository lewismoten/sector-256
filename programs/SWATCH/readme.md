# SWATCH

A **253-byte** temporal color-swatch utility. Open **UTILS**, select **SWATCH**,
and press RETURN. The 16 x 16 matrix shows every ordered pair of C64 palette
colors. Read hexadecimal color A on the left and color B above the grid.
The diagonal contains the 16 original colors; the other cells cover all
120 distinct unordered two-color pairs, with their transposed equivalents.

| Key | Action |
| --- | --- |
| 1–9 | Set video frames per phase; the current value follows `1-9:`. |
| M | Cycle A:B ratios: 2:2, 1:3, 3:1. `M:n/4` gives A's share of four frames. |
| SPACE | Hold or resume the current native-color frame. |
| RUN/STOP | Return to the same launcher page. |

At rate 1, equal mixing alternates A/B every video frame: approximately
20 ms per phase on PAL or 16.7 ms on NTSC. Unequal mixing uses four phases,
with three exposures to one color and one to the other. Rate 9 holds each
phase for nine video frames. Updates begin at raster line 256.

These three duty ratios cover **376 nominal two-color recipes**: 16 unmixed
colors, 120 equal pairs, and 240 unequal pairs. Transposing the matrix reverses
the unequal ratio. This is the set of two-color mixtures representable by
four equally timed frames, not an enumeration of mixtures involving three
or four different source colors or arbitrary exposure ratios.

The VIC-II still outputs its original 16 colors. The apparent blends depend
on refresh rate, screen persistence, brightness, color calibration, and
emulator/display behavior. Some recipes can appear alike or visibly flicker;
there is no universal list of distinct extra hardware colors. SPACE holds
one source frame, so it deliberately reveals the original colors.

All matrix coloring, timing, ratio controls, and labels live in the program's
253-byte payload. The launcher supplies standard text clearing/output and
cooperative keyboard/exit services. Four checkerboard icons use only the
exact C64 authoring palette and cycle at the fastest launcher rate.

![Illustrative equal-ratio swatches](preview.png)

The static preview uses arithmetic RGB averages of the project's authoring
palette as a visual reference, **not measured colors from a C64 display**.
`preview.gif` contains the actual alternating native-color frames reconstructed
from executed C64 screen/color RAM; GIF playback can change their timing.
