// Copyright © 2024 TripPiece. All rights reserved

import Foundation
import UIKit

class TestVC: UIViewController {
    
    // MARK: - UI Elements
    private lazy var sampleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Click Me", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(didTapSampleButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var sampleLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, World!"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(sampleLabel)
        view.addSubview(sampleButton)
        
        // Layout using Auto Layout
        sampleLabel.translatesAutoresizingMaskIntoConstraints = false
        sampleButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sampleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sampleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            
            sampleButton.topAnchor.constraint(equalTo: sampleLabel.bottomAnchor, constant: 20),
            sampleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sampleButton.widthAnchor.constraint(equalToConstant: 120),
            sampleButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // MARK: - Actions
    @objc private func didTapSampleButton() {
        sampleLabel.text = "Button Clicked!"
        sampleLabel.textColor = .systemRed
    }
}
