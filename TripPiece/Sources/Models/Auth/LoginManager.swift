// Copyright © 2024 TripPiece. All rights reserved

import Foundation
import UIKit
import Moya
import KeychainSwift
import SwiftyToaster

extension ProfileVC {
    ///SignUpRequest를 생성하여 MultipartFormData로 변환
    func createMultipartFormData() -> [MultipartFormData]? {
        var multipartData = [MultipartFormData]()
        let signUpMng = SignUpManager.shared
        let v = SignUpRequest(
            Info: Info(
                name: signUpMng.name,
                email: signUpMng.email,
                password: signUpMng.password,
                nickname: signUpMng.nickname,
                gender: signUpMng.gender,
                birth: signUpMng.birth,
                country: signUpMng.country
            ),
            profileImg: signUpMng.profileImg!
        )
        
        ///Info 정보를 JSON으로 파싱하여 MultipartFormData에 Info 필드로 추가
        do {
                    let jsonEncoder = JSONEncoder()
                    let jsonData = try jsonEncoder.encode(v.Info)
                    if let jsonFieldData = String(data: jsonData, encoding: .utf8)?.data(using: .utf8) {
                        multipartData.append(MultipartFormData(provider: .data(jsonFieldData), name: "info"))
                    }
                } catch {
                    print("⚠️ Failed to encode Info to JSON: \(error)")
                    return nil
                }
        
        
        ///이미지 데이터를 압축하여 MultipartFormData에 profileImg 필드로 추가
        if let imageData = v.profileImg.jpegData(compressionQuality: 0.2) {
            multipartData.append(
                MultipartFormData(
                    provider: .data(imageData),
                    name: "profileImg",
                    fileName: "image.jpg",
                    mimeType: "image/jpeg"
                )
            )
        }
        return multipartData
    }
    
    /// 회원가입 API 호출
    func callSignUpAPI(completion: @escaping (Bool) -> Void) {
        guard let formData = createMultipartFormData() else {
            completion(false)
            return
        }
        
        LoginProvider.request(.postSignUp(param: formData)) { result in
            switch result {
            case .success(let response):
                print(response)
                if response.statusCode == 200 {
//                    Toaster.shared.makeToast("회원가입이 성공적으로 완료되었습니다.")
                    completion(true)
                } else {
//                    Toaster.shared.makeToast("데이터를 불러오는 데 실패했습니다.")
                    completion(false)
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                if let responseData = error.response?.data,
                   let jsonString = String(data: responseData, encoding: .utf8) {
                    print("서버 응답 메시지: \(jsonString)")
                }
                Toaster.shared.makeToast("회원가입 요청 중 오류가 발생했습니다.")
                completion(false)
            }
        }
    }
}

extension LoginVC {
    func setupLoginDTO(_ emailString: String, _ pwString: String) -> LoginRequest? {
        return LoginRequest(email: emailString, password: pwString)
    }
    
    func callLoginAPI(_ userParameter: LoginRequest, completion: @escaping (Bool) -> Void) {
        LoginProvider.request(.postLogin(param: userParameter)) { result in
            switch result {
            case .success(let response):
                do {
                    print(response)
                    let data = try response.map(TokenDto.self)
                    
                    SelectLoginTypeVC.keychain.set(data.result.accessToken, forKey: "serverAccessToken")
                    SelectLoginTypeVC.keychain.set(data.result.refreshToken, forKey: "serverRefreshToken")
                    SelectLoginTypeVC.keychain.set(String(data.result.createdAt), forKey: "accessTokenExpiresIn")
                    completion(true)
                } catch {
                    Toaster.shared.makeToast("\(response.statusCode) : 데이터를 불러오는데 실패했습니다.")
                }
            case .failure(let error) :
                if let response = error.response {
                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
                }
                completion(false)
            }
        }
    }
}
