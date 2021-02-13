//
//  CardsViewController.swift
//
//
//  Created by Korlan Omarova on 13.02.2021.
//

import UIKit

class CardsViewController: UIViewController {
    
    lazy var roundDetectorFirst: SeparatorViews = {
        let view = SeparatorViews()
        view.layer.cornerRadius = 8
        view.backgroundColor = .red
        return view
    }()
    
    lazy var roundDetectorSecond: SeparatorViews = {
        let view = SeparatorViews()
        view.layer.cornerRadius = 8
        view.backgroundColor = .gray
        return view
    }()
    
    lazy var roundDetectorThird: SeparatorViews = {
        let view = SeparatorViews()
        view.layer.cornerRadius = 8
        view.backgroundColor = .gray
        return view
    }()
    
    lazy var roundDetectorFourth: SeparatorViews = {
        let view = SeparatorViews()
        view.layer.cornerRadius = 8
        view.backgroundColor = .gray
        return view
    }()
    
    lazy var roundDetectorFifth: SeparatorViews = {
        let view = SeparatorViews()
        view.layer.cornerRadius = 8
        view.backgroundColor = .gray
        return view
    }()
    
    lazy var detectStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 3
//        stackView.backgroundColor = .cyan
        return stackView
    }()
    var detectors = [UIView]()
    var dataText = [String]()
    var cardView = CardView()
    var cardViewTwo = CardView()
    var cardViewThird = CardView()
    var cardViewFour = CardView()
    var cardViewFifth = CardView()
    
    var isBeginning = false
    var isEnding = false
    
    var cardViews = [CardView]()
    var count = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupViews()
        dataText = DataSynonims.sharedInstance.arr
        
        
        cardViews = [cardView, cardViewTwo, cardViewThird, cardViewFour, cardViewFifth]
        detectors = [roundDetectorFirst, roundDetectorSecond, roundDetectorThird, roundDetectorFourth, roundDetectorFifth]
        setTextForCards()
        addPanGesture(view: cardView)
        
        
    }
    
    func addPanGesture(view: UIView) {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(pan)
        
    }
    
    var currentIndex = 0
    
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        
        let fileView = sender.view!
        currentIndex = cardViews.firstIndex(of: fileView as! CardView)!
//        print(currentIndex)
//        print(cardViews.index(after: currentIndex))
        var nextView: CardView = fileView as! CardView
        var previousView: UIView = fileView
        if currentIndex != 0{
             previousView = cardViews[cardViews.index(before: currentIndex)]
        }
        if currentIndex != 4{
            nextView = cardViews[cardViews.index(after: currentIndex)]
//            nextView.setText(dataText[currentIndex + 1])
        }
        
        switch sender.state {
        case .began, .changed:
            moveViewWithPan(view: fileView, sender: sender)
            
        case .ended:
            if self.currentIndex == 0 {
                UIView.animate(withDuration: 0.7, animations: {
                   
                    fileView.center = CGPoint(x: self.view.center.x - 285,y: fileView.center .y)
                    
                    nextView.center = CGPoint(x: nextView.center.x  - 285,y: fileView.center.y)
                    self.addPanGesture(view: nextView)
                    self.detectorAssign(index: self.currentIndex+1)
                
                })
            }else if self.currentIndex == 4{
                UIView.animate(withDuration: 0.7, animations: {
                  
                    fileView.center = CGPoint(x: self.view.center.x + 285,y: fileView.center .y)
                      
                    previousView.center = CGPoint(x: previousView.center.x  + 285,y: fileView.center.y)
                    self.addPanGesture(view: previousView)
                    self.detectorAssign(index: self.currentIndex-1)
                        
                })
            }else{
            UIView.animate(withDuration: 0.7, animations: {
               
                if sender.location(in: fileView).x > 125{
                    if self.currentIndex != 4{
                    fileView.center = CGPoint(x: self.view.center.x - 285,y: fileView.center .y)
                    }
                    nextView.center = CGPoint(x: nextView.center.x  - 285,y: fileView.center.y)
                    self.addPanGesture(view: nextView)
                    self.detectorAssign(index: self.currentIndex+1)
                    
                }else if sender.location(in: fileView).x < 125 {
                    if self.currentIndex != 0{
                    fileView.center = CGPoint(x: self.view.center.x + 285,y: fileView.center .y)
                    }
                    previousView.center = CGPoint(x: previousView.center.x  + 285,y: fileView.center.y)
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
        
        for i in 0..<dataText.count{
            cardViews[i].setText(dataText[i])
        }
        
        detectStackView.addArrangedSubview(roundDetectorFirst)
        detectStackView.addArrangedSubview(roundDetectorSecond)
        detectStackView.addArrangedSubview(roundDetectorThird)
        detectStackView.addArrangedSubview(roundDetectorFourth)
        detectStackView.addArrangedSubview(roundDetectorFifth)

    }
    func detectorAssign(index: Int){
        detectors[index].backgroundColor = .red
        detectors.forEach {
            if $0 != detectors[index]{
            $0.backgroundColor = .gray
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
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        cardView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        detectStackView.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 20).isActive = true
        detectStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        detectStackView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        roundDetectorFirst.widthAnchor.constraint(equalToConstant: 15).isActive = true
        roundDetectorSecond.widthAnchor.constraint(equalToConstant: 15).isActive = true
        roundDetectorThird.widthAnchor.constraint(equalToConstant: 15).isActive = true
        roundDetectorFourth.widthAnchor.constraint(equalToConstant: 15).isActive = true
        roundDetectorFifth.widthAnchor.constraint(equalToConstant: 15).isActive = true
        
        cardViewTwo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        cardViewTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 250).isActive = true
        cardViewTwo.heightAnchor.constraint(equalToConstant: 200).isActive = true
        cardViewTwo.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        cardViewThird.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        cardViewThird.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 250).isActive = true
        cardViewThird.heightAnchor.constraint(equalToConstant: 200).isActive = true
        cardViewThird.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        cardViewFour.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        cardViewFour.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 250).isActive = true
        cardViewFour.heightAnchor.constraint(equalToConstant: 200).isActive = true
        cardViewFour.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        cardViewFifth.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        cardViewFifth.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 250).isActive = true
        cardViewFifth.heightAnchor.constraint(equalToConstant: 200).isActive = true
        cardViewFifth.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        
        
    }
}

