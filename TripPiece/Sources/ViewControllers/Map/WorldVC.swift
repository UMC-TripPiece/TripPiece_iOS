// Copyright © 2024 TripPiece. All rights reserved

import UIKit

class WorldVC: UIViewController {
    
    public var searchResults: [SearchedCityResponse] = []
    
    private lazy var navBar: GradientNavigationBar = {
        return GradientNavigationBar(title: "여행자님의 세계지도")
    }() // 안먹히면 전 프로젝트에서 다시 가져와서 사용할 것
    
    
    private lazy var customSearchBar: CustomSearchBar = {
        let searchBarVC = CustomSearchBar()
        
        searchBarVC.searchBar.placeholder = "도시 및 국가를 검색해 보세요."
            
        searchBarVC.onTextDidChange = { [weak self] text in
            self?.sendCitySearchRequest(keyword: text)
        }
        return searchBarVC
    }()
    
    
    private lazy var searchTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.identifier)
        tableView.layer.cornerRadius = 5
        tableView.clipsToBounds = true
        tableView.backgroundColor = .clear
        tableView.layer.shadowColor = UIColor.black.cgColor
        tableView.layer.shadowOpacity = 0.1
        tableView.layer.shadowOffset = CGSize(width: 0, height: 4)
        tableView.layer.shadowRadius = 15
        
        return tableView
    }()
    
    public lazy var searchTableViewHeightConstraint = searchTableView.heightAnchor.constraint(equalToConstant: 0)
    
        

    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.view.backgroundColor = .white
        setupUI()
    }
    
    
    private func setupUI() {
            
            view.addSubview(navBar)
            
            view.addSubview(customSearchBar)
            view.addSubview(searchTableView)
            
            setupConstraints()
    }

    private func setupConstraints() {
        
        navBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(107)
        }
            

        customSearchBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(navBar.snp.bottom).offset(15)
            make.height.equalTo(48)
        }
        searchTableView.snp.makeConstraints { make in
                make.top.equalTo(customSearchBar.snp.bottom).offset(3)
                make.leading.trailing.equalToSuperview().inset(16)
        }
                
        searchTableViewHeightConstraint.isActive = true // 높이 제약 활성화
                
    }
    
    
    
    
    //MARK: Setup Actions
    
    func sendCitySearchRequest(keyword: String) {
        MapManager.getSearchedCities(keyword: keyword) { result in
            switch result {
            case .success(let searchResult):
                print("검색 결과: \(searchResult)")
                self.searchResults = searchResult.result
                self.updateSearchTableViewHeight()
                self.searchTableView.isHidden = self.searchResults.isEmpty
                self.searchTableView.reloadData()
            case .failure(let error):
                print("오류 발생: \(error.localizedDescription)")
                // 사용자에게 에러 메시지 표시
            }
        }

    }

    
    


}

/*
// MARK: - UITableViewDataSource, UITableViewDelegate

extension WorldVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            // 첫 번째 셀을 "검색 결과:"로 표시
            let cell = UITableViewCell(style: .default, reuseIdentifier: "HeaderCell")
            cell.textLabel?.text = "검색 결과"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            cell.textLabel?.textColor = .black
            cell.backgroundColor = UIColor(white: 1, alpha: 0.8)
            return cell
        } else {
            // 나머지 셀은 검색 결과를 표시
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.identifier, for: indexPath) as? SearchResultCell else { return UITableViewCell() }
                
            let cityData = searchResults[indexPath.row - 1]  // -1을 하여 첫 번째 셀을 건너뜁니다.
            let cityName = cityData.cityName ?? ""
            let countryName = cityData.countryName ?? ""
            let countryImage = cityData.countryImage ?? ""
                
            cell.configure(cityName: cityName, countryName: countryName, countryImage: countryImage)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 55  // 첫 번째 셀의 높이를 50으로 고정
        } else {
            return 48 // 나머지 셀의 높이는 커스텀 셀에 의해 결정됨
        }
    }
        
        
        
        
        
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityData = searchResults[indexPath.row - 1]
            
        customSearchBar.searchBar.text = cityData.cityName
        searchTableView.isHidden = true
            
        let selectedCityViewController = SelectedCityViewController()
        selectedCityViewController.cityData = cityData
            
        // TODO: Macaw로 변환하면서 수정 못한 것
        //updateWorldViewUI(with: cityData["countryName"] ?? "한국")
            
            
        // 모달로 표시할 때 기존 뷰 컨트롤러를 배경에 반투명하게 보이도록 설정
        selectedCityViewController.modalPresentationStyle = .overCurrentContext
        selectedCityViewController.modalTransitionStyle = .crossDissolve // 부드러운 전환을 위해
        // 모달로 뷰 컨트롤러를 표시
        present(selectedCityViewController, animated: true, completion: nil)
                    
    }
                
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)  // 스크롤을 시작할 때 키보드 내리기
        searchTableView.isHidden = true
    }
}
*/
