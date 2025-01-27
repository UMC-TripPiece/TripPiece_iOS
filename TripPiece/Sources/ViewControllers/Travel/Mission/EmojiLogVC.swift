import UIKit
import SnapKit

class EmojiLogVC: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    var travelId: Int
    
    init(travelId: Int) {
        self.travelId = travelId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    private var selectedEmojis: [String?] = [nil, nil, nil, nil]
    private var emojiButtons: [UIButton] = []
    private var underlineViews: [UIView] = []
    
    private var hiddenTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .default
        textField.isHidden = true
        return textField
    }()
    
    // MARK: - UI Components
    // 기존 코드 유지
    
    private lazy var customNavBar: CustomNavigationLogoBar = {
        let nav = CustomNavigationLogoBar()
        nav.backgroundColor = .white
        return nav
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "어떤 기분인가요?"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "지금 느끼는 감정을 \n4가지 이모지로 표현해 보세요!"
        label.numberOfLines = 2
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor(named: "subtitle")
        return label
    }()
    
    private lazy var titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "dum4")
        return imageView
    }()
    
    private lazy var grayBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "BgColor2")
        return view
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.text = "이모지"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private lazy var emojiStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var memoLabel: UILabel = {
        let label = UILabel()
        label.text = "메모"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private lazy var memoTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 10
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.text = "| 감정을 글로 표현해보세요 (100자 이내)"
        textView.textColor = .lightGray
        textView.delegate = self
        return textView
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("기록 추가", for: .normal)
        button.backgroundColor = UIColor(hex: "D3D3D3")
        button.layer.cornerRadius = 8
        button.isEnabled = false
        button.addTarget(self, action: #selector(addRecord), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        // UI 설정
        setupUI()
        setConstraints()
        
        // 숨겨진 텍스트 필드 추가
        view.addSubview(hiddenTextField)
        hiddenTextField.delegate = self
        
        // 키보드 숨기기
        setupDismissKeyboardGesture()
        
        // 뒤로가기 알림 설정
        NotificationCenter.default.addObserver(self, selector: #selector(handleBackButtonTap), name: .backButtonTapped, object: nil)
        
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupUI() {
        view.addSubview(customNavBar)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(titleImageView)
        
        view.addSubview(grayBackgroundView)
        grayBackgroundView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(emojiLabel)
        contentStackView.addArrangedSubview(emojiStackView)
        contentStackView.addArrangedSubview(memoLabel)
        contentStackView.addArrangedSubview(memoTextView)
        
        view.addSubview(addButton)
        
        // 이모지 선택 버튼 및 밑줄 추가
        for i in 0..<4 {
            let button = UIButton(type: .system)
            button.setTitle("", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 40)
            button.tag = i
            button.addTarget(self, action: #selector(selectEmoji(_:)), for: .touchUpInside)
            emojiButtons.append(button)
            
            let underline = UIView()
            underline.backgroundColor = .lightGray
            underlineViews.append(underline)
            
            let containerView = UIView()
            containerView.addSubview(button)
            containerView.addSubview(underline)
            emojiStackView.addArrangedSubview(containerView)
            
            button.snp.makeConstraints { make in
                make.centerX.equalTo(containerView)
                make.centerY.equalTo(containerView)
            }
            
            underline.snp.makeConstraints { make in
                make.top.equalTo(button.snp.bottom).offset(5)
                make.centerX.equalTo(containerView)
                make.height.equalTo(2)
                make.width.equalTo(40)
            }
        }
    }
    
    private func setConstraints() {
        customNavBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(48)
        }
        
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
            make.width.height.equalTo(85)
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
        
        emojiStackView.snp.makeConstraints { make in
            make.top.equalTo(emojiLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        
        memoTextView.snp.makeConstraints { make in
            make.top.equalTo(memoLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(memoTextView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    // MARK: - Actions
    
    @objc private func handleBackButtonTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func selectEmoji(_ sender: UIButton) {
        // 텍스트 필드 세션을 관리합니다.
        if hiddenTextField.isFirstResponder {
            hiddenTextField.resignFirstResponder()
        }
        
        hiddenTextField.tag = sender.tag
        hiddenTextField.keyboardType = .default
        hiddenTextField.becomeFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard !string.isEmpty else { return false }
        
        // 이모지 입력 여부 확인
        if string.unicodeScalars.first?.properties.isEmoji == true {
            let buttonTag = textField.tag
            selectedEmojis[buttonTag] = string
            emojiButtons[buttonTag].setTitle(string, for: .normal)
            underlineViews[buttonTag].backgroundColor = .systemRed
            
            hiddenTextField.resignFirstResponder()
            validateInput() // 이모지 입력 상태 검증
            return false
        }
        
        return false
    }
    
    // 메모 텍스트뷰
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "| 감정을 글로 표현해보세요 (100자 이내)"
            textView.textColor = .lightGray
        }
        validateInput() // 메모 입력 상태 검증
    }
    
    private func validateInput() {
        let isMemoValid = !(memoTextView.text.isEmpty || memoTextView.text == "| 감정을 글로 표현해보세요 (100자 이내)")
        let isEmojiSelected = !selectedEmojis.contains(nil)
        
        addButton.isEnabled = isMemoValid && isEmojiSelected
        addButton.backgroundColor = addButton.isEnabled ? UIColor.systemPink : UIColor(hex: "D3D3D3")
    }
    
    // MARK: - 기록 추가

    @objc private func addRecord() {
        guard let memoText = memoTextView.text, memoText != "| 감정을 글로 표현해보세요 (100자 이내)", !memoText.isEmpty else {
            print("메모를 입력하세요.")
            return
        }
        
        let nonNilEmojis = selectedEmojis.compactMap { $0 }
        
        MissionLogManager.postEmojiPiece(createEmojiPieceRequest: CreateEmojiPieceRequest(travelId: travelId, description: memoText, emojis: nonNilEmojis), completion: { [weak self] result in
            switch result {
            case .success(let response):
                guard let self = self else { return }
                let emojiCompleteVC = EmojiCompleteVC()
                emojiCompleteVC.modalPresentationStyle = .fullScreen
                emojiCompleteVC.setPreviewText(self.memoTextView.text, emojis: self.selectedEmojis)
                present(emojiCompleteVC, animated: true, completion: nil)
            case .failure(let error):
                print("Error occurred: \(error.localizedDescription)")
            }
        })
    }

    // 키보드 숨기기 제스처 설정
    private func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
