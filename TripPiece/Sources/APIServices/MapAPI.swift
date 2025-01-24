// Copyright © 2024 TripPiece. All rights reserved

import Foundation
import Moya

enum MapAPI {
    case getUserMap
    case getUserMapStats
    case getMapSearch(keyword: String)
    case getMapMarkers
    
    case postMaps(param: MapRequest)
    
    case deleteMapColor(param: MapRequest)
    case changeMapColor(param: MapRequest)
}

extension MapAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.NetworkManager.baseURL) else {
            fatalError("fatal error - invalid url")
        }
        return url
    }

    var path: String {
        switch self {
        case .getUserMap: return "maps"
        case .getUserMapStats: return "maps/stats"
        case .getMapSearch(let keyword): return "maps/search"
        case .getMapMarkers: return "maps/markers"
            
        case .postMaps(let param): return "maps"
            
        case .deleteMapColor(let param): return "maps/color"
        case .changeMapColor(let param): return "maps/color"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getUserMap, .getUserMapStats, .getMapSearch, .getMapMarkers:
            return .get
        case .postMaps:
            return .post
        case .deleteMapColor:
            return .delete
        case .changeMapColor:
            return .put
        }
    }

    var task: Moya.Task {
        switch self {
        case .getUserMap :
            return .requestPlain
        case .getUserMapStats :
            return .requestPlain
        case .getMapSearch(let keyword) :
            return .requestParameters(parameters: ["keyword": keyword], encoding: URLEncoding.queryString)
        case .getMapMarkers:
            return .requestPlain
        case .postMaps(let param) :
            return .requestJSONEncodable(param)
        case .deleteMapColor(let param) :
            return .requestJSONEncodable(param)
        case .changeMapColor(param: let param) :
            return .requestJSONEncodable(param)
        }
    }

    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
