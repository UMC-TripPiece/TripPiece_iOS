// Copyright © 2024 TripPiece. All rights reserved

import Foundation

struct UpdateThumbnailRequest: Codable {
    let travelId: Int
    let pictureIdList: [Int]
}
