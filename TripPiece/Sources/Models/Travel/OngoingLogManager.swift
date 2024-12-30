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
}
