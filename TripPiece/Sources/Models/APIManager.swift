// Copyright © 2024 TripPiece. All rights reserved

import Foundation
import Moya

class APIManager {
    static let AuthProvider = MoyaProvider<AuthAPI>(plugins: [NetworkLoggerPlugin() ])
    static let MapProvider = MoyaProvider<MapAPI>(plugins: [BearerTokenPlugin(), NetworkLoggerPlugin()])
    static let TravelProvider = MoyaProvider<TravelAPI>(plugins: [BearerTokenPlugin(), NetworkLoggerPlugin()])
    static let TripPieceProvider = MoyaProvider<TripPieceAPI>(plugins: [BearerTokenPlugin(), NetworkLoggerPlugin()])
    static let UserProvider = MoyaProvider<AuthAPI>(plugins: [BearerTokenPlugin(), NetworkLoggerPlugin()])
}
