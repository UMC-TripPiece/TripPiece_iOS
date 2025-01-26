// Copyright © 2024 TripPiece. All rights reserved

import Foundation
import Moya
import SwiftyToaster

class MyLogManager {
    static func fetchTravelsInfo(completion: @escaping (Result<DefaultMultiResponse<TravelsInfo>, Error>) -> Void) {
        APIManager.TravelProvider.request(.getTravels) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONDecoder().decode(DefaultMultiResponse<TravelsInfo>.self, from: response.data)
                    completion(.success(data))
                } catch {
//                    Toaster.shared.makeToast("\(response.statusCode) : 데이터를 불러오는데 실패했습니다.")
                    completion(.failure(error))
                }
            case .failure(let error):
                if let response = error.response {
//                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
                }
                completion(.failure(error))
            }
        }
    }
    
    static func fetchTripPieceInfo(completion: @escaping (Result<DefaultMultiResponse<TripPieceInfo>, Error>) -> Void) {
        APIManager.TripPieceProvider.request(.getAllTripPiece) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONDecoder().decode(DefaultMultiResponse<TripPieceInfo>.self, from: response.data)
                    completion(.success(data))
                } catch {
//                    Toaster.shared.makeToast("\(response.statusCode) : 데이터를 불러오는데 실패했습니다.")
                    completion(.failure(error))
                }
            case .failure(let error):
                if let response = error.response {
//                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
                }
                completion(.failure(error))
            }
        }
    }
    
    static func fetchGeocoding(country: String, city: String, completion: @escaping (Result<GeocodingResponse, Error>) -> Void) {
        APIManager.GeoCodingProvider.request(.getCoordinate(country: country, city: city)) { result in
            switch result {
            case .success(let response):
                if let decodedString = String(data: response.data, encoding: .utf8) {
                    print("Decoded String: \(decodedString)")
                }
                do {
                    let data = try JSONDecoder().decode(GeocodingResponse.self, from: response.data)
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
