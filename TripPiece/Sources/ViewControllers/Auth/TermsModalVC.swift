// Copyright © 2024 TripPiece. All rights reserved

import Foundation
import UIKit
import SnapKit
import Then

class TermsModalVC: UIViewController {

    // MARK: - Properties
    var agreements: [Bool] = [false, false, false, false]
    private var isAllAgreed: Bool = false
    
    private var agreeItems: [TermsAgreeView] = []
    
    // MARK: - UI Components
    private let subHeaderLabel = UILabel().then {
        $0.text = "약관에 동의해 주세요"
        $0.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    private let allTitleLabel = UILabel().then {
        $0.text = "전체 약관 동의"
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.textColor = Constants.Colors.black
    }
    
    private let dividerView = UIView().then {
        $0.backgroundColor = Constants.Colors.bgGray
    }
    
    private let allToggleButton = UIButton(type: .system).then {
        $0.tintColor = Constants.Colors.black5
        $0.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        $0.addTarget(self, action: #selector(allAgreeButtonTapped), for: .touchUpInside)
    }
    
    private lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("가입하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = Constants.Colors.bgGray
        button.layer.cornerRadius = 8
        button.isEnabled = false
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationItem.leftBarButtonItem = nil
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        print(allToggleButton.isUserInteractionEnabled) // true여야 합니다
        print(allToggleButton.frame)
        
        setupUI()
        setupConstraints()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = Constants.Colors.white
        
        [subHeaderLabel, allToggleButton, allTitleLabel, dividerView, startButton].forEach {
            view.addSubview($0)
        }
        
        for index in 0..<3 {
            let title = ["(필수) 서비스 이용약관 동의", "(필수) 개인정보 처리방침 동의", "(필수) 위치정보 이용약관"][index]
            //TODO: 이용약관 내용 추가
            let contents = ["Constants.Policy.privacy", "Constants.Policy.location", "Constants.Policy.service"][index]
            let agreeView = createAgreeView(title: title, content: contents ,index: index)
            agreeItems.append(agreeView)
            view.addSubview(agreeView)
        }
    }
    
    private func setupConstraints() {
        subHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(DynamicPadding.dynamicValue(32.0))
            make.leading.equalToSuperview().inset(DynamicPadding.dynamicValue(20.0))
        }
        allToggleButton.snp.makeConstraints { make in
            make.top.equalTo(subHeaderLabel.snp.bottom).offset(DynamicPadding.dynamicValue(50.0))
            make.leading.equalToSuperview().inset(DynamicPadding.dynamicValue(20.0))
            make.width.height.equalTo(24)
        }
        
        allTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(allToggleButton)
            make.leading.equalTo(allToggleButton.snp.trailing).offset(10)
        }
        
        dividerView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(32.0))
            make.top.equalTo(allTitleLabel.snp.bottom).offset(DynamicPadding.dynamicValue(20.0))
        }
        
        for (index, view) in agreeItems.enumerated() {
            view.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                
                if index == 0 {
                    make.top.equalTo(dividerView.snp.bottom).offset(DynamicPadding.dynamicValue(20.0)) // 첫 번째 뷰의 제약 조건
                } else {
                    make.top.equalTo(agreeItems[index - 1].snp.bottom).offset(DynamicPadding.dynamicValue(10.0)) // 이전 뷰의 아래쪽에 위치
                }
                
                make.height.equalTo(DynamicPadding.dynamicValue(32.0))
            }
        }
        
        startButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(20.0))
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-DynamicPadding.dynamicValue(30.0))
            make.height.equalTo(50)
        }
    }
    
    
    // MARK: - Factory Method
    private func createAgreeView(title: String, content: String, index: Int) -> TermsAgreeView {
        return TermsAgreeView().then { agreeView in
            agreeView.configure(
                title: title,
                content: content,
                isChecked: agreements[index]
            )
            
            agreeView.onStateChange = { [weak self] isChecked in
                guard let self = self else { return }
                self.agreements[index] = isChecked
                self.updateStartButtonState()
            }
        }
    }
    
    // MARK: - Actions
    @objc private func allAgreeButtonTapped() {
        print("전체 동의 버튼 클릭됨") // 호출 여부 확인
        isAllAgreed.toggle()
        agreements = Array(repeating: isAllAgreed, count: agreements.count)
        allToggleButton.tintColor = isAllAgreed ? Constants.Colors.mainPurple : Constants.Colors.black5
        agreeItems.forEach { $0.setChecked(isChecked: isAllAgreed) }
        updateStartButtonState()
    }
    
    private func updateStartButtonState() {
        let allRequiredAgreed = agreements.prefix(3).allSatisfy { $0 }
        isAllAgreed = allRequiredAgreed
        allToggleButton.tintColor = isAllAgreed ? Constants.Colors.mainPurple : Constants.Colors.black5
        startButton.isEnabled = allRequiredAgreed
        startButton.backgroundColor = allRequiredAgreed ? Constants.Colors.mainPurple : Constants.Colors.bgGray
    }
    
    @objc private func startButtonTapped() {
        let profileVC = ProfileVC()
        
        profileVC.isEmailLogin = true
        profileVC.modalPresentationStyle = .fullScreen
        present(profileVC, animated: true, completion: nil)
    }
}
