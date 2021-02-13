//
//  CardView.swift
//  WordnikMVCApp
//
//  Created by Korlan Omarova on 12.02.2021.
//

import UIKit
import AVFoundation

final class CardView: UIView {

    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.specialPurple
        return label
    }()
    
    lazy var voiceButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.voice, for: .normal)
        button.addTarget(self, action: #selector(voiceButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect = .zero) {
        super .init(frame: frame)
        setupViews()
        setStyles()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func voiceButtonPressed(){
        let utterance = AVSpeechUtterance(string: textLabel.text!)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.rate = 0.5
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    private func setupViews(){
        [textLabel, voiceButton].forEach {
        self.addSubview($0)
        $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        voiceButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        voiceButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        voiceButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        voiceButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
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
