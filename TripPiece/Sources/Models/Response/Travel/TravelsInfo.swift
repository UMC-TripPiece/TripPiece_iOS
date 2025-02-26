// Copyright © 2024 TripPiece. All rights reserved

import Foundation

struct TravelsInfo: Codable { //multi Response
    let id: Int
    let title: String
    let thumbnail: String
    var startDate: String
    var endDate: String
    let cityName: String
    let countryName: String
    let status: String
    let countryImage: String
    
}
