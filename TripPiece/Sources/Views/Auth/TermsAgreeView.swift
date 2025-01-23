// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import SnapKit

class TermsAgreeView: UIView {
    
    // MARK: - UI Components
    private let titleLabel = UILabel()
    private let moreButton = UIButton(type: .system)
    private let toggleButton = UIButton(type: .system)
    
    // MARK: - Properties
    var onStateChange: ((Bool) -> Void)? // 상태 변경 시 호출되는 클로저
    
    private var detailInfo: String?
    
    private var isChecked: Bool = false
    
    // MARK: - Initializer
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        titleLabel.numberOfLines = 1
        titleLabel.textColor = Constants.Colors.black2
        titleLabel.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleButtonTapped))
                titleLabel.addGestureRecognizer(tapGesture)
        
        moreButton.setTitle("보기", for: .normal)
        moreButton.setTitleColor(Constants.Colors.black3, for: .normal)
        moreButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        moreButton.addTarget(self, action: #selector(showDetailVC), for: .touchUpInside)
        
        toggleButton.tintColor = Constants.Colors.black5
        toggleButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        toggleButton.addTarget(self, action: #selector(toggleButtonTapped), for: .touchUpInside)
        
        [titleLabel, moreButton, toggleButton].forEach {
            addSubview($0)
        }
        
        toggleButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(DynamicPadding.dynamicValue(32.0))
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(toggleButton.snp.trailing).offset(10)
            make.centerY.equalTo(toggleButton)
        }
        
        moreButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(32.0))
            make.centerY.equalTo(toggleButton)
        }
    }
    
    // MARK: - Configuration
    func configure(title: String, content: String?, isChecked: Bool) {
        titleLabel.text = title
        detailInfo = content
        self.isChecked = isChecked
        updateToggleButton()
    }
    
    // MARK: - Methods
    @objc private func toggleButtonTapped() {
        isChecked.toggle()
        updateToggleButton()
        onStateChange?(isChecked)
    }
    
    func setChecked(isChecked: Bool) {
        self.isChecked = isChecked
        updateToggleButton()
    }
    
    private func updateToggleButton() {
        let imageName = isChecked ? "checkmark.circle.fill" : "checkmark.circle.fill"
        toggleButton.setImage(UIImage(systemName: imageName), for: .normal)
        toggleButton.tintColor = isChecked ? Constants.Colors.mainPurple : Constants.Colors.black5
    }
    
    @objc private func showDetailVC() {
        print("showDetailVC Tapperd")
        guard let parentVC = parentViewController else {
                print("부모 뷰 컨트롤러가 설정되지 않았습니다.")
                return
            }
            
        let detailVC = DetailInfoVC(
                title: titleLabel.text ?? "앱 정보",
                content: detailInfo ?? "약관의 세부 내용을 여기에 제공합니다."
            )
            parentVC.navigationController?.pushViewController(detailVC, animated: true)
    }
}
