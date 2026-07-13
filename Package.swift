// swift-tools-version: 6.2
import PackageDescription
import Foundation

let version: Version = "0.1.0"
let coreChecksum = "d30dd74f21017d0e536e64cc540fd4fd7a549d3643f30670b3029c1829b6ba90"
let uiChecksum = "5444f3f3bb3de1914dcc437f2ce33fb13f5319affbc934a739077c69b5d02e3a"
let foundationVersion: Version = "0.1.0"
let configurationVersion: Version = "0.1.0"
let releaseType = "releases"

let package = Package(
	name: "DemoMain",
	platforms: [.iOS(.v17)],
	products: [
		.library(
			name: "DemoMainCore",
			targets: ["DemoMainCore"]
		),
		.library(
			name: "DemoMainUI",
			targets: ["DemoMainUI"]
		),
	],
	dependencies: [
		.package(url: "https://github.com/georgioscc/demo-foundation-ios.git", exact: foundationVersion),
		.package(url: "https://github.com/georgioscc/demo-configuration-ios.git", exact: configurationVersion),
	],
	targets: [
		.binaryTarget(
			name: "DemoMainCoreBinary",
			url: "https://downloads.georgioscc.dev/demo-main/\(releaseType)/ios/\(version)/DemoMainCore.xcframework.zip",
			checksum: coreChecksum
		),
		// Thin source-only wrapper target. Its only real job is to declare
		// dependencies on DemoFoundation and DemoConfiguration so SwiftPM/Xcode
		// creates the graph edges that pull both in automatically — the same
		// technique Mapbox uses with MapboxMapsWrapper.
		.target(
			name: "DemoMainCore",
			dependencies: [
				"DemoMainCoreBinary",
				.product(name: "DemoFoundation", package: "demo-foundation-ios"),
				.product(name: "DemoConfiguration", package: "demo-configuration-ios"),
			],
			path: "Sources/DemoMainCore"
		),
		.binaryTarget(
			name: "DemoMainUIBinary",
			url: "https://downloads.georgioscc.dev/demo-main/\(releaseType)/ios/\(version)/DemoMainUI.xcframework.zip",
			checksum: uiChecksum
		),
		// Same pattern as above, but for UI: also pulls in DemoMainCore
		// (the wrapper target above, not the raw binary), plus Foundation and
		// Configuration directly, matching the real UI packages' dependency shape.
		.target(
			name: "DemoMainUI",
			dependencies: [
				"DemoMainUIBinary",
				"DemoMainCore",
				.product(name: "DemoFoundation", package: "demo-foundation-ios"),
				.product(name: "DemoConfiguration", package: "demo-configuration-ios"),
			],
			path: "Sources/DemoMainUI"
		),
	]
)
