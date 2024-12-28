// Copyright © 2024 TripPiece. All rights reserved

import UIKit

extension WorldVC: UITableViewDelegate, UITableViewDataSource {
    
    
    
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
            let cityName = cityData.cityName
            let countryName = cityData.countryName
            let countryImage = cityData.countryImage
                        
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
            
        self.searchBar.searchBar.text = cityData.cityName
        self.searchTableView.isHidden = true
            
        //let selectedCityViewController = SelectedCityViewController()
        //selectedCityViewController.cityData = cityData
            
    // TODO: Macaw로 변환하면서 수정 못한 것
    //        updateWorldViewUI(with: cityData["countryName"] ?? "한국")
            
            
        // 모달로 표시할 때 기존 뷰 컨트롤러를 배경에 반투명하게 보이도록 설정
        /*selectedCityViewController.modalPresentationStyle = .overCurrentContext
        selectedCityViewController.modalTransitionStyle = .crossDissolve // 부드러운 전환을 위해
        // 모달로 뷰 컨트롤러를 표시
        present(selectedCityViewController, animated: true, completion: nil)*/
            
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)  // 스크롤을 시작할 때 키보드 내리기
        searchTableView.isHidden = true
    }
    
}

