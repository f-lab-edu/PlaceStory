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
        .package(path: "../ProxyPackage")
    ],
    targets: [
        .target(
            name: "LoggedIn",
            dependencies: [
                "ProxyPackage"
            ]
        ),
        .testTarget(
            name: "LoggedInTests",
            dependencies: ["LoggedIn"]),
    ]
)
