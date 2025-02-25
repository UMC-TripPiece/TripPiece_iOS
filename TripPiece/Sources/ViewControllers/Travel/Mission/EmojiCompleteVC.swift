//
//  EmojiCompleteViewController.swift
//  MyWorldApp
//
//  Created by 반성준 on 8/21/24.
//

import UIKit

class EmojiCompleteVC: UIViewController {
    // 기록 추가 완료를 나타내는 이미지뷰
    private lazy var checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "PuzzleCheck4") // 완료 이미지 설정
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
    
    private lazy var previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "dum4")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var previewSubLabel: UILabel = {
        let label = UILabel()
        label.text = "이땐 이랬어요 :)"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    //이모지 미리보기 라벨
    private lazy var emojiPreviewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var previewStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [previewImageView, previewSubLabel, emojiPreviewLabel])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        return stackView
    }()
    
    // 완료 버튼
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.backgroundColor = UIColor(named: "Main3")
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
            make.height.equalTo(248)
        }
        
        previewStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        
        doneButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(30)
            make.leading.trailing.equalToSuperview().inset(21)
            make.height.equalTo(50)
        }
    }
    
    // 미리보기 텍스트 설정 메서드
    func setPreviewText(_ memoText: String, emojis: [String?]) {
        emojiPreviewLabel.text = emojis.compactMap { $0 }.joined(separator: " ")
    }
    
    // 현재 날짜를 반환하는 메서드
    private func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        return formatter.string(from: Date())
    }
    
    // 완료 버튼 클릭 시 호출되는 메서드
    @objc private func doneButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
