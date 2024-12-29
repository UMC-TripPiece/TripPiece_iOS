// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import SnapKit
import SDWebImage

class ExploreTravelLogCell: UIView {
    
    // MARK: - UI Components
    let profileView = ProfileLabelView()

    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
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
    
    private let locationLabel: UILabel = {
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
        addSubview(cardView)
        
        [imageView, overlayView].forEach {
            cardView.addSubview($0)
        }
        [profileView, titleLabel, dividerView, dateIconView, dateLabel, locationIconView, locationLabel].forEach {
            overlayView.addSubview($0)
        }
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(200)
        }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        profileView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(60)
            make.left.equalToSuperview().offset(12)
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
        locationLabel.snp.makeConstraints { make in
            make.centerY.equalTo(locationIconView.snp.centerY)
            make.left.equalTo(locationIconView.snp.right).offset(8)
        }
    }
    
    // MARK: - Configuration
    func configure(imageURL: String, title: String, date: String, location: String, profileImg: String, name: String) {
        // 이미지 로드
        if let imageUrl = URL(string: imageURL) {
            imageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder"))
        }
        
        // 텍스트 설정
        titleLabel.text = title
        dateLabel.text = date
        locationLabel.text = location
        
        profileView.configure(profileImg: profileImg, name: name, textColor: .white)
    }
}
