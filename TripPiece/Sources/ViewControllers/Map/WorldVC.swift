// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import Macaw

class WorldVC: UIViewController, UITextFieldDelegate {
    
    public var searchResults: [SearchedCityResponse] = []
    
    private lazy var navBar: GradientNavigationBar = {
        return GradientNavigationBar(title: "여행자님의 세계지도")
    }() // 안먹히면 전 프로젝트에서 다시 가져와서 사용할 것
    

    
    public lazy var mapView: MapView = {
        let mapView = MapView()
        mapView.clipsToBounds = true
        //mapView.delegate = self // 필요시 delegate 설정
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
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.view.backgroundColor = .white
        setupUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layoutIfNeeded()
        // 이 부분 꼭 필요한가?
        scrollView.maximumZoomScale = scrollView.bounds.height / mapView.map.bounds!.h * 3
        scrollView.minimumZoomScale = scrollView.bounds.height / mapView.map.bounds!.h
        scrollView.zoomScale = scrollView.minimumZoomScale
        
        
        focusOnCountry(with: .southKorea)  
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // searchBar를 항상 최상위로 유지
        view.bringSubviewToFront(searchBar)
        view.bringSubviewToFront(searchTableView)
    }

    
    
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
    
    
    
    
    //MARK: Setup Actions
    
    // x 버튼 눌렀을 때 호출되는 UITextFieldDelegate 메서드
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // 테이블뷰 숨김 처리
        searchTableView.isHidden = true
        // true를 반환하면 텍스트필드도 비워짐
        return true
    }
    
    
    
    
    

    
    
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
 
        

