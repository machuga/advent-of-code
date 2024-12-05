import Foundation

let args = CommandLine.arguments
let flag = args.indices.contains(1) ? args[1] : "input"

typealias Row = [Substring]
typealias Wordsearch = [[Substring]]
typealias Coords = (Int, Int)
let WORD = "XMAS"

let rawInputByLine : [String] = readInputFromFlag(flag: flag)
let input : Wordsearch = rawInputByLine.map {
    $0.split(separator: "")
}

func checkWest(start: Coords, wordsearch: Wordsearch) -> Bool {
    let (row, col) = start

    guard wordsearch[row].indices.contains(col-3) else {
        return false
    }

    let elements = wordsearch[row][(col-3)...col]

    return elements.reversed().joined(separator: "") == WORD
}

func checkEast(start: Coords, wordsearch: Wordsearch) -> Bool {
    let (row, col) = start

    guard wordsearch[row].indices.contains(col+3) else {
        return false
    }

    let elements = wordsearch[row][col...(col+3)]

    return elements.joined(separator: "") == WORD
}

func checkNorth(start: Coords, wordsearch: Wordsearch) -> Bool {
    let (row, col) = start

    guard wordsearch.indices.contains(row) && wordsearch.indices.contains(row-3) else {
        return false
    }

    let challenge = wordsearch[row][col] + wordsearch[row - 1][col] + wordsearch[row - 2][col] + wordsearch[row - 3][col]

    return challenge == WORD
}

func checkSouth(start: Coords, wordsearch: Wordsearch) -> Bool {
    let (row, col) = start

    guard wordsearch.indices.contains(row) && wordsearch.indices.contains(row+3) else {
        return false
    }

    let challenge = wordsearch[row][col] + wordsearch[row + 1][col] + wordsearch[row + 2][col] + wordsearch[row + 3][col]

    return challenge == WORD
}

func checkNorthWest(start: Coords, wordsearch: Wordsearch) -> Bool {
    let (row, col) = start

    guard wordsearch.indices.contains(row-3) && wordsearch[row-3].indices.contains(col-3) else {
        return false
    }

    let challenge = wordsearch[row][col] + wordsearch[row - 1][col - 1] + wordsearch[row - 2][col - 2] + wordsearch[row - 3][col - 3]

    return challenge == WORD
}

func checkNorthEast(start: Coords, wordsearch: Wordsearch) -> Bool {
    let (row, col) = start

    guard wordsearch.indices.contains(row-3) && wordsearch[row-3].indices.contains(col+3) else {
        return false
    }

    let challenge = wordsearch[row][col] + wordsearch[row - 1][col + 1] + wordsearch[row - 2][col + 2] + wordsearch[row - 3][col + 3]

    return challenge == WORD
}

func checkSouthWest(start: Coords, wordsearch: Wordsearch) -> Bool {
    let (row, col) = start

    guard wordsearch.indices.contains(row+3) && wordsearch[row+3].indices.contains(col-3) else {
        return false
    }

    let challenge = wordsearch[row][col] + wordsearch[row + 1][col - 1] + wordsearch[row + 2][col - 2] + wordsearch[row + 3][col - 3]

    return challenge == WORD
}

func checkSouthEast(start: Coords, wordsearch: Wordsearch) -> Bool {
    let (row, col) = start

    guard wordsearch.indices.contains(row+3) && wordsearch[row+3].indices.contains(col+3) else {
        return false
    }

    let challenge = wordsearch[row][col] + wordsearch[row + 1][col + 1] + wordsearch[row + 2][col + 2] + wordsearch[row + 3][col + 3]

    return challenge == WORD
}

func checkAllDirections(start: Coords, wordsearch: Wordsearch) -> Int {
    return [
        checkNorth(start: start, wordsearch: wordsearch),
        checkEast(start: start, wordsearch: wordsearch),
        checkSouth(start: start, wordsearch: wordsearch),
        checkWest(start: start, wordsearch: wordsearch),
        checkNorthEast(start: start, wordsearch: wordsearch),
        checkSouthEast(start: start, wordsearch: wordsearch),
        checkSouthWest(start: start, wordsearch: wordsearch),
        checkNorthWest(start: start, wordsearch: wordsearch),
    ].filter { $0 == true }.count
}

func partI() {
    var answer = 0

    for (rowIndex, row) in input.enumerated() {
        for (colIndex, col) in row.enumerated() {
            if (col == "X") {
                answer += checkAllDirections(start: (rowIndex, colIndex), wordsearch: input)
            }
        }
    }

    print("Part I answer: \(answer)")
}


func checkCross(start: Coords, wordsearch: Wordsearch) -> Int {
    let (row, col) = start
    let w : Wordsearch = wordsearch

    guard w.indices.contains(row-1)
        && w.indices.contains(row+1)
        && w[row+1].indices.contains(col-1)
        && w[row+1].indices.contains(col+1)
        && w[row-1].indices.contains(col-1)
        && w[row-1].indices.contains(col+1)
        else {
        return 0
    }

    let vals : [Substring] = [
        w[row+1][col+1] + w[row][col] + w[row-1][col-1], // North West
        w[row+1][col-1] + w[row][col] + w[row-1][col+1], // North East
        w[row-1][col-1] + w[row][col] + w[row+1][col+1], // South East
        w[row-1][col+1] + w[row][col] + w[row+1][col-1], // South West
    ]

    return vals.filter { $0 == "MAS" }.count >= 2 ? 1 : 0
}

func partII() {
    var answer = 0

    for (rowIndex, row) in input.enumerated() {
        for (colIndex, col) in row.enumerated() {
            if (col == "A") {
                answer += checkCross(start: (rowIndex, colIndex), wordsearch: input)
            }
        }
    }
    print("Part II answer: \(answer)")
}

partI();
partII();

