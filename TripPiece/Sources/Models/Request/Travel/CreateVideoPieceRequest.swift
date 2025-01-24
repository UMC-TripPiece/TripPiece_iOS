// Copyright © 2024 TripPiece. All rights reserved

import Foundation

struct CreateVideoPieceRequest : Codable {
    let travelId : Int
    let description : String
    let video : Data
}
