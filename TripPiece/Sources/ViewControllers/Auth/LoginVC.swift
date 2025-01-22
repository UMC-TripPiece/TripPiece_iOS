// Copyright © 2024 TripPiece. All rights reserved

import Alamofire
import UIKit
import AuthenticationServices
import KakaoSDKUser
import SnapKit
import Moya
import SwiftyToaster

class LoginVC: UIViewController {
    
    let navigationBarManager = NavigationBarManager()
    
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
    
    // MARK: - Initialization
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Colors.bg4
        
        setupViews()
        setupNavigationBar()
        setupActions()
        setupConstraints()
    }
    
    // MARK: - Setup Methods
    func setupViews() {
        [welcomeLabel, joinLabel, imageView, loginField, loginButton].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupNavigationBar() {
        navigationBarManager.setTitle(to: navigationItem, title: "LOGIN", textColor: Constants.Colors.mainPurple!)
        navigationBarManager.addBackButton(to: navigationItem, target: self, action: #selector(didTapBackButton))
    }
    
    func setupActions() {
        loginField.emailField.addTarget(self, action: #selector(checkFormValidity), for: .editingChanged)
        loginField.passwordField.addTarget(self, action: #selector(checkFormValidity), for: .editingChanged)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            make.leading.equalToSuperview().offset(DynamicPadding.dynamicValue(20.0))
        }
        joinLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.top).offset(50)
            make.leading.equalTo(welcomeLabel)
        }
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalToSuperview().offset(DynamicPadding.dynamicValue(20.0))
            make.height.equalTo(150)
        }
        
        loginField.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(20.0))
            make.height.equalTo(150)
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
        navigationController?.popViewController(animated: true)
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
                callLoginAPI(loginRequest) { isSuccess, statusCode in
                        if isSuccess {
                            print("로그인 성공! 상태 코드: \(statusCode ?? 0)")
                            self.proceedIfSignupSuccessful()
                        } else {
                            if let code = statusCode {
                                print("로그인 실패! 상태 코드: \(code)")
                                self.checkLoginInfo()
                            } else {
                                self.checkLoginInfo()
                                print("로그인 실패! 상태 코드를 확인할 수 없습니다.")
                            }
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
