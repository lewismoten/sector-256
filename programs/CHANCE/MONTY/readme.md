# MONTY

A **256-byte** Monty Hall game for the Commodore 64. Open CHANCE, select
MONTY, and press RETURN.

Pick door **1**, **2**, or **3**. The car is placed behind a door before you
pick. Monty opens one of the other doors to show a goat. Press **S** to switch
to the remaining closed door or **K** to keep your first choice. The game shows
whether you won the car or got a goat, then updates the **W** and **L** totals.
Press RETURN to play another round; RUN/STOP returns to the launcher.

The launcher supplies a changing random byte. The game reduces its 1–255
range to three equally sized groups, so each door has the same chance of hiding
the car. Switching wins two thirds of the time over many rounds; keeping wins
one third. Scores remain visible between rounds in the current session and
show three decimal digits.

![Monty Hall game after a goat is revealed](preview.png)
