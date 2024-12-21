// Copyright © 2024 TripPiece. All rights reserved

import Foundation

struct GeocodingResponse: Codable {
    let results: [GeocodingResult]
    struct GeocodingResult: Codable {
        let geometry: Geometry
        struct Geometry: Codable {
            let location: Location
            struct Location: Codable {
                let lat: Double
                let lng: Double
            }
        }
    }
    let status: String
}
