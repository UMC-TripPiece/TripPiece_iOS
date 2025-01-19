// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import Macaw

class WorldVC: UIViewController, UITextFieldDelegate {
    private var isAPICalled = false
    public var searchResults: [SearchedCityResponse] = []
    public var coloredCountries: [ColorVisitRecord] = []
    public var statsCountries: StatsVisitRecord = StatsVisitRecord(countryCount: 0, cityCount: 0, countryCodes: [], cityIds: [])
    public var userId: Int?
    
    private lazy var navBar: GradientNavigationBar = {
        return GradientNavigationBar(title: "여행자님의 세계지도")
    }()
    

    // MARK: - UI Components
    public lazy var mapView: MapView = {
        let mapView = MapView()
        mapView.clipsToBounds = true
        mapView.isUserInteractionEnabled = true
        return mapView
    }()
    
    
    public lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.maximumZoomScale = 5
        scrollView.minimumZoomScale = 1
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bouncesZoom = true
        scrollView.bounces = true
        scrollView.delegate = self
        return scrollView
    }()
    
    
    public lazy var searchBar: CustomSearchBar = {
        let searchBarVC = CustomSearchBar()
        searchBarVC.searchBar.placeholder = "도시 및 국가를 검색해 보세요."
        searchBarVC.searchBar.searchTextField.delegate = self
            
        searchBarVC.onTextDidChange = { [weak self] text in
            self?.sendCitySearchRequest(keyword: text)
        }
        return searchBarVC
    }()

    public lazy var searchTableView: CustomSearchTableView = {
        let tableView = CustomSearchTableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.view.backgroundColor = .white
        setupUI()
        mapView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleChangeMapColorNotification), name: .changeMapColor, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDeleteMapColorNotification), name: .deleteMapColor, object: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserData()
        
        view.layoutIfNeeded()
        // 이 부분 꼭 필요한가?
        scrollView.maximumZoomScale = scrollView.bounds.height / mapView.map.bounds!.h * 3
        scrollView.minimumZoomScale = scrollView.bounds.height / mapView.map.bounds!.h
        scrollView.zoomScale = scrollView.minimumZoomScale
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // searchBar를 항상 최상위로 유지
        view.bringSubviewToFront(searchBar)
        view.bringSubviewToFront(searchTableView)
    }

    
    // MARK: - UI Methods
    private func setupUI() {
        view.addSubview(navBar)
            
        view.addSubview(searchBar)
        view.addSubview(searchTableView)
        
        view.addSubview(scrollView)
        scrollView.addSubview(mapView)
            
        setupConstraints()
    }

    private func setupConstraints() {
        // navigation bar
        navBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(107)
        }
            
        // search bar
        searchBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(navBar.snp.bottom).offset(15)
            make.height.equalTo(48)
        }
        searchTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(3)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(searchTableView.heightConstraint)
        }
        
        // mapview
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(mapView.map.bounds!.w)
            make.height.equalTo(mapView.map.bounds!.h)
        }
    }
    
    // NotificationCenter에서 호출할 메서드
    @objc private func handleChangeMapColorNotification(_ notification: Notification) {
        guard let userId = userId else { return }
        getCountryColorsData(userId) { colorInfo in
            if let data = colorInfo {
                DispatchQueue.main.async {
                    self.coloredCountries = data
                    self.setUpCountryColor(data)
                }
                
            }
        }

    }
    
    @objc private func handleDeleteMapColorNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let deletedItem = userInfo["deletedItem"] as? String else {
            return
        }
        guard let countryEnum = CountryEnum(rawValue: deletedItem) else { return }
        guard let defaultColor = UIColor(hex: "#c8c4c4") else { return }
        mapView.colorMap(countryEnum: countryEnum, color: defaultColor)
    
    }
    
    
    
    //MARK: Setup Actions
    // x 버튼 눌렀을 때 호출되는 UITextFieldDelegate 메서드
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // 테이블뷰 숨김 처리
        searchTableView.isHidden = true
        // true를 반환하면 텍스트필드도 비워짐
        return true
    }
    
    func getUserData() {
        getUserId { userInfo in
            if let userInfo = userInfo {
                self.userId = userInfo.userId
                self.getCountryStatsData(userInfo.userId) { statsInfo in
                    if let data = statsInfo {
                        self.statsCountries = data
                        self.setUpBadgeView(nickname: userInfo.nickname, profileImage: userInfo.profileImg, visitedCountryNum: data.countryCount, visitedCityNum: data.cityCount)
                    }
                }
                self.getCountryColorsData(userInfo.userId) { colorInfo in
                    if let data = colorInfo {
                        self.coloredCountries = data
                        self.setUpCountryColor(data)
                    }
                }
                if !self.isAPICalled {  /// 앱 실행시 첫 1번만 한국에 zoom in
                    self.focusOnCountry(with: .southKorea)
                }
                self.isAPICalled = true
            }
        }
    }
    
    private func setUpBadgeView(nickname: String, profileImage: String, visitedCountryNum: Int, visitedCityNum: Int) {
        // 기존의 지도 및 UI 요소가 추가된 후 아래에 배지 뷰를 추가합니다.
        let floatingBadgeView = FloatingBadgeView()
        floatingBadgeView.updateProfile(with: nickname)
        guard let urlImage = URL(string: profileImage) else { return }
        floatingBadgeView.updateProfileImage(with: urlImage)
        floatingBadgeView.updateSubtitleLabel(countryNum: visitedCountryNum, cityNum: visitedCityNum)
        view.addSubview(floatingBadgeView)
                
        floatingBadgeView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(42)
            make.leading.trailing.equalToSuperview().inset(21)
            make.height.equalToSuperview().multipliedBy(0.131516588)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setUpCountryColor(_ colorData: [ColorVisitRecord]) {
        // 미리 매핑된 색상 딕셔너리 정의
        let colorMapping: [String: String] = [
            "BLUE": "#6744FF",
            "RED": "#FD2D69",
            "CYAN": "#25CEC1",
            "YELLOW": "#FFB40F"
        ]
        // 데이터 반복 처리
        for data in colorData {
            // 매핑된 색상 값을 가져오고, 없으면 기존 값을 사용
            let countryColor = colorMapping[data.color] ?? data.color
            // 색상을 변경
            self.mapView.colorMap(
                countryEnum: CountryEnum(rawValue: data.countryCode) ?? .southKorea,
                color: UIColor(hex: countryColor) ?? .gray
            )
        }
    }
    
    
    
    
    

    
    
    //MARK: API call
    func getUserId(completion: @escaping (MemberInfoResult?) -> Void) {
        UserInfoManager.fetchMemberInfo { result in
            switch result {
            case .success(let memberInfo):
                completion(memberInfo.result)
            case .failure(let error):
                completion(nil)
            }
        }
    }
    

    func getCountryColorsData(_ userId: Int, completion: @escaping ([ColorVisitRecord]?) -> Void) {
        MapManager.getCountryColors(userId: userId) { result in
            switch result {
            case .success(let colorInfo):
                completion(colorInfo.result)
            case .failure(let error):
                print("color 오류 발생: \(error.localizedDescription)")
                completion([])
            }
        }
    }
    
    func getCountryStatsData(_ userId: Int, completion: @escaping (StatsVisitRecord?) -> Void) {
        MapManager.getCountryStats(userId: userId) { result in
            switch result {
            case .success(let statsInfo):
                print("나라 stats data: \(statsInfo.result)")
                completion(statsInfo.result)
            case .failure(let error):
                print("오류 발생: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    func sendCitySearchRequest(keyword: String) {
        MapManager.getSearchedCities(keyword: keyword) { result in
            switch result {
            case .success(let searchResult):
                self.searchResults = searchResult.result
                self.searchTableView.calculateHeight(rowCount: searchResult.result.count)
                self.searchTableView.isHidden = self.searchResults.isEmpty
                self.searchTableView.reloadData()
            case .failure(let error):
                print("오류 발생: \(error.localizedDescription)")
            }
        }
    }
    
    
    // 옵저버 제거 (deinit에서 옵저버 해제)
    deinit {
        NotificationCenter.default.removeObserver(self, name: .changeMapColor, object: nil)
        NotificationCenter.default.removeObserver(self, name: .deleteMapColor, object: nil)
    }


}
 
        

