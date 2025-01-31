// Copyright © 2024 TripPiece. All rights reserved

import Foundation

struct CreateTravelRequest: Codable {
    var cityName: String
    var countryName: String
    var title: String
    var startDate: String
    var endDate: String
    // Base64
    var thumbnail: Data?
}
