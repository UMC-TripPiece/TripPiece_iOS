// Copyright © 2024 TripPiece. All rights reserved

import UIKit

class EndTripButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        setTitle("여행 종료", for: .normal)
        setTitleColor(.systemPink, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        backgroundColor = UIColor.systemPink.withAlphaComponent(0.1)
        layer.cornerRadius = 5

        snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
}
