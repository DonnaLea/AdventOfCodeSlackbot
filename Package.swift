// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AdventOfCodeSlackbot",
    dependencies: [
      // Dependencies declare other packages that this package depends on.
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
          name: "AdventOfCodeSlackbot",
          dependencies: ["AdventOfCodeSlackbotCore"]
        ),
        .target(
          name: "AdventOfCodeSlackbotCore",
          dependencies: []
        ),
        .testTarget(
            name: "AdventOfCodeSlackbotTests",
            dependencies: ["AdventOfCodeSlackbotCore"]
        ),
    ]
)
