// Copyright © 2024 TripPiece. All rights reserved

import Alamofire
import UIKit
import AuthenticationServices
import KakaoSDKUser
import SnapKit
import Moya

class LoginVC: UIViewController {

    private lazy var backButton: CustomBackButton = {
        let button = CustomBackButton(title: "")
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Log In"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = Constants.Colors.mainPurple
        label.textAlignment = .center
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "LoginPuzzle")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요 :)"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = Constants.Colors.black1
        label.textAlignment = .left
        return label
    }()
    
    let joinLabel: UILabel = {
        let label = UILabel()
        label.text = "여행조각에 오신 것을 환영합니다!"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = Constants.Colors.black2
        label.textAlignment = .left
        return label
    }()
    
    let loginField = CustomLabelTextFieldView(labelText: "로그인", emailPlaceholder: "| 이메일을 입력해 주세요", passwordPlaceholder: "| 비밀번호를 입력해 주세요", validationText: "아이디 혹은 비밀번호를 확인해 주세요")
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그인", for: .normal)
        button.backgroundColor = Constants.Colors.bgGray
        button.layer.cornerRadius = 5
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    func setupViews() {
        [backButton, titleLabel, welcomeLabel, joinLabel, imageView, loginField, loginButton].forEach {
            view.addSubview($0)
        }
    }
    
    func setupActions() {
        loginField.emailField.addTarget(self, action: #selector(checkFormValidity), for: .editingChanged)
        loginField.passwordField.addTarget(self, action: #selector(checkFormValidity), for: .editingChanged)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Colors.bg4
        
        setupViews()
        setupActions()
        setupConstraints()
    }
    
    private func setupConstraints() {
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalToSuperview().offset(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.centerX.equalToSuperview()
        }
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(80)
            make.leading.equalToSuperview().offset(20)
        }
        joinLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.top).offset(50)
            make.leading.equalToSuperview().offset(20)
        }
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
            make.trailing.equalToSuperview().offset(20)
            make.height.equalTo(150)
        }
        
        loginField.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(140)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(loginField.snp.bottom).offset(30)
            make.leading.trailing.equalTo(loginField)
            make.height.equalTo(50)
        }
    }
    
    //MARK: Setup Actions
    lazy var isValid = false
    
    @objc func didTapBackButton() {
        var currentVC: UIViewController? = self
            while let presentingVC = currentVC?.presentingViewController {
                if presentingVC is SelectLoginTypeVC {
                    presentingVC.dismiss(animated: true, completion: nil)
                    return
                }
                currentVC = presentingVC
            }
        print("SelectLoginTypeVC를 찾을 수 없습니다.")
    }
    
    @objc func loginButtonTapped() {
        print("로그인 버튼 클릭")
        sendLoginRequest()
    }
    
    @objc func checkFormValidity() {
        let email = loginField.text1 ?? ""
        let password = loginField.text2 ?? ""
        let isFormValid = (ValidationUtility.isValidEmail(email)) && (ValidationUtility.isValidPassword(password))
        
        isValid = isFormValid
        loginButton.isEnabled = isFormValid
        loginButton.backgroundColor = isFormValid ? Constants.Colors.mainPurple : Constants.Colors.bgGray
    }
    
    func checkLoginInfo() {
        loginField.emailField.layer.borderColor = Constants.Colors.mainPink?.cgColor
        loginField.passwordField.layer.borderColor = Constants.Colors.mainPink?.cgColor
        loginField.validationLabel.isHidden = false
    }
    
    func sendLoginRequest() {
        if isValid {
            if let loginRequest = setupLoginDTO(loginField.emailField.text!, loginField.passwordField.text!) {
                callLoginAPI(loginRequest) { isSuccess in
                    if isSuccess {
                        self.proceedIfSignupSuccessful()
                    } else {
                        self.checkLoginInfo()
                        print("로그인 실패")
                    }
                }
            }
        }
    }
    
    func proceedIfSignupSuccessful() {
        let tabBarController = TabBar()
        tabBarController.modalPresentationStyle = .fullScreen
        present(tabBarController, animated: true, completion: nil)
    }
}
