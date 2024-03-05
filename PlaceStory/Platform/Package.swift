// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Platform",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "LocalStorage",
            targets: ["LocalStorage"]
        ),
        .library(
            name: "Model",
            targets: ["Model"]
        ),
        .library(
            name: "RepositoryImps",
            targets: ["RepositoryImps"]),
        .library(
            name: "SecurityServices",
            targets: ["SecurityServices"]
        ),
        .library(
            name: "AppleMapView",
            targets: ["AppleMapView"]
        )
    ],
    dependencies: [
      .package(path: "../ProxyPackage"),
      .package(path: "../Domain")
    ],
    targets: [
        .target(
            name: "LocalStorage",
            dependencies: [
                .product(name: "ProxyPackage", package: "ProxyPackage"),
                .product(name: "Utils", package: "ProxyPackage"),
                "Model"
            ]
        ),
        .target(
            name: "Model",
            dependencies: [
                "ProxyPackage",
                .product(name: "Entities", package: "Domain")
            ]
        ),
        .target(
            name: "RepositoryImps",
            dependencies: [
                "LocalStorage",
                .product(name: "Utils", package: "ProxyPackage"),
                "Model",
                "SecurityServices",
                .product(name: "Repositories", package: "Domain")
            ]
        ),
        .target(
            name: "SecurityServices"
        ),
        .target(
            name: "AppleMapView",
            dependencies: [
                "ProxyPackage",
                .product(name: "Entities", package: "Domain")
            ]
        )
    ]
)
