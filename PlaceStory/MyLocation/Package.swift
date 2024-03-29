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
        .package(path: "../Domain"),
        .package(path: "../Platform"),
        .package(path: "../PlaceDiary")
    ],
    targets: [
        .target(
            name: "MyLocation",
            dependencies: [
                "ProxyPackage",
                .product(name: "UseCase", package: "Domain"),
                .product(name: "RepositoryImps", package: "Platform"),
                .product(name: "CommonUI", package: "ProxyPackage"),
                .product(name: "Utils", package: "ProxyPackage"),
                "PlaceSearcher",
                .product(name: "AppleMapView", package: "Platform"),
                .product(name: "PlaceList", package: "PlaceDiary")
            ]
        ),
        .target(
            name: "PlaceSearcher",
            dependencies: [
                "ProxyPackage",
                .product(name: "CommonUI", package: "ProxyPackage"),
                .product(name: "Utils", package: "ProxyPackage"),
                .product(name: "UseCase", package: "Domain")
            ]
        ),
        .testTarget(
            name: "MyLocationTests",
            dependencies: [
                "MyLocation",
                .product(name: "CommonUI", package: "ProxyPackage"),
                .product(name: "Entities", package: "Domain"),
                .product(name: "UseCase", package: "Domain"),
                .product(name: "Repositories", package: "Domain"),
                "PlaceSearcher"
            ]),
    ]
)
