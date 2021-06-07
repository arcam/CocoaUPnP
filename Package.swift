// swift-tools-version:5.4
import PackageDescription

let package = Package(
  name: "CocoaUPnP",
  platforms: [.tvOS(.v12), .iOS(.v12)],
  products: [.library(name: "CocoaUPnP", targets: ["CocoaUPnP"])],
  dependencies: [
    // A delightful networking framework for iOS, macOS, watchOS, and tvOS.
    .package(name: "AFNetworking", url: "https://github.com/AFNetworking/AFNetworking.git", .upToNextMajor(from: "4.0.1")),

    // Asynchronous socket networking library for Mac and iOS
    .package(name: "CocoaAsyncSocket", url: "https://github.com/robbiehanson/CocoaAsyncSocket.git", .upToNextMajor(from: "7.6.5")),

    // The #1 HTTP server for iOS, macOS & tvOS (also includes web based uploader & WebDAV server)
    .package(name: "GCDWebServers", url: "https://github.com/nostradani/GCDWebServer.git", .branch("master")),

    // A sensible way to deal with XML & HTML for iOS & macOS
    .package(name: "Ono", url: "https://github.com/jay18001/Ono.git", .branch("master")),
  ],
  targets: [
    .target(
      name: "CocoaUPnP",
      dependencies: [
        "AFNetworking",
        "CocoaAsyncSocket",
        "GCDWebServers",
        "Ono",
      ],
      path: "CocoaUPnP",
      publicHeadersPath: ""
    ),
  ]
)
