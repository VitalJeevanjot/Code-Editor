import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var appState: AppState

    @State private var text: String = ""
    @State private var language: EditorLanguage = .javascript
    @State private var theme: EditorTheme = .midnight
    @State private var openedFileName: String = "Untitled"

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
        .onChange(of: appState.currentFileURL) { newValue in
            guard let url = newValue else { return }
            openFile(url)
        }
    }

    private var header: some View {
        HStack(spacing: 16) {
            Button("Open") {
                openFilePicker()
            }

            Text(openedFileName)
                .font(.subheadline)
                .foregroundColor(.secondary)

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
                openedFileName = "Untitled"
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(Color(NSColor.windowBackgroundColor))
    }

    private func openFilePicker() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.allowedFileTypes = EditorLanguage.allExtensions
        panel.begin { response in
            guard response == .OK, let url = panel.url else { return }
            openFile(url)
        }
    }

    private func openFile(_ url: URL) {
        do {
            let contents = try String(contentsOf: url)
            text = contents
            openedFileName = url.lastPathComponent
            if let detected = EditorLanguage.language(for: url) {
                language = detected
            }
        } catch {
            openedFileName = "Unable to open file"
        }
    }
}
