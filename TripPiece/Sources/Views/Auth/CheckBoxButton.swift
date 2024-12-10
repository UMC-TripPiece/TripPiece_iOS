// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import SnapKit

class CheckBoxButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        self.setImage(UIImage(systemName: "checkmark.square.fill")?.withTintColor(Constants.Colors.mainPurple ?? .blue, renderingMode: .alwaysOriginal), for: .selected)
        self.setImage(UIImage(systemName: "square")?.withTintColor(UIColor(hex: "#D8D8D8") ?? .gray, renderingMode: .alwaysOriginal), for: .normal)
        self.setTitle(title, for: .normal)
        self.setTitleColor(.black, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        self.imageView?.translatesAutoresizingMaskIntoConstraints = false
                self.titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        if let imageView = self.imageView, let titleLabel = self.titleLabel {
            imageView.snp.makeConstraints { make in
                            make.leading.equalToSuperview()
                            make.centerY.equalToSuperview()
                            make.width.equalTo(20)
                            make.height.equalTo(20)
                        }
                        titleLabel.snp.makeConstraints { make in
                            make.leading.equalTo(imageView.snp.trailing).offset(10)
                            make.trailing.equalToSuperview()
                            make.centerY.equalToSuperview()
                        }
        }
        self.contentHorizontalAlignment = .left
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
