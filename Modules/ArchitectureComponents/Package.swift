// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ArchitectureComponents",
    platforms: [.iOS("14.0")],
    products: [
        .library(
            name: "ArchitectureComponents",
            targets: ["ArchitectureComponents"]
        )
    ],
    dependencies: [ ],
    targets: [
        .target(
            name: "ArchitectureComponents",
            dependencies: []
        )
    ]
)
