// Copyright © 2024 TripPiece. All rights reserved

import Foundation

struct MemberInfo: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: MemberInfoResult
}

struct MemberInfoResult: Codable {
    let nickname: String
    let profileImg: String
    let travelNum: Int
    let isPublic: Bool
    let gender: String
    let country: String
    let birth: String
}

