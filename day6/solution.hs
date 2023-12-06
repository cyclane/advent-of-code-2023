type Race = (Int, Int)

loadRaces :: String -> [Race]
loadRaces str = zip ts ds
  where
    [ts, ds] = map getNs $ splitStr '\n' str
    getNs :: String -> [Int]
    getNs = map read . filter (not . null) . splitStr ' ' . drop 2 . dropWhile (/=':')

loadRace :: String -> Race
loadRace str = (t, d)
  where
    [t, d] = map getN $ splitStr '\n' str
    getN :: String -> Int
    getN = read . filter (/= ' ') . drop 2 . dropWhile (/= ':')

splitStr :: Char -> String -> [String]
splitStr onC = foldr splitStr' [""]
  where
    splitStr' :: Char -> [String] -> [String]
    splitStr' c (cur:splits)
      | c == onC  = "":cur:splits
      | otherwise = (c:cur):splits

raceOptions :: Race -> Int
raceOptions (t, d) = t + 1 - 2 * head [n | n <- [0..t], n * (t-n) > d]

part1 :: String -> String
part1 = show . product . map raceOptions . loadRaces

part2 :: String -> String
part2 = show . raceOptions . loadRace

main :: IO ()
main = do
  s <- readFile "input.txt"
  putStrLn $ "Part 1: " ++ part1 s
  putStrLn $ "Part 2: " ++ part2 s