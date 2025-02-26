// Copyright © 2024 TripPiece. All rights reserved

import Foundation
import UIKit

// UIViewController extionsion
extension UIViewController {
    private static let loadingIndicatorTag = 999

    /// 로딩 인디케이터 표시
    func showLoadingIndicator() {
        DispatchQueue.main.async {
            if let _ = self.view.viewWithTag(UIViewController.loadingIndicatorTag) {
                return
            }

            let indicator = UIActivityIndicatorView(style: .large)
            indicator.center = self.view.center
            indicator.tag = UIViewController.loadingIndicatorTag
            indicator.hidesWhenStopped = true
            indicator.startAnimating()

            self.view.addSubview(indicator)
        }
    }

    /// 로딩 인디케이터 숨김
    func hideLoadingIndicator() {
        DispatchQueue.main.async {
            if let indicator = self.view.viewWithTag(UIViewController.loadingIndicatorTag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
}
