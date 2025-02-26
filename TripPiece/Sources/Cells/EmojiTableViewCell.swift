// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import SnapKit

class EmojiTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
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
        mainStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(60)
        }
        topEmojiView.snp.makeConstraints { make in
            make.width.equalTo(87.82)
            make.height.equalTo(87.5)
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
        imageView.image = UIImage(resource: .dum4)
        return imageView
    }()
    
    // 제목
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "이땐 이랬어요 :)"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    // 구분선
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "Black3")
        view.heightAnchor.constraint(equalToConstant: 2).isActive = true
        view.widthAnchor.constraint(equalToConstant: 20).isActive = true
        return view
    }()
    
    // 중간 이모지들
    private lazy var middleEmojisLabel: UILabel = {
        let label = UILabel()
        label.text = "😴😔🗿😷"
        label.font = UIFont.systemFont(ofSize: 28)
        label.textAlignment = .center
        return label
    }()
    
    // 설명 텍스트
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "공항에서 방금 내렸는데\n 사람이 너무 많아서 힘든 상태다... \n아!! 빨리 정신 차려야하는데~~"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = UIColor(named: "Black1")
        label.numberOfLines = 0
        return label
    }()
    
    // 날짜 레이블
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "24.08.12 13:07"
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textAlignment = .center
        label.textColor = UIColor(named: "Main3")
        return label
    }()
    
    // 스택 뷰에 모든 요소 추가
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            topEmojiView,
            titleLabel,
            separatorView,
            middleEmojisLabel,
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
        descriptionLabel.text = travelsDetailInfo.description
        dateLabel.text = CalendarManager.shared.convertISO8601ToDate(iso8601Date: "\(travelsDetailInfo.createdAt)Z")?.toStringYMDHM
        middleEmojisLabel.text = travelsDetailInfo.mediaUrls?.joined(separator: "")
    }
    func initializeCell(tripPieceInfo: TripPieceInfo) {
        descriptionLabel.text = tripPieceInfo.memo
        dateLabel.text = CalendarManager.shared.convertISO8601ToDate(iso8601Date: "\(tripPieceInfo.createdAt)Z")?.toStringYMDHM
        middleEmojisLabel.text = tripPieceInfo.mediaUrl
    }
}
