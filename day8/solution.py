import math

if __name__ == "__main__":
    with open("input.txt") as f:
        lines = f.read().split("\n")
    instructions = lines[0]
    d = {}
    for l in lines[2:]:
        pair = l.split(" = ")
        d[pair[0]] = pair[1][1:-1].split(", ")

    cur = "AAA"
    count = 0
    while cur != "ZZZ":
        for i in instructions:
            count += 1
            cur = d[cur][0 if i == "L" else 1]
            if cur == "ZZZ":
                break
    print(count)

    cur = [k for k in d.keys() if k[-1] == "A"]
    counts = [0 for _ in range(len(cur))]
    while not all([s[-1] == "Z" for s in cur]):
        for i in instructions:
            for idx in range(len(cur)):
                if cur[idx][-1] == "Z":
                    continue
                counts[idx] += 1
                cur[idx] = d[cur[idx]][0 if i == "L" else 1]
            if all([s[-1] == "Z" for s in cur]):
                break
    print(math.lcm(*counts))