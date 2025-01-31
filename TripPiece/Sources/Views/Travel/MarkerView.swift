//
//  MarkerView.swift
//  MyWorldApp
//
//  Created by 김호성 on 2024.12.16.
//

import UIKit
import SnapKit
import SDWebImage

class MarkerView: UIView {

    // MARK: - Lifecycle
    init(frame: CGRect, image: UIImage) {
        super.init(frame: frame)
        self.setupUI()
        imageView.layer.cornerRadius = frame.width / 2
        imageView.image = image
    }
    
    init(frame: CGRect, imageURL: String) {
        super.init(frame: frame)
        self.setupUI()
        if let imageUrl = URL(string: imageURL) {
            imageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder"))
        }
        imageView.layer.cornerRadius = frame.width / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = [Constants.Colors.mainPurple, Constants.Colors.mainPink, Constants.Colors.mainYellow, Constants.Colors.mint].randomElement()??.cgColor
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: - Setup UI
    
    private func setupUI() {
        self.addSubview(imageView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
    }
    
    
}
