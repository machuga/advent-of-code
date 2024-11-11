import {
  filter,
  getInput,
  head,
  last,
  map,
  pipe,
  reduce,
  split,
  sum,
  tap,
} from "../util.ts";

const parseLine = pipe([]);

type Pos = { x: number; y: number };

type PartNumber = {
  num: number;
  start: Pos;
  end: Pos;
  neighbors: Pos[];
};

type Sym = {
  location: Pos;
};

type Dimensions = {
  width: number;
  height: number;
};

const isNumber = (value) => !isNaN(value);
const getCharType = (char) => {
  if (char === ".") {
    return "dot";
  }

  if (isNumber(char)) {
    return "number";
  }

  return "symbol";
};

function range(start, end) {
  return [...Array(start + end).keys()].map((i) => i + startAt);
}

const clampedRange = (start, end, max) =>
  [...Array(Math.max(Math.min(end, max) - start)).keys()].map((i) =>
    i + Math.max(start, 0)
  );

const getNeighbors = (start: Pos, end: Pos, dimensions: Dimensions) => {
  const row = start[0];
  const firstCol = start[1];
  const lastCol = end[1];

  console.log("Start, end", start, end);
  const yRange = clampedRange(firstCol - 1, lastCol + 1, dimensions.width - 1);
  console.log("Y range is", yRange);
  const northRow = row - 1 < 0 ? [] : yRange.map((y) => [row - 1, y]);
  console.log("I need to use row ", row + 1);
  const southRow = row + 1 > dimensions.height - 1
    ? []
    : yRange.map((y) => [row + 1, y]);

  console.log("South row is", northRow);
  console.log("Mid row", head(yRange), firstCol);
  const midRow = [
    head(yRange) === firstCol ? null : [row, head(yRange)],
    last(yRange) === lastCol ? null : [row, last(yRange)],
  ].filter(Boolean);

  const neighbors = northRow.concat(midRow).concat(southRow);

  console.log("Neighbors", neighbors);
  return neighbors;
};

const trackPartNumber: PartNumber = (
  rawNum: string,
  end: Pos,
  dimensions: Dimensions,
) => {
  console.log("rawNum", rawNum, rawNum.length, end);
  const start = [end[0], end[1] - rawNum.length - 1];
  const num = parseInt(rawNum, 10);
  console.log("num as ", num);

  console.log("Getting neighbors for", start, end, dimensions);
  const neighbors: Pos[] = getNeighbors(start, end, dimensions);

  return {
    num,
    start,
    end,
    neighbors,
  };
};

const part1 = () => {
  const scanToTree = (grid) => {
    const pos = (x, y) => grid[x][y];
    const isValidPartNumber = (partNumber: PartNumber) =>
      partNumber.neighbors.some(([x, y]) =>
        getCharType(pos(x, y)) === "symbol"
      );

    const dimensions = {
      width: grid[0].length,
      height: grid.length,
    };

    const committedNumbers = [];
    let currentNum = "";

    for (let x = 0; x < dimensions.height; x++) {
      for (let y = 0; y < dimensions.width; y++) {
        const charType = getCharType(pos(x, y));

        console.log("Checking position", x, y, pos(x, y), charType);
        if (charType === "number") {
          currentNum += pos(x, y);
          console.log("Current number", currentNum);
        } else {
          if (currentNum) {
            console.log("Time to try to commit this number", currentNum);
            const partNum = trackPartNumber(
              currentNum,
              y === 0 ? [x - 1, dimensions.width - 1] : [x, y - 1],
              dimensions,
            );

            const symbolNeighbors = partNum.neighbors.filter(([x, y]) => {
              console.log("Checking point", x, y);
              return getCharType(pos(x, y)) === "symbol";
            });

            console.log(
              "Number",
              partNum.num,
              "has these symbol neighbors",
              symbolNeighbors,
            );
            if (isValidPartNumber(partNum)) {
              committedNumbers.push(partNum);
            }

            currentNum = "";
          }
        }
      }
    }

    return committedNumbers;

    return;
  };
  const result = pipe([
    getInput,
    map(split("")),
    scanToTree,
  ])(Deno.args[0]);

  console.log("Part 1:", result);
};

const part2 = () => {
  const result = pipe([
    getInput,
    map(split("")),
  ])(Deno.args[0]);

  console.log("Part 2:", result);
};

part1();
//part2();
