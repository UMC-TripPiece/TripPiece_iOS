// Copyright © 2024 TripPiece. All rights reserved

import UIKit

protocol MapDelegate: AnyObject {
    func didSelectCountry(_ country: CountryEnum?)
}



extension WorldVC: MapDelegate {
    
    func didSelectCountry(_ country: CountryEnum?) {
        if let country = country {
            // 나라 클릭됐을 때의 동작
            print("onClicked\nID: \(country.rawValue), name: \(country.name), flag: \(country.emoji)")
            let visitRecordsVC = VisitRecordsVC()
            navigationController?.pushViewController(visitRecordsVC, animated: true)
        } else {
            // 바다 클릭됐을 때의 동작
            print("onClickedSea")
        }
    }
}
