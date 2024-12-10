// Copyright © 2024 TripPiece. All rights reserved

import Foundation

struct CreateVideoPieceRequest : Codable {
    let travelId : String
    let description : String
    let video : Data
}
