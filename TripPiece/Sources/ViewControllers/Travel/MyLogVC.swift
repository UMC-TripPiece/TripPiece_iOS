// Copyright © 2024 TripPiece. All rights reserved

import Foundation
import UIKit
import SnapKit
import GoogleMaps

//TODO: 여행조각 최신순 sorting 확인 필요

class MyLogVC: UIViewController {
    private lazy var navBar: GradientNavigationBar = {
        return GradientNavigationBar(title: "여행자님의 기록")
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.bg2
        return view
    }()
    
    private lazy var mapView: GMSMapView = {
        let options = GMSMapViewOptions()
        options.camera = GMSCameraPosition(latitude: 37.5665, longitude: 126.9780, zoom: 6.0)
        options.frame = .zero
        
        let mapView = GMSMapView(options: options)
        return mapView
    }()
    
    private lazy var progressTravelSectionTitle: UILabel = {
        let label = UILabel()
        label.text = "진행 중인 여행"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.isHidden = true
        return label
    }()
    
    private lazy var progressTravelCard: ProgressTravelLogCardCell = {
        let card = ProgressTravelLogCardCell()
        card.isHidden = true // 기본값 설정
        return card
    }()
    
    private lazy var tripSectionTitle: UILabel = {
        let label = UILabel()
        label.text = "생성된 여행기"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private lazy var travelLogScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var travelLogStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 여행한 나라가 없어요."
        label.textColor = Constants.Colors.black3
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.isHidden = true // 초기에는 숨김 처리
        return label
    }()
    
    private lazy var historyTitle: UILabel = {
        let label = UILabel()
        label.text = "여행자님의 지난 여행 조각"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private lazy var sortScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var latestSortButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("최신순", for: .normal)
        button.setTitleColor(Constants.Colors.black3, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        //        button.addTarget(self, action: #selector(updateSelectedFilterButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var oldestSortButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("오래된 순", for: .normal)
        button.setTitleColor(Constants.Colors.black3, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        //        button.addTarget(self, action: #selector(updateSelectedFilterButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var sortStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private lazy var tripPieceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var emptyPieceLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 기록한 조각이 없어요."
        label.textColor = Constants.Colors.black3
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.isHidden = true // 초기에는 숨김 처리
        return label
    }()
    
    let allButton = PieceSortButton(title: "전체", tag: 0, target: self, action: #selector(filterButtonTapped(_:)))
    let photoButton = PieceSortButton(title: "📷 사진", tag: 1, target: self, action: #selector(filterButtonTapped(_:)))
    let videoButton = PieceSortButton(title: "🎬 영상", tag: 2, target: self, action: #selector(filterButtonTapped(_:)))
//    let musicButton = PieceSortButton(title: "🎶 음악", tag: 3, target: self, action: #selector(filterButtonTapped(_:)))
    let memoButton = PieceSortButton(title: "✍🏻 메모", tag: 4, target: self, action: #selector(filterButtonTapped(_:)))
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus")?.withTintColor(Constants.Colors.black5 ?? .blue, renderingMode: .alwaysOriginal),for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor(named: "Main")
        button.layer.cornerRadius = 30
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowRadius = 5
        button.addTarget(self, action: #selector(startTravel), for: .touchUpInside)
        return button
    }()
    
    var fetchedTravelsInfo: [TravelsInfo] = []
    var onGoingTravelsInfo: TravelsInfo?
    var allPiece: [TripPieceInfo] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MyLogManager.fetchTravelsInfo { result in
            switch result {
            case .success(let TravelsInfo):
                    self.fetchedTravelsInfo = TravelsInfo.result // 데이터를 저장
                print(self.fetchedTravelsInfo)
                    self.updateTravelLogStackView()
                    self.updateGoogleMap()
            case .failure(let error):
                print("Error occurred: \(error.localizedDescription)")
            }
            MyLogManager.fetchTripPieceInfo { result in
                switch result {
                case .success(let TripPieceInfo):
                    self.allPiece = TripPieceInfo.result
                    self.updateTripPieceStackView(items: self.allPiece)
                case .failure(let error):
                    print("Error occurred: \(error.localizedDescription)")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupGestures()
        updateSelectedFilterButton(selectedButton: allButton)
    }
    
    func setupView() {
        
        scrollView.delaysContentTouches = false
        scrollView.canCancelContentTouches = true
        view.backgroundColor = Constants.Colors.bg2
        [navBar, scrollView, addButton].forEach {
            view.addSubview($0)
        }
        scrollView.addSubview(contentView)
        travelLogScrollView.addSubview(travelLogStackView)
        travelLogScrollView.addSubview(emptyStateLabel)
        [allButton, photoButton, videoButton, /*musicButton,*/ memoButton].forEach {
            sortStackView.addArrangedSubview($0)
        }
        sortScrollView.addSubview(sortStackView)
        tripPieceStackView.addSubview(emptyPieceLabel)
        [mapView, progressTravelSectionTitle, progressTravelCard, tripSectionTitle, travelLogScrollView, historyTitle, sortScrollView, tripPieceStackView].forEach {
            contentView.addSubview($0)
        }
        
    }
    
    func setupConstraints() {
        navBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(107)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        mapView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        progressTravelSectionTitle.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
        }
        progressTravelCard.snp.makeConstraints { make in
            make.top.equalTo(progressTravelSectionTitle.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(90)
        }
        tripSectionTitle.snp.makeConstraints { make in
            make.top.equalTo(progressTravelCard.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
        }
        travelLogScrollView.snp.makeConstraints { make in
            make.top.equalTo(tripSectionTitle.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(240)
        }
        travelLogStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.trailing.top.bottom.equalToSuperview()
            make.height.equalToSuperview()
        }
        emptyStateLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        historyTitle.snp.makeConstraints { make in
            make.top.equalTo(travelLogScrollView.snp.bottom)
            make.leading.equalToSuperview().offset(16)
        }
        sortScrollView.snp.makeConstraints { make in
            make.top.equalTo(historyTitle.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        sortStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalToSuperview()
        }
        tripPieceStackView.snp.makeConstraints { make in
            make.top.equalTo(sortScrollView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-40)  // 마지막 요소이므로 아래 여백 설정
        }
        emptyPieceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
        }
        addButton.snp.makeConstraints { make in
            make.width.height.equalTo(63)
            make.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(40)
        }
    }
    
    func setupGestures() {
        let progressTravelGesture = UITapGestureRecognizer(target: self, action: #selector(getProgressTravel))
        progressTravelCard.addGestureRecognizer(progressTravelGesture)
        progressTravelCard.isUserInteractionEnabled = true
    }
    
    // MARK: func 세팅
    @objc private func startTravel() {
        //TODO: 여행기 생성 클릭 시 넘어가는 뷰
        let viewController = StartLogVC()
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    
    
    @objc private func getProgressTravel() {
        guard let tabBarController = self.tabBarController else {
            print("TabBarController is nil")
            return
        }
        tabBarController.selectedIndex = 1 // MyLogVC가 두 번째 탭이므로 index 1
            
        // 선택된 탭의 네비게이션 컨트롤러 가져오기
        if let navigationController = tabBarController.selectedViewController as? UINavigationController {
            let viewController = OngoingLogVC()
            viewController.travelsInfo = onGoingTravelsInfo
            navigationController.pushViewController(viewController, animated: true)
        }
//        let viewController = OngoingLogVC()
//        viewController.modalPresentationStyle = .fullScreen
//        self.present(viewController, animated: true, completion: nil)
    }
    
    func updateTravelLogStackView() {
        travelLogStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        if fetchedTravelsInfo.isEmpty {
            // 데이터가 없을 때
            emptyStateLabel.isHidden = false
            travelLogStackView.isHidden = true
        } else {
            // 데이터가 있을 때
            emptyStateLabel.isHidden = true
            travelLogStackView.isHidden = false

            for TravelsInfo in fetchedTravelsInfo.reversed() {
                let cell = TravelLogCardCell()
                let title = "\(TravelsInfo.countryImage) \(TravelsInfo.title)"
                let date = "\(TravelsInfo.startDate) ~ \(TravelsInfo.endDate)"
                let location = "\(TravelsInfo.cityName), \(TravelsInfo.countryName)"
                cell.configure(id: TravelsInfo.id, imageURL: TravelsInfo.thumbnail, title: title, date: date, subtitle: location, isONGOING: TravelsInfo.status)
                cell.mainButton.addTarget(self, action: #selector(onClickCell(sender: )), for: .touchUpInside)
                travelLogStackView.addArrangedSubview(cell)
                
                if TravelsInfo.status == "ONGOING" {
                    self.onGoingTravelsInfo = TravelsInfo
                    progressTravelSectionTitle.isHidden = false
                    progressTravelCard.isHidden = false
                    let daysElapsed = calculateDaysElapsed(from: TravelsInfo.startDate)
                    let subtitle = "Day \(daysElapsed)"
                    let title = "[\(TravelsInfo.cityName)] \(TravelsInfo.title)"
                    self.progressTravelCard.configure(imageURL: TravelsInfo.thumbnail, title: title, date: date, subtitle: subtitle)
                    
                }
            }
        }
        updateLayoutForProgressTravelCardVisibility()
        travelLogScrollView.setNeedsLayout()
        travelLogScrollView.layoutIfNeeded()
    }
    
    @objc private func onClickCell(sender: UIButton) {
        let vc = UINavigationController(rootViewController: FinishPuzzleVC(travelId: sender.tag))
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    private func updateGoogleMap() {
        mapView.clear()
        
        for (index, travelsInfo) in fetchedTravelsInfo.enumerated() {
            MyLogManager.fetchGeocoding(country: travelsInfo.countryName, city: travelsInfo.cityName) { [weak self] result in
                switch result {
                case .success(let geocodingResponse):
//                    print(geocodingResponse)
                    if let result = geocodingResponse.results.first {
                        self?.appendMarker(position: CLLocationCoordinate2D(latitude: result.geometry.location.lat, longitude: result.geometry.location.lng), imageURL: travelsInfo.thumbnail, zIndex: index)
                    }
                case .failure(let error):
                    print("Not Found: \(travelsInfo.countryName), \(travelsInfo.cityName)")
                    print("Status: \(travelsInfo.status)")
                    print("Error occurred: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func appendMarker(position: CLLocationCoordinate2D, imageURL: String, zIndex: Int) {
        let marker = GMSMarker(position: position)
        marker.map = mapView
        marker.zIndex = Int32(zIndex)
        marker.iconView = MarkerView(frame: CGRect(x: 0, y: 0, width: 32, height: 32), imageURL: imageURL)
    }
    
    func updateLayoutForProgressTravelCardVisibility() {
        if progressTravelSectionTitle.isHidden && progressTravelCard.isHidden {
            tripSectionTitle.snp.remakeConstraints { make in
                make.top.equalTo(mapView.snp.bottom).offset(16)
                make.leading.equalToSuperview().offset(16)
            }
        } else {
            tripSectionTitle.snp.remakeConstraints { make in
                make.top.equalTo(progressTravelCard.snp.bottom).offset(16)
                make.leading.equalToSuperview().offset(16)
            }
        }
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    func updateTripPieceStackView(items: [TripPieceInfo]) { //여행 조각 관련 함수
        tripPieceStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if allPiece.isEmpty {
            // 데이터가 없을 때
            emptyPieceLabel.isHidden = false
        } else {
            // 데이터가 있을 때
            emptyPieceLabel.isHidden = true
            
            for item in items.reversed() {
                let cell = PieceCell()
                let formattedDate = formatDate(from: item.createdAt)!
                let location = "\(item.cityName), \(item.countryName)"
                cell.configure(type: item.category, mediaURL: item.mediaUrl ?? "", memo: item.memo ?? "", createdAt: formattedDate, location: location)
                tripPieceStackView.addArrangedSubview(cell)
            }
        }
    }
    
    //TODO: 최신순 sorting 추가
    func updateSelectedFilterButton(selectedButton: PieceSortButton) {
        let buttons = [allButton, photoButton, videoButton, /*musicButton,*/ memoButton]
        for button in buttons {
            button.updateSelection(isSelected: button == selectedButton)
        }
    }
    
    @objc func filterButtonTapped(_ sender: UIButton) {
        let selectedType = TravelItemType(rawValue: sender.tag) ?? .all
        let filteredPiece = filterPieces(by: selectedType)
        updateTripPieceStackView(items: filteredPiece)
        
        if let button = sender as? PieceSortButton {
            updateSelectedFilterButton(selectedButton: button)
        }
    }
    
    private func filterPieces(by type: TravelItemType) -> [TripPieceInfo] {
        if type == .all {
            return allPiece
        } else {
            return allPiece.filter { item in
                switch type {
                case .photo:
                    return item.category == "PICTURE"
                case .video:
                    return item.category == "VIDEO"
                case .memo:
                    return item.category == "MEMO"
                case .music:
                    return item.category == "MUSIC"
                default:
                    return false
                }
            }
        }
    }
    
}
