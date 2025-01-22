// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

class DetailInfoVC: UIViewController {
    
    // MARK: - Properties
    let navigationBarManager = NavigationBarManager()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let contentLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.textColor = Constants.Colors.black2
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    private var itemTitle: String?
    private var itemContent: String?
    
    // MARK: - Initializer
    init(title: String, content: String) {
        super.init(nibName: nil, bundle: nil)
        self.itemTitle = title
        self.itemContent = content
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Colors.bg4
        setupNavigationBar(itemTitleString: itemTitle ?? "앱 정보")
        setupUI()
        configureData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        fixNavigationBarAppearance()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Setup Navigation Bar
    private func setupNavigationBar(itemTitleString: String) {
        // itemTitle을 네비게이션 바 제목으로 설정
        navigationBarManager.setTitle(to: navigationItem, title: itemTitleString, textColor: Constants.Colors.black ?? .black)
        navigationBarManager.addBackButton(to: navigationItem, target: self, action: #selector(backButtonTapped))
    }
    
    private func fixNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Constants.Colors.bg4
        appearance.titleTextAttributes = [.foregroundColor: Constants.Colors.black2!]
        
        appearance.shadowColor = nil
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // 스크롤뷰 계층 구조 추가
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(contentLabel)
        
        // 스크롤뷰 제약 설정
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        // 컨텐츠 뷰 제약 설정
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview() // 수평 스크롤 방지
        }
        
        // 컨텐츠 라벨 제약 설정
        contentLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview() // 컨텐츠 아래 공간 확보
        }
    }
    
    // MARK: - Configure Data
    private func configureData() {
        contentLabel.text = itemContent
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
