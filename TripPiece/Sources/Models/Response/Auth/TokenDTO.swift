// Copyright © 2024 TripPiece. All rights reserved

import Foundation

struct TokenDto: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: TokenResult
}

struct TokenResult: Codable {
    let id: Int
    let email: String
    let nickname: String
    let createdAt: String
    let accessToken: String
    let refreshToken: String
}
