// Copyright © 2024 TripPiece. All rights reserved

import UIKit

class SelectedCityVC: UIViewController {
    
    var cityData: SearchedCityResponse? // 받아올 도시 정보

    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    
    
    // 오른쪽 위 'X'자 버튼
    private let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = UIColor(named: "Black3")
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private let countryImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = Constants.Colors.black5
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40 // 이미지뷰의 크기에 맞춰 반지름을 설정해야 함
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.text = "😵"  // 원하는 이모티콘 텍스트 설정
        label.font = UIFont.systemFont(ofSize: 60) // 레이블의 폰트 크기 조정
        label.textAlignment = .center
        return label
    }()
    
    private let numberOfPeoleLabel: UILabel = {
        let label = UILabel()
        let numberOfPeople = 0
        label.text = "\(numberOfPeople)명이 여행했어요!"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = Constants.Colors.mainPink
        label.textAlignment = .center
        return label
    }()
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "클릭된 도시가 없습니다"
        label.font = UIFont.systemFont(ofSize: 20, weight: .black)
        label.textAlignment = .center
        return label
    }()
    
    private let cityExplainBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#F9F9F9")
        return view
    }()

    private let cityExplainLabel: UILabel = {
        let label = UILabel()
        label.text = "클릭된 도시가 없습니다. 다시 한번 시도해주세요."
        label.textColor = Constants.Colors.black2
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let logStartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("여행 기록 시작", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor(hex: "#280595")?.withAlphaComponent(0.1)
        button.setTitleColor(Constants.Colors.mainPurple, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        return button
    }()
    
    private let mapColorButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("세계지도 색칠", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = Constants.Colors.mainPurple
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        return button
    }()
    
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 7
        stackView.distribution = .fillEqually
        return stackView
    }()


    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setupConstraints()
        addTargetToButtons()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4) // 반투명한 검정색 설정
        let randomInt = Int.random(in: 1...300)
        numberOfPeoleLabel.text = "\(randomInt)명이 여행했어요!"
        
        if let cityData = cityData {
            titleLabel.text = "\(cityData.cityName), \(cityData.countryName)"
            cityExplainLabel.text = cityData.cityDescription
            emojiLabel.text = cityData.countryImage
        }
    }
    
    // MARK: - UI Methods
    private func addSubViews() {
        view.addSubview(containerView)
        
        containerView.addSubview(countryImage)        // 레이블을 이미지 뷰에 추가
        countryImage.addSubview(emojiLabel)
        containerView.addSubview(numberOfPeoleLabel)
        containerView.addSubview(titleLabel)
        containerView.addSubview(cityExplainBackgroundView)
        containerView.addSubview(cityExplainLabel)
        containerView.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(logStartButton)
        buttonsStackView.addArrangedSubview(mapColorButton)
        containerView.addSubview(dismissButton)
    }
    
    
    private func setupConstraints() {
        let screenSize = UIScreen.main.bounds.size
        // Container view constraints
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.89230769)
            if screenSize.height >= 812 {
                make.height.equalToSuperview().multipliedBy(0.39454976)
            } else {
                make.height.equalToSuperview().multipliedBy(0.45)
            }
        }
        //나라 image
        countryImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(0.4)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(87)
        }
        emojiLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        // 도시를 여행한 사람들의 수
        numberOfPeoleLabel.snp.makeConstraints { make in
            make.top.equalTo(countryImage.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        // 도시 이름
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(numberOfPeoleLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        // 도시 설명
        cityExplainLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(cityExplainBackgroundView.snp.centerY)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        // UILabel 크기를 기준으로 backgroundView 크기 설정 (패딩 추가)
        cityExplainBackgroundView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(14)
            make.bottom.equalTo(buttonsStackView.snp.top).offset(-13)
        }
        // 버튼 stack view constraints
        buttonsStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.945402299)
            make.height.equalToSuperview().multipliedBy(0.12012012)
            make.bottom.equalToSuperview().inset(10)
        }
        //dismissButton constraints
        dismissButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.width.height.equalTo(14)
        }
    }
    
    
    
    //MARK: Setup Actions
    private func addTargetToButtons() {
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        mapColorButton.addTarget(self, action: #selector(mapColorButtonTapped(_:)), for: .touchUpInside)
        logStartButton.addTarget(self, action: #selector(logStartButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc private func dismissButtonTapped(_ sender: UIButton) {        // 모달로 표시된 뷰 컨트롤러를 닫음
        dismiss(animated: true, completion: nil)
    }
    
    @objc func logStartButtonTapped(_ sender: UIButton) {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first,
              let tabBarController = window.rootViewController as? UITabBarController else {
            return
        }

        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            tabBarController.selectedIndex = 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                print("notification 보냄")
                NotificationCenter.default.post(name: NSNotification.Name("PresentStartLogVC"), object: self.cityData)
            }
        }
    }
    
    
    
    // 세계지도 색칠하기
    @objc func mapColorButtonTapped(_ sender: UIButton) {
        let coloringVC = ColoringVC()
        coloringVC.modalPresentationStyle = .overCurrentContext
        coloringVC.modalTransitionStyle = .crossDissolve
        coloringVC.cityData = cityData
        present(coloringVC, animated: true, completion: nil)
    }
    
    
    
    
    
}
