// Copyright © 2024 TripPiece. All rights reserved

import Foundation

struct EmailVerifyResponse : Codable {
    let isSuccess : Bool
    let code : String
    let message : String
    let result : String
}
