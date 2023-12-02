import {
  filter,
  getInput,
  last,
  map,
  pipe,
  reduce,
  split,
  sum,
  tap,
} from "../util.ts";

const possibleSet = {
  blue: 14,
  green: 13,
  red: 12,
};

const parseLine = pipe([
  split(": "),
  last,
  split("; "),
  map(pipe([
    split(", "),
    map(pipe([
      split(" "),
      ([quantity, color]) => [parseInt(quantity, 10), color],
    ])),
    (arr) => {
      return arr.reduce((acc, [quantity, color], i) => {
        acc[color] = parseInt(quantity, 10);

        return acc;
      }, {});
    },
  ])),
]);

const part1 = () => {
  const result = pipe([
    getInput,
    map(parseLine),
    reduce((acc, sets, i) => {
      const valid = !sets.some((obj) => {
        return Object.keys(possibleSet).some((key) =>
          (obj[key] || 0) > possibleSet[key]
        );
      });

      if (valid) {
        acc.push(i + 1);
      }

      return acc;
    }, []),
    sum,
  ])(Deno.args[0]);

  console.log("Part 1:", result);
};

const part2 = () => {
  const result = pipe([])(Deno.args[0]);

  console.log("Part 2:", result);
};

part1();
part2();
