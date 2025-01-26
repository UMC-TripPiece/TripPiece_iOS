// Copyright © 2024 TripPiece. All rights reserved

import UIKit

extension ColoringVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedColors.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorPuzzleCell.identifier, for: indexPath) as! ColorPuzzleCell
        // 마지막 셀은 + 버튼
        if indexPath.item == selectedColors.count {
            let addButton = createButton(
                image: UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate),
                target: self,
                action: #selector(didTapAddButton(_:)),
                buttonImageSize: CGSize(width: 20, height: 20)
            )
            addButton.tintColor = UIColor(named: "Black3")
            addButton.setImage(addButton.image(for: .normal)?.withRenderingMode(.alwaysTemplate),for: .normal)
            cell.configure(with: addButton)
            addButton.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        } else {
            // 기존 퍼즐 색상 버튼
            let color = selectedColors[indexPath.item]
            let baseImage = UIImage(named: "puzzle_purple")
            let coloredImage = baseImage?.tinted(with: UIColor(hex: color) ?? UIColor.black)
            let button = createButton(
                image: coloredImage, // 이미지 이름을 동적으로 설정
                target: self,
                action: #selector(didTapColorButton(_:)),
                buttonImageSize: CGSize(width: 38, height: 38)
            )
            button.backgroundColor = .clear
            button.accessibilityIdentifier = color // 색상 정보를 버튼에 저장
            cell.configure(with: button)
        }

        return cell
    }
    
}

extension UIImage {
    /// 이미지에 특정 색상을 입혀서 반환하는 함수
    func tinted(with color: UIColor) -> UIImage? {
        return self.withTintColor(color, renderingMode: .alwaysOriginal)
    }
}
