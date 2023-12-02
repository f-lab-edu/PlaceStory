// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppRoot",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "AppRoot",
            targets: ["AppRoot"]
        ),
    ],
    dependencies: [
        .package(path: "../ProxyPackage")
    ],
    targets: [
        .target(
            name: "AppRoot",
            dependencies: [
                "ProxyPackage"
            ]
        ),
        .testTarget(
            name: "AppRootTests",
            dependencies: ["AppRoot"]),
    ]
)
