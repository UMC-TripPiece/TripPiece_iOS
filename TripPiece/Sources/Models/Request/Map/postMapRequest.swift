// Copyright © 2024 TripPiece. All rights reserved

import Foundation

struct postMapRequest : Codable {
    let userId : String
    let countryCode : String
    let color : String
    let cityId : Int
}
