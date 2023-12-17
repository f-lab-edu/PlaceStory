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
        .package(path: "../LoggedIn")
    ],
    targets: [
        .target(
            name: "AppRoot",
            dependencies: [
                "ProxyPackage",
                "LoggedOut",
                .product(name: "UseCase", package: "Domain"),
                .product(name: "RepositoryImps", package: "Platform"),
                "LoggedIn",
            ]
        )
    ]
)
