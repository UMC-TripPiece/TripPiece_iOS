//
//  Untitled.swift
//  MyWorldApp
//
//  Created by 김나연 on 12/14/24.
//

// Reusable View Controller for Different Content Types
import UIKit
import SnapKit

// Define the ContentType for different content views
enum ContentType {
    case photo
    case video
    case text

    var title: String {
        switch self {
        case .photo: return "사진 추가"
        case .video: return "동영상 추가"
        case .text: return "메모"
        }
    }

    var subtitle: String {
        switch self {
        case .photo: return "사진을 추가한 후 설명을 작성해보세요!"
        case .video: return "동영상을 추가한 후 설명을 작성해보세요!"
        case .text: return "여행하면서 느낀 것들을 글로 표현해보세요!"
        }
    }

    var placeholder: String {
        switch self {
        case .photo: return "| 사진에 대해 설명해주세요! (100자 이내)"
        case .video: return "| 영상에 대해 설명해주세요! (100자 이내)"
        case .text: return "| 메모를 작성해주세요 (100자 이내)"
        }
    }
}

// NetworkManager placeholder for Moya integration
class ContentNetworkManager {
    static let shared = ContentNetworkManager()
    private init() {}

    // Placeholder for GET request
    func fetchContent(travelId: Int, type: ContentType, completion: @escaping (Result<Void, Error>) -> Void) {
        // Moya GET request logic goes here
        completion(.success(())) // Placeholder
    }

    // Placeholder for POST request
    func postContent(travelId: Int, type: ContentType, memo: String, images: [UIImage]?, completion: @escaping (Result<Void, Error>) -> Void) {
        // Moya POST request logic goes here
        completion(.success(())) // Placeholder
    }
}

// Reusable LogViewController
class ContentLogViewController: UIViewController {
    private let contentType: ContentType
    private let travelId: Int

    // MARK: - UI Components
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = contentType.title
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = contentType.subtitle
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .darkGray
        return label
    }()

    private lazy var memoTextView: UITextView = {
        let textView = UITextView()
        textView.text = contentType.placeholder
        textView.textColor = .lightGray
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
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

    // MARK: - Initializer
    init(contentType: ContentType, travelId: Int) {
        self.contentType = contentType
        self.travelId = travelId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDismissKeyboardGesture()
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(memoTextView)
        view.addSubview(addButton)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(20)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
        }

        memoTextView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(150)
        }

        addButton.snp.makeConstraints { make in
            make.top.equalTo(memoTextView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }

    private func updateAddButtonState() {
        let isMemoValid = !memoTextView.text.isEmpty && memoTextView.text != contentType.placeholder
        addButton.isEnabled = isMemoValid
        addButton.backgroundColor = isMemoValid ? .systemBlue : .lightGray
    }

    @objc private func addRecord() {
        ContentNetworkManager.shared.postContent(travelId: travelId, type: contentType, memo: memoTextView.text, images: selectedImages) { result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    print("Record added successfully!")
                    self.dismiss(animated: true)
                case .failure(let error):
                    print("Error adding record: \(error.localizedDescription)")
                }
            }
        }
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

// MARK: - UITextViewDelegate
extension ContentLogViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == contentType.placeholder {
            textView.text = ""
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = contentType.placeholder
            textView.textColor = .lightGray
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        updateAddButtonState()
    }
}
