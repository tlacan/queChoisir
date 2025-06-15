// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "TopProductsFeature",
    platforms: [
        .iOS("26.0")
    ],
    products: [
        .library(
            name: "TopProductsFeature",
            targets: ["TopProductsFeature"]
        )
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(path: "../ClaudeService"),
        .package(path: "../DesignSystem")
    ],
    targets: [
        .target(
            name: "TopProductsFeature",
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
