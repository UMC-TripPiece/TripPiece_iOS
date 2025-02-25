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
            var multipartFormDatas: [MultipartFormData] = []
            let memoDescription = ["description": param.memo.description]
            if let memoData = try? JSONSerialization.data(withJSONObject: memoDescription, options: []),
               let memoJSONString = String(data: memoData, encoding: .utf8) {
                multipartFormDatas.append(MultipartFormData(provider: .data(memoJSONString.data(using: .utf8)!), name: "memo"))
            }
            multipartFormDatas.append(MultipartFormData(provider: .data(param.video), name: "video", fileName: param.videoName ?? "\(UUID().uuidString).mp4", mimeType: "video/mp4"))
            return .uploadMultipart(multipartFormDatas)
        case .postVideoPiece(let param):
            var formData = [MultipartFormData]()
            
            let memoObject: [String: Any] = ["description": param.memo.description]  // 딕셔너리로 변환!
            if let memoData = try? JSONSerialization.data(withJSONObject: memoObject, options: []) {
                let memoPart = MultipartFormData(
                    provider: .data(memoData),
                    name: "memo"
                )
                formData.append(memoPart)
            }

            // (2) `video`는 바이너리 파일로 전송
            let videoMimeType: String

            // MOV 여부를 판별할 수 없으므로 기본적으로 "video/mp4" 사용
            if param.video.count > 4 {
                let header = param.video.prefix(4)  // 첫 4바이트 추출
                if header == Data([0x00, 0x00, 0x00, 0x14]) { // MOV 파일 헤더 예시
                    videoMimeType = "video/quicktime"
                } else {
                    videoMimeType = "video/mp4"
                }
            } else {
                videoMimeType = "video/mp4"  // 기본값
            }
            let videoPart = MultipartFormData(
                provider: .data(param.video),
                name: "video",
                fileName: "video.mp4",  // 확장자 맞추기
                mimeType: videoMimeType   // 비디오 MIME 타입 지정
            )
            formData.append(videoPart)

            return .uploadMultipart(formData)
            
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
