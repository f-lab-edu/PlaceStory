// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PlaceDiary",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PlaceList",
            targets: ["PlaceList"]),
        .library(
            name: "PlaceRecordEditor",
            targets: ["PlaceRecordEditor"])
    ],
    dependencies: [
        .package(path: "../ProxyPackage"),
        .package(path: "../Domain")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "PlaceList",
            dependencies: [
                "ProxyPackage",
                .product(name: "UseCase", package: "Domain"),
                .product(name: "Utils", package: "ProxyPackage"),
                .product(name: "Entities", package: "Domain"),
                "PlaceRecordEditor",
                .product(name: "CommonUI", package: "ProxyPackage")
            ]
        ),
        .target(
            name: "PlaceRecordEditor",
            dependencies: [
                "ProxyPackage",
                .product(name: "Utils", package: "ProxyPackage"),
                .product(name: "Entities", package: "Domain"),
                .product(name: "CommonUI", package: "ProxyPackage")
            ]
        ),
        .testTarget(
            name: "PlaceDiaryTests",
            dependencies: ["PlaceList"]),
    ]
)
