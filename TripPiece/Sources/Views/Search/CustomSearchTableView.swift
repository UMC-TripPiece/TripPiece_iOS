// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import SnapKit

class CustomSearchTableView: UITableView {
    public var heightConstraint: CGFloat = 0.0 {
        didSet {
            updateHeightConstraint() // 값이 변경될 때 제약 업데이트
        }
    }
    
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupUI()
        register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.identifier)
    }
    
    private func setupUI() {
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.backgroundColor = .clear
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 15
    }
    
    
    // 검색 결과 수에 따라 테이블 뷰 높이를 업데이트
    public func calculateHeight(rowCount: Int) {
        let rowHeight: CGFloat = 48.0 // 각 행의 높이
        let maxVisibleRows = 7 // 표시할 최대 행 수
        let visibleRows = min(rowCount, maxVisibleRows)
        heightConstraint = (CGFloat(visibleRows) * rowHeight) + 55
        /*UIView.animate(withDuration: 0.3) { // 애니메이션으로 높이 변경
            self.view.layoutIfNeeded()
        }*/
        print("heightConstraint: \(heightConstraint)")
    }
    

        
    // height constraint 업데이트
    private func updateHeightConstraint() {
        self.snp.updateConstraints { make in
            make.height.equalTo(heightConstraint)
        }
        UIView.animate(withDuration: 0.3) {
            self.superview?.layoutIfNeeded()
        }
    }
}

