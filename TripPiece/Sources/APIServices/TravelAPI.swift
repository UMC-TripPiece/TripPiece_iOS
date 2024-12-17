// Copyright © 2024 TripPiece. All rights reserved

import Foundation
import Moya

enum TravelAPI {
    //get
    case getProgressTravels
    case getTravels
    case getTravelsInfo(travelId: Int)
    case getTravelsInfoDetails(travelId: Int)
    
    //여행기 생성
    case postCreateTravel(param: CreateTravelRequest)
    
    //여행 조각 추가
    case postWherePiece(param: CreateVideoPieceRequest)
    case postVideoPiece(param: CreateVideoPieceRequest)
    case postSelfiePiece(param: CreatePhotoPieceRequest) //사진 한 장
    case postPicturePiece(param: CreatePhotosPieceRequest) //사진 여러 장
    case postMemoPiece(param: CreateMemoPieceRequest)
    case postEmojiPiece(param: CreateEmojiPieceRequest)
    
    //여행 완료
    case postTravelEnd(travelId: Int)
}

extension TravelAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.NetworkManager.baseURL) else {
            fatalError("fatal error - invalid url")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getProgressTravels: return "mytravels"
        case .getTravels: return "travels"
        case .getTravelsInfo(let travelId): return "travels/\(travelId)"
        case .getTravelsInfoDetails(let travelId): return "mytravels/\(travelId)/continue"
            
        case .postCreateTravel: return "mytravels"
            
        case .postWherePiece(let param):
            return "mytravels/where/\(param.travelId)"
        case .postVideoPiece(let param):
            return "mytravels/video/\(param.travelId)"
        case .postSelfiePiece(let param):
            return "mytravels/selfie/\(param.travelId)"
        case .postPicturePiece(let param):
            return "mytravels/picture/\(param.travelId)"
        case .postMemoPiece(let param):
            return "mytravels/memo/\(param.travelId)"
        case .postEmojiPiece(let param):
            return "mytravels/emoji/\(param.travelId)"
            
        case .postTravelEnd(let travelId): return "mytravels/end/\(travelId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getProgressTravels, .getTravels, .getTravelsInfo, .getTravelsInfoDetails:
            return .get
        case .postCreateTravel, .postWherePiece, .postVideoPiece, .postSelfiePiece,
                .postPicturePiece, .postMemoPiece, .postEmojiPiece, .postTravelEnd:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getProgressTravels, .getTravels, .getTravelsInfo, .getTravelsInfoDetails:
            return .requestPlain
            
        case .postCreateTravel(let param):
            return .requestJSONEncodable(param)
            
        case .postWherePiece(let param):
            return .requestJSONEncodable(param)
        case .postVideoPiece(let param):
            return .requestJSONEncodable(param)
        case .postSelfiePiece(let param):
            return .requestJSONEncodable(param)
        case .postPicturePiece(let param):
            return .requestJSONEncodable(param)
        case .postMemoPiece(let param):
            return .requestJSONEncodable(param)
        case .postEmojiPiece(let param):
            return .requestJSONEncodable(param)
            
        case .postTravelEnd:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .postCreateTravel, .postWherePiece, .postVideoPiece, .postSelfiePiece, .postPicturePiece :
            return ["Content-Type": "multipart/form-data"]
        default :
            return ["Content-Type": "application/json"]
        }
    }
}
