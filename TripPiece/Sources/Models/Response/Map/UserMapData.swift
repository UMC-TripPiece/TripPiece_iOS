// Copyright © 2024 TripPiece. All rights reserved

import Foundation

struct ColorVisitRecord: Codable {
    //let visitId: Int
    //let userId: Int
    let countryCode: String
    let color: String
}

struct StatsVisitRecord: Codable {
    let countryCount: Int
    let cityCount: Int
    let countryCodes: [String]
    let cityIds: [Int]
}
