// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
        name: "Swift_FP",
        products: [
            // Products define the executables and libraries produced by a package, and make them visible to other packages.
            .library(
                    name: "Swift_FP",
                    targets: ["Swift_FP"]),
        ],
        dependencies: [
            // Dependencies declare other packages that this package depends on.
            // .package(url: /* package url */, from: "1.0.0"),
            .package(url: "https://github.com/bow-swift/bow.git", from: "0.7.0")
        ],
        targets: [
            // Targets are the basic building blocks of a package. A target can define a module or a test suite.
            // Targets can depend on other targets in this package, and on products in packages which this package depends on.
            .target(
                    name: "Swift_FP",
                    dependencies: [
                        "Bow",
                        "BowOptics",
                        "BowRecursionSchemes",
                        "BowFree",
                        "BowGeneric",
                        "BowEffects",
                        "BowRx"
                    ]),
            .testTarget(
                    name: "Swift_FPTests",
                    dependencies: [
                        "Swift_FP",

                        // Type class laws
                        "BowLaws",
                        "BowOpticsLaws",
                        "BowEffectsLaws",

                        // Generators for PBT with SwiftCheck
                        "BowGenerators",
                        "BowFreeGenerators",
                        "BowEffectsGenerators",
                        "BowRxGenerators"
                    ]),
        ]
)
