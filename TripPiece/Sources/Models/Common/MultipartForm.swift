// Copyright © 2024 TripPiece. All rights reserved

import Foundation
import Moya
import UIKit

class MultipartForm {
    //codable 데이터 JSON 으로 인코딩
    static func createJSONMultipartData<T: Encodable>(data: T, fieldName: String) -> MultipartFormData? {
        do {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = .prettyPrinted // JSON 예쁘게 출력
            let jsonData = try jsonEncoder.encode(data)
            
            return MultipartFormData(
                provider: .data(jsonData),
                name: fieldName
            )
        } catch {
            print("⚠️ Failed to encode JSON: \(error.localizedDescription)")
            return nil
        }
    }
    
    //이미지 하나 추가
    static func createImageMultipartData(image: UIImage, fieldName: String) -> MultipartFormData? {
        if let imageData = image.jpegData(compressionQuality: 0.2) {
            return MultipartFormData(
                provider: .data(imageData),
                name: fieldName,
                fileName: "image.jpg",
                mimeType: "image/jpeg"
            )
        }
        return nil
    }
    
    static func createMultiImageMultipartData(images: [UIImage], fieldName: String) -> MultipartFormData? {
        for (index, image) in images.enumerated() {
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                    return MultipartFormData(
                        provider: .data(imageData),
                        name: fieldName,
                        fileName: "image\(index).jpg",
                        mimeType: "image/jpeg"
                )
            }
        }
        return nil
    }
}
