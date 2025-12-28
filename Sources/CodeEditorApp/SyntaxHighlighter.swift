import Foundation
import SwiftUI

struct SyntaxHighlighter {
    static func highlight(text: String, language: EditorLanguage, theme: EditorTheme) -> AttributedString {
        var attributed = AttributedString(text)
        attributed.foregroundColor = theme.textColor

        let keywordPattern = "\\b(\(language.keywords.joined(separator: "|")))\\b"
        apply(pattern: keywordPattern, in: text, to: &attributed, color: Color(red: 248 / 255, green: 113 / 255, blue: 113 / 255))
        apply(pattern: numberPattern, in: text, to: &attributed, color: Color(red: 125 / 255, green: 211 / 255, blue: 252 / 255))

        switch language {
        case .html:
            apply(pattern: "<!--(.|\\n)*?-->", in: text, to: &attributed, color: commentColor)
            apply(pattern: "</?\\w+[^>]*>", in: text, to: &attributed, color: Color(red: 56 / 255, green: 189 / 255, blue: 248 / 255))
        case .css:
            apply(pattern: "/\\*([\\s\\S]*?)\\*/", in: text, to: &attributed, color: commentColor)
            apply(pattern: "\\b[a-z-]+(?=\\s*:)", in: text, to: &attributed, color: Color(red: 52 / 255, green: 211 / 255, blue: 153 / 255))
        default:
            apply(pattern: "//.*", in: text, to: &attributed, color: commentColor)
            apply(pattern: "/\\*([\\s\\S]*?)\\*/", in: text, to: &attributed, color: commentColor)
        }

        apply(pattern: stringPattern, in: text, to: &attributed, color: Color(red: 251 / 255, green: 191 / 255, blue: 36 / 255))

        return attributed
    }

    private static let numberPattern = "\\b\\d+(?:\\.\\d+)?\\b"
    private static let stringPattern = "\"(?:\\\\.|[^\\\"])*\"|'(?:\\\\.|[^\\\\'])*'|`(?:\\\\.|[^\\\\`])*`"
    private static let commentColor = Color(red: 148 / 255, green: 163 / 255, blue: 184 / 255)

    private static func apply(pattern: String, in text: String, to attributed: inout AttributedString, color: Color) {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return
        }

        let nsRange = NSRange(text.startIndex..., in: text)
        let matches = regex.matches(in: text, options: [], range: nsRange)

        for match in matches {
            guard let range = Range(match.range, in: text) else { continue }
            guard let start = AttributedString.Index(range.lowerBound, within: attributed),
                  let end = AttributedString.Index(range.upperBound, within: attributed) else { continue }
            attributed[start..<end].foregroundColor = color
        }
    }
}
