// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "Core",
    platforms: [
        .iOS("26.0")
    ],
    products: [
        .library(
            name: "Core",
            targets: ["Core"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/Swinject/Swinject.git",
            from: "2.8.0"
        )
    ],
    targets: [
        .target(
            name: "Core",
            dependencies: ["Swinject"],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        )
    ]
)
