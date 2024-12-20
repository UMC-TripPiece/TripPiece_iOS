// Copyright © 2024 TripPiece. All rights reserved

import Foundation

enum TravelItemType: Int {
    case all = 0
    case photo
    case video
    case music
    case memo
    
    var displayName: String {
        switch self {
        case .all: return "전체"
        case .photo: return "📷 사진"
        case .video: return "🎬 영상"
        case .music: return "🎶 음악"
        case .memo: return "✍🏻 메모"
        }
    }
    
    var categoryKey: String? {
        switch self {
        case .all: return nil
        case .photo: return "PICTURE"
        case .video: return "VIDEO"
        case .music: return "MUSIC"
        case .memo: return "MEMO"
        }
    }
}
