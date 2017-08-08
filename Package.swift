import PackageDescription

let package = Package(
    name: "POPAPIKit",
    dependencies: [
        .Package(url: "https://github.com/antitypical/Result.git", majorVersion: 3),
    ],
    exclude: ["Sources/AbstractInputStream.m"]
)
