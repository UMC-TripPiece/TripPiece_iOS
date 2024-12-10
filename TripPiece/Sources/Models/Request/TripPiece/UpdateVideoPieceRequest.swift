// Copyright © 2024 TripPiece. All rights reserved

import Foundation

struct UpdateVideoPieceRequest : Codable {
    let tripPieceId : String
    let description : String
    let video : Data
}
