// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import SnapKit

class Picture2TableViewCell: UITableViewCell {
    
    
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
        setConstraints()
    }
    
    private func setConstraints() {
        separatorView.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(2)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(60)
        }
        
        imagesStackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(150)
        }
        
        topEmojiView.snp.makeConstraints { make in
            make.width.equalTo(85.82)
            make.height.equalTo(84.5)
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
        imageView.image = UIImage(named: "ootdEmoji")
        return imageView
    }()
    
    // 제목
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 OOTD !"
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
    
    // 이미지 뷰들
    private lazy var imageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ootdImage1")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var imageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ootdImage2")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // 설명 텍스트
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘을 위해 새로 장만했어 ^~^"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = UIColor(named: "Black1")
        label.numberOfLines = 0
        return label
    }()
    // 날짜 레이블
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "24.08.12 15:13"
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textAlignment = .center
        label.textColor = UIColor(named: "Main3")
        return label
    }()
    
    // 이미지 뷰들을 담을 스택 뷰
    private lazy var imagesStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView1, imageView2])
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            topEmojiView,
            titleLabel,
            separatorView,
            imagesStackView,
            descriptionLabel,
            dateLabel
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
        let imageViews: [UIImageView] = [imageView1, imageView2]
        for i in 0..<2 {
            guard let mediaUrl = travelsDetailInfo.mediaUrls?[i], let url = URL(string: mediaUrl) else { return }
            imageViews[i].sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder")) { [weak self] (image, error, cacheType, imageURL) in
                imageViews[i].image = image
            }
        }
        descriptionLabel.text = travelsDetailInfo.description
        dateLabel.text = CalendarManager.shared.convertISO8601ToDate(iso8601Date: travelsDetailInfo.createdAt)?.toStringYMDHM
    }
}
