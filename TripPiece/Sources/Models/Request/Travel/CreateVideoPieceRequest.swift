// Copyright © 2024 TripPiece. All rights reserved

import Foundation

struct CreateVideoPieceRequest : Codable {
    let travelId : Int
    let memo : MemoObject
    let video : Data
    let videoName: String?
    
    init(travelId: Int, memo: MemoObject, video: Data, videoName: String? = nil) {
        self.travelId = travelId
        self.memo = memo
        self.video = video
        self.videoName = videoName
    }
//    let video: String
}
