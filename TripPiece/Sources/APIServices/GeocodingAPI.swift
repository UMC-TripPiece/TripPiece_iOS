// Copyright © 2024 TripPiece. All rights reserved

import Foundation
import Moya

enum GeocodingAPI {
    case getCoordinate(country: String, city: String)
}

extension GeocodingAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://maps.googleapis.com") else {
            fatalError("fatal error - invalid url")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getCoordinate(let country, let city):
            return "/maps/api/geocode/json"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCoordinate(let country, let city):
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getCoordinate(let country, let city):
            return .requestParameters(parameters: ["address": "\(country) \(city)", "key": "AIzaSyCbZnlOXmN8Yz7AI93dJWH-KENnT6R-5kM"], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getCoordinate(let country, let city):
            return [
                "Content-Type": "application/json",
            ]
        }
    }
}
