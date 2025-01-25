// Copyright © 2024 TripPiece. All rights reserved

import Foundation

struct CreateEmojiPieceRequest : Codable {
    let travelId : Int
    let description : String
    let emojis : [String]
}

