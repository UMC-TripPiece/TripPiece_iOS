// Copyright © 2024 TripPiece. All rights reserved

import Foundation
import UIKit

class PuzzleManager {
    static let shared = PuzzleManager()
    
    private init() { }
    
    
    private func cropImageToMatchMask(image: UIImage, maskSize: CGSize) -> UIImage? {
        let imageSize = image.size
        
        let imageAspectRatio = imageSize.width / imageSize.height
        let maskAspectRatio = maskSize.width / maskSize.height
        
        var cropRect: CGRect
        
        if imageAspectRatio > maskAspectRatio {
            // 이미지가 더 넓은 경우: 양 옆을 잘라냄
            let newWidth = imageSize.height * maskAspectRatio
            let xOffset = (imageSize.width - newWidth) / 2
            cropRect = CGRect(x: xOffset, y: 0, width: newWidth, height: imageSize.height)
        } else {
            // 이미지가 더 높은 경우: 위아래를 잘라냄
            let newHeight = imageSize.width / maskAspectRatio
            let yOffset = (imageSize.height - newHeight) / 2
            cropRect = CGRect(x: 0, y: yOffset, width: imageSize.width, height: newHeight)
        }
        
        guard let croppedCGImage = image.cgImage?.cropping(to: cropRect) else {
            return nil
        }
        
        return UIImage(cgImage: croppedCGImage)
    }

    private func maskImage(image: UIImage, withMask maskImage: UIImage) -> UIImage? {
        guard let croppedImage = cropImageToMatchMask(image: image, maskSize: maskImage.size) else {
            return nil
        }

        let imageReference = croppedImage.cgImage
        let maskReference = maskImage.cgImage
        
        guard let mask = CGImage(maskWidth: maskReference!.width,
                                 height: maskReference!.height,
                                 bitsPerComponent: maskReference!.bitsPerComponent,
                                 bitsPerPixel: maskReference!.bitsPerPixel,
                                 bytesPerRow: maskReference!.bytesPerRow,
                                 provider: maskReference!.dataProvider!,
                                 decode: nil,
                                 shouldInterpolate: false) else {
            return nil
        }

        guard let maskedReference = imageReference!.masking(mask) else {
            return nil
        }

        return UIImage(cgImage: maskedReference)
    }

    func createPuzzlePiece(image: UIImage, mask: UIImage) -> UIImageView {
        guard let blackMaskedImage = convertToBlackAndWhiteAndInvert(image: mask) else { return UIImageView() }
        guard let maskedImage = maskImage(image: image, withMask: blackMaskedImage) else { return UIImageView() }
        let imageView = UIImageView(image: maskedImage)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }
    
    private func convertToBlackAndWhiteAndInvert(image: UIImage, threshold: CGFloat = 0.5) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        
        let width = cgImage.width
        let height = cgImage.height
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapInfo = CGImageAlphaInfo.none.rawValue
        
        guard let context = CGContext(data: nil,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: 8,
                                      bytesPerRow: width,
                                      space: colorSpace,
                                      bitmapInfo: bitmapInfo) else {
            return nil
        }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let pixelBuffer = context.data else { return nil }
        
        let thresholdValue = UInt8(threshold * 255)
        
        for y in 0..<height {
            for x in 0..<width {
                let pixelIndex = y * width + x
                let pixel = pixelBuffer.load(fromByteOffset: pixelIndex, as: UInt8.self)
                // 새로운 픽셀 값을 반전시킴
                let newPixel: UInt8 = pixel > thresholdValue ? 0 : 255
                pixelBuffer.storeBytes(of: newPixel, toByteOffset: pixelIndex, as: UInt8.self)
            }
        }
        
        guard let outputCGImage = context.makeImage() else { return nil }
        return UIImage(cgImage: outputCGImage)
    }
}
