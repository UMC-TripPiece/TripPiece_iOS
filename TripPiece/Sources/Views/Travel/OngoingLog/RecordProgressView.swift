// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import SnapKit

class RecordProgressView: UIView {
    private var progressLabels: [UILabel] = []
    private var progressIcons: [UIImageView] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 14

        let colors: [UIColor] = [Constants.Colors.mainPurple ?? .purple, Constants.Colors.mainYellow ?? .yellow, .systemCyan, Constants.Colors.mainPink ?? .systemPink]
        let icons = ["puzzlepiece.extension.fill", "puzzlepiece.extension.fill", "puzzlepiece.extension.fill", "puzzlepiece.extension.fill"]

        for i in 0..<4 {
            let container = UIStackView()
            container.axis = .horizontal
            container.spacing = 9
            container.alignment = .center

            let icon = UIImageView()
            icon.image = UIImage(systemName: icons[i])?.withRenderingMode(.alwaysTemplate)
            icon.tintColor = colors[i]
            icon.contentMode = .scaleAspectFit
            icon.snp.makeConstraints { make in
                make.width.height.equalTo(20)
            }

            let label = UILabel()
            label.text = "0"
            label.textAlignment = .center
            label.textColor = .black
            label.font = UIFont.boldSystemFont(ofSize: 18)

            let subLabel = UILabel()
            subLabel.text = "개"
            subLabel.textAlignment = .center
            subLabel.textColor = .black
            subLabel.font = UIFont.systemFont(ofSize: 12)

            container.addArrangedSubview(icon)
            container.addArrangedSubview(label)
            container.addArrangedSubview(subLabel)

            progressIcons.append(icon)
            progressLabels.append(label)

            stackView.addArrangedSubview(container)
        }

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }

        backgroundColor = .white
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 4
    }

    func configure(pictureCount: Int, videoCount: Int, memoCount: Int) {
        let counts = [pictureCount, videoCount, 0, memoCount] // 3번째 칸은 0개로 고정
        for (index, count) in counts.enumerated() {
            progressLabels[index].text = "\(count)"
        }
    }
}
