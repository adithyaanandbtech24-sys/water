// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Bubbluu",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .executable(name: "Bubbluu", targets: ["Bubbluu"])
    ],
    targets: [
        .executableTarget(
            name: "Bubbluu",
            resources: [
                .process("Resources")
            ],
            linkerSettings: [
                .unsafeFlags([
                    "-Xlinker", "-sectcreate",
                    "-Xlinker", "__TEXT",
                    "-Xlinker", "__info_plist",
                    "-Xlinker", "Sources/Info.plist"
                ])
            ]
        )
    ]
)
