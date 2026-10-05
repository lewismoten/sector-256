# HILO

HILO shows one card rank and asks whether the next randomly selected rank will
be higher or lower. Press `H` for higher or `L` for lower. Correct guesses add
to the score and move on to the next card; ties count as losses. Press RETURN
after a loss to begin a new game.

Card ranks run from A through K. The launcher random-byte service picks each
rank, and RUN/STOP returns to the Sector 256 launcher.

The game is stored in a single 256-byte disk block.
