// Copyright © 2024 TripPiece. All rights reserved

import Foundation
import Moya
import SwiftyToaster

class PuzzleLogManager {
    static func endTravel(travelId: Int, completion: @escaping (Result<DefaultResponse<EndTravelInfo>, Error>) -> Void) {
        APIManager.TravelProvider.request(.postTravelEnd(travelId: travelId)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONDecoder().decode(DefaultResponse<EndTravelInfo>.self, from: response.data)
                    completion(.success(data))
                } catch {
                    Toaster.shared.makeToast("\(response.statusCode) : 데이터를 불러오는데 실패했습니다.")
                    completion(.failure(error))
                }
            case .failure(let error):
                if let response = error.response {
                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
                }
                completion(.failure(error))
            }
        }
    }
    
    static func fetchTravelsInfo(travelId: Int, completion: @escaping (Result<DefaultResponse<EndTravelInfo>, Error>) -> Void) {
        APIManager.TravelProvider.request(.getTravelsInfo(travelId: travelId)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONDecoder().decode(DefaultResponse<EndTravelInfo>.self, from: response.data)
                    completion(.success(data))
                } catch {
                    Toaster.shared.makeToast("\(response.statusCode) : 데이터를 불러오는데 실패했습니다.")
                    completion(.failure(error))
                }
            case .failure(let error):
                if let response = error.response {
                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
                }
                completion(.failure(error))
            }
        }
    }
    
    static func fetchThumbnail(travelId: Int, completion: @escaping (Result<DefaultResponse<[ThumbnailInfo]>, Error>) -> Void) {
        APIManager.TravelProvider.request(.getThumbnail(travelId: travelId)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONDecoder().decode(DefaultResponse<[ThumbnailInfo]>.self, from: response.data)
                    completion(.success(data))
                } catch {
                    Toaster.shared.makeToast("\(response.statusCode) : 데이터를 불러오는데 실패했습니다.")
                    completion(.failure(error))
                }
            case .failure(let error):
                if let response = error.response {
                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
                }
                completion(.failure(error))
            }
        }
    }
    static func fetchTravelsInfoDetails(travelId: Int, completion: @escaping (Result<DefaultResponse<[TravelsDetailInfo]>, Error>) -> Void) {
        APIManager.TravelProvider.request(.getTravelsInfoDetails(travelId: travelId)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONDecoder().decode(DefaultResponse<[TravelsDetailInfo]>.self, from: response.data)
                    completion(.success(data))
                } catch {
                    Toaster.shared.makeToast("\(response.statusCode) : 데이터를 불러오는데 실패했습니다.")
                    completion(.failure(error))
                }
            case .failure(let error):
                if let response = error.response {
                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
                }
                completion(.failure(error))
            }
        }
    }
    static func fetchAllPictures(travelId: Int, completion: @escaping (Result<DefaultResponse<[ThumbnailInfo]>, Error>) -> Void) {
        APIManager.TravelProvider.request(.getAllPictures(travelId: travelId)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONDecoder().decode(DefaultResponse<[ThumbnailInfo]>.self, from: response.data)
                    completion(.success(data))
                } catch {
                    Toaster.shared.makeToast("\(response.statusCode) : 데이터를 불러오는데 실패했습니다.")
                    completion(.failure(error))
                }
            case .failure(let error):
                if let response = error.response {
                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
                }
                completion(.failure(error))
            }
        }
    }
    
    static func updateThumbnail(param: UpdateThumbnailRequest, completion: @escaping (Result<DefaultResponse<[ThumbnailInfo]>, Error>) -> Void) {
        APIManager.TravelProvider.request(.postUpdateThumbnail(param: param)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONDecoder().decode(DefaultResponse<[ThumbnailInfo]>.self, from: response.data)
                    completion(.success(data))
                } catch {
                    Toaster.shared.makeToast("\(response.statusCode) : 데이터를 불러오는데 실패했습니다.")
                    completion(.failure(error))
                }
            case .failure(let error):
                if let response = error.response {
                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
                }
                completion(.failure(error))
            }
        }
    }
}
