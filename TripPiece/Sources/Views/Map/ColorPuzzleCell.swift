// Copyright © 2024 TripPiece. All rights reserved

import UIKit

class ColorPuzzleCell: UICollectionViewCell {
    
    static let identifier = "ColorPuzzleCell"
    
    // 퍼즐 버튼을 담는 컨테이너 뷰
    private let buttonContainerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(buttonContainerView)
        
        buttonContainerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(60)
        }
    }
            
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// ViewController에서 만든 버튼을 셀에 추가
    func configure(with button: UIButton) {
        // 이전 버튼을 모두 제거하고 새 버튼 추가
        buttonContainerView.subviews.forEach { $0.removeFromSuperview() }
        // 새 버튼 추가
        buttonContainerView.addSubview(button)
            
        // 버튼의 레이아웃 설정
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    /// 셀이 재사용될 때 호출되는 메서드 (상태 초기화)
    override func prepareForReuse() {
        super.prepareForReuse()
            
        // 컨테이너 뷰 안에 있는 모든 버튼 제거
        buttonContainerView.subviews.forEach { $0.removeFromSuperview() }
    }
    
    
}
