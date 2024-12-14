import Foundation

let args = CommandLine.arguments
let flag = args.indices.contains(1) ? args[1] : "input"

typealias Row = [Character]
typealias Grid = [Row]
typealias Position = (Int, Int)
typealias GuardInfo = (Position, Direction)

struct State {
    var guardInfo : GuardInfo
    var grid : Grid
    var cycle : Int = 0
    var distinctPositions : Int = 1
    var done : Bool = false
}

let input: Grid = readInputFromFlag(flag: flag).map { Array($0) }

enum Direction : Character, CaseIterable {
    case north = "^"
    case east = ">"
    case south = "v"
    case west = "<"
}

enum Sprite : Character {
    case unvisited = "."
    case visted = "X"
    case obstacle = "#"
    case guardNorth = "^"
    case guardEast = ">"
    case guardSouth = "v"
    case guardWest = "<"
}

func turn(from: Direction) -> Direction {
    switch from {
        case .north: return .east
        case .east:  return .south
        case .south: return .west
        case .west:  return .north
    }
}

// Function to print the grid to the terminal
func printGrid(_ grid: [[Character]]) {
    // Move the cursor to the top-left corner using the ANSI escape code
    print("\u{001B}[H", terminator: "")

    // Print the grid row by row
    for row in grid {
        print(row.map { String($0) }.joined())
    }
}

func findGuard(_ grid: Grid) -> GuardInfo {
    let possibleDirections = Direction.allCases.map { $0.rawValue }
    let guardRow = -1
    let guardCol = -1
    let guardDir : Direction = .north

    for (rowIndex, row) in grid.enumerated() {
        for (colIndex, value) in row.enumerated() {
            if possibleDirections.contains(value) {
                return ((rowIndex, colIndex), Direction(rawValue: value)!) as GuardInfo
            }
        }
    }

    return ((guardRow, guardCol), guardDir)
}

func nextPosition(from: GuardInfo) -> Position {
    let ((x,y), direction) = from

    switch direction {
        case .north: return (x - 1, y)
        case .east:  return (x, y + 1)
        case .south: return (x + 1, y)
        case .west:  return (x, y - 1)
    }
}

func move(_ state: State) -> State {
    var grid = state.grid
    let ((x, y), currentDirection) = state.guardInfo

    // Check ahead
    let (nextX, nextY) : Position = nextPosition(from: state.guardInfo)

    guard nextX < grid.count && nextX >= 0 && nextY >= 0 && nextY < grid[0].count else {
        return State(
            guardInfo: state.guardInfo,
            grid: state.grid,
            cycle: state.cycle,
            distinctPositions: state.distinctPositions,
            done: true
        )
    }

    // Turn if collision
    if grid[nextX][nextY] == "#" {
        let nextDirection = turn(from: currentDirection)
        // Replace current location with X
        grid[x][y] = nextDirection.rawValue
        return State(
            guardInfo: ((x,y), nextDirection),
            grid: grid,
            cycle: state.cycle + 1,
            distinctPositions: state.distinctPositions,
            done: false
        )
    }

    // Move guard forward if no collision
    let distinctPositions = grid[nextX][nextY] == "X" ? state.distinctPositions : state.distinctPositions + 1
    grid[nextX][nextY] = grid[x][y]
    grid[x][y] = "X"

    return State(
        guardInfo: ((nextX, nextY), currentDirection),
        grid: grid,
        cycle: state.cycle + 1,
        distinctPositions: distinctPositions,
        done: false
    )
}

func partI() {
    var state = State(guardInfo: findGuard(input), grid: input)

    // Clear the terminal
    print("\u{001B}[2J", terminator: "")

    printGrid(state.grid)       // Print the updated grid

    while !state.done {
        state = move(state)

        if flag != "--input" {
            Thread.sleep(forTimeInterval: 0.1)
            printGrid(state.grid)
            print("cycle: \(state.cycle)")
            print("positions: \(state.distinctPositions)")
        }
    }

    printGrid(state.grid)

    print("Part I answer: \(state.distinctPositions)")
}

func partII() {
    let answer = 0

    print("Part II answer: \(answer)")
}

partI()
partII()
