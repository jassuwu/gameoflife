package main

import (
	"fmt"

	"golang.org/x/term"
)

// STEPS:
// [x] Get the terminal dimensions
// [ ] Define the structure of the grid and initialize randomly
// [ ] Write the next grid computation with the GOL rules.
// [ ] Infinitely loop the GOL generations
// [ ] VOILA! CONWAY's GAME OF LIFE BABYYYY

func assert(condition bool, message string) {
	if !condition {
		panic(message)
	}
}

func main() {
	COLS, ROWS, err := term.GetSize(0)
	assert(err == nil, "error when getting the terminal size")
	fmt.Println(ROWS, COLS)
}
