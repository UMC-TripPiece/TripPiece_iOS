// Copyright © 2024 TripPiece. All rights reserved

import Foundation
import Moya

enum TripPieceAPI {
    case deleteTripPiece(tripPieceId: Int)
    
    case getTripPiece(tripPieceId: Int)
    case getAllTripPiece

    case updateVideoPiece(param: UpdateVideoPieceRequest)
    case updatePicturePiece(param: UpdatePhotosPieceRequest)
    case updateMemoPiece(param: UpdateMemoPieceRequest)
    case updateEmojiPiece(param: UpdateEmojiPieceRequest)
}

extension TripPieceAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.NetworkManager.baseURL) else {
            fatalError("fatal error - invalid url")
        }
        return url
    }

    var path: String {
        switch self {
        case .deleteTripPiece(let tripPieceId): return "mytrippieces/delete/\(tripPieceId)"
        case .getTripPiece(let tripPieceId): return "mytrippieces/\(tripPieceId)"
        case .getAllTripPiece: return "mytrippieces/all"

        case .updateVideoPiece(let param): return "mytrippieces/video/update/\(param.tripPieceId)"
        case .updatePicturePiece(let param): return "mytrippieces/picture/update/\(param.tripPieceId)"
        case .updateMemoPiece(let param): return "mytrippieces/memo/update/\(param.tripPieceId)"
        case .updateEmojiPiece(let param): return "mytrippieces/emoji/update/\(param.tripPieceId)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getTripPiece, .getAllTripPiece:
            return .get
        case .updateVideoPiece, .updatePicturePiece, .updateMemoPiece, .updateEmojiPiece:
            return .patch
        case .deleteTripPiece:
            return .delete
        
        }
    }

    var task: Moya.Task {
        switch self {
        case .getTripPiece(let param) :
            return .requestJSONEncodable(param)
        case .getAllTripPiece :
            return .requestPlain
        case .updateVideoPiece(let param) :
            return .requestJSONEncodable(param)
        case .updatePicturePiece(let param) :
            return .requestJSONEncodable(param)
        case .updateMemoPiece(let accessToken) :
            return .requestJSONEncodable(accessToken)
        case .updateEmojiPiece(let param) :
            return .requestJSONEncodable(param)
        case .deleteTripPiece(let param) :
            return .requestJSONEncodable(param)
        }
    }

    var headers: [String : String]? {
        switch self {
        case .updateVideoPiece, .updatePicturePiece :
            return ["Content-Type": "multipart/form-data"]
        default :
            return ["Content-Type": "application/json"]
        }
    }
}
