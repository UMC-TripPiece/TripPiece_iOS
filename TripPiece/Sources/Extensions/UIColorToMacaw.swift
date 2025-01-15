// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import Macaw

extension Macaw.Color {
    static func from(uiColor: UIColor) -> Macaw.Color {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        // UIColor의 구성 요소 가져오기
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        // Macaw의 Color.rgba로 변환
        return Macaw.Color.rgba(
            r: Int(red * 255),
            g: Int(green * 255),
            b: Int(blue * 255),
            a: Double(alpha)
        )
    }
}
