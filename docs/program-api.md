# Program interface

Programs assemble for the original NMOS 6502/6510 at `$c000`. The first byte is
the entry point. The launcher copies the indexed payload there and calls it
with `JSR $c000`. A normal `RTS` returns to the launcher. Every compiled byte,
including strings/tables/initialized data, counts toward the 256-byte limit.
Uninitialized runtime RAM does not consume disk payload bytes.

## Shared services

Include `api.inc` from your `main.asm`:

| Address | Symbol | Contract |
| --- | --- | --- |
| `$1000` | `WAITKEY` | Block until a nonzero PETSCII key arrives in A. Poll RUN/STOP and unwind directly to the launcher when pressed. X/Y preserved by the underlying KERNAL services. Flags/A may change. |
| `$1003` | `CLEAR` | Clear the current text screen through CHROUT 147; A/flags may change. |
| `$1006` | `PUTCHAR` | CHROUT wrapper; input A is a PETSCII character. |
| `$1009` | `RANDOM` | Lightweight LFSR/jiffy-mixed byte in A; A/flags change; X/Y preserved. Not cryptographic. |
| `$100c` | `POLLKEY` | Nonblocking input: A=0 if no key, otherwise PETSCII key. RUN/STOP exits to the launcher. A/flags may change. |
| `$100f` | `EXIT` | Explicit exit to launcher; enter with JMP or JSR. Does not return. |
| `$1012` | `HIRES` | Initialize cyan-on-black, double-buffered 320×200 bitmaps. Call once before using graphics services. |
| `$1015` | `NEWFRAME` | Clear the hidden bitmap; leaves the displayed frame intact. |
| `$1018` | `LINE` | Draw an inclusive Bresenham line in the hidden bitmap. Endpoints are `$06/$07` (x0/y0) and `$08/$09` (x1/y1). X coordinates 0–255, Y coordinates 0–199. Invalid Y endpoints are rejected. Modifies x0/y0 to the endpoint. |
| `$101b` | `FLIP` | Wait for raster line 256 and show the completed bitmap, then exchange front/back buffers. |

Graphics services may change A/X/Y, flags, and launcher pointer bytes `$fd/$fe`.
They preserve `$02–$05`, so programs can keep a phase and geometry scratch
values there. Keep the normal IRQ enabled and call POLLKEY once per frame.
FLIP switches between `$6000` and `$a000` bitmaps, with color matrices at
`$4000` and `$8000`. The `$a000` container has already been copied before launch
and can be reused by these services. These routines belong to the launcher and
are excluded from the per-program payload budget; program-specific geometry,
trigonometric tables, and animation logic count toward it.

The mandatory common exit convention is **RUN/STOP**. Programs must regularly
call WAITKEY or POLLKEY (the included turn-based games use WAITKEY). This is cooperative input:
the launcher cannot interrupt an arbitrary program that never calls the input
service or disables the KERNAL keyboard scan. Real-time programs should call
POLLKEY each frame so RUN/STOP remains responsive without waiting for a key.

Returning through WAITKEY discards the game's nested return addresses and
restores the stack pointer captured immediately before launch. Do not change
the launcher's saved stack state. The launcher restores its bitmap display,
turns off sprites/SID volume, drains pending keys, and redraws the same page.

## Environment

- Interrupts and the standard KERNAL keyboard IRQ are enabled.
- `$01 = $36`: BASIC ROM off, KERNAL ROM and I/O visible.
- Normal text mode is active: screen `$0400`, ROM uppercase characters,
  black background/border, white text. The launcher uses a bitmap in another
  VIC bank while browsing.
- Private code and RAM may occupy `$c000–$cfff`. Do not overwrite launcher RAM
  or catalog/icon buffers. The shared graphics API may reuse the container area
  for its second bitmap; access it through the API.
- The supplied games use `$02–$05` and `$20–$39` as BASIC scratch zero page.
  This is safe for their specified KERNAL input/output calls; it is not a
  general guarantee for arbitrary ROM routines or BASIC execution.
- Preserve the standard IRQ vectors, CIA keyboard/timer setup, interrupt
  state, KERNAL, and I/O mapping while using WAITKEY. Programs that customize
  those must restore them before exiting.
- D64 drive number is 8 in this first version. Programs are not standalone
  SYS-able PRGs without the launcher ABI.

## Minimal source

```asm
.include "api.inc"
.cpu "6502"
* = $c000
    lda #65
    jsr PUTCHAR
    jsr WAITKEY
    rts
```

`scripts/build.py` compiles all discovered main.asm files, verifies the entry
address and size, and packs their payloads automatically.
