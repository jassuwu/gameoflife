package main

import (
	"fmt"
	"math/rand"
	"os"
	"os/exec"
	"os/signal"
	"runtime"
	"syscall"
	"time"

	"golang.org/x/term"
)

// STEPS:
// [x] Get the terminal dimensions
// [x] Define the structure of the grid and initialize randomly
// [x] Write the next grid computation with the GOL rules.
// [x] Infinitely loop the GOL generations
// [x] VOILA! CONWAY's GAME OF LIFE BABYYYY

func assert(condition bool, message string) {
	if !condition {
		panic(message)
	}
}

func hideCursor() {
	// ANSI escape sequence to hide the cursor
	fmt.Print("\033[?25l")
}

func showCursor() {
	// ANSI escape sequence to show the cursor
	fmt.Print("\033[?25h")
}

func ClearScreen() {
	var cmd *exec.Cmd
	switch runtime.GOOS {
	case "windows":
		cmd = exec.Command("cmd", "/c", "cls")
	default:
		cmd = exec.Command("clear")
	}
	cmd.Stdout = os.Stdout
	cmd.Run()
}

const (
	DEAD                   = ' '
	ALIVE                  = '■' // Use something blocky: ■ or #
	TIME_DELAY_BETWEEN_GEN = 50 * time.Millisecond
)

type Grid struct {
	R, C   int
	values [][]rune
}

func NewGrid() *Grid {
	COLS, ROWS, err := term.GetSize(0)
	// COLS, ROWS = COLS/2, ROWS/2
	COLS, ROWS = COLS-1, ROWS-1
	assert(err == nil, "error when getting the terminal size")
	values := make([][]rune, ROWS)
	for r := range ROWS {
		row := make([]rune, COLS)
		for c := range COLS {
			// Randomly initialize the cell as ALIVE or DEAD.
			if rand.Intn(10) <= 8 {
				row[c] = DEAD
			} else {
				row[c] = ALIVE
			}
		}
		values[r] = row
	}
	return &Grid{R: ROWS, C: COLS, values: values}
}

func (g *Grid) Clone() *Grid {
	// Create a deep clone of the grid.
	newValues := make([][]rune, g.R)
	for r := 0; r < g.R; r++ {
		newValues[r] = make([]rune, g.C)
		copy(newValues[r], g.values[r])
	}
	return &Grid{R: g.R, C: g.C, values: newValues}
}

func (g *Grid) Print() {
	for r := 0; r < g.R; r++ {
		for c := 0; c < g.C; c++ {
			fmt.Printf("%c", g.values[r][c])
		}
		fmt.Println()
	}
}

func getAliveNeighbors(values [][]rune, r, c int) (n int) {
	for _, dR := range []int{-1, 0, 1} {
		for _, dC := range []int{-1, 0, 1} {
			if dR == 0 && dC == 0 {
				continue
			}
			R, C := r+dR, c+dC
			if R >= 0 && R < len(values) && C >= 0 && C < len(values[0]) && values[R][C] == ALIVE {
				n++
			}
		}
	}
	return
}

func ComputeNextGen(g *Grid) (next *Grid) {
	next = g.Clone()
	for r := range g.values {
		for c := range g.values[r] {
			a := getAliveNeighbors(g.values, r, c)
			if g.values[r][c] == ALIVE {
				if a < 2 || a > 3 {
					next.values[r][c] = DEAD
				}
			} else {
				if a == 3 {
					next.values[r][c] = ALIVE
				}
			}
		}
	}
	return
}

func main() {
	hideCursor()

	// Set up channel to listen for interrupt signals
	sigChan := make(chan os.Signal, 1)
	signal.Notify(sigChan, os.Interrupt, syscall.SIGTERM)
	go func() {
		<-sigChan
		// Show the cursor again when the program is interrupted
		showCursor()
		os.Exit(0)
	}()

	// game of life loop
	grid := NewGrid()
	for {
		ClearScreen()
		grid.Print()
		time.Sleep(TIME_DELAY_BETWEEN_GEN)
		grid = ComputeNextGen(grid)
	}
}
