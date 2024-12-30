// Copyright © 2024 TripPiece. All rights reserved

import Foundation

class MapManager {
    
    static func getSearchedCities(keyword: String, completion: @escaping (Result<DefaultMultiResponse<SearchedCityResponse>, Error>) -> Void) {
        APIManager.MapProvider.request(.getMapSearch(keyword: keyword)) { result in
            switch result {
            case .success(let response):
                do {
                    let searchResult = try response.map(DefaultMultiResponse<SearchedCityResponse>.self)
                    print("success")
                    completion(.success(searchResult))
                } catch {
                    print("mapping error: \(error.localizedDescription)")
                    completion(.failure(error)) // 디코딩 실패 전달
                }
                
            case .failure(let error):
                print("network error: \(error.localizedDescription)")
                completion(.failure(error)) // 네트워크 실패 전달
            }
        }
    }
    
    
    
    
    
}

