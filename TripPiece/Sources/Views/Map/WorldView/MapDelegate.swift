// Copyright © 2024 TripPiece. All rights reserved

import UIKit

protocol MapDelegate: AnyObject {
    func didSelectCountry(_ country: CountryEnum?)
}



extension WorldVC: MapDelegate {
    
    func didSelectCountry(_ country: CountryEnum?) {
        // 바다 클릭 시 처리
        guard let country = country else { return }

        // 색칠된 나라 확인
        if let coloredCountry = coloredCountries.first(where: { $0.countryCode == country.rawValue }) {
            // 색칠된 나라 처리

            // VisitRecordsVC로 이동
            let visitRecordsVC = VisitRecordsVC()
            visitRecordsVC.colorRecords = coloredCountries
            visitRecordsVC.cityIds = statsCountries.cityIds
            navigationController?.pushViewController(visitRecordsVC, animated: true)
        } else {
            // 색칠되지 않은 나라
            return
        }
    }
}
