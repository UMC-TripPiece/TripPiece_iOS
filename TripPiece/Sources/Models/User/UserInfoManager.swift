// Copyright © 2024 TripPiece. All rights reserved

import Foundation
import Moya
import SwiftyToaster

class UserInfoManager {
    static func fetchMemberInfo(completion: @escaping (Result<DefaultResponse<MemberInfoResult>, Error>) -> Void) {
        APIManager.UserProvider.request(.getUserProfile) { result in
                switch result {
                case .success(let response):
                    do {
                        let data = try JSONDecoder().decode(DefaultResponse<MemberInfoResult>.self, from: response.data)
                        print(data)
                        completion(.success(data))
                    } catch {
                        Toaster.shared.makeToast("\(response.statusCode) : 유저 데이터를 불러오는데 실패했습니다.")
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
