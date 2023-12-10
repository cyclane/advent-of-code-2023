async function loadInput(filename: string) {
  const decoder = new TextDecoder("utf-8");
  const contents = await Deno.readFile(filename);
  return decoder.decode(contents);
}

function toSubComponents(l: string) {
  const components: [number, string][] = [];
  let current = "";
  let idx = 0;
  for (const c of l) {
    if (
      current.length === 0 ||
      !Number.isNaN(Number(current[0])) && !Number.isNaN(Number(c))
    ) {
      current += c;
    } else {
      components.push([idx - current.length, current]);
      current = c;
    }
    idx++;
  }
  components.push([idx - current.length, current]);
  return components;
}

type Component = [number, number, string];

/**
 * Checks whether two components are adjacent
 * @param c1 First component.
 * @param c2 Second component.
 */
function isAdjacent([y1, x1, s1]: Component, [y2, x2, s2]: Component) {
  const [l1, l2] = [s1.length, s2.length];
  // end x positions
  const [x1e, x2e] = [x1 + l1 - 1, x2 + l2 - 1];
  return (y1 === y2 - 1 || y1 === y2 + 1) && (
        (x1 - 1 <= x2 && x2 <= x1e + 1) ||
        (x1 - 1 <= x2e && x2e <= x1e + 1) ||
        (x2 <= x1 - 1 && x1e + 1 <= x2e)
      ) || (y1 === y2) && (x2e === x1 - 1 || x2 === x1e + 1);
}

function isPartNumber(
  components: Component[],
  component: Component,
) {
  return Boolean(
    components.find((c) => isAdjacent(component, c) && c[2] !== "."),
  );
}

function gearRatio(
  components: Component[],
  component: Component,
) {
  if (component[2] !== "*") return null;
  const numbers = components
    .filter((c) => isAdjacent(component, c))
    .map(([, , s]) => Number(s))
    .filter((n) => !Number.isNaN(n));
  if (numbers.length === 2) {
    return numbers[0] * numbers[1];
  }
  return null;
}

async function main() {
  const lines = await loadInput("input.txt").then((s) => s.split("\n"));
  const components = lines.map(toSubComponents)
    .flatMap((cs, idx) => cs.map((c) => [idx, c[0], c[1]] as Component));
  const numbers = components.filter(([, , s]) => !Number.isNaN(Number(s)));
  const fnumbers = numbers.filter((c) => isPartNumber(components, c));
  console.log(
    "Part 1:",
    fnumbers.map(([, , s]) => Number(s)).reduce((p, c) => p + c),
  );
  const gears = components
    .map((c) => gearRatio(components, c))
    .filter((c) => c !== null) as number[];
  console.log("Part 2:", gears.reduce((p, c) => p + c));
}

await main();
