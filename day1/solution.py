#!/usr/bin/env python3.12
from typing import Iterable

def first_digit(s: str):
    for idx, c in enumerate(s):
        if "0" <= c <= "9":
            return idx, int(c)

def first_word(s: str, words: list[str]):
    indexes = [(s.find(w), w) for w in words]
    try:
        midx = min([idx for idx in indexes if idx[0] != -1])
        return midx[0], words.index(midx[1]) + 1
    except ValueError:
        return None
    
def not_null[T](i: Iterable[T | None]):
    return [a for a in i if a is not None]

digits = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
rdigits = [d[::-1] for d in digits]

if __name__ == "__main__":
    with open("input.txt") as f:
        lines = [l for l in f.read().split("\n") if l != ""]
    print("Part 1:", sum([
        first_digit(line)[1] * 10 + first_digit(line[::-1])[1]
        for line in lines
    ]))
    print("Part 2:", sum([
        min(not_null([first_digit(line), first_word(line, digits)]))[1] * 10 +
            min(not_null([first_digit(rline := line[::-1]), first_word(rline, rdigits)]))[1]
        for line in lines
    ]))