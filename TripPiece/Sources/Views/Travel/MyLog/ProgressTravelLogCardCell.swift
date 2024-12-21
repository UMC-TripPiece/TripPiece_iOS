// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import SnapKit
import SDWebImage

class ProgressTravelLogCardCell: UIView {
    
    // MARK: - UI Components
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.mainPurple?.withAlphaComponent(0.1)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.layer.borderColor = Constants.Colors.mainPurple?.cgColor
//        view.layer.shadowColor = Constants.Colors.mainPurple?.cgColor
//        view.layer.shadowOpacity = 0.4
//        view.layer.shadowOffset = CGSize(width: 0, height: 0)
//        view.layer.shadowRadius = 5.0
        view.layer.borderWidth = 1.0
        
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = Constants.Colors.black3
        return label
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = Constants.Colors.black
        return label
    }()
    
    private let dayCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = Constants.Colors.mainPurple
        return label
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupTapGesture()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        addSubview(cardView)
        [imageView, dateLabel, titleLabel, dayCountLabel].forEach {
            cardView.addSubview($0)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        let padding = 16
        
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(padding)
            make.centerY.equalTo(cardView)
            make.width.height.equalTo(60)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView).offset(8)
            make.leading.equalTo(imageView.snp.trailing).offset(12)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(4)
            make.leading.equalTo(imageView.snp.trailing).offset(12)
        }
        dayCountLabel.snp.makeConstraints{ make in
            make.centerY.equalTo(imageView)
            make.trailing.equalTo(cardView).inset(padding)
        }
    }
    
    // MARK: - Configuration
    func configure(imageURL: String, title: String, date: String, subtitle: String) {
        // 이미지 로드
        if let imageUrl = URL(string: imageURL) {
            imageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder"))
        }
        
        // 텍스트 설정
        titleLabel.text = title
        dateLabel.text = date
        dayCountLabel.text = subtitle
    }
    // MARK: - Tap Gesture
        private func setupTapGesture() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            cardView.isUserInteractionEnabled = true
            cardView.addGestureRecognizer(tapGesture)
        }
        
        @objc private func handleTap() {
            // OngoingLogVC로 전환
            let viewController = OngoingLogVC()
            viewController.modalPresentationStyle = .fullScreen
            if let topController = UIApplication.shared.keyWindow?.rootViewController {
                topController.present(viewController, animated: true, completion: nil)
            }
        }
}
