// Copyright © 2024 TripPiece. All rights reserved


import UIKit

class SearchResultCell: UITableViewCell {
    
    static let identifier = "SearchResultCell"
        
    private let cellLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor(hex: "#747474")
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "arrowIcon")
        return imageView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(cityName: String, countryName: String, countryImage: String) {
        cellLabel.text = "\(countryImage)  \(cityName), \(countryName)"
    }
    
    
    func setUpUI() {
        contentView.addSubview(cellLabel)
        contentView.addSubview(arrowImageView)
        contentView.backgroundColor = UIColor(white: 1, alpha: 0.8)
        backgroundColor = .clear
        
        
        cellLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(5)
            make.height.equalTo(10)
        }
    }
}
