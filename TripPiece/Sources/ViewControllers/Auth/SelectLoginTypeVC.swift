// Copyright © 2024 TripPiece. All rights reserved

import Alamofire
import SwiftyJSON
import UIKit
import AuthenticationServices
import KakaoSDKUser
import SnapKit
import KeychainSwift
import SwiftyToaster

let superViewHeight = UIScreen.main.bounds.height
let superViewWidth = UIScreen.main.bounds.width

class SelectLoginTypeVC : UIViewController {
    
    static let keychain = KeychainSwift() // For storing tokens like GoogleAccessToken, GoogleRefreshToken, FCMToken, serverAccessToken, serverRefreshToken, accessTokenCreatedAt
    
    lazy var backgroundImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "backgroundImage")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    let emailLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("E-mail로 시작하기", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(emailLoginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let kakaoLoginButton: UIButton = {
        let button = UIButton()
        if let image = UIImage(named: "btn_login_kakao")?.withRenderingMode(.alwaysOriginal) {
            button.setImage(image, for: .normal)
        } else {
            print("Image btn_login_kakao not found!")
        }
        button.addTarget(self, action: #selector(kakaoButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("이미 계정이 있으신가요?", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var kakaoAuthVM: KakaoAuthVM = KakaoAuthVM()
    
    //MARK: - Define Method
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setConstraints()
    }
    
    // 뷰 관련 세팅
    func setView() {
        [backgroundImage, emailLoginButton, kakaoLoginButton, loginButton].forEach {
            view.addSubview($0)
        }
        navigationController?.navigationBar.isHidden = true
    }
    
    func setConstraints() {
        let leading: CGFloat = 30
        
        backgroundImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-UIScreen.main.bounds.height * 0.1)
            make.bottom.equalToSuperview().offset(UIScreen.main.bounds.height * 0.1)
            make.leading.equalToSuperview().offset(-UIScreen.main.bounds.width * 0.1)
            make.trailing.equalToSuperview().offset(UIScreen.main.bounds.width * 0.1)
        }
        
        emailLoginButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(superViewHeight * 0.795)
            make.leading.equalToSuperview().offset(leading)
            make.trailing.equalToSuperview().offset(-leading)
            make.height.equalTo(emailLoginButton.snp.width).multipliedBy(0.15)
        }
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(superViewHeight * 0.87)
            make.leading.equalToSuperview().offset(leading)
            make.trailing.equalToSuperview().offset(-leading)
            make.height.equalTo(kakaoLoginButton.snp.width).multipliedBy(0.15)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(superViewHeight * 0.94)
            make.leading.equalToSuperview().offset(leading)
            make.trailing.equalToSuperview().offset(-leading)
        }
    }
    
    @objc func emailLoginButtonTapped(_ sender: UIButton) {
        let SignUpVC = SignUpVC()
        SignUpVC.modalPresentationStyle = .fullScreen
        present(SignUpVC, animated: true, completion: nil)
    }
    
    @objc func loginButtonTapped(_ sender: UIButton) {
        let loginVC = LoginVC()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)
    }
    
    @objc func kakaoButtonTapped(_ sender: UIButton) {
        self.kakaoAuthVM.KakaoLogin { success in
            if success {
                UserApi.shared.me { (user, error) in
                    if let error = error {
                        print("에러 발생: \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            Toaster.shared.makeToast("사용자 정보 가져오기 실패")
                        }
                        return
                    }
                    
                    let userID = user?.id ?? 0
                    let userEmail = user?.kakaoAccount?.email ?? ""
                    
                    if let _ = SelectLoginTypeVC.keychain.get("KakaoToken") {
                        if let loginRequest = self.setupKakaoLoginDTO(userEmail, userID) {
                            self.callKakaoLoginAPI(loginRequest) { isSuccess in
                                if isSuccess {
                                    self.proceedIfLoginSuccessful()
                                } else {
                                    print("로그인 실패")
                                }
                            }
                        }
                    } else {
                        SocialSignUpManager.shared.setName(providerIdInt: userID, emailString: userEmail)
                        self.proceedIfSocialNameSetSuccessful()
                    }
                }
            } else {
                print("카카오 회원가입 실패")
            }
        }
    }
    
    func proceedIfSocialNameSetSuccessful() {
        let profileVC = ProfileVC()
        profileVC.isEmailLogin = true
        profileVC.modalPresentationStyle = .fullScreen
        present(profileVC, animated: true, completion: nil)
    }
    
    func proceedIfLoginSuccessful() {
        let tabBarController = TabBar()
        tabBarController.modalPresentationStyle = .fullScreen
        present(tabBarController, animated: true, completion: nil)
    }
}
