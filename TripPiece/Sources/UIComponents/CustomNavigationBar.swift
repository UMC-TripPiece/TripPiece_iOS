// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import UIKit

public class NavigationBarManager {
    
    public init() {
        }
    
    // MARK: - 왼쪽 커스텀 백버튼 생성
    public func addBackButton(to navigationItem: UINavigationItem, target: Any?, action: Selector) {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = Constants.Colors.black3!
        backButton.addTarget(target, action: action, for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    // MARK: - 오른쪽 커스텀 버튼 생성
    public func addRightButton(
        to navigationItem: UINavigationItem,
        title: String? = nil,
        icon: String? = nil,
        target: Any?,
        action: Selector,
        tintColor: UIColor = .label,
        font: UIFont = .systemFont(ofSize: 16, weight: .medium)
    ) {
        let rightButton = UIButton(type: .system)
        
        if let title = title {
            // 텍스트 버튼
            rightButton.setTitle(title, for: .normal)
            rightButton.setTitleColor(tintColor, for: .normal)
            rightButton.titleLabel?.font = font
        } else if let icon = icon {
            // 이미지 버튼
            rightButton.setImage(UIImage(systemName: icon), for: .normal)
            rightButton.tintColor = tintColor
        }
        
        rightButton.addTarget(target, action: action, for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    
    // MARK: - 네비게이션 타이틀 설정
    public func setTitle(to navigationItem: UINavigationItem, title: String, textColor: UIColor = .label, font: UIFont = .systemFont(ofSize: 20, weight: .semibold)) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = font
        titleLabel.textColor = textColor
        titleLabel.textAlignment = .center
        navigationItem.titleView = titleLabel
    }
    
    public func setNReturnTitle(
        to navigationItem: UINavigationItem,
        title: String,
        textColor: UIColor = .label,
        font: UIFont = .systemFont(ofSize: 18, weight: .bold)
    ) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = font
        titleLabel.textColor = textColor
        titleLabel.textAlignment = .center
        navigationItem.titleView = titleLabel
        return titleLabel  // UILabel(smallTitle) 반환
    }
    
    public func addLeftRightButtons(
        to navigationItem: UINavigationItem,
        leftIcon: String,
        leftAction: Selector,
        rightIcon: String,
        rightAction: Selector,
        target: Any?,
        tintColor: UIColor = .label
    ) {
        // 왼쪽 버튼 생성
        let leftButton = UIButton(type: .system)
        leftButton.setImage(UIImage(systemName: leftIcon), for: .normal)
        leftButton.tintColor = tintColor
        leftButton.addTarget(target, action: leftAction, for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        
        // 오른쪽 버튼 생성
        let rightButton = UIButton(type: .system)
        rightButton.setImage(UIImage(systemName: rightIcon), for: .normal)
        rightButton.tintColor = tintColor
        rightButton.addTarget(target, action: rightAction, for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
}
