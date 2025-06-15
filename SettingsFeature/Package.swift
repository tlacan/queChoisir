// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "SettingsFeature",
    platforms: [
      .iOS("26.0")
    ],
    products: [
        .library(
            name: "SettingsFeature",
            targets: ["SettingsFeature"]
        )
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(path: "../DesignSystem")
    ],
    targets: [
        .target(
            name: "SettingsFeature",
            dependencies: [
                "Core",
                "DesignSystem"
            ],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        )
    ]
)
