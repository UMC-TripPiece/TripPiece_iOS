// Copyright © 2024 TripPiece. All rights reserved

import UIKit

extension WorldVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mapView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        // 확대 끝나고 해상도 높이기
        mapView.contentScaleFactor = scrollView.zoomScale+3
    }
    
    
    /// 나라별 zoom in 메소드
    func focusOnCountry(with country: CountryEnum) {
        print("focusOnCountry: \(country)")
        let scrollViewSize = scrollView.bounds.size
        guard let countryBounds = mapView.getCountryBounds(country: country) else { return }
        
        let zoomScaleX = scrollViewSize.width / countryBounds.width
        let zoomScaleY = scrollViewSize.height / countryBounds.height
        let newZoomScale = min(zoomScaleX, zoomScaleY, scrollView.maximumZoomScale)
        
        scrollView.setZoomScale(newZoomScale, animated: true)
        mapView.contentScaleFactor = scrollView.zoomScale
        
        let offsetX = (countryBounds.midX * newZoomScale) - (scrollViewSize.width / 2)
        let offsetY = (countryBounds.midY * newZoomScale) - (scrollViewSize.height / 2)
        
        let newContentOffset = CGPoint(x: max(offsetX, 0), y: max(offsetY, 0))
        
        // Animate the zoom scale and content offset
        UIView.animate(withDuration: 1.2, delay: 0.3, options: .curveEaseInOut, animations: {
            self.scrollView.setZoomScale(newZoomScale, animated: false) // Disable default animation
            self.scrollView.setContentOffset(newContentOffset, animated: false) // Smooth scroll with animation block
        }, completion: { _ in
            // Ensure the content scale factor is updated after animation
            self.mapView.contentScaleFactor = self.scrollView.zoomScale
        })
    }
}
