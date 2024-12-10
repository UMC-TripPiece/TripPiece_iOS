// Copyright © 2024 TripPiece. All rights reserved

import Alamofire
import SwiftyJSON
import UIKit
import AuthenticationServices
import KakaoSDKUser
import SnapKit
import KeychainSwift

let superViewHeight = UIScreen.main.bounds.height
let superViewWidth = UIScreen.main.bounds.width

class SelectLoginTypeVC : UIViewController {
    
    var userInfo: [String: Any] = [:]
    
    static let keychain = KeychainSwift() // For storing tokens like GoogleAccessToken, GoogleRefreshToken, FCMToken, serverAccessToken, serverRefreshToken, accessTokenExpiresIn
    
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
        Task {
            if await kakaoAuthVM.KakaoLogin() {
                DispatchQueue.main.async {
                    UserApi.shared.me() { [weak self] (user, error) in
                        guard let self = self else { return }
                        if let error = error {
                            print(error)
                            return
                        }
                        
                        let userID = user?.id ?? nil
                        let userEmail = user?.kakaoAccount?.email ?? ""

                        userInfo["providerId"] = userID
                        userInfo["email"] = userEmail
                        print(userInfo)

                        sendLoginRequest()
                    }
                }
            } else {
                print("Login failed.")
            }
        }
    }
    
    func sendLoginRequest() {
        guard let url = URL(string: "http://3.34.111.233:8080/user/kakao/login") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("*/*", forHTTPHeaderField: "accept")

        print(userInfo)
        // JSON 데이터를 문자열로 변환
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: userInfo, options: [])
                request.httpBody = jsonData
            } catch {
                print("Failed to serialize JSON: \(error)")
                return
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error making POST request: \(error)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Unexpected response: \(String(describing: response))")
                    return
                }
                
                if !(200...299).contains(httpResponse.statusCode) {
                    print("Unexpected response: \(String(describing: response))")
                    if let data = data, let errorMessage = String(data: data, encoding: .utf8) {
                        print("Error message: \(errorMessage)")
                        DispatchQueue.main.async {
                            let profileVC = KakaoProfileVC()
                            profileVC.userInfo = self.userInfo
                            profileVC.loginPath = "/kakao"

                            // Present ProfileViewController modally
                            profileVC.modalPresentationStyle = .fullScreen
                            self.present(profileVC, animated: true, completion: nil)
                                        }
                    }
                    return
                }
                
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("Response data: \(responseString)")
                    DispatchQueue.main.async {
                            // JSON 파싱을 통해 refreshToken을 추출
                            if let jsonData = responseString.data(using: .utf8) {
                                do {
                                    if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                                       let result = json["result"] as? [String: Any],
                                       let refreshToken = result["refreshToken"] as? String {
                                        
                                        UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
                                        
                                        self.proceedIfLoginSuccessful()
                                    }
                                } catch {
                                    print("JSON 파싱 에러: \(error.localizedDescription)")
                                }
                            }
                        }
                }
            }
            task.resume()
    }
    
    func proceedIfLoginSuccessful() {
            let tabBarController = TabBar()
            tabBarController.modalPresentationStyle = .fullScreen
            present(tabBarController, animated: true, completion: nil)
    }
}
