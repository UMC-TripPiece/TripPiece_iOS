// Copyright © 2024 TripPiece. All rights reserved

import Foundation

struct TravelsDetailInfo: Codable {
    let id: Int
    let description: String
    let category: String
    let mediaUrls: [String]?
    let createdAt: String
}
