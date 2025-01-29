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
            var formData = [MultipartFormData]()
            
            // (1) data 파트: 여행 정보(도시, 날짜 등)를 JSON으로 만들어서 담기
            let travelDict: [String: Any] = [
                "cityName": param.cityName,
                "countryName": param.countryName,
                "title": param.title,
                "startDate": param.startDate,
                "endDate": param.endDate
            ]
            
            if let jsonData = try? JSONSerialization.data(withJSONObject: travelDict, options: []) {
                let multipartItem = MultipartFormData(
                    provider: .data(jsonData),
                    name: "data",                // 서버가 요구하는 파라미터 key (스웨거에서 'data'라고 표기)
                    fileName: "data.json",       // 굳이 파일명은 아무거나, 없애도 상관없을 수 있음
                    mimeType: "application/json" // JSON으로 전송
                )
                formData.append(multipartItem)
            }
            
            // (2) thumbnail 파트: 실제 이미지 “바이너리”를 파일 형식으로 전송
            if let thumbnailData = param.thumbnail {
                let thumbnailPart = MultipartFormData(
                    provider: .data(thumbnailData),
                    name: "thumbnail",           // 스웨거에서 'thumbnail' 파라미터
                    fileName: "thumbnail.jpg",   // 확장자 jpg/png 맞춰서
                    mimeType: "image/jpeg"       // jpeg라면 "image/jpeg"
                )
                formData.append(thumbnailPart)
            }
            
            return .uploadMultipart(formData)
            
        case .postWherePiece(let param):
            return .requestJSONEncodable(param)
        case .postVideoPiece(let param):
            return .requestJSONEncodable(param)
            
        case .postSelfiePiece(let param):
            return .requestJSONEncodable(param)
            
        case .postPicturePiece(let param):
            var formData = [MultipartFormData]()
            
            // (A) memo: string
            let memoObject: [String: Any] = ["description": param.memo.description]  // 딕셔너리로 변환!
            if let memoData = try? JSONSerialization.data(withJSONObject: memoObject, options: []) {
                let memoPart = MultipartFormData(
                    provider: .data(memoData),
                    name: "memo",
                    fileName: "memo.json",   // JSON으로 보내니까 파일명 추가
                    mimeType: "application/json"
                )
                formData.append(memoPart)
            }
            
            // (B) photos: 여러 개의 바이너리
            // swagger에 "photos"라 하면, name="photos"로 각 파일을 append
            for (index, imageData) in param.photos.enumerated() {
                let photoPart = MultipartFormData(
                    provider: .data(imageData),
                    name: "photos",
                    fileName: "photo\(index).jpg",
                    mimeType: "image/jpeg"
                )
                formData.append(photoPart)
            }
            return .uploadMultipart(formData)
            
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
