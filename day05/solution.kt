import java.nio.file.Files
import java.nio.file.Path
import kotlin.math.max
import kotlin.math.min

class Mapping(val to: String, private val lines: List<MapLine>) {
    fun get(n: Long): Long =
        lines.firstNotNullOfOrNull { it.get(n) } ?: n

    fun getInterval(interval: Interval): List<Interval> =
        lines.mapNotNull { it.getInterval(interval) }.let { intervals ->
            val result = mutableListOf<Interval>()
            var remaining = listOf(interval)
            for ((f, t) in intervals) {
                remaining = remaining.flatMap { it.difference(f) }
                result.add(t)
            }
            result.addAll(remaining)
            result
        }
}

class MapLine(line: Triple<Long, Long, Long>) {
    private val interval = Interval(line.second, line.second + line.third - 1)
    private val offset = line.first - line.second

    fun get(n: Long): Long? =
        if (interval.start <= n && n <= interval.end) n + offset
        else null

    fun getInterval(i: Interval): Pair<Interval, Interval>? =
        interval.overlap(i)?.let {
            it to it.applyOffset(offset)
        }
}

class Interval(val start: Long, val end: Long) {
    fun overlap(interval: Interval): Interval? {
        val s = max(interval.start, start)
        val e = min(interval.end, end)
        if (s > e) return null
        return Interval(s, e)
    }

    fun difference(interval: Interval): List<Interval> {
        val diffs = mutableListOf<Interval>()
        if (start < interval.start) {
            diffs.add(Interval(start, min(interval.start - 1, end)))
        }
        if (interval.end < end) {
            diffs.add(Interval(max(interval.end + 1, start), end))
        }
        return diffs
    }

    fun applyOffset(offset: Long): Interval =
        Interval(start + offset, end + offset)
}

fun main() {
    val sections = Files.readString(Path.of("input.txt"))
        .split("\n\n")
    val seeds = sections[0].substringAfter(": ")
        .split(' ')
        .map { it.toLong() }
    val mappings = sections.subList(1, sections.size).associate { section ->
        val lines = section.split('\n')
        val (from, to) = lines[0].substringBefore(" map:")
            .split("-to-")
        val map = Mapping(to, lines.subList(1, lines.size).map { line ->
            val (a, b, c) = line.split(' ').map { it.toLong() }
            MapLine(Triple(a, b, c))
        })
        from to map
    }
    val p1 = seeds.minOf { s ->
        var category = "seed"
        var n = s
        while (category != "location") {
            val mapping = mappings[category]!!
            n = mapping.get(n)
            category = mapping.to
        }
        n
    }
    println("Part 1: $p1")

    val p2 = run {
        var category = "seed"
        var intervals = seeds.chunked(2)
            .map { (s, l) -> Interval(s, s + l - 1) }
        while (category != "location") {
            val mapping = mappings[category]!!
            intervals = intervals.flatMap { mapping.getInterval(it) }
            category = mapping.to
        }
        intervals.minOf { it.start }
    }
    println("Part 2: $p2")
}