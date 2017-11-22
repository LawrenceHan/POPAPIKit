import PackageDescription

let package = Package(
    name: "POPAPIKit",
    dependencies: [
        .Package(url: "https://github.com/antitypical/Result.git", from: "3.0.0"),
    ],
    targets: [
	.target(
            name: "APIKit", 
            dependencies: ["Result"],
            exclude: ["BodyParameters/AbstractInputStream.m"]
        )
    ],
    swiftLanguageVersions: [4]
)
