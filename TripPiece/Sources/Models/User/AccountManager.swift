// Copyright © 2024 TripPiece. All rights reserved

import Foundation
import Moya
import SwiftyToaster

extension ProfileEditVC {
    func postProfileUpdateAPI(completion: @escaping (Bool) -> Void) {
        var multipartData = [MultipartFormData]()
        let updateMng = ProfileUpdateManager.shared
        let profileUpdate = SignUpRequest(
            info: UpdateInfo(
                nickname: updateMng.nickname,
                gender: updateMng.gender,
                birth: updateMng.birth,
                country: updateMng.country
            ),
            profileImg: updateMng.profileImg
        )
        if let infoData = MultipartForm.createJSONMultipartData(data: profileUpdate.info, fieldName: "info") {
            multipartData.append(infoData)
        }
        if let profileImage = profileUpdate.profileImg,
           let imageData = MultipartForm.createImageMultipartData(image: profileImage, fieldName: "profileImg") {
            multipartData.append(imageData)
        }
        
        APIManager.UserProvider.request(.updateProfile(param: multipartData)) { result in
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
