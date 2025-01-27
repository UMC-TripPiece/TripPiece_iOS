// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import SnapKit

class MemoTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
        self.addSubview(mainStackView)
        self.addSubview(underSeparatorView)
        setConstraints()
    }
    
    private func setConstraints() {
        mainStackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(60)
        }
        underSeparatorView.snp.makeConstraints { make in
            make.top.equalTo(mainStackView.snp.bottom).offset(40)
            make.height.equalTo(5)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private lazy var memoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping // 단어 단위로 줄바꿈
        label.text = "이따가 돈키호테 들렸다가... 음... 지금 몹시 피곤모드\n그래도 힘내서 열심히 돌아다녀야지 ~~ 연우는 나와 다르게 체력이 넘쳐난다 어떻게 저럴 수 있지..ㅋㅋㅋㅋ"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = UIColor(named: "Black1")
        return label
    }()
    
    // 날짜 레이블
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "24.08.12 16:02"
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textAlignment = .center
        label.textColor = UIColor(named: "Main3")
        return label
    }()
    
    private lazy var mainStackView: UIStackView = {
        // 스택 뷰에 모든 요소 추가
        let stackView = UIStackView(arrangedSubviews: [
            memoLabel,
            dateLabel
        ])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 25
        return stackView
    }()
    
    private lazy var underSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "BgColor3")
        return view
    }()
    
    func initializeCell(travelsDetailInfo: TravelsDetailInfo) {
        memoLabel.text = travelsDetailInfo.description
        dateLabel.text = CalendarManager.shared.convertISO8601ToDate(iso8601Date: travelsDetailInfo.createdAt)?.toStringYMDHM
    }
}
