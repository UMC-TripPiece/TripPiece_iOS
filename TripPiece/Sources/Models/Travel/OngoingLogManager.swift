// Copyright © 2024 TripPiece. All rights reserved


import Foundation
import Moya
import SwiftyToaster

class OngoingLogManager {
    
    static func fetchProgressTravelsInfo(completion: @escaping (Result<DefaultResponse<ProgressTravelsInfo>, Error>) -> Void) {
        APIManager.TravelProvider.request(.getProgressTravels) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONDecoder().decode(DefaultResponse<ProgressTravelsInfo>.self, from: response.data)
                    completion(.success(data))
                } catch {
                    Toaster.shared.makeToast("\(response.statusCode) : 데이터를 불러오는데 실패했습니다.")
                    completion(.failure(error))
                }
            case .failure(let error):
                // 네트워크 에러 처리
                if let response = error.response {
                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
                }
                completion(.failure(error))
            }
        }
    }
    
    //로그 버튼 post
    static func postTravelPicture(_ CreatePhotosPieceRequest : CreatePhotosPieceRequest, completion: @escaping (Bool, Response?) -> Void) {
        APIManager.TravelProvider.request(.postPicturePiece(param: CreatePhotosPieceRequest)) { result in
            switch result {
            case .success(let response):
                print(response)
                if response.statusCode == 200 {
                    completion(true, response)
                } else {
                    completion(false, response)
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                if let responseData = error.response?.data,
                   let jsonString = String(data: responseData, encoding: .utf8) {
                    print("사진 기록/서버 응답 메시지: \(jsonString)")
                }
                Toaster.shared.makeToast("사진 기록 추가 중 오류가 발생했습니다.")
                completion(false, error.response)
            }
        }
    }
    static func postTravelVideo(_ CreateVideoPieceRequest : CreateVideoPieceRequest, completion: @escaping (Bool, Response?) -> Void) {
        APIManager.TravelProvider.request(.postVideoPiece(param: CreateVideoPieceRequest)) { result in
            switch result {
            case .success(let response):
                print(response)
                if response.statusCode == 200 {
                    completion(true, response)
                } else {
                    completion(false, response)
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                if let responseData = error.response?.data,
                   let jsonString = String(data: responseData, encoding: .utf8) {
                    print("동영상 기록/서버 응답 메시지: \(jsonString)")
                }
                Toaster.shared.makeToast("동영상 기록 추가 중 오류가 발생했습니다.")
                completion(false, error.response)
            }
        }
    }
    static func postTravelMemo(_ CreateMemoPieceRequest : CreateMemoPieceRequest, completion: @escaping (Bool, Response?) -> Void) {
        APIManager.TravelProvider.request(.postMemoPiece(param: CreateMemoPieceRequest)) { result in
            switch result {
            case .success(let response):
                print(response)
                if response.statusCode == 200 {
                    completion(true, response)
                } else {
                    completion(false, response)
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                if let responseData = error.response?.data,
                   let jsonString = String(data: responseData, encoding: .utf8) {
                    print("사진 기록/서버 응답 메시지: \(jsonString)")
                }
                Toaster.shared.makeToast("사진 기록 추가 중 오류가 발생했습니다.")
                completion(false, error.response)
            }
        }
    }
}
