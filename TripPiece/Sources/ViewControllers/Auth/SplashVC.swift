// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import SnapKit

class SplashVC: UIViewController {
    
    let tokenPlugin = BearerTokenPlugin()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "splashView"))
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 현재 뷰 컨트롤러가 내비게이션 컨트롤러 안에 있는지 확인
        if self.navigationController == nil {
            // 네비게이션 컨트롤러가 없으면 새로 설정
            let navController = UINavigationController(rootViewController: self)
            navController.modalPresentationStyle = .fullScreen
            
            // 현재 창의 rootViewController 교체
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = navController
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
            }
        }
        setupSplashScreen()
        setConstraints()
        
//        SelectLoginTypeVC.keychain.clear()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.tokenPlugin.checkAuthenticationStatus { token in
                if let token = token {
                    self.navigateToMainScreen()
                } else {
                    self.navigateToSignUpScreen()
                }
            }
        }
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
        let SelectLoginTypeVC = SelectLoginTypeVC()
        navigationController?.pushViewController(SelectLoginTypeVC, animated: true)
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
