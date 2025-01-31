//
//  PhotoLogViewController.swift
//  MyWorldApp
//
//  Created by 김나연 on 8/2/24.
//

import UIKit
import SnapKit

class PhotoLogViewController: UIViewController {

    func didTapBackButton() {
        print("didTapBackButton called")
        navigationController?.popViewController(animated: true)
    }

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
        nav.translatesAutoresizingMaskIntoConstraints = false
        nav.backgroundColor = .white
        return nav
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "사진 추가"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "사진을 추가한 후 \n설명을 작성해보세요!"
        label.numberOfLines = 2
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor(named: "subtitle")
        return label
    }()

    private lazy var titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "dum1")
        return imageView
    }()

    // ✅ 회색 영역 전체(스크롤뷰를 담기 위한 컨테이너)
    private lazy var grayBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "BgColor2")
        return view
    }()

    // ✅ grayBackgroundView 안에 들어갈 스크롤 뷰
    private lazy var grayScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = true
        scroll.backgroundColor = .clear
        return scroll
    }()

    // ✅ 스크롤뷰 안에 들어갈 임시 컨테이너(오토레이아웃 편의용)
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()

    // ✅ 스크롤될 실제 콘텐츠를 수직으로 쌓을 스택
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        // 스택 간격 필요하면 아래 처럼 설정
        // stackView.spacing = 10
        return stackView
    }()

    // 사진 4개 뷰(버튼처럼 쓰기) 모아두는 스택
    private lazy var photosStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 9
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()

    private lazy var photoSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "최대 4장 첨부 가능합니다"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(named: "Black2")
        return label
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
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = UIColor(named: "Black3")
        textView.text = "| 사진에 대해 설명해주세요! (100자 이내)"
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

    private var selectedImages: [UIImage] = [] {
        didSet {
            updateAddButtonState()
        }
    }

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleBackButtonTap), name: .backButtonTapped, object: nil)
        navigationItem.hidesBackButton = true
        view.backgroundColor = .white

        // 키보드 숨기기 제스처
        setupDismissKeyboardGesture()

        // (1) 최상단 NavBar, 타이틀, 서브타이틀, 이미지
        view.addSubview(customNavBar)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(titleImageView)

        // (2) grayBackgroundView(고정 영역), 그 안에 scrollView
        view.addSubview(grayBackgroundView)
        grayBackgroundView.addSubview(grayScrollView)

        // (3) scrollView 안에 contentView & 수직 스택뷰
        grayScrollView.addSubview(contentView)
        contentView.addSubview(contentStackView)

        // (4) stackView에 필요한 모든 하위 뷰를 **순서대로** 쌓기
        //     (각각 사이에 spacer를 넣어서 여백 줄 수 있음)
        contentStackView.addArrangedSubview(photosStackView)
        contentStackView.addArrangedSubview(createSpacer(height: 10))
        contentStackView.addArrangedSubview(photoSubtitleLabel)
        contentStackView.addArrangedSubview(createSpacer(height: 30))
        contentStackView.addArrangedSubview(memoTitleLabel)
        contentStackView.addArrangedSubview(createSpacer(height: 10))
        contentStackView.addArrangedSubview(memoTextView)
        contentStackView.addArrangedSubview(createSpacer(height: 216))
        contentStackView.addArrangedSubview(addButton)

        // (5) 오토레이아웃 설정
        setConstraints()

        // (6) 사진 스택 초기화(플러스 아이콘 4개 등)
        setupPhotosStackView()
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

        // B) 타이틀/서브타이틀/이미지
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(customNavBar.snp.bottom).offset(41)
            make.leading.equalToSuperview().offset(21)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(customNavBar.snp.bottom).offset(84)
            make.leading.equalToSuperview().offset(21)
            make.height.greaterThanOrEqualTo(42)
        }
        titleImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(129)
            make.trailing.equalToSuperview().inset(21.18)
        }

        // C) grayBackgroundView (상단 subtitleLabel 아래)
        grayBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()  // 화면 끝까지
        }

        // D) 스크롤 뷰
        grayScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview() // grayBackgroundView 전체를 채움
        }

        // E) contentView(스크롤 내부 실제 컨테이너)
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(grayScrollView.contentLayoutGuide)
            make.width.equalTo(grayScrollView.frameLayoutGuide)
        }

        // F) contentStackView
        contentStackView.snp.makeConstraints { make in
            // contentView의 위에서 30만큼 띄우고, 좌우 21 여백
            make.top.equalTo(contentView.snp.top).offset(30)
            make.leading.trailing.equalTo(contentView).inset(21)
            // 스택뷰의 마지막 요소 아래로 충분히 공간을 주려면 bottom도 잡아줌
            make.bottom.equalTo(contentView.snp.bottom).offset(-30)
        }

        // G) 메모 텍스트뷰, 버튼 등 높이 지정
        memoTextView.snp.makeConstraints { make in
            make.height.equalTo(90)
        }
        addButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }

    private func setupPhotosStackView() {
        // 스택에 4개의 버튼 컨테이너(플러스 아이콘)
        for _ in 0..<4 {
            let buttonContainer = UIView()
            buttonContainer.backgroundColor = .white
            buttonContainer.layer.cornerRadius = 10
            buttonContainer.clipsToBounds = true

            let imageView = UIImageView()
            let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .small)
            imageView.image = UIImage(systemName: "plus", withConfiguration: config)
            imageView.tintColor = .gray
            imageView.contentMode = .center
            imageView.isUserInteractionEnabled = true

            buttonContainer.layer.shadowColor = UIColor.black.cgColor
            buttonContainer.layer.shadowOpacity = 0.2
            buttonContainer.layer.shadowOffset = CGSize(width: 0, height: 2)

            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectPhoto))
            buttonContainer.addGestureRecognizer(tapGesture)

            buttonContainer.addSubview(imageView)
            photosStackView.addArrangedSubview(buttonContainer)

            // 정사각형 크기
            buttonContainer.snp.makeConstraints { make in
                make.width.equalTo(UIScreen.main.bounds.width / 5.7)
                make.height.equalTo(buttonContainer.snp.width)
            }

            // 중앙에 이미지
            imageView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.height.equalTo(UIScreen.main.bounds.width / 5.7)
            }
        }
    }

    //MARK: - Button & Functions
    private func updateAddButtonState() {
        let isMemoValid = !memoTextView.text.isEmpty && memoTextView.text != "| 사진에 대해 설명해주세요! (100자 이내)"
        addButton.isEnabled = !selectedImages.isEmpty && isMemoValid
        addButton.backgroundColor = (selectedImages.isEmpty || !isMemoValid)
            ? UIColor(named: "Cancel")
            : UIColor(named: "Main")
    }

    @objc private func handleBackButtonTap() {
        dismiss(animated: true)
    }

    @objc private func selectPhoto() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "카메라 열기", style: .default) { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true)
            } else {
                let alert = UIAlertController(
                    title: "카메라 사용 불가",
                    message: "카메라를 사용할 수 없습니다.",
                    preferredStyle: .alert
                )
                let okAction = UIAlertAction(title: "확인", style: .default)
                alert.addAction(okAction)
                self.present(alert, animated: true)
            }
        }
        let libraryAction = UIAlertAction(title: "라이브러리에서 사진 선택", style: .default) { _ in
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }

    @objc private func addRecord() {
        let photoDataArray = selectedImages.compactMap { $0.jpegData(compressionQuality: 0.5) }
        logPicture(memoTextView.text, photos: photoDataArray) { result in
            switch result {
            case .success(let message):
                print(message)
                self.navigateToPhotoCompleteViewController()
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                let alert = UIAlertController(title: "오류", message: "사진 업로드에 실패했습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                self.present(alert, animated: true)
            }
        }
    }

    func logPicture(_ memo: String, photos: [Data], completion: @escaping (Result<Any, Error>) -> Void) {
        guard !memo.isEmpty, !photos.isEmpty else {
            let error = NSError(
                domain: "Upload Memo Error",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Invalid inputs for memo or photos"]
            )
            completion(.failure(error))
            return
        }
        let data = CreatePhotosPieceRequest(
            travelId: travelId,
            memo: MemoObject(description: memo),
            photos: photos
        )
        print("사진 기록 추가 완료: \(data)")

        OngoingLogManager.postTravelPicture(data) { isSuccess, response in
            if isSuccess {
                completion(.success("Picture update successful"))
            } else {
                if let data = response?.data,
                   let errorMessage = String(data: data, encoding: .utf8) {
                    print("서버 에러 메시지: \(errorMessage)")
                }
                let error = NSError(
                    domain: "Log Picture Error",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Log picture update failed."]
                )
                completion(.failure(error))
            }
        }
    }

    private func navigateToPhotoCompleteViewController() {
        let recordCompleteVC = PhotoCompleteViewController()
        recordCompleteVC.images = selectedImages
        recordCompleteVC.memoText = memoTextView.text
        recordCompleteVC.modalPresentationStyle = .fullScreen
        present(recordCompleteVC, animated: true)
    }

    private func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK: - Extension
extension PhotoLogViewController: UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "| 사진에 대해 설명해주세요! (100자 이내)" {
            textView.text = ""
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "| 사진에 대해 설명해주세요! (100자 이내)"
            textView.textColor = UIColor(named: "Black3")
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= 100
    }

    func textViewDidChange(_ textView: UITextView) {
        updateAddButtonState()
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            if selectedImages.count < 4 && selectedImages.count < photosStackView.arrangedSubviews.count {
                selectedImages.append(selectedImage)

                if let buttonContainer = photosStackView.arrangedSubviews[selectedImages.count - 1] as? UIView,
                   let imageView = buttonContainer.subviews.first as? UIImageView {
                    imageView.image = selectedImage
                    imageView.contentMode = .scaleAspectFill
                    imageView.clipsToBounds = true
                } else {
                    print("❌ Error: 해당 index의 UIView 안에서 UIImageView를 찾을 수 없음")
                }
            } else {
                print("Error: 선택한 이미지 개수가 허용된 범위를 초과함")
            }
        }
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
