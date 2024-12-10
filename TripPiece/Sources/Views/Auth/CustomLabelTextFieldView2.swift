// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import SnapKit

//회원가입 뷰 텍스트필드
class CustomLabelTextFieldView2: UIView {
    let label: UILabel
    let textField: PaddedTextField
    let validationLabel: UILabel

    var text: String? {
        return textField.text
    }

    init(labelText: String, textFieldPlaceholder: String, validationText: String) {
        self.label = UILabel()
        self.textField = PaddedTextField(padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10
                                                              ))
        self.validationLabel = UILabel()

        super.init(frame: .zero)

        label.text = labelText
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .left

        textField.placeholder = textFieldPlaceholder
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.backgroundColor = UIColor(hex: "#FFFFFF")

        textField.layer.borderColor = UIColor(hex: "#FFFFFF")?.cgColor
        textField.layer.borderWidth = 1.0  // 원하는 테두리 두께로 설정
        textField.layer.cornerRadius = 5.0  // 테두리에 둥근 모서리를 주고 싶을 때 설정
        
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOpacity = 0.1 // 투명도 설정 (0.0 ~ 1.0)
        textField.layer.shadowOffset = CGSize(width: 3, height: 3) // 섀도우의 위치 설정
        textField.layer.shadowRadius = 5.0 // 섀도우의 블러 정도 설정

        validationLabel.text = validationText
        validationLabel.textColor = UIColor(hex: "#FD2D69")
        validationLabel.font = UIFont.systemFont(ofSize: 12)
        validationLabel.isHidden = true // Initially hidden

        addSubview(label)
        addSubview(textField)
        addSubview(validationLabel)

        label.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        validationLabel.snp.makeConstraints { make in
            make.centerY.equalTo(label.snp.centerY)
            make.trailing.lessThanOrEqualToSuperview()
        }
        textField.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
