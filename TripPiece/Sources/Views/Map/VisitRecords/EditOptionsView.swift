// Copyright © 2024 TripPiece. All rights reserved

import UIKit

// 기록 수정 버튼 custom
class EditOptionsView: UIView {

    let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("수정하기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.setImage(UIImage(named: "editPencil"), for: .normal)  // 펜슬 아이콘
        button.tintColor = UIColor(hex: "#636363")
        button.setTitleColor(UIColor(hex: "#636363"), for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        // 제약 조건 설정
        guard let imageView = button.imageView else { return button }
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(28)
            make.centerY.equalToSuperview().offset(2)
            make.leading.equalToSuperview().offset(5)
        }
        return button
    }()

    let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("기록 삭제", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        let trashImage = UIImage(systemName: "trash")?.resized(to: CGSize(width: 26, height: 26)) // 원하는 크기로 리사이즈
        button.setImage(trashImage, for: .normal)
        button.tintColor = Constants.Colors.mainPink
        button.setTitleColor(Constants.Colors.mainPink, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        // 제약 조건 설정
        guard let imageView = button.imageView else { return button }
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview().offset(1)
            make.leading.equalToSuperview().offset(5)
        }
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 5
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 5

        addSubview(editButton)
        addSubview(deleteButton)

        // Auto Layout 설정
        editButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview().offset(-5)
            make.height.equalTo(36.5)
        }
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(editButton.snp.bottom)
            make.centerX.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview()
        }

    }
}
