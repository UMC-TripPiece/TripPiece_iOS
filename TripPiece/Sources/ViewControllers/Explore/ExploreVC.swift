// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import SnapKit

class ExploreVC: UIViewController {

    // MARK: - UI Properties
    
    private lazy var topBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var puzzle: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "puzzle"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var exploreLabel: UILabel = {
        let label = UILabel()
        label.text = "탐색"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = UIColor(hex: "6644FF")
        return label
    }()
    
    private lazy var friendListButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "person.2.fill"), for: .normal)
        button.tintColor = UIColor(hex: "696969")
        button.setTitle(" 친구 목록", for: .normal)
        button.setTitleColor(UIColor(hex: "696969"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return button
    }()
    
    private lazy var searchField: UITextField = {
        let textField = UITextField()
        textField.placeholder = " | 도시 및 국가를 검색해보세요"
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(hex: "6644FF")?.cgColor
        textField.layer.cornerRadius = 8
        textField.rightViewMode = .always
        
        let magnifyingGlassImageView = UIImageView(image: UIImage(named: "magnifyingGlass"))
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        magnifyingGlassImageView.frame = CGRect(x: -5, y: 5, width: 20, height: 20)
        paddingView.addSubview(magnifyingGlassImageView)
        textField.rightView = paddingView
        return textField
    }()
    
    private lazy var trendingTitleSubtitleView: TitleSubtitleView = {
        let view = TitleSubtitleView()
        view.configure(
            title: "요즘 떠오르는 도시",
            subtitle: "여행 조각들이 많이 기록되는 도시들이에요"
        )
        return view
    }()
    
    private lazy var trendingCitiesScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var trendingCitiesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 15
        return stackView
    }()
    
    private lazy var dividingLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "F2F2F2")
        return view
    }()
    
    private lazy var latestJournalTitleSubtitleView: TitleSubtitleView = {
        let view = TitleSubtitleView()
        view.configure(
            title: "최신 여행기",
            subtitle: "최근 사용자들이 기록한 여행기에요"
        )
        return view
    }()
    
    private lazy var latestScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var latestStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()

    var trendingCitiesInfo: [TrendingResponse] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //요즘 떠오르는 도시 api 호출
        ExploreManager.fetchTrendingInfo { result in
            switch result {
            case .success(let data):
                self.trendingCitiesInfo = data.result // 데이터를 저장
                self.updateTrendingCityStackView()
                print("데이터 불러오기")
            case .failure(let error):
                print("Error occurred: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupActions()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        view.backgroundColor = UIColor(hex: "F7F7F7")
        
        [topBar, searchField, trendingTitleSubtitleView,
         trendingCitiesScrollView, dividingLine, latestJournalTitleSubtitleView,
         latestScrollView].forEach {
            view.addSubview($0)
        }
        
        [puzzle, exploreLabel, friendListButton].forEach {
            topBar.addSubview($0)
        }
        
        trendingCitiesScrollView.addSubview(trendingCitiesStackView)
        latestScrollView.addSubview(latestStackView)
    }
    
    private func setupConstraints() {
        topBar.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(100)
        }
        
        puzzle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(60)
            make.size.equalTo(20)
        }
        
        exploreLabel.snp.makeConstraints { make in
            make.left.equalTo(puzzle.snp.right).offset(8)
            make.centerY.equalTo(puzzle)
        }
        
        friendListButton.snp.makeConstraints { make in
            make.centerY.equalTo(puzzle)
            make.right.equalToSuperview().inset(16)
        }
        
        searchField.snp.makeConstraints { make in
            make.top.equalTo(topBar.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        
        trendingTitleSubtitleView.snp.makeConstraints { make in
            make.top.equalTo(searchField.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(16)
        }
        trendingCitiesScrollView.snp.makeConstraints { make in
            make.top.equalTo(trendingTitleSubtitleView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(150)
        }
        trendingCitiesStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.trailing.top.bottom.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        dividingLine.snp.makeConstraints { make in
            make.top.equalTo(trendingCitiesScrollView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(5)
        }
        
        latestJournalTitleSubtitleView.snp.makeConstraints { make in
            make.top.equalTo(dividingLine.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(16)
        }
        latestScrollView.snp.makeConstraints { make in
            make.top.equalTo(latestJournalTitleSubtitleView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        latestStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func updateTrendingCityStackView() { //여행기 cell 추가
        trendingCitiesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for TrendingResponse in trendingCitiesInfo {
            let cell = TrendingCityCardCell()
            let title = "\(TrendingResponse.city), \(TrendingResponse.country)"
            let subtitle = "\(TrendingResponse.count)명이 여행했어요"
            cell.configure(imageURL: TrendingResponse.thumbnail ?? "https://via.placeholder.com/150", title: title, subtitle: subtitle)
            trendingCitiesStackView.addArrangedSubview(cell)
        }
    }
}
