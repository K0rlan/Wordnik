//
//  SynonimsCollectionViewCell.swift
//  WordnikMVCApp
//
//  Created by Korlan Omarova on 12.02.2021.
//

import UIKit

class SynonimsCollectionViewCell: UICollectionViewCell {
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect = .zero) {
        super .init(frame: frame)
        setupViews()
        setStyles()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        self.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        textLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        
        self.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        
    }
    
    private func setStyles(){
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        self.backgroundColor = .white

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 3, height: 4)
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.3
        self.layer.masksToBounds = false
        
    }
}
