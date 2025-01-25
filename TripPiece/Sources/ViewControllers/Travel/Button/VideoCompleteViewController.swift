//
//  VideoCompleteViewController.swift
//  MyWorldApp
//
//  Created by 김나연 on 8/21/24.
//

import UIKit
import SnapKit

class VideoCompleteViewController: UIViewController {
    
    // 기록 추가 완료를 나타내는 이미지뷰
    private lazy var checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "PuzzleCheck2") // 완료 이미지 설정
        return imageView
    }()
    
    // 완료 메시지 레이블
    private lazy var completionLabel: UILabel = {
        let label = UILabel()
        label.text = "기록 추가 완료!"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textAlignment = .center
        return label
    }()
    
    // 날짜 레이블
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = getCurrentDate() // 현재 날짜를 표시
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    
    // 미리보기 레이블
    private lazy var previewLabel: UILabel = {
        let label = UILabel()
        label.text = "미리보기"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .lightGray
        label.textAlignment = .left
        return label
    }()
    
    // 썸네일 이미지와 텍스트를 감싸는 스택 뷰
    private lazy var thumbnailContainerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 5
        return view
    }()
    
    // 썸네일 이미지를 표시할 이미지뷰
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    // 텍스트를 표시할 텍스트뷰
    private lazy var previewTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    private lazy var previewStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [thumbnailImageView, previewTextView])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        return stackView
    }()
    
    // 완료 버튼
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.backgroundColor = UIColor(named: "Main2")
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    // UI 구성 메서드
    private func setupUI() {
        view.addSubview(checkImageView)
        view.addSubview(completionLabel)
        view.addSubview(dateLabel)
        
        view.addSubview(previewLabel)
        view.addSubview(thumbnailContainerView)
        view.addSubview(thumbnailImageView)
        
        thumbnailContainerView.addSubview(previewStackView)
        
        view.addSubview(doneButton)
        
        // 레이아웃 설정
        checkImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(184)
            make.centerX.equalToSuperview()
        }
        
        completionLabel.snp.makeConstraints { make in
            make.top.equalTo(checkImageView.snp.bottom).offset(17)
            make.centerX.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(completionLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        previewLabel.snp.makeConstraints{ make in
            make.top.equalTo(dateLabel.snp.bottom).offset(114)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        thumbnailContainerView.snp.makeConstraints { make in
            make.top.equalTo(previewLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(21)
            make.height.equalTo(239)
        }
        
        previewStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        
        thumbnailImageView.snp.makeConstraints { make in
            make.height.equalTo(162)
        }
        
        doneButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(30)
            make.leading.trailing.equalToSuperview().inset(21)
            make.height.equalTo(50)
        }
    }
    
    // 현재 날짜를 반환하는 메서드
    private func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        return formatter.string(from: Date())
    }
    
    // 썸네일 이미지와 텍스트를 설정하는 메서드
    func configure(with image: UIImage, text: String) {
        thumbnailImageView.image = image
        previewTextView.text = text
    }
    
    func setPreviewText(_ text: String) {
        previewTextView.text = text
    }
    func setVideoComplete(with image: UIImage, text: String) {
        thumbnailImageView.image = image
        previewTextView.text = text
    }
    
    // 완료 버튼 클릭 시 호출되는 메서드
    @objc private func doneButtonTapped() {
        var targetViewController = presentingViewController
         
        while let presentingVC = targetViewController?.presentingViewController {
            targetViewController = presentingVC
        }
         
        targetViewController?.dismiss(animated: true) {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let tabBarController = windowScene.windows.first?.rootViewController as? TabBar {
                    tabBarController.selectedIndex = 1 // "나의 기록" 탭으로 이동
                }
            }
    }
}
