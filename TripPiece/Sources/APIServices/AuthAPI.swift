// Copyright © 2024 TripPiece. All rights reserved

import Foundation
import Moya
import UIKit

enum AuthAPI {
    //이메일 인증
    case postEmailVerify(param: EmailVerifyRequest)
    case postEmailSend(email: String)
    
    case postSignUp(param: [MultipartFormData])
    case postLogin(param: LoginRequest)
    case postLogout
    case userDelete //
    
    // SNS 로그인
    case postKakaoSignUp(param: [MultipartFormData])
    case postKakaoLogin(param: KakaoLoginRequest)
    
    // 기타
    case updateProfile(param: [MultipartFormData])
    case getUserProfile
    case postTokenReissue(refreshToken: String)
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.NetworkManager.baseURL) else {
            fatalError("fatal error - invalid url")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .postEmailVerify: return "email/verify"
        case .postEmailSend: return "email/send"
        case .postSignUp: return "user/signup"
        case .postLogin: return "user/login"
        case .postLogout: return "user/logout"
        case .userDelete: return "user/withdrawal"
        case .postKakaoSignUp: return "user/kakao/signup"
        case .postKakaoLogin: return "user/kakao/login"
        case .updateProfile: return "user/update"
        case .getUserProfile: return "user/myprofile"
        case .postTokenReissue: return "user/reissue"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postEmailVerify, .postEmailSend, .postSignUp, .postLogin, .postLogout, .postKakaoLogin, .postKakaoSignUp, .postTokenReissue:
            return .post
        case .getUserProfile:
            return .get
        case .updateProfile:
            return .patch
        case .userDelete:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .postEmailVerify(let param) :
            return .requestJSONEncodable(param)
        case .postEmailSend(let email) :
            return .requestParameters(parameters: ["email": email], encoding: JSONEncoding.default)
        case .postSignUp(let param):
            return .uploadMultipart(param)
        case .postLogin(let param) :
            return .requestJSONEncodable(param)
        case .postLogout :
            return .requestPlain
        case .userDelete :
            return .requestPlain
        case .postKakaoSignUp(let param) :
            return .uploadMultipart(param)
        case .postKakaoLogin(let param) :
            return .requestJSONEncodable(param)
        case .updateProfile(let param) :
            return .uploadMultipart(param)
        case .getUserProfile :
            return .requestPlain
        case .postTokenReissue(let refreshToken) :
            return .requestParameters(parameters: ["refreshToken": refreshToken], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .postSignUp, .postKakaoSignUp, .updateProfile :
            return ["Content-Type": "multipart/form-data"]
        default :
            return ["Content-Type": "application/json"]
        }
    }
}
