// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DomainLayer",
    platforms: [.iOS("14.0")],
    products: [
        .library(
            name: "DomainLayer",
            targets: ["DomainLayer"]
        )
    ],
    targets: [
        .target(
            name: "DomainLayer",
            dependencies: []
        )
    ]
)
