// Copyright © 2024 TripPiece. All rights reserved

import Foundation

struct SearchResponse: Codable {
    let id: Int
    let title: String
    let thumbnail: String
    let startDate: String
    let endDate: String
    let cityName: String
    let countryName: String
    let status: String
    let userId: Int
    let profileImg: String
    let nickname: String
}
