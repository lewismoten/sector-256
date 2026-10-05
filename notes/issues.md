# Sector 256 program audit

> **Scope disclaimer — static analysis versus execution.** Consolidated from the nine completed audit transcripts dated October 5, 2026. Unless marked **Executed** or **Assembled**, each conclusion is static review of source, metadata, README, icons, and previews—not proof of runtime behavior. Static findings should be reproduced in an emulator before release. No audit work in this report edited a program or generated asset.

**Coverage:** 258 stable program IDs in the eight original review categories. The program sections retain audit-time categories; any `programs/GAMES/<ID>/...` reference is an audit-time path, not a claim about the concurrent relocation.

## Rating key

- **1/5** materially incomplete or misleading.
- **2/5** limited or materially weakened by a finding.
- **3/5** competent small program / neutral audit rating.
- **4/5** notably strong within the format.
- **5/5** exceptional (none assigned in the supplied audits).

## Per-program findings

### DEMOS (26)

- **ATOM — 2/5.** **High:** `x` is uninitialized before indexing the four-byte orbit table.
- **CANDLE — 3/5.** Simple character-art candle; its dedicated icon is the only appropriate use of the repeated candle artwork.
- **CITYLGT — 2/5.** Uses the shared candle launcher icon, which is unrelated to this program and weakens identification.
- **COLORCYC — 2/5.** Uses the shared candle launcher icon, which is unrelated to this program and weakens identification.
- **CREDITS — 2/5.** Uses the shared candle launcher icon, which is unrelated to this program and weakens identification.
- **CUBE3D — 4/5.** The running vector cube is strong, but the checked preview is stale relative to the current animated program.
- **DANCE — 3/5.** The running vector dance loop is stronger than its stale preview; refresh the preview from the current poses.
- **EQUALIZR — 3/5.** Static preview fits the equalizer concept, but a still cannot demonstrate its intended motion.
- **FIREFLY — 2/5.** Uses the shared candle launcher icon, which is unrelated to this program and weakens identification.
- **GLITCH — 2/5.** Uses the shared candle launcher icon, which is unrelated to this program and weakens identification.
- **HEARTBT — 2/5.** Uses the shared candle launcher icon, which is unrelated to this program and weakens identification.
- **HEXFLOW — 2/5.** Uses the shared candle launcher icon, which is unrelated to this program and weakens identification.
- **HYPNO — 3/5.** **High:** uninitialized `f` indexes the two-entry text-pointer table on first draw.
- **MARQUEE — 3/5.** **High:** uninitialized `x` can index beyond the four-byte `dots` table.
- **MAZE10 — 3/5.** Dedicated icon and preview fit the small maze, with no further static-code defect reported.
- **MUNCHING — 3/5.** Dedicated icon/preview represent the pattern; no further static-code defect was reported.
- **NEON — 2/5.** Uses the shared candle launcher icon, which is unrelated to this program and weakens identification.
- **OCEAN — 2/5.** Uses the shared candle launcher icon, which is unrelated to this program and weakens identification.
- **RAIN — 1/5.** **High:** its final 232-byte pass writes past screen/color RAM (`$07e8…` / `$dbe8…`), overrunning memory and I/O-adjacent space.
- **RASTBARS — 2/5.** Uses the shared candle launcher icon, which is unrelated to this program and weakens identification.
- **SCANNER — 2/5.** Uses the shared candle launcher icon, which is unrelated to this program and weakens identification.
- **SNOW — 3/5.** The settling-snow implementation is not represented by the stale preview; refresh it from current output.
- **SUNSET — 2/5.** Uses the shared candle launcher icon, which is unrelated to this program and weakens identification.
- **TRUCHET — 2/5.** Uses the shared candle launcher icon, which is unrelated to this program and weakens identification.
- **WORMS — 2/5.** Uses the shared candle launcher icon, which is unrelated to this program and weakens identification.
- **XORPAT — 3/5.** Dedicated visual assets fit the XOR pattern; no further static-code defect was reported.

#### Category-wide asset and documentation findings

- Asset identity: ATOM, CITYLGT, COLORCYC, CREDITS, FIREFLY, GLITCH, HEARTBT, HEXFLOW, HYPNO, MARQUEE, NEON, OCEAN, RASTBARS, SCANNER, SUNSET, TRUCHET, and WORMS reuse candle art; it is appropriate only for CANDLE.
- CUBE3D, DANCE, and SNOW have animated icon/preview sets, but their supplied preview captures were identified as stale against the current programs.

### EDU (61)

- **ADDITION — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **ALPHABET — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **ANIMALS — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **BINQUIZ — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **BITOPS — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **BODY — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **CLOCK — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **COLORS — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **COMPASS — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **COUNTING — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **DAYS — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **DAYSWK — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **DIVIDE — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **DIVQUIZ — 2/5.** `f` is never initialized before the first fact-table lookup, so the initial displayed fact is indeterminate.
- **ESTIMATE — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **FAMILY — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **FOOD — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **FRACTION — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **GRAPHPT — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **GREATER — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **HEXQUIZ — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **HOME — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **JOBS — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **KEYFIND — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **LANDMARK — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **LOGIC — 4/5.** Interactive AND-gate presentation is strong, but `a` and `b` are read before initialization on first draw.
- **MAPGRID — 2/5.** `f` is never initialized before the first prompt-table lookup; the initial prompt is indeterminate.
- **MAPS — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **MATHQUIZ — 2/5.** `f` is never initialized before the first fact-table lookup; the initial fact is indeterminate.
- **MEASURE — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **MEMORY — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **MONTHS — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **MULTIPLY — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **MUSIC — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **NATURE — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **NUMBERS — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **NUMLINE — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **OCEANLIF — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **OCEANS — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **ODDEVEN — 4/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **OPPOSITE — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **PETSCIIQ — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **PLANETS — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **PLANTS — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **PLANTS2 — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **PRIMEQZ — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **QUIZ — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **RHYMES — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **ROUNDING — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **SCHOOL — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **SEQUENCE — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **SHAPEQZ — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **SHAPES — 2/5.** Tests memorization of an arbitrary 1/2/3 legend rather than direct shape recognition.
- **SPACE — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **SPELLING — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **SPORTS — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **SQUAREQZ — 2/5.** A very narrow one-digit recall drill; the generic icon and static capture do not communicate the square-number task well.
- **SUBTRACT — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **TIMESDRL — 2/5.** `f` is never initialized before the first fact-table lookup; the initial fact is indeterminate.
- **TRANSPRT — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **WEATHER — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.

#### Category-wide asset and documentation findings

- All 61 icons/previews structurally validated as one-frame assets; `animation_speed: 8` is visually inert.
- Repeated generic icon treatment weakens identification, and several table-driven drills read uninitialized first-use state.

### GAMES (78)

- **ARCHERY — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **ARTILLRY — 2/5.** Uses a repeated generic launcher icon shared with other games, reducing catalog identity.
- **BALLOON — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **BASKETBL — 2/5.** Uses a repeated generic launcher icon shared with other games, reducing catalog identity.
- **BEAM — 2/5.** Uses a repeated generic launcher icon shared with other games, reducing catalog identity.
- **BLACKJCK — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **BOUNCE — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **BOWLING — 2/5.** Uses a repeated generic launcher icon shared with other games, reducing catalog identity.
- **BOXPUSH — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **BRICKS — 2/5.** Uses a repeated generic launcher icon shared with other games, reducing catalog identity.
- **BUMPCAR — 2/5.** Uses a repeated generic launcher icon shared with other games, reducing catalog identity.
- **CATCHER — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **CAVE — 2/5.** Uses a repeated generic launcher icon shared with other games, reducing catalog identity.
- **CHICKEN — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **CHOMP — 2/5.** The implementation is a five-square take-away abstraction: the `2–5` prompt does not match its accepted range and it does not realize the usual two-dimensional Chomp board.
- **COPTER — 2/5.** Uses a repeated generic launcher icon shared with other games, reducing catalog identity.
- **COWBULL — 2/5.** Repeated secret/guess digits can overcount cows because every guess digit is compared with every secret digit; the README promises a different repeated-digit interpretation.
- **CRAPS — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **DARTS — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **DEFUSE — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **DICE — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **DOCKING — 2/5.** Uses a repeated generic launcher icon shared with other games, reducing catalog identity.
- **DODGE — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **DROP4 — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **DUEL — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **ECHOSEQ — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **ELEVATOR — 2/5.** Uses a repeated generic launcher icon shared with other games, reducing catalog identity.
- **ESCAPE — 2/5.** Uses a repeated generic launcher icon shared with other games, reducing catalog identity.
- **FALLDOWN — 2/5.** Uses a repeated generic launcher icon shared with other games, reducing catalog identity.
- **FIREMAN — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **FISHING — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **FIVEDICE — 2/5.** Uses a repeated generic launcher icon shared with other games, reducing catalog identity.
- **FLIPPER — 2/5.** Uses a repeated generic launcher icon shared with other games, reducing catalog identity.
- **FLOOD — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **FLUTTER — 2/5.** Uses a repeated generic launcher icon shared with other games, reducing catalog identity.
- **FOXGEESE — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **GOLF — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **GUESSNUM — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **HANGMAN — 4/5.** Meaningful two-frame asset set; README omits explicit restart/control details beyond RUN/STOP.
- **HILO — 3/5.** The one-character score display is uncapped.
- **HORSES — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **HOTPOT — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **HUNT — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **HURDLES — 2/5.** Uses a repeated generic launcher icon shared with other games, reducing catalog identity.
- **ICEPATH — 2/5.** Uses a repeated generic launcher icon shared with other games, reducing catalog identity.
- **INVADE — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **JUGGLE — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **JUMPER — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **KNIGHTS — 2/5.** Uses a repeated generic launcher icon shared with other games, reducing catalog identity.
- **LANDER — 2/5.** Uses a repeated generic launcher icon shared with other games, reducing catalog identity.
- **LAVA — 2/5.** Uses a repeated generic launcher icon shared with other games, reducing catalog identity.
- **LOCKPICK — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **LOTTO — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **MANCALA — 2/5.** Uses a repeated generic launcher icon shared with other games, reducing catalog identity.
- **MATCH — 2/5.** Uses a repeated generic launcher icon shared with other games, reducing catalog identity.
- **MAZE3D — 2/5.** Uses a repeated generic launcher icon shared with other games, reducing catalog identity.
- **MAZEDARK — 2/5.** Uses a repeated generic launcher icon shared with other games, reducing catalog identity.
- **MAZERUN — 2/5.** Uses a repeated generic launcher icon shared with other games, reducing catalog identity.
- **MINES — 2/5.** Uses a repeated generic launcher icon shared with other games, reducing catalog identity.
- **MONTY — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **NIM — 2/5.** Uses a repeated generic launcher icon shared with other games, reducing catalog identity.
- **NUMMEM — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **NUMRACE — 2/5.** Uses a repeated generic launcher icon shared with other games, reducing catalog identity.
- **ODDONE — 2/5.** Uses a repeated generic launcher icon shared with other games, reducing catalog identity.
- **OTHELLO — 2/5.** Uses a repeated generic launcher icon shared with other games, reducing catalog identity.
- **PAIRS — 2/5.** Uses a repeated generic launcher icon shared with other games, reducing catalog identity.
- **PEGS — 2/5.** Uses a repeated generic launcher icon shared with other games, reducing catalog identity.
- **PENALTY — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **PIG — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **POKER — 2/5.** Selects outcome text rather than dealing, rendering, or evaluating a poker hand.
- **PONG — 2/5.** Uses a repeated generic launcher icon shared with other games, reducing catalog identity.
- **REACTION — 2/5.** Uses a repeated generic launcher icon shared with other games, reducing catalog identity.
- **ROCKPAPR — 2/5.** The CPU move is revealed before the player chooses, making the contest trivial.
- **SLOTS — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **TICTACTO — 4/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **TUGOWAR — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **WHACK — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **ZAP — 2/5.** Uses a repeated generic launcher icon shared with other games, reducing catalog identity.

#### Category-wide asset and documentation findings

- All 78 manifests parsed; only HANGMAN and TICTACTO have meaningful two-frame icon-preview GIFs.
- Repeated static-icon groups reduce identity: ARTILLRY BASKETBL; BEAM BUMPCAR ESCAPE; BOWLING BRICKS; CAVE COPTER FLUTTER LANDER; CHOMP MANCALA NIM NUMRACE; DOCKING ELEVATOR; FALLDOWN LAVA MINES; FIVEDICE MATCH MAZE3D MAZEDARK MAZERUN OTHELLO PAIRS PEGS POKER; FLIPPER PONG; HURDLES ODDONE REACTION ZAP; ICEPATH KNIGHTS.

### LAB (10)

- **ALIASING — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **ANT — 4/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **BEATS — 3/5.** Preview shows the UI, but cannot demonstrate the audible beat experiment.
- **CHAOS — 4/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **COLORRAM — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **LFSR — 2/5.** **Executed:** the checked-in payload did not advance its displayed state after a keypress; repair the update/display logic.
- **LIFE — 4/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **RULE30 — 4/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **SANDPILE — 4/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **SCROLLX — 3/5.** Preview at offset zero does not demonstrate the fine-scroll effect; the icon is generic for a hardware experiment.

#### Category-wide asset and documentation findings

- All ten icons/previews validate as static assets; no GIFs or extra icon frames.
- Executed emulator tests passed for ANT, CHAOS, LIFE, RULE30, and SANDPILE; the LFSR probe exposed the per-program defect above.

### MATH (41)

- **ARMSTRNG — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **BASECONV — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **BINCOUNT — 3/5.** Potential uninitialized zero-page counter state merits initialization before the first display.
- **BINOMIAL — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **CANTOR — 3/5.** The preview is a stylized Cantor diagram, not a consistently scaled ternary subdivision.
- **CATALAN — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **CIRCLE — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **COLLATZ — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **DIGROOT — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **DIVISORS — 3/5.** Potential uninitialized zero-page factor state merits initialization before the first display.
- **EDIGITS — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **FACTORL — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **FIB — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **GCD — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **GOLDEN — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **GRAYCODE — 3/5.** Potential uninitialized zero-page counter state merits initialization before the first display.
- **HAPPY — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **HILBERT — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **KAPREKAR — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **KOCH — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **LINES — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **LOOKSAY — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **LUCAS — 2/5.** Its spiral icon is too similar to FIB’s, weakening catalog distinction.
- **MAGICSQ — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **MODCLOCK — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **MULTAB — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **PALINDRM — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **PASCAL — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **PERFECT — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **PERMUTE — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **PI — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **POWERS2 — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **PRIMES — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **PYTHTRIP — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **ROMAN — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **SIERPCAR — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **SINTABLE — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **SQRT — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **SQUARES — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **TOTIENT — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **TRIANGNU — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.

#### Category-wide asset and documentation findings

- All 41 descriptions match the catalog and visual assets are single-frame; animation speed is visually non-operative.
- The audit called out presentation/differentiation concerns and three possible uninitialized-state cases, not broad asset corruption.

### SOUND (15)

- **ARPEGGIO — 3/5.** Static preview cannot demonstrate the central audible behavior.
- **BEEPER — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **BELLS — 2/5.** SID volume/low-frequency state is incompletely initialized; the held tone also does not match a decaying bell well.
- **CHORDS — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **COINSND — 3/5.** Static preview cannot demonstrate the central audible behavior.
- **DOORBELL — 3/5.** Static preview cannot demonstrate the central audible behavior.
- **KLAXON — 3/5.** Static preview cannot demonstrate the central audible behavior.
- **METRONOM — 3/5.** Static preview cannot demonstrate the central audible behavior.
- **MUSICBOX — 2/5.** README melody claim conflicts with source: the listed fragment ends on A rather than the familiar G ending.
- **PHONERNG — 3/5.** Static preview cannot demonstrate the central audible behavior.
- **PIANO — 3/5.** Static preview cannot demonstrate the central audible behavior.
- **SCALE — 3/5.** Static preview cannot demonstrate the central audible behavior.
- **SIREN — 3/5.** Static preview cannot demonstrate the central audible behavior.
- **SWEEP — 3/5.** Static preview cannot demonstrate the central audible behavior.
- **TONEGEN — 2/5.** Uninitialized `$d400` makes frequency depend on residual SID state; the bell-like icon also misrepresents a tone generator.

#### Category-wide asset and documentation findings

- All 15 sources assembled at `$c000`; all icons/previews validate as static assets. No audio, keyboard, launcher, or emulator session was run.
- Still screenshots cannot demonstrate the audible result, and individual README build sections are inconsistent.

### TOYS (14)

- **BINCLOCK — 2/5.** A fixed binary example is presented as a clock; it has no advancing clock behavior or refresh loop.
- **BUBBLES — 2/5.** Claims a scattered/random field, but source emits characters sequentially through the text cursor rather than placing them at random screen positions.
- **CATEYES — 2/5.** `f` is uninitialized before the first eye-frame table lookup.
- **CONFETTI — 2/5.** Claims a scattered/random field, but source emits characters sequentially through the text cursor rather than placing them at random screen positions.
- **DOODLE — 3/5.** `C` clears the screen without redrawing the title/control reminder.
- **FACES — 2/5.** Uses the category’s repeated generic icon rather than a program-specific launcher symbol.
- **FLOWERS — 2/5.** Claims a scattered/random field, but source emits characters sequentially through the text cursor rather than placing them at random screen positions.
- **FORTUNE — 2/5.** Uses the category’s repeated generic icon rather than a program-specific launcher symbol.
- **ORACLE — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **POPCORN — 2/5.** Claims a scattered/random field, but source emits characters sequentially through the text cursor rather than placing them at random screen positions.
- **SPARKLER — 2/5.** The claimed sparkler is a key-triggered static character field, not animated or radiating sparks.
- **SPINNER — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **SPINTOP — 2/5.** `f` is uninitialized before the first frame-table lookup.
- **WINDMILL — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.

#### Category-wide asset and documentation findings

- All 14 manifests and static assets validate; there are no GIFs or numbered icon frames.
- BUBBLES, CATEYES, CONFETTI, FACES, FLOWERS, FORTUNE, POPCORN, and SPARKLER share a generic icon; several claimed scatter effects are sequential text output.

### UTILS (13)

- **BANKVIEW — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **COINTOSS — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **COLORSET — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **CRTTEST — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **JOYTEST — 3/5.** Likely UI/behavior defect: bit extraction displays `F,R,L,D,U` while the screen advertises `U,D,L,R,F`; CIA keyboard sharing is also a hardware caveat.
- **MAZEGEN — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **PALNTSC — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **PETSCII — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **RANDPICK — 2/5.** Description casing conflicts with the documented uppercase convention, and the runtime screen omits `ANY KEY=ROLL`.
- **REGVIEW — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **SCORE — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.
- **SWATCH — 3/5.** The temporal color-mixing behavior is hard to verify from the supplied static/stale preview treatment; align preview/documentation with the actual animated states.
- **TALLY — 3/5.** No program-specific defect was reported by the static audit; this is not runtime verification.

#### Category-wide asset and documentation findings

- All referenced paths resolve and the declared 1,846-byte payload total matches listed programs; icons meet documented constraints.
- MAZEGEN and SWATCH are animated-icon cases; generated GIF changes were pre-existing and were not edited by this audit.

## Intended new GAMES categories (stable-ID mapping; no path assumption)

This is the intended split from the catalog/product audit. It is a mapping table, not an assertion that a particular directory has or has not already moved. The five intended categories plus the seven non-GAMES categories total 12, the supported limit.

| Intended category | Stable program IDs | Count |
| --- | --- | ---: |
| ARCADE | BALLOON, BEAM, BOUNCE, BRICKS, BUMPCAR, CATCHER, CAVE, COPTER, DOCKING, DODGE, ELEVATOR, ESCAPE, FALLDOWN, FIREMAN, FLIPPER, FLUTTER, INVADE, JUGGLE, JUMPER, LANDER, LAVA, PONG, ZAP | 23 |
| SPORTS | ARCHERY, ARTILLRY, BASKETBL, BOWLING, DARTS, FISHING, GOLF, HORSES, HURDLES, PENALTY | 10 |
| PUZZLES | BOXPUSH, DEFUSE, ECHOSEQ, FLOOD, GUESSNUM, HANGMAN, HUNT, ICEPATH, KNIGHTS, LOCKPICK, MAZE3D, MAZEDARK, MAZERUN, MINES, NUMMEM, ODDONE, PEGS, REACTION, WHACK | 19 |
| TABLETOP | CHICKEN, CHOMP, COWBULL, DROP4, DUEL, FOXGEESE, MANCALA, MATCH, NIM, NUMRACE, OTHELLO, PAIRS, ROCKPAPR, TICTACTO, TUGOWAR | 15 |
| CHANCE | BLACKJCK, CRAPS, DICE, FIVEDICE, HILO, HOTPOT, LOTTO, MONTY, PIG, POKER, SLOTS | 11 |

## Prioritized unresolved issues

1. **P0:** reproduce, repair, and regress-test the executed LFSR non-advancement defect (`LAB/LFSR/main.asm`).
2. **P0:** repair RAIN’s screen/color-RAM overrun before release.
3. **P1:** initialize first-use state in ATOM, HYPNO, MARQUEE; the EDU fact/prompt drills; LOGIC; and TOYS CATEYES/SPINTOP.
4. **P1:** align JOYTEST bit order/UI labels and validate against CIA/keyboard interaction; correct COWBULL repeated-digit scoring and CHOMP’s stated controls/rules.
5. **P2:** eliminate SID-state dependence in BELLS/TONEGEN, correct MUSICBOX documentation, and test sound behavior in an emulator.
6. **P2:** replace stale DEMOS previews and shared/misleading launcher icons, especially candle reuse and repeated GAMES/TOYS groups.
7. **P2:** apply/verify the GAMES split by stable ID, regenerate catalog assets, and update tests coupled to current category IDs/order.

## Source provenance

- `/Users/lewismoten/.hermes/cache/delegation/live/deleg_74c17321/task-0.log` through `task-8.log`.
- The transcripts report pre-existing generated-GIF modifications under DEMOS, GAMES/HANGMAN, and UTILS/MAZEGEN; this report neither created nor altered them.
