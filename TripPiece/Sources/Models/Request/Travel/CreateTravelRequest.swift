// Copyright © 2024 TripPiece. All rights reserved

import Foundation

//struct CreateTravelRequest : Codable {
//    let cityName : String
//    let countryName : String
//    let title : String
//    let startDate : String
//    let endDate : String
//}
struct CreateTravelRequest: Codable {
    var cityName: String
    var countryName: String
    var title: String
    var startDate: String
    var endDate: String
    var thumbnail: Data = Data()
    
    // 새로운 값을 동적으로 업데이트하는 메서드
    mutating func updateInfo(title: String? = nil, cityName: String? = nil, countryName: String? = nil, startDate: String? = nil, endDate: String? = nil, thumbnail: Data? = nil) {
        if let title = title { self.title = title }
        if let cityName = cityName { self.cityName = cityName }
        if let countryName = countryName { self.countryName = countryName }
        if let startDate = startDate { self.startDate = startDate }
        if let endDate = endDate { self.endDate = endDate }
        if let thumbnail = thumbnail {self.thumbnail = thumbnail}
    }
}
