// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Extensions",
    platforms: [.iOS("14.0")],
    products: [
        .library(
            name: "Extensions",
            targets: ["Extensions"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: "7.0.0"))
    ],
    targets: [
        .target(
            name: "Extensions",
            dependencies: [
                .product(
                    name: "Kingfisher",
                    package: "Kingfisher",
                    condition: .when(platforms: [.iOS])
                )
            ]
        )
    ]
)
