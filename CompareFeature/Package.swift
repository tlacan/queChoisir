// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "CompareFeature",
    platforms: [
        .iOS("26.0")
    ],
    products: [
        .library(
            name: "CompareFeature",
            targets: ["CompareFeature"]
        )
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(path: "../ClaudeService"),
        .package(path: "../DesignSystem")
    ],
    targets: [
        .target(
            name: "CompareFeature",
            dependencies: [
                "Core",
                "ClaudeService",
                "DesignSystem"
            ],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        )
    ]
)
