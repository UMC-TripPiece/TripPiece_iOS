// Copyright © 2024 TripPiece. All rights reserved

import UIKit

extension UINavigationController {
    
    func replaceViewController(viewController: UIViewController, animated:Bool) {
        viewControllers.removeLast()
        viewControllers.append(viewController)
        setViewControllers(viewControllers, animated: animated)
    }
}
