// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import SnapKit

import UIKit
import SnapKit

class OngoingLogVC: UIViewController {

    // MARK: - 상단(비스크롤 영역)에 들어갈 UI

    // 1) 배경 이미지
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ongoingLogTop")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // 2) 닫기 버튼
    private lazy var xButton: XButton = {
        let button = XButton()
        button.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        return button
    }()
    
    // 3) 여행 요약 뷰
    private lazy var travelSummary: TravelSummaryView = {
        let view = TravelSummaryView()
        view.isHidden = true
        return view
    }()
    
    /**
     배경 + X버튼을 겹쳐놓을 컨테이너
     (배경이 전체를 채우고, 우측 상단에 버튼을 올리는 식)
     */
    private lazy var backgroundContainerView: UIView = {
        let container = UIView()
        
        // 배경 이미지 전부 채움
        container.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.edges.equalToSuperview()
            // 30% 높이 비율 (원하는 값으로 조정)
            make.height.equalTo(UIScreen.main.bounds.height * 0.3)
        }
        
        // travelSummary을 배경 위에 겹쳐서 좌측에
        container.addSubview(travelSummary)
        travelSummary.snp.makeConstraints { make in
            make.centerY.equalTo(container.snp.centerY)
            make.trailing.equalTo(container.snp.trailing).offset(-16)
            make.leading.equalTo(container.snp.leading).offset(16)
        }
        
        // xButton을 배경 위에 겹쳐서 우측 상단에
        container.addSubview(xButton)
        xButton.snp.makeConstraints { make in
            make.centerY.equalTo(travelSummary.snp.centerY).offset(-36)
            make.trailing.equalTo(container.snp.trailing).offset(-16)
            make.width.height.equalTo(25)
        }
        
        return container
    }()
    
    
    
    // MARK: - 스크롤 뷰 및 나머지 UI

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    // 스크롤 콘텐츠를 담는 컨테이너 뷰
    private lazy var contentView: UIView = {
        return UIView()
    }()

    private lazy var recordStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "기록 현황"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = Constants.Colors.mainPurple ?? .purple
        return label
    }()
    
    private lazy var recordProgressView = RecordProgressView()
    
    private lazy var recordMissionLabel: UILabel = {
        let label = UILabel()
        label.text = "기록 남기기"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = Constants.Colors.mainPurple ?? .purple
        return label
    }()
    
    private lazy var missionCell: MissionCell = {
        let cell = MissionCell()
        return cell
    }()
    
    private lazy var recordButtons: [RecordButton] = [
        RecordButton(emoji: "📷", title: "사진", borderColor: Constants.Colors.mainPurple ?? .purple),
        RecordButton(emoji: "🎬", title: "동영상", borderColor: Constants.Colors.mainYellow ?? .yellow),
        RecordButton(emoji: "✍🏻", title: "메모", borderColor: Constants.Colors.mainPink ?? .systemPink),
        RecordButton(emoji: "😁", title: "이모지", borderColor: Constants.Colors.mainPink ?? .systemPink)
    ]
    
    private lazy var endTripButton = EndTripButton()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        fetchTravelSummary()
        configureMissionCell()
        configureRecordButtons()
        
        // 뒤로 버튼 숨기기
        navigationItem.hidesBackButton = true
    }

    // MARK: - UI Setup

    private func setupUI() {
        
        // (1) topStackView(배경+버튼+travelSummary) 먼저 추가
        view.addSubview(backgroundContainerView)
        backgroundContainerView.snp.makeConstraints { make in
            // SafeArea 상단에 붙이고, 좌우는 화면 끝까지
            make.top.equalToSuperview()
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        // (2) 스크롤 뷰는 그 아래
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(backgroundContainerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        // (3) 스크롤 내부 컨텐츠
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }

        // (4) contentView에 나머지 UI 요소 배치
        contentView.addSubview(recordStatusLabel)
        contentView.addSubview(recordProgressView)
        contentView.addSubview(recordMissionLabel)
        contentView.addSubview(missionCell)
        
        let recordStack = UIStackView(arrangedSubviews: recordButtons)
        recordStack.axis = .horizontal
        recordStack.spacing = 8
        recordStack.distribution = .fillEqually
        contentView.addSubview(recordStack)
        
        contentView.addSubview(endTripButton)
        
        // (5) 배치 잡기
        recordStatusLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
        }

        recordProgressView.snp.makeConstraints { make in
            make.top.equalTo(recordStatusLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        recordMissionLabel.snp.makeConstraints { make in
            make.top.equalTo(recordProgressView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
        }

        missionCell.snp.makeConstraints { make in
            make.top.equalTo(recordMissionLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(180)
        }

        recordStack.snp.makeConstraints { make in
            make.top.equalTo(missionCell.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        endTripButton.snp.makeConstraints { make in
            make.top.equalTo(recordStack.snp.bottom).offset(35)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
            // 마지막 뷰이므로 contentView의 bottom을 잡아주기
            make.bottom.equalTo(contentView.snp.bottom).offset(-41)
        }
    }
    
    // MARK: - Button Action

    @objc private func closeView() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Fetch Data
    var progressTravelsInfo: ProgressTravelsInfo?
    
    private func fetchTravelSummary() {
        OngoingLogManager.fetchProgressTravelsInfo { result in
            switch result {
            case .success(let ProgressTravelsInfo):
                self.progressTravelsInfo = ProgressTravelsInfo.result
                self.updateTravelSummary()
                self.updatePuzzleCount()
                print("데이터 불러오기")
            case .failure(let error):
                print("Error occurred: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Update UI
    private func updateTravelSummary() {
        guard let travelInfo = progressTravelsInfo else {
            print("No ongoing travels available.")
            return
        }
        let calendarText = "\(travelInfo.startDate) ~ \(travelInfo.endDate)"

        travelSummary.configure(
            userImage: travelInfo.profileImg,
            userName: travelInfo.nickname,
            title: travelInfo.title,
            city: travelInfo.cityName,
            country: travelInfo.countryName,
            day: travelInfo.dayCount,
            calendarImage: UIImage(named: "calendar"),
            calendarText: calendarText
        )
        travelSummary.isHidden = false
    }

    private func updatePuzzleCount() {
        guard let travelInfo = progressTravelsInfo else {
            print("No ongoing travels available.")
            return
        }
        recordProgressView.configure(
            pictureCount: travelInfo.pictureNum,
            videoCount: travelInfo.videoNum,
            memoCount: travelInfo.memoNum
        )
    }
    
    private func configureMissionCell() {
        let images = [
            UIImage(named: "mission1")!,
            UIImage(named: "mission2")!,
            UIImage(named: "mission3")!
        ]
        missionCell.configure(images: images)
    }
    
    private func configureRecordButtons() {
        for (index, button) in recordButtons.enumerated() {
            button.tag = index
            button.addTarget(self, action: #selector(handleRecordButtonTapped(_:)), for: .touchUpInside)
        }
    }
    
    @objc private func handleRecordButtonTapped(_ sender: UIButton) {
        guard let travelId = progressTravelsInfo?.id else {
            print("Travel ID is nil")
            return
        }
        print("Button with tag \(sender.tag) clicked")
        
        var viewController: UIViewController?
        
        switch sender.tag {
        case 0:
            viewController = PhotoLogViewController(travelId: travelId)
        case 1:
            viewController = VideoLogViewController(travelId: travelId)
        case 2:
            viewController = MemoLogViewController(travelId: travelId)
        default:
            return
        }
        
        if let viewController = viewController {
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true, completion: nil)
        }
    }
}
