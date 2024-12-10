// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import SnapKit

class CustomLabelTextFieldView: UIView {
    let label: UILabel
    let emailField: PaddedTextField
    let passwordField: PaddedTextField
    let validationLabel: UILabel

    var text1: String? {
        return emailField.text
    }
    
    var text2: String? {
        return passwordField.text
    }

    init(labelText: String, emailPlaceholder: String, passwordPlaceholder: String, validationText: String) {
        self.label = UILabel()
        self.emailField = PaddedTextField(padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        self.passwordField = PaddedTextField(padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        self.validationLabel = UILabel()

        super.init(frame: .zero)

        // Label setup
        label.text = labelText
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .left

        // Simplified TextField setup
        setupTextField(emailField, placeholder: emailPlaceholder)
        setupTextField(passwordField, placeholder: passwordPlaceholder)
        self.passwordField.isSecureTextEntry = true

        // ValidationLabel setup
        validationLabel.text = validationText
        validationLabel.textColor = UIColor(hex: "#FD2D69")
        validationLabel.font = UIFont.systemFont(ofSize: 12)
        validationLabel.isHidden = true

        // Add subviews
        addSubview(label)
        addSubview(emailField)
        addSubview(passwordField)
        addSubview(validationLabel)

        // Set constraints
        label.snp.makeConstraints { make in
            make.top.equalToSuperview()
        }
        validationLabel.snp.makeConstraints { make in
            make.centerY.equalTo(label.snp.centerY)
            make.trailing.lessThanOrEqualToSuperview()
        }
        emailField.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview() // Match leading and trailing edges
            make.height.equalTo(50)
        }

        passwordField.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview() // Match leading and trailing edges
            make.height.equalTo(50)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTextField(_ textField: PaddedTextField, placeholder: String) {
        textField.placeholder = placeholder
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.backgroundColor = UIColor.white
        textField.layer.borderColor = UIColor(hex: "#FFFFFF")?.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOpacity = 0.1
        textField.layer.shadowOffset = CGSize(width: 3, height: 3)
        textField.layer.shadowRadius = 5.0
    }
}
