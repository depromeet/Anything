// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ProModule",
    platforms: [.iOS(.v10)],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "ProModule",
            targets: ["ProModule"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/ReactiveX/RxSwift", .upToNextMajor(from: "5.1.1")),
        .package(url: "https://github.com/RxSwiftCommunity/RxDataSources", .upToNextMajor(from: "4.0.1")),
        .package(url: "https://github.com/RxSwiftCommunity/RxKeyboard", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/RxSwiftCommunity/RxGesture", .upToNextMajor(from: "3.0.3")),
        .package(url: "https://github.com/RxSwiftCommunity/RxCoreLocation", .upToNextMajor(from: "1.5.0")),
        .package(url: "https://github.com/RxSwiftCommunity/RxOptional", .upToNextMajor(from: "4.1.0")),
        .package(url: "https://github.com/yanniks/RxKingfisher", .revision("27548d2102b5a04373a98c954089cd8291fcdc7f")),
        .package(url: "https://github.com/ReactorKit/ReactorKit", .revision("17c33781d2f1285ef3a8b562dc40a1438e8d3df8")),
        .package(url: "https://github.com/SnapKit/SnapKit", .upToNextMajor(from: "5.0.1")),
        .package(url: "https://github.com/uber/RIBs", .branch("master")),
        .package(url: "https://github.com/devxoul/MoyaSugar", .upToNextMajor(from: "1.3.3")),
        .package(url: "https://github.com/devxoul/RxViewController", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/devxoul/SwiftyColor", .upToNextMajor(from: "1.2.1")),
        .package(url: "https://github.com/devxoul/Then", .upToNextMajor(from: "2.7.0")),
        .package(url: "https://github.com/devxoul/URLNavigator", .upToNextMajor(from: "2.3.0")),
        .package(url: "https://github.com/Moya/Moya", .upToNextMajor(from: "14.0.0")),
        .package(url: "https://github.com/slackhq/PanModal", .upToNextMajor(from: "1.2.7")),
        .package(url: "https://github.com/AliSoftware/Reusable", .upToNextMajor(from: "4.1.1")),
        .package(url: "https://github.com/evgenyneu/Cosmos", .upToNextMajor(from: "23.0.0")),
        .package(url: "https://github.com/CocoaLumberjack/CocoaLumberjack", .upToNextMajor(from: "3.6.2")),
        .package(name: "Lottie", url: "https://github.com/airbnb/lottie-ios", .upToNextMajor(from: "3.1.9")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "ProModule",
            dependencies: [
                "RxSwift",
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "RxRelay", package: "RxSwift"),
                "RxDataSources",
                "RxKeyboard",
                "RxGesture",
                "RxCoreLocation",
                "RxOptional",
                "RxKingfisher",
                "ReactorKit",
                "SnapKit",
                "RIBs",
                "MoyaSugar",
                "RxViewController",
                "SwiftyColor",
                "Then",
                "URLNavigator",
                "Moya",
                .product(name: "RxMoya", package: "Moya"),
                "PanModal",
                "Reusable",
                "Cosmos",
                "CocoaLumberjack",
                .product(name: "CocoaLumberjackSwift", package: "CocoaLumberjack"),
                "Lottie",
        ]),
        .testTarget(
            name: "ProModuleTests",
            dependencies: ["ProModule"]),
    ]
)
