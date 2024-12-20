import UIKit

class TabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
        appearance()
    }
    
    func setTabBar() {
        //TODO:여기서 월드 부분 뭐시기 컨트롤러? 뭐 그런걸로 해야 스유랑 연결됨
        let vc1 = UINavigationController(rootViewController: TestVC())
        vc1.tabBarItem = UITabBarItem(title: "월드", image: UIImage(named: "World"), tag: 1)
        let vc2 = UINavigationController(rootViewController: MyLogVC())
        vc2.tabBarItem = UITabBarItem(title: "나의 기록", image: UIImage(named: "MyLog"), tag: 2)
        let vc3 = UINavigationController(rootViewController: TestVC())
        vc3.tabBarItem = UITabBarItem(title: "탐색", image: UIImage(named: "Explore"), tag: 3)
        let vc4 = UINavigationController(rootViewController: MyPageVC())
        vc4.tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(named: "User"), tag: 4)
        self.viewControllers = [vc1, vc2, vc3, vc4]
    }
    func appearance() {
        let barAppearance = UITabBarAppearance()
        barAppearance.configureWithOpaqueBackground()
        
        // 아이콘 기본 색상 설정
        barAppearance.stackedLayoutAppearance.normal.iconColor = UIColor(named: "Not selected")
        
        self.tabBar.standardAppearance = barAppearance
        
        self.tabBar.layer.cornerRadius = 20
        self.tabBar.layer.masksToBounds = false
        self.tabBar.tintColor = UIColor(named: "Main")
        self.tabBar.backgroundColor = .white
        
        // 그림자 설정
        self.tabBar.layer.shadowColor = UIColor.black.cgColor
        self.tabBar.layer.shadowOpacity = 0.2
        self.tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        self.tabBar.layer.shadowRadius = 10
        
        // 탭바 아이템 위치 조정
        self.tabBar.itemPositioning = .centered
        self.tabBar.itemSpacing = 55
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var tabFrame = tabBar.frame
        tabFrame.size.height = 100
        tabFrame.origin.y = view.frame.size.height - 100
        tabBar.frame = tabFrame
    }
}
