// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import SnapKit
import SDWebImage

class TravelLogCardCell: UIView {
    
    // MARK: - UI Components
    let mainButton: UIButton = {
        let button = UIButton()
        return button
    }()
    private let shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 5
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let isProgressButton: UIButton = {
        let button = UIButton()
        button.setTitle("여행 중", for: .normal)
        button.backgroundColor = UIColor(hex: "FD2D69")
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.isHidden = true
        return button
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let dateIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar")?.withTintColor(Constants.Colors.mint ?? .blue, renderingMode: .alwaysOriginal)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let locationIconView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "locationIcon"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        addSubview(shadowView)
        
        shadowView.addSubview(cardView)
        shadowView.addSubview(mainButton)
        
        [imageView, overlayView].forEach {
            cardView.addSubview($0)
        }
        [titleLabel, isProgressButton, dividerView, dateIconView, dateLabel, locationIconView, subtitleLabel].forEach {
            overlayView.addSubview($0)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        mainButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        shadowView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(280)
            make.height.equalTo(150)
        }
        
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(60)
            make.left.equalToSuperview().offset(12)
        }
        
        isProgressButton.snp.makeConstraints { make in
            make.height.equalTo(15)
            make.left.equalTo(titleLabel.snp.right).offset(12)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.width.greaterThanOrEqualTo(40)
        }
        dividerView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        dateIconView.snp.makeConstraints { make in
            make.top.equalTo(dividerView.snp.bottom).offset(5)
            make.width.height.equalTo(20)
            make.left.equalToSuperview().offset(8)
        }
        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(dateIconView.snp.right).offset(8)
            make.centerY.equalTo(dateIconView.snp.centerY)
        }
        locationIconView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(5)
            make.width.height.equalTo(20)
            make.left.equalToSuperview().offset(8)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(locationIconView.snp.centerY)
            make.left.equalTo(locationIconView.snp.right).offset(8)
        }
    }
    
    // MARK: - Configuration
    func configure(id: Int, imageURL: String, title: String, date: String, subtitle: String, isONGOING: String) {
        mainButton.tag = id
        // 이미지 로드
        if let imageUrl = URL(string: imageURL) {
            imageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder"))
        }
        
        // 텍스트 설정
        titleLabel.text = title
        dateLabel.text = date
        subtitleLabel.text = subtitle
        
        // "여행 중" 상태에 따른 스타일 변경
        if isONGOING == "ONGOING" {
            isProgressButton.isHidden = false
            shadowView.layer.borderColor = Constants.Colors.mainPink?.cgColor
            shadowView.layer.shadowColor = Constants.Colors.mainPink?.cgColor
            shadowView.layer.shadowOpacity = 0.4
            shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
            shadowView.layer.shadowRadius = 5.0
            shadowView.layer.borderWidth = 1.0
        } else {
            shadowView.layer.borderWidth = 0
            shadowView.layer.shadowColor = UIColor.black.cgColor
        }
    }
}
