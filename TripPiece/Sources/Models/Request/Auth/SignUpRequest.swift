// Copyright © 2024 TripPiece. All rights reserved

import Foundation
import UIKit

//SignUpDto
struct SignUpRequest {
    let Info : Info
    let profileImg : UIImage
}

struct Info : Codable {
    let name : String
    let email : String
    let password : String
    let nickname : String
    let gender : String
    let birth : String
    let country : String
}

class SignUpManager {
    static let shared = SignUpManager()
    
    var name : String = ""
    var email : String = ""
    var password : String = ""
    var nickname : String = ""
    var gender : String = ""
    var birth : String = ""
    var country : String = ""
    var profileImg : UIImage? = nil
    
    private init() {}
    
    func setName(username : String, emailString : String, pwString : String) {
        name = username
        email = emailString
        password = pwString
    }
    
    func setProfile(nicknameString: String, birthString : String, countryString: String) {
        nickname = nicknameString
        birth = birthString
        country = countryString
    }
    
}
