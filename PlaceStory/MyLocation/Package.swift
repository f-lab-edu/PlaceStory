// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MyLocation",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "MyLocation",
            targets: ["MyLocation"]),
        .library(
            name: "PlaceSearcher",
            targets: ["PlaceSearcher"])
    ],
    dependencies: [
        .package(path: "../ProxyPackage"),
        .package(path: "../Domain")
    ],
    targets: [
        .target(
            name: "MyLocation",
            dependencies: [
                "ProxyPackage",
                .product(name: "UseCase", package: "Domain")
            ]
        ),
        .target(
            name: "PlaceSearcher",
            dependencies: [
                "ProxyPackage"
            ]
        ),
        .testTarget(
            name: "MyLocationTests",
            dependencies: ["MyLocation"]),
    ]
)
