import Foundation
import SwiftUI

@MainActor
final class AppState: ObservableObject {
    static let shared = AppState()

    @Published var currentFileURL: URL?

    func openFile(url: URL) {
        currentFileURL = url
    }
}
