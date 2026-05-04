// swift-tools-version: 5.9
import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "NobodyWho",
    platforms: [
        .iOS(.v15),
        .macOS(.v13),
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
            url: "https://github.com/nobodywho-ooo/nobodywho/releases/download/nobodywho-swift-v0.1.0/NobodyWhoNative.xcframework.zip",
            checksum: "420cd8400ba6cac40e2faeeec14367cdd744cf3db8f647f368d2c4be64024826"
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
