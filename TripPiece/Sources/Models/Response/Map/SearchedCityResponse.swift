// Copyright © 2024 TripPiece. All rights reserved

import Foundation

struct SearchedCityResponse: Codable {
    let cityName: String
    let countryName: String
    let cityDescription: String
    let countryImage: String
    let logCount: Int
    let cityId: Int
}
