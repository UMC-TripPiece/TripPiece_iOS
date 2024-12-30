// Copyright © 2024 TripPiece. All rights reserved

import UIKit

class RecordButton: UIButton {
    init(emoji: String, title: String, borderColor: UIColor) {
        super.init(frame: .zero)
        setupUI(emoji: emoji, title: title, borderColor: borderColor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI(emoji: String, title: String, borderColor: UIColor) {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 3

        let emojiLabel = UILabel()
        emojiLabel.text = emoji
        emojiLabel.font = UIFont.systemFont(ofSize: 30)

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = .darkGray

        stackView.addArrangedSubview(emojiLabel)
        stackView.addArrangedSubview(titleLabel)

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }

        backgroundColor = .white
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = borderColor.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4

        snp.makeConstraints { make in
            make.height.equalTo(80)
        }
    }
}
