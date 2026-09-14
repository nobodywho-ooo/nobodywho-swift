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
            url: "https://github.com/nobodywho-ooo/nobodywho/releases/download/nobodywho-swift-v4.0.0/NobodyWhoNative.xcframework.zip",
            checksum: "6c9b20c8220629a253da5bf5e0962339594e089c840716f64e8f15e77fcac7a0"
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
