// Copyright © 2024 TripPiece. All rights reserved

import Foundation
import Moya

enum MapAPI {
    case deleteMapColor(mapId: Int)
    
    case getUserMap(userId: Int)
    case getUserMapStats(userId: Int)
    case getMapSearch(keyword: String)
    case getMapMarkers
    
    case postMaps(param: postMapRequest)
    
    //TODO: API update 필요
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
        case .deleteMapColor(let mapId): return "maps/color/delete/\(mapId)"
            
        case .getUserMap(let userId): return "maps/\(userId)"
        case .getUserMapStats(let userId): return "maps/stats/\(userId)"
        case .getMapSearch(let keyword): return "maps/search"
        case .getMapMarkers: return "maps/markers"
            
        case .postMaps(let param): return "maps"
        //TODO: put case 추가 필요
        }
    }

    var method: Moya.Method {
        switch self {
        case .getUserMap, .getUserMapStats, .getMapSearch, .getMapMarkers:
            return .get
        case .deleteMapColor:
            return .delete
        case .postMaps:
            return .post
        }
    }

    var task: Moya.Task {
        switch self {
        case .deleteMapColor :
            return .requestPlain
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
        }
    }

    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
