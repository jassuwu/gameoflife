import os, time, random

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

    def __get_alive_neighbor_count(self, r, c):
        count = 0
        for dr in [-1, 0, 1]:
            for dc in [-1, 0, 1]:
                row, col = r+dr, c+dc
                if row == r and col == c:
                    continue
                if 0 <= row < self.R and 0 <= col < self.C and self.grid[row][col] == ALIVE:
                    count += 1
        return count

    def compute_next_gen(self):
        next_grid = [row[:] for row in self.grid]
        for r in range(len(next_grid)):
            for c in range(len(next_grid[0])):
                alive_count = self.__get_alive_neighbor_count(r, c)
                if self.grid[r][c] == ALIVE:
                    if alive_count < 2 or alive_count > 3:
                        next_grid[r][c] = DEAD
                else:
                    if alive_count == 3:
                        next_grid[r][c] = ALIVE
        self.grid = next_grid

if __name__ == "__main__":
    print("\033[?25l")
    gol = GOL()
    while True:
        os.system('cls' if os.name == 'nt' else 'clear')
        gol.print()
        time.sleep(0)
        gol.compute_next_gen()
