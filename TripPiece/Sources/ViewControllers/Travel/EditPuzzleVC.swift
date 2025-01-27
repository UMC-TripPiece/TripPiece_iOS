// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import SnapKit

class EditPuzzleVC: UIViewController {
    
    var travelId: Int
    
    private var thumbnails: [ThumbnailInfo?] = [nil, nil, nil, nil, nil, nil, nil, nil, nil]
    
    private var allImages: [ThumbnailInfo] = []
    
    private var deleteFlag: [Bool] = [false, false, false, false, false, false, false, false, false]
    
    init(travelId: Int) {
        self.travelId = travelId
        super.init(nibName: nil, bundle: nil)
        fetchAllPictures(travelId: travelId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private lazy var customNavBar: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "colorlogo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "취소", attributes: [
            .foregroundColor: UIColor(hex: "#A7A7A7"),
            .font: UIFont.systemFont(ofSize: 14)
        ]), for: .normal)
        button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return button
    }()
    
    @objc private func cancel() {
        navigationController?.popViewController(animated: true)
    }
    
    private lazy var completeButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "편집 완료", attributes: [
            .foregroundColor: UIColor(hex: "#6644FF"),
            .font: UIFont.systemFont(ofSize: 14)
        ]), for: .normal)
        button.addTarget(self, action: #selector(complete), for: .touchUpInside)
        return button
    }()
    
    @objc private func complete() {
        var pictureIdList: [Int] = [-1, -1, -1, -1, -1, -1, -1, -1, -1,]
        for image in allImages {
            guard let index = image.thumbnail_index else { continue }
            pictureIdList[index] = image.id
        }
        print(pictureIdList)
        PuzzleLogManager.updateThumbnail(
            param: UpdateThumbnailRequest(travelId: travelId, pictureIdList: pictureIdList),
            completion: { result in
                switch result {
                case .success(let value):
                    print(value)
                case .failure(let error):
                    print(error)
                }
            })
    }
    
    private lazy var initialCustomNavBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        // 여행기록 제목
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "여행조각 사진 수정"
            label.font = UIFont.boldSystemFont(ofSize: 22)
            label.textAlignment = .center
            return label
        }()
        
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bouncesVertically = true
//        scrollView.contentSize =
        return scrollView
    }()
    
    private lazy var scrollContentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var puzzleGrayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        view.addSubview(travelPlaceLabel)
        view.addSubview(puzzleBackgroundView)
        
        travelPlaceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
        }
        
        puzzleBackgroundView.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(travelPlaceLabel.snp.bottom).offset(15)
            make.width.height.equalTo(348)
            make.bottom.equalToSuperview().inset(40)
        }
        return view
    }()
    
    private lazy var travelPlaceLabel: UILabel = {
        let label = UILabel()
        label.text = "🇯🇵 도쿄, 일본"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - 퍼즐뷰
    private lazy var puzzleBackgroundView: UIView = {
        let view = UIView()
        //view.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        view.backgroundColor = .clear
        
        let puzzleImages = [
            puzzleImage1,
            puzzleImage2,
            puzzleImage3,
            puzzleImage4,
            puzzleImage5,
            puzzleImage6,
            puzzleImage7,
            puzzleImage8,
            puzzleImage9,
        ]
        
        for i in 0..<9 {
            view.addSubview(puzzleImages[i])
            puzzleImages[i].tag = i
        }
        
        puzzleImage1.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }
            
        puzzleImage2.snp.makeConstraints { make in
            make.centerY.equalTo(puzzleImage1.snp.centerY)
            make.leading.equalTo(puzzleImage1.snp.trailing).offset(-23.5)
        }
            
        puzzleImage3.snp.makeConstraints { make in
            make.centerY.equalTo(puzzleImage1.snp.centerY)
            make.trailing.equalToSuperview()
        }
            
        puzzleImage4.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(puzzleImage1.snp.bottom).offset(-23)
        }
            
        puzzleImage5.snp.makeConstraints { make in
            make.centerX.equalTo(puzzleImage2.snp.centerX)
            make.centerY.equalTo(puzzleImage4.snp.centerY)
        }
            
        puzzleImage6.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(puzzleImage4.snp.centerY)
        }
            
        puzzleImage7.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalTo(puzzleImage9.snp.centerY)
        }
            
        puzzleImage8.snp.makeConstraints { make in
            make.leading.equalTo(puzzleImage7.snp.trailing).offset(-23.5)
            make.centerY.equalTo(puzzleImage9.snp.centerY)
        }
            
        puzzleImage9.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        return view
    }()
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        guard let index = sender.view?.tag else { return }
        
        if thumbnails[index] == nil { return }
        
        let puzzleImages = [
            puzzleImage1,
            puzzleImage2,
            puzzleImage3,
            puzzleImage4,
            puzzleImage5,
            puzzleImage6,
            puzzleImage7,
            puzzleImage8,
            puzzleImage9,
        ]
        
        if deleteFlag[index] {
            thumbnails[index] = nil
            for (i, image) in allImages.enumerated() {
                if image.thumbnail_index == index {
                    allImages[i].thumbnail_index = nil
                }
            }
            puzzleImages[index].image = UIImage(named: "puzzlePiece\(index+1)")!.withTintColor([Constants.Colors.mainPurple, Constants.Colors.mainPink, Constants.Colors.mainYellow, Constants.Colors.mint].randomElement()!!, renderingMode: .automatic)
        } else {
            puzzleImages[index].image = UIImage(named: "puzzletrash\(index)")
        }
        deleteFlag[index] = !deleteFlag[index]
        imageCollectionView.reloadData()
    }
    
    private func initializePuzzleImages() {
        let puzzleImages = [
            puzzleImage1,
            puzzleImage2,
            puzzleImage3,
            puzzleImage4,
            puzzleImage5,
            puzzleImage6,
            puzzleImage7,
            puzzleImage8,
            puzzleImage9,
        ]
        
        for i in 0..<9 {
            puzzleImages[i].image = UIImage(named: "puzzlePiece\(i+1)")!.withTintColor([Constants.Colors.mainPurple, Constants.Colors.mainPink, Constants.Colors.mainYellow, Constants.Colors.mint].randomElement()!!, renderingMode: .automatic)
            if deleteFlag[i] {
                puzzleImages[i].image = UIImage(named: "puzzletrash\(i)")
                continue
            }
            if let thumbnail = thumbnails[i], let url = URL(string: thumbnail.pictureUrl) {
                puzzleImages[i].sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder")) { [weak self] (image, error, cacheType, imageURL) in
                    guard let self = self else { return }
                    if let downloadedImage = image {
                        // Replace the main image with the downloaded image
                        let puzzleMaskImage = UIImage(named: "puzzlePiece\(i + 1)")!
                        let imageView = PuzzleManager.shared.createPuzzlePiece(image: downloadedImage, mask: puzzleMaskImage)
                        
                        // Replace the existing imageView with the new one containing the downloaded image
                        puzzleImages[i].image = imageView.image
                    }
                }
            }
        }
    }
    
    private lazy var puzzleImage1: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "puzzlePiece1")!.withTintColor([Constants.Colors.mainPurple, Constants.Colors.mainPink, Constants.Colors.mainYellow, Constants.Colors.mint].randomElement()!!, renderingMode: .automatic)
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(139.57)
            make.height.equalTo(114.78)
        }
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped(_:))))
        
        return imageView
    }()
    
    private lazy var puzzleImage2: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "puzzlePiece2")!.withTintColor([Constants.Colors.mainPurple, Constants.Colors.mainPink, Constants.Colors.mainYellow, Constants.Colors.mint].randomElement()!!, renderingMode: .automatic)
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(139.57)
            make.height.equalTo(114.78)
        }
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped(_:))))
        
        return imageView
    }()

    private lazy var puzzleImage3: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "puzzlePiece3")!.withTintColor([Constants.Colors.mainPurple, Constants.Colors.mainPink, Constants.Colors.mainYellow, Constants.Colors.mint].randomElement()!!, renderingMode: .automatic)
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(114.78)
            make.height.equalTo(114.78)
        }
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped(_:))))
        
        return imageView
    }()

    private lazy var puzzleImage4: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "puzzlePiece4")!.withTintColor([Constants.Colors.mainPurple, Constants.Colors.mainPink, Constants.Colors.mainYellow, Constants.Colors.mint].randomElement()!!, renderingMode: .automatic)
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(139.57)
            make.height.equalTo(139.57)
        }
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped(_:))))
        
        return imageView
    }()
    
    private lazy var puzzleImage5: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "puzzlePiece5")!.withTintColor([Constants.Colors.mainPurple, Constants.Colors.mainPink, Constants.Colors.mainYellow, Constants.Colors.mint].randomElement()!!, renderingMode: .automatic)
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(139.57)
            make.height.equalTo(139.57)
        }
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped(_:))))
        
        return imageView
    }()


    private lazy var puzzleImage6: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "puzzlePiece6")!.withTintColor([Constants.Colors.mainPurple, Constants.Colors.mainPink, Constants.Colors.mainYellow, Constants.Colors.mint].randomElement()!!, renderingMode: .automatic)
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(114.78)
            make.height.equalTo(139.57)
        }
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped(_:))))
        
        return imageView
    }()


    private lazy var puzzleImage7: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "puzzlePiece7")!.withTintColor([Constants.Colors.mainPurple, Constants.Colors.mainPink, Constants.Colors.mainYellow, Constants.Colors.mint].randomElement()!!, renderingMode: .automatic)
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(139.57)
            make.height.equalTo(139.57)
        }
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped(_:))))
        
        return imageView
    }()

    private lazy var puzzleImage8: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "puzzlePiece8")!.withTintColor([Constants.Colors.mainPurple, Constants.Colors.mainPink, Constants.Colors.mainYellow, Constants.Colors.mint].randomElement()!!, renderingMode: .automatic)
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(139.57)
            make.height.equalTo(139.57)
        }
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped(_:))))
        
        return imageView
    }()
    
    private lazy var puzzleImage9: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "puzzlePiece9")!.withTintColor([Constants.Colors.mainPurple, Constants.Colors.mainPink, Constants.Colors.mainYellow, Constants.Colors.mint].randomElement()!!, renderingMode: .automatic)
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(114.78)
            make.height.equalTo(139.57)
        }
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped(_:))))
        
        return imageView
    }()
    
    private lazy var imageSelectView: UIView = {
        let view = UIView()
        
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(imageCollectionView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.equalToSuperview().inset(22)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().inset(22)
        }
        
        imageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(21)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(58)
            make.height.equalTo( (allImages.count / 3 + min(1, allImages.count % 3)) * 120)
        }
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "여행조각 사진"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "퍼즐을 탭해서 해당 자리에 넣을 사진을 선택하세요 ;)"
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 2
        layout.itemSize = CGSize(width: 115, height: 115)
        layout.estimatedItemSize = CGSize(width: 115, height: 115)
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: ImageCollectionViewCell.self))
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private func updateCollectionViewHeight() {
        imageCollectionView.snp.updateConstraints { make in
            make.height.equalTo( (allImages.count / 3 + min(1, allImages.count % 3)) * 120)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(customNavBar)
        customNavBar.addSubview(cancelButton)
        customNavBar.addSubview(logoImageView)
        customNavBar.addSubview(completeButton)
        view.addSubview(initialCustomNavBar)
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        scrollContentView.addSubview(puzzleGrayView)
        scrollContentView.addSubview(imageSelectView)
        setConstraints()
    }
    
    func setConstraints() {
        customNavBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(48)
        }
        logoImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 105.72, height: 25.5))
        }
        cancelButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(22)
            make.centerY.equalToSuperview()
        }
        
        completeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-22)
            make.centerY.equalToSuperview()
        }
        initialCustomNavBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(customNavBar.snp.bottom).offset(30)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(initialCustomNavBar.snp.bottom).offset(25)
            make.leading.trailing.bottom.equalToSuperview()
        }
        scrollContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        puzzleGrayView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
        imageSelectView.snp.makeConstraints { make in
            make.top.equalTo(puzzleGrayView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func fetchAllPictures(travelId: Int) {
        PuzzleLogManager.fetchAllPictures(travelId: travelId) { [weak self] result in
            switch result {
            case .success(let value):
                self?.allImages = value.result
                for thumbnailInfo in value.result {
                    guard let index = thumbnailInfo.thumbnail_index else { continue }
                    self?.thumbnails[index] = thumbnailInfo
                }
                self?.initializePuzzleImages()
                self?.updateCollectionViewHeight()
                self?.imageCollectionView.reloadData()
                print(value.result)
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

extension EditPuzzleVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ImageCollectionViewCell.self), for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let url = URL(string: allImages[indexPath.row].pictureUrl ?? "") else { return cell }
        cell.mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder")) { [weak self] (image, error, cacheType, imageURL) in
            print(imageURL)
            cell.mainImageView.image = image
        }
        if let thumbnailIndex = allImages[indexPath.row].thumbnail_index {
            if thumbnailIndex >= 0 {
                cell.setSelected(true)
                return cell
            }
        }
        cell.setSelected(false)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if allImages[indexPath.row].thumbnail_index != nil {
            return
        }
        var index: Int? = nil
        for (i, thumbnail) in thumbnails.enumerated() {
            guard let thumbnail = thumbnail else {
                index = i
                break
            }
        }
        guard let index = index else { return }
        allImages[indexPath.row].thumbnail_index = index
        thumbnails[index] = allImages[indexPath.row]
        initializePuzzleImages()
        collectionView.reloadData()
    }
}
