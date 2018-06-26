// swift-tools-version:4.0
// Generated automatically by Perfect Assistant
// Date: 2018-06-20 22:13:14 +0000
import PackageDescription

let package = Package(
	name: "LinkDirector",
	dependencies: [
		.package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", "3.0.0"..<"4.0.0"),
		.package(url: "https://github.com/PerfectlySoft/Perfect-PostgreSQL.git", "3.0.0"..<"4.0.0"),
		.package(url: "https://github.com/PerfectlySoft/Perfect-Redis.git", "3.0.0"..<"4.0.0"),
		.package(url: "https://github.com/PerfectlySoft/Perfect-CloudFormation.git", "0.0.0"..<"1.0.0"),
		.package(url: "https://github.com/PerfectlySoft/Perfect-Mustache.git", from: "3.0.0")
	],
	targets: [
		.target(name: "LinkDirector", dependencies: ["PerfectHTTPServer", "PerfectPostgreSQL", "PerfectRedis", "PerfectCloudFormation", "PerfectMustache"])
	]
)
