// Copyright © 2024 TripPiece. All rights reserved

import Foundation

struct MemberInfoResult: Codable {
    let userId: Int
    let nickname: String
    let profileImg: String
    let travelNum: Int
    let isPublic: Bool
    let gender: String
    let country: String
    let birth: String
}

