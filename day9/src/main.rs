use std::fs;

fn predict_next(line: &[i32]) -> i32 {
    if line.iter().all(|&n| n == 0) {
        0
    } else {
        let diffs = line.windows(2).into_iter()
            .map(|w| w[1] - w[0])
            .collect::<Vec<_>>();
        line.last().expect("should be a non-empty line") + predict_next(&diffs)
    }
}

fn main() {
    let contents = fs::read_to_string("input.txt")
        .expect("should have read input file")
        .split("\n")
        .map(|line| line.split(" ")
            .map(|s| s.parse::<i32>().expect("should have been an integer"))
            .collect::<Vec<_>>()
        )
        .collect::<Vec<_>>();
    let p1: i32 = contents.iter()
        .map(|line| predict_next(line))
        .sum();
    println!("Part 1: {p1}");
    let p2: i32 = contents.iter()
        .map(|line| predict_next(
            &line.iter().rev().map(|&n| n).collect::<Vec<_>>()
        ))
        .sum();
    println!("Part 2: {p2}");
}
