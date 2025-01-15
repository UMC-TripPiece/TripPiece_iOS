// Copyright © 2024 TripPiece. All rights reserved

import UIKit

extension ColoringVC: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let selectedColor = viewController.selectedColor

        // 선택한 색상을 Hex로 변환하여 배열에 추가
        selectedColors.append(selectedColor.toHex() ?? "6744FF")
        saveSelectedColors(selectedColors)
        colorSelectionCollectionView.reloadData()
    }
}

extension ColoringVC {
    
    
    // MARK: - UI Methods
    // 공통된 UIButton 생성 함수
    public func createButton(image: UIImage?, target: Any?, action: Selector, buttonImageSize: CGSize) -> UIButton {
        let button = UIButton()
        button.isSelected = false
        button.backgroundColor = .clear
        button.tintColor = .clear
        
        // 이미지를 리사이즈하고 설정
        if let image = image {
            let resizedImage = image.resized(to: buttonImageSize)
            button.setImage(resizedImage, for: .normal)
        }

        //constraint 설정
        button.snp.makeConstraints { make in
            make.width.height.equalTo(53)
        }
        button.addTarget(target, action: action, for: .touchUpInside)
        
        return button
    }
    
    // 퍼즐 버튼 체크 표시 추가 함수
    private func addCheckmark(to button: UIButton) {
        let checkmarkImageView = UIImageView(image: UIImage(named: "checkmark"))
        checkmarkImageView.tag = 1001 // 체크마크를 식별할 수 있도록 tag 설정
        button.addSubview(checkmarkImageView)
        
        checkmarkImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(11)
            make.height.equalTo(8)
        }
    }
    // 체크 표시 제거 함수
    private func removeCheckmark(from button: UIButton) {
        let checkmarkTag = 1001 // 체크마크에 할당된 tag 값
                
        for subview in button.subviews where subview is UIImageView {
            if subview.tag == checkmarkTag {
                subview.removeFromSuperview()
            }
        }
    }

    //MARK: Setup Actions
    @objc func didTapAddButton(_ sender: UIButton) {
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        print("색깔 더하기 버튼 눌림!!!")
        present(colorPicker, animated: true, completion: nil)
    }
    
    @objc func didTapColorButton(_ sender: UIButton) {
        if let currentButton = selectedButton {
            if currentButton == sender {
                // 이미 선택된 버튼을 다시 클릭한 경우 선택 해제
                sender.isSelected = false
                // 기본 상태
                sender.backgroundColor = .clear // 기본 배경색
                sender.layer.shadowOpacity = 0
                removeCheckmark(from: sender)
                selectedButton = nil
                return
            } else {
                // 다른 버튼이 선택된 상태에서 새 버튼을 클릭한 경우
                // 기본 상태
                currentButton.backgroundColor = .clear // 기본 배경색
                currentButton.layer.shadowOpacity = 0
                currentButton.isSelected = false
                removeCheckmark(from: currentButton)
            }
        }

        // 새로운 버튼 선택
        sender.isSelected = true
        selectedButton = sender
        sender.backgroundColor = UIColor.white.withAlphaComponent(1) // 선택된 배경색
        sender.layer.cornerRadius = 5
        sender.layer.shadowColor = UIColor.black.cgColor
        sender.layer.shadowOpacity = 0.15
        sender.layer.shadowOffset = CGSize(width: 0, height: 2)
        sender.layer.shadowRadius = 1
        // 체크 표시 추가
        addCheckmark(to: sender)
        
    }
    
    // collectionview cell 길게 눌렀을 때
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        // 제스처가 시작될 때만 처리
        if gestureRecognizer.state == .began {
            let point = gestureRecognizer.location(in: colorSelectionCollectionView)
            if let indexPath = colorSelectionCollectionView.indexPathForItem(at: point), indexPath.item < selectedColors.count {
                if indexPath.item < defaultColors.count {
                    return
                }
                // Haptic Feedback 발생
                let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
                feedbackGenerator.impactOccurred()
                // 삭제 알림 띄우기
                showDeleteConfirmationAlert(for: indexPath.item)
            }
        }
    }

    
    
    func loadSelectedColors() -> [String] {
        // UserDefaults에서 저장된 색상 불러오기
        let savedColors = UserDefaults.standard.array(forKey: "selectedColors") as? [String] ?? []
        
        // 기본 색상 + 저장된 색상 합치기
        let combinedColors = defaultColors + savedColors
        print("userDefault-불러온 색상 배열: \(combinedColors)")
        return combinedColors
    }
    
    func saveSelectedColors(_ colors: [String]) {
        // 기본 색상을 제외하고 유저가 추가한 색상만 저장
        let userColors = colors.filter { !defaultColors.contains($0) }
        UserDefaults.standard.set(userColors, forKey: "selectedColors")
        print("userDefault-유저가 추가한 색상 저장 완료: \(userColors)")
    }
    
    // 저장한 색깔 삭제
    func deleteColor(at index: Int) {
        // 색상 배열에서 해당 색상 삭제
        selectedColors.remove(at: index)
        // 업데이트된 배열을 UserDefaults에 저장
        saveSelectedColors(selectedColors)
        // 컬렉션 뷰 갱신
        colorSelectionCollectionView.reloadData()
        print("색상 삭제 완료! 현재 색상 배열: \(selectedColors)")
    }

    
    func showDeleteConfirmationAlert(for index: Int) {
        let alert = UIAlertController(title: "삭제하시겠습니까?", message: "선택한 색상을 삭제하면 되돌릴 수 없습니다.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            // 선택한 색상 삭제
            self.deleteColor(at: index)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        present(alert, animated: true, completion: nil)
    }
}
