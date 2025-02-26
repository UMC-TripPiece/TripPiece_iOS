// Copyright © 2024 TripPiece. All rights reserved


import UIKit
import SnapKit

//TODO: - 편집 버튼 추가

class TravelSummaryView: UIView {
    
    // MARK: - UI Components
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.textColor = .white
        return label
    }()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .white
        return label
    }()
    
    private let calendarImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let calendarLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
//    private let editButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("편집", for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 11)
//        button.titleLabel?.textColor = .white
//        
//        // 밑줄 스타일 추가
//        let attributedString = NSAttributedString(
//            string: "편집",
//            attributes: [
//                .underlineStyle: NSUnderlineStyle.single.rawValue,
//                .foregroundColor: UIColor.white
//            ]
//        )
//        button.setAttributedTitle(attributedString, for: .normal)
//        button.addTarget(self, action: #selector(openEditView), for: .touchUpInside)
//        
//        return button
//    }()
    
    private let stackView = UIStackView()
    private let userStack = UIStackView()
    private let calendarStack = UIStackView()
    
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
        stackView.axis = .vertical
        stackView.spacing = 5
        
        userStack.axis = .horizontal
        userStack.spacing = 8
        userStack.addArrangedSubview(imageView)
        userStack.addArrangedSubview(nameLabel)
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
        imageView.layer.cornerRadius = 10
        
        calendarStack.axis = .horizontal
        calendarStack.spacing = 8
        calendarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(18)
        }
        calendarStack.addArrangedSubview(calendarImageView)
        calendarStack.addArrangedSubview(calendarLabel)
        
        stackView.addArrangedSubview(userStack)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(locationLabel)
        stackView.addArrangedSubview(dayLabel)
        stackView.addArrangedSubview(calendarStack)
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Configure Method
    func configure(userImage: String?, userName: String, title: String, city: String, country: String, day: Int, calendarImage: UIImage?, calendarText: String) {
        if let userImage = userImage, let url = URL(string: userImage) {
            imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        } else {
            imageView.image = UIImage(named: "placeholder")
        }
        nameLabel.text = userName
        titleLabel.text = title
        
        let locationText = "\(city), \(country)"
        let attributedString = NSMutableAttributedString(string: locationText)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: locationText.count))
        locationLabel.attributedText = attributedString
        
        dayLabel.text = "오늘은 여행 \(day)일차예요!"
        calendarImageView.image = calendarImage
        calendarLabel.text = calendarText
    }
//    @objc private func openEditView() {
//        guard let parentViewController = self.parentViewController else { return }
//        let editVC = StartLogVC() // EditViewVC를 호출
//        editVC.modalPresentationStyle = .fullScreen
//        parentViewController.present(editVC, animated: true, completion: nil)
//    }
}
