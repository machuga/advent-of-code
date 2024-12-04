import Foundation

let args = CommandLine.arguments
let flag = args.indices.contains(1) ? args[1] : "input"

let rawInputByLine : [String] = readInputFromFlag(flag: flag)
let input : [[Int]] = rawInputByLine.map {
    $0.components(separatedBy: " ").map { num in Int(num)! }
}

enum Direction {
    case positive
    case negative
}

func isSafeOperation(first: Int, second: Int, direction: Direction) -> Bool {
    if direction == .positive && first > second {
        return false
    }

    if direction == .negative && first < second {
        return false
    }

    return (1...3).contains(abs(first - second))
}

func isRowSafe(_ row: [Int]) -> Bool {
    let direction : Direction = row[0] > row[1] ? .negative : .positive

    return zip(row, row.dropFirst()).allSatisfy { (a, b) in
        isSafeOperation(first: a, second: b, direction: direction)
    }
}

func rowWithoutIndex(row: [Int], index: Int) -> [Int] {
    var newRow = row
    newRow.remove(at: index)
    return newRow
}

func partI() {
    let answer = input.filter(isRowSafe).count
    print("Part I answer: \(answer)")
}

func partII() {
    let answer = input.filter {
        if isRowSafe($0) {
            return true
        }

        // Something went wrong, need to scan all
        for i in $0.indices {
            let result = isRowSafe(rowWithoutIndex(row: $0, index: i))

            if result == true {
                return true
            }
        }

        return false
    }

    print("Part II answer: \(answer.count)")
}

partI();
partII();

