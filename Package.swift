// swift-tools-version: 5.9
import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "NobodyWho",
    platforms: [
        .iOS(.v15),
        .macOS(.v13),
        .visionOS(.v1),
        .watchOS(.v10),
    ],
    products: [
        .library(
            name: "NobodyWho",
            targets: ["NobodyWho"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.0"),
    ],
    targets: [
        .binaryTarget(
            name: "NobodyWhoNative",
            // During development, use a local path:
            url: "https://github.com/nobodywho-ooo/nobodywho/releases/download/nobodywho-swift-v2.0.1/NobodyWhoNative.xcframework.zip",
            checksum: "897637cdabb681ca68e2fadb3ffa473f40943106172b0b70f76d94c79e3db359"
            // For releases, CI patches this to:
            // url: "https://github.com/nobodywho-ooo/nobodywho/releases/download/nobodywho-swift-v<VERSION>/NobodyWhoNative.xcframework.zip",
            // checksum: "<SHA256>"
        ),
        // Macro compiler plugin
        .macro(
            name: "NobodyWhoMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ],
            path: "macros"
        ),
        .target(
            name: "NobodyWho",
            dependencies: ["NobodyWhoGenerated", "NobodyWhoMacros"],
            path: "src",
            plugins: []
        ),
        // The generated bindings are compiled as part of the NobodyWho target
        .target(
            name: "NobodyWhoGenerated",
            dependencies: ["NobodyWhoNative"],
            path: "generated",
            sources: ["nobodywho.swift"],
            linkerSettings: [
                .linkedFramework("Accelerate"),
                .linkedLibrary("c++"),
            ]
        ),
        .testTarget(
            name: "NobodyWhoMacroTests",
            dependencies: [
                "NobodyWhoMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ],
            path: "tests/MacroTests"
        ),
        .testTarget(
            name: "NobodyWhoTests",
            dependencies: ["NobodyWho"],
            path: "tests/NobodyWhoTests"
        ),
    ]
)
