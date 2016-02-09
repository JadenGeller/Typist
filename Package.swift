
import PackageDescription

let package = Package(
    name: "Typist",
    dependencies: [
        .Package(url: "https://github.com/JadenGeller/Axiomatic.git", majorVersion: 1)
    ]
)
