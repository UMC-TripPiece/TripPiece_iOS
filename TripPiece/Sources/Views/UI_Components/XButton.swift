// Copyright © 2024 TripPiece. All rights reserved


import UIKit
import SnapKit

class XButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .regular)
        let image = UIImage(systemName: "xmark", withConfiguration: config)
        setImage(image, for: .normal)
        tintColor = .white
    }
}
