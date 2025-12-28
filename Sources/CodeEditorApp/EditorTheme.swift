import SwiftUI

enum EditorTheme: String, CaseIterable, Identifiable {
    case midnight
    case paper

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .midnight:
            return "Midnight"
        case .paper:
            return "Paper"
        }
    }

    var backgroundColor: Color {
        switch self {
        case .midnight:
            return Color(red: 15 / 255, green: 23 / 255, blue: 42 / 255)
        case .paper:
            return Color(red: 247 / 255, green: 247 / 255, blue: 245 / 255)
        }
    }

    var textColor: Color {
        switch self {
        case .midnight:
            return Color(red: 226 / 255, green: 232 / 255, blue: 240 / 255)
        case .paper:
            return Color(red: 32 / 255, green: 33 / 255, blue: 36 / 255)
        }
    }

    var caretColor: Color {
        switch self {
        case .midnight:
            return Color(red: 56 / 255, green: 189 / 255, blue: 248 / 255)
        case .paper:
            return Color(red: 37 / 255, green: 99 / 255, blue: 235 / 255)
        }
    }
}
