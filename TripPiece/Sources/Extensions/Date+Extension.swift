// Copyright © 2024 TripPiece. All rights reserved

import Foundation

extension Date {
    var millisecondsSince1970: Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    /// 밀리초에서 Date 객체 생성
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    
    var toStringYMDHM: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy.MM.dd HH:mm"
        return dateFormatter.string(from: self)
    }
    
    var toStringYMD: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy.MM.dd"
        return dateFormatter.string(from: self)
    }
}
