// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import SnapKit

class SolidWhiteBar: UIView {

    // 퍼즐 이미지
    private lazy var puzzleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "puzzle_purple")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // 텍스트 레이블
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = Constants.Colors.mainPurple
        return label
    }()

    // 생성자
    init(title: String) {
        super.init(frame: .zero)
        self.titleLabel.text = title
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // UI 설정
    private func setupUI() {
        self.backgroundColor = .white
        // 서브뷰 추가
        addSubview(puzzleImageView)
        addSubview(titleLabel)

        puzzleImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(21)
            make.top.equalToSuperview().offset(68)
            make.height.width.lessThanOrEqualTo(20)
        }
        titleLabel.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(51)
            make.top.equalToSuperview().offset(66)
        }
        
    }

}
