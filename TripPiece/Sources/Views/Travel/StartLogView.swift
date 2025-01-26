// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import SnapKit

final class StartLogView: UIView {
    
    // MARK: - UI 프로퍼티
    
    lazy var startNavBar: LogStartNavigationBar = {
        let nav = LogStartNavigationBar()
        nav.backgroundColor = .white
        return nav
    }()
    
    lazy var addCountryButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "plus country"), for: .normal)
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "도시 추가"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    lazy var grayBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "BgColor1") ?? .lightGray
        return view
    }()
    
    // **스크롤뷰** 추가 (핵심)
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    // scrollView 안에 놓을 컨테이너 뷰
    // (스택뷰를 직접 scrollView에 붙여도 되지만,
    //  일반적으로 중간 컨테이너를 두면 제약 잡기가 편해.)
    lazy var contentContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    // 기존에 쓰던 contentStackView
    lazy var contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        return stack
    }()
    
    lazy var travelPeriodLabel: UILabel = {
        let label = UILabel()
        label.text = "여행 기간"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    lazy var startDateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("시작 날짜", for: .normal)
        button.setImage(UIImage(named: "Calendar2"), for: .normal)
        
        button.tintColor = UIColor(named: "Black2") ?? .black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(UIColor(named: "Black2") ?? .black, for: .normal)
        
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        
        return button
    }()
    
    lazy var endDateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("끝난 날짜", for: .normal)
        button.setImage(UIImage(named: "Calendar2"), for: .normal)
        
        button.tintColor = UIColor(named: "Black2") ?? .black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(UIColor(named: "Black2") ?? .black, for: .normal)
        
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        
        return button
    }()
    
    lazy var dateButtonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        return stack
    }()
    
    lazy var startDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .inline
        picker.backgroundColor = .white
        picker.isHidden = true
        return picker
    }()
    
    lazy var endDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .inline
        picker.backgroundColor = .white
        picker.isHidden = true
        return picker
    }()
    
    lazy var travelTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "여행 제목"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    lazy var travelTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.borderWidth = 1
        tv.layer.cornerRadius = 5
        
        tv.text = "| 여행 제목을 입력해주세요 (15자 이내)"
        tv.textColor = .lightGray
        tv.isScrollEnabled = false
        return tv
    }()
    
    lazy var startLogButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("여행 기록 시작하기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        
        button.backgroundColor = UIColor(named: "Cancel") ?? .red
        button.layer.cornerRadius = 5
        button.isEnabled = false
        return button
    }()
    
    // 검색 결과 테이블
    lazy var searchTableView: UITableView = {
        let tv = UITableView()
        tv.isHidden = true
        tv.backgroundColor = .clear
        return tv
    }()
    
    // 커스텀 검색 바
    lazy var searchController: CustomSearchBar = {
        let sb = CustomSearchBar()
        sb.searchBar.placeholder = "검색할 국가를 입력하세요"
        return sb
    }()
    
    lazy var addPhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "plus photo"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.isHidden = true
        button.alpha = 0.0
        return button
    }()
    
    // MARK: - 초기화
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - UI 세팅
    
    private func setupUI() {
        backgroundColor = .white
        
        // 상단 네비, 버튼, 타이틀 등
        addSubview(startNavBar)
        addSubview(addCountryButton)
        addSubview(addPhotoButton)
        addSubview(titleLabel)
        
        // 회색 배경
        addSubview(grayBackgroundView)
        
        // 그 위에 검색 결과 테이블 (최상단)
        addSubview(searchTableView)
        
        // **중요**: grayBackgroundView 안에 scrollView를 넣고,
        //           그 안에 contentContainerView, 그 안에 contentStackView
        grayBackgroundView.addSubview(scrollView)
        scrollView.addSubview(contentContainerView)
        contentContainerView.addSubview(contentStackView)
        
        // 기존 stack에 요소 추가
        contentStackView.addArrangedSubview(spacer(30))
        contentStackView.addArrangedSubview(travelPeriodLabel)
        contentStackView.addArrangedSubview(spacer(10))
        
        contentStackView.addArrangedSubview(dateButtonStackView)
        dateButtonStackView.addArrangedSubview(startDateButton)
        dateButtonStackView.addArrangedSubview(endDateButton)
        contentStackView.addArrangedSubview(spacer(10))
        
        contentStackView.addArrangedSubview(startDatePicker)
        contentStackView.addArrangedSubview(endDatePicker)
        
        contentStackView.addArrangedSubview(spacer(20))
        contentStackView.addArrangedSubview(travelTitleLabel)
        contentStackView.addArrangedSubview(spacer(10))
        contentStackView.addArrangedSubview(travelTextView)
        
        // contentStackView 아래쪽 공간 조금 더 줘서 picker가 접히더라도 여유 공간
        contentStackView.addArrangedSubview(spacer(50))
        
        // startLogButton은 스크롤뷰 외부가 아니라
        // "아래쪽"에 붙이고 싶으면 contentStackView에 넣을 수도 있지만,
        // "절대 위치"로 safeArea 하단에 고정하려면 아래쪽 constraint로 잡으면 됨.
        // 여기서는 contentStackView 내에 넣어 스크롤되게 만들겠다면:
        contentStackView.addArrangedSubview(spacer(50))
        contentStackView.addArrangedSubview(startLogButton)
        contentStackView.addArrangedSubview(spacer(50))
        
        setupConstraints()
    }
    
    private func spacer(_ height: CGFloat) -> UIView {
        let v = UIView()
        v.snp.makeConstraints { make in
            make.height.equalTo(height)
        }
        return v
    }
    
    private func setupConstraints() {
        
        // 상단 네비
        startNavBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }
        
        addCountryButton.snp.makeConstraints { make in
            make.top.equalTo(startNavBar.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        
        addPhotoButton.snp.makeConstraints { make in
            make.top.equalTo(startNavBar.snp.bottom).offset(20)
            make.centerX.equalToSuperview().offset(15)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(addCountryButton.snp.bottom).offset(15)
        }
        
        grayBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        // 시작,끝난 날짜 입력 버튼
        dateButtonStackView.snp.makeConstraints { make in
                    make.height.equalTo(50)
                    make.top.equalTo(travelPeriodLabel.snp.bottom).offset(10)

                }
        
        // 여행 제목 입력 뷰
        travelTextView.snp.makeConstraints { make in
                    make.height.equalTo(50) // 원하는 높이 설정
                    make.top.equalTo(travelTitleLabel.snp.bottom).offset(10)
                }

        
        searchTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top).offset(-3)
            make.leading.trailing.equalToSuperview().inset(21)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        // 스크롤뷰 전체를 grayBackgroundView와 동일하게
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // scrollView 안에 contentContainerView
        contentContainerView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            // 폭은 scrollView와 동일 (수직 스크롤)
            make.width.equalTo(scrollView.frameLayoutGuide)
            // 높이는 자동(스택 높이에 따라)
        }
        
        // 그 안에 contentStackView
        contentStackView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview().inset(21)
        }
        
        // "여행 기록 시작하기" 버튼
        startLogButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        // 만약 startLogButton을
        // grayBackgroundView 하단에 고정하고 싶다면(스크롤 밖):
        // 아래와 같은 식으로 따로 제약 잡아주면 됨.
        // 그런데 위 코드는 contentStackView 안에 넣었으니 필요 없음.
        /*
        startLogButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.equalTo(grayBackgroundView.snp.leading).offset(21)
            make.trailing.equalTo(grayBackgroundView.snp.trailing).offset(-21)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-50)
        }
        */
    }
}
