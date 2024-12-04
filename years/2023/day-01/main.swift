//
//  main.swift
//  Learning Land
//
//  Created by Matt Machuga on 11/11/24.
//

import Foundation

print("Hello, World!")
let relativeTo = "."

let args = CommandLine.arguments
let filename = args.indices.contains(1) ? args[1] : "input"

func readInput(inputType : String = "input") -> [String] {
    let path = NSString(string: "\(relativeTo)/\(inputType).txt").expandingTildeInPath
    let url = URL(fileURLWithPath: path)
    var contents : String?

    do {
        contents = try String(contentsOf: url, encoding: .utf8)
    } catch {
        print("Invalid file", error)
    }

    if let lines = contents?
        .trimmingCharacters(in: CharacterSet(["\n", " "]))
        .components(separatedBy: "\n") {
        return lines.map { $0.trimmingCharacters(in: CharacterSet(["\n", " "]))}
    } else {
        return []
    }
}

func findFringeNumericalPairs(input : String) -> [String] {
    let pattern = "\\d"

    do {
        let regex = try NSRegularExpression(pattern: pattern)
        let matches = regex.matches(in: input, range: NSRange(input.startIndex..., in: input))

        // Map over all matches to extract the number strings
        let allNumbers = matches.compactMap { match -> String? in
            if let range = Range(match.range, in: input) {
                return String(input[range])
            }
            return nil
        }

        return allNumbers
    } catch {
        print("lolded")
    }
    return []
}

let numbers : [Int] = readInput(inputType: filename)
    .compactMap(findFringeNumericalPairs(input:))
    .map { Int(($0.first ?? "") + ($0.last ?? "0")) ?? 0 }

for line in numbers {
    print(line)
}


print("result: \(numbers.reduce(0, +))")

