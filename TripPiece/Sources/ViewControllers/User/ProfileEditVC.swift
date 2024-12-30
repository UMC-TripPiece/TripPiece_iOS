// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import SnapKit
import SDWebImage

class ProfileEditVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    var selectedImageData: Data?
    
    // MARK: - UI Elements
    private lazy var backButton: CustomBackButton = {
        let button = CustomBackButton(title: "")
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    private let updateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("완료", for: .normal)
        button.setTitleColor(Constants.Colors.black3, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let profileLabel: UILabel = {
        let label = UILabel()
        label.text = "PROFILE"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = Constants.Colors.mainPurple
        return label
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "profileExample")
        return imageView
    }()
    
    let photoEditIconView = IconBadgeView(systemName: "camera", iconSize: 20, backgroundSize: 35)
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        return label
    }()
    
    private let nicknameTextField: PaddedTextField = {
        let textField = PaddedTextField(padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        return textField
    }()
    
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.text = "성별"
        return label
    }()
    
    private let genderSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["남성", "여성"])
        return segmentedControl
    }()
    
    private let birthdateLabel: UILabel = {
        let label = UILabel()
        label.text = "생년월일"
        return label
    }()
    
    lazy var birthdateTextField: PaddedTextField = {
        // 텍스트 필드 초기화
        let textField = PaddedTextField(padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        textField.setPlaceholder("YYYY/MM/DD")
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        // UIDatePicker 초기화 및 설정
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.maximumDate = Date()
        picker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        // 텍스트 필드와 데이트 피커 연결
        textField.inputView = picker
        
        return textField
    }()
    
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.text = "국적"
        return label
    }()
    
    private let countryTextField: PaddedTextField = {
        let textField = PaddedTextField(padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        textField.setPlaceholder("🇰🇷 대한민국", color: .black)
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserInfoManager.fetchMemberInfo { result in
            switch result {
            case .success(let memberInfo):
                let profileImgURL = URL(string: memberInfo.result.profileImg)
                self.profileImageView.sd_setImage(with: profileImgURL, placeholderImage: UIImage(named: "profileExample"))
                self.nicknameTextField.text = "\(memberInfo.result.nickname)"
                if memberInfo.result.gender == "MALE" {
                    self.genderSegmentedControl.selectedSegmentIndex = 0
                    ProfileUpdateManager.shared.gender = "MALE"
                } else {
                    self.genderSegmentedControl.selectedSegmentIndex = 1
                    ProfileUpdateManager.shared.gender = "FEMALE"
                }
                self.birthdateTextField.text = "\(memberInfo.result.birth)"
            case .failure(let error):
                print("Error occurred: \(error.localizedDescription)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Colors.bg4
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        setupViews()
        setupConstraints()
        
        // 기타 설정
        configureTapGestureForProfileImage()
        configureTapGestureForDismissingPicker()
    }
    
    // MARK: - UI Setup
    private func setupViews() {
        // UI 요소를 뷰에 추가
        [backButton,
         profileLabel,
         profileImageView,
         photoEditIconView,
         nicknameTextField,
         genderLabel,
         genderSegmentedControl,
         birthdateLabel,
         birthdateTextField,
         countryLabel,
         countryTextField,
         updateButton
        ].forEach { view.addSubview($0) }
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        profileLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
        }
        updateButton.snp.makeConstraints { make in
            make.centerY.equalTo(profileLabel)
            make.trailing.equalTo(nicknameTextField)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(profileLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        photoEditIconView.snp.makeConstraints { make in
            make.centerX.equalTo(profileImageView.snp.trailing).offset(-17)
            make.centerY.equalTo(profileImageView.snp.bottom).offset(-17)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
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
    }
    
    // 추가적인 기능 구현 (예: 프로필 이미지 선택, 생년월일 변경 등)
    @objc private func didTapBackButton() {
        self.navigationController?.isNavigationBarHidden = true
        navigationController?.popViewController(animated: false)
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
    
    func downloadImageData(from urlString: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL string.")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error downloading image data: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received.")
                completion(nil)
                return
            }
            
            completion(data)
        }
        
        task.resume()
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
            ProfileUpdateManager.shared.profileImg = selectedImage
        } else {
            print("⚠️ 이미지 선택 실패")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func updateButtonTapped() {
        ProfileUpdateManager.shared.setProfile(nicknameString: nicknameTextField.text!, birthString: birthdateTextField.text!, countryString: "South Korea")
        
        postProfileUpdateAPI { isSuccess in
            if isSuccess {
                self.proceedIfUpdateSuccessful()
                print("프로필 업데이트 완료")
            } else {
                print("프로필 업데이트 실패")
            }
        }
    }
    
    func configureTapGestureForProfileImage() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectProfileImage))
        photoEditIconView.addGestureRecognizer(tapGesture)
    }
    
    func configureTapGestureForDismissingPicker() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissDatePicker))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissDatePicker() {
        view.endEditing(true)
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
            ProfileUpdateManager.shared.gender = "MALE"
        } else if selectedValue == "여성" {
            ProfileUpdateManager.shared.gender = "FEMALE"
        }
    }
    
    // 생년월일 변경 시 호출
    @objc func dateChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        birthdateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    // 폼 유효성 검사
    func checkFormValidity() {
        let isFormValid = !(nicknameTextField.text?.isEmpty ?? true) &&
        !(birthdateTextField.text?.isEmpty ?? true) &&
        (genderSegmentedControl.selectedSegmentIndex != UISegmentedControl.noSegment)
    }
    
    func proceedIfUpdateSuccessful() {
        self.navigationController?.isNavigationBarHidden = true
        navigationController?.popViewController(animated: false)
    }
}
