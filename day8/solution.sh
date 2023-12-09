#!/bin/bash

declare -A mappings

gcd() {
    local a=$1
    local b=$2
    while [ $b -ne 0 ]
    do
        local t=$b
        b=$(($a % $b))
        a=$t
    done
    echo ${a#-}
}

lcm() {
    local d=$(gcd $1 $2)
    echo $(($1 * $2 / $d))
}

findcount() {
    cur=$1
    instructions=$2
    pattern=$3
    count=0
    while [[ $cur != $pattern ]]
    do
        for (( idx = 0; idx < ${#instructions}; idx++ ))
        do
            ((count += 1))
            instruction=${instructions:$idx:1}
            part=0
            if [ $instruction = "R" ]
            then
                part=4
            fi
            mapping=${mappings[$cur]}
            cur=${mapping:$part:3}
            if [[ $cur == $pattern ]]
            then
                break
            fi
        done
    done
    echo $count
}

# Parse inputs
file="input.txt"
instructions=$(head -n1 $file)

while read line || [ -n "$line" ]
do
    key=${line%% *}
    values=${line##*(}
    values=${values%)}
    mappings[$key]=${values/,/}
done <<< $(tail -n +3 $file)

# Part 1
echo "Part 1: $(findcount "AAA" $instructions "ZZZ")"

# Part 2
count=1
for key in ${!mappings[@]}
do
    if [[ $key != *A ]]
    then
        continue
    fi
    cur=$key
    count=$(lcm $count $(findcount $cur $instructions *Z))
done
echo "Part 2: $count"