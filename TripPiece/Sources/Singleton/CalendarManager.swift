// Copyright © 2024 TripPiece. All rights reserved

import Foundation

class CalendarManager {
    static let shared = CalendarManager()
    
    private init() { }
    
    // 2025-01-10T05:42:44.858Z
    func convertISO8601ToDate(iso8601Date: String) -> Date? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return isoFormatter.date(from: iso8601Date)
    }
    
    // 2025-01-10
    func convertStringToDate(stringDate: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 9)

        return dateFormatter.date(from: stringDate)
    }
    
    func getAllDates(startDate: Date, endDate: Date) -> [Date] {
        var dates: [Date] = []
        let calendar = Calendar.current

        var currentDate = startDate
        while currentDate <= endDate {
            dates.append(currentDate)
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
                break
            }
            currentDate = nextDate
        }
        return dates
    }
    
    func daysBetweenDates(from: Date?, to: Date?) -> Int {
        guard let from = from,
              let to = to else {
            return 0
        }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: from, to: to)
        return components.day ?? 0
    }
}
