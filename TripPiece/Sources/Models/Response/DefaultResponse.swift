// Copyright © 2024 TripPiece. All rights reserved

import Foundation

struct DefaultResponse<T: Codable>: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: T
}

struct DefaultMultiResponse<T: Codable>: Codable {
    let isSuccess: Bool
    let code: String?
    let message: String
    let result: [T]
}
