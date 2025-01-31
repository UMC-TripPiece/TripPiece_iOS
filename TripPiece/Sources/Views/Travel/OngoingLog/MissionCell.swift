// Copyright © 2024 TripPiece. All rights reserved


import UIKit
import SnapKit

enum MissionEnum: Int {
    case selfie
    case liveVideo
    case emoji
}

class MissionCell: UIView {
    
    var onClickCell: ((MissionEnum) -> Void)?

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 264, height: 148)
        layout.minimumLineSpacing = 70
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast
        collectionView.isPagingEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MissionItemCell.self, forCellWithReuseIdentifier: "MissionItemCell")
        return collectionView
    }()

    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = Constants.Colors.mainPurple
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        return pageControl
    }()

    private var images: [UIImage] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(collectionView)
        addSubview(pageControl)

        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(148)
        }

        pageControl.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }

    func configure(images: [UIImage]) {
        self.images = images
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension MissionCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MissionItemCell", for: indexPath) as? MissionItemCell else {
            return UICollectionViewCell()
        }
        cell.configure(image: images[indexPath.row])
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        let currentIndex = round(scrollView.contentOffset.x / cellWidthIncludingSpacing)
        pageControl.currentPage = Int(currentIndex)
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing

        // 현재 인덱스를 계산
        let estimatedIndex = scrollView.contentOffset.x / cellWidthIncludingSpacing
        let index: Int
        if velocity.x > 0 {
            index = Int(ceil(estimatedIndex)) // 오른쪽으로 스크롤
        } else if velocity.x < 0 {
            index = Int(floor(estimatedIndex)) // 왼쪽으로 스크롤
        } else {
            index = Int(round(estimatedIndex)) // 속도가 없으면 가까운 셀로
        }

        // 타겟 오프셋을 설정
        let horizontalInset = (collectionView.frame.width - layout.itemSize.width) / 2
        targetContentOffset.pointee = CGPoint(x: CGFloat(index) * cellWidthIncludingSpacing, y: 0)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let missionEnum = MissionEnum(rawValue: indexPath.row) else { return }
        onClickCell?(missionEnum)
    }
}
extension MissionCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }

        let cellWidth = layout.itemSize.width
        let spacing = layout.minimumLineSpacing
        let totalWidth = cellWidth + spacing

        // 첫 번째와 마지막 셀을 가운데 정렬하기 위한 여백 계산
        let horizontalInset = (collectionView.frame.width - cellWidth) / 2
        return UIEdgeInsets(top: 0, left: horizontalInset, bottom: 0, right: horizontalInset)
    }
}


class MissionItemCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.1
        imageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        imageView.layer.shadowRadius = 4
        imageView.layer.masksToBounds = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(image: UIImage) {
        imageView.image = image
        
    }
}
