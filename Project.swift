import ProjectDescription

let project = Project(
    name: "TripPiece",
    targets: [
        .target(
            name: "TripPiece",
            destinations: .init([.iPhone]),
            product: .app,
            bundleId: "url.MyWorldApp.TripPieces",
            deploymentTargets: .iOS("16.6"),
            infoPlist: .extendingDefault(
                with: [
                    "UIUserInterfaceStyle" : "Light", // 다크모드 제거
                    "UISupportedInterfaceOrientations" : ["UIInterfaceOrientationPortrait"], // 화면 방향 세로 고정
                    "UILaunchStoryboardName": "",
                    "CFBundleDisplayName" : "여행조각",
                    "CFBundleIcons": [
                                "CFBundlePrimaryIcon": [
                                    "CFBundleIconFiles": ["AppIcon"],
                                    "UIPrerenderedIcon": true
                                ]
                            ],
                    "CFBundleDevelopmentRegion" : "ko_KR",
                    "UIApplicationSceneManifest": [
                        "UIApplicationSupportsMultipleScenes": false,
                        "UISceneConfigurations": [
                            "UIWindowSceneSessionRoleApplication": [
                                [
                                    "UISceneConfigurationName": "Default Configuration",
                                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                                ],
                            ]
                        ]
                    ],
                    "NSAppTransportSecurity" : [
                        "NSAllowsArbitraryLoads" : true
                    ],
                    "KAKAO_NATIVE_APP_KEY" : "b30c067a8e1ee82121d9dad510240fbe",
                    "CFBundleURLTypes" : [
                        [
                        "CFBundleTypeRole" : "Editor",
                        "CFBundleURLName" : "kakaologin",
                        "CFBundleURLSchemes" : ["kakao74177ce7b14b89614c47ac7d51464b95"]
                        ],
                    ],
                    "LSApplicationQueriesSchemes" : ["kakaokompassauth" , "kakaolink"],
                ]
            ),
            sources: ["TripPiece/Sources/***"],
            resources: ["TripPiece/Resources/***"],
            dependencies: [
                .external(name: "Moya"),
                .external(name: "SnapKit"),
                .external(name: "KeychainSwift"),
                
                .external(name: "KakaoSDK"),
                .external(name: "KakaoSDKAuth"),
                .external(name: "KakaoSDKCert"),
                .external(name: "KakaoSDKCertCore"),
                .external(name: "KakaoSDKCommon"),
                
                .external(name: "FirebaseAuth"),
                .external(name: "FirebaseCore"),
                .external(name: "FirebaseMessaging"),
                .external(name: "FirebaseFirestore"),
//                .external(name: "FirebaseAnalytics"),
                .external(name: "SDWebImage"),
                .external(name: "Then"),
                .external(name: "SwiftyToaster"),
                .external(name: "InteractiveMap"),
                .external(name: "GoogleMaps"),
                .external(name: "SwiftyJSON"),
                .external(name: "Macaw")
            ]
        ),
        .target(
            name: "TripPieceTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.TripPieceTests",
            infoPlist: .default,
            sources: ["TripPiece/Tests/**"],
            resources: [],
            dependencies: [.target(name: "TripPiece")]
        ),
    ],
    fileHeaderTemplate: "Copyright © 2024 TripPiece. All rights reserved"
)
