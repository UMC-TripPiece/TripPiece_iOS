// Copyright © 2024 TripPiece. All rights reserved

import UIKit

class VisitRecordsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var visitRecords: [ColorVisitRecord] = []
    
    
    
    // MARK: - UI Components
    // 테이블 뷰 생성
    let tableView = UITableView()

    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // 뷰의 기본 설정
        view.backgroundColor = UIColor(hex: "#F7F7F7")
        self.title = "방문 기록"
        // 네비게이션 바의 appearance 설정
        configureNavigationBarAppearance(backgroundColor: .white, titleColor: .black)

        setUpBackButton()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 테이블 뷰 밑 흰 공간 제거
        setUpFooterView()
    }
    
    
    
    // MARK: - UI Methods
    func setUpBackButton() {
        // 커스텀 백 버튼 이미지 설정
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "backButton"), for: .normal)  // 백 버튼에 사용할 이미지
        backButton.tintColor = Constants.Colors.bg3
        backButton.sizeToFit()  // 버튼 크기 맞춤
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        // UIBarButtonItem으로 설정
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    

    
    
    func setUpFooterView() {
        // 화면 높이
        let screenHeight = view.frame.height
        // 테이블 뷰의 콘텐츠 높이
        let tableViewContentHeight = tableView.contentSize.height
        // 남은 공간 계산
        let remainingHeight = max(0, screenHeight - tableViewContentHeight)
        // 테이블 뷰의 푸터 뷰를 설정하여 빈 공간 색상 변경
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: remainingHeight))
        footerView.backgroundColor = UIColor(hex: "#F7F7F7")
        tableView.tableFooterView = footerView
    }
    
    

    func setupTableView() {
        // 테이블 뷰 델리게이트 및 데이터 소스 설정
        tableView.delegate = self
        tableView.dataSource = self
        
        // 테이블 뷰의 스타일 설정
        tableView.tableFooterView = UIView() // 빈 셀 제거
        tableView.separatorStyle = .none
        
        // 테이블 뷰에 사용할 셀 등록
        tableView.register(VisitRecordCell.self, forCellReuseIdentifier: "VisitRecordCell")
        
        // 테이블 뷰를 뷰에 추가
        view.addSubview(tableView)
        
        // 오토레이아웃 설정
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    
    @objc func backButtonTapped() {
        // 뒤로 가기 액션
        navigationController?.popViewController(animated: true)
    }
    
    
    
    

    // UITableViewDataSource 메서드들
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visitRecords.count // 실제 데이터에 따라 변경
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VisitRecordCell", for: indexPath) as! VisitRecordCell
        /*
        let visitData = visitRecords[indexPath.row]
        let cityName = visitData.
        let countryName = visitData.countryName
        let countryColor = visitData.color
        let countryEmoji = countryEmojis[countryName] ?? ""
        

                    
        // 셀에 데이터 설정
        cell.configure(countryName: "\(cityName), \(countryName)", flagEmoji: countryEmoji, puzzleColor: countryColor) // 실제 데이터 사용
        
        cell.cityData = ["cityName": cityName, "countryName": countryName, "countryImage": countryEmoji]
        
        cell.buttonAction = { [weak self] data in
            guard let self = self else { return }
            // 여기서 데이터를 다른 ViewController에 전달하며 이동
            
            let coloringVC = ColoringVC()
            coloringVC.modalPresentationStyle = .overCurrentContext
            coloringVC.modalTransitionStyle = .crossDissolve
            coloringVC.cityData = ["cityName": cityName, "countryName": countryName, "countryImage": countryEmoji]
            present(coloringVC, animated: true, completion: nil)
        }*/
        
        return cell
    }

    // UITableViewDelegate 메서드들 (셀 선택 등 추가)
    /*func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // 셀 선택시의 동작 추가
    }*/
}






// MARK: - Extension
extension VisitRecordsVC {
    func configureNavigationBarAppearance(backgroundColor: UIColor, titleColor: UIColor) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = backgroundColor
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: titleColor]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}

