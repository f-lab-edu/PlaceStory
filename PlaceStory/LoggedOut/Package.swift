// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LoggedOut",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "LoggedOut",
            targets: ["LoggedOut"]),
    ],
    dependencies: [
        .package(path: "../ProxyPackage")
    ],
    targets: [
        .target(
            name: "LoggedOut",
            dependencies: [
                "ProxyPackage"
            ]
        ),
        .testTarget(
            name: "LoggedOutTests",
            dependencies: ["LoggedOut"]),
    ]
)
