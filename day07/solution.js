const fs = require("fs/promises");

const order = ["A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2"];
const newOrder = ["A", "K", "Q", "T", "9", "8", "7", "6", "5", "4", "3", "2", "J"];

/**
 * @param {string[]} hand
 * @param {boolean} useJoker
 */
function handType(hand, useJoker = false) {
    function eq(v) {
        return c => c === v || useJoker && c === "J";
    }
    const s = new Set(useJoker ? hand.filter(c => c !== "J") : hand);
    if (s.size === 1 || s.size === 0) { // 0 if JJJJJ and useJoker == true
        return 0;
    } else if (s.size === 2) {
        let m = -1;
        for (const v of s.values()) {
            const count = hand.filter(eq(v)).length;
            if (count > m) m = count;
        }
        if (m === 4) {
            return 1;
        }
        return 2;
    } else if (s.size === 3) {
        let m = -1;
        for (const v of s.values()) {
            const count = hand.filter(eq(v)).length;
            if (count > m) m = count;
        }
        if (m === 3) {
            return 3;
        }
        return 4;
    } else if (s.size === 4) {
        return 5;
    }
    return 6;
}

/**
 * @param {string[]} h1
 * @param {string[]} h2
 * @param {boolean} useJoker
 */
function cmpHands(h1, h2, useJoker = false) {
    const [t1, t2] = [handType(h1, useJoker), handType(h2, useJoker)];
    if (t1 !== t2) return t1 - t2;
    for (let idx = 0; idx < h1.length; idx++) {
        const [v1, v2] = [h1[idx], h2[idx]];
        if (v1 !== v2) {
            return useJoker ? newOrder.indexOf(v1) - newOrder.indexOf(v2)
                : order.indexOf(v1) - order.indexOf(v2);
        }
    }
    return 0;
}

/**
 * @param {{hand: string[], bid: number}[]} hands
 */
function totalWinnings(hands) {
    return hands.map((h, idx) => h.bid * (idx + 1))
        .reduce((p, c) => p + c)
}

async function main() {
    const lines = await fs.readFile("input.txt", {encoding: "utf8"})
        .then(s => s.split("\n"));
    const hands = lines.map(l => {
        const [h, b] = l.split(" ");
        return {
            hand: h.split(""),
            bid: Number(b)
        };
    });
    hands.sort((h1, h2) => cmpHands(h2.hand, h1.hand));
    console.log("Part 1:", totalWinnings(hands));
    hands.sort((h1, h2) => cmpHands(h2.hand, h1.hand, true));
    console.log("Part 2:", totalWinnings(hands));
}

main();