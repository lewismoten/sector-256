# Sector 256 program ideas

505 ideas for C64 programs whose stored payload fits in 256 bytes. Names are 8 characters max; completed programs are tracked below.

**Fit** is a rough estimate: **Easy** fits comfortably, **Tight** means fighting for the last bytes, **Stretch** is a known hard sizecoding target that may need a simplified version.

| Category | Ideas | Easy | Tight | Stretch |
| --- | ---: | ---: | ---: | ---: |
| [GAMES](#games) | 118 | 27 | 68 | 23 |
| [DEMOS](#demos) | 79 | 40 | 34 | 5 |
| [UTILS](#utils) | 60 | 35 | 22 | 3 |
| [LAB](#lab) | 70 | 23 | 40 | 7 |
| [SOUND](#sound) | 48 | 30 | 17 | 1 |
| [TOYS](#toys) | 42 | 25 | 17 | 0 |
| [MATH](#math) | 51 | 24 | 23 | 4 |
| [EDU](#edu) | 37 | 25 | 12 | 0 |
| **Total** | **505** | **229** | **233** | **43** |

## Progress

Completed: ANT, ARCHERY, ARTILLRY, BALLOON, BASKETBL, BEAM, BOUNCE, BUMPCAR, BOXPUSH, CATCHER, CAVE, CHAOS, CHICKEN, COPTER, COWBULL, CUBE3D,
DANCE, BOWLING, BRICKS, CRAPS, DARTS, DEFUSE, DICE, DOCKING, DODGE, ELEVATOR, DROP4, DUEL, ESCAPE, ECHOSEQ, FIREMAN, FLUTTER, FLOOD, FISHING, GOLF, GUESSNUM, CHOMP, JUGGLE, HURDLES, QUIZ, COUNTING, ALPHABET, SPELLING, COLORS, SHAPES, ADDITION, SUBTRACT, MULTIPLY, DIVIDE, FRACTION, CLOCK, ODDEVEN, MEMORY, PLANETS, ANIMALS, WEATHER, OCEANS, MAPS, DAYS, MONTHS, BODY, FOOD, TRANSPRT, HOME, NATURE, MUSIC, SPORTS, SPACE, JOBS, OPPOSITE, RHYMES, NUMBERS, SCHOOL, FAMILY, PLANTS, OCEANLIF, LANDMARK,
HANGMAN, HILO, HORSES, HOTPOT, INVADE, LOCKPICK,
HUNT, LIFE, LOTTO, FALLDOWN, FLIPPER, FIVEDICE, FOXGEESE, ICEPATH, JUMPER, KNIGHTS, LANDER, LAVA, MANCALA, MATCH, MAZE3D, MAZEDARK, MAZERUN, MINES, NIM, NUMRACE, OTHELLO, PAIRS, PEGS, POKER, PONG,
MAZEGEN, MONTY, RULE30, SANDPILE,
SNOW, SWATCH, TICTACTO.

Completed: PLANTS2 — extended plant-word practice in EDU.

Completed: COMPASS — added a cardinal-direction arrow quiz to EDU.

Completed: GREATER — added a comparison-symbol drill to EDU.

Completed: BINQUIZ — added a binary-to-decimal lesson to EDU.

Completed: CANTOR — added a character-mode Cantor set to the MATH category.

Completed: FIB — added the Fibonacci sequence through the 16-bit limit to MATH.

Completed: BINCOUNT — added an interactive eight-bit binary counter to MATH.

Completed: PASCAL — added the first six rows of Pascal's triangle to MATH.

Completed: GRAYCODE — added an interactive eight-bit Gray-code counter to MATH.

Completed: SCALE — added an ascending SID scale to the SOUND category.

Completed: ARPEGGIO — added a fast SID C-major arpeggio to SOUND.

Completed: DOORBELL — added a two-note SID doorbell chime to SOUND.

Completed: SIREN — added a four-tone SID siren wail to SOUND.

Completed: DOODLE — added a WASD sketchpad to the TOYS category.

Completed: FACES — added random character-art faces to TOYS.

Completed: FORTUNE — added random fortune-cookie messages to TOYS.

Completed: ROCKPAPR — added a random rock-paper-scissors game to GAMES.

Completed: SLOTS — added a three-reel slot machine to GAMES.

Completed: TUGOWAR — added a two-player Q-versus-P tug of war to GAMES.

Completed: BANKVIEW — added a processor-port memory-bank display to UTILS.

Completed: COINTOSS — added a random coin toss with tallies to UTILS.

Completed: COLORSET — added a border and background color picker to UTILS.

Completed: MAZE10 — added the classic random diagonal character maze to DEMOS.

Completed: EQUALIZR — added random character-mode equalizer bars to DEMOS.

Completed: SEQUENCE — added a number-pattern quiz to EDU.

Completed: PRIMEQZ — added a prime-number yes-or-no quiz to EDU.

Completed: KEYFIND — added a keyboard-location drill to EDU.

Completed: REGVIEW — added a live VIC-II color-register display to UTILS.

Completed: SCORE — added a two-player tabletop scorekeeper to UTILS.

Completed: PIANO — added a four-key SID piano to SOUND.

Completed: BEEPER — added typed-key SID feedback to SOUND.

Completed: CHORDS — added three-voice SID major chords to SOUND.

Completed: MULTAB — added a one-through-five multiplication table to MATH.

Completed: PIG — added a compact roll-or-hold dice game to GAMES.

Completed: WHACK — added a five-hit number-key reaction game to GAMES.

Completed: SQUARES — added an odd-number-sums square proof to MATH.

Completed: PENALTY — added a random-keeper penalty shootout to GAMES.

Completed: XORPAT — added a classic x-XOR-y character texture to DEMOS.

Completed: JOYTEST — added a dual-port joystick bit display to UTILS.

Completed: TRIANGNU — added the first ten triangular numbers to MATH.

Completed: LUCAS — added Lucas numbers through the 16-bit limit to MATH.

Completed: POWERS2 — added powers of two through the 16-bit limit to MATH.

Completed: HEXQUIZ — added decimal-to-hex digit practice to EDU.

Completed: BITOPS — added a one-bit logic-operation quiz to EDU.

Completed: KAPREKAR — added a 6174 Kaprekar routine demonstration to MATH.

Completed: NUMMEM — added a three-digit memory game to GAMES.

Completed: MUSICBOX — added a compact SID music-box phrase to SOUND.

Completed: PALNTSC — added a KERNAL PAL/NTSC video-standard reporter to UTILS.

Completed: DAYSWK — added a next-weekday drill to EDU.

Completed: ESTIMATE — added a briefly flashed dot-counting drill to EDU.

Completed: ARMSTRNG — added three-digit Armstrong-number identities to MATH.

Completed: MUNCHING — added phased munching XOR squares to DEMOS.

Completed: GCD — added a step-by-step Euclid algorithm demonstration to MATH.

## GAMES

118 ideas.

| Name | Description | Fit |
| --- | --- | --- |
| `ARCHERY` | Account for wind and timing to hit a moving target | Tight |
| `ARTILLRY` | Set angle and power to lob shells over a hill at the enemy | Stretch |
| `BALLOON` | Pump a balloon for points; pop it and lose the round | Easy |
| `BASKETBL` | Time a shot's arc to sink free throws | Tight |
| `BEAM` | Rotate a turret to zap enemies approaching from all sides | Tight |
| `BLACKJCK` | Draw cards toward 21 against a dealer who stands on 17 | Tight |
| `BLOCKFAL` | Falling three-block columns; line up three colors to clear | Stretch |
| `BOMBER` | A plane descends over a city; bomb the towers flat to land | Tight |
| `BOUNCE` | Guide a constantly bouncing ball onto platforms | Tight |
| `BOWLING` | Aim and curve a ball at ten pins | Tight |
| `BOXPUSH` | Push crates onto targets in one hand-built warehouse level | Stretch |
| `BRICKS` | Paddle and ball smash a wall of bricks | Stretch |
| `BUMPCAR` | Bumper cars bounce around an arena; avoid getting hit | Tight |
| `CATCHER` | Move a basket to catch falling stars; miss three and it's over | Easy |
| `CAVE` | Fly through a scrolling cave tunnel that keeps narrowing | Tight |
| `CHICKEN` | Two players race toward each other; last to swerve wins | Easy |
| `CHOMP` | Take bites of a chocolate grid; whoever takes the poisoned corner loses | Tight |
| `CITYDEF` | Intercept falling missiles before they reach your cities | Stretch |
| `CODEBRK` | Guess a hidden 4-color code from right-place/right-color hints | Tight |
| `COPTER` | Hold a key to rise, release to fall, through a cave | Tight |
| `COWBULL` | Guess a 4-digit number from bulls and cows hints | Easy |
| `CRAPS` | Come-out roll, point, and pass/fail rules | Tight |
| `DARTS` | Throw at a dartboard with a wobbling crosshair | Tight |
| `DEFUSE` | Cut the wires in the right order before the timer hits zero | Tight |
| `DICE` | Roll two dice with an animated tumble | Easy |
| `DOCKING` | Match velocity and line up to dock with a space station | Tight |
| `DODGE` | Move left/right to avoid falling blocks; score is survival time | Easy |
| `DOTS` | Two-player dots and boxes on a small grid | Tight |
| `DRAG` | Shift gears at the right RPM in a quarter-mile drag race | Tight |
| `DROP4` | Two players drop discs into columns; first to four in a row wins | Tight |
| `DUEL` | Two gunslingers; the first to fire after the signal wins | Tight |
| `DUNGEON` | Walk a random dungeon and fight monsters by bumping them | Stretch |
| `ECHOSEQ` | Repeat a growing sequence of flashing colors and tones | Tight |
| `ELEVATOR` | Run an elevator to deliver passengers before they give up | Tight |
| `ESCAPE` | Robots step toward you each move; lure them into collisions | Tight |
| `FALLDOWN` | Drop through gaps in rising floors without touching the top | Tight |
| `FIREMAN` | Move the net to bounce jumpers from a burning building | Tight |
| `FISHING` | Wait for a bite and press at the right moment to reel in | Easy |
| `FIVEDICE` | Roll five dice up to three times chasing a scoring hand | Tight |
| `FLIPPER` | Minimal two-flipper ball table with gravity | Stretch |
| `FLOOD` | Recolor the top-left region to flood the board in limited moves | Tight |
| `FLUTTER` | One-key bird flaps through gaps in scrolling pipes | Tight |
| `FOXGEESE` | Fox and geese board game for two players | Stretch |
| `GOLF` | Aim and set power to putt a ball into the hole | Tight |
| `GUESSNUM` | Guess a number 1-100; computer says higher or lower | Easy |
| `HILO` | Guess whether the next card is higher or lower | Easy |
| `HOCKEY` | Two-player air hockey with paddle and puck physics | Stretch |
| `HORSES` | Bet on one of five horses in a random race | Easy |
| `HOTPOT` | Pass the keyboard around until the hidden timer goes off | Easy |
| `HUNT` | Find hidden treasure from hot/cold distance hints | Tight |
| `HURDLES` | Mash to run, tap to jump over hurdles | Tight |
| `ICEPATH` | Slide on ice until you hit a rock; reach the exit | Tight |
| `INVADE` | One row of descending invaders and one shot at a time | Stretch |
| `JUGGLE` | Keep three balls in the air with one paddle | Tight |
| `JUMPER` | Endless runner: jump over scrolling obstacles | Tight |
| `KNIGHTS` | Knight's tour: visit every square of a board exactly once | Tight |
| `LANDER` | Thrust against gravity to touch down gently on a landing pad | Stretch |
| `LAVA` | Floor tiles crumble after you step; last player standing wins | Tight |
| `LOCKPICK` | Turn a dial and listen for clicks to crack a safe | Tight |
| `LOTTO` | Pick six numbers and see how many the draw matches | Easy |
| `MANCALA` | Two-player mancala sowing game | Tight |
| `MATCH` | Flip pairs of cards to find matches on a 4x4 board | Tight |
| `MAZE3D` | First-person wireframe corridor view of a small maze | Stretch |
| `MAZEDARK` | Maze where only the cells next to you are visible | Tight |
| `MAZERUN` | Navigate a fixed maze before the countdown ends | Tight |
| `MERGE` | Slide tiles on a 4x4 grid so matching numbers combine | Stretch |
| `MINES` | Reveal a grid without hitting hidden mines; numbers count neighbors | Stretch |
| `MIRRORS` | Place mirrors to bounce a beam into the target | Tight |
| `NIM` | Take 1-3 sticks per turn against the CPU; last stick loses | Easy |
| `NUMMEM` | Memorize a flashed number; it grows one digit each round | Easy |
| `ODDONE` | Spot the odd character out in a grid before time runs out | Easy |
| `ORBIT` | Steer around a planet's gravity well to collect pods | Stretch |
| `PADDLE` | Two-player paddle tennis, one player on keys, one on joystick | Tight |
| `PARACHUT` | Steer a falling parachutist onto a moving boat | Tight |
| `PARKING` | Slide cars around a lot to free the exit for yours | Tight |
| `PEGSOL` | Peg solitaire on the cross-shaped board | Tight |
| `PENALTY` | Pick a corner to shoot; the keeper guesses a side | Easy |
| `PIG` | Dice game: keep rolling to build a turn total or bank it | Easy |
| `PIPES` | Rotate tiles to connect a pipe from source to drain | Stretch |
| `QUEENS` | Place eight queens so none attack each other | Tight |
| `RACE` | Top-down road scrolls and twists; stay off the edges | Tight |
| `RAFT` | Paddle a raft down a scrolling river avoiding rocks | Tight |
| `REACTION` | Wait for the flash, hit a key, and see your time in jiffies | Easy |
| `REVERSI` | Two-player flip-the-discs board game with move validation | Stretch |
| `ROADHOP` | Hop across lanes of scrolling traffic to reach the far side | Stretch |
| `ROCKPAPR` | Rock-paper-scissors against the computer with a score | Easy |
| `ROCKS` | Rotate and thrust a ship to shoot drifting rocks | Stretch |
| `ROULETTE` | Bet a number or color and spin the wheel | Tight |
| `SALVO` | Find the computer's hidden ships on a 10x10 grid | Tight |
| `SAME` | Remove groups of same-colored blocks; the rest fall down | Tight |
| `SHOOTGAL` | Targets slide across a gallery; time your shots | Tight |
| `SKIER` | Steer down a slope between scrolling gates | Tight |
| `SLIDE15` | 15-tile sliding puzzle shuffled from the solved state | Tight |
| `SLOTS` | Three-reel slot machine with a credit counter | Easy |
| `SNAKE` | Steer a growing snake to food; hitting a wall or yourself ends the game | Tight |
| `SNAKES2` | Two-player snakes on one screen | Tight |
| `SPLAT` | Squash bugs crawling across the screen before they escape | Easy |
| `SQUASH` | One paddle, one ball, three walls | Easy |
| `STACKER` | Time a key press to stack sliding blocks as high as you can | Easy |
| `STAIRS` | Climb random platforms upward before the floor rises | Tight |
| `SUDOKU4` | 4x4 mini sudoku with one built-in puzzle | Tight |
| `SUMO` | Two players shove each other toward the ring edge | Tight |
| `TAG` | Two-player chase; the tagger switches on contact | Tight |
| `TANKS` | Two tanks trade turns firing ballistic shots | Stretch |
| `TINYADV` | Three-room text adventure using single-key commands | Stretch |
| `TOGGLES` | Pressing a cell flips it and its neighbors; turn every light off | Tight |
| `TOWERS` | Move a stack of disks between three pegs (Towers of Hanoi) | Tight |
| `TRAILS` | Two-player light-trail duel; first to crash into any trail loses | Tight |
| `TRAINS` | Switch junctions to route trains to matching stations | Tight |
| `TUGOWAR` | Two players mash keys to pull the rope marker | Easy |
| `TUNNEL` | Dig through dirt collecting gems while rocks fall | Tight |
| `TWENTY1` | Count up to 21 adding 1-3 per turn; whoever says 21 wins | Easy |
| `TYPERACE` | Letters fall from the top; type them before they land | Tight |
| `VOLLEY` | Two players bounce a ball over a net | Tight |
| `WELL` | Falling blocks fill rows in a narrow well (simplified pieces) | Stretch |
| `WHACK` | Hit the number key of the mole that pops up | Easy |
| `WUMPUS` | Hunt the wumpus through a 20-room cave with bats and pits | Stretch |
| `ZAP` | Zap aliens that appear at random positions | Easy |

## DEMOS

79 ideas.

| Name | Description | Fit |
| --- | --- | --- |
| `ATOM` | Electrons orbiting a nucleus | Easy |
| `AURORA` | Shifting curtains of color across the sky | Tight |
| `BIGTEXT` | Large letters built by scaling ROM characters 8x | Tight |
| `BIRDS` | Flocking boids following three simple rules | Tight |
| `BOLTS` | Random lightning bolts with screen flashes | Tight |
| `BORDERS` | Open the top and bottom borders with raster tricks | Tight |
| `BOUNCER` | Bouncing ball sprite that squashes on impact | Easy |
| `BOUNCTXT` | A block of text bouncing around the screen | Easy |
| `CANDLE` | Flickering candle flame | Easy |
| `CHECKER` | Scrolling 3D checkerboard floor | Tight |
| `CITYLGT` | Night skyline where windows switch on and off | Easy |
| `CLOUDS` | Parallax clouds drifting across a sky | Easy |
| `COLORCYC` | Color cycling over a static pattern | Easy |
| `COMET` | Comet with a fading tail crossing the sky | Easy |
| `CREDITS` | Rolling credits over a starry background | Easy |
| `CURTAIN` | Theater curtains open to reveal a message | Easy |
| `DISSOLVE` | Screen dissolves in random order driven by an LFSR | Tight |
| `DNA` | Rotating double helix of characters | Tight |
| `DOTSPHR` | Rotating sphere made of dots | Stretch |
| `DOTTORUS` | Rotating torus made of dots | Stretch |
| `DYCP` | Wavy text where each character has its own vertical offset | Tight |
| `EQUALIZR` | Animated graphic equalizer bars | Easy |
| `FADE` | Smooth fade-in and fade-out using a luminance-ordered palette | Easy |
| `FIRE` | Rising flames using character shading and heat diffusion | Tight |
| `FIREFLY` | Fireflies blinking in a dark field | Easy |
| `FIREWORK` | Particle fireworks bursting in bitmap mode | Tight |
| `FISHTANK` | Fish sprites swimming around an aquarium | Tight |
| `FLAGWAVE` | Waving checkered flag | Tight |
| `FLD` | Bounce the whole screen with flexible line distance | Tight |
| `FOUNTAIN` | Particle fountain with gravity | Tight |
| `GLITCH` | Random screen corruption that resolves into a message | Easy |
| `HEARTBT` | Beating heart sprite with a pulse sound | Easy |
| `HEXFLOW` | Streams of hex digits flowing like data | Easy |
| `HYPNO` | Pulsing concentric rings | Easy |
| `INTERFER` | Interference rings from two moving centers | Tight |
| `KALEIDO` | Four-way mirrored random patterns | Tight |
| `LAVALAMP` | Slow-moving color blobs like a lava lamp | Tight |
| `LISSAJ` | Lissajous curves traced by a moving point | Tight |
| `MARQUEE` | Chasing lights around the screen border | Easy |
| `MAZE10` | The classic diagonal-slash maze, written in assembly | Easy |
| `METABALL` | Blobby metaballs merging in character mode | Stretch |
| `MOIRE` | Moire interference of two line sets | Tight |
| `MUNCHING` | Munching squares: the classic x XOR y over time | Easy |
| `NEON` | Flickering neon sign text | Easy |
| `OCEAN` | Rolling waves of characters | Easy |
| `OCTAHED` | Rotating wireframe octahedron | Tight |
| `PLANETS` | Planets orbiting a sun at different speeds | Tight |
| `PLASMA` | Classic sine-table color plasma on the text screen | Tight |
| `PYRAMID` | Rotating wireframe pyramid | Tight |
| `RAIN` | Green character rain cascading down the screen | Easy |
| `RAINDROP` | Rain falling with splashes on a ground line | Easy |
| `RASTBARS` | Bouncing raster color bars | Easy |
| `ROTOZOOM` | Rotating, zooming texture on the text screen | Stretch |
| `SCANNER` | Sweeping red light bar moving back and forth | Easy |
| `SCROLLER` | Smooth-scrolling message along the bottom row | Easy |
| `SHADEBOB` | Shade bobs leaving glowing trails | Tight |
| `SINEDOTS` | A wave of dots rippling across the screen | Easy |
| `SINESCRL` | Text scroller that waves along a sine curve | Tight |
| `SPIRAL` | Characters spiral inward from the screen edges | Easy |
| `SPLITSCR` | Text on top, hires bitmap below via a raster split | Tight |
| `SPRITES` | Eight hardware sprites orbiting in a circle | Easy |
| `STARBURS` | Colored lines bursting outward from the center | Easy |
| `STARFLD` | 3D starfield streaming toward the viewer | Easy |
| `STARPOLY` | Spinning star polygon with a changing point count | Tight |
| `STARS2D` | Parallax horizontal starfield at three speeds | Easy |
| `SUNSET` | Gradient sky built from raster color changes | Easy |
| `TETRA` | Rotating wireframe tetrahedron | Tight |
| `TEXTMELT` | Screen text melts downward column by column | Easy |
| `TILTGRID` | Perspective grid scrolling toward a horizon | Tight |
| `TRUCHET` | Random Truchet tiles from diagonal PETSCII characters | Easy |
| `TUNNELFX` | Endless spinning tunnel made of characters | Tight |
| `TWISTER` | Twisting vertical bar built from raster color changes | Tight |
| `TYPEWRT` | Message typed out letter by letter with click sounds | Easy |
| `VECBALL` | Rotating ball of vector points with depth shading | Stretch |
| `WATER` | Ripples spreading from random drops | Tight |
| `WAVEGRID` | Undulating 3D grid of points | Tight |
| `WIPE` | A cycle of screen wipe transitions | Easy |
| `WORMS` | Colored worms crawling randomly | Easy |
| `XORPAT` | Animated XOR texture pattern | Easy |

## UTILS

60 ideas.

| Name | Description | Fit |
| --- | --- | --- |
| `ALARMCLK` | Set an alarm on the TOD clock and ring when it hits | Tight |
| `BANKVIEW` | Show the memory configuration bits in the processor port | Easy |
| `BASICSZ` | Report BASIC program size and free memory | Easy |
| `BINVIEW` | Show a value in binary, hex and decimal as you type | Easy |
| `CALC` | Four-function integer calculator | Tight |
| `CHARED` | Edit one character's 8x8 bitmap | Stretch |
| `CHARVIEW` | Show all 256 characters of the current character set | Easy |
| `CIAREGS` | Live display of CIA timers and ports | Easy |
| `COINTOSS` | Flip a coin and keep a tally | Easy |
| `COLORSET` | Pick border, background and text colors and keep them | Easy |
| `COMPARE` | Compare two memory ranges and list the differences | Tight |
| `CONVERGE` | Crosshatch pattern for CRT convergence | Easy |
| `COPYMEM` | Copy a memory range to another address | Tight |
| `CRC` | Compute the CRC-16 of a memory range | Tight |
| `CRTTEST` | Color bars and grid for adjusting a monitor | Easy |
| `DATEDAYS` | Day of the week for any date | Tight |
| `DIRLIST` | Show the disk directory without wiping BASIC memory | Tight |
| `DISKFREE` | Show blocks free on the disk | Easy |
| `DISKMAP` | Show the disk's block allocation map as a grid | Tight |
| `DOSCMD` | Type and send any DOS command to the drive | Easy |
| `DRIVEID` | Identify the drive model by reading its ROM | Tight |
| `DRVSTAT` | Read and display the drive error channel | Easy |
| `FILLMEM` | Fill a memory range with a value | Easy |
| `FORMAT` | Format a disk with a prompted name and ID | Easy |
| `HEXCALC` | Hex/decimal converter and adder | Tight |
| `IRQVEC` | Show the IRQ, NMI and BRK vectors | Easy |
| `JOYTEST` | Joystick tester for both ports, directions and fire | Easy |
| `KEYCODE` | Press a key to see its PETSCII and matrix codes | Easy |
| `KEYREP` | Toggle key repeat on and off | Easy |
| `LOWERCAS` | Switch to the lowercase character set and lock it | Easy |
| `MEMDUMP` | Hex dump of memory; keys page forward and back | Tight |
| `MEMVIEW` | Show RAM directly as screen characters, scrollable | Easy |
| `METRONOM` | Adjustable metronome with a tick sound | Easy |
| `MONITOR` | Tiny monitor to view and edit memory in hex | Stretch |
| `NOTEPAD` | Type a note on screen that stays until reset | Tight |
| `PADDLES` | Read paddle and mouse POT values live | Easy |
| `PALNTSC` | Detect and report a PAL or NTSC machine | Easy |
| `PETSCII` | Table of PETSCII codes alongside their characters | Easy |
| `RAMTEST` | Write and read patterns through free RAM, reporting errors | Tight |
| `RANDPICK` | Pick a random number in a range you enter | Easy |
| `REGVIEW` | Live display of the VIC-II registers | Easy |
| `RENAME` | Rename a disk file | Tight |
| `RESET` | Clean soft reset back to BASIC | Easy |
| `ROMSUM` | Checksum the KERNAL and BASIC ROMs to identify versions | Easy |
| `SCORE` | Two-player scoreboard for tabletop games | Easy |
| `SCRATCH` | Delete a disk file by name with confirmation | Tight |
| `SCRDUMP` | Save the current text screen to disk | Tight |
| `SCREENSV` | Blank the screen after inactivity, restore on a key | Tight |
| `SCRLOAD` | Load a saved text screen file | Easy |
| `SEARCH` | Search memory for a byte sequence | Tight |
| `SECTVIEW` | Read a disk sector and hex dump it | Stretch |
| `SPEEDTST` | Benchmark: count loop iterations per frame | Tight |
| `SPRVIEW` | View sprite data from any memory block | Tight |
| `STOPWTCH` | Stopwatch with lap times | Easy |
| `TALLY` | Tally counter with up and down keys | Easy |
| `TIMER` | Countdown timer with an alarm tone | Easy |
| `TODCLOCK` | Set and display the CIA time-of-day clock | Easy |
| `UNNEW` | Recover a BASIC program after NEW | Tight |
| `VALIDATE` | Send a validate command to the drive | Easy |
| `VARDUMP` | List BASIC variables and their values | Tight |

## LAB

70 ideas.

| Name | Description | Fit |
| --- | --- | --- |
| `ALIASING` | Sample a fast motion at the frame rate to show aliasing | Easy |
| `ANT` | Langton's ant wanders chaotically, then builds its highway | Tight |
| `BADLINES` | Visualize VIC bad lines stealing CPU time | Tight |
| `BEATS` | Two slightly detuned SID voices so you can hear beats | Easy |
| `BFS` | Breadth-first flood fill finding the shortest path | Tight |
| `BIRTHDAY` | Birthday paradox: random dates until two match | Tight |
| `BRIAN` | Brian's Brain three-state automaton | Tight |
| `CHAOS` | Chaos game plots random midpoints into a Sierpinski triangle | Easy |
| `CHARROM` | Copy the character ROM to RAM and edit glyphs live | Tight |
| `CLOCKS` | Jiffy clock and CIA TOD side by side, showing the drift | Easy |
| `COINRUNS` | Flip coins and track the longest run of heads | Easy |
| `COLORRAM` | Demonstrate that color RAM is only 4 bits wide | Easy |
| `CYCCOUNT` | Measure an instruction's cycle count with CIA timers | Tight |
| `CYCLIC` | Cyclic cellular automaton that forms spirals | Tight |
| `DAYNIGHT` | Day and Night automaton B3678/S34678 | Tight |
| `DECAY` | Radioactive decay simulation with a half-life graph | Tight |
| `DICESTAT` | Roll dice thousands of times and histogram the sums | Easy |
| `DIFFUSE` | Two colors of particles mixing over time | Tight |
| `DLA` | Diffusion-limited aggregation grows a branching crystal | Tight |
| `EPIDEMIC` | Infection spreading and recovering across a grid | Tight |
| `ERODE` | Erosion carving channels into a random terrain | Tight |
| `FOREST` | Forest-fire automaton: trees grow, lightning burns | Tight |
| `GALTON` | Galton board: falling balls pile into a bell curve | Tight |
| `GAMBLER` | Gambler's ruin random walk until the bankroll hits zero | Easy |
| `GRAVSIM` | Two bodies orbiting under Newtonian gravity | Stretch |
| `HARMONO` | Harmonograph drawn by decaying sine motions | Tight |
| `HEATEQ` | Heat diffusing along a bar | Tight |
| `HENON` | Henon map attractor plotted point by point | Tight |
| `HIGHLIFE` | Life variant B36/S23 with self-replicators | Tight |
| `IRQLAB` | Change the raster IRQ line and watch the split move | Tight |
| `ISING` | Ising spin model with adjustable temperature | Stretch |
| `KEYMAP` | Live 8x8 keyboard matrix lighting up as keys are pressed | Easy |
| `LFSR` | Watch a linear feedback shift register's bits cycle | Easy |
| `LIFE` | Conway's Game of Life on the text screen; SPACE reseeds | Tight |
| `LOGISTIC` | Logistic map bifurcation diagram | Tight |
| `LORENZ` | Lorenz attractor traced in projection | Stretch |
| `MAZESOLV` | Wall-follower solving a random maze step by step | Tight |
| `NOISE` | SID noise oscillator values plotted as dots | Easy |
| `PENDULUM` | Swinging pendulum with adjustable length | Tight |
| `PERCOLAT` | Random grid fill; test whether water percolates through | Tight |
| `PREDPREY` | Foxes-and-rabbits population simulation on a grid | Stretch |
| `PRISONER` | Iterated prisoner's dilemma tournament between simple strategies | Tight |
| `PROJECTL` | Plot projectile paths for different launch angles | Tight |
| `QSORTVIZ` | Quicksort visualization with the pivot highlighted | Stretch |
| `RASTER` | Move a raster color split with keys to see where timing lands | Easy |
| `REACTDIF` | Reaction-diffusion spots and stripes on a coarse grid | Stretch |
| `RNGTEST` | Plot jiffy byte, SID noise and an LFSR side by side | Tight |
| `RPSLIFE` | Rock-paper-scissors automaton forming spirals | Tight |
| `RULE30` | Elementary cellular automaton; keys cycle through all 256 rules | Tight |
| `SANDPILE` | Abelian sandpile topples into fractal patterns | Tight |
| `SCHELL` | Schelling neighborhood-preference model on a grid | Tight |
| `SCROLLX` | Adjust the VIC fine-scroll registers with keys | Easy |
| `SEEDS` | Seeds automaton exploding outward | Easy |
| `SHUFFLE` | Fisher-Yates shuffle visualized on bars | Easy |
| `SIDLAB` | Pick waveform, pitch and pulse width with keys and hear them | Tight |
| `SNOWCRYS` | Crystal-growth automaton forming six-sided flakes | Tight |
| `SORTVIZ` | Bars of random heights sorted live, with reshuffle | Tight |
| `SPRCOLL` | Two sprites and the collision register shown live | Easy |
| `SPRING` | Mass on a spring with adjustable damping | Tight |
| `SPRPRIO` | Toggle sprite-background priority to see layering | Easy |
| `STACKVIZ` | Watch the 6502 stack page as subroutines push and pop | Easy |
| `TIMERS` | Show CIA timer A counting down | Easy |
| `TRAFFIC` | Rule 184 traffic flow with jams forming and dissolving | Easy |
| `TURMITE` | Two-state turmites with selectable rules | Tight |
| `VICBANK` | Switch VIC banks and screen pointers interactively | Tight |
| `VOTER` | Voter model: cells copy random neighbors until consensus | Easy |
| `WALK` | Random walker leaving a colored trail | Easy |
| `WAVES1D` | Wave equation on a string; pluck it with a key | Tight |
| `WIREWRLD` | Wireworld automaton running a preset circuit | Stretch |
| `ZEROPAGE` | Live view of zero page changing | Easy |

## SOUND

48 ideas.

| Name | Description | Fit |
| --- | --- | --- |
| `ALARM` | Wake-up alarm patterns | Easy |
| `ARPEGGIO` | Fast arpeggiated chords in the classic C64 style | Easy |
| `BASSLINE` | Looping acid-style bassline with a filter sweep | Tight |
| `BEEPER` | Click and beep feedback for every key typed | Easy |
| `BELLS` | Ringing bell tones through the filter | Easy |
| `BIRDSONG` | Random chirping birds | Tight |
| `CHIPTUNE` | Short looping tune from a compact note table | Tight |
| `CHORDS` | Pick a chord type and hear it played | Tight |
| `CLOCKTIK` | Ticking clock with an hourly chime | Easy |
| `COINSND` | Arcade coin and power-up jingles | Easy |
| `CRICKETS` | Night crickets | Easy |
| `DIGI` | Play a tiny 4-bit sample through the volume register | Tight |
| `DOORBELL` | Ding-dong chime | Easy |
| `DRONE` | Evolving three-voice ambient drone | Easy |
| `DRUMS` | Number keys trigger kick, snare and hi-hat | Tight |
| `DTMF` | Number keys play touch-tone dual frequencies on two voices | Tight |
| `ECHO` | Simulated echo by retriggering a voice at falling volume | Tight |
| `ENGINE` | Engine revving under key-controlled throttle | Easy |
| `EXPLODE` | Noise explosions with decay | Easy |
| `FILTERS` | Sweep filter cutoff and resonance with keys | Tight |
| `GREENSL` | Greensleeves melody on a plucked voice | Tight |
| `KLAXON` | Car horns and klaxons | Easy |
| `LASERSFX` | Gallery of laser and zap sound effects | Easy |
| `MINUET` | A few bars of the public-domain Minuet in G | Tight |
| `MORSE` | Type text and hear it sent in Morse code | Tight |
| `MUSICBOX` | Twinkle Twinkle played like a music box | Tight |
| `OCEANSND` | Waves crashing via filter sweeps | Easy |
| `ODETOJOY` | Beethoven's Ode to Joy melody | Tight |
| `ORGAN` | Three-voice chords played from the keyboard | Tight |
| `PHONERNG` | Classic bell-telephone ring cadence | Easy |
| `PIANO` | Keyboard plays notes on SID voice 1 | Easy |
| `RAINSND` | Rain on a window from random noise drips | Easy |
| `RANDMEL` | Random pentatonic melody generator | Easy |
| `RINGMOD` | Demonstrate ring modulation between voices | Easy |
| `ROTARY` | Rotary-dial pulse clicks for each digit pressed | Tight |
| `SCALES` | Play major, minor and blues scales | Easy |
| `SEQUENCR` | 16-step drum sequencer with a looping cursor | Stretch |
| `SIREN` | Police siren sweep | Easy |
| `SWEEP` | Frequency sweep across the audible range | Easy |
| `SYNCDEMO` | Hard-sync sweep sound | Easy |
| `THEREMIN` | Joystick or paddle controls pitch and volume | Easy |
| `TONEGEN` | Test tone with adjustable frequency | Easy |
| `TRAINSND` | Steam train chugging with a whistle | Easy |
| `TUNER` | Reference pitches for tuning instruments | Easy |
| `VIBRATO` | Vibrato and tremolo depth controlled by keys | Easy |
| `WAVESHOW` | Hear a waveform and see its shape drawn | Tight |
| `WIND` | Filtered noise wind that gusts | Easy |
| `WINDCHM` | Random wind chime tones | Easy |

## TOYS

42 ideas.

| Name | Description | Fit |
| --- | --- | --- |
| `BALLPIT` | Many balls bouncing around the screen | Easy |
| `BINCLOCK` | Binary clock with LED-style dots | Easy |
| `BUBBLES` | Bubbles float upward and pop on a key press | Easy |
| `CALENDAR` | Month calendar for any year and month | Tight |
| `CATEYES` | A pair of eyes that follow the cursor | Easy |
| `CLOCKFC` | Analog clock face with moving hands | Tight |
| `CONFETTI` | Confetti burst on every key press | Easy |
| `DIGCLOCK` | Big digital clock driven by the TOD clock | Easy |
| `DOMINO` | A domino chain toppling across the screen | Tight |
| `DOODLE` | Two keys per axis draw a continuous line; shake to clear | Easy |
| `FACES` | Random faces with different expressions | Easy |
| `FIDGET` | Spinner that speeds up with key taps and slowly winds down | Easy |
| `FISHFEED` | Drop food and watch fish swim to it | Easy |
| `FLOWERS` | Random flowers bloom across the screen | Easy |
| `FORTUNE` | Random fortune-cookie sayings from a short list | Tight |
| `GROWVINE` | Vines grow and curl across the screen | Easy |
| `HOURGLAS` | Sand falling through an hourglass timer | Tight |
| `KALEIDDR` | Joystick drawing reflected eight ways | Tight |
| `KITE` | Fly a kite in gusty wind | Easy |
| `MARBLE` | Marble rolls down ramps you place | Tight |
| `MIRRORDR` | Draw in one quadrant and see it mirrored into four | Tight |
| `MOBILE` | Hanging mobile swaying gently | Tight |
| `MOON` | Moon phase for an entered date | Tight |
| `NAMEGEN` | Random fantasy names built from syllables | Tight |
| `ORACLE` | Ask a yes/no question and get a random answer | Easy |
| `PAINT` | Draw and flood-fill with eight colors | Tight |
| `PEGBOARD` | Place glowing pegs on a dark grid | Easy |
| `PET` | Virtual pet: feed it and play before it gets grumpy | Tight |
| `POPCORN` | Kernels pop around the screen | Easy |
| `RAINBOW` | Typed letters cycle through colors | Easy |
| `SIGNMAKR` | Type a word and see it in huge letters | Tight |
| `SKETCH` | Draw on the text screen with the joystick | Easy |
| `SNOWFLK` | Build a random six-fold snowflake | Tight |
| `SPARKLER` | Joystick-driven sparkler that leaves glitter | Easy |
| `SPINNER` | Random spinner for picking turns in board games | Easy |
| `SPINTOP` | Spinning top that wobbles as it slows | Easy |
| `SPIRO` | Rolling-circle curves from adjustable gear ratios | Tight |
| `STAMPS` | Stamp PETSCII shapes anywhere on the screen | Easy |
| `TEAMPICK` | Randomly split players into two teams | Easy |
| `TREE` | Recursive fractal tree that grows branch by branch | Tight |
| `WINDMILL` | Windmill that spins while you hold a key | Easy |
| `ZOETROPE` | Spin a strip of frames into a looping animation | Easy |

## MATH

51 ideas.

| Name | Description | Fit |
| --- | --- | --- |
| `ARMSTRNG` | Find narcissistic (Armstrong) numbers | Easy |
| `BARNSLEY` | Barnsley fern from fixed-point affine maps | Stretch |
| `BASECONV` | Convert numbers between bases 2-16 | Easy |
| `BIGADD` | Add two 40-digit numbers | Tight |
| `BINCOUNT` | Binary counter on eight lights | Easy |
| `BINOMIAL` | Binomial coefficients row by row | Tight |
| `CANTOR` | Cantor set bars | Easy |
| `CATALAN` | Catalan numbers with multi-byte arithmetic | Tight |
| `CIRCLE` | Bresenham circle drawing | Easy |
| `COLLATZ` | Enter a number and watch its Collatz sequence | Easy |
| `DIGROOT` | Digital root of any number | Easy |
| `DIVISORS` | List the divisors of any number | Easy |
| `DRAGON` | Dragon curve folding pattern | Tight |
| `EDIGITS` | Spigot algorithm printing digits of e | Tight |
| `FACTOR` | Factor any 16-bit number into primes | Tight |
| `FACTORL` | Factorials with multi-byte arithmetic | Tight |
| `FIB` | Fibonacci numbers up to the 16-bit limit | Easy |
| `GCD` | Greatest common divisor by Euclid's algorithm, step by step | Easy |
| `GOLDEN` | Sunflower dot pattern from the golden angle | Tight |
| `GRAYCODE` | Gray code counter showing single-bit changes | Easy |
| `HAPPY` | Find happy numbers | Easy |
| `HILBERT` | Hilbert curve drawn in characters | Tight |
| `JULIA` | Julia set in characters | Stretch |
| `KAPREKAR` | Kaprekar's routine converging to 6174 | Easy |
| `KOCH` | Koch snowflake iterations | Tight |
| `LINES` | Bresenham lines radiating from the center | Easy |
| `LOOKSAY` | Look-and-say sequence | Tight |
| `LUCAS` | Lucas numbers alongside Fibonacci | Easy |
| `MAGICSQ` | Generate an odd-order magic square | Tight |
| `MANDEL` | Mandelbrot set in 40x25 characters with fixed-point math | Stretch |
| `MODCLOCK` | Modular arithmetic on a clock face | Easy |
| `MULTAB` | Multiplication table grid | Easy |
| `PALINDRM` | Reverse-and-add palindrome search | Easy |
| `PASCAL` | Pascal's triangle with odd entries colored | Easy |
| `PERFECT` | Find perfect numbers up to 65535 | Tight |
| `PERMUTE` | List every permutation of the letters ABCD | Tight |
| `PI` | Monte Carlo estimate of pi from random dots | Tight |
| `PIDIGITS` | Spigot algorithm printing digits of pi | Stretch |
| `PLOTFN` | Plot a sine curve with adjustable amplitude | Tight |
| `POWERS2` | Powers of two to many digits | Tight |
| `PRIMES` | Sieve of Eratosthenes marking primes on screen | Easy |
| `PRIMSPIR` | Ulam prime spiral | Tight |
| `PYTHTRIP` | Find Pythagorean triples | Easy |
| `ROMAN` | Convert numbers to Roman numerals | Tight |
| `SIERPCAR` | Sierpinski carpet | Tight |
| `SINTABLE` | Build and display a sine table without ROM math | Easy |
| `SQRT` | Integer square roots by Newton's method | Tight |
| `SQUARES` | Visual proof that sums of odd numbers make squares | Easy |
| `TIMESTBL` | Times-table circle connecting n to k*n mod m | Tight |
| `TOTIENT` | Euler's totient of any number | Tight |
| `TRIANGNU` | Triangular numbers drawn as dot triangles | Easy |

## EDU

37 ideas.

| Name | Description | Fit |
| --- | --- | --- |
| `ALPHABET` | Press A to Z in order against the clock | Easy |
| `ANGLES` | Estimate the angle of a drawn line | Tight |
| `BINQUIZ` | Convert the shown binary number to decimal | Easy |
| `BITOPS` | AND/OR/XOR quiz on bytes | Tight |
| `CLOCKQZ` | Read the analog clock and type the time | Tight |
| `COLORS` | Name the color shown with a number key | Easy |
| `COMPASS` | Name the compass direction of an arrow | Easy |
| `COUNTING` | Count the dots shown and type the number | Easy |
| `DAYSWK` | Which weekday comes next? drill | Easy |
| `DIVQUIZ` | Division facts drill with remainders | Easy |
| `ESTIMATE` | Guess how many dots flashed for an instant | Easy |
| `FRACTION` | Identify the fraction shown as a shaded bar | Tight |
| `GRAPHPT` | Plot an (x,y) point and check it | Easy |
| `GREATER` | Choose which of two numbers is larger | Easy |
| `HEXQUIZ` | Hex-to-decimal drill | Easy |
| `INTERVAL` | Ear training: identify musical intervals | Tight |
| `KEYFIND` | Find and press the highlighted key | Easy |
| `LOGIC` | Toggle inputs to explore logic gate truth tables | Easy |
| `MAPGRID` | Find a coordinate on a lettered grid | Easy |
| `MATHQUIZ` | Random addition and subtraction drill with a score | Easy |
| `MEASURE` | Estimate the length of a bar in characters | Easy |
| `MONEY` | Count coins to make a target total | Tight |
| `MORSEQZ` | Hear a Morse letter and type it | Tight |
| `NOTEREAD` | Name the note shown on a staff | Tight |
| `NUMLINE` | Place a number on a number line | Easy |
| `ODDEVEN` | Sort numbers into odd or even | Easy |
| `OPCODES` | Quiz on 6502 opcode bytes | Tight |
| `PETSCIIQ` | See a character and guess its code | Easy |
| `PIANOQZ` | Hear a note and name it | Tight |
| `PRIMEQZ` | Is it prime? Yes/no speed round | Easy |
| `RHYTHM` | Tap back a rhythm you hear | Tight |
| `ROUNDING` | Round numbers to the nearest ten | Easy |
| `SEQUENCE` | Find the next number in a pattern | Easy |
| `SHAPEQZ` | Name the shape drawn with a number key | Easy |
| `SQUAREQZ` | Squares of 1-20 flash drill | Easy |
| `TIMESDRL` | Multiplication flashcards with a timer | Easy |
| `TYPETUT` | Typing tutor drilling home-row letters | Tight |
