package main

import (
	"fmt"
	"math/rand"

	"golang.org/x/term"
)

// STEPS:
// [x] Get the terminal dimensions
// [x] Define the structure of the grid and initialize randomly
// [ ] Write the next grid computation with the GOL rules.
// [ ] Infinitely loop the GOL generations
// [ ] VOILA! CONWAY's GAME OF LIFE BABYYYY

func assert(condition bool, message string) {
	if !condition {
		panic(message)
	}
}

const (
	DEAD  = ' '
	ALIVE = '#'
)

type Grid struct {
	R, C   int
	values [][]rune
}

func NewGrid() *Grid {
	COLS, ROWS, err := term.GetSize(0)
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

func (g *Grid) Print() {
	for r := 0; r < g.R; r++ {
		for c := 0; c < g.C; c++ {
			fmt.Printf("%c", g.values[r][c])
		}
		fmt.Println()
	}
}

func main() {
	grid := NewGrid()
	grid.Print()
}
