// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import SnapKit

class PuzzleLogVC: UIViewController {
    
    var travelId: Int
    var thumbnails: [UIImage?]
    
    private var travelsDetailInfo: [Int: [TravelsDetailInfo]] = [:]
    private var dayRange: (start: Date, end: Date)?
    private var placeName: String = ""
    
    private var dayIndex: Int = 0
    
    init(travelId: Int, thumbnails: [UIImage?]) {
        self.travelId = travelId
        self.thumbnails = thumbnails
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    private lazy var customNavBar: FinishNavigationBar = {
        let nav = FinishNavigationBar()
        nav.backgroundColor = .white
        return nav
    }()
    
    // 여행기록 제목
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        return label
    }()
    
    // 날짜 레이블
    private lazy var initialDateLabel: UILabel = {
        let label = UILabel()
        label.text = "24.08.12~24.08.16"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(named: "Main")
        return label
    }()
    
    private lazy var dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 4
        
        // 달력 이미지
        let dateImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "calendarImage")
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        dateImageView.snp.makeConstraints{ make in
            make.width.height.equalTo(18)
        }
        
        stackView.addArrangedSubview(dateImageView)
        stackView.addArrangedSubview(initialDateLabel)
        
        return stackView
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(dateStackView)
        
        return stackView
    }()
    
    private lazy var initialCustomNavBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        let dotButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(resource: .dot), for: .normal)
            button.showsMenuAsPrimaryAction = true
            button.menu = UIMenu(options: .displayInline, children: [
                UIAction(title: "조각 사진 수정하기", image: UIImage(resource: .pencil), handler: { [weak self] _ in
                    guard let self = self else { return }
                    let viewController = EditPuzzleVC(travelId: self.travelId)
                    navigationController?.pushViewController(viewController, animated: true)
                })
            ])
            return button
        }()
        
        view.addSubview(titleStackView)
        view.addSubview(dotButton)
        
        dotButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.trailing.equalToSuperview().inset(30)
            make.width.height.equalTo(15)
        }
        titleStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalToSuperview()
        }
        return view
    }()
    
    private lazy var scrolledDateLabel: UILabel = {
        let label = UILabel()
        label.text = "24.08.12"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        label.textColor = UIColor(named: "Main")
        return label
    }()
    
    private lazy var scrolledDayLabel: UILabel = {
        let label = UILabel()
        label.text = "\(dayIndex+1)일차"
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textAlignment = .center
        label.textColor = UIColor(named: "Black1")
        return label
    }()
    
    
    private lazy var scrolledCustomNavBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        let yesterdayButton = UIButton()
        let tomorrowButton = UIButton()
        yesterdayButton.setImage(UIImage(named: "arrowImage2"), for: .normal)
        tomorrowButton.setImage(UIImage(named: "arrowImage"), for: .normal)
        yesterdayButton.addTarget(self, action: #selector(onClickBefore), for: .touchUpInside)
        tomorrowButton.addTarget(self, action: #selector(onClickAfter), for: .touchUpInside)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 12
            
        stackView.addArrangedSubview(scrolledDateLabel)
        stackView.addArrangedSubview(scrolledDayLabel)
        view.addSubview(stackView)
        view.addSubview(yesterdayButton)
        view.addSubview(tomorrowButton)
        
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }
        yesterdayButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.width.equalTo(8)
            make.height.equalTo(17)
        }
        tomorrowButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.width.equalTo(8)
            make.height.equalTo(17)
        }
        
        return view
    }()
    
    private lazy var logTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PuzzleTableViewCell.self, forCellReuseIdentifier: String(describing: PuzzleTableViewCell.self))
        tableView.register(EmojiTableViewCell.self, forCellReuseIdentifier: String(describing: EmojiTableViewCell.self))
        tableView.register(Picture1TableViewCell.self, forCellReuseIdentifier: String(describing: Picture1TableViewCell.self))
        tableView.register(Picture2TableViewCell.self, forCellReuseIdentifier: String(describing: Picture2TableViewCell.self))
        tableView.register(Picture3TableViewCell.self, forCellReuseIdentifier: String(describing: Picture3TableViewCell.self))
        tableView.register(Picture4TableViewCell.self, forCellReuseIdentifier: String(describing: Picture4TableViewCell.self))
        tableView.register(SelfieTableViewCell.self, forCellReuseIdentifier: String(describing: SelfieTableViewCell.self))
        tableView.register(MemoTableViewCell.self, forCellReuseIdentifier: String(describing: MemoTableViewCell.self))
        tableView.register(WhereTableViewCell.self, forCellReuseIdentifier: String(describing: WhereTableViewCell.self))
        tableView.register(VideoTableViewCell.self, forCellReuseIdentifier: String(describing: VideoTableViewCell.self))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        return tableView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        fetchTravelLog(travelId: travelId)
        scrolledCustomNavBar.isHidden = true
        initialCustomNavBar.isHidden = false
        // 뒤로가기 알림 설정
        NotificationCenter.default.addObserver(self, selector: #selector(handleBackButtonTap), name: .backButtonTapped, object: nil)
    }
    
    @objc private func handleBackButtonTap() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupUI() {
        view.addSubview(customNavBar)
        view.addSubview(initialCustomNavBar)
        view.addSubview(scrolledCustomNavBar)
        view.addSubview(logTableView)
        setConstraints()
    }
    
    func setConstraints() {
        customNavBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(48)
        }
        initialCustomNavBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(customNavBar.snp.bottom).offset(30)
        }
        scrolledCustomNavBar.snp.makeConstraints { make in
            make.top.equalTo(initialCustomNavBar.snp.top)
            make.bottom.equalTo(initialCustomNavBar.snp.bottom)
            make.leading.equalTo(initialCustomNavBar.snp.leading)
            make.trailing.equalTo(initialCustomNavBar.snp.trailing)
        }
        logTableView.snp.makeConstraints { make in
            make.top.equalTo(initialCustomNavBar.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    @objc private func onClickBefore() {
        if dayIndex <= 0 {
            return
        }
        dayIndex -= 1
        updateScrolledCustomNavBar()
        logTableView.reloadData()
    }
    @objc private func onClickAfter() {
        if dayIndex >= CalendarManager.shared.daysBetweenDates(from: dayRange?.start, to: dayRange?.end) {
            return
        }
        dayIndex += 1
        updateScrolledCustomNavBar()
        logTableView.reloadData()
    }
    
    //MARK: - GET
    private func fetchTravelLog(travelId: Int) {
        PuzzleLogManager.fetchTravelsInfoDetails(travelId: travelId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let value):
                for travelsDetailInfo in value.result {
                    guard let createdAt: Date = CalendarManager.shared.convertISO8601ToDate(iso8601Date: "\(travelsDetailInfo.createdAt)Z") else { continue }
                    let dayIndex: Int = CalendarManager.shared.daysBetweenDates(from: self.dayRange?.start, to: createdAt)
                    self.travelsDetailInfo[dayIndex, default: []].append(travelsDetailInfo)
                    scrolledCustomNavBar.isHidden = true
                    initialCustomNavBar.isHidden = false
                }
                logTableView.reloadData()
            case .failure(let error):
                print("Error occurred: \(error.localizedDescription)")
            }
        }
    }
    
    func initializeView(endTravelInfo: EndTravelInfo?) {
        guard let endTravelInfo = endTravelInfo else { return }
        guard let startDate: Date = CalendarManager.shared.convertStringToDate(stringDate: endTravelInfo.startDate) else { return }
        guard let endDate: Date = CalendarManager.shared.convertStringToDate(stringDate: endTravelInfo.endDate) else { return }
        self.dayRange = (start: startDate, end: endDate)
        titleLabel.text = endTravelInfo.title
        initialDateLabel.text = "\(endTravelInfo.startDate)~\(endTravelInfo.endDate)"
        placeName = "\(endTravelInfo.countryImage)\(endTravelInfo.city), \(endTravelInfo.country)"
        
    }
    private func updateScrolledCustomNavBar() {
        guard let dayRange = dayRange else { return }
        scrolledDateLabel.text = Calendar.current.date(byAdding: .day, value: dayIndex, to: dayRange.start)?.toStringYMD
        scrolledDayLabel.text = "\(dayIndex+1)일차"
    }
    
}

extension PuzzleLogVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (travelsDetailInfo[dayIndex] ?? []).count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PuzzleTableViewCell.self), for: indexPath) as? PuzzleTableViewCell else { return UITableViewCell() }
            cell.initializeCell(thumbnails: thumbnails, place: placeName)
            return cell
        }
        
        guard let travelDetailInfo = travelsDetailInfo[dayIndex]?[indexPath.row - 1] else {
            return UITableViewCell()
        }
        switch travelDetailInfo.category {
        case "PICTURE":
            switch travelDetailInfo.mediaUrls?.count {
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: Picture1TableViewCell.self), for: indexPath) as? Picture1TableViewCell else { return UITableViewCell() }
                cell.initializeCell(travelsDetailInfo: travelDetailInfo)
                return cell
            case 2:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: Picture2TableViewCell.self), for: indexPath) as? Picture2TableViewCell else { return UITableViewCell() }
                cell.initializeCell(travelsDetailInfo: travelDetailInfo)
                return cell
            case 3:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: Picture3TableViewCell.self), for: indexPath) as? Picture3TableViewCell else { return UITableViewCell() }
                cell.initializeCell(travelsDetailInfo: travelDetailInfo)
                return cell
            case 4:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: Picture4TableViewCell.self), for: indexPath) as? Picture4TableViewCell else { return UITableViewCell() }
                cell.initializeCell(travelsDetailInfo: travelDetailInfo)
                return cell
            default:
                break
            }
            
        case "SELFIE":
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SelfieTableViewCell.self), for: indexPath) as? SelfieTableViewCell else { return UITableViewCell() }
            cell.initializeCell(travelsDetailInfo: travelDetailInfo)
            return cell
        case "VIDEO":
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: VideoTableViewCell.self), for: indexPath) as? VideoTableViewCell else { return UITableViewCell() }
            cell.initializeCell(travelsDetailInfo: travelDetailInfo)
            return cell
        case "WHERE":
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WhereTableViewCell.self), for: indexPath) as? WhereTableViewCell else { return UITableViewCell() }
            cell.initializeCell(travelsDetailInfo: travelDetailInfo)
            return cell
        case "MEMO":
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MemoTableViewCell.self), for: indexPath) as? MemoTableViewCell else { return UITableViewCell() }
            cell.initializeCell(travelsDetailInfo: travelDetailInfo)
            return cell
        case "EMOJI":
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EmojiTableViewCell.self), for: indexPath) as? EmojiTableViewCell else { return UITableViewCell() }
            cell.initializeCell(travelsDetailInfo: travelDetailInfo)
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrolledCustomNavBar.isHidden = false
        initialCustomNavBar.isHidden = true
    }
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return travelsDetailInfo[dayIndex]?.count ?? 0 == 0 ? tableView.frame.height : 0
//    }
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let view = UIView()
//        return view
//    }
}
