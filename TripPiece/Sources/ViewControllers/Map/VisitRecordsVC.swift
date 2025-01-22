// Copyright © 2024 TripPiece. All rights reserved

import UIKit

class VisitRecordsVC: UIViewController, VisitRecordCellDelegate {
    
    
    var userId: Int?
    var colorRecords: [ColorVisitRecord] = []
    var cityIds: [Int] = []
    
    
    // MARK: - UI Components
    // 테이블 뷰 생성
    private lazy var tableView = UITableView()
    
    // 기존 테이블 뷰를 컬렉션 뷰로 변경
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical // 세로 스크롤
        layout.minimumLineSpacing = 16 // 셀 간 간격
        layout.minimumInteritemSpacing = 0 // 아이템 간 간격
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(hex: "#F9F9F9")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = true
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(VisitRecordCell.self, forCellWithReuseIdentifier: VisitRecordCell.identifier)
        return collectionView
    }()
    
    
    
    private lazy var customNavBar = UIView()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // 뷰의 기본 설정
        view.backgroundColor = .white
        view.addSubview(customNavBar)
        view.addSubview(collectionView) // superview가 nil인지 확인
        setupCollectionView()
        setupCustomNavigationBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleCollectionViewUpdate), name: .updateCollectionView, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        updateColor()
    }
    
    
    // MARK: - UI Methods
    private func setupCustomNavigationBar() {
        // Custom Navigation Bar 설정
        customNavBar.backgroundColor = .white // 원하는 색상 설정
        
        // navigation bar
        customNavBar.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(50)
        }
        
        // 타이틀 Label 추가
        let titleLabel = UILabel()
        titleLabel.text = "방문 기록"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        customNavBar.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        // Back 버튼 추가
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        backButton.tintColor = UIColor(named: "Black3")
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        customNavBar.addSubview(backButton)
        
        backButton.snp.makeConstraints { make in
            make.width.equalTo(16.5)
            make.height.equalTo(17)
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
    }
    
    private func setupCollectionView() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(customNavBar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
    }
    
    @objc private func handleCollectionViewUpdate() {
        guard let userId = userId else { return }
        getCountryColorsData(userId) { colorInfo in
            guard let colorInfo = colorInfo else { return }
            self.colorRecords = colorInfo
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
        
    private func updateColor() {
        guard let userId = userId else { return }
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        getCountryStatsData(userId) { data in
            if let data = data {
                self.cityIds = data.cityIds
            }
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        getCountryColorsData(userId) { data in
            if let data = data {
                self.colorRecords = data
            }
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            self.collectionView.reloadData()
        }
    }


    
    
    // 특정 countryCode에 대한 최신 색상 찾기
    func getLatestColor(for countryCode: String) -> String? {
        for record in colorRecords.reversed() { // 최신 순으로 순회
            if record.countryCode == countryCode {
                return record.color
            }
        }
        return nil
    }
    
    
    @objc func backButtonTapped() {
        // 뒤로 가기 액션
        navigationController?.popViewController(animated: true)
    }
    
    
    // 색깔 수정/삭제
    func didTapEditButton(at indexPath: IndexPath) {
        let cityId = cityIds[indexPath.row]
        guard let cityName = CityEnum.find(byId: cityId) else { return }
        let countryCode = cityName.country.rawValue
        guard let countryColor = getLatestColor(for: countryCode) else { return }
        
        let editColorVC = ColoringVC()
        editColorVC.modalPresentationStyle = .overCurrentContext
        editColorVC.modalTransitionStyle = .crossDissolve
        editColorVC.cityData = SearchedCityResponse(cityName: cityName.rawValue, countryName: cityName.country.name, cityDescription: "", countryImage: cityName.country.emoji, logCount: 0, cityId: cityId)
        editColorVC.userId = userId
        present(editColorVC, animated: true, completion: nil)
    }
    
    func didTapDeleteButton(at indexPath: IndexPath) {
        guard let userId = userId else { return }
        let cityId = cityIds[indexPath.row]
        guard let result = CityEnum.find(byId: cityId) else { return }
        let countryCode = result.country.rawValue
        guard let countryColor = getLatestColor(for: countryCode) else { return }
        deleteColor(countryCode: countryCode, cityId: cityId, color: countryColor) { result in
            switch result {
            case .success(let message):
                print("삭제 성공: \(message)")
                NotificationCenter.default.post(name: .deleteMapColor, object: nil, userInfo: ["deletedItem": countryCode])
                self.cityIds.removeAll { $0 == cityId }
                self.getCountryColorsData(userId) { colorInfo in
                    guard let colorInfo = colorInfo else { return }
                    self.colorRecords = colorInfo
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData() // 데이터 업데이트 후 리로드
                }
            case .failure(let error):
                print("오류 발생: \(error.localizedDescription)")
            }
        }
    }
    
    
    
    
    //MARK: API call
    func deleteColor(countryCode: String, cityId: Int, color: String, completion: @escaping (Result<Any, Error>) -> Void) {
        guard let userId = userId else { return }

        let data = MapRequest(
            userId: userId,
            countryCode: "\(countryCode)",
            color: color,
            cityId: cityId
        )
        print("deleteColor - 보내는 정보: \(data)")
        
        MapManager.deleteCountryColor(data) { isSuccess, response in
            if isSuccess {
                completion(.success("color deletion successful"))
            } else {
                if let data = response?.data,  // 서버 응답 데이터 확인
                   let errorMessage = String(data: data, encoding: .utf8) {
                        print("서버 에러 메시지: \(errorMessage)")
                }
                        
                let error = NSError(domain: "MapError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Color update failed."])
                completion(.failure(error))
            }
        }
    }
    
    func getCountryColorsData(_ userId: Int, completion: @escaping ([ColorVisitRecord]?) -> Void) {
        MapManager.getCountryColors(userId: userId) { result in
            switch result {
            case .success(let colorInfo):
                completion(colorInfo.result)
            case .failure(let error):
                print("color 오류 발생: \(error.localizedDescription)")
                completion([])
            }
        }
    }
    
    func getCountryStatsData(_ userId: Int, completion: @escaping (StatsVisitRecord?) -> Void) {
        MapManager.getCountryStats(userId: userId) { result in
            switch result {
            case .success(let statsInfo):
                print("나라 stats data: \(statsInfo.result)")
                completion(statsInfo.result)
            case .failure(let error):
                print("오류 발생: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .updateCollectionView, object: nil)
    }

    
    
}

extension VisitRecordsVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cityIds.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VisitRecordCell.identifier, for: indexPath) as! VisitRecordCell
        
        let cityIdData = cityIds[indexPath.row]
        guard let result = CityEnum.find(byId: cityIdData) else { return cell }

        let cityName = result.rawValue
        let countryName = result.country.name
        let countryEmoji = result.country.emoji
        let countryCode = result.country.rawValue
        
        let countryColor = getLatestColor(for: countryCode) ?? "#C0C0C0"
        
        // 셀 구성
        cell.delegate = self
        cell.configure(countryName: "\(cityName), \(countryName)", flagEmoji: countryEmoji, puzzleColor: countryColor)
        cell.cityData = ["cityName": cityName, "countryName": countryName, "countryImage": countryEmoji]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 98) // 셀 크기
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16 // 셀 간 간격
    }
}

    

    


