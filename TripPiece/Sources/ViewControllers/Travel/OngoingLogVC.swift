// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import SnapKit

class OngoingLogVC: UIViewController {

    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ongoingLogTop")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var scrollView: UIScrollView = {
        return UIScrollView()
    }()
    
    private lazy var travelSummary: TravelSummaryView = {
        let view = TravelSummaryView()
        view.isHidden = true
        return view
    }()
        
    private lazy var xButton: XButton = {
        let button = XButton()
        button.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        return button
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        fetchTravelSummary()
        configureMissionCell()
        configureRecordButtons()
        navigationItem.hidesBackButton = true // 뒤로 버튼 숨기기
    }

    private func setupUI() {
        view.addSubview(backgroundImageView)
        view.addSubview(travelSummary)
        view.addSubview(xButton)
        view.addSubview(recordStatusLabel)
        view.addSubview(recordProgressView)
        view.addSubview(recordMissionLabel)
        view.addSubview(missionCell)
        view.addSubview(endTripButton)

        let recordStack = UIStackView(arrangedSubviews: recordButtons)
        recordStack.axis = .horizontal
        recordStack.spacing = 8
        recordStack.distribution = .fillEqually
        recordStack.isUserInteractionEnabled = true

        view.addSubview(recordStack)
        view.addSubview(endTripButton)

        backgroundImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(235)
        }

        travelSummary.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        xButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(89)
            make.trailing.equalToSuperview().offset(-25)
            make.width.height.equalTo(25)
        }
        
        recordStatusLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(265)
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
            make.top.equalTo(recordStack.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
    }
    //MARK: - Function
    @objc private func closeView() {
//        dismiss(animated: true, completion: nil)
        print("dkddk나는 바보")
        navigationController?.popViewController(animated: true)

    }
    
    // MARK: - Fetch Data
    var progressTravelsInfo: ProgressTravelsInfo?
    
    private func fetchTravelSummary() {
        OngoingLogManager.fetchProgressTravelsInfo { result in
            switch result {
            case .success(let ProgressTravelsInfo):
                self.progressTravelsInfo = ProgressTravelsInfo.result // 데이터를 저장
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
        // 캘린더 텍스트 생성
        let calendarText = "\(travelInfo.startDate) ~ \(travelInfo.endDate)"

        // TravelSummaryView 구성
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
    
    // 버튼에 액션 추가
    private func configureRecordButtons() {
        for (index, button) in recordButtons.enumerated() {
            button.tag = index // 버튼 태그 설정 (버튼 식별용)
            button.addTarget(self, action: #selector(handleRecordButtonTapped(_:)), for: .touchUpInside)
        }
    }
    @objc private func handleRecordButtonTapped(_ sender: UIButton) {
        guard let travelId = progressTravelsInfo?.id else {
                print("Travel ID is nil")
                return
            }
        print("Button with tag \(sender.tag) clicked")

        switch sender.tag {
        case 0: // "사진" 버튼
            let photoVC = PhotoLogViewController(travelId: travelId)
            navigationController?.pushViewController(photoVC, animated: true)
        case 1: // "동영상" 버튼
            let videoVC = VideoLogViewController(travelId: travelId)
            navigationController?.pushViewController(videoVC, animated: true)
        case 2: // "메모" 버튼
            let memoVC = MemoLogViewController(travelId: travelId)
            navigationController?.pushViewController(memoVC, animated: true)
        default:
            break
        }
    }

}
