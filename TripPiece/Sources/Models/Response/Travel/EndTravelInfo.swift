// Copyright © 2024 TripPiece. All rights reserved

import Foundation

struct EndTravelInfo: Codable {
    let title: String
    let city: String
    let country: String
    let countryImage: String
    let startDate: String
    let endDate: String
    let totalPieces: Int
    let memoCount: Int
    let pictureCount: Int
    let videoCount: Int
    let pictureSummaries: [PictureSummary]
    struct PictureSummary: Codable {
        let id: Int
        let description: String
        let category: String
        let mediaUrls: [String]
        let createdAt: String
    }
}
