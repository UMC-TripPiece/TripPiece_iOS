//
//  SelfieLogViewController.swift
//  MyWorldApp
//
//  Created by 이예성 on 8/19/24.
//

import UIKit
import SnapKit

class PieceVC: UIViewController {
    
    var tripPieceInfo: TripPieceInfo
            
    init(tripPieceInfo: TripPieceInfo) {
        self.tripPieceInfo = tripPieceInfo
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    private lazy var baseView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var customNavBar: CustomNavigationLogoBar = {
        let nav = CustomNavigationLogoBar()
        nav.translatesAutoresizingMaskIntoConstraints = false
        nav.backgroundColor = .white
        return nav
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        let day = CalendarManager.shared.convertISO8601ToDate(iso8601Date: "\(tripPieceInfo.createdAt)Z")?.toStringDetailYMD ?? ""
        let text = "\(day)\n\(tripPieceInfo.cityName), \(tripPieceInfo.countryName)에서의 기록"
        var attributedText = NSMutableAttributedString(string: text)
        let dayRange: NSRange = (text as NSString).range(of: day)
        attributedText.addAttribute(.foregroundColor, value: UIColor(hex: "#FD2D69"), range: dayRange)
        let placeRange: NSRange = (text as NSString).range(of: "\(tripPieceInfo.cityName), \(tripPieceInfo.countryName)")
        attributedText.addAttribute(.foregroundColor, value: UIColor(hex: "#6644FF"), range: placeRange)
        label.attributedText = attributedText
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private lazy var logTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(EmojiTableViewCell.self, forCellReuseIdentifier: String(describing: EmojiTableViewCell.self))
        tableView.register(Picture1TableViewCell.self, forCellReuseIdentifier: String(describing: Picture1TableViewCell.self))
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
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupUI()
        
        // NotificationCenter 관찰자 추가
        NotificationCenter.default.addObserver(self, selector: #selector(handleBackButtonTap), name: .backButtonTapped, object: nil)
        
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        view.addSubview(customNavBar)
        view.addSubview(baseView)
        
        baseView.addSubview(titleLabel)
        baseView.addSubview(logTableView)
        setConstraints()
    }
    
    func setConstraints() {
        customNavBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(48)
        }
        baseView.snp.makeConstraints({ make in
            make.top.equalTo(customNavBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        })
        titleLabel.snp.makeConstraints{ make in
            make.top.equalToSuperview().inset(41)
            make.centerX.equalToSuperview()
        }
        logTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Function
    
    ///뒤로가기 버튼
    @objc private func handleBackButtonTap() {
        navigationController?.popViewController(animated: true)
    }
}

extension PieceVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tripPieceInfo.category {
        case "PICTURE":
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: Picture1TableViewCell.self), for: indexPath) as? Picture1TableViewCell else { return UITableViewCell() }
            cell.initializeCell(tripPieceInfo: tripPieceInfo)
            return cell
        case "SELFIE":
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SelfieTableViewCell.self), for: indexPath) as? SelfieTableViewCell else { return UITableViewCell() }
            cell.initializeCell(tripPieceInfo: tripPieceInfo)
            return cell
        case "VIDEO":
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: VideoTableViewCell.self), for: indexPath) as? VideoTableViewCell else { return UITableViewCell() }
            cell.initializeCell(tripPieceInfo: tripPieceInfo)
            return cell
        case "WHERE":
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WhereTableViewCell.self), for: indexPath) as? WhereTableViewCell else { return UITableViewCell() }
            cell.initializeCell(tripPieceInfo: tripPieceInfo)
            return cell
        case "MEMO":
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MemoTableViewCell.self), for: indexPath) as? MemoTableViewCell else { return UITableViewCell() }
            cell.initializeCell(tripPieceInfo: tripPieceInfo)
            return cell
        case "EMOJI":
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EmojiTableViewCell.self), for: indexPath) as? EmojiTableViewCell else { return UITableViewCell() }
            cell.initializeCell(tripPieceInfo: tripPieceInfo)
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
}
