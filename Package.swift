// swift-tools-version: 6.2
import PackageDescription
import Foundation

// NOTE: swap "georgioscc" for your actual GitHub username/org if different.
let version: Version = "0.1.0"
let coreChecksum = "PASTE_DEMOMAINCORE_CHECKSUM_HERE"
let uiChecksum = "PASTE_DEMOMAINUI_CHECKSUM_HERE"
let foundationVersion: Version = "0.1.0"
let configurationVersion: Version = "0.1.0"
let releaseType = "releases"

let package = Package(
	name: "DemoMain",
	platforms: [.iOS(.v17)],
	products: [
		.library(
			name: "DemoMainCore",
			targets: ["DemoMainCoreWrapper"]
		),
		.library(
			name: "DemoMainUI",
			targets: ["DemoMainUIWrapper"]
		),
	],
	dependencies: [
		.package(url: "https://github.com/georgioscc/demo-foundation-ios.git", exact: foundationVersion),
		.package(url: "https://github.com/georgioscc/demo-configuration-ios.git", exact: configurationVersion),
	],
	targets: [
		// IMPORTANT: this name MUST match the actual framework/module name
		// shipped inside the zip (i.e. what the local build package's target
		// was named) — not an arbitrary label. That's why this is
		// "DemoMainCore", not "DemoMainCoreBinary".
		.binaryTarget(
			name: "DemoMainCore",
			url: "https://downloads.georgioscc.dev/demo-main/\(releaseType)/ios/\(version)/DemoMainCore.xcframework.zip",
			checksum: coreChecksum
		),
		// Thin source-only wrapper target, deliberately named differently from
		// the binary target above (naming collision otherwise). Its only real
		// job is to declare dependencies on DemoFoundation and
		// DemoConfiguration so SwiftPM/Xcode creates the graph edges that pull
		// both in automatically — the same technique Mapbox uses with
		// MapboxMapsWrapper vs. the MapboxMaps binary target.
		.target(
			name: "DemoMainCoreWrapper",
			dependencies: [
				"DemoMainCore",
				.product(name: "DemoFoundation", package: "demo-foundation-ios"),
				.product(name: "DemoConfiguration", package: "demo-configuration-ios"),
			],
			path: "Sources/DemoMainCoreWrapper"
		),
		// Same naming rule applies here: must match the shipped module name.
		.binaryTarget(
			name: "DemoMainUI",
			url: "https://downloads.georgioscc.dev/demo-main/\(releaseType)/ios/\(version)/DemoMainUI.xcframework.zip",
			checksum: uiChecksum
		),
		// Also pulls in DemoMainCoreWrapper (not the raw DemoMainCore binary
		// target directly — going through the wrapper ensures Foundation/
		// Configuration are pulled in transitively too), plus Foundation and
		// Configuration directly, matching the real UI packages' dependency shape.
		.target(
			name: "DemoMainUIWrapper",
			dependencies: [
				"DemoMainUI",
				"DemoMainCoreWrapper",
				.product(name: "DemoFoundation", package: "demo-foundation-ios"),
				.product(name: "DemoConfiguration", package: "demo-configuration-ios"),
			],
			path: "Sources/DemoMainUIWrapper"
		),
	]
)
