; Stable launcher ABI. All programs start at $c000 and may use $c000-$cfff.
; WAITKEY polls RUN/STOP and returns a nonzero PETSCII key in A.
; RUN/STOP unwinds to the launcher, so it never reaches the game.
WAITKEY = $1000
CLEAR = $1003
PUTCHAR = $1006
RANDOM = $1009
POLLKEY = $100c
EXIT = $100f
HIRES = $1012
NEWFRAME = $1015
LINE = $1018
FLIP = $101b
LINE_X0 = $06
LINE_Y0 = $07
LINE_X1 = $08
LINE_Y1 = $09
GETIN = $ffe4
CHROUT = $ffd2
PLOT = $fff0
