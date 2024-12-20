// Copyright © 2024 TripPiece. All rights reserved

import Foundation

func formatDate(from input: String) -> String? {
    let inputDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
    let outputDateFormat = "yyyy.MM.dd HH:mm"
    
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = inputDateFormat
    inputFormatter.locale = Locale(identifier: "en_US_POSIX") // 안정적인 날짜 처리를 위해 사용
    
    guard let date = inputFormatter.date(from: input) else {
        print("Invalid input date format: \(input)")
        return nil
    }
    
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = outputDateFormat
    outputFormatter.locale = Locale(identifier: "en_US_POSIX")
    
    return outputFormatter.string(from: date)
}


func calculateDaysElapsed(from startDateString: String) -> Int {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd" // 여행 시작 날짜의 형식에 맞게 설정

    guard let startDate = dateFormatter.date(from: startDateString) else {
        print("Invalid date format")
        return 0
    }
    
    let currentDate = Date()
    let calendar = Calendar.current
    
    let components = calendar.dateComponents([.day], from: startDate, to: currentDate)
    let daysDifference = components.day ?? 0
    
    return max(daysDifference + 1, 1)
}
