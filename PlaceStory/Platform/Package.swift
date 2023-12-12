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
    ],
    dependencies: [
      .package(path: "../Domain"),
      .package(path: "../ProxyPackage")
    ],
    targets: [
        .target(
            name: "LocalStorage",
            dependencies: [
                "ProxyPackage",
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
                .product(name: "Repositories", package: "Domain"),
                "LocalStorage",
                .product(name: "Utils", package: "ProxyPackage"),
                "Model"
            ]
        ),
    ]
)
