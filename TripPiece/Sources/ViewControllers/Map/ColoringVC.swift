// Copyright © 2024 TripPiece. All rights reserved


import UIKit
import SwiftyToaster

class ColoringVC: UIViewController {
    
    var cityData: SearchedCityResponse? // 받아올 도시 정보
    let defaultColors = ["6744FF", "FFB40F", "25CEC1", "FD2D69"]
    var selectedColors: [String] = []

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
        button.snp.makeConstraints { make in
            make.width.height.equalTo(14)
        }
        return button
    }()
    
    private let countryImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = Constants.Colors.black5
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25 // 이미지뷰의 크기에 맞춰 반지름을 설정해야 함
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.text = "😵"  // 원하는 이모티콘 텍스트 설정
        label.font = UIFont.systemFont(ofSize: 32) // 레이블의 폰트 크기 조정
        label.textAlignment = .center
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "클릭된 도시가 없습니다"
        label.font = UIFont.systemFont(ofSize: 16, weight: .black)
        label.textAlignment = .center
        return label
    }()
    
    private let colorSelectBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#F9F9F9")
        return view
    }()
    
    // 색상 선택 description label
    private let colorSelectDescriptionStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .leading
        
        let firstLabel: UILabel = {
            let label = UILabel()
            label.text = "색상 선택"
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.textColor = UIColor(hex: "#393939")
            return label
        }()

        let secondLabel: UILabel = {
            let label = UILabel()
            label.text = "색상은 나라 전체에 반영됩니다."
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = Constants.Colors.black2
            return label
        }()

        stackView.addArrangedSubview(firstLabel)
        stackView.addArrangedSubview(secondLabel)
        
        return stackView
    }()
    
    // 현재 선택된 버튼을 추적하는 변수
    public var selectedButton: UIButton? {
        didSet {
            // selectedButton이 설정될 때마다 saveButton의 상태를 업데이트
            saveButton.isEnabled = (selectedButton != nil)
        }
    }
    
    public lazy var colorSelectionCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 17
        layout.estimatedItemSize = CGSize(width: 54, height: 54) // 퍼즐 크기 설정
            
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ColorPuzzleCell.self, forCellWithReuseIdentifier: ColorPuzzleCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 13)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("취소", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor(hex: "#A4A4A4")?.withAlphaComponent(0.1)
        button.setTitleColor(UIColor(hex: "#636363"), for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        return button
    }()

    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("저장", for: .normal)
        // 비활성화 상태일 때
        button.setTitleColor(.lightGray, for: .disabled)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        // 활성화 상태일 때
        button.backgroundColor = Constants.Colors.mainPurple
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        return button
    }()

    /// 취소/완료 버튼
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
        setUpColorPicker()
        addTargetToButtons()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        saveButton.isEnabled = false // 기본적으로 비활성화
        
        if let cityData = cityData {
            titleLabel.text = "\(cityData.cityName), \(cityData.countryName)"
            emojiLabel.text = cityData.countryImage
        }
        
        
    }
    
    
    // MARK: - UI Methods
    private func addSubViews() {
        view.addSubview(containerView)
        containerView.addSubview(dismissButton)
        containerView.addSubview(countryImage)
        countryImage.addSubview(emojiLabel)
        containerView.addSubview(titleLabel)
        containerView.addSubview(colorSelectBackgroundView)
        containerView.addSubview(colorSelectDescriptionStack)
        containerView.addSubview(colorSelectionCollectionView)
        containerView.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(cancelButton)
        buttonsStackView.addArrangedSubview(saveButton)
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
        //dismissButton constraints
        dismissButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
        //country image
        countryImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(34)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(51)
        }
        emojiLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        // Title label constraints
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(countryImage.snp.bottom).offset(10)
        }
        // 색깔 선택 뷰 (수정 필요)
        colorSelectBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(17)
            make.bottom.equalTo(buttonsStackView.snp.top).offset(-13)
            make.horizontalEdges.equalToSuperview()
        }
        colorSelectDescriptionStack.snp.makeConstraints { make in
            make.top.equalTo(colorSelectBackgroundView.snp.top).offset(10)
            make.leading.equalToSuperview().inset(13)
        }
        // Color selection view constraints
        colorSelectionCollectionView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(colorSelectBackgroundView.snp.centerY).multipliedBy(1.1)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.height.equalTo(60)
        }
        // Cancel and done button constraints
        buttonsStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.945402299)
            make.height.equalToSuperview().multipliedBy(0.12012012)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    
    
    //MARK: Setup Actions
    private func setUpColorPicker() {
        // 저장된 색상 불러오기
        selectedColors = loadSelectedColors()
        colorSelectionCollectionView.reloadData()
        // 길게 누르기 제스처 추가
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        colorSelectionCollectionView.addGestureRecognizer(longPressGesture)
    }
    
    private func addTargetToButtons() {
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTapped(_:)), for: .touchUpInside)
    }
    
    // 취소 버튼 눌렸을 때
    @objc func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func dismissButtonTapped(_ sender: UIButton) {    // 모달로 표시된 뷰 컨트롤러를 전부 닫음
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    func dismissMultipleTimes(from viewController: UIViewController?, completion: @escaping () -> Void) {
        guard let viewController = viewController else {
            completion()
            return
        }
                
        // 두 번의 dismiss를 동시에 실행
        if let firstPresentingViewController = viewController.presentingViewController?.presentingViewController {
            viewController.dismiss(animated: false) // 첫 번째 뷰 닫기
            firstPresentingViewController.dismiss(animated: true, completion: completion) // 두 번째 뷰 닫기
        } else if let firstPresentingViewController = viewController.presentingViewController {
                viewController.dismiss(animated: true, completion: completion) // 한 번만 닫기
        } else {
            completion()
        }
    }
    
    private func dismissWhenEditing() {
        // 현재 화면에서 네비게이션 스택 닫기
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: false)
                
            navigationController.dismiss(animated: false)
        } else {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }




    @objc private func saveButtonTapped(_ sender: UIButton) {        // 서버에 해당 유저의 기록을 올릴 것
        guard let selectedColor = selectedButton?.accessibilityIdentifier else { return }
        
        self.getCountryStatsData { [weak self] result in
            guard let self = self else { return }
            guard let data = result else { return }
            guard let cityData = self.cityData else { return }
            
            //수정
            if data.cityIds.contains(cityData.cityId) {
                Toaster.shared.makeToast("색칠되었던 색상을 수정합니다.")
                editColor(selectedColor) { editResult in
                    switch editResult {
                    case .success(let message):
                        DispatchQueue.main.async {
                            self.dismissMultipleTimes(from: self) {
                                NotificationCenter.default.post(name: .updateCollectionView, object: nil)
                                NotificationCenter.default.post(name: .changeMapColor, object: nil)
                            }
                        }
                    case .failure(let error):
                        print("색상 수정 오류 발생: \(error.localizedDescription)")
                    }
                }
                // 첫 업로드
            } else {
                colorCountry(selectedColor) { result in
                    switch result {
                    case .success(let message):
                        DispatchQueue.main.async {
                            self.dismissMultipleTimes(from: self) {
                                NotificationCenter.default.post(name: .changeMapColor, object: nil)
                            }
                        }
                    case .failure(let error):
                        print("오류 발생: \(error.localizedDescription)")
                    }
                }
            }
            
        }
    }
        

    //MARK: API call
    func colorCountry(_ color: String, completion: @escaping (Result<Any, Error>) -> Void) {
        guard
            let cityData = cityData,
            let countryCode = CountryEnum.find(byName: cityData.countryName)?.rawValue
        else {
            return
        }

        let data = MapRequest(
            countryCode: "\(countryCode)",
            color: color,  // 서버에서 수정 완료되면 color로 수정할 것
            cityId: cityData.cityId
        )

        MapManager.postCountryColor(data) { isSuccess, response in
            if isSuccess {
                completion(.success("Color update successful"))
            } else {
                if let data = response?.data,  // 서버 응답 데이터 확인
                   let errorMessage = String(data: data, encoding: .utf8) {
                        print("서버 에러 메시지: \(errorMessage)")
                }
                        
                let error = NSError(domain: "MapError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Color update failed."])
                completion(.failure(error))
            }
        }
    }
    
    func editColor(_ color: String, completion: @escaping (Result<Any, Error>) -> Void) {
        guard
            let cityData = cityData,
            let countryCode = CountryEnum.find(byName: cityData.countryName)?.rawValue
        else {
            return
        }

        let data = MapRequest(
            countryCode: "\(countryCode)",
            color: color,  // 서버에서 수정 완료되면 color로 수정할 것
            cityId: cityData.cityId
        )
        
        MapManager.changeCountryColor(data) { isSuccess, response in
            if isSuccess {
                completion(.success("color change successful"))
            } else {
                if let data = response?.data,  // 서버 응답 데이터 확인
                   let errorMessage = String(data: data, encoding: .utf8) {
                        print("서버 에러 메시지: \(errorMessage)")
                }
                        
                let error = NSError(domain: "MapError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Color update failed."])
                completion(.failure(error))
            }
        }
    }
    
    
    func getCountryStatsData(completion: @escaping (StatsVisitRecord?) -> Void) {
        MapManager.getCountryStats { result in
            switch result {
            case .success(let statsInfo):
                completion(statsInfo.result)
            case .failure(let error):
                print("오류 발생: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    
}


extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage ?? self
    }
}




