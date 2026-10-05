# Sector 256 programs

Every program here runs from the [Sector 256](../README.md) 
Commodore 64 launcher, and each one's stored payload fits in 
**256 bytes or less**. That's one disk block. Press RUN/STOP 
in any program to return to the launcher.

* ![ANT](LAB/ANT/icon.png) [ANT](#ant)
* ![CHAOS](LAB/CHAOS/icon.png) [CHAOS](#chaos)
* ![CUBE3D](DEMOS/CUBE3D/icon-preview.gif) [CUBE3D](#cube3d)
* ![DANCE](DEMOS/DANCE/icon-preview.gif) [DANCE](#dance)
* ![HANGMAN](GAMES/HANGMAN/icon-preview.gif) [HANGMAN](#hangman)
* ![LIFE](LAB/LIFE/icon.png) [LIFE](#life)
* ![MAZEGEN](UTILS/MAZEGEN/icon-preview.gif) [MAZEGEN](#mazegen)
* ![MONTY](GAMES/MONTY/icon.png) [MONTY](#monty)
* ![RULE30](LAB/RULE30/icon.png) [RULE30](#rule30)
* ![SANDPILE](LAB/SANDPILE/icon.png) [SANDPILE](#sandpile)
* ![SNOW](DEMOS/SNOW/icon-preview.gif) [SNOW](#snow)
* ![SWATCH](UTILS/SWATCH/icon-preview.gif) [SWATCH](#swatch)
* ![TICTACTO](GAMES/TICTACTO/icon-preview.gif) [TICTACTO](#tictacto)
---
## ANT

LANGTON'S ANT ON 256X200 HIRES. SPACE:RESET. STOP:RETURN.

Category: LAB. Stored payload: **223 bytes**.

[Assembly source](LAB/ANT/main.asm)

![ANT preview](LAB/ANT/preview.png)

## CHAOS

CHAOS GAME BUILDS A FRACTAL. SPACE:RESET. RUN/STOP:RETURN.

Category: LAB. Stored payload: **187 bytes**.

[Assembly source](LAB/CHAOS/main.asm)

![CHAOS preview](LAB/CHAOS/preview.png)

## CUBE3D

A ROTATING 3D WIREFRAME CUBE.   RUN/STOP TO RETURN TO LAUNCHER.

Category: DEMOS. Stored payload: **238 bytes**.

[Assembly source](DEMOS/CUBE3D/main.asm)

![CUBE3D preview](DEMOS/CUBE3D/preview.gif)

## DANCE

DISCO LADY: FOUR VECTOR DANCE POSES. RUN/STOP TO RETURN.

Category: DEMOS. Stored payload: **249 bytes**.

[Assembly source](DEMOS/DANCE/main.asm)

![DANCE preview](DEMOS/DANCE/preview.gif)

## HANGMAN

GUESS A SIX-LETTER WORD.         SIX MISSES AND YOU LOSE.

Category: GAMES. Stored payload: **253 bytes**.

[Assembly source](GAMES/HANGMAN/main.asm)

![HANGMAN preview](GAMES/HANGMAN/preview.png)

## LIFE

CONWAY LIFE. SPACE:RANDOMIZE. RUN/STOP:RETURN.

Category: LAB. Stored payload: **243 bytes**.

[Assembly source](LAB/LIFE/main.asm)

![LIFE preview](LAB/LIFE/preview.png)

## MAZEGEN

190-ROOM PERFECT MAZE. SPACE:NEW. RUN/STOP:RETURN.

Category: UTILS. Stored payload: **183 bytes**.

[Assembly source](UTILS/MAZEGEN/main.asm)

![MAZEGEN preview](UTILS/MAZEGEN/preview.png)

## MONTY

PICK 1-3. MONTY OPENS A GOAT. S:SWITCH K:KEEP. STOP:EXIT.

Category: GAMES. Stored payload: **256 bytes**.

[Assembly source](GAMES/MONTY/main.asm)

![MONTY preview](GAMES/MONTY/preview.png)

## RULE30

RULE 30 FROM ONE CELL. SPACE:RESET. RUN/STOP:RETURN.

Category: LAB. Stored payload: **220 bytes**.

[Assembly source](LAB/RULE30/main.asm)

![RULE30 preview](LAB/RULE30/preview.png)

## SANDPILE

SANDPILE FRACTAL. SPACE:RESET WITH NEW COLORS. RUN/STOP:RETURN.

Category: LAB. Stored payload: **244 bytes**.

[Assembly source](LAB/SANDPILE/main.asm)

![SANDPILE preview](LAB/SANDPILE/preview.png)

## SNOW

PIXEL SNOW: BRIGHT FLAKES FALL FAST AND STACK. RUN/STOP:EXIT.

Category: DEMOS. Stored payload: **255 bytes**.

[Assembly source](DEMOS/SNOW/main.asm)

![SNOW preview](DEMOS/SNOW/preview.gif)

## SWATCH

ALL 16 COLORS + 120 PAIRS. 1-9:RATE M:MIX SPACE:HOLD STOP:EXIT.

Category: UTILS. Stored payload: **256 bytes**.

[Assembly source](UTILS/SWATCH/main.asm)

![SWATCH preview](UTILS/SWATCH/preview.gif)

## TICTACTO

TWO PLAYERS. KEYS 1-9 PLACE X/O. MAKE A LINE OF THREE.

Category: GAMES. Stored payload: **253 bytes**.

[Assembly source](GAMES/TICTACTO/main.asm)

![TICTACTO preview](GAMES/TICTACTO/preview.png)

---
**13 programs · 3,060 bytes total · 268 bytes to spare across the whole set**

Want to add one? See [Add a program](../docs/add_program.md) 
and the [program interface](../docs/program-api.md). 
The build rejects any payload over 256 bytes.

Regenerate this page with `python scripts/programs_md.py`.