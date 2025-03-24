// Copyright © 2024 TripPiece. All rights reserved

import Foundation
import UIKit

struct SignUpRequest<T: Codable> {
    let info: T
    let profileImg: UIImage?
}

struct Info : Codable {
    let email : String
    let password : String
    let nickname : String
    let gender : String
    let birth : String
    let country : String
}

struct SocialInfo : Codable {
    let providerId : Int64
    let email : String
    let nickname : String
    let gender : String
    let birth : String
    let country : String
}

struct UpdateInfo : Codable {
    let nickname : String
    let gender : String
    let birth : String
    let country : String
}

class SignUpManager {
    static let shared = SignUpManager()
    
    var email : String = ""
    var password : String = ""
    var nickname : String = ""
    var gender : String = ""
    var birth : String = ""
    var country : String = ""
    var profileImg : UIImage? = nil
    
    private init() {}
    
    func setName(emailString : String, pwString : String) {
        email = emailString
        password = pwString
    }
    
    func setProfile(nicknameString: String, birthString : String, countryString: String) {
        nickname = nicknameString
        birth = birthString
        country = countryString
    }
}

class SocialSignUpManager {
    static let shared = SocialSignUpManager()
    
    var providerId : Int64 = 0
    var email : String = ""
    var nickname : String = ""
    var gender : String = ""
    var birth : String = ""
    var country : String = ""
    var profileImg : UIImage? = nil
    
    private init() {}
    
    func setName(providerIdInt : Int64, emailString : String) {
        providerId = providerIdInt
        email = emailString
    }
    
    func setProfile(nicknameString: String, birthString : String, countryString: String) {
        nickname = nicknameString
        birth = birthString
        country = countryString
    }
}

class ProfileUpdateManager {
    static let shared = ProfileUpdateManager()
    
    var nickname : String = ""
    var gender : String = ""
    var birth : String = ""
    var country : String = ""
    var profileImg : UIImage? = nil
    
    private init() {}
    
    func setProfile(nicknameString: String, birthString : String, countryString: String) {
        nickname = nicknameString
        birth = birthString
        country = countryString
    }
}
