// Copyright © 2024 TripPiece. All rights reserved

import Foundation

struct TrendingResponse: Codable {
    let id: Int
    let city: String
    let country: String
    let thumbnail: String?
    let count: Int
}
