// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ProxyPackage",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "ProxyPackage",
            targets: ["ProxyPackage"]),
        .library(
            name: "Utils",
            targets: ["Utils"]),
        .library(
            name: "CommonUI",
            targets: ["CommonUI"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/DevYeom/ModernRIBs.git", from: "1.0.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1")),
        .package(url: "https://github.com/realm/realm-swift.git", .upToNextMajor(from: "10.40.0")),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", exact: "10.23.0")
    ],
    targets: [
        .target(
            name: "ProxyPackage",
            dependencies: [
                .product(name: "ModernRIBs", package: "ModernRIBs"),
                .product(name: "SnapKit", package: "SnapKit"),
                .product(name: "Realm", package: "realm-swift"),
                .product(name: "RealmSwift", package: "realm-swift"),
                .product(name: "FirebaseDatabase", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk")
            ]
        ),
        .target(
            name: "Utils"
        ),
        .target(
            name: "CommonUI",
            dependencies: [
                .product(name: "SnapKit", package: "SnapKit")
            ]
        ),
        .testTarget(
            name: "ProxyPackageTests",
            dependencies: ["ProxyPackage"]),
    ]
)
