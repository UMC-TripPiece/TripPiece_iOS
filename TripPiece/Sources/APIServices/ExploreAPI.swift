// Copyright © 2024 TripPiece. All rights reserved

import Foundation
import Moya
import UIKit

enum ExploreAPI {
    case getSearchResult(query: String)
    case getPopularResult
}

extension ExploreAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.NetworkManager.baseURL) else {
            fatalError("fatal error - invalid url")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getSearchResult: return "explore/search"
        case .getPopularResult: return "explore/popular"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getSearchResult, .getPopularResult:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getSearchResult(let query):
                return .requestParameters(parameters: ["query": query], encoding: URLEncoding.queryString)
        case .getPopularResult :
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
