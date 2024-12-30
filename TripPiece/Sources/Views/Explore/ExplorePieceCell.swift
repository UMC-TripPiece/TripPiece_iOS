// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import SnapKit
import SDWebImage

class ExplorePieceCell: UIView {
    
    // MARK: - UI Components
    
    private let pieceView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    let pieceImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isHidden = true
        return imageView
    }()
    
    private let pieceMemoView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.clipsToBounds = true
        view.isHidden = true
        return view
    }()
    
    private let sideBar: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let memoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    let profileView = ProfileLabelView()
    
    private let locationIconView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "locationIcon"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(hex: "636363")
        return label
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        addSubview(pieceView)
        pieceView.addSubview(pieceImageView)
        pieceView.addSubview(pieceMemoView)
        pieceMemoView.addSubview(memoLabel)
        pieceView.addSubview(sideBar)
        
        [titleLabel, profileView, locationIconView, locationLabel].forEach {
            sideBar.addSubview($0)
        }
        pieceView.isUserInteractionEnabled = true
    }
    
    private func setupConstraints() {
        pieceView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(90)
        }
        
        pieceImageView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.25)
            make.left.top.bottom.equalToSuperview()
        }
        
        pieceMemoView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.4)
        }
        memoLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        //sideBar & 하위 요소
        sideBar.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview()
        }
        profileView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.equalTo(titleLabel)
            make.height.equalTo(20)
        }
        locationIconView.snp.makeConstraints { make in
            make.centerY.equalTo(profileView)
            make.leading.equalTo(profileView.snp.trailing).offset(16)
            make.width.height.equalTo(15)
        }
        locationLabel.snp.makeConstraints { make in
            make.leading.equalTo(locationIconView.snp.trailing).offset(5)
            make.centerY.equalTo(locationIconView)
        }
    }
    // MARK: - Configuration
    
    func configure(type: String, mediaURL: String, memo: String, location: String, profileImg: String, name: String) {
        locationLabel.text = location
        profileView.configure(profileImg: profileImg, name: name, textColor: .black)
        
        if type == "MEMO" {
            pieceMemoView.isHidden = false
            titleLabel.text = "메모"
            memoLabel.text = memo
            
            titleLabel.snp.remakeConstraints { make in
                make.top.equalTo(pieceView.snp.top).offset(16)
                make.leading.equalTo(pieceMemoView.snp.trailing).offset(16)
            }
            sideBar.snp.remakeConstraints { make in
                make.width.equalToSuperview().multipliedBy(0.6)
            }
        } else if type == "PICTURE" || type == "VIDEO" {
            pieceImageView.isHidden = false
            if type == "PICTURE" {
                titleLabel.text = "사진"
            } else if type == "VIDEO" {
                titleLabel.text = "영상"
            }
            if let imageUrl = URL(string: mediaURL) {
                pieceImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "pieceImagePlaceholder"))
            }
            
            titleLabel.snp.remakeConstraints { make in
                make.top.equalTo(pieceView.snp.top).offset(16)
                make.leading.equalTo(pieceImageView.snp.trailing).offset(16)
            }
            
            sideBar.snp.remakeConstraints { make in
                make.width.equalToSuperview().multipliedBy(0.75)
            }
        } else {
            pieceMemoView.isHidden = true
            pieceImageView.isHidden = true
        }
    }
}
