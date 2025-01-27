// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import SnapKit

class WhereTableViewCell: UITableViewCell {
    
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
        topEmojiView.snp.makeConstraints { make in
            make.width.equalTo(87.82)
            make.height.equalTo(87.5)
        }
        separatorView.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(2)
        }
        videoView.snp.makeConstraints { make in
            make.width.equalTo(348)
            make.height.equalTo(162)
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
        imageView.image = UIImage(named: "dum2")
        return imageView
    }()
    
    // 제목
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "여행의 순간을 영상으로!"
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
    
    // 이미지 뷰
    private lazy var videoView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "puzzleImage4")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // 설명 텍스트
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "스키야키 보글보글...🤤"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = UIColor(named: "Black1")
        label.numberOfLines = 0
        return label
    }()
    
    // 날짜 레이블
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "24.08.12 19:12"
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textAlignment = .center
        label.textColor = UIColor(named: "Main3")
        return label
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            topEmojiView,
            titleLabel,
            separatorView,
            videoView,
            descriptionLabel,
            dateLabel
        ])
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var underSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "BgColor3")
        return view
    }()
    
    func initializeCell(travelsDetailInfo: TravelsDetailInfo) {
        guard let mediaUrl = travelsDetailInfo.mediaUrls?.first, let url = URL(string: mediaUrl) else { return }
        videoView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder")) { [weak self] (image, error, cacheType, imageURL) in
            self?.videoView.image = image
        }
        descriptionLabel.text = travelsDetailInfo.description
        dateLabel.text = CalendarManager.shared.convertISO8601ToDate(iso8601Date: travelsDetailInfo.createdAt)?.toStringYMDHM
    }
}
