// Copyright © 2024 TripPiece. All rights reserved

import Foundation

//LoginDto
struct LoginRequest : Codable {
    let email : String
    let password : String
}

//KakaoLoginDto
struct KakaoLoginRequest : Codable {
    let email : String
    let providerId : Int64
}
