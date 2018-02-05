// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Parade",
    products: [
        .library(name: "Parade", targets: ["Parade"])
    ],
    targets: [
        .target(name: "Parade", dependencies: []),
    ]
)
