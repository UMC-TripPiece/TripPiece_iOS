// Copyright © 2024 TripPiece. All rights reserved

import Foundation

struct CreatePhotoPieceRequest : Codable { //사진 한 장
    let travelId : Int
    let memo : String
    let photo : Data
}

struct CreatePhotosPieceRequest : Codable { //사진 여러 장
    let travelId : Int
    let memo : String
    let photos : [Data]
}
