// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import SnapKit

class SplashVC: UIViewController {
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "splashView"))
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSplashScreen()
        setConstraints()
    }
    
    private func setupSplashScreen() {
        view.addSubview(backgroundImageView)
    }

    func navigateToMainScreen() {
        let tabBarController = TabBar()
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = scene.windows.first {
            window.rootViewController = tabBarController
            window.makeKeyAndVisible()
        }
    }
    
    func navigateToSignUpScreen() {
        let signUpVC = SignUpVC()
        signUpVC.modalPresentationStyle = .fullScreen
        present(signUpVC, animated: true, completion: nil)
    }
    
    func setConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-UIScreen.main.bounds.height * 0.1)
            make.bottom.equalToSuperview().offset(UIScreen.main.bounds.height * 0.1)
            make.leading.equalToSuperview().offset(-UIScreen.main.bounds.width * 0.1)
            make.trailing.equalToSuperview().offset(UIScreen.main.bounds.width * 0.1)
        }
    }
}
