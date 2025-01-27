// Copyright © 2024 TripPiece. All rights reserved

import Foundation
import Moya

enum TravelAPI {
    //get
    case getProgressTravels
    case getTravels
    case getTravelsInfo(travelId: Int)
    case getTravelsInfoDetails(travelId: Int)
    case getThumbnail(travelId: Int)
    case getAllPictures(travelId: Int)
    
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
    
    // 썸네일 수정
    case postUpdateThumbnail(param: UpdateThumbnailRequest)
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
        case .getTravelsInfoDetails(let travelId): return "mytravels/continue/\(travelId)"
        case .getThumbnail(let travelId): return "mytravels/thumbnail/\(travelId)"
        case .getAllPictures(let travelId): return "mytravels/update/\(travelId)"
            
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
            
        case .postUpdateThumbnail(let param):
            return "mytravels/thumbnail/update/\(param.travelId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getProgressTravels, .getTravels, .getTravelsInfo, .getTravelsInfoDetails, .getThumbnail, .getAllPictures:
            return .get
        case .postCreateTravel, .postWherePiece, .postVideoPiece, .postSelfiePiece,
                .postPicturePiece, .postMemoPiece, .postEmojiPiece, .postTravelEnd, .postUpdateThumbnail:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getProgressTravels, .getTravels, .getTravelsInfo, .getTravelsInfoDetails, .getThumbnail, .getAllPictures:
            return .requestPlain
            
        case .postCreateTravel(let param):
            return .requestJSONEncodable(param)
            
        case .postWherePiece(let param):
            return .requestJSONEncodable(param)
        case .postVideoPiece(let param):
            return .requestJSONEncodable(param)
        case .postSelfiePiece(let param):
            var multipartFormDatas: [MultipartFormData] = []
            let memoDescription = ["description": param.memo]
            if let memoData = try? JSONSerialization.data(withJSONObject: memoDescription, options: []),
               let memoJSONString = String(data: memoData, encoding: .utf8) {
                multipartFormDatas.append(MultipartFormData(provider: .data(memoJSONString.data(using: .utf8)!), name: "memo"))
            }
            multipartFormDatas.append(MultipartFormData(provider: .data(param.photo), name: "photo", fileName: "\(UUID().uuidString).png", mimeType: "image/png"))
            return .uploadMultipart(multipartFormDatas)
        case .postPicturePiece(let param):
            return .requestJSONEncodable(param)
        case .postMemoPiece(let param):
            return .requestJSONEncodable(param)
        case .postEmojiPiece(let param):
            return .requestJSONEncodable(param)
            
        case .postTravelEnd:
            return .requestPlain
        case .postUpdateThumbnail(let param):
            return .requestParameters(parameters: [
                "pictureIdList": param.pictureIdList
            ], encoding: URLEncoding.queryString)
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
