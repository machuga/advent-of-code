const args = Deno.args;
const [arg = "--sample"] = args[0];

export const pipe = (fns: Function[]) => (x: unknown) =>
  fns.reduce((v, f) => f(v), x);

export const map =
  (fn: (el: unknown, index?: number) => unknown) => (arr: unknown[]) =>
    arr.map(fn);

// @ts-ignore: No
export const reduce = (fn, init) => (arr) => arr.reduce(fn, init);

export const processInputArg = (arg: string | number) => {
  switch (arg) {
    case "--input":
      return "input.txt";
    case "--sample":
      return "sample.txt";
    case "--sample-2":
      return "sample-2.txt";
    default:
      return "sample.txt";
  }
};

const filename = processInputArg(arg);
export const parseRawInput = (filename) => Deno.readTextFileSync(filename);

export const parseInput = (filename = "sample.txt") =>
  parseRawInput(filename).split("\n").filter(Boolean);

const getInput = pipe([
  processInputArg,
  parseInput,
]);

const part1 = () => {
  const result = pipe([
    getInput,
    map((str) => str.replace(/[^\d]+/g, "")),
    map((str) => parseInt(str[0] + str[str.length - 1], 10)),
    reduce((acc, num) => acc + num, 0),
  ])(Deno.args[0]);

  console.log("Part 1:", result);
};

const part2 = () => {
  const NUM_REGEX = /(?=(\d|one|two|three|four|five|six|seven|eight|nine))/gi;
  const table = {
    one: "one1one",
    two: "two2two",
    three: "three3three",
    four: "four4four",
    five: "five5five",
    six: "six6six",
    seven: "seven7seven",
    eight: "eight8eight",
    nine: "nine9nine",
  };
  const result = pipe([
    getInput,
    map((str) => str.replaceAll(NUM_REGEX, (match, term) => table[term])),
    map((str) => str.replaceAll(/[^\d]+/g, "")),
    map((str) => parseInt(str[0] + "" + str[str.length - 1], 10)),
    reduce((acc, num) => acc + num, 0),
  ])(Deno.args[0]);

  console.log("Part 2:", result);
};

part1();
part2();
