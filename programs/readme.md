# Sector 256 programs

Every program here runs from the [Sector 256](../README.md) 
Commodore 64 launcher, and each one's stored payload fits in 
**256 bytes or less**. That's one disk block. Press RUN/STOP 
in any program to return to the launcher.

* [![CUBE3D](CUBE3D/icon-preview.gif)](#cube3d)
* [![DANCE](DANCE/icon-preview.gif)](#dance)
* [![HANGMAN](HANGMAN/icon-preview.gif)](#hangman)
* [![LIFE](LIFE/icon.png)](#life)
* [![MAZEGEN](MAZEGEN/icon-preview.gif)](#mazegen)
* [![MONTY](MONTY/icon.png)](#monty)
* [![SNOW](SNOW/icon-preview.gif)](#snow)
* [![SWATCH](SWATCH/icon-preview.gif)](#swatch)
* [![TICTACTO](TICTACTO/icon-preview.gif)](#tictacto)
---
## CUBE3D

A ROTATING 3D WIREFRAME CUBE.   RUN/STOP TO RETURN TO LAUNCHER.

Category: DEMOS. Stored payload: **238 bytes**.

[Assembly source](CUBE3D/main.asm)

![CUBE3D preview](CUBE3D/preview.gif)

## DANCE

DISCO LADY: FOUR VECTOR DANCE POSES. RUN/STOP TO RETURN.

Category: DEMOS. Stored payload: **249 bytes**.

[Assembly source](DANCE/main.asm)

![DANCE preview](DANCE/preview.gif)

## HANGMAN

GUESS A SIX-LETTER WORD.         SIX MISSES AND YOU LOSE.

Category: GAMES. Stored payload: **253 bytes**.

[Assembly source](HANGMAN/main.asm)

![HANGMAN preview](HANGMAN/preview.png)

## LIFE

CONWAY LIFE. SPACE:RANDOMIZE. RUN/STOP:RETURN.

Category: LAB. Stored payload: **243 bytes**.

[Assembly source](LIFE/main.asm)

![LIFE preview](LIFE/preview.png)

## MAZEGEN

190-ROOM PERFECT MAZE. SPACE:NEW. RUN/STOP:RETURN.

Category: UTILS. Stored payload: **183 bytes**.

[Assembly source](MAZEGEN/main.asm)

![MAZEGEN preview](MAZEGEN/preview.png)

## MONTY

PICK 1-3. MONTY OPENS A GOAT. S:SWITCH K:KEEP. STOP:EXIT.

Category: GAMES. Stored payload: **256 bytes**.

[Assembly source](MONTY/main.asm)

![MONTY preview](MONTY/preview.png)

## SNOW

PIXEL SNOW: BRIGHT FLAKES FALL FAST AND STACK. RUN/STOP:EXIT.

Category: DEMOS. Stored payload: **255 bytes**.

[Assembly source](SNOW/main.asm)

![SNOW preview](SNOW/preview.gif)

## SWATCH

ALL 16 COLORS + 120 PAIRS. 1-9:RATE M:MIX SPACE:HOLD STOP:EXIT.

Category: UTILS. Stored payload: **256 bytes**.

[Assembly source](SWATCH/main.asm)

![SWATCH preview](SWATCH/preview.gif)

## TICTACTO

TWO PLAYERS. KEYS 1-9 PLACE X/O. MAKE A LINE OF THREE.

Category: GAMES. Stored payload: **253 bytes**.

[Assembly source](TICTACTO/main.asm)

![TICTACTO preview](TICTACTO/preview.png)

---
**9 programs · 2,186 bytes total · 118 bytes to spare across the whole set**

Want to add one? See [Add a program](../docs/add_program.md) 
and the [program interface](../docs/program-api.md). 
The build rejects any payload over 256 bytes.

Regenerate this page with `python scripts/programs_md.py`.