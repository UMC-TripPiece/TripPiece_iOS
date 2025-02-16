// Copyright © 2024 TripPiece. All rights reserved

import Foundation
import Moya
import SwiftyToaster

class ExploreManager {
    static func fetchTrendingInfo(completion: @escaping (Result<DefaultMultiResponse<TrendingResponse>, Error>) -> Void) {
        APIManager.ExploreProvider.request(.getPopularResult) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONDecoder().decode(DefaultMultiResponse<TrendingResponse>.self, from: response.data)
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
    
    static func fetchSearchInfo(query: String, completion: @escaping (Result<DefaultMultiResponse<SearchResponse>, Error>) -> Void) {
        APIManager.ExploreProvider.request(.getSearchResult(query: query)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONDecoder().decode(DefaultMultiResponse<SearchResponse>.self, from: response.data)
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
}
