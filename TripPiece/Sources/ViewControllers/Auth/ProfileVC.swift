// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import SnapKit
import Moya

class ProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var isEmailLogin = false
    var isSocialLogin = false
    
    let profileLabel: UILabel = {
        let label = UILabel()
        label.text = "PROFILE"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = Constants.Colors.mainPurple
        return label
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profilePlaceholder")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 60
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let profileImageIconView = IconBadgeView(systemName: "camera", iconSize: 20, backgroundSize: 40)
    
    private lazy var nicknameTextField: CustomLabelTextFieldView2 = {
        let textField = CustomLabelTextFieldView2(labelText: "닉네임", textFieldPlaceholder: "| 사용할 닉네임을 입력해 주세요.", validationText: "")
        textField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return textField
    }()
    
    let genderLabel: UILabel = {
        let label = UILabel()
        label.text = "성별"
        return label
    }()
    
    let genderSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["남성", "여성"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        return segmentedControl
    }()
    
    let birthdateLabel: UILabel = {
        let label = UILabel()
        label.text = "생년월일"
        return label
    }()
    
    let birthdateTextField: PaddedTextField = {
        let textField = PaddedTextField(padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        textField.setPlaceholder("YYYY/MM/DD")
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return textField
    }()
    
    let birthdatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        return picker
    }()
    
    let countryLabel: UILabel = {
        let label = UILabel()
        label.text = "국적"
        return label
    }()
    
    let countryTextField: PaddedTextField = {
        let textField = PaddedTextField(padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        textField.setPlaceholder("🇰🇷 대한민국", color: .black)
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    let explainLabel : UILabel = {
        //TODO: 국가 선택 기능
        let label = UILabel()
        label.text = "선택한 국가 외 지역으로 이동하면\n 여행 기록 기능이 자동으로 활성화됩니다."
        return label
    }()
    
    let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("시작하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.isEnabled = false
        button.backgroundColor = Constants.Colors.bgGray // Replace with actual UIColor if not defined
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Colors.bg4
        // 뷰 설정 및 초기화
        setupViews()
        setupConstraints()
        
        configureTapGestureForProfileImage()
        configureTapGestureForDismissingPicker()
        configureDatePicker()
    }
    
    func setupViews() {
        [profileLabel, profileImageView, profileImageIconView, nicknameTextField, genderLabel, genderSegmentedControl, birthdateLabel, birthdateTextField, countryLabel, countryTextField, explainLabel, startButton].forEach {
            view.addSubview($0)
        }
    }
    
    func setupConstraints() {
        profileLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.centerX.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(profileLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        profileImageIconView.snp.makeConstraints { make in
            make.centerX.equalTo(profileImageView.snp.trailing).offset(-20)
            make.centerY.equalTo(profileImageView.snp.bottom).offset(-20)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        genderLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(20)
            make.leading.equalTo(nicknameTextField)
        }
        
        genderSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(genderLabel.snp.bottom).offset(8)
            make.leading.equalTo(nicknameTextField)
            make.width.equalTo(superViewWidth * 0.4)
            make.height.equalTo(50)
        }
        
        birthdateLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(20)
            make.leading.equalTo(genderSegmentedControl.snp.trailing).offset(20)
        }
        
        birthdateTextField.snp.makeConstraints { make in
            make.top.equalTo(birthdateLabel.snp.bottom).offset(8)
            make.leading.equalTo(birthdateLabel)
            make.trailing.equalTo(nicknameTextField)
            make.height.equalTo(50)
        }
        
        countryLabel.snp.makeConstraints { make in
            make.top.equalTo(birthdateTextField.snp.bottom).offset(20)
            make.leading.equalTo(nicknameTextField)
        }
        
        countryTextField.snp.makeConstraints { make in
            make.top.equalTo(countryLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(nicknameTextField)
            make.height.equalTo(50)
        }
        
        startButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-40)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
    
    @objc func signUpButtonTapped() {
        print("isEmailLogin : \(isEmailLogin)")
        print("isSocialLogin : \(isSocialLogin)")
        if isEmailLogin {
            SignUpManager.shared.setProfile(nicknameString: nicknameTextField.text!, birthString: birthdateTextField.text!, countryString: "South Korea")
            callSignUpAPI() { isSuccess in
                if isSuccess {
                    self.proceedIfSignupSuccessful()
                    print("회원 가입 성공")
                } else {
                    print("회원 가입 실패")
                }
            }
        }
        if isSocialLogin {
            SocialSignUpManager.shared.setProfile(nicknameString: nicknameTextField.text!, birthString: birthdateTextField.text!, countryString: "South Korea")
            callKakaoSignUpAPI() { isSuccess in
                if isSuccess {
                    self.proceedIfSignupSuccessful()
                    print("회원 가입 성공")
                } else {
                    print("회원 가입 실패")
                }
            }
        }
        
    }
    
    func configureTapGestureForProfileImage() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectProfileImage))
        profileImageIconView.addGestureRecognizer(tapGesture)
    }
    
    func configureTapGestureForDismissingPicker() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissDatePicker))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissDatePicker() {
        view.endEditing(true)
    }
    
    func configureDatePicker() {
        birthdatePicker.datePickerMode = .date
        birthdatePicker.preferredDatePickerStyle = .wheels
        birthdatePicker.maximumDate = Date()
        birthdatePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        birthdateTextField.inputView = birthdatePicker
    }
    
    // 프로필 이미지 선택
    @objc func selectProfileImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            profileImageView.image = selectedImage
            if isEmailLogin {
                SignUpManager.shared.profileImg = selectedImage
            }
            if isSocialLogin {
                SocialSignUpManager.shared.profileImg = selectedImage
            }
            
        } else {
            print("⚠️ 이미지 선택 실패")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
//    func convertImageToFileData(_ image: UIImage, fileName: String = "profile.jpg") -> (data: Data, fileName: String, mimeType: String)? {
//        guard let imageData = image.jpegData(compressionQuality: 0.1) else { // JPEG로 변환
//            print("이미지를 JPEG 데이터로 변환 실패")
//            return nil
//        }
//        return (data: imageData, fileName: "profile.jpg", mimeType: "image/jpeg")
//    }
//    
    // 닉네임 또는 생년월일 변경 시 호출
    @objc func textFieldDidChange(_ textField: UITextField) {
        checkFormValidity()
    }
    
    // 성별 선택 시 호출
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        let selectedValue = sender.titleForSegment(at: selectedIndex)

        if let genderString = selectedValue {
            switch genderString {
            case "남성":
                SignUpManager.shared.gender = "MALE"
                SocialSignUpManager.shared.gender = "MALE"
            case "여성":
                SignUpManager.shared.gender = "FEMALE"
                SocialSignUpManager.shared.gender = "FEMALE"
            default:
                print("Unknown gender selected")
            }
        }

        checkFormValidity()
    }
    
    // 생년월일 변경 시 호출
    @objc func dateChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        birthdateTextField.text = dateFormatter.string(from: sender.date)
        checkFormValidity()
    }
    
    // 폼 유효성 검사
    func checkFormValidity() {
        let isFormValid = !(nicknameTextField.text?.isEmpty ?? true) &&
        !(birthdateTextField.text?.isEmpty ?? true) &&
        (genderSegmentedControl.selectedSegmentIndex != UISegmentedControl.noSegment)
        
        startButton.isEnabled = isFormValid
        startButton.backgroundColor = isFormValid ? Constants.Colors.mainPurple : Constants.Colors.bgGray
    }
    
    func sendSignupRequest() {
        callSignUpAPI() { isSuccess in
            if isSuccess {
                self.proceedIfSignupSuccessful()
                print("회원 가입 성공")
            } else {
                print("회원 가입 실패")
            }
        }
    }
    
    func proceedIfSignupSuccessful() {
        let VC = TabBar()
        VC.modalPresentationStyle = .fullScreen
        present(VC, animated: true, completion: nil)
        
    }
}
