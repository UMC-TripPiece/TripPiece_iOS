// Copyright © 2024 TripPiece. All rights reserved

import Foundation

struct ThumbnailInfo: Codable {
    let id: Int
    let pictureUrl: String
    let travel_thumbnail: Bool?
    var thumbnail_index: Int?
}
