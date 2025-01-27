// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import SnapKit

final class StartLogVC: UIViewController,
                        UITextFieldDelegate,
                        UITextViewDelegate {
    
    // MARK: - UI (뷰 전담)
    public let rootView = StartLogView()
    
    // MARK: - 데이터 모델
    public var travelRequest = CreateTravelRequest(cityName: "",
                                                    countryName: "",
                                                    title: "",
                                                    startDate: "",
                                                    endDate: "")
    
    // 검색 결과
    private var searchResults: [[String: String]] = []
    
    // MARK: - 라이프 사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1) rootView 붙이기
        view.backgroundColor = .white
        view.addSubview(rootView)
        rootView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        // 2) 델리게이트/데이터소스
        rootView.travelTextView.delegate = self
        
        rootView.searchTableView.delegate = self
        rootView.searchTableView.dataSource = self
        rootView.searchTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // 기존엔 `shouldChangeCharactersIn` 메서드에서 검색어를 처리했지만,
        // 이제는 한글 완성형을 위해 editingChanged + markedTextRange 방식으로 전환
        let searchTextField = rootView.searchController.searchBar.searchTextField
        // editingChanged 이벤트 연결
        searchTextField.addTarget(self,
                                  action: #selector(searchTextFieldDidChange(_:)),
                                  for: .editingChanged)
        
        // 3) 버튼 액션
        rootView.addCountryButton.addTarget(self, action: #selector(showSearchController), for: .touchUpInside)
        rootView.startDateButton.addTarget(self, action: #selector(showStartDatePicker), for: .touchUpInside)
        rootView.endDateButton.addTarget(self, action: #selector(showEndDatePicker), for: .touchUpInside)
        rootView.addPhotoButton.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
        rootView.startLogButton.addTarget(self, action: #selector(tapStartLogButton), for: .touchUpInside)
        
        // 4) DatePicker 값 변경
        rootView.startDatePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        rootView.endDatePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        // 5) 키보드 내리기
        setupDismissKeyboardGesture()
        
        // 6) 뒤로가기 버튼 노티 (LogStartNavigationBar에서 post)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleBackButtonTap),
                                               name: .backButtonTapped,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .backButtonTapped, object: nil)
    }
    
    // MARK: - **한글 완성**을 위한 핵심 로직
    /// 한글 자음/모음이 조합 중(markedTextRange != nil)이면 검색 안 하고, 조합이 끝난 순간에만 실행
    @objc private func searchTextFieldDidChange(_ textField: UITextField) {
        // 아직 조합 중이면 return
        if let _ = textField.markedTextRange {
            return
        }
        
        // 조합이 끝난 상태
        guard let newText = textField.text, !newText.isEmpty else {
            // 빈 문자열 → 결과 초기화
            searchResults.removeAll()
            rootView.searchTableView.reloadData()
            rootView.searchTableView.isHidden = true
            return
        }
        
        // 완성된 문자열로 검색
        searchCities(keyword: newText)
    }
    
    // MARK: - 실제 네트워크 요청 → `searchResults` 업데이트 (Moya 예시)
    private func searchCities(keyword: String) {
        APIManager.MapProvider.request(.getMapSearch(keyword: keyword)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                do {
                    guard (200...299).contains(response.statusCode) else {
                        print("HTTP Error: \(response.statusCode)")
                        return
                    }
                    // JSON 파싱
                    if let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any],
                       let cityArray = json["result"] as? [[String: Any]] {
                        
                        var temp = [[String: String]]()
                        for cityDict in cityArray {
                            var converted = [String: String]()
                            for (k, v) in cityDict {
                                if let s = v as? String {
                                    converted[k] = s
                                }
                            }
                            temp.append(converted)
                        }
                        
                        self.searchResults = temp
                        self.rootView.searchTableView.isHidden = temp.isEmpty
                        self.rootView.searchTableView.reloadData()
                    }
                } catch {
                    print("JSON 파싱 에러: \(error)")
                }
            case .failure(let error):
                print("요청 실패: \(error)")
            }
        }
    }
    
    // MARK: - 뒤로가기
    @objc private func handleBackButtonTap() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - 검색 바 표시 / 숨기기
    @objc private func showSearchController() {
        rootView.searchController.alpha = 0
        rootView.searchController.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(rootView.searchController)
        rootView.searchController.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(21)
            make.trailing.equalToSuperview().offset(-21)
            make.top.equalTo(rootView.startNavBar.snp.bottom).offset(35)
            make.height.equalTo(48)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.rootView.searchController.alpha = 1
        }
    }
    
    @objc private func hideSearchController() {
        UIView.animate(withDuration: 0.3, animations: {
            self.rootView.searchController.alpha = 0
        }) { _ in
            self.rootView.searchController.removeFromSuperview()
        }
    }
    
    // MARK: - DatePicker
    @objc private func showStartDatePicker() {
        rootView.startDatePicker.isHidden.toggle()
        rootView.endDatePicker.isHidden = true
        
        let height: CGFloat = rootView.startDatePicker.isHidden ? 0 : 350
        rootView.startDatePicker.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func showEndDatePicker() {
        rootView.endDatePicker.isHidden.toggle()
        rootView.startDatePicker.isHidden = true
        
        let height: CGFloat = rootView.endDatePicker.isHidden ? 0 : 350
        rootView.endDatePicker.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let selectedDate = formatter.string(from: sender.date)
        
        if sender == rootView.startDatePicker {
            rootView.startDateButton.setTitle(selectedDate, for: .normal)
            travelRequest.updateInfo(startDate: selectedDate)
        } else {
            rootView.endDateButton.setTitle(selectedDate, for: .normal)
            travelRequest.updateInfo(endDate: selectedDate)
        }
        updateStartLogButtonState()
    }
    
    // MARK: - 키보드 숨기기
    private func setupDismissKeyboardGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - 사진 추가
    @objc private func addPhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    // MARK: - "여행 기록 시작하기" 버튼
    @objc private func tapStartLogButton() {
        startLog(with: travelRequest)
    }
    
    private func startLog(with request: CreateTravelRequest) {
        print("Travel Info: \(request)")
        // 네트워크 로직 (Moya/Alamofire 등)
        handleSuccessResponse()
    }
    
    private func handleSuccessResponse() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first,
           let tabBarController = window.rootViewController as? TabBar {
            
            let myLogVC = MyLogVC()
            let navC = UINavigationController(rootViewController: myLogVC)
            navC.tabBarItem = UITabBarItem(title: "나의 기록",
                                           image: UIImage(named: "My log"),
                                           tag: 2)
            navC.tabBarItem.badgeValue = "여행중"
            
            tabBarController.viewControllers?[1] = navC
            tabBarController.selectedIndex = 1
        } else {
            print("TabBarController not found.")
        }
    }
    
    // MARK: - 유효성 검사
    private func validateTravelInfo() -> Bool {
        !travelRequest.cityName.isEmpty &&
        !travelRequest.countryName.isEmpty &&
        !travelRequest.title.isEmpty &&
        !travelRequest.startDate.isEmpty &&
        !travelRequest.endDate.isEmpty &&
        travelRequest.startDate <= travelRequest.endDate
    }
    
    public func updateStartLogButtonState() {
        if validateTravelInfo() {
            rootView.startLogButton.isEnabled = true
            rootView.startLogButton.backgroundColor = UIColor(named: "Main") ?? .blue
        } else {
            rootView.startLogButton.isEnabled = false
            rootView.startLogButton.backgroundColor = UIColor(named: "Cancel") ?? .red
        }
    }
}

// MARK: - UITextViewDelegate (여행 제목 입력)
extension StartLogVC {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .darkText
        }
        centerTextVertically(textView)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "| 여행 제목을 입력해주세요 (15자 이내)"
            textView.textColor = .lightGray
        }
        centerTextVertically(textView)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        centerTextVertically(textView)
    }
    
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        travelRequest.updateInfo(title: updatedText)
        updateStartLogButtonState()
        
        centerTextVertically(textView)
        
        // 15자 제한
        return updatedText.count <= 15
    }
    
    private func centerTextVertically(_ textView: UITextView) {
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width,
                                                height: .greatestFiniteMagnitude))
        let topOffset = (textView.bounds.size.height - size.height * textView.zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        textView.contentOffset = CGPoint(x: 0, y: -positiveTopOffset)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate (검색 결과)
extension StartLogVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return searchResults.count + 1
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "HeaderCell")
            cell.textLabel?.text = "검색 결과"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            cell.backgroundColor = UIColor(white: 1, alpha: 0.8)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let cityData = searchResults[indexPath.row - 1]
            let cityName = cityData["cityName"] ?? ""
            let countryName = cityData["countryName"] ?? ""
            let countryImage = cityData["countryImage"] ?? ""
            
            cell.textLabel?.text = "\(countryImage) \(cityName), \(countryName)"
            cell.backgroundColor = UIColor(white: 1, alpha: 0.8)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row != 0 else { return }
        
        let cityData = searchResults[indexPath.row - 1]
        let cityName = cityData["cityName"] ?? ""
        let countryName = cityData["countryName"] ?? ""
        let countryImage = cityData["countryImage"] ?? ""
        
        // 타이틀 라벨
        rootView.titleLabel.text = "\(countryImage) \(cityName), \(countryName)"
        
        // travelRequest
        travelRequest.updateInfo(cityName: cityName, countryName: countryName)
        updateStartLogButtonState()
        
        // 검색창 숨기기
        rootView.searchTableView.isHidden = true
        hideSearchController()
        
        // addPhotoButton 등장
        showAddphotoBtnController()
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate (사진 추가)
extension StartLogVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let selectedImage = info[.editedImage] as? UIImage else {
            print("이미지를 가져오지 못했습니다.")
            return
        }
        
        guard let imageData = selectedImage.jpegData(compressionQuality: 0.8) else {
            print("이미지 데이터 변환 실패")
            return
        }
        
        // 썸네일 업데이트
        travelRequest.thumbnail = imageData
        
        // 원형 이미지
        let circularImage = makeCircularImage(image: selectedImage, size: CGSize(width: 60, height: 60))
        rootView.addPhotoButton.setImage(circularImage, for: .normal)
        rootView.addPhotoButton.layer.cornerRadius = 30
        rootView.addPhotoButton.clipsToBounds = true
        
        // 위치 다시 잡기
        rootView.addPhotoButton.snp.remakeConstraints { make in
            make.centerX.equalTo(rootView.startNavBar.snp.centerX)
            make.top.equalTo(rootView.startNavBar.snp.bottom).offset(24)
        }
        
        view.layoutIfNeeded()
    }
    
    private func makeCircularImage(image: UIImage, size: CGSize) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        UIBezierPath(ovalIn: rect).addClip()
        image.draw(in: rect)
        let circularImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return circularImage ?? image
    }
}

// MARK: - 기타 (국가 선택 후 addPhotoButton 애니메이션)
extension StartLogVC {
    @objc func showAddphotoBtnController() {
        UIView.animate(withDuration: 0.3, animations: {
            self.rootView.addCountryButton.transform = CGAffineTransform(scaleX: 0.63, y: 0.63)
            self.rootView.addCountryButton.snp.updateConstraints { make in
                make.centerX.equalToSuperview().offset(112)
            }
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.rootView.addPhotoButton.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.rootView.addPhotoButton.alpha = 1.0
            }
        })
    }
}
