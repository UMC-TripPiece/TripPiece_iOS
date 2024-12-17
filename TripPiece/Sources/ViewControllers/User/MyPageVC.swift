// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import SnapKit
import SDWebImage
import Moya
import SwiftyToaster

class MyPageVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    static var isKakaoLogin : Bool = false
    lazy var kakaoAuthVM: KakaoAuthVM = KakaoAuthVM()
    
    var backgroundImageView: UIImageView!
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "My Page"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = Constants.Colors.white
        label.textAlignment = .center
        return label
    }()

    let profileImageView = UIImageView()
    
    let profileEditIconView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "profileImageEdit"))
        imageView.isUserInteractionEnabled = true // Enable user interaction
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "여행자 님"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    
    let followersLabel: UILabel = {
        let label = UILabel()
        label.text = "0\n팔로워"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        label.text = "0\n팔로잉"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    let travelLogsLabel: UILabel = {
        let label = UILabel()
        label.text = "0\n여행기"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    let mapPublicSwitch: UISwitch = {
        let mapSwitch = UISwitch()
        return mapSwitch
    }()
    
    let mapPublicLabel: UILabel = {
        let label = UILabel()
        label.text = "내 지도 공개 여부"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(Constants.Colors.mainPink, for: .normal)
        button.backgroundColor = Constants.Colors.mainPink?.withAlphaComponent(0.1)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserInfoManager.fetchMemberInfo { result in
            switch result {
                case .success(let memberInfo):
                print("Nickname: \(memberInfo.result.nickname)")
                case .failure(let error):
                    print("Error occurred: \(error.localizedDescription)")
                }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        
        configureTapGestureForProfileEditIcon()
    }
    
    func setupViews() {
        backgroundImageView = UIImageView(image: UIImage(named: "myPageTop"))
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(view.frame.height * 0.3) // You can adjust this height as needed
        }
        backgroundImageView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
        }
        profileImageView.image = UIImage(named: "profileExample")
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 70
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImageView)
        
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(backgroundImageView.snp.bottom).offset(-95)
            make.width.height.equalTo(140)
        }
        
        view.addSubview(profileEditIconView)

        profileEditIconView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.centerX.equalTo(profileImageView.snp.trailing).inset(17)
            make.centerY.equalTo(profileImageView.snp.top).inset(17)
        }
        // Name label
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        // Followers, following, and travel logs labels
        let stackView = UIStackView(arrangedSubviews: [followersLabel, followingLabel, travelLogsLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
        }
        let superViewWidth = view.frame.width

        let mapStackView = UIStackView(arrangedSubviews: [mapPublicLabel, mapPublicSwitch])
        mapStackView.axis = .horizontal
        mapStackView.spacing = superViewWidth * 0.40
        view.addSubview(mapStackView)
        
        mapStackView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(30)
        }
        
        // Logout button
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(mapStackView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(50)
        }
    }
    
    func configureTapGestureForProfileEditIcon() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileEdit))
        profileEditIconView.addGestureRecognizer(tapGesture)
    }
    
    @objc func profileEdit() {
        let editVC = TestVC()
        editVC.modalPresentationStyle = .fullScreen
        present(editVC, animated: true, completion: nil)
    }
    
    @objc func logoutTapped() {
        APIManager.UserProvider.request(.postLogout) { result in
            switch result {
            case .success(let response):
                
                if MyPageVC.isKakaoLogin {
                    self.kakaoAuthVM.kakaoLogout()
                    ["serverAccessToken", "accessTokenExpiresIn", "serverRefreshToken"].forEach { keyName in
                        SelectLoginTypeVC.keychain.delete(keyName)
                    }
                    Toaster.shared.makeToast("로그아웃")
                    self.showSplashScreen()
                } else {
                    ["serverAccessToken", "accessTokenExpiresIn", "serverRefreshToken"].forEach { keyName in
                        SelectLoginTypeVC.keychain.delete(keyName)
                    }
                    Toaster.shared.makeToast("로그아웃")
                    self.showSplashScreen()
                }
                
            case .failure(let error):
                if let response = error.response {
                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
                }
            }
        }
    }
    
    func showSplashScreen() {
        let splashViewController = SplashVC()

        // 현재 윈도우 가져오기
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .first else {
            print("윈도우를 가져올 수 없습니다.")
            return
        }

        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
            window.rootViewController = splashViewController
        }, completion: nil)
    }
}
