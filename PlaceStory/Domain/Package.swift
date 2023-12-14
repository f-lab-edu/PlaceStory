// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Domain",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Entities",
            targets: ["Entities"]
        ),
        .library(
            name: "UseCase",
            targets: ["UseCase"]),
        .library(
            name: "Repositories",
            targets: ["Repositories"])
    ],
    dependencies: [
        .package(path: "ProxyPackage")
    ],
    targets: [
        .target(
            name: "Entities"
        ),
        .target(
            name: "UseCase",
            dependencies: [
                "Entities",
                "Repositories",
                "ProxyPackage"
            ]
        ),
        .target(
            name: "Repositories",
            dependencies: [
                "Entities",
                "ProxyPackage"
            ]
        )
    ]
)
