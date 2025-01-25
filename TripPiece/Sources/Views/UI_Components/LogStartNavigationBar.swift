// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import SnapKit

extension Notification.Name {
    static let backButtonTapped = Notification.Name("backButtonTapped")
}
class LogStartNavigationBar: UINavigationBar {
    private let startLogLabel: UILabel = {
        let label = UILabel()
        label.text = "여행 기록 시작하기"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()

    private lazy var iconImageView: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    private func setupViews() {
        addSubview(startLogLabel)
        addSubview(iconImageView)

        startLogLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }

        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(22)
            make.centerY.equalToSuperview()
        }
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var newSize = super.sizeThatFits(size)
        newSize.height = 48
        return newSize
    }

    @objc func back() {
        NotificationCenter.default.post(name: .backButtonTapped, object: nil)
    }
}
