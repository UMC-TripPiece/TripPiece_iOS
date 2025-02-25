// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import SnapKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.layer.borderColor = UIColor(resource: .main).cgColor
        return imageView
    }()
    
    private func setupUI() {
        self.addSubview(mainImageView)
        setConstraints()
    }
    
    private func setConstraints() {
        mainImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.height.equalTo(115)
        }
    }
    
    func setSelected(_ selected: Bool) {
        mainImageView.layer.borderWidth = selected ? 2 : 0
    }
}
