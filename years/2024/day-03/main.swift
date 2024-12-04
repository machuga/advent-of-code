import Foundation

let args = CommandLine.arguments
let flag = args.indices.contains(1) ? args[1] : "input"

let rawInputByLine : [String] = readInputFromFlag(flag: flag)
//let input : [[String]] = rawInputByLine.map {
//    $0.components(separatedBy: " ")
//}

let input = rawInputByLine
let pattern = "mul\\((\\d{1,3}),(\\d{1,3})\\)"

func partI() {
    let regex = try! NSRegularExpression(pattern: pattern)

    let answer = input.map { line in
        let matches = regex.matches(in: line, range: NSRange(line.startIndex..., in: line))

        let results = matches.map { match -> Int in
            // Group 1: firstNum
            let firstRange = Range(match.range(at: 1), in: line)!
            let firstNum = Int(line[firstRange])!

            // Group 2: secondNum
            let secondRange = Range(match.range(at: 2), in: line)!
            let secondNum = Int(line[secondRange])!

            return firstNum * secondNum
        }.reduce(0, +)

        return results
    }.reduce(0, +)

    print("Part I answer: \(answer)")
}

func partII() {
    let answer = 0

    print("Part II answer: \(answer)")
}

partI();
partII();

