// Copyright © 2024 TripPiece. All rights reserved

import Foundation

struct CreateTravelRequest : Codable {
    let cityName : String
    let countryName : String
    let title : String
    let startDate : String
    let endDate : String
}
