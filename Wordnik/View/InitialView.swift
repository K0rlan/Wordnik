//
//  InitialView.swift
//  Wordnik
//
//  Created by Korlan Omarova on 14.02.2021.
//

import UIKit

class InitialView: UIView {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = Constants.blueGray
        label.text = "Enter random word"
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        self.backgroundColor = Constants.pewter
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }

}
