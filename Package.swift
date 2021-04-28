// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "Swift-for-IoT-sanbox-vapor-sandbox",
    platforms: [
       .macOS(.v10_15)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/uraimo/SwiftyGPIO.git", from: "1.3.3"),
        .package(url: "https://github.com/sroebert/mqtt-nio.git", from: "1.0.1"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "SwiftyGPIO", package: "SwiftyGPIO"),
                .product(name: "MQTTNIO", package: "mqtt-nio"),
                .product(name: "NIO", package:"swift-nio")
    ],
            swiftSettings: [
                // Enable better optimizations when building in Release configuration. Despite the use of
                // the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
                // builds. See <https://github.com/swift-server/guides#building-for-production> for details.
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]
        ),
        .target(name: "Run", dependencies: [.target(name: "App")]),
        .testTarget(name: "AppTests", dependencies: [
            .target(name: "App"),
            .product(name: "XCTVapor", package: "vapor"),
        ])
    ]
)
