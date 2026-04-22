// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "athmovil-checkout-sdk",
    defaultLocalization: "en",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "athmovil_checkout", 
            targets: ["athmovil_checkout"]
        )
    ],
    targets: [
        .target(
            name: "athmovil_checkout",
            path: "Sources/AthmovilCheckout",
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "athmovil-checkoutTests",
            dependencies: ["athmovil_checkout"],
            path: "athmovil-checkoutTests"
        ),
        .testTarget(
            name: "athmovil_checkoutIntegrationTests",
            dependencies: ["athmovil_checkout"],
            path: "athmovil_checkoutIntegrationTests"
        )
    ]
)
