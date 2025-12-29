import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApplication.shared.setActivationPolicy(.regular)
        NSApplication.shared.activate(ignoringOtherApps: true)
    }

    func application(_ application: NSApplication, openFiles filenames: [String]) {
        guard let first = filenames.first else {
            return
        }
        let url = URL(fileURLWithPath: first)
        Task { @MainActor in
            AppState.shared.openFile(url: url)
        }
        application.reply(toOpenOrPrint: .success)
    }
}
