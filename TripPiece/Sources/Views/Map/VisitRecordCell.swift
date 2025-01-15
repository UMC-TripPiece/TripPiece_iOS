// Copyright © 2024 TripPiece. All rights reserved


import UIKit

class VisitRecordCell: UITableViewCell {
    
    static let identifier = "VisitRecordCell"
    
    var buttonAction: (([String: String]) -> Void)?

    var cityData: [String: String]? // 전달할 데이터
    
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
            button.setImage(UIImage(named: "editButton"), for: .normal)  // 버튼 모양을 이미지로 설정
            return button
    }()
    
    
    var editOptionsView: EditOptionsView?
    
    
    let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = .white
        // 그림자 설정
        view.layer.shadowColor = UIColor.black.cgColor  // 그림자 색상
        view.layer.shadowOpacity = 0.1                 // 그림자 불투명도 (0.0 - 1.0)
        view.layer.shadowOffset = CGSize(width: 0, height: 0) // 그림자 오프셋 (x, y)
        view.layer.shadowRadius = 5                     // 그림자 블러 반경
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell() {
        // 컨테이너 뷰 설정
        contentView.addSubview(containerView)
        contentView.backgroundColor = UIColor(hex: "#F7F7F7")
        
        // 국기 이미지 뷰 설정
        containerView.addSubview(puzzleImageView)
        containerView.addSubview(countryLabel)
        containerView.addSubview(editCountryLogButton)
        editCountryLogButton.addTarget(self, action: #selector(showOptions), for: .touchUpInside)

        // 오토레이아웃 설정
        contentView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top).offset(-30)
            make.bottom.equalTo(containerView.snp.bottom).offset(5)
        }
        containerView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.892307692)
            make.height.equalTo(68)
            make.centerX.equalToSuperview()
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
            puzzleImageView.image = UIImage(named: "Puzzle1")
        case "YELLOW":
            puzzleImageView.image = UIImage(named: "Puzzle2")
        case "CYAN":
            puzzleImageView.image = UIImage(named: "Puzzle3")
        case "RED":
            puzzleImageView.image = UIImage(named: "Puzzle4")
        default:
            puzzleImageView.image = nil // 기본값으로 이미지를 제거하거나 원하는 다른 이미지를 설정
            }
        
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
        if let cityData = cityData {
            buttonAction?(cityData)
        }
    }

        @objc private func deleteLogAction() {
            // 삭제하기 액션 처리
            print("기록 삭제 선택됨")
        }
}




// 기록 수정 버튼 custom
class EditOptionsView: UIView {

    let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("수정하기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.setImage(UIImage(named: "editPencil"), for: .normal)  // 펜슬 아이콘
        button.tintColor = Constants.Colors.bg2
        button.setTitleColor(Constants.Colors.bg2, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        // 제약 조건 설정
        guard let imageView = button.imageView else { return button }
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(28)
            make.centerY.equalToSuperview().offset(2)
            make.leading.equalToSuperview().offset(5)
        }
        return button
    }()

    let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("기록 삭제", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.setImage(UIImage(named: "deleteBin"), for: .normal)  // 휴지통 아이콘
        button.tintColor = Constants.Colors.mainPink
        button.setTitleColor(Constants.Colors.mainPink, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        // 제약 조건 설정
        guard let imageView = button.imageView else { return button }
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview().offset(-22)
            make.leading.equalToSuperview().offset(5)
        }
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 5
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 5

        addSubview(editButton)
        addSubview(deleteButton)

        // Auto Layout 설정
        editButton.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(36.5)
        }
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(editButton.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }

    }
}
