// Copyright © 2024 TripPiece. All rights reserved

import Foundation
import UIKit
import Moya
import KeychainSwift
import SwiftyToaster

extension ProfileVC {
    ///자체 회원가입 API 호출
    func callSignUpAPI(completion: @escaping (Bool) -> Void) {
        var multipartData = [MultipartFormData]()
        let signUpMng = SignUpManager.shared
        let emailSignUp = SignUpRequest(
            info: Info(
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
        if let infoData = MultipartForm.createJSONMultipartData(data: emailSignUp.info, fieldName: "info") {
            multipartData.append(infoData)
        }
        if let imageData = MultipartForm.createImageMultipartData(image: emailSignUp.profileImg!, fieldName: "profileImg") {
            multipartData.append(imageData)
        }
        
        APIManager.AuthProvider.request(.postSignUp(param: multipartData)) { result in
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
    
    ///카카오 회원가입 API 호출
    func callKakaoSignUpAPI(completion: @escaping (Bool) -> Void) {
        var multipartData = [MultipartFormData]()
        let signUpMng = SocialSignUpManager.shared
        let emailSignUp = SignUpRequest(
            info: SocialInfo(
                providerId: signUpMng.providerId,
                email: signUpMng.email,
                nickname: signUpMng.nickname,
                gender: signUpMng.gender,
                birth: signUpMng.birth,
                country: signUpMng.country
            ),
            profileImg: signUpMng.profileImg!
        )
        if let infoData = MultipartForm.createJSONMultipartData(data: emailSignUp.info, fieldName: "info") {
            multipartData.append(infoData)
        }
        if let imageData = MultipartForm.createImageMultipartData(image: emailSignUp.profileImg!, fieldName: "profileImg") {
            multipartData.append(imageData)
        }
        
        APIManager.AuthProvider.request(.postKakaoSignUp(param: multipartData)) { result in
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
        APIManager.AuthProvider.request(.postLogin(param: userParameter)) { result in
            switch result {
            case .success(let response):
                do {
                    print(response)
                    let data = try response.map(TokenDto.self)
                    let currentTimeInMilliseconds = Date().millisecondsSince1970
                    SelectLoginTypeVC.keychain.set(data.result.accessToken, forKey: "serverAccessToken")
                    SelectLoginTypeVC.keychain.set(data.result.refreshToken, forKey: "serverRefreshToken")
                    SelectLoginTypeVC.keychain.set(String(currentTimeInMilliseconds), forKey: "accessTokenCreatedAt")
                    print(data)
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

extension SelectLoginTypeVC {
    func setupKakaoLoginDTO(_ emailString: String, _ providerIdInt: Int64) -> KakaoLoginRequest? {
        return KakaoLoginRequest(email: emailString, providerId: providerIdInt)
    }
    
    func callKakaoLoginAPI(_ userParameter: KakaoLoginRequest, completion: @escaping (Bool) -> Void) {
        APIManager.AuthProvider.request(.postKakaoLogin(param: userParameter)) { result in
            switch result {
            case .success(let response):
                do {
                    print(response)
                    let data = try response.map(TokenDto.self)
                    let currentTimeInMilliseconds = Date().millisecondsSince1970
                    SelectLoginTypeVC.keychain.set(data.result.accessToken, forKey: "serverAccessToken")
                    SelectLoginTypeVC.keychain.set(data.result.refreshToken, forKey: "serverRefreshToken")
                    SelectLoginTypeVC.keychain.set(String(currentTimeInMilliseconds), forKey: "accessTokenCreatedAt")
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
