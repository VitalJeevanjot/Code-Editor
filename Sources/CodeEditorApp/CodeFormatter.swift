import Foundation

struct CodeFormatter {
    static func format(_ text: String) -> String {
        let trimmedLines = text.split(whereSeparator: \.isNewline).map { line in
            line.replacingOccurrences(of: "\t", with: "  ").trimmingCharacters(in: .whitespaces)
        }
        return trimmedLines.joined(separator: "\n") + "\n"
    }
}
