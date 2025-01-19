// Copyright © 2024 TripPiece. All rights reserved

import Foundation

struct MapRequest : Codable {
    let userId : Int
    let countryCode : String
    let color : String
    let cityId : Int
}
