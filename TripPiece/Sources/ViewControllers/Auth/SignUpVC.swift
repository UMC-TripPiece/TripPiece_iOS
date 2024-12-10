// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import SnapKit
//import FirebaseAuth
import FirebaseCore
import Moya

class SignUpVC: UIViewController {
    
    let LoginProvider = MoyaProvider<AuthAPI>(plugins: [ NetworkLoggerPlugin() ])
    
    private lazy var usernameField = CustomLabelTextFieldView2(labelText: "이름", textFieldPlaceholder: "| 이름을 입력해 주세요", validationText: "이름을 입력해주세요")
    private lazy var emailField = CustomLabelTextFieldView2(labelText: "이메일", textFieldPlaceholder: "| 사용할 이메일 주소를 입력해 주세요", validationText: "사용할 수 없는 이메일입니다")
    private lazy var passwordField: CustomLabelTextFieldView2 = {
        let field = CustomLabelTextFieldView2(labelText: "비밀번호", textFieldPlaceholder: "| 8~20자 이내 영문자, 숫자, 특수문자의 조합", validationText: "올바르지 않은 형식입니다")
        field.textField.isSecureTextEntry = true
        return field
    }()
    private lazy var confirmPasswordField: CustomLabelTextFieldView2 = {
        let field = CustomLabelTextFieldView2(labelText: "비밀번호 확인", textFieldPlaceholder: "| 비밀번호를 다시 입력해 주세요", validationText: "비밀번호를 다시 한 번 확인해 주세요")
        field.textField.isSecureTextEntry = true
        return field
    }()
    
    // MARK: - UI Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "SIGN UP"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = Constants.Colors.mainPurple
        label.textAlignment = .center
        return label
    }()
    
    private lazy var termsCheckBox: CheckBoxButton = {
        return CheckBoxButton(title: " 이용약관 (필수)")
    }()
    
    private lazy var privacyCheckBox: CheckBoxButton = {
        return CheckBoxButton(title: " 개인정보 수집 및 이용 (필수)")
    }()
    
    private lazy var allAgreeCheckBox: CheckBoxButton = {
        return CheckBoxButton(title: " 전체동의")
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("가입하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = Constants.Colors.bgGray
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var termsValidationLabel: UILabel = {
        let label = UILabel()
        label.text = "이용 약관 및 개인정보 수집에 동의해주세요"
        label.textColor = Constants.Colors.mainPink
        label.font = UIFont.systemFont(ofSize: 12)
        label.isHidden = true
        return label
    }()
    
    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupActions()
        validateInputs()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        [titleLabel, usernameField, emailField, passwordField, confirmPasswordField, termsCheckBox, privacyCheckBox, allAgreeCheckBox, termsValidationLabel, signUpButton].forEach {
            view.addSubview($0)
        }
        
        self.view.backgroundColor = Constants.Colors.bg4
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }
        
        usernameField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-40)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        emailField.snp.makeConstraints { make in
            make.top.equalTo(usernameField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        confirmPasswordField.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        termsValidationLabel.snp.makeConstraints { make in
            make.bottom.equalTo(confirmPasswordField.snp.bottom).offset(40)
            make.leading.equalToSuperview().inset(20)
        }
        termsCheckBox.snp.makeConstraints { make in
            make.top.equalTo(termsValidationLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        
        privacyCheckBox.snp.makeConstraints { make in
            make.top.equalTo(termsCheckBox.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        
        allAgreeCheckBox.snp.makeConstraints { make in
            make.top.equalTo(privacyCheckBox.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        
    }
    
    private func setupActions() {
        usernameField.textField.addTarget(self, action: #selector(usernameValidate), for: .editingChanged)
        emailField.textField.addTarget(self, action: #selector(emailValidate), for: .editingChanged)
        passwordField.textField.addTarget(self, action: #selector(passwordValidate), for: .editingChanged)
        confirmPasswordField.textField.addTarget(self, action: #selector(confirmPasswordValidate), for: .editingChanged)
        
        allAgreeCheckBox.addTarget(self, action: #selector(allAgreeTapped), for: .touchUpInside)
        termsCheckBox.addTarget(self, action: #selector(termsTapped), for: .touchUpInside)
        privacyCheckBox.addTarget(self, action: #selector(privacyTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Actions
    @objc func signUpButtonTapped() {
        if isValid {
            print("회원가입 버튼 클릭")
            self.navigateToProfileVC()
        } else {
            print("조건값 확인 필요")
        }
    }
    
    func navigateToProfileVC() {
        let profileVC = ProfileVC()
        //userInfoManager에 입력된 기본 개인정보 저장
        SignUpManager.shared.setName(username: usernameField.text!, emailString: emailField.text!, pwString: passwordField.text!)
        profileVC.modalPresentationStyle = .fullScreen
        present(profileVC, animated: true, completion: nil)
        }
    
    @objc func allAgreeTapped() {
        let isSelected = !allAgreeCheckBox.isSelected
        print("전체 동의 함수 실행")
        allAgreeCheckBox.isSelected = isSelected
        termsCheckBox.isSelected = isSelected
        privacyCheckBox.isSelected = isSelected
        if allAgreeCheckBox.isSelected {
            termsValidationLabel.isHidden = true
        } else {
            termsValidationLabel.isHidden = false
        }
        termsAgreeValidate()
    }
    
    @objc func termsTapped() {
        termsCheckBox.isSelected.toggle()
        updateAllAgreeState()
        if allAgreeCheckBox.isSelected {
            termsValidationLabel.isHidden = true
        } else {
            termsValidationLabel.isHidden = false
        }
        termsAgreeValidate()
    }
    
    @objc func privacyTapped() {
        privacyCheckBox.isSelected.toggle()
        updateAllAgreeState()
        if allAgreeCheckBox.isSelected {
            termsValidationLabel.isHidden = true
        } else {
            termsValidationLabel.isHidden = false
        }
        termsAgreeValidate()
    }
    
    func updateAllAgreeState() {
        allAgreeCheckBox.isSelected = termsCheckBox.isSelected && privacyCheckBox.isSelected
    }
    
    //TODO: 유효성 체크 함수 간단화 필요
    lazy var isUsernameValid = false
    lazy var isEmailValid = false
    lazy var isPasswordValid = false
    lazy var isConfirmPasswordValid = false
    lazy var isTermsAgreeValid = false
    
    @objc func usernameValidate(){
        if let username = usernameField.text, !username.isEmpty {
            usernameField.validationLabel.isHidden = true
            usernameField.textField.layer.borderColor = Constants.Colors.mainPurple?.cgColor
            isUsernameValid = true
        } else {
            usernameField.validationLabel.isHidden = false
            usernameField.textField.layer.borderColor = Constants.Colors.mainPink?.cgColor
        }
        validateInputs()
    }
    
    @objc func emailValidate(){
        if let email = emailField.text, ValidationUtility.isValidEmail(email) {
            emailField.validationLabel.isHidden = true
            emailField.textField.layer.borderColor = Constants.Colors.mainPurple?.cgColor
            isEmailValid = true
        } else {
            emailField.validationLabel.isHidden = false
            emailField.textField.layer.borderColor = Constants.Colors.mainPink?.cgColor
        }
    }
    
    @objc func passwordValidate(){
        if let password = passwordField.text, ValidationUtility.isValidPassword(password) {
            passwordField.validationLabel.isHidden = true
            passwordField.textField.layer.borderColor = Constants.Colors.mainPurple?.cgColor
            isPasswordValid = true
        } else {
            passwordField.validationLabel.isHidden = false
            passwordField.textField.layer.borderColor = Constants.Colors.mainPink?.cgColor
        }
        validateInputs()
    }
    
    @objc func confirmPasswordValidate() {
        if let confirmPassword = confirmPasswordField.text, confirmPassword == passwordField.text {
            confirmPasswordField.validationLabel.isHidden = true
            confirmPasswordField.textField.layer.borderColor = Constants.Colors.mainPurple?.cgColor
            isConfirmPasswordValid = true
        } else {
            confirmPasswordField.validationLabel.isHidden = false
            confirmPasswordField.textField.layer.borderColor = Constants.Colors.mainPink?.cgColor
        }
        validateInputs()
    }
    
    @objc func termsAgreeValidate() {
        if allAgreeCheckBox.isSelected {
            termsValidationLabel.isHidden = true
            isTermsAgreeValid = true
        } else {
            termsValidationLabel.isHidden = false
        }
        validateInputs()
    }
    
    var isValid = false
    @objc func validateInputs() {
        isValid = isUsernameValid && isEmailValid && isPasswordValid && isConfirmPasswordValid && isTermsAgreeValid
        signUpButton.isEnabled = isValid
        signUpButton.backgroundColor = isValid ? Constants.Colors.mainPurple : Constants.Colors.bgGray
    }
    
}
