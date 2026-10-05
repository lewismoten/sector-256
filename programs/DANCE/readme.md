# DANCE

A **249-byte** C64 vector disco demo. Open DEMOS, select DANCE, and press
RETURN. A lady in a flared dress cycles through four arm-and-foot poses;
RUN/STOP returns to the launcher.

The angular figure, cyan phosphor look, and repeating dance loop recall the
small graphics demos and disco imagery a home-computer hobbyist might have
made in the 1980s. The 6502 program stores a fixed outline, four compact pose
tables, and a list of line connections. The launcher's shared graphics routines
draw each pose into a hidden bitmap, then swap it onto the screen.

![Animated C64 execution preview](preview.gif)

The launcher icon has four matching 16x16 frames. The preview was captured
from the assembled program running in the project's 6502 execution harness.
