// swift-tools-version: 6.0
@preconcurrency import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        productTypes: ["Moya" : .framework,
                       "SnapKit": .framework,
                       "KeychainSwift" : .framework,
                       "KakaoSDK": .staticLibrary,
                       "KakaoSDKAuth": .staticLibrary,
                       "KakaoSDKCert": .staticLibrary,
                       "KakaoSDKCertCore": .staticLibrary,
                       "KakaoSDKCommon": .staticLibrary,
                       "FirebaseCore" : .staticLibrary,
                       "FirebaseAuth" : .staticLibrary,
                       "FirebaseMessaging" : .staticLibrary,
                       "FirebaseFirestore" : .staticLibrary,
                       "SDWebImage" : .framework,
                       "SwiftyToaster" : .framework,
                       "InteractiveMap" : .framework,
                       "GoogleMaps" : .framework,
                       "SwiftyJSON" : .framework,
                       "Macaw" : .framework
                      ]
    )
#endif

let package = Package(
    name: "TripPiece",
    dependencies: [
        .package(url: "https://github.com/Moya/Moya.git", from: "15.0.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.0.0"),
        .package(url: "https://github.com/evgenyneu/keychain-swift.git", from: "24.0.0"),
        .package(url: "https://github.com/kakao/kakao-ios-sdk", from: "2.23.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "11.4.0"),
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.19.7"),
        .package(url: "https://github.com/noeyiz/SwiftyToaster.git", from: "1.0.2"),
        .package(url: "https://github.com/grandsir/InteractiveMap", .branch("main")),
        .package(url: "https://github.com/devxoul/Then", from: "3.0.0"),
        .package(url: "https://github.com/googlemaps/ios-maps-sdk", from: "9.1.0"),
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "5.0.2"),
        .package(url: "https://github.com/H0sungKim/Macaw.git", branch: "master")
    ]
)
