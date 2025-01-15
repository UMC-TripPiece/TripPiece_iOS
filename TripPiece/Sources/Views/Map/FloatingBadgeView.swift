// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import SDWebImage


class FloatingBadgeView: UIView {
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10 // 이미지 뷰의 너비/높이의 절반으로 설정
        imageView.clipsToBounds = true // 이미지를 레이어의 경계에 맞춰 자르기
        return imageView
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    private let userProfileStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal // 수평 방향 스택 뷰
        stackView.alignment = .center // 중앙 정렬
        stackView.spacing = 5 // 간격 설정
        return stackView
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    private let globeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "worldPuzzleImage")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    
    // MARK: - Setup Methods
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 15
        layer.borderWidth = 1
        layer.borderColor = Constants.Colors.mainPurple?.cgColor
        
        addSubview(userProfileStackView)
        userProfileStackView.addArrangedSubview(profileImageView)
        userProfileStackView.addArrangedSubview(userNameLabel)
        addSubview(subtitleLabel)
        addSubview(globeImageView)
        
        setUpConstraints()
    }
    
    
    func setUpConstraints() {
        userProfileStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(15)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(userProfileStackView.snp.leading)
            make.bottom.equalToSuperview().inset(20)
            make.trailing.equalTo(globeImageView.snp.leading).offset(-15)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.centerY.equalTo(userNameLabel.snp.centerY)
            make.height.width.equalTo(20)
        }
        
        globeImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-25)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(85)
        }
    }
    
    // 유저 이름 업데이트
    func updateProfile(with nickname: String) {
        userNameLabel.text = "\(nickname) 님"
    }
    
    // 프로필 이미지를 업데이트
    func updateProfileImage(with urlString: URL) {
        profileImageView.sd_setImage(with: urlString, placeholderImage: UIImage(named: "profilePlaceholder"))
    }
    
    // label 글자 업데이트
    func updateSubtitleLabel(countryNum: Int, cityNum: Int) {
        let fullText = "현재까지 \(countryNum)개의 나라의\n\(cityNum)개의 도시를 방문했어요"
        let attributedString = NSMutableAttributedString(string: fullText)
            
        let countryRange = (fullText as NSString).range(of: "\(countryNum)개의 나라")
        let cityRange = (fullText as NSString).range(of: "\(cityNum)개의 도시")
            
        attributedString.addAttribute(.foregroundColor, value: Constants.Colors.mainPurple ?? UIColor.blue, range: countryRange)
        attributedString.addAttribute(.foregroundColor, value: Constants.Colors.mainPurple ?? UIColor.blue, range: cityRange)
            
        subtitleLabel.attributedText = attributedString
    }
    
}

