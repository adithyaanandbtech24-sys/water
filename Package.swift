// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "HitaApp",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .executable(name: "HitaApp", targets: ["HitaApp"])
    ],
    targets: [
        .executableTarget(
            name: "HitaApp",
            path: "Sources",
            resources: [
                .process("Resources")
            ]
        )
    ]
)
