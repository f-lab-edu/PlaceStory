// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LoggedIn",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "LoggedIn",
            targets: ["LoggedIn"]),
    ],
    dependencies: [
        .package(path: "../ProxyPackage"),
        .package(path: "../Domain"),
        .package(path: "../MyLocation")
    ],
    targets: [
        .target(
            name: "LoggedIn",
            dependencies: [
                "ProxyPackage",
                .product(name: "Entities", package: "Domain"),
                "MyLocation"
            ]
        ),
        .testTarget(
            name: "LoggedInTests",
            dependencies: ["LoggedIn"]),
    ]
)
