// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import SnapKit
import SDWebImage
import Moya
import SwiftyToaster

class MyPageVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    static var isKakaoLogin : Bool = false
    lazy var kakaoAuthVM: KakaoAuthVM = KakaoAuthVM()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "myPageTop"))
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let myPageLabel: UILabel = {
        let label = UILabel()
        label.text = "My Page"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = Constants.Colors.white
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "My Page"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = Constants.Colors.white
        label.textAlignment = .center
        return label
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "profileExample"))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 70
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let profileEditIconView = IconBadgeView(systemName: "pencil", iconSize: 20, backgroundSize: 40)
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "여행자 님"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let followersLabel: UILabel = {
        let label = UILabel()
        label.text = "0\n팔로워"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let followingLabel: UILabel = {
        let label = UILabel()
        label.text = "0\n팔로잉"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let travelLogsLabel: UILabel = {
        let label = UILabel()
        label.text = "0\n여행기"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let mapPublicLabel: UILabel = {
        let label = UILabel()
        label.text = "내 지도 공개 여부"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let mapPublicSwitch: UISwitch = {
        let mapSwitch = UISwitch()
        mapSwitch.onTintColor = Constants.Colors.mainPurple
        return mapSwitch
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(Constants.Colors.mainPink, for: .normal)
        button.backgroundColor = Constants.Colors.mainPink?.withAlphaComponent(0.1)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let mapStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = Constants.Colors.white
        stackView.axis = .horizontal
        stackView.spacing = 40 // 고정된 spacing 값 설정
        return stackView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserInfoManager.fetchMemberInfo { result in
            switch result {
            case .success(let memberInfo):
                let profileImgURL = URL(string: memberInfo.result.profileImg)
                self.configureSwitch(isEnabled: memberInfo.result.isPublic)
                self.nameLabel.text = "\(memberInfo.result.nickname)님"
                self.travelLogsLabel.text = "\(memberInfo.result.travelNum)\n여행기"
                self.profileImageView.sd_setImage(with: profileImgURL, placeholderImage: UIImage(named: "profileExample"))
            case .failure(let error):
                print("Error occurred: \(error.localizedDescription)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if navigationController == nil {
            let navigationController = UINavigationController(rootViewController: self)
            navigationController.modalPresentationStyle = .fullScreen
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
                keyWindow.rootViewController?.present(navigationController, animated: true)
            }
        }
        
        self.navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        
        configureTapGestureForProfileEditIcon()
    }
    
    func setupViews() {
        [backgroundImageView, myPageLabel, profileImageView, profileEditIconView, nameLabel, stackView, mapStackView, logoutButton].forEach {
            view.addSubview($0)
        }
        [followersLabel, followingLabel, travelLogsLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        [mapPublicLabel, mapPublicSwitch].forEach {
            mapStackView.addArrangedSubview($0)
        }
        
    }
    
    func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(200) // 고정 높이 설정
        }
        myPageLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.centerX.equalToSuperview()
        }
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(backgroundImageView.snp.bottom).offset(-70) // 이미지가 겹쳐 보이도록 설정
            make.width.height.equalTo(140)
        }
        profileEditIconView.snp.makeConstraints { make in
            make.trailing.equalTo(profileImageView.snp.trailing)
            make.top.equalTo(profileImageView.snp.top)
            make.width.height.equalTo(40)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(32)
            make.height.equalTo(50) // 고정 높이 설정
        }
        mapStackView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(32)
            make.height.equalTo(40) // 고정 높이 설정
        }
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(mapStackView.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(44)
        }
    }
    
    func configureTapGestureForProfileEditIcon() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileEdit))
        profileEditIconView.addGestureRecognizer(tapGesture)
    }
    
    func configureSwitch(isEnabled: Bool) {
        mapPublicSwitch.isOn = isEnabled
    }
    
    @objc func profileEdit() {
        self.navigationController?.isNavigationBarHidden = false
        let editVC = ProfileEditVC()
        navigationController?.pushViewController(editVC, animated: false)
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
