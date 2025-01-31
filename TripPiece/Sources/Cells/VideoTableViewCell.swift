// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import SnapKit

class VideoTableViewCell: UITableViewCell {
    
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
        videoImageView.snp.makeConstraints { make in
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
    
    private lazy var videoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "puzzleImage3")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // 설명 텍스트
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "길가다가 찍어본 스티커사진"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = UIColor(named: "Black1")
        label.numberOfLines = 0
        return label
    }()
    
    // 날짜 레이블
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "24.08.12 15:48"
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textAlignment = .center
        label.textColor = UIColor(named: "Main3")
        return label
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            videoImageView,
            descriptionLabel,
            dateLabel
        ])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 15
        return stackView
    }()
    
    private lazy var underSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "BgColor3")
        return view
    }()
    
    func initializeCell(travelsDetailInfo: TravelsDetailInfo) {
        descriptionLabel.text = travelsDetailInfo.description
        dateLabel.text = CalendarManager.shared.convertISO8601ToDate(iso8601Date: "\(travelsDetailInfo.createdAt)Z")?.toStringYMDHM
        guard let mediaUrl = travelsDetailInfo.mediaUrls?.first, let url = URL(string: mediaUrl) else { return }
        videoImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder")) { [weak self] (image, error, cacheType, imageURL) in
            self?.videoImageView.image = image
        }
    }
}
