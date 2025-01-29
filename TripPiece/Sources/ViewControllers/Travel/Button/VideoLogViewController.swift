//
//  VideoLogViewController.swift
//  MyWorldApp
//
//  Created by 김나연 on 8/2/24.
//

import UIKit
import SnapKit
import AVFoundation

import UIKit
import SnapKit
import AVFoundation

class VideoLogViewController: UIViewController, UITextViewDelegate {

    // MARK: - Properties

    var travelId: Int

    // 썸네일 이미지 (비디오 선택 시 생성)
    private var selectedVideo: UIImage? {
        didSet {
            updateAddButtonState()
        }
    }
    // 비디오 파일 URL
    private var selectedVideoURL: URL? {
        didSet {
            updateAddButtonState()
        }
    }
    private var videoImage: UIImage?

    // MARK: - Init

    init(travelId: Int) {
        self.travelId = travelId
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - UI
    private lazy var customNavBar: CustomNavigationLogoBar = {
        let nav = CustomNavigationLogoBar()
        nav.translatesAutoresizingMaskIntoConstraints = false
        nav.backgroundColor = .white
        return nav
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "동영상 추가"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "동영상을 추가한 후 \n설명을 작성해보세요!"
        label.numberOfLines = 2
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor(named: "subtitle")
        return label
    }()
    
    private lazy var titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "dum2")
        return imageView
    }()
    
    // 회색 영역(여기에 스크롤뷰를 넣어, SE3 기기에서도 내용 스크롤 가능)
    private lazy var grayBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "BgColor2")
        return view
    }()

    
    
    // ✅ grayScrollView 안에 실제 배치할 컨테이너
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()

    // ✅ 수직 스택: (버튼스택, 라벨, 메모, 버튼) 순서로 쌓는다
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        return stackView
    }()
    
    // 동영상 버튼 컨테이너들을 수평으로 쌓을 스택
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var memoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "메모"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    private lazy var spacerLabel: UILabel = {
        let label = UILabel()
        label.text = " "
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private lazy var memoTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textColor = UIColor(named: "Black3")
        textView.text = "| 영상에 대해 설명해주세요 (100자 이내)"
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.shadowColor = UIColor.black.cgColor
        textView.layer.shadowOpacity = 0.2
        textView.layer.shadowOffset = CGSize(width: 0, height: 2)
        textView.layer.cornerRadius = 5
        textView.delegate = self
        return textView
    }()
        
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("기록 추가", for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 8
        button.isEnabled = false
        button.addTarget(self, action: #selector(addRecord), for: .touchUpInside)
        return button
    }()

    //MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        NotificationCenter.default.addObserver(self, selector: #selector(handleBackButtonTap), name: .backButtonTapped, object: nil)
        setupUI()
        setupDismissKeyboardGesture()
    }

    //MARK: - Setup UI

    private func setupUI() {
        // (1) 상단 바 + 제목/서브타이틀/이미지
        view.addSubview(customNavBar)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(titleImageView)

        // (2) grayBackgroundView(회색 영역) + 스크롤뷰
        view.addSubview(grayBackgroundView)
        grayBackgroundView.addSubview(contentView)
        contentView.addSubview(contentStackView)

        // (3) 스택뷰에 순서대로 뷰 쌓기
        contentStackView.addArrangedSubview(buttonsStackView)
        contentStackView.addArrangedSubview(createSpacer(height: 20))
        contentStackView.addArrangedSubview(memoTitleLabel)
        contentStackView.addArrangedSubview(createSpacer(height: 10))
        contentStackView.addArrangedSubview(memoTextView)
//        contentStackView.addArrangedSubview(createSpacer(height: UIScreen.main.bounds.height / 8))
        contentStackView.addArrangedSubview(spacerLabel)
        contentStackView.addArrangedSubview(addButton)
        contentStackView.addArrangedSubview(createSpacer(height: 20))


        // (4) 오토레이아웃 설정
        setConstraints()

        // (5) 동영상 버튼(썸네일 표시용) 생성
        setupButtonsStackView()
    }
    
    private func createSpacer(height: CGFloat) -> UIView {
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.heightAnchor.constraint(equalToConstant: height).isActive = true
        return spacer
    }
    
    private func setConstraints() {
        // A) 커스텀 네비게이션 바
        customNavBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(48)
        }

        // B) 제목, 서브타이틀, 이미지
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(customNavBar.snp.bottom).offset(21)
            make.leading.equalToSuperview().offset(21)
            make.height.equalTo(33)

        }
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(21)
            make.height.equalTo(45)
        }
        titleImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(129)
            make.trailing.equalToSuperview().inset(21.18)
        }

        // C) grayBackgroundView (아래 고정)
        grayBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        

        // E) contentView (scrollView 안쪽 컨테이너)
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(grayBackgroundView)
//            make.width.equalTo(grayBackgroundView).inset(16)
        }

        // F) contentStackView (수직 쌓기)
        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(30)
            make.leading.trailing.equalTo(contentView).inset(21)
            make.bottom.equalTo(contentView.snp.bottom).offset(-30)
        }

        // G) 메모와 버튼 높이
        memoTitleLabel.snp.makeConstraints { make in
            make.height.equalTo(19)
        }
        memoTextView.snp.makeConstraints { make in
            make.height.equalTo(69)
        }
        spacerLabel.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(20)
        }
        addButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
    
    private func setupButtonsStackView() {
        // ✅ 동영상 추가 버튼(혹은 썸네일 표시) 컨테이너
        let buttonContainer = UIView()
        buttonContainer.backgroundColor = .white
        buttonContainer.layer.cornerRadius = 10
        buttonContainer.clipsToBounds = true
        
        // ✅ 버튼 생성
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .gray
        // 썸네일을 “가득 채우려면” .scaleAspectFill
        button.imageView?.contentMode = .scaleAspectFill
        button.imageView?.clipsToBounds = true

        // 그림자 (컨테이너나 버튼 중 원하는 쪽에 적용)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        button.addTarget(self, action: #selector(selectVideo), for: .touchUpInside)
        
        // 스택뷰에 컨테이너 추가
        buttonsStackView.addArrangedSubview(buttonContainer)
        // 컨테이너에 버튼 부착
        buttonContainer.addSubview(button)
        
        // 컨테이너 크기 (원하는대로)
        buttonContainer.snp.makeConstraints { make in
            // 예: 세로로 162 고정
            make.height.equalTo(162)
        }
        
        // 버튼은 컨테이너를 가득 채움
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - Button & Functions
    
    private func updateAddButtonState() {
        let isMemoValid = !(memoTextView.text.isEmpty) && memoTextView.text != "| 영상에 대해 설명해주세요 (100자 이내)"
        addButton.isEnabled = (selectedVideo != nil) && isMemoValid
        addButton.backgroundColor = (selectedVideo == nil || !isMemoValid)
            ? UIColor(named: "Cancel")
            : UIColor(named: "Main2")
    }
    @objc private func handleBackButtonTap() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc private func addRecord() {
        guard let videoURL = selectedVideoURL else {
            print("No video selected")
            return
        }
        do {
            let videoData = try Data(contentsOf: videoURL)
            logVideo(memoTextView.text ?? "", video: videoData) { result in
                switch result {
                case .success(let message):
                    print(message)
                    self.navigateToVideoCompleteViewController()
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    let alert = UIAlertController(
                        title: "오류",
                        message: "비디오 업로드에 실패했습니다.",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                    self.present(alert, animated: true)
                }
            }
        } catch {
            print("Failed to convert video to Data: \(error.localizedDescription)")
        }
    }
    
    private func logVideo(_ description: String, video: Data, completion: @escaping (Result<Any, Error>) -> Void) {
        guard !description.isEmpty, !video.isEmpty else {
            let error = NSError(
                domain: "Upload Memo Error",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Invalid inputs for memo or video"]
            )
            completion(.failure(error))
            return
        }

        let data = CreateVideoPieceRequest(
            travelId: travelId,
            memo: MemoObject(description: description),
            video: video
        )
        print("비디오 기록 추가 요청: \(data)")

        OngoingLogManager.postTravelVideo(data) { isSuccess, response in
            if isSuccess {
                completion(.success("Video update successful"))
            } else {
                if let data = response?.data,
                   let errorMessage = String(data: data, encoding: .utf8) {
                    print("서버 에러 메시지: \(errorMessage)")
                }
                let error = NSError(
                    domain: "Log Video Error",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Log video update failed."]
                )
                completion(.failure(error))
            }
        }
    }

    // 동영상 기록 완료 페이지로 이동
    private func navigateToVideoCompleteViewController() {
        guard let thumbnail = videoImage, let text = memoTextView.text else {
            let alert = UIAlertController(title: "경고", message: "썸네일 또는 텍스트가 없습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            return
        }
        
        let recordCompleteVC = VideoCompleteViewController()
        recordCompleteVC.setPreviewText(text)
        recordCompleteVC.setVideoComplete(with: thumbnail, text: text)
        recordCompleteVC.modalPresentationStyle = .fullScreen
        present(recordCompleteVC, animated: true)
    }

    @objc private func selectVideo() {
        let alert = UIAlertController(title: "동영상 추가", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "라이브러리에서 동영상 선택", style: .default) { _ in
            self.openPhotoLibrary()
        })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(alert, animated: true)
    }
    
    private func openPhotoLibrary() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.movie"]
        present(picker, animated: true)
    }

    //MARK: - Keyboard

    private func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UIImagePickerController & UINavigationControllerDelegate
extension VideoLogViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // 동영상 선택 완료
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        defer { picker.dismiss(animated: true) }

        // (1) 선택한 동영상 URL
        guard let videoURL = info[.mediaURL] as? URL else {
            print("비디오 URL이 없음")
            return
        }
        self.selectedVideoURL = videoURL

        // (2) 썸네일 생성
        let videoThumbnail = getThumbnailImage(forUrl: videoURL)
        self.selectedVideo = videoThumbnail
        self.videoImage = videoThumbnail

        // (3) 버튼에 썸네일 표시
        if
            let buttonContainer = buttonsStackView.arrangedSubviews.first,
            let button = buttonContainer.subviews.first as? UIButton,
            let thumbnail = videoThumbnail
        {
            // 썸네일 이미지를 버튼 배경으로
            button.setImage(thumbnail, for: .normal)
            // 가득 채우려면 .scaleAspectFill
            button.imageView?.contentMode = .scaleAspectFill
            button.imageView?.clipsToBounds = true

            // 썸네일이 버튼 전체를 채우도록
            button.imageView?.snp.remakeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    // 동영상 URL -> 썸네일 UIImage
    private func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        do {
            let thumbnailImage = try assetImageGenerator.copyCGImage(
                at: CMTimeMake(value: 1, timescale: 60),
                actualTime: nil
            )
            return UIImage(cgImage: thumbnailImage)
        } catch {
            print("썸네일 생성 에러: \(error)")
            return nil
        }
    }
}

// MARK: - UITextViewDelegate
extension VideoLogViewController {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "| 영상에 대해 설명해주세요 (100자 이내)" {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "| 영상에 대해 설명해주세요 (100자 이내)"
            textView.textColor = .lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateAddButtonState()
    }

    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String
    ) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        // 글자 수 제한 100자
        return updatedText.count <= 100
    }
}
