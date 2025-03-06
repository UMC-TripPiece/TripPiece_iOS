// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import SnapKit
//import FirebaseAuth
import FirebaseCore
import Moya

class SignUpVC: UIViewController {
    // MARK: - UI Properties
    let navigationBarManager = NavigationBarManager()
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    private lazy var usernameField = CustomLabelTextFieldView2(labelText: "이름", textFieldPlaceholder: "| 이름을 입력해 주세요", validationText: "이름을 입력해주세요")
    
    private lazy var emailField = CustomLabelTextFieldView2(labelText: "이메일", textFieldPlaceholder: "| 사용할 이메일 주소를 입력해 주세요", validationText: "사용할 수 없는 이메일입니다")
    
    private lazy var confirmCodeField: PaddedTextField = {
        let textField = PaddedTextField(padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        textField.placeholder = "| 인증번호 입력"
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 16)
        return textField
    }()
    
    private lazy var confirmCodeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("인증번호 전송", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = Constants.Colors.bgGray
        button.layer.cornerRadius = 5
        button.isEnabled = false
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var codeValidationLabel: UILabel = {
        let label = UILabel()
        label.text = "인증번호가 전송되었습니다."
        label.textColor = Constants.Colors.mainPurple
        label.font = UIFont.systemFont(ofSize: 12)
        label.isHidden = true
        return label
    }()
    
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
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("가입하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = Constants.Colors.bgGray
        button.layer.cornerRadius = 8
        button.isEnabled = false
        button.addTarget(self, action: #selector(showTermsModal), for: .touchUpInside)
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
        setupView()
        setupNavigationBar()
        setupConstraints()
        setupActions()
        validateInputs()
        
        setupKeyboardObservers()
        setupDismissKeyboardGesture()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup Methods
    private func setupNavigationBar() {
        // itemTitle을 네비게이션 바 제목으로 설정
        navigationBarManager.setTitle(to: navigationItem, title: "SIGN UP", textColor: Constants.Colors.mainPurple!)
        navigationBarManager.addBackButton(to: navigationItem, target: self, action: #selector(didTapBackButton))
    }
    
    private func setupView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [usernameField, emailField, confirmCodeField, confirmCodeButton, codeValidationLabel, passwordField, confirmPasswordField, signUpButton].forEach {
            contentView.addSubview($0)
        }
        
        self.view.backgroundColor = Constants.Colors.bg4
    }
    
    private func setupConstraints() {
        // scrollView는 view 전체에 맞춤
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // contentView는 scrollView의 contentLayoutGuide와 frameLayoutGuide에 맞춤
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            // contentView의 높이는 내부 요소에 따라 확장되도록 함
        }

        // 모든 서브뷰는 contentView를 기준으로 배치합니다.
        usernameField.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(DynamicPadding.dynamicValue(20.0))
            make.leading.trailing.equalTo(contentView).inset(20)
        }
        emailField.snp.makeConstraints { make in
            make.top.equalTo(usernameField.snp.bottom).offset(DynamicPadding.dynamicValue(20.0))
            make.leading.trailing.equalTo(contentView).inset(20)
        }
        confirmCodeField.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(DynamicPadding.dynamicValue(10.0))
            make.leading.equalTo(contentView).inset(20)
            make.width.equalTo(contentView).multipliedBy(0.6)
            make.height.equalTo(50)
        }
        confirmCodeButton.snp.makeConstraints { make in
            make.centerY.equalTo(confirmCodeField)
            make.leading.equalTo(confirmCodeField.snp.trailing).offset(10)
            make.trailing.equalTo(contentView).inset(20)
            make.height.equalTo(50)
        }
        codeValidationLabel.snp.makeConstraints { make in
            make.top.equalTo(confirmCodeField.snp.bottom).offset(DynamicPadding.dynamicValue(10.0))
            make.leading.equalTo(contentView).inset(20)
        }
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(codeValidationLabel.snp.bottom).offset(DynamicPadding.dynamicValue(20.0))
            make.leading.trailing.equalTo(contentView).inset(20)
        }
        confirmPasswordField.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(DynamicPadding.dynamicValue(20.0))
            make.leading.trailing.equalTo(contentView).inset(20)
        }
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordField.snp.bottom).offset(40)
            make.leading.trailing.equalTo(contentView).inset(20)
            make.height.equalTo(50)
            make.bottom.equalTo(contentView).offset(-20) // contentView의 bottom까지 확장
        }
    }

    
    // MARK: - 키보드 설정
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    private func scrollToActiveTextField() {
        guard let activeField = getActiveTextField() else { return }
        
        let textFieldFrame = activeField.convert(activeField.bounds, to: view)
        let keyboardHeight = scrollView.contentInset.bottom
        
        let visibleHeight = scrollView.frame.height - keyboardHeight

        if textFieldFrame.maxY > visibleHeight {
            let offsetY = textFieldFrame.maxY - visibleHeight + 20 // 여유 공간 추가
            scrollView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: true)
        }
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        let keyboardHeight = keyboardFrame.height

        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentInset.bottom = keyboardHeight + 30
            self.scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight + 30
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.scrollToActiveTextField()
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollView.contentInset = .zero
            self.scrollView.verticalScrollIndicatorInsets = .zero
        })
    }


    /// 현재 활성화된 `UITextField` 찾기
    func getActiveTextField() -> UITextField? {
        return findActiveTextField(in: contentView)
    }

    /// 재귀적으로 서브뷰에서 현재 활성화된 `UITextField` 찾기
    private func findActiveTextField(in view: UIView) -> UITextField? {
        for subview in view.subviews {
            if let textField = subview as? UITextField, textField.isFirstResponder {
                return textField
            } else if let found = findActiveTextField(in: subview) {
                return found
            }
        }
        return nil
    }

    // MARK: - 키보드 해제 설정
    func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupActions() {
        usernameField.textField.addTarget(self, action: #selector(usernameValidate), for: .editingChanged)
        emailField.textField.addTarget(self, action: #selector(emailValidate), for: .editingChanged)
        passwordField.textField.addTarget(self, action: #selector(passwordValidate), for: .editingChanged)
        confirmPasswordField.textField.addTarget(self, action: #selector(confirmPasswordValidate), for: .editingChanged)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func confirmButtonTapped() {
        guard let email = emailField.text else {
            // 이메일이 비어 있는 경우 처리
            emailField.validationLabel.isHidden = false
            emailField.textField.layer.borderColor = Constants.Colors.mainPink?.cgColor
            confirmCodeButton.isEnabled = false
            confirmCodeButton.backgroundColor = Constants.Colors.bgGray
            return
        }
        
        if ValidationUtility.isValidEmail(email) {
            emailField.validationLabel.isHidden = true
            emailField.textField.layer.borderColor = Constants.Colors.mainPurple?.cgColor
            confirmCodeButton.isEnabled = true
            confirmCodeButton.backgroundColor = Constants.Colors.mainPurple
            if confirmCodeButton.title(for: .normal) == "인증번호 전송" {
                callSendCodeAPI(email: email) { isSuccess in
                    if isSuccess {
                        //TODO: 이메일 중복 경우 분기처리 필요
                        self.confirmCodeButton.setTitle("인증번호 확인", for: .normal)
                        self.confirmCodeButton.isEnabled = true
                        self.codeValidationLabel.isHidden = false
                        self.codeValidationLabel.text = "입력하신 이메일로 코드가 전송되었습니다!"
                    }
                }
            } else if confirmCodeButton.title(for: .normal) == "인증번호 확인" {
                if let emailCodeRequest = self.setupEmailCodeDTO(email, confirmCodeField.text!) {
                    self.validateCodeAPI(emailCodeRequest) { isSuccess in
                        if isSuccess {
                            self.isEmailValid = true
                            self.codeValidationLabel.text = "인증번호 확인이 완료되었어요!"
                            self.validateInputs()
                        }
                    }
                }
            }
        } else {
            // 이메일 형식이 올바르지 않은 경우 처리
            emailField.validationLabel.isHidden = false
            emailField.textField.layer.borderColor = Constants.Colors.mainPink?.cgColor
            confirmCodeButton.isEnabled = false
            confirmCodeButton.backgroundColor = Constants.Colors.bgGray
        }
    }
    
    @objc func showTermsModal() {
        SignUpManager.shared.setName(username: usernameField.text!, emailString: emailField.text!, pwString: passwordField.text!)
        let termsModalVC = TermsModalVC()
        termsModalVC.isModalInPresentation = true
        termsModalVC.loadViewIfNeeded()
        let navigationController = UINavigationController(rootViewController: termsModalVC)

        navigationController.modalPresentationStyle = .pageSheet
        navigationController.sheetPresentationController?.detents = [.medium(), .large()]
        navigationController.sheetPresentationController?.prefersGrabberVisible = true

        present(navigationController, animated: true, completion: nil)
    }
    
    func navigateToProfileVC() {
        let profileVC = ProfileVC()
        profileVC.isEmailLogin = true
        profileVC.modalPresentationStyle = .fullScreen
        present(profileVC, animated: true, completion: nil)
    }
    
    lazy var isUsernameValid = false
    lazy var isEmailValid = false
    lazy var isPasswordValid = false
    lazy var isConfirmPasswordValid = false
    
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
                confirmCodeButton.isEnabled = true
                confirmCodeButton.backgroundColor = Constants.Colors.mainPurple
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
    
    var isValid = false
    @objc func validateInputs() {
        isValid = isUsernameValid && isEmailValid && isPasswordValid && isConfirmPasswordValid
        signUpButton.isEnabled = isValid
        signUpButton.backgroundColor = isValid ? Constants.Colors.mainPurple : Constants.Colors.bgGray
    }
}
extension UIView {
    func selectedTextField() -> UITextField? {
        if let textField = self as? UITextField, textField.isFirstResponder {
            return textField
        }
        for subview in subviews {
            if let activeTextField = subview.selectedTextField() {
                return activeTextField
            }
        }
        return nil
    }
}
