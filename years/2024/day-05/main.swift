import Foundation

let args = CommandLine.arguments
let flag = args.indices.contains(1) ? args[1] : "input"

let rawInput: String = readRawInputFromFlag(flag: flag)
let inputSections : [[String]] = rawInput.components(separatedBy: "\n\n").map { $0.components(separatedBy: "\n") }

func mapToArrayOfInts(separator: String) -> (_ str : String) -> [Int] {
    return { $0.components(separatedBy: separator).map { el in Int(el)! } }
}

let orderInstructions = inputSections[0].map(mapToArrayOfInts(separator: "|"))
let challenges = inputSections[1].map(mapToArrayOfInts(separator: ","))

func partI() {
    let adjacency = orderInstructions.reduce(into: [Int: [Int]]()) { (dict, current) in
        let el = current[0]
        let before = current[1]

        dict[el, default: []].append(before)
    }

    let answer = challenges.filter { challenge in
        var previous = -1

        for (index, pageNum) in challenge.reversed().enumerated() {
            if index != 0 {
                if !adjacency[pageNum, default: []].contains(previous) {
                    return false
                }
            }

            previous = pageNum
        }

        return true
    }.map { $0[$0.count / 2] }.reduce(0, +)

    print("Part I answer: \(answer)")
}

func partII() {
    let answer = 0

    print("Part II answer: \(answer)")
}

partI()
partII()
