//
//  GradientNavigationBar.swift
//  MyWorldApp
//
//  Created by 김나연 on 8/12/24.
//

import UIKit
import SnapKit

class GradientNavigationBar: UIView {

    // 퍼즐 이미지
    private lazy var puzzleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "puzzle icon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // 텍스트 레이블
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white
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
        // 그라데이션 배경 추가
        applyGradient()

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

    // 그라데이션 적용 함수
    private func applyGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(named: "gra1")?.cgColor ?? UIColor.clear.cgColor,
            UIColor(named: "gra2")?.cgColor ?? UIColor.clear.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // 그라데이션 레이어의 프레임을 다시 설정
        layer.sublayers?.first?.frame = bounds
    }
}
