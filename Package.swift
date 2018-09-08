import PackageDescription

let package = Package(
    name: "POPAPIKit",
    dependencies: [
		.package(url: "https://github.com/antitypical/Result.git", from: "4.0.0"),
    ],
    exclude: ["Sources/AbstractInputStream.m"]
    swiftLanguageVersions: [4]
)
