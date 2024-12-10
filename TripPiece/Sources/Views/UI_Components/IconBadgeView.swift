// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import SnapKit

class IconBadgeView: UIView {
    
    // MARK: - Initializers
    init(systemName: String, iconSize: CGFloat = 18, backgroundSize: CGFloat = 48) {
        super.init(frame: .zero)
        setupView(systemName: systemName, iconSize: iconSize, backgroundSize: backgroundSize)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Private Methods
    private func setupView(systemName: String, iconSize: CGFloat, backgroundSize: CGFloat) {
        self.backgroundColor = .white
        self.layer.cornerRadius = backgroundSize / 2
        self.clipsToBounds = true
        
        let imageView = UIImageView()
        let configuration = UIImage.SymbolConfiguration(pointSize: iconSize, weight: .medium)
        let icon = UIImage(systemName: systemName, withConfiguration: configuration)?
            .withTintColor(Constants.Colors.bgGray ?? .gray, renderingMode: .alwaysOriginal)
        imageView.image = icon
        
        addSubview(imageView)

        self.snp.makeConstraints { make in
            make.size.equalTo(backgroundSize)
        }
        
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(iconSize)
        }
    }
}
