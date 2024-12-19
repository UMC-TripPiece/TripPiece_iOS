// Copyright © 2024 RT4. All rights reserved

import Foundation
import Moya
import SwiftyToaster

final class BearerTokenPlugin: PluginType {
    private var accessToken: String? {
        return SelectLoginTypeVC.keychain.get("serverAccessToken")
    }

    func checkAuthenticationStatus(completion: @escaping (String?) -> Void) {
        guard let accessToken = SelectLoginTypeVC.keychain.get("serverAccessToken"),
              let accessTokenCreatedMillis = SelectLoginTypeVC.keychain.get("accessTokenCreatedAt"),
              let createdMillis = Int64(accessTokenCreatedMillis) else {
            print("AccessToken이 존재하지 않음.")
            refreshAccessToken(completion: completion)
            return
        }
        let expiryMillis = createdMillis + (120 * 60 * 1000) // 30분 = 1,800,000 밀리초
        let expiryDate = Date(milliseconds: expiryMillis)
        if Date() < expiryDate {
            print("AccessToken 유효. 갱신 불필요.")
            completion(accessToken)
        } else {
            print("AccessToken 만료. RefreshToken으로 갱신 시도.")
            refreshAccessToken(completion: completion)
        }
    }
    
    private func refreshAccessToken(completion: @escaping (String?) -> Void) {
        guard let refreshToken = SelectLoginTypeVC.keychain.get("serverRefreshToken") else {
//            print("RefreshToken이 존재하지 않음.")
//            Toaster.shared.makeToast("다시 로그인 해 주세요")
            completion(nil)
            return
        }
        
        APIManager.AuthProvider.request(.postTokenReissue(refreshToken: refreshToken)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.map(RefreshTokenDto.self)
                    SelectLoginTypeVC.keychain.set(data.result.accessToken, forKey: "serverAccessToken")
                    SelectLoginTypeVC.keychain.delete("serverRefreshToken")
//                    print("AccessToken 갱신 성공.")
                    completion(data.result.accessToken)
                } catch {
                    completion(nil)
                }
            case .failure(let error):
                Toaster.shared.makeToast("\(error.localizedDescription)")
                if let response = error.response {
                    print("Response Body: \(String(data: response.data, encoding: .utf8) ?? "")")
                }
                completion(nil)
            }
        }
    }
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        
        let semaphore = DispatchSemaphore(value: 0)
        var tokenToAdd: String?

        checkAuthenticationStatus { token in
            tokenToAdd = token
            semaphore.signal()
        }
        
        semaphore.wait()
        
        if let token = tokenToAdd {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
}
