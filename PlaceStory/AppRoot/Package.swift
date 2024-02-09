// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppRoot",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "AppRoot",
            targets: ["AppRoot"]),
    ],
    dependencies: [
        .package(path: "../ProxyPackage"),
        .package(path: "../LoggedOut"),
        .package(path: "../Domain"),
        .package(path: "../Platform"),
        .package(path: "../LoggedIn"),
        .package(path: "../MyLocation"),
        .package(path: "../PlaceDiary")
    ],
    targets: [
        .target(
            name: "AppRoot",
            dependencies: [
                "ProxyPackage",
                "LoggedOut",
                .product(name: "UseCase", package: "Domain"),
                .product(name: "RepositoryImps", package: "Platform"),
                .product(name: "Repositories", package: "Domain"),
                "LoggedIn",
                .product(name: "MyLocation", package: "MyLocation"),
                .product(name: "AppleMapView", package: "Platform"),
                .product(name: "PlaceList", package: "PlaceDiary"),
                .product(name: "PlaceSearcher", package: "MyLocation"),
                .product(name: "LocalStorage", package: "Platform"),
                .product(name: "SecurityServices", package: "Platform")
            ]
        )
    ]
)
