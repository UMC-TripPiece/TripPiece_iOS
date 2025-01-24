//
//  Untitled.swift
//  MyWorldApp
//
//  Created by 김나연 on 12/14/24.
//

import UIKit

// MARK: - BaseReusableLogViewController
class BaseReusableLogViewController: UIViewController {
    
    // MARK: - Properties
    private var titleText: String
    private var subtitleText: String
    private var placeholderText: String
    private var maxMemoLength: Int
    private var maxAttachments: Int
    private var iconImage: UIImage?

    private var selectedMedia: [UIImage] = [] {
        didSet {
            updateAddButtonState()
        }
    }

    // MARK: - UI Components
    private lazy var customNavBar: CustomNavigationLogoBar = {
        let nav = CustomNavigationLogoBar()
        nav.translatesAutoresizingMaskIntoConstraints = false
        nav.backgroundColor = .white
        return nav
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = titleText
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = subtitleText
        label.numberOfLines = 2
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor(named: "subtitle")
        return label
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = iconImage
        return imageView
    }()

    private lazy var memoTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = UIColor(named: "Black3")
        textView.text = placeholderText
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

    private lazy var mediaStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()

    // MARK: - Initializer
    init(title: String, subtitle: String, placeholder: String, maxMemoLength: Int, maxAttachments: Int, iconImage: UIImage?) {
        self.titleText = title
        self.subtitleText = subtitle
        self.placeholderText = placeholder
        self.maxMemoLength = maxMemoLength
        self.maxAttachments = maxAttachments
        self.iconImage = iconImage
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
        view.addSubview(customNavBar)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(iconImageView)
        view.addSubview(mediaStackView)
        view.addSubview(memoTextView)
        view.addSubview(addButton)
        setupMediaStackView()
        setConstraints()
    }

    private func setupMediaStackView() {
        for _ in 0..<maxAttachments {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "add photo")
            imageView.contentMode = .scaleAspectFit
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectMedia))
            imageView.addGestureRecognizer(tapGesture)
            mediaStackView.addArrangedSubview(imageView)
        }
    }

    private func setConstraints() {
        customNavBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(customNavBar.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
        }

        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.width.height.equalTo(40)
        }

        mediaStackView.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(100)
        }

        memoTextView.snp.makeConstraints { make in
            make.top.equalTo(mediaStackView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(150)
        }

        addButton.snp.makeConstraints { make in
            make.top.equalTo(memoTextView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
    }

    // MARK: - Actions
    @objc private func selectMedia() {
        // Media picker logic
    }

    @objc private func addRecord() {
        // Networking logic will be implemented later
    }

    private func updateAddButtonState() {
        let isMemoValid = !memoTextView.text.isEmpty && memoTextView.text != placeholderText
        addButton.isEnabled = !selectedMedia.isEmpty && isMemoValid
        addButton.backgroundColor = addButton.isEnabled ? .blue : .lightGray
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
extension BaseReusableLogViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = .lightGray
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= maxMemoLength
    }
}
