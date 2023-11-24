import {
  chunk,
  map,
  parseRawInput,
  pipe,
  processInputArg,
  reduce,
  reverse,
  slice,
  sort,
  split,
  sum,
  tap,
  trim,
} from "../util.ts";

const [arg, maxRounds = 20] = Deno.args;
const filename = processInputArg(arg);
const inputList = parseRawInput(filename).trim();

const MONKEY_REGEX = /Monkey\s(?<num>\d+):/;
const STARTING_ITEMS_PREFIX = "Starting items: ";
const TEST_LINE_REGEX = /Test: divisible by (?<num>\d+)/;
const THROW_TO_REGEX = /If (?<bool>\w+): throw to monkey (?<num>\d+)/;

const assertPrefix = (prefix) => (str) => {
  if (!str.startsWith(prefix)) {
    throw new Error(
      `Line '${str}' did not contain expected prefix '${prefix}'`,
    );
  }

  return;
};

const castTo = (basedOn, num) =>
  typeof basedOn === "bigint" ? BigInt(num) : num;

const operationMap = {
  "+": (operands) =>
    operands.reduce((acc, e) => acc + e, castTo(operands[0], 0)),
  "-": (operands) =>
    operands.reduce((acc, e) => acc - e, castTo(operands[0], 0)),
  "*": (operands) =>
    operands.reduce((acc, e) => acc * e, castTo(operands[0], 1)),
  "/": (operands) =>
    operands.reduce((acc, e) => acc / e, castTo(operands[0], 1)),
};

const parseMonkey = (arg) => {
  const monkeyIndex = parseMonkeyLine(arg[0]);
  const startingItems = parseStartingItems(arg[1]);
  const [operator, ...operands] = parseOperation(arg[2]);
  const [test, consequence, alternative] = parseTest(arg.slice(3));

  return {
    index: monkeyIndex,
    startingItems,
    throwTo: (val) => {
      if (typeof val === "bigint") {
        return val % BigInt(test) === BigInt(0) ? consequence : alternative;
      }

      return val % test === 0 ? consequence : alternative;
    },
    inspectionCount: 0,
    operation: (old) =>
      operationMap[operator](
        operands.map((op) => op === "old" ? old : castTo(old, op)),
      ),
  };
};

const parseMonkeyLine = (str) => {
  assertPrefix("Monkey ");
  const parsedNumber = str.match(MONKEY_REGEX)?.groups?.num;

  if (parsedNumber === undefined) {
    throw new Error("Invalid Monkey");
  }

  return parseInt(parsedNumber);
};

const parseStartingItems = (line) => {
  assertPrefix(STARTING_ITEMS_PREFIX);

  return pipe([
    split(", "),
    map(pipe([trim, parseInt])),
  ])(line.substring(STARTING_ITEMS_PREFIX.length + 1));
};

const parseOperation = (line) => {
  assertPrefix("Operation: ");

  return pipe([
    trim,
    split(" "),
    map(pipe([
      trim,
      (val) => isNaN(val) ? val : parseInt(val),
    ])),
    ([result, eq, lOp, operator, rOp]) => [operator, lOp, rOp],
  ])(line.substring("Operation: ".length + 1));
};

const parseTest = ([test, consLine, altLine]) => {
  const divisibleBy = parseInt(
    test.match(TEST_LINE_REGEX)?.groups?.num,
    10,
  );
  const consequence = parseInt(consLine.match(THROW_TO_REGEX)?.groups?.num, 10);
  const alternative = parseInt(altLine.match(THROW_TO_REGEX)?.groups?.num, 10);

  return [divisibleBy, consequence, alternative];
};

const parseInstructions = pipe([
  split("\n\n"),
  map(pipe([
    split("\n"),
    parseMonkey,
  ])),
]);

const part1 = () => {
  const compute = () => {
    return pipe([
      parseInstructions,
      (monkies) => {
        let round = 0;

        while (round < maxRounds) {
          for (let [i, monkey] of monkies.entries()) {
            while (monkey.startingItems.length > 0) {
              monkey.inspectionCount++;
              const item = monkey.startingItems.shift();
              const newVal = Math.floor(monkey.operation(item) / 3);
              const destination = monkey.throwTo(newVal);
              monkies[destination].startingItems.push(newVal);
            }
          }

          round++;
        }

        console.log(
          "Here are the monkeys",
          monkies.map((x) => [x.index, x.startingItems]),
        );

        console.log(
          "Most active",
          monkies.map((x) => [x.index, x.inspectionCount]),
        );

        return monkies;
      },
      map(({ inspectionCount }) => inspectionCount),
      sort,
      reverse,
      slice(0, 2),
      reduce((acc, e) => acc * e, 1),
    ])(inputList);
  };

  console.log(`Part 1: Count is "`, compute(), '"');
};

const part2 = () => {
  const compute = () => {
    const promoteToBigInts = (monkies) => {
      monkies.forEach((monkey) => {
        monkey.startingItems = monkey.startingItems.map((item) => BigInt(item));
      });

      return monkies;
    };
    return pipe([
      parseInstructions,
      promoteToBigInts,
      (monkies) => {
        let round = 0;

        while (round < 1000) {
          for (let [i, monkey] of monkies.entries()) {
            while (monkey.startingItems.length > 0) {
              monkey.inspectionCount++;
              const item = monkey.startingItems.shift();
              const newVal = monkey.operation(item);
              const destination = monkey.throwTo(newVal);
              monkies[destination].startingItems.push(newVal);
            }
          }

          round++;
        }

        console.log(
          "Here are the monkeys",
          monkies.map((x) => [x.index, x.startingItems]),
        );

        console.log(
          "Most active",
          monkies.map((x) => [x.index, x.inspectionCount]),
        );

        monkies.forEach((x) => {
          console.log(
            `Monkey ${x.index} inspected items ${x.inspectionCount} times`,
          );
        });
        return monkies;
      },
      map(({ inspectionCount }) => inspectionCount),
      sort,
      reverse,
      slice(0, 2),
      reduce((acc, e) => acc * e, 1),
    ])(inputList);
  };
  console.log(`Part 2: Count is "`, compute());
};

part1();
part2();
