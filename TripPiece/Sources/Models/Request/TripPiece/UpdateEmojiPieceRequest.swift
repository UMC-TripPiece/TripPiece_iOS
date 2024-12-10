// Copyright © 2024 TripPiece. All rights reserved

import Foundation

struct UpdateEmojiPieceRequest : Codable {
    let tripPieceId : String
    let description : String
    let emojis : [String]
}

