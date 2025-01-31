// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import SnapKit

class SelfieTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        self.addSubview(mainStackView)
        self.addSubview(underSeparatorView)
        selfieBackGroundView.addSubview(selfieStackView)
        setConstraints()
    }
    
    private func setConstraints() {
        separatorView.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(2)
        }
        
        topEmojiView.snp.makeConstraints { make in
            make.width.equalTo(85.82)
            make.height.equalTo(84.5)
        }
        
//        selfieBackGroundView.snp.makeConstraints { make in
//            make.width.equalTo(294)
//        }
        selfieStackView.snp.makeConstraints { make in
            make.width.equalTo(278)
            make.centerX.equalToSuperview()
            make.top.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(15)
        }
        selfieImageView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(328)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(60)
        }
        underSeparatorView.snp.makeConstraints { make in
            make.top.equalTo(mainStackView.snp.bottom).offset(40)
            make.height.equalTo(5)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // 상단 이모지
    private lazy var topEmojiView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "selfieEmoji")
        return imageView
    }()
    
    // 제목
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "제 셀카에요~!"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    // 구분선
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "Black3")
        return view
    }()
    
    // 폴라로이드 모양 뷰
    private lazy var selfieBackGroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor(named: "Black3")?.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 5
        return view
    }()
    
    private lazy var selfieStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            selfieImageView,
            descriptionLabel,
        ])
        
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 15
        return stackView
    }()
    
    // 이미지 뷰
    private lazy var selfieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "selfieImage")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // 설명 텍스트
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "기차 안에서"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor(named: "Black1")
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            topEmojiView,
            titleLabel,
            separatorView,
            selfieBackGroundView,
        ])
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 25
        return stackView
    }()
    
    private lazy var underSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "BgColor3")
        return view
    }()
    
    func initializeCell(travelsDetailInfo: TravelsDetailInfo) {
        guard let mediaUrl = travelsDetailInfo.mediaUrls?.first, let url = URL(string: mediaUrl) else { return }
        selfieImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder")) { [weak self] (image, error, cacheType, imageURL) in
            self?.selfieImageView.image = image
        }
        descriptionLabel.text = travelsDetailInfo.description
    }
}
