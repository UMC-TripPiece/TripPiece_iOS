// Copyright © 2024 TripPiece. All rights reserved

import Foundation

extension Date {
    init?(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000.0)
    }
}
