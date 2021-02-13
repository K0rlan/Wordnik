//
//  AntonymsView.swift
//  Wordnik
//
//  Created by Korlan Omarova on 14.02.2021.
//

import UIKit

class AntonymsView: UIView {

    
    lazy var roundDetectorFirst: UIView = {
        let view = SeparatorViews()
        view.layer.cornerRadius = 4
        view.backgroundColor = Constants.specialYellow
        return view
    }()
    
    lazy var roundDetectorSecond: UIView = {
        let view = SeparatorViews()
        view.layer.cornerRadius = 4
        view.backgroundColor = Constants.blueGray
        return view
    }()
    
    lazy var roundDetectorThird: UIView = {
        let view = SeparatorViews()
        view.layer.cornerRadius = 4
        view.backgroundColor = Constants.blueGray
        return view
    }()
    
    lazy var roundDetectorFourth: UIView = {
        let view = SeparatorViews()
        view.layer.cornerRadius = 4
        view.backgroundColor = Constants.blueGray
        return view
    }()
    
    lazy var roundDetectorFifth: UIView = {
        let view = SeparatorViews()
        view.layer.cornerRadius = 4
        view.backgroundColor = Constants.blueGray
        return view
    }()
    
    lazy var detectStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 2
        return stackView
    }()
    
    var detectors = [UIView]()
    
    var cardView = CardView()
    var cardViewTwo = CardView()
    var cardViewThird = CardView()
    var cardViewFour = CardView()
    var cardViewFifth = CardView()

    var cardViews = [CardView]()

    var currentIndex = 0
    var data = [String]()
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupViews()
        data = DataSingleton.sharedInstance.antonyms
        
        cardViews = [cardView, cardViewTwo, cardViewThird, cardViewFour, cardViewFifth]
        detectors = [roundDetectorFirst, roundDetectorSecond, roundDetectorThird, roundDetectorFourth, roundDetectorFifth]
        setTextForCards()
        addPanGesture(view: cardView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addPanGesture(view: UIView) {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(pan)
        
    }
    
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        
        let fileView = sender.view!
        currentIndex = cardViews.firstIndex(of: fileView as! CardView)!
        var nextView: CardView = fileView as! CardView
        var previousView: UIView = fileView
        
        if currentIndex != 0{
            previousView = cardViews[cardViews.index(before: currentIndex)]
        }
        if currentIndex != 4{
            nextView = cardViews[cardViews.index(after: currentIndex)]
        }
        
        switch sender.state {
        case .began, .changed:
            moveViewWithPan(view: fileView, sender: sender)
            
        case .ended:
            if self.currentIndex == 0 {
                UIView.animate(withDuration: 0.7, animations: {
                    
                    fileView.center = CGPoint(x: self.center.x - 290,y: fileView.center .y)
                    nextView.center = CGPoint(x: nextView.center.x  - 290,y: fileView.center.y)
                    self.addPanGesture(view: nextView)
                    self.detectorAssign(index: self.currentIndex+1)
                    
                })
            }else if self.currentIndex == 4{
                UIView.animate(withDuration: 0.7, animations: {
                    
                    fileView.center = CGPoint(x: self.center.x + 290,y: fileView.center .y)
                    previousView.center = CGPoint(x: previousView.center.x  + 290,y: fileView.center.y)
                    self.addPanGesture(view: previousView)
                    self.detectorAssign(index: self.currentIndex-1)
                    
                })
            }else{
                UIView.animate(withDuration: 0.7, animations: {
                    
                    if sender.location(in: fileView).x > 125{
                        if self.currentIndex != 4{
                            fileView.center = CGPoint(x: self.center.x - 290,y: fileView.center .y)
                        }
                        nextView.center = CGPoint(x: nextView.center.x  - 290,y: fileView.center.y)
                        self.addPanGesture(view: nextView)
                        self.detectorAssign(index: self.currentIndex+1)
                        
                    }else if sender.location(in: fileView).x < 125 {
                        if self.currentIndex != 0{
                            fileView.center = CGPoint(x: self.center.x + 290,y: fileView.center .y)
                        }
                        previousView.center = CGPoint(x: previousView.center.x  + 290,y: fileView.center.y)
                        self.addPanGesture(view: previousView)
                        self.detectorAssign(index: self.currentIndex-1)
                    }
                })
            }
        default:
            break
        }
    }
    func setTextForCards(){
        
        for i in 0..<data.count{
            cardViews[i].setText(data[i])
        }
        
        detectStackView.addArrangedSubview(roundDetectorFirst)
        detectStackView.addArrangedSubview(roundDetectorSecond)
        detectStackView.addArrangedSubview(roundDetectorThird)
        detectStackView.addArrangedSubview(roundDetectorFourth)
        detectStackView.addArrangedSubview(roundDetectorFifth)
        
    }
    func detectorAssign(index: Int){
        detectors[index].backgroundColor = Constants.specialYellow
        detectors.forEach {
            if $0 != detectors[index]{
                $0.backgroundColor = Constants.blueGray
                $0.frame.size.height = 10
                $0.frame.size.width = 10
            }
        }
    }
    func moveViewWithPan(view: UIView, sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y)
        sender.setTranslation(CGPoint.zero, in: view)
    }
    
    private func setupViews(){
        [cardView, cardViewTwo, cardViewThird, cardViewFour, cardViewFifth, detectStackView].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
              
        cardView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cardView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40).isActive = true
        cardView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40).isActive = true
        cardView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        detectStackView.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 20).isActive = true
        detectStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        detectStackView.heightAnchor.constraint(equalToConstant: 8).isActive = true
        
        roundDetectorFirst.widthAnchor.constraint(equalToConstant: 8).isActive = true
        roundDetectorSecond.widthAnchor.constraint(equalToConstant: 8).isActive = true
        roundDetectorThird.widthAnchor.constraint(equalToConstant: 8).isActive = true
        roundDetectorFourth.widthAnchor.constraint(equalToConstant: 8).isActive = true
        roundDetectorFifth.widthAnchor.constraint(equalToConstant: 8).isActive = true
        
        cardViewTwo.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cardViewTwo.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 250).isActive = true
        cardViewTwo.heightAnchor.constraint(equalToConstant: 100).isActive = true
        cardViewTwo.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        cardViewThird.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cardViewThird.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 250).isActive = true
        cardViewThird.heightAnchor.constraint(equalToConstant: 100).isActive = true
        cardViewThird.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        cardViewFour.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cardViewFour.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 250).isActive = true
        cardViewFour.heightAnchor.constraint(equalToConstant: 100).isActive = true
        cardViewFour.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        cardViewFifth.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cardViewFifth.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 250).isActive = true
        cardViewFifth.heightAnchor.constraint(equalToConstant: 100).isActive = true
        cardViewFifth.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
    }

}
