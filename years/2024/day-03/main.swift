import Foundation

let args = CommandLine.arguments
let flag = args.indices.contains(1) ? args[1] : "input"

let rawInputByLine : [String] = readInputFromFlag(flag: flag)
//let input : [[String]] = rawInputByLine.map {
//    $0.components(separatedBy: " ")
//}

let input = rawInputByLine.joined(separator: "")

func parseMuls(input: String) -> Int {
    let pattern = "mul\\((\\d{1,3}),(\\d{1,3})\\)"
    let regex = try! NSRegularExpression(pattern: pattern)

    let matches = regex.matches(in: input, range: NSRange(input.startIndex..., in: input))

    return matches.map { match -> Int in
        // Group 1: firstNum
        let firstRange = Range(match.range(at: 1), in: input)!
        let firstNum = Int(input[firstRange])!

        // Group 2: secondNum
        let secondRange = Range(match.range(at: 2), in: input)!
        let secondNum = Int(input[secondRange])!

        return firstNum * secondNum
    }.reduce(0, +)

}

func partI() {
    let answer = parseMuls(input: input)

    print("Part I answer: \(answer)")
}

func partII() {
    let pattern = "(^|do\\(\\))(.*?)($|don't\\(\\))"
    let regex = try! NSRegularExpression(pattern: pattern)

    let matches = regex.matches(in: input, range: NSRange(input.startIndex..., in: input))
    let answer = matches.map { match -> Int in
        let range = Range(match.range(at: 2), in: input)!
        let substr = String(input[range])

        return parseMuls(input: substr)
    }.reduce(0, +)

    print("Part II answer: \(answer)")
}

partI();
partII();

