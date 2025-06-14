import ProjectDescription

let project = Project(
    name: "QueChoisir",
    packages: [
        .remote(
            url: "https://github.com/Swinject/Swinject.git",
            requirement: .upToNextMajor(from: "2.8.0")
        ),
        .remote(
            url: "https://github.com/jamesrochabrun/SwiftAnthropic.git",
            requirement: .upToNextMajor(from: "1.0.0")
        )
    ],
    settings: .settings(
        base: [
            "SWIFT_STRICT_CONCURRENCY": "complete",
            "SWIFT_UPCOMING_FEATURE_GLOBAL_ACTOR_ISOLATION": "YES",
            "SWIFT_DEFAULT_ACTOR_ISOLATION": "MainActor"
        ],
        configurations: [
            .debug(
                name: "Debug",
                xcconfig: "Configurations/Debug.xcconfig"
            ),
            .release(
                name: "Release",
                xcconfig: "Configurations/Release.xcconfig"
            )
        ]
    ),
    targets: [
        .target(
            name: "QueChoisir",
            destinations: .iOS,
            product: .app,
            bundleId: "com.quechoisir.app",
            deploymentTargets: .iOS("26.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen.storyboard",
                    "CFBundleDisplayName": "QueChoisir",
                    "CLAUDE_API_KEY": "$(CLAUDE_API_KEY)"
                ]
            ),
            sources: ["App/Sources/**"],
            resources: [],
            dependencies: [
                .package(product: "Swinject"),
                .target(name: "TopProductsFeature"),
                .target(name: "CompareFeature"),
                .target(name: "SettingsFeature"),
                .target(name: "ClaudeService"),
                .target(name: "Core"),
                .target(name: "DesignSystem")
            ]
        ),
        .target(
            name: "Core",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.quechoisir.core",
            deploymentTargets: .iOS("26.0"),
            sources: ["Core/Sources/**"],
            dependencies: [
                .package(product: "Swinject")
            ]
        ),
        .target(
            name: "ClaudeService",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.quechoisir.claudeservice",
            deploymentTargets: .iOS("26.0"),
            sources: ["ClaudeService/Sources/**"],
            dependencies: [
                .target(name: "Core"),
                .package(product: "SwiftAnthropic"),
                .package(product: "Swinject")
            ]
        ),
        .target(
            name: "TopProductsFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.quechoisir.topproducts",
            deploymentTargets: .iOS("26.0"),
            sources: ["TopProductsFeature/Sources/**"],
            dependencies: [
                .target(name: "Core"),
                .target(name: "ClaudeService"),
                .target(name: "DesignSystem")
            ]
        ),
        .target(
            name: "CompareFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.quechoisir.compare",
            deploymentTargets: .iOS("26.0"),
            sources: ["CompareFeature/Sources/**"],
            dependencies: [
                .target(name: "Core"),
                .target(name: "ClaudeService"),
                .target(name: "DesignSystem")
            ]
        ),
        .target(
            name: "SettingsFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.quechoisir.settings",
            deploymentTargets: .iOS("26.0"),
            sources: ["SettingsFeature/Sources/**"],
            dependencies: [
                .target(name: "Core"),
                .target(name: "DesignSystem")
            ]
        ),
        .target(
            name: "DesignSystem",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.quechoisir.designsystem",
            deploymentTargets: .iOS("26.0"),
            sources: ["DesignSystem/Sources/**"],
            resources: ["DesignSystem/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "QueChoisirTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.quechoisir.app.tests",
            deploymentTargets: .iOS("26.0"),
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "QueChoisir")
            ]
        )
    ]
)