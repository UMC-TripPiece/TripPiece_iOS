// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import SnapKit

class KakaoProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var userInfo: [String: Any]?
    var selectedImageData: Data?
    var status = false
    lazy var loginPath = ""
    class PaddedTextField: UITextField {
        
        var padding: UIEdgeInsets
        
        init(padding: UIEdgeInsets) {
            self.padding = padding
            super.init(frame: .zero)
            setupDefaultStyle()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // Adjusts the text position within the field
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: padding)
        }
        
        // Adjusts the text position during editing
        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: padding)
        }
        
        // Adjusts the placeholder text position
        override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: padding)
        }
        
        // Method to setup the default style for the text field
        private func setupDefaultStyle() {
            self.borderStyle = .none
            self.layer.borderColor = Constants.Colors.bgGray?.cgColor
            self.layer.borderWidth = 1.0
            self.layer.cornerRadius = 5.0
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.1 // Shadow opacity (0.0 ~ 1.0)
            self.layer.shadowOffset = CGSize(width: 3, height: 3) // Shadow offset position
            self.layer.shadowRadius = 5.0
            self.backgroundColor = Constants.Colors.white
        }
        
        // Optional: Method to easily update the placeholder text
        func setPlaceholder(_ placeholder: String, color: UIColor = .lightGray) {
                self.attributedPlaceholder = NSAttributedString(
                    string: placeholder,
                    attributes: [NSAttributedString.Key.foregroundColor: color]
                )
            }
    }
    
    // UI 요소 선언
    let profileLabel = UILabel()
    let profileImageView = UIImageView()
    let profileImageIconView = UIImageView()
    let nicknameTextField = PaddedTextField(padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
    let genderLabel = UILabel()
    let genderSegmentedControl = UISegmentedControl(items: ["남성", "여성"])
    let birthdateLabel = UILabel()
    let birthdateTextField = PaddedTextField(padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
    let birthdatePicker = UIDatePicker()
    let countryLabel = UILabel()
    let countryTextField = PaddedTextField(padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
    let startButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Colors.bg4
        // 뷰 설정 및 초기화
        setupViews()
        setupConstraints()
        
        // 기타 설정
        configureTapGestureForProfileImage()
        configureTapGestureForDismissingPicker()
        configureDatePicker()
    }
    
    func setupViews() {
        // 프로필 라벨 설정
        profileLabel.text = "PROFILE"
        profileLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        profileLabel.textColor = Constants.Colors.mainPurple
        
        // 프로필 이미지 설정
        profileImageView.image = UIImage(named: "profileExample")
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 50
        profileImageView.clipsToBounds = true
        
        profileImageIconView.image = UIImage(named: "photoEditIcon")
        profileImageIconView.isUserInteractionEnabled = true
        // 나머지 UI 요소 설정
        nicknameTextField.setPlaceholder("사용할 닉네임을 입력해주세요")
        nicknameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        genderLabel.text = "성별"
        
        genderSegmentedControl.selectedSegmentIndex = 0
        userInfo?["gender"] = "MALE"
        genderSegmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        
        birthdateLabel.text = "생년월일"
        
        birthdateTextField.setPlaceholder( "YYYY/MM/DD")
        birthdateTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        countryLabel.text = "국적"
        
        countryTextField.setPlaceholder("🇰🇷 대한민국", color: .black)
        countryTextField.isUserInteractionEnabled = false
        
        
        
        startButton.setTitle("시작하기", for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        startButton.isEnabled = false
        startButton.backgroundColor = Constants.Colors.bgGray
        startButton.layer.cornerRadius = 8
        startButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        
        [profileLabel, profileImageView, profileImageIconView, nicknameTextField, genderLabel, genderSegmentedControl, birthdateLabel, birthdateTextField, countryLabel, countryTextField, startButton].forEach {
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
            make.width.height.equalTo(100)
        }
        profileImageIconView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.centerX.equalTo(profileImageView.snp.trailing).offset(-15)
            make.centerY.equalTo(profileImageView.snp.bottom).offset(-15)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        genderLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(20)
            make.leading.equalTo(nicknameTextField)
        }
        
        genderSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(genderLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(nicknameTextField)
            make.height.equalTo(50)
        }
        
        birthdateLabel.snp.makeConstraints { make in
            make.top.equalTo(genderSegmentedControl.snp.bottom).offset(20)
            make.leading.equalTo(nicknameTextField)
        }
        
        birthdateTextField.snp.makeConstraints { make in
            make.top.equalTo(birthdateLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(nicknameTextField)
            make.height.equalTo(50)
        }
        
        countryLabel.snp.makeConstraints { make in
            make.top.equalTo(birthdateTextField.snp.bottom).offset(20)
            make.leading.equalTo(nicknameTextField)
            make.height.equalTo(50)
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
    
    // 추가적인 기능 구현 (예: 프로필 이미지 선택, 생년월일 변경 등)
    
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
        print(userInfo)
        sendSignupRequest()
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
            
            // 선택된 이미지를 jpegData로 변환하여 저장
            selectedImageData = selectedImage.jpegData(compressionQuality: 0.2)
            
            if selectedImageData != nil {
                print("이미지 데이터 저장 완료")
            } else {
                print("이미지 데이터 변환 실패")
            }
        } else {
            print("이미지 선택 실패")
        }
        
        // 이미지 피커 닫기
        dismiss(animated: true, completion: nil)
    }
    
    // 닉네임 또는 생년월일 변경 시 호출
    @objc func textFieldDidChange(_ textField: UITextField) {
        checkFormValidity()
    }
    
    // 성별 선택 시 호출
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        let selectedValue = sender.titleForSegment(at: selectedIndex)
        if selectedValue == "남성" {
            userInfo?["gender"] = "MALE"
        } else if selectedValue == "여성" {
            userInfo?["gender"] = "FEMALE"
        }
        checkFormValidity()
    }
    
    // 생년월일 변경 시 호출
    @objc func dateChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        birthdateTextField.text = dateFormatter.string(from: sender.date)
        userInfo?["birth"] = birthdateTextField.text
        checkFormValidity()
    }
    
    // 폼 유효성 검사
    func checkFormValidity() {
        let isFormValid = !(nicknameTextField.text?.isEmpty ?? true) &&
            !(birthdateTextField.text?.isEmpty ?? true) &&
            (genderSegmentedControl.selectedSegmentIndex != UISegmentedControl.noSegment)
        
        userInfo?["nickname"] = nicknameTextField.text
        userInfo?["country"] = "South Korea"
        
        startButton.isEnabled = isFormValid
        startButton.backgroundColor = isFormValid ? Constants.Colors.mainPurple : Constants.Colors.bgGray
    }
    
    func sendSignupRequest() {
        guard let url = URL(string: "http://3.34.111.233:8080/user/kakao/signup") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        

        // JSON 데이터를 문자열로 변환
        let jsonData = try! JSONSerialization.data(withJSONObject: userInfo, options: [])
        let jsonString = String(data: jsonData, encoding: .utf8)!
        
        // 멀티파트 데이터 생성
        var body = Data()
        
        // 'info' 필드 추가
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"info\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(jsonString)\r\n".data(using: .utf8)!)
        
        // 이미지 파일 추가
        
        if let imageData = selectedImageData {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"profileImg\"; filename=\"Group 2085663362.png\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
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
                }
                return
            }
            
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Response data: \(responseString)")
                DispatchQueue.main.async {
                                // 응답이 성공적일 경우 status를 true로 변경
                    self.status = true
                                self.proceedIfSignupSuccessful()
                            }
            }
        }
        task.resume()
    }

    func proceedIfSignupSuccessful() {
        if status {
            let VC = SignUpVC()
            VC.modalPresentationStyle = .fullScreen
            present(VC, animated: true, completion: nil)
        }
    }
}
