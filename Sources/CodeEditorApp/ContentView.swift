import SwiftUI

struct ContentView: View {
    @State private var text: String = ""
    @State private var language: EditorLanguage = .javascript
    @State private var theme: EditorTheme = .midnight

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            CodeEditorView(text: $text, language: language, theme: theme)
        }
        .onAppear {
            if text.isEmpty {
                text = language.starterTemplate
            }
        }
    }

    private var header: some View {
        HStack(spacing: 16) {
            Picker("Language", selection: $language) {
                ForEach(EditorLanguage.allCases) { language in
                    Text(language.displayName).tag(language)
                }
            }
            .pickerStyle(.menu)
            .onChange(of: language) { newLanguage in
                if text.isEmpty {
                    text = newLanguage.starterTemplate
                }
            }

            Picker("Theme", selection: $theme) {
                ForEach(EditorTheme.allCases) { theme in
                    Text(theme.displayName).tag(theme)
                }
            }
            .pickerStyle(.segmented)

            Button("Format") {
                text = CodeFormatter.format(text)
            }

            Button("Copy") {
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(text, forType: .string)
            }

            Spacer()

            Button("Reset") {
                text = language.starterTemplate
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(Color(NSColor.windowBackgroundColor))
    }
}
