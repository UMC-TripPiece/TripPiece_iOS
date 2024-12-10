// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import SnapKit

//class PaddedTextField: UITextField {
//    var padding: UIEdgeInsets
//
//    init(padding: UIEdgeInsets) {
//        self.padding = padding
//        super.init(frame: .zero)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    // 텍스트 영역의 위치를 조정
//    override func textRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.inset(by: padding)
//    }
//
//    // 편집 시 텍스트 영역의 위치를 조정
//    override func editingRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.inset(by: padding)
//    }
//
//    // 플레이스홀더 텍스트 영역의 위치를 조정
//    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.inset(by: padding)
//    }
//}

class PaddedTextField: UITextField {
    
    var padding: UIEdgeInsets
    
    init(padding: UIEdgeInsets) {
        self.padding = padding
        super.init(frame: .zero)
        setupDefaultStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    private func setupDefaultStyle() {
        self.borderStyle = .none
        self.layer.borderColor = UIColor(hex: "#D8D8D8")?.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowRadius = 5.0
        self.backgroundColor = UIColor(hex: "#FFFFFF")
    }
    
    func setPlaceholder(_ placeholder: String, color: UIColor = .lightGray) {
            self.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [NSAttributedString.Key.foregroundColor: color]
            )
        }
}
