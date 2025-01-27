// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import SnapKit

class FinishPuzzleVC: UIViewController {
    
    var travelId: Int
    
    private var dayRange: (start: Date, end: Date)?
    private var endTravelInfo: EndTravelInfo?

    init(travelId: Int) {
        self.travelId = travelId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    private lazy var customNavBar: FinishNavigationBar = {
        let nav = FinishNavigationBar()
        nav.iconImageView.isEnabled = false
        nav.iconImageView.isHidden = true
        nav.backgroundColor = .white
        return nav
    }()
    
    // 여행기록 제목
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "연우와 우정여행"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textAlignment = .center
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
        
        // 날짜 레이블
        let dateLabel: UILabel = {
            let label = UILabel()
            label.text = "24.08.12~24.08.16"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = UIColor(named: "Main")
            return label
        }()
        
        stackView.addArrangedSubview(dateImageView)
        stackView.addArrangedSubview(dateLabel)
        
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
    
    //MARK: - 여행조각들
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        
        // AttributedString 설정
        let fullText = "총 42개의 여행 조각들을 모았어요!"
        let attributedString = NSMutableAttributedString(string: fullText)
        
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)

        
        // 특정 텍스트에 색상 적용
        let numOfPuzzles = (fullText as NSString).range(of: "42개의 여행 조각들")
        attributedString.addAttribute(.foregroundColor, value: UIColor(named: "Main3") ?? UIColor.systemPink, range: numOfPuzzles)
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16, weight: .bold), range: numOfPuzzles)
        label.attributedText = attributedString
        
        label.textAlignment = .center
        return label
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "Black5")
        return view
    }()
    
    private lazy var photoCountStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 2
        
        let countLabel: UILabel = {
            let label = UILabel()
            label.textColor = .black
            
            // AttributedString 설정
            let fullText = "31개"
            let attributedString = NSMutableAttributedString(string: fullText)
            label.font = UIFont.systemFont(ofSize: 14, weight: .bold)

            // 특정 텍스트에 색상 적용
            let number = (fullText as NSString).range(of: "31")
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 20, weight: .bold), range: number)
            label.attributedText = attributedString
            return label
        }()
        
        let nameLabel: UILabel = {
            let label = UILabel()
            label.text = "사진"
            label.textColor = UIColor(named: "Black3")
            label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
            return label
        }()
        
        stackView.addArrangedSubview(countLabel)
        stackView.addArrangedSubview(nameLabel)
        
        return stackView
    }()
    private lazy var videoCountStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 2
        
        let countLabel: UILabel = {
            let label = UILabel()
            label.textColor = .black
            
            // AttributedString 설정
            let fullText = "4개"
            let attributedString = NSMutableAttributedString(string: fullText)
            label.font = UIFont.systemFont(ofSize: 14, weight: .bold)

            // 특정 텍스트에 색상 적용
            let number = (fullText as NSString).range(of: "4")
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 20, weight: .bold), range: number)
            label.attributedText = attributedString
            return label
        }()
        
        let nameLabel: UILabel = {
            let label = UILabel()
            label.text = "영상"
            label.textColor = UIColor(named: "Black3")
            label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
            return label
        }()
        
        stackView.addArrangedSubview(countLabel)
        stackView.addArrangedSubview(nameLabel)
        
        return stackView
    }()
    
    private lazy var musicCountStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 2
        
        let countLabel: UILabel = {
            let label = UILabel()
            label.textColor = .black
            
            // AttributedString 설정
            let fullText = "0개"
            let attributedString = NSMutableAttributedString(string: fullText)
            label.font = UIFont.systemFont(ofSize: 14, weight: .bold)

            // 특정 텍스트에 색상 적용
            let number = (fullText as NSString).range(of: "1")
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 20, weight: .bold), range: number)
            label.attributedText = attributedString
            return label
        }()
        
        let nameLabel: UILabel = {
            let label = UILabel()
            label.text = "음악"
            label.textColor = UIColor(named: "Black3")
            label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
            return label
        }()
        
        stackView.addArrangedSubview(countLabel)
        stackView.addArrangedSubview(nameLabel)
        
        return stackView
    }()
    
    
    private lazy var memoCountStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 2
        
        let countLabel: UILabel = {
            let label = UILabel()
            label.textColor = .black
            
            // AttributedString 설정
            let fullText = "6개"
            let attributedString = NSMutableAttributedString(string: fullText)
            label.font = UIFont.systemFont(ofSize: 14, weight: .bold)

            // 특정 텍스트에 색상 적용
            let number = (fullText as NSString).range(of: "6")
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 20, weight: .bold), range: number)
            label.attributedText = attributedString
            return label
        }()
        
        let nameLabel: UILabel = {
            let label = UILabel()
            label.text = "메모"
            label.textColor = UIColor(named: "Black3")
            label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
            return label
        }()
        
        stackView.addArrangedSubview(countLabel)
        stackView.addArrangedSubview(nameLabel)
        
        return stackView
    }()
    
    private lazy var numOfLogsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 47
        
        stackView.addArrangedSubview(photoCountStack)
        stackView.addArrangedSubview(videoCountStack)
        stackView.addArrangedSubview(musicCountStack)
        stackView.addArrangedSubview(memoCountStack)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var explainView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.05).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 20
        
        
        view.addSubview(infoLabel)
        view.addSubview(separatorView)
        view.addSubview(numOfLogsStack)
        
        // 제약 조건 설정
        infoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints { make in
            make.width.equalTo(318)
            make.height.equalTo(1)
            make.centerX.equalToSuperview()
            make.top.equalTo(infoLabel.snp.bottom).offset(12)
        }
        
        numOfLogsStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(separatorView.snp.bottom).offset(10)
        }
        return view
    }()
    
    //MARK: - 도시, 나라
    private lazy var travelPlaceLabel: UILabel = {
        let label = UILabel()
        label.text = "🇯🇵 도쿄, 일본"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - 퍼즐뷰
    private lazy var puzzleBackgroundView: UIView = {
        let view = UIView()
        //view.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        view.backgroundColor = .clear
        
        view.addSubview(puzzleImage1)
        view.addSubview(puzzleImage2)
        view.addSubview(puzzleImage3)
        view.addSubview(puzzleImage4)
        view.addSubview(puzzleImage5)
        view.addSubview(puzzleImage6)
        view.addSubview(puzzleImage7)
        view.addSubview(puzzleImage8)
        view.addSubview(puzzleImage9)
        
        puzzleImage1.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }
            
        puzzleImage2.snp.makeConstraints { make in
            make.centerY.equalTo(puzzleImage1.snp.centerY)
            make.leading.equalTo(puzzleImage1.snp.trailing).offset(-23.5)
        }
            
        puzzleImage3.snp.makeConstraints { make in
            make.centerY.equalTo(puzzleImage1.snp.centerY)
            make.trailing.equalToSuperview()
        }
            
        puzzleImage4.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(puzzleImage1.snp.bottom).offset(-23)
        }
            
        puzzleImage5.snp.makeConstraints { make in
            make.centerX.equalTo(puzzleImage2.snp.centerX)
            make.centerY.equalTo(puzzleImage4.snp.centerY)
        }
            
        puzzleImage6.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(puzzleImage4.snp.centerY)
        }
            
        puzzleImage7.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalTo(puzzleImage9.snp.centerY)
        }
            
        puzzleImage8.snp.makeConstraints { make in
            make.leading.equalTo(puzzleImage7.snp.trailing).offset(-23.5)
            make.centerY.equalTo(puzzleImage9.snp.centerY)
        }
            
        puzzleImage9.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        return view
    }()
    
    private lazy var puzzleImage1: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "puzzlePiece1")!.withTintColor([Constants.Colors.mainPurple, Constants.Colors.mainPink, Constants.Colors.mainYellow, Constants.Colors.mint].randomElement()!!, renderingMode: .automatic)
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(139.57)
            make.height.equalTo(114.78)
        }
        
        return imageView
    }()
    
    private lazy var puzzleImage2: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "puzzlePiece2")!.withTintColor([Constants.Colors.mainPurple, Constants.Colors.mainPink, Constants.Colors.mainYellow, Constants.Colors.mint].randomElement()!!, renderingMode: .automatic)
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(139.57)
            make.height.equalTo(114.78)
        }
        
        return imageView
    }()

    private lazy var puzzleImage3: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "puzzlePiece3")!.withTintColor([Constants.Colors.mainPurple, Constants.Colors.mainPink, Constants.Colors.mainYellow, Constants.Colors.mint].randomElement()!!, renderingMode: .automatic)
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(114.78)
            make.height.equalTo(114.78)
        }
        
        return imageView
    }()

    private lazy var puzzleImage4: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "puzzlePiece4")!.withTintColor([Constants.Colors.mainPurple, Constants.Colors.mainPink, Constants.Colors.mainYellow, Constants.Colors.mint].randomElement()!!, renderingMode: .automatic)
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(139.57)
            make.height.equalTo(139.57)
        }
        
        return imageView
    }()
    
    private lazy var puzzleImage5: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "puzzlePiece5")!.withTintColor([Constants.Colors.mainPurple, Constants.Colors.mainPink, Constants.Colors.mainYellow, Constants.Colors.mint].randomElement()!!, renderingMode: .automatic)
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(139.57)
            make.height.equalTo(139.57)
        }
        
        return imageView
    }()


    private lazy var puzzleImage6: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "puzzlePiece6")!.withTintColor([Constants.Colors.mainPurple, Constants.Colors.mainPink, Constants.Colors.mainYellow, Constants.Colors.mint].randomElement()!!, renderingMode: .automatic)
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(114.78)
            make.height.equalTo(139.57)
        }
        
        return imageView
    }()


    private lazy var puzzleImage7: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "puzzlePiece7")!.withTintColor([Constants.Colors.mainPurple, Constants.Colors.mainPink, Constants.Colors.mainYellow, Constants.Colors.mint].randomElement()!!, renderingMode: .automatic)
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(139.57)
            make.height.equalTo(139.57)
        }
        
        return imageView
    }()

    private lazy var puzzleImage8: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "puzzlePiece8")!.withTintColor([Constants.Colors.mainPurple, Constants.Colors.mainPink, Constants.Colors.mainYellow, Constants.Colors.mint].randomElement()!!, renderingMode: .automatic)
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(139.57)
            make.height.equalTo(139.57)
        }
        
        return imageView
    }()
    
    private lazy var puzzleImage9: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "puzzlePiece9")!.withTintColor([Constants.Colors.mainPurple, Constants.Colors.mainPink, Constants.Colors.mainYellow, Constants.Colors.mint].randomElement()!!, renderingMode: .automatic)
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(114.78)
            make.height.equalTo(139.57)
        }
        
        return imageView
    }()
    
    //MARK: - 버튼
    private lazy var continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("여행기 이어보기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = UIColor(named: "Main")
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleTravelLogStarted), for: .touchUpInside)
        return button
    }()

    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        self.view.addSubview(customNavBar)
        setupUI()
        fetchThumbnail(travelId: travelId)
        fetchTravelData(travelId: travelId)
    }

    
    @objc private func handleTravelLogStarted() {
        var thumbnails: [UIImage?] = []
        let puzzleImages = [self.puzzleImage1, self.puzzleImage2, self.puzzleImage3, self.puzzleImage4, self.puzzleImage5, self.puzzleImage6, self.puzzleImage7, self.puzzleImage8, self.puzzleImage9]
        for puzzleImage in puzzleImages {
            thumbnails.append(puzzleImage.tag == 0 ? nil : puzzleImage.image)
        }
        let puzzleLogVC = PuzzleLogVC(travelId: travelId, thumbnails: thumbnails)
        puzzleLogVC.initializeView(endTravelInfo: endTravelInfo)
        navigationController?.pushViewController(puzzleLogVC, animated: true)
//        puzzleLogVC.modalPresentationStyle = .fullScreen
//        self.present(puzzleLogVC, animated: true, completion: nil)
    }
    
    private func setupUI() {
        view.addSubview(titleStackView)
        view.addSubview(explainView)
        view.addSubview(travelPlaceLabel)
        view.addSubview(puzzleBackgroundView)
        view.addSubview(continueButton)
        setConstraints()
    }
    func setConstraints() {
        customNavBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(48)
        }
        titleStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(customNavBar.snp.bottom).offset(30)
        }
        explainView.snp.makeConstraints{ make in
            make.leading.trailing.equalToSuperview().inset(21)
            make.top.equalTo(titleStackView.snp.bottom).offset(20)
            make.height.equalTo(106)
        }
        travelPlaceLabel.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(explainView.snp.bottom).offset(26)
        }
        puzzleBackgroundView.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(travelPlaceLabel.snp.bottom).offset(15)
            make.width.height.equalTo(348)
        }
        continueButton.snp.makeConstraints{ make in
            make.leading.trailing.equalToSuperview().inset(21)
            make.height.equalTo(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(30)
        }
    }
    //MARK: - GET
    private func fetchTravelData(travelId: Int) {
        PuzzleLogManager.fetchTravelsInfo(travelId: travelId) { result in
            switch result {
            case .success(let value):
                self.endTravelInfo = value.result
                self.updateView(endTravelInfo: value.result)
                guard let startDate: Date = CalendarManager.shared.convertStringToDate(stringDate: value.result.startDate) else { return }
                guard let endDate: Date = CalendarManager.shared.convertStringToDate(stringDate: value.result.endDate) else { return }
                self.dayRange = (start: startDate, end: endDate)
            case .failure(let error):
                print("Error occurred: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchThumbnail(travelId: Int) {
        PuzzleLogManager.fetchThumbnail(travelId: travelId) { result in
            switch result {
            case .success(let value):
                self.updateThumbnail(thumbnailInfos: value.result)
            case .failure(let error):
                print("Error occurred: \(error.localizedDescription)")
                self.fetchThumbnailForInitial()
            }
        }
    }
    
    private func fetchThumbnailForInitial() {
        if let endTravelInfo = endTravelInfo {
            updateThumbnailForInitial(endTravelInfo: endTravelInfo)
            return
        }
        PuzzleLogManager.fetchTravelsInfo(travelId: travelId) { result in
            switch result {
            case .success(let value):
                self.updateThumbnailForInitial(endTravelInfo: value.result)
            case .failure(let error):
                print("Error occurred: \(error.localizedDescription)")
            }
        }
    }
    
    private func updateView(endTravelInfo: EndTravelInfo) {
        self.titleLabel.text = "\(endTravelInfo.title)"
        self.travelPlaceLabel.text = "\(endTravelInfo.countryImage) \(endTravelInfo.city), \(endTravelInfo.country)"
        if let dateLabel = self.dateStackView.arrangedSubviews[1] as? UILabel {
            dateLabel.text = "\(endTravelInfo.startDate)~\(endTravelInfo.endDate)"
        }
        
        // 퍼즐 데이터 업데이트
        let fullText = "총 \(endTravelInfo.totalPieces)개의 여행 조각들을 모았어요!"
        let attributedString = NSMutableAttributedString(string: fullText)

        // "totalPieces" 부분의 범위를 찾습니다.
        if let rangeOfTotalPieces = fullText.range(of: "\(endTravelInfo.totalPieces)개의 여행 조각들") {
            // NSString으로 변환하여 NSRange를 가져옵니다.
            let nsRange = NSRange(rangeOfTotalPieces, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: UIColor(named: "Main3") ?? UIColor.systemPink, range: nsRange)
        }
        self.infoLabel.attributedText = attributedString
        
        if let countLabel = self.memoCountStack.arrangedSubviews.first as? UILabel {
            let fullText = "\(endTravelInfo.memoCount)개"
            
            let attributedString = NSMutableAttributedString(string: fullText)
            let numberRange = (fullText as NSString).range(of: "\(endTravelInfo.memoCount)")
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 20, weight: .bold), range: numberRange)
            
            countLabel.attributedText = attributedString
        }
        
        if let countLabel = self.photoCountStack.arrangedSubviews.first as? UILabel {
            let fullText = "\(endTravelInfo.pictureCount)개"
            
            let attributedString = NSMutableAttributedString(string: fullText)
            let numberRange = (fullText as NSString).range(of: "\(endTravelInfo.pictureCount)")
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 20, weight: .bold), range: numberRange)
            
            countLabel.attributedText = attributedString
        }
        
        if let countLabel = self.videoCountStack.arrangedSubviews.first as? UILabel {
            let fullText = "\(endTravelInfo.videoCount)개"
            
            let attributedString = NSMutableAttributedString(string: fullText)
            let numberRange = (fullText as NSString).range(of: "\(endTravelInfo.videoCount)")
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 20, weight: .bold), range: numberRange)
            
            countLabel.attributedText = attributedString
        }
        
        if let countLabel = self.musicCountStack.arrangedSubviews.first as? UILabel {
            let fullText = "\(endTravelInfo.videoCount)개"
            
            let attributedString = NSMutableAttributedString(string: fullText)
            let numberRange = (fullText as NSString).range(of: "\(endTravelInfo.videoCount)")
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 20, weight: .bold), range: numberRange)
            
            countLabel.attributedText = attributedString
        }
    }
    
    private func updateThumbnail(thumbnailInfos: [ThumbnailInfo]) {
        // 각 퍼즐 이미지에 순서대로 할당
        let puzzleImages = [self.puzzleImage1, self.puzzleImage2, self.puzzleImage3, self.puzzleImage4, self.puzzleImage5, self.puzzleImage6, self.puzzleImage7, self.puzzleImage8, self.puzzleImage9]
        
        for thumbnailInfo in thumbnailInfos {
            guard let url = URL(string: thumbnailInfo.pictureUrl ?? ""), let index = thumbnailInfo.thumbnail_index else { continue }
            // Download image using SDWebImage
            
            puzzleImages[index].sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), completed: { [weak self] (image, error, cacheType, imageURL) in
                guard let self = self else { return }
                if let downloadedImage = image {
                    // Replace the main image with the downloaded image
                    let puzzleMaskImage = UIImage(named: "puzzlePiece\(index + 1)")!
                    let imageView = PuzzleManager.shared.createPuzzlePiece(image: downloadedImage, mask: puzzleMaskImage)
                    
                    // Replace the existing imageView with the new one containing the downloaded image
                    puzzleImages[index].image = imageView.image
                    puzzleImages[index].tag = 1
                }
            })
        }
    }
    
    private func updateThumbnailForInitial(endTravelInfo: EndTravelInfo) {
        let pictureSummaries = endTravelInfo.pictureSummaries
        // 각 퍼즐 이미지에 순서대로 할당
        let puzzleImages = [self.puzzleImage1, self.puzzleImage2, self.puzzleImage3, self.puzzleImage4, self.puzzleImage5, self.puzzleImage6, self.puzzleImage7, self.puzzleImage8, self.puzzleImage9]
        
        for (index, pictureSummary) in pictureSummaries.prefix(puzzleImages.count).enumerated() {
            if let firstMediaUrl = pictureSummary.mediaUrls.first, let url = URL(string: firstMediaUrl) {
                // Download image using SDWebImage
                puzzleImages[index].sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), completed: { [weak self] (image, error, cacheType, imageURL) in
                    guard let self = self else { return }
                    if let downloadedImage = image {
                        // Replace the main image with the downloaded image
                        let puzzleMaskImage = UIImage(named: "puzzlePiece\(index + 1)")!
                        let imageView = PuzzleManager.shared.createPuzzlePiece(image: downloadedImage, mask: puzzleMaskImage)
                        
                        // Replace the existing imageView with the new one containing the downloaded image
                        puzzleImages[index].image = imageView.image
                        puzzleImages[index].tag = 1
                    }
                })
            }
        }
    }
}
