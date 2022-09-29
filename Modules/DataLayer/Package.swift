// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DataLayer",
    platforms: [.iOS("14.0")],
    products: [
        .library(
            name: "DataLayer",
            targets: ["DataLayer"]
        )
    ],
    dependencies: [
        .package(name: "DomainLayer", path: "../DomainLayer"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.5.0")),
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "3.0.0")
    ],
    targets: [
        .target(
            name: "DataLayer",
            dependencies: [
                .product(
                    name: "DomainLayer",
                    package: "DomainLayer",
                    condition: .when(platforms: [.iOS])
                ),
                .product(
                    name: "Alamofire",
                    package: "alamofire",
                    condition: .when(platforms: [.iOS])
                ),
                .product(
                    name: "KeychainAccess",
                    package: "keychainaccess",
                    condition: .when(platforms: [.iOS])
                )
            ]
        )
    ]
)
