import Foundation

let args = CommandLine.arguments
let flag = args.indices.contains(1) ? args[1] : "input"

let rawInputByLine : [String] = readInputFromFlag(flag: flag)

func prepareLists(rows: [String]) -> [[Int]] {
    rows.reduce(into: [[], []]) { arrs, row in
        let input = row.components(separatedBy: "   ").map { Int($0)! }

        arrs[0].append(input[0])
        arrs[1].append(input[1])
    }
}

func partI() {
    let arrs : [[Int]] = prepareLists(rows: rawInputByLine).map { $0.sorted() }

    let answer = (0..<arrs[0].count).map { abs(arrs[0][$0] - arrs[1][$0]) }.reduce(0, +)

    print("Part I answer: \(answer)")
}

func partII() {
    let arrs : [[Int]] = prepareLists(rows: rawInputByLine)
    let leftList = arrs[0]
    let rightList = arrs[1]

    let answer = leftList.map { leftEl in leftEl * rightList.filter { rightEl in leftEl == rightEl }.count }.reduce(0, +)

    print("Part II answer: \(answer)")
}
partI();
partII();

