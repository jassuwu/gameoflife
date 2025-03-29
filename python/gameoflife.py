# STEPS:
# 1. find the dimensions of the terminal
# 2. initialize the grid randomly
# 3. write the nextgencompute function according to GOL rules
# 4. infinite loop and run :)

import os
import random

DEAD                   = " "
ALIVE                  = "■" # Use something blocky: ■ or #

class GOL:
    def __init__(self):
        COLS, ROWS = os.get_terminal_size()
        self.C = COLS
        self.R = ROWS
        self.grid = [[ALIVE if random.random() > 0.8 else DEAD for _ in range(COLS)] for _ in range(ROWS)]

    def print(self):
        for r in range(self.R):
            print("".join(self.grid[r]))

gol = GOL()
gol.print()
