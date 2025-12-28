// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CodeEditorApp",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "CodeEditorApp", targets: ["CodeEditorApp"])
    ],
    targets: [
        .executableTarget(name: "CodeEditorApp")
    ]
)
