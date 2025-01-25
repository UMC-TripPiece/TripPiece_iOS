//
//  File.swift
//  MyWorldApp
//
//  Created by 김나연 on 8/22/24.
//

import UIKit
import SnapKit

class PhotoCompleteViewController: UIViewController {

    var images: [UIImage] = []
    var memoText: String = ""

    private lazy var checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "PuzzleCheck1")
        return imageView
    }()
    
    private lazy var completionLabel: UILabel = {
        let label = UILabel()
        label.text = "기록 추가 완료!"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = getCurrentDate() // 현재 날짜를 표시
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    
    private lazy var previewLabel: UILabel = {
        let label = UILabel()
        label.text = "미리보기"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .lightGray
        label.textAlignment = .left
        return label
    }()
    
    private lazy var thumbnailContainerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 5
        return view
    }()
    
    private lazy var previewImgStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = 10
            stackView.alignment = .center
            return stackView
        }()
    
    private lazy var previewStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [previewImgStackView, previewTextView])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var previewTextView: UITextView = {
        let textView = UITextView()
        textView.text = memoText
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.backgroundColor = UIColor(named: "Main")
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        view.addSubview(checkImageView)
        view.addSubview(completionLabel)
        view.addSubview(dateLabel)
        view.addSubview(previewLabel)
        
        view.addSubview(thumbnailContainerView)
        thumbnailContainerView.addSubview(previewStackView)
        view.addSubview(doneButton)
        
        adjustLayoutBasedOnImageCount()
    }
    
    private func setupLayout() {
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
            make.height.equalTo(232)
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
    
    //선택된 이미지 수에 따라 레이아웃 조정
    private func adjustLayoutBasedOnImageCount() {
        let imageCount = images.count
        
        if imageCount == 1 {
            // 이미지가 1개일 때 중앙에 크게 배치
            let imageView = createImageView(image: images[0])
            previewImgStackView.addArrangedSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.height.equalTo(72)
            }
        } else if imageCount == 2 {
            // 이미지가 2개일 때 수평으로 배치
            previewImgStackView.axis = .horizontal
            previewImgStackView.distribution = .fillEqually
            
            for image in images {
                let imageView = createImageView(image: image)
                previewImgStackView.addArrangedSubview(imageView)
            }
        } else if imageCount == 3 {
            // 이미지가 3개일 때 맨 위에 1개, 그 밑에 2개 배치
            let upperImageView = createImageView(image: images[0])
            previewImgStackView.addArrangedSubview(upperImageView)
            
            let lowerStackView = UIStackView()
            lowerStackView.axis = .horizontal
            lowerStackView.distribution = .fillEqually
            lowerStackView.spacing = 10
            previewImgStackView.addArrangedSubview(lowerStackView)
            
            for i in 1..<3 {
                let imageView = createImageView(image: images[i])
                lowerStackView.addArrangedSubview(imageView)
            }
            
            upperImageView.snp.makeConstraints { make in
                make.width.equalTo(144)
            }
        } else if imageCount == 4 {
            // 이미지가 4개일 때 2x2 그리드로 배치
            previewImgStackView.axis = .vertical
            
            let upperStackView = UIStackView()
            upperStackView.axis = .horizontal
            upperStackView.distribution = .fillEqually
            upperStackView.spacing = 10
            previewImgStackView.addArrangedSubview(upperStackView)
            
            let lowerStackView = UIStackView()
            lowerStackView.axis = .horizontal
            lowerStackView.distribution = .fillEqually
            lowerStackView.spacing = 10
            previewImgStackView.addArrangedSubview(lowerStackView)
            
            for i in 0..<2 {
                let imageView = createImageView(image: images[i])
                upperStackView.addArrangedSubview(imageView)
            }
            
            for i in 2..<4 {
                let imageView = createImageView(image: images[i])
                lowerStackView.addArrangedSubview(imageView)
            }
        }
    }
    
    private func createImageView(image: UIImage) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }
    
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
    
    private func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        return formatter.string(from: Date())
    }
}
