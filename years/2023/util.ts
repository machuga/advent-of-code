export const processInputArg = (arg: string) => {
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

export const parseRawInput = (filename) => Deno.readTextFileSync(filename);

export const parseInput = (filename = "sample.txt") =>
  parseRawInput(filename).split("\n").filter(Boolean);

export const getInput = (arg = Deno.args[0] || "") =>
  pipe([
    processInputArg,
    parseInput,
  ])(arg);

export const last: { <T>(arr: T[]): T } = (arr) => arr[arr.length - 1];

export const toInt = (str: string) => parseInt(str, 10);

export const split = (separator: string) => (str: string) =>
  str.split(separator);

export const trim = (str: string) => str.trim();

export const join = (separator: string) => (arr: string[]) =>
  arr.join(separator);

export const pipe = (fns: Function[]) => (x: unknown) =>
  fns.reduce((v, f) => f(v), x);

export const flatMap =
  (fn: (el: unknown, index?: number) => unknown) => (arr: unknown[]) =>
    arr.flatMap(fn);

export const map =
  (fn: (el: unknown, index?: number) => unknown) => (arr: unknown[]) =>
    arr.map(fn);

export const filter =
  (fn: (el: unknown, index?: number) => unknown) => (arr: unknown[]) =>
    arr.filter(fn);

// @ts-ignore: No
export const reduce = (fn, init) => (arr) => arr.reduce(fn, init);

export const find =
  (fn: (el: unknown, index?: number) => unknown) => (arr: unknown[]) =>
    arr.find(fn);

export const sum = (arr: unknown[]) =>
  // @ts-ignore: Don't feel like typing this correctly
  arr.reduce((acc: number, e?: number) => acc + e, 0);

export const transpose = (array: unknown[][]) =>
  array[0].map((_, colIndex) => array.map((row) => row[colIndex]));

export const zip = (a: unknown[], b: unknown[]) => a.map((k, i) => [k, b[i]]);

// @ts-ignore: Don't feel like typing this correctly
export const sort = (arr: unknown[]) => arr.sort((a, b) => a < b ? -1 : 1);

export const slice = (start, end = undefined) => (arr: unknown[]) =>
  arr.slice(start, end);

export const reverse = (arr) => arr.reverse();

export const chunk = (size: number) => (arr: unknown[]): unknown[] =>
  arr.reduce((result: unknown[][], item, index) => {
    const chunkIndex = Math.floor(index / size);

    if (!result[chunkIndex]) {
      result[chunkIndex] = []; // start a new chunk
    }

    result[chunkIndex].push(item);

    return result;
  }, []);

export const tap = (str: string) => (value: unknown) => {
  console.log(str, value);
  return value;
};
