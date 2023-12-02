from dataclasses import dataclass

@dataclass
class CubeSet:
    red: int
    green: int
    blue: int

    @classmethod
    def from_str(cls, s: str):
        data = dict([
            (colour, int(count))
            for colour, count in (x.strip().split(" ")[::-1] for x in s.split(","))
        ])
        return cls(
            red = data.get("red", 0),
            green = data.get("green", 0),
            blue = data.get("blue", 0)
        )

    def power(self):
        return self.red * self.green * self.blue


@dataclass
class Game:
    no: int
    cube_sets: list[CubeSet]

    @classmethod
    def from_str(cls, s: str):
        game, cube_sets = [x.strip() for x in s.split(":")]
        return cls(
            no = int(game.split(" ")[1]),
            cube_sets = [CubeSet.from_str(x.strip()) for x in cube_sets.split(";")]
        )

if __name__ == "__main__":
    with open("input.txt") as f:
        games = [Game.from_str(s) for s in f.read().split("\n")]
    print("Part 1:", sum([
        g.no
        for g in games
        if all([
            cs.red <= 12 and cs.green <= 13 and cs.blue <= 14
            for cs in g.cube_sets
        ])
    ]))
    print("Part 2:", sum([
        CubeSet(
            red = max([cs.red for cs in g.cube_sets]),
            green = max([cs.green for cs in g.cube_sets]),
            blue = max([cs.blue for cs in g.cube_sets]),
        ).power()
        for g in games
    ]))