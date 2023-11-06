// swift-tools-version:5.7


import PackageDescription

let package = Package(
    name: "SherlockForms",
    platforms: [
      .iOS(.v16),
      .macOS(.v13)
    ],
    products: [
        .library(
            name: "SherlockForms",
            targets: ["SherlockForms"]
        ),
        .library(
            name: "SherlockDebugForms",
            targets: ["SherlockDebugForms"]
        ),
        .library(
            name: "SherlockHUD",
            targets: ["SherlockHUD"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SherlockHUD",
            dependencies: [],
            swiftSettings: [
                .unsafeFlags([
                    "-Xfrontend", "-warn-concurrency",
                    "-Xfrontend", "-enable-actor-data-race-checks",
                ])
            ]
        ),
        .target(
            name: "SherlockForms",
            dependencies: ["SherlockHUD"],
            swiftSettings: [
                .unsafeFlags([
                    "-Xfrontend", "-warn-concurrency",
                    "-Xfrontend", "-enable-actor-data-race-checks",
                ])
            ]
        ),
        .target(
            name: "SherlockDebugForms",
            dependencies: ["SherlockForms"],
            swiftSettings: [
                .unsafeFlags([
                    "-Xfrontend", "-warn-concurrency",
                    "-Xfrontend", "-enable-actor-data-race-checks",
                ])
            ]
        ),
    ]
)
