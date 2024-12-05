import Foundation

let relativeTo = FileManager.default.currentDirectoryPath

func parseInputArg(arg : String = "input") -> String {
    if (arg == "--input") {
        return "input.txt"
    }

    if (arg == "--sample-2") {
        return "sample-2.txt"
    }

    return "sample.txt"
}

func readInput(filename : String = "input") -> [String] {
    let path = NSString(string: "\(relativeTo)/\(filename)").expandingTildeInPath
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

func readInputFromFlag(flag : String) -> [String] {
    return readInput(filename: parseInputArg(arg: flag));
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        guard size > 0 else { return [] } // Handle invalid size

        return stride(from: 0, to: self.count, by: size).map { startIndex in
            let endIndex = Swift.min(startIndex + size, self.count)
            return Array(self[startIndex..<endIndex])
        }
    }
}
