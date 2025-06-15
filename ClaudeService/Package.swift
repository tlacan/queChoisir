// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "ClaudeService",
    platforms: [
        .iOS("26.0")
    ],
    products: [
        .library(
            name: "ClaudeService",
            targets: ["ClaudeService"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/Swinject/Swinject.git",
            from: "2.8.0"
        ),
        .package(
            url: "https://github.com/jamesrochabrun/SwiftAnthropic.git",
            from: "1.0.0"
        ),
        .package(path: "../Core")
    ],
    targets: [
        .target(
            name: "ClaudeService",
            dependencies: [
                "Core",
                "Swinject",
                "SwiftAnthropic"
            ],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency"),
                .defaultIsolation(nil) // Explicitly nonisolated
            ]
        )
    ]
)
