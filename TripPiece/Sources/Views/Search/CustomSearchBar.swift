// Copyright © 2024 TripPiece. All rights reserved

import UIKit

class CustomSearchBar: UIView {
    
    // MARK: - Properties
    
    var onTextDidChange: ((String) -> Void)? // 텍스트 변경 시 호출될 클로저
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        
        searchBar.layer.cornerRadius = 5
        searchBar.layer.masksToBounds = true
        searchBar.backgroundImage = UIImage()  // 서치바의 기본 배경을 제거
        searchBar.barTintColor = .clear
        searchBar.backgroundColor = UIColor(white: 1, alpha: 0.8)// 약간 투명한 배경 설정
        searchBar.layer.borderColor = Constants.Colors.mainPurple?.cgColor
        
        //custom search bar의 그림자 설정
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 10
        
        if let textField = searchBar.searchTextField as? UITextField {
            textField.backgroundColor = UIColor.clear
            textField.borderStyle = .none
            textField.layer.cornerRadius = 12
            textField.layer.masksToBounds = true
        }
        
        return searchBar
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        self.addSubview(searchBar)
        setupConstraints()
    }
    
    private func setupConstraints() {
        searchBar.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
            
        })
    }
}

// MARK: - UISearchBarDelegate

extension CustomSearchBar: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.layer.borderWidth = searchBar.text == "" ? 0 : 1
        // 테두리 추가
        searchBar.layer.borderColor = Constants.Colors.mainPurple?.cgColor
        onTextDidChange?(searchText) // 텍스트가 변경될 때 클로저 호출
    }
}
