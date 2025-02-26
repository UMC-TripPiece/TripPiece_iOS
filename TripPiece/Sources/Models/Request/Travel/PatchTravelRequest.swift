// Copyright © 2024 TripPiece. All rights reserved

import Foundation

struct PatchTravelRequest: Codable {
    var travelId: Int
    var thumbnail: Data?
    var title: String
    var startDate: String
    var endDate: String
}
