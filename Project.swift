import ProjectDescription

let project = Project(
    name: "QueChoisir",
    packages: [
        .local(path: "./Core"),
        .local(path: "./ClaudeService"),
        .local(path: "./DesignSystem"),
        .local(path: "./TopProductsFeature"),
        .local(path: "./CompareFeature"),
        .local(path: "./SettingsFeature")
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
                .package(product: "Core"),
                .package(product: "ClaudeService"),
                .package(product: "DesignSystem"),
                .package(product: "TopProductsFeature"),
                .package(product: "CompareFeature"),
                .package(product: "SettingsFeature")
            ]
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