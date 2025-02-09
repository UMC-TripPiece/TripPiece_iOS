import UIKit
import SnapKit
import AVFoundation
import Alamofire

class LiveVideoLogVC: UIViewController {
    
    var travelId: Int
        
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
        nav.backgroundColor = .white
        return nav
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "지금 어디에 있나요?"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "영상으로 지금 이 순간을 \n카메라에 담아보세요!"
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
    
    ///회색 배경부분부터
    private lazy var grayBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "BgColor2")
        return view
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        return stackView
    }()
    
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
        
    private var selectedVideo: UIImage? {
        didSet {
            updateAddButtonState()
        }
    }
    private var selectedVideoURL: URL? {
        didSet {
            updateAddButtonState()
        }
    }

    //MARK: - Init
    override func viewDidLoad() {
        setupDismissKeyboardGesture()
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(customNavBar)
        setupUI()

        // NotificationCenter 관찰자 추가
        NotificationCenter.default.addObserver(self, selector: #selector(handleBackButtonTap), name: .backButtonTapped, object: nil)
        
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
    }

    //MARK: - Setup UI
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(titleImageView)
        view.addSubview(buttonsStackView)
        view.addSubview(addButton)
        
        view.addSubview(grayBackgroundView)
        grayBackgroundView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(buttonsStackView)
        contentStackView.addArrangedSubview(createSpacer(height: 20))
        contentStackView.addArrangedSubview(memoTitleLabel)
        contentStackView.addArrangedSubview(createSpacer(height: 10))
        contentStackView.addArrangedSubview(memoTextView)
        contentStackView.addArrangedSubview(createSpacer(height: 132))
        contentStackView.addArrangedSubview(addButton)

        setConstraints()
        setupButtonsStackView()
    }
    
    private func createSpacer(height: CGFloat) -> UIView {
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.heightAnchor.constraint(equalToConstant: height).isActive = true
        return spacer
    }
    
    func setConstraints() {
        customNavBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(48)
        }
        titleLabel.snp.makeConstraints{ make in
            make.top.equalTo(customNavBar.snp.bottom).offset(41)
            make.leading.equalToSuperview().offset(21)
        }
        subtitleLabel.snp.makeConstraints{ make in
            make.top.equalTo(customNavBar.snp.bottom).offset(84)
            make.leading.equalToSuperview().offset(21)
            make.height.greaterThanOrEqualTo(42)
        }
        titleImageView.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(129)
            make.trailing.equalToSuperview().inset(21.18)
        }
        grayBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
                
        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(grayBackgroundView.snp.top).offset(30)
            make.leading.trailing.equalToSuperview().inset(21)
        }
        
        memoTextView.snp.makeConstraints { make in
            make.height.equalTo(69)
        }
        
        addButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        buttonsStackView.arrangedSubviews.first?.snp.makeConstraints { make in
            make.width.equalTo(348)
            make.height.equalTo(162)
        }
    }
    
    //MARK: - Function
    private func setupButtonsStackView() {
        let button = UIButton()
        button.setImage(UIImage(named: "add video"), for: .normal)
        button.tintColor = .gray
        button.contentMode = .scaleAspectFit
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(selectVideo), for: .touchUpInside)
        buttonsStackView.addArrangedSubview(button)
    }
    
    private func updateAddButtonState() {
        // 두 변수의 상태를 프린트하여 확인
        print("Selected video URL: \(selectedVideoURL?.absoluteString ?? "nil")")
        
        addButton.isEnabled = selectedVideo != nil
        addButton.backgroundColor = selectedVideo == nil ? UIColor(named: "Cancel") : UIColor(named: "Main2")
    }

    
    ///뒤로가기 버튼
    @objc private func handleBackButtonTap() {
        navigationController?.popViewController(animated: true)
    }
    
    ///비디오 추가 버튼 클릭
    @objc private func selectVideo() {
        let alert = UIAlertController(title: "동영상 추가", message: " ", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "라이브러리에서 동영상 선택", style: .default, handler: { _ in
            self.openPhotoLibrary()
        }))
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }

    ///앨범 열기
    private func openPhotoLibrary() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = ["public.movie"]
        self.present(imagePickerController, animated: true, completion: nil)
    }

    @objc private func addRecord() {
        print("Record button tapped")
        postVideoMemo()
    }

    private func postVideoMemo() {
        guard let videoURL = selectedVideoURL else {
            print("Video URL is nil")
            return
        }
        guard let videoData = try? Data(contentsOf: videoURL) else {
            print("Failed to convert video to data")
            return
        }
        let memoText: String = {
            if memoTextView.text == "| 감정을 글로 표현해보세요 (100자 이내)" {
                return ""
            }
            return memoTextView.text
        }()
        print(videoURL.lastPathComponent)
        MissionLogManager.postLiveVideoPiece(createVideoPieceRequest: CreateVideoPieceRequest(travelId: travelId, memo: MemoObject(description: memoText), video: videoData, videoName: videoURL.lastPathComponent)) { [weak self] result in
            switch result {
            case .success(let value):
                self?.navigateToVideoCompleteViewController()
            case .failure(let error):
                print("Failed to upload video: \(error.localizedDescription)")
            }
        }
    }
        
    private func getRefreshToken() -> String? {
        return UserDefaults.standard.string(forKey: "refreshToken")
    }
    
    ///이동
    var videoImage: UIImage?
    private func navigateToVideoCompleteViewController() {
        guard let thumbnail = videoImage, let text = memoTextView.text else {
            // 에러 처리: 텍스트나 썸네일이 없을 때
            let alert = UIAlertController(title: "경고", message: "썸네일 또는 텍스트가 없습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            return
        }
        
        let recordCompleteVC = LiveVideoCompleteVC()
        recordCompleteVC.setVideoComplete(with: thumbnail)
        navigationController?.replaceViewController(viewController: recordCompleteVC, animated: true)
    }
}

extension LiveVideoLogVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedVideoURL = info[.mediaURL] as? URL {
            let videoThumbnail = getThumbnailImage(forUrl: selectedVideoURL)
            selectedVideo = videoThumbnail
            self.videoImage = videoThumbnail

            self.selectedVideoURL = selectedVideoURL  // URL 설정
            print("Selected video URL: \(selectedVideoURL.absoluteString)")
                        
            let button = buttonsStackView.arrangedSubviews.first as! UIButton
            button.setImage(videoThumbnail, for: .normal)
            button.imageView?.contentMode = .scaleAspectFill
            button.imageView?.clipsToBounds = true
                        
            // 썸네일 크기를 지정된 크기로 설정
            button.snp.updateConstraints { make in
//                make.width.equalTo(348)
                make.height.equalTo(162)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    ///비디오 썸네일 생성
    private func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        do {
            let thumbnailImage = try assetImageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        return nil
    }
    
    ///키보드 내리기
    private func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
        
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension LiveVideoLogVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "| 영상에 대해 설명해주세요 (100자 이내)" {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "| 영상에 대해 설명해주세요 (100자 이내)"
            textView.textColor = UIColor.lightGray
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= 100 // 글자 수 제한 100자
    }
}
