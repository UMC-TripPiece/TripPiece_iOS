// Copyright © 2024 TripPiece. All rights reserved

import Foundation
import UIKit
import SnapKit

class PieceSortButton: UIButton {
    init(title: String, tag: Int, target: Any?, action: Selector) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setTitleColor(.black, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        self.backgroundColor = Constants.Colors.white
        self.layer.cornerRadius = 15
        self.tag = tag

        self.layer.borderColor = Constants.Colors.white?.cgColor
        self.layer.borderWidth = 1.0  // 원하는 테두리 두께로 설정

        self.clipsToBounds = false
        self.layer.masksToBounds = false
        
        self.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(20)
        }
        
        self.addTarget(target, action: action, for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateSelection(isSelected: Bool) {
        if isSelected {
            self.backgroundColor = Constants.Colors.mainPurple?.withAlphaComponent(0.1)
            self.layer.borderColor = Constants.Colors.mainPurple?.cgColor
            self.setTitleColor(Constants.Colors.mainPurple, for: .normal)
        } else {
            self.backgroundColor = Constants.Colors.white
            self.layer.borderColor = Constants.Colors.white?.cgColor  // 기본 테두리 색상
            self.setTitleColor(.black, for: .normal)
        }
    }
}
