// Copyright © 2024 TripPiece. All rights reserved

import Foundation
import Moya
import SwiftyToaster

class MissionLogManager {
    
    static func postSelfiePiece(createPhotoPieceRequest: CreatePhotoPieceRequest, completion: @escaping (Result<DefaultResponse<PieceInfo>, Error>) -> Void) {
        APIManager.TravelProvider.request(.postSelfiePiece(param: createPhotoPieceRequest)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONDecoder().decode(DefaultResponse<PieceInfo>.self, from: response.data)
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
    
    static func postLiveVideoPiece(createVideoPieceRequest: CreateVideoPieceRequest, completion: @escaping (Result<DefaultResponse<PieceInfo>, Error>) -> Void) {
        APIManager.TravelProvider.request(.postWherePiece(param: createVideoPieceRequest)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONDecoder().decode(DefaultResponse<PieceInfo>.self, from: response.data)
                    completion(.success(data))
                } catch {
                    Toaster.shared.makeToast("\(response.statusCode) : 데이터를 불러오는데 실패했습니다.")
                    completion(.failure(error))
                }
            case .failure(let error):
                print(error)
                // 네트워크 에러 처리
                if let response = error.response {
                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
                }
                completion(.failure(error))
            }
        }
    }
    
    static func postEmojiPiece(createEmojiPieceRequest: CreateEmojiPieceRequest, completion: @escaping (Result<DefaultResponse<PieceInfo>, Error>) -> Void) {
        APIManager.TravelProvider.request(.postEmojiPiece(param: createEmojiPieceRequest)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONDecoder().decode(DefaultResponse<PieceInfo>.self, from: response.data)
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
}
