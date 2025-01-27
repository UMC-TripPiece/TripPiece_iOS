// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import SnapKit

class ExploreVC: UIViewController, UITextFieldDelegate {
    
    public var searchResults: [SearchedCityResponse] = []
    
    // MARK: - UI Properties
    
    private lazy var navBar: SolidWhiteBar = {
        return SolidWhiteBar(title: "탐색")
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
    
    /*private lazy var searchField: UITextField = {
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
    }()*/
    
    public lazy var searchBar: CustomSearchBar = {
        let searchBarVC = CustomSearchBar()
        
        searchBarVC.searchBar.placeholder = "도시 및 국가를 검색해 보세요."
        searchBarVC.searchBar.searchTextField.delegate = self
            
        /*searchBarVC.onTextDidChange = { [weak self] text in
            self?.sendCitySearchRequest(keyword: text)
        }*/
        
        return searchBarVC
    }()

    
    public lazy var searchTableView: CustomSearchTableView = {
        let tableView = CustomSearchTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        return tableView
    }()
    
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.bg2
        return view
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
    
    private lazy var latestLogTitleSubtitleView: TitleSubtitleView = {
        let view = TitleSubtitleView()
        view.configure(
            title: "최신 여행기",
            subtitle: "최근 사용자들이 기록한 여행기에요"
        )
        return view
    }()
    
    private lazy var latestLogStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    var trendingCitiesInfo: [TrendingResponse] = []
        
    let dummyTravelLogs: [TravelLogData] = [
        TravelLogData(
            imageURL: "https://via.placeholder.com/300x150",
            title: "Beautiful Beach",
            date: "2024-12-01",
            location: "Malibu, USA",
            profileImg: "https://via.placeholder.com/40",
            name: "Alice"
        ),
        TravelLogData(
            imageURL: "https://via.placeholder.com/300x150",
            title: "Snowy Mountains",
            date: "2024-11-15",
            location: "Swiss Alps, Switzerland",
            profileImg: "https://via.placeholder.com/40",
            name: "Bob"
        ),
        TravelLogData(
            imageURL: "https://via.placeholder.com/300x150",
            title: "City Lights",
            date: "2024-10-20",
            location: "Tokyo, Japan",
            profileImg: "https://via.placeholder.com/40",
            name: "Charlie"
        ),
        TravelLogData(
            imageURL: "https://via.placeholder.com/300x150",
            title: "Desert Adventure",
            date: "2024-09-10",
            location: "Sahara, Morocco",
            profileImg: "https://via.placeholder.com/40",
            name: "Diana"
        ),
        TravelLogData(
            imageURL: "https://via.placeholder.com/300x150",
            title: "Historic Landmarks",
            date: "2024-08-05",
            location: "Rome, Italy",
            profileImg: "https://via.placeholder.com/40",
            name: "Ethan"
        )
    ]
    
    struct ExplorePieceData {
        let type: String
        let mediaURL: String
        let memo: String
        let location: String
        let profileImg: String
        let name: String
    }

    // 더미 데이터 생성
    let explorePieceDummyData: [ExplorePieceData] = [
        ExplorePieceData(
            type: "MEMO",
            mediaURL: "",
            memo: "이곳에서 본 석양은 정말 잊을 수 없었어요.",
            location: "Malibu, USA",
            profileImg: "https://via.placeholder.com/40",
            name: "Alice"
        ),
        ExplorePieceData(
            type: "PICTURE",
            mediaURL: "https://via.placeholder.com/300x200",
            memo: "",
            location: "Swiss Alps, Switzerland",
            profileImg: "https://via.placeholder.com/40",
            name: "Bob"
        ),
        ExplorePieceData(
            type: "VIDEO",
            mediaURL: "https://via.placeholder.com/300x200",
            memo: "",
            location: "Tokyo, Japan",
            profileImg: "https://via.placeholder.com/40",
            name: "Charlie"
        ),
        ExplorePieceData(
            type: "MEMO",
            mediaURL: "",
            memo: "사막의 밤은 정말 고요하고 별이 아름다웠어요.",
            location: "Sahara, Morocco",
            profileImg: "https://via.placeholder.com/40",
            name: "Diana"
        ),
        ExplorePieceData(
            type: "PICTURE",
            mediaURL: "https://via.placeholder.com/300x200",
            memo: "",
            location: "Rome, Italy",
            profileImg: "https://via.placeholder.com/40",
            name: "Ethan"
        )
    ]
    
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
        updateLatestLogStackView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("ScrollView Content Size:", scrollView.contentSize)
        print("TrendingCitiesScrollView Content Size:", trendingCitiesScrollView.contentSize)
        
        // searchBar를 항상 최상위로 유지
        view.bringSubviewToFront(searchBar)
        view.bringSubviewToFront(searchTableView)
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
        view.backgroundColor = Constants.Colors.bg2
        
        scrollView.delaysContentTouches = false
        scrollView.canCancelContentTouches = true
        
        [navBar, scrollView, searchBar, searchTableView].forEach {
            view.addSubview($0)
        }
        navBar.addSubview(friendListButton)
        scrollView.addSubview(contentView)
        trendingCitiesScrollView.addSubview(trendingCitiesStackView)
        
        
        [trendingTitleSubtitleView,
         trendingCitiesScrollView, dividingLine, latestLogTitleSubtitleView,
         latestLogStackView].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        navBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(107)
        }
        friendListButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        searchTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(3)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(searchTableView.heightConstraint)
        }
        trendingTitleSubtitleView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(16)
        }
        trendingCitiesScrollView.snp.makeConstraints { make in
            make.top.equalTo(trendingTitleSubtitleView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(150)
        }
        trendingCitiesStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.trailing.top.bottom.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        dividingLine.snp.makeConstraints { make in
            make.top.equalTo(trendingCitiesScrollView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(5)
        }
        
        latestLogTitleSubtitleView.snp.makeConstraints { make in
            make.top.equalTo(dividingLine.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(16)
        }
        latestLogStackView.snp.makeConstraints { make in
            make.top.equalTo(latestLogTitleSubtitleView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-40)
        }
    }
    
    
    //MARK: Setup Actions
    
    // x 버튼 눌렀을 때 호출되는 UITextFieldDelegate 메서드
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // 테이블뷰 숨김 처리
        searchTableView.isHidden = true
        // true를 반환하면 텍스트필드도 비워짐
        return true
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
            //TODO: 데이터 null 아니게 되는 거면 수정 필요
            cell.configure(imageURL: TrendingResponse.thumbnail ?? "https://via.placeholder.com/150", title: title, subtitle: subtitle)
            trendingCitiesStackView.addArrangedSubview(cell)
        }
    }
    
    func updateLatestLogStackView() { //여행기 cell 추가
        latestLogStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for TravelLogData in dummyTravelLogs {
            let cell = ExploreTravelLogCell()
            cell.configure(imageURL: TravelLogData.imageURL, title: TravelLogData.title, date: TravelLogData.date, location: TravelLogData.location, profileImg: TravelLogData.profileImg, name: TravelLogData.name)
            latestLogStackView.addArrangedSubview(cell)
        }
    }
    
//    func updateLatestLogStackView() { //여행조각 cell 추가 예시 코드
//        latestLogStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
//        
//        for ExplorePieceData in explorePieceDummyData {
//            let cell = ExplorePieceCell()
//            cell.configure(type: ExplorePieceData.type, mediaURL: ExplorePieceData.mediaURL, memo: ExplorePieceData.memo, location: ExplorePieceData.location, profileImg: ExplorePieceData.profileImg, name: ExplorePieceData.name)
//            latestLogStackView.addArrangedSubview(cell)
//        }
//    }
    
    
    //MARK: API call
    
    func sendCitySearchRequest(keyword: String) {
        MapManager.getSearchedCities(keyword: keyword) { result in
            switch result {
            case .success(let searchResult):
                //print("검색 결과: \(searchResult)")
                self.searchResults = searchResult.result
                self.searchTableView.calculateHeight(rowCount: searchResult.result.count)
                self.searchTableView.isHidden = self.searchResults.isEmpty
                self.searchTableView.reloadData()
            case .failure(let error):
                print("오류 발생: \(error.localizedDescription)")
            }
        }

    }
    
    
    
}


