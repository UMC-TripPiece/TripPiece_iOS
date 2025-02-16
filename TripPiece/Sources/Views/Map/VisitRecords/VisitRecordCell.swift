// Copyright © 2024 TripPiece. All rights reserved


import UIKit

class VisitRecordCell: UICollectionViewCell {
    
    static let identifier = "VisitRecordCell"
    weak var delegate: VisitRecordCellDelegate?
    
    var cityData: [String: String]? // 전달할 데이터
    var editOptionsView: EditOptionsView?
    
    private let puzzleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    
    private let editCountryLogButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "editButton")
        button.setImage(image, for: .normal)
        return button
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = .white
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 5
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupCell() {
        // 컨테이너 뷰 설정
        contentView.addSubview(containerView)
        self.backgroundColor = UIColor(hex: "#F9F9F9")
        contentView.backgroundColor = UIColor(hex: "#F9F9F9")
        
        // 국기 이미지 뷰 설정
        containerView.addSubview(puzzleImageView)
        containerView.addSubview(countryLabel)
        containerView.addSubview(editCountryLogButton)
        editCountryLogButton.addTarget(self, action: #selector(showOptions), for: .touchUpInside)

        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.lessThanOrEqualTo(68)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(25)
        }
        puzzleImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(35.75)
        }
        countryLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(puzzleImageView.snp.trailing).offset(16.25)
        }
        editCountryLogButton.snp.makeConstraints { make in
            make.width.height.equalTo(14)
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
    }


    func configure(countryName: String, flagEmoji: String, puzzleColor: String) {
        setupCell()
        countryLabel.text = "\(flagEmoji) \(countryName)"
        
        // 퍼즐 컬러에 따라 이미지를 다르게 설정
        switch puzzleColor {
        case "BLUE":
            puzzleImageView.image = createPuzzle(color: "6744FF")
        case "YELLOW":
            puzzleImageView.image = createPuzzle(color: "FFB40F")
        case "CYAN":
            puzzleImageView.image = createPuzzle(color: "25CEC1")
        case "RED":
            puzzleImageView.image = createPuzzle(color: "FD2D69")
        default:
            puzzleImageView.image = createPuzzle(color: puzzleColor)
        }
        
    }
    
    // 공통된 UIButton 생성 함수
    public func createPuzzle(color: String) -> UIImage {
        // 이미지를 리사이즈하고 설정
        guard let baseImage = UIImage(named: "puzzle_purple") else { return UIImage() }
        guard let coloredImage = baseImage.tinted(with: UIColor(hex: color) ?? UIColor.black) else { return UIImage() }
        return coloredImage
    }
    
    
    @objc private func showOptions() {
        guard let superview = self.superview else { return }
            
        // 메뉴 뷰 생성 및 추가
        if let editOptionsView = editOptionsView {
            editOptionsView.removeFromSuperview() // 기존 메뉴 제거
            self.editOptionsView = nil
            return
        }
            
        let editOptionsView = EditOptionsView(frame: CGRect(x: 0, y: 0, width: 150, height: 100))
        self.editOptionsView = editOptionsView
        superview.addSubview(editOptionsView)
        
        editOptionsView.snp.makeConstraints { make in
            make.width.equalTo(115)
            make.height.equalTo(73)
            make.top.equalTo(editCountryLogButton.snp.bottom).offset(8)
            make.trailing.equalTo(editCountryLogButton.snp.trailing)
        }

        // 메뉴 버튼 액션 설정
        editOptionsView.editButton.addTarget(self, action: #selector(editLogAction), for: .touchUpInside)
        editOptionsView.deleteButton.addTarget(self, action: #selector(deleteLogAction), for: .touchUpInside)
    }
    
    
    @objc private func editLogAction() {
        // 수정하기 액션 처리
        guard let collectionView = self.superview as? UICollectionView,
              let indexPath = collectionView.indexPath(for: self) else { return }
        delegate?.didTapEditButton(at: indexPath)
    }

    @objc private func deleteLogAction() {
        // 삭제하기 액션 처리
        guard let collectionView = self.superview as? UICollectionView,
              let indexPath = collectionView.indexPath(for: self) else { return }
        delegate?.didTapDeleteButton(at: indexPath)
    }
    
    
    
}



protocol VisitRecordCellDelegate: AnyObject {
    func didTapEditButton(at indexPath: IndexPath)
    func didTapDeleteButton(at indexPath: IndexPath)
}
