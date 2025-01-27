// Copyright © 2024 TripPiece. All rights reserved

import UIKit

class PuzzleTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
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
        self.addSubview(placeLabel)
        self.addSubview(puzzleBackgroundView)
        self.addSubview(separatorView)
        puzzleBackgroundView.addSubview(puzzleImage1)
        puzzleBackgroundView.addSubview(puzzleImage2)
        puzzleBackgroundView.addSubview(puzzleImage3)
        puzzleBackgroundView.addSubview(puzzleImage4)
        puzzleBackgroundView.addSubview(puzzleImage5)
        puzzleBackgroundView.addSubview(puzzleImage6)
        puzzleBackgroundView.addSubview(puzzleImage7)
        puzzleBackgroundView.addSubview(puzzleImage8)
        puzzleBackgroundView.addSubview(puzzleImage9)
        setConstraints()
    }
    
    private func setConstraints() {
        placeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(30)
            make.centerX.equalToSuperview()
        }
        puzzleBackgroundView.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(placeLabel.snp.bottom).offset(15)
            make.width.height.equalTo(348)
        }
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(puzzleBackgroundView.snp.bottom).offset(40)
            make.height.equalTo(5)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        puzzleImage1.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        puzzleImage2.snp.makeConstraints { make in
            make.centerY.equalTo(puzzleImage1.snp.centerY)
            make.leading.equalTo(puzzleImage1.snp.trailing).offset(-23.5)
        }
        
        puzzleImage3.snp.makeConstraints { make in
            make.centerY.equalTo(puzzleImage1.snp.centerY)
            make.trailing.equalToSuperview()
        }
        
        puzzleImage4.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(puzzleImage1.snp.bottom).offset(-23)
        }
            
        puzzleImage5.snp.makeConstraints { make in
            make.centerX.equalTo(puzzleImage2.snp.centerX)
            make.centerY.equalTo(puzzleImage4.snp.centerY)
        }
            
        puzzleImage6.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(puzzleImage4.snp.centerY)
        }
            
        puzzleImage7.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalTo(puzzleImage9.snp.centerY)
        }
            
        puzzleImage8.snp.makeConstraints { make in
            make.leading.equalTo(puzzleImage7.snp.trailing).offset(-23.5)
            make.centerY.equalTo(puzzleImage9.snp.centerY)
        }
            
        puzzleImage9.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private lazy var placeLabel: UILabel = {
        let label = UILabel()
        label.text = "🇯🇵 도쿄, 일본"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private lazy var puzzleBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var puzzleImage1: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "puzzlePiece1")!.withTintColor([Constants.Colors.mainPurple, Constants.Colors.mainPink, Constants.Colors.mainYellow, Constants.Colors.mint].randomElement()!!, renderingMode: .automatic)
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(139.57)
            make.height.equalTo(114.78)
        }
        
        return imageView
    }()
    
    private lazy var puzzleImage2: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "puzzlePiece2")!.withTintColor([Constants.Colors.mainPurple, Constants.Colors.mainPink, Constants.Colors.mainYellow, Constants.Colors.mint].randomElement()!!, renderingMode: .automatic)
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(139.57)
            make.height.equalTo(114.78)
        }
        
        return imageView
    }()

    private lazy var puzzleImage3: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "puzzlePiece3")!.withTintColor([Constants.Colors.mainPurple, Constants.Colors.mainPink, Constants.Colors.mainYellow, Constants.Colors.mint].randomElement()!!, renderingMode: .automatic)
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(114.78)
            make.height.equalTo(114.78)
        }
        
        return imageView
    }()

    private lazy var puzzleImage4: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "puzzlePiece4")!.withTintColor([Constants.Colors.mainPurple, Constants.Colors.mainPink, Constants.Colors.mainYellow, Constants.Colors.mint].randomElement()!!, renderingMode: .automatic)
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(139.57)
            make.height.equalTo(139.57)
        }
        
        return imageView
    }()
    
    private lazy var puzzleImage5: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "puzzlePiece5")!.withTintColor([Constants.Colors.mainPurple, Constants.Colors.mainPink, Constants.Colors.mainYellow, Constants.Colors.mint].randomElement()!!, renderingMode: .automatic)
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(139.57)
            make.height.equalTo(139.57)
        }
        
        return imageView
    }()


    private lazy var puzzleImage6: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "puzzlePiece6")!.withTintColor([Constants.Colors.mainPurple, Constants.Colors.mainPink, Constants.Colors.mainYellow, Constants.Colors.mint].randomElement()!!, renderingMode: .automatic)
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(114.78)
            make.height.equalTo(139.57)
        }
        
        return imageView
    }()


    private lazy var puzzleImage7: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "puzzlePiece7")!.withTintColor([Constants.Colors.mainPurple, Constants.Colors.mainPink, Constants.Colors.mainYellow, Constants.Colors.mint].randomElement()!!, renderingMode: .automatic)
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(139.57)
            make.height.equalTo(139.57)
        }
        
        return imageView
    }()

    private lazy var puzzleImage8: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "puzzlePiece8")!.withTintColor([Constants.Colors.mainPurple, Constants.Colors.mainPink, Constants.Colors.mainYellow, Constants.Colors.mint].randomElement()!!, renderingMode: .automatic)
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(139.57)
            make.height.equalTo(139.57)
        }
        
        return imageView
    }()
    
    private lazy var puzzleImage9: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "puzzlePiece9")!.withTintColor([Constants.Colors.mainPurple, Constants.Colors.mainPink, Constants.Colors.mainYellow, Constants.Colors.mint].randomElement()!!, renderingMode: .automatic)
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(114.78)
            make.height.equalTo(139.57)
        }
        
        return imageView
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "BgColor3")
        return view
    }()
    
    func initializeCell(thumbnails: [UIImage?], place: String) {
        let imageViews: [UIImageView] = [
            puzzleImage1,
            puzzleImage2,
            puzzleImage3,
            puzzleImage4,
            puzzleImage5,
            puzzleImage6,
            puzzleImage7,
            puzzleImage8,
            puzzleImage9,
        ]
        for i in 0..<9 {
            if let thumbnail = thumbnails[i] {
                imageViews[i].image = thumbnail
            } else {
                imageViews[i].image = UIImage(named: "puzzlePiece\(i+1)")!.withTintColor([Constants.Colors.mainPurple, Constants.Colors.mainPink, Constants.Colors.mainYellow, Constants.Colors.mint].randomElement()!!, renderingMode: .automatic)
            }
        }
        placeLabel.text = place
    }
}
