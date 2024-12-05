import Foundation

let args = CommandLine.arguments
let flag = args.indices.contains(1) ? args[1] : "input"

let rawInputByLine : [String] = readInputFromFlag(flag: flag)
//let input : [] = rawInputByLine.map {
//    $0.split(separator: "")
//}

let input = rawInputByLine


func partI() {
    let answer = 0

    print("Part I answer: \(answer)")
}

func partII() {
    let answer = 0

    print("Part II answer: \(answer)")
}

partI();
partII();

