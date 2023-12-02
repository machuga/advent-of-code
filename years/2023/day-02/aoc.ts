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
  const result = pipe([
    getInput,
    map(parseLine),
    map(pipe([
      // Damn closure scoping forcing me to do this at the moment.  The reduce
      // initializer value will be captured as a literal and will cause weird
      // behavior if this is not wrapped in another execution context
      (game) =>
        reduce((acc, set) => {
          Object.keys(possibleSet).forEach((color) => {
            if (set[color] > acc[color]) {
              acc[color] = set[color];
            }
          });
          return acc;
        }, { blue: 0, green: 0, red: 0 })(game),
      (game) =>
        Object.keys(possibleSet).reduce(
          (acc, color) => acc * (game[color] || 1),
          1,
        ),
    ])),
    sum,
  ])(Deno.args[0]);

  console.log("Part 2:", result);
};

part1();
part2();
