//
//  CardView.swift
//  WordnikMVCApp
//
//  Created by Korlan Omarova on 12.02.2021.
//

import UIKit

final class CardView: UIView {

    lazy var textLabel: UILabel = {
        let label = UILabel()
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
        
        textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    public func setText(_ text: String){
        self.textLabel.text = text
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
