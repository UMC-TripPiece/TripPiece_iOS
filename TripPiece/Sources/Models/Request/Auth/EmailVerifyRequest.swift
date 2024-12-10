// Copyright © 2024 TripPiece. All rights reserved

import Foundation

struct EmailVerifyRequest : Codable {
    let email : String
    let code : String
}
