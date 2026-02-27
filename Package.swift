// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "FulhamKit",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "FulhamKit",
            targets: ["FulhamKit"]
        )
    ],
    targets: [
        .target(
            name: "FulhamKit",
            path: "Sources/FulhamKit"
        )
    ]
)
