// Copyright © 2024 TripPiece. All rights reserved

import Foundation

struct UpdatePhotoPieceRequest : Codable { //사진 한 장
    let tripPieceId : String
    let memo : String
    let photo : Data
}

struct UpdatePhotosPieceRequest : Codable { //사진 여러 장
    let tripPieceId : String
    let memo : String
    let photos : [Data]
}
