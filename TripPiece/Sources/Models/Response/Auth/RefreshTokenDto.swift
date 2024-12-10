// Copyright © 2024 TripPiece. All rights reserved

import Foundation

struct RefreshTokenDto : Decodable {
    let isSuccess : Bool
    let code : String
    let result : Tokens
}

struct Tokens : Decodable {
    let accessToken : String
    let refreshToken : String
}
