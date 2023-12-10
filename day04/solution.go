package main

import (
	"errors"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func noErr(err error) {
	if err != nil {
		panic(err)
	}
}

func main() {
	// parsing
	input, err := os.ReadFile("input.txt")
	noErr(err)
	lines := strings.Split(string(input), "\n")
	cards := make([]Card, len(lines))
	cardCounts := map[int]int{}
	for idx, l := range lines {
		card, err := LineToCard(l)
		noErr(err)
		cards[idx] = card
		cardCounts[card.Id] = 1
	}

	// part 1
	s := 0
	for _, c := range cards {
		s += c.Points()
	}
	println("Part 1:", s)

	// part 2
	t := 0
	for _, c := range cards {
		t += cardCounts[c.Id]
		for n := 1; n <= c.Wins(); n++ {
			_, exists := cardCounts[c.Id+n]
			if exists {
				cardCounts[c.Id+n] += cardCounts[c.Id]
			}
		}
	}
	println("Part 2:", t)
}

type Card struct {
	Id        int
	WinningNs []int
	MyNs      []int
}

func (card Card) Wins() int {
	c := 0
	for _, w := range card.WinningNs {
		for _, n := range card.MyNs {
			if w == n {
				c++
			}
		}
	}
	return c
}

func (card Card) Points() int {
	// math.Pow with into to float conversion feels wrong
	p := 1
	for _, w := range card.WinningNs {
		for _, n := range card.MyNs {
			if w == n {
				p *= 2
			}
		}
	}
	if p == 1 {
		return 0
	}
	return p / 2
}

var NoCutErr = errors.New("no cut found")

func LineToCard(line string) (Card, error) {
	cardIdStr, nStr, f := strings.Cut(line, ":")
	if !f {
		return Card{}, fmt.Errorf("cut ':': %w", NoCutErr)
	}
	_, idStr, f := strings.Cut(cardIdStr, " ")
	if !f {
		return Card{}, fmt.Errorf("cut ' ': %w", NoCutErr)
	}
	id, err := strconv.Atoi(strings.TrimSpace(idStr))
	if err != nil {
		return Card{}, fmt.Errorf("card id: %w", err)
	}
	cardNStrs, myNStrs, f := strings.Cut(nStr, "|")
	if !f {
		return Card{}, fmt.Errorf("cut '|': %w", NoCutErr)
	}
	cardNs, err := strToNumbers(cardNStrs)
	if err != nil {
		return Card{}, fmt.Errorf("card ns: %w", err)
	}
	myNs, err := strToNumbers(myNStrs)
	if err != nil {
		return Card{}, fmt.Errorf("my ns: %w", err)
	}
	return Card{
		Id:        id,
		WinningNs: cardNs,
		MyNs:      myNs,
	}, nil
}

func strToNumbers(str string) ([]int, error) {
	nStrs := strings.Split(str, " ")
	ns := make([]int, 0)
	for _, nStr := range nStrs {
		if nStr == "" {
			continue
		}
		n, err := strconv.Atoi(strings.TrimSpace(nStr))
		if err != nil {
			return nil, err
		}
		ns = append(ns, n)
	}
	return ns, nil
}
