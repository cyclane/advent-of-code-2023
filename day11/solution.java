import java.io.IOException;
import java.math.BigInteger;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;
import java.util.SortedSet;
import java.util.TreeSet;

class Solution {
    public static void main(String[] args) throws IOException {
        String contents = Files.readString(Path.of("input.txt"));
        String[] lines = contents.split("\n");
        List<Galaxy> galaxies = new ArrayList<Galaxy>();
        SortedSet<Integer> xs = new TreeSet<Integer>();
        SortedSet<Integer> ys = new TreeSet<Integer>();
        for (int x = 0; x < lines[0].length(); x++) {
            xs.add(x);
        }
        for (int y = 0; y < lines.length; y++) {
            ys.add(y);
            for (int x = 0; x < lines[y].length(); x++) {
                char c = lines[y].charAt(x);
                if (c == '#') {
                    galaxies.add(new Galaxy(x, y));
                    ys.remove(y);
                    xs.remove(x);
                }
            }
        }

        // Part 1
        List<Galaxy> galaxiesPart1 = expandSpaces(galaxies, xs, ys, 2);
        int sum1 = 0;
        for (Galaxy g1 : galaxiesPart1) {
            for (Galaxy g2 : galaxiesPart1) {
                sum1 += g1.distance(g2);
            }
        }
        System.out.println(String.format("Part 1: %d", sum1 / 2));

        // Part 2
        List<Galaxy> galaxiesPart2 = expandSpaces(galaxies, xs, ys, 1000000);
        BigInteger sum2 = BigInteger.ZERO;
        for (Galaxy g1 : galaxiesPart2) {
            for (Galaxy g2 : galaxiesPart2) {
                int d = g1.distance(g2);
                sum2 = sum2.add(BigInteger.valueOf(d));
            }
        }
        System.out.println(String.format("Part 2: %d", sum2.divide(BigInteger.TWO)));
    }

    private static List<Galaxy> expandSpaces(Iterable<Galaxy> galaxies, Iterable<Integer> xs, Iterable<Integer> ys, int times) {
        List<Galaxy> newGalaxies = new ArrayList<Galaxy>();
        for (Galaxy g : galaxies) {
            int dx = 0;
            int dy = 0;
            for (Integer x : xs) {
                if (x < g.x) {
                    dx += times - 1;
                } else {
                    break;
                }
            }
            for (Integer y : ys) {
                if (y < g.y) {
                    dy += times - 1;
                } else {
                    break;
                }
            }
            newGalaxies.add(new Galaxy(g.x + dx, g.y + dy));
        }
        return newGalaxies;
    }
}

class Galaxy {
    public int x;
    public int y;
    public Galaxy(int x, int y) {
        this.x = x;
        this.y = y;
    }

    public int distance(Galaxy other) {
        return Math.abs(other.x - x) + Math.abs(other.y - y);
    }
}