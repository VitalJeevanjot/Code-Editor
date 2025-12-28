import SwiftUI

struct CodeEditorView: View {
    @Binding var text: String
    let language: EditorLanguage
    let theme: EditorTheme

    @State private var selectedCompletion: String?
    @FocusState private var isFocused: Bool

    private var highlightedText: AttributedString {
        SyntaxHighlighter.highlight(text: text, language: language, theme: theme)
    }

    private var currentToken: String? {
        guard let range = tokenRange(in: text) else { return nil }
        return String(text[range])
    }

    private var completions: [String] {
        let allCompletions = language.completions + language.keywords
        guard let token = currentToken, token.count >= 2 else { return [] }
        return allCompletions
            .filter { $0.lowercased().hasPrefix(token.lowercased()) }
            .sorted()
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            Text(highlightedText)
                .font(.system(.body, design: .monospaced))
                .padding(12)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

            TextEditor(text: $text)
                .focused($isFocused)
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.clear)
                .accentColor(theme.caretColor)
                .padding(8)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
        }
        .background(theme.backgroundColor)
        .overlay(alignment: .topTrailing) {
            if !completions.isEmpty {
                CompletionListView(completions: completions) { suggestion in
                    applySuggestion(suggestion)
                }
                .padding(12)
            }
        }
        .onAppear {
            isFocused = true
        }
    }

    private func applySuggestion(_ suggestion: String) {
        guard let range = tokenRange(in: text) else {
            text += suggestion
            return
        }
        text.replaceSubrange(range, with: suggestion)
    }

    private func tokenRange(in value: String) -> Range<String.Index>? {
        var end = value.endIndex
        var start = end
        while start > value.startIndex {
            let prev = value.index(before: start)
            let char = value[prev]
            if char.isLetter || char.isNumber || char == "_" {
                start = prev
            } else {
                break
            }
        }
        return start == end ? nil : start..<end
    }
}

private struct CompletionListView: View {
    let completions: [String]
    let onSelect: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Suggestions")
                .font(.caption)
                .foregroundColor(.secondary)
            ForEach(completions, id: \.self) { completion in
                Button {
                    onSelect(completion)
                } label: {
                    Text(completion)
                        .font(.system(.caption, design: .monospaced))
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        .frame(maxWidth: 320)
    }
}
