//
//  MainViewController.swift
//  WordnikMVCApp
//
//  Created by Korlan Omarova on 12.02.2021.
//

import UIKit
import Moya
import AVFoundation

class MainViewController: UIViewController {
    
    lazy var searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
    lazy var definition: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var pronunciation: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    lazy var voiceButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.voice, for: .normal)
        button.alpha = 0
        button.addTarget(self, action: #selector(voiceButtonPressed), for: .touchUpInside)
        return button
    }()
    lazy var roundDetectorFirst: SeparatorViews = {
        let view = SeparatorViews()
        view.layer.cornerRadius = 5
        view.backgroundColor = .red
        return view
    }()
    
    lazy var roundDetectorSecond: SeparatorViews = {
        let view = SeparatorViews()
        view.layer.cornerRadius = 5
        view.backgroundColor = .gray
        return view
    }()
    
    lazy var roundDetectorThird: SeparatorViews = {
        let view = SeparatorViews()
        view.layer.cornerRadius = 5
        view.backgroundColor = .gray
        return view
    }()
    
    lazy var roundDetectorFourth: SeparatorViews = {
        let view = SeparatorViews()
        view.layer.cornerRadius = 5
        view.backgroundColor = .gray
        return view
    }()
    
    lazy var roundDetectorFifth: SeparatorViews = {
        let view = SeparatorViews()
        view.layer.cornerRadius = 5
        view.backgroundColor = .gray
        return view
    }()
    
    lazy var detectStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 3
        return stackView
    }()
    var detectors = [UIView]()
    
    var cardView = CardView()
    var cardViewTwo = CardView()
    var cardViewThird = CardView()
    var cardViewFour = CardView()
    var cardViewFifth = CardView()

    var cardViews = [CardView]()
    
//    lazy var collectionView : UICollectionView = {
//        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.scrollDirection = .horizontal
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
//        collectionView.showsHorizontalScrollIndicator = false
//
//        collectionView.register(SynonimsCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
//        collectionView.backgroundColor = .white
//        return collectionView
//    }()
    
    var data = [String]()
    let provider = MoyaProvider<APIService>()
    
    var searchText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        searchBar.delegate = self
        setupViews()
        
//        collectionView.delegate = self
//        collectionView.dataSource = self
        
        let button = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(recognizeCards))
        self.navigationItem.rightBarButtonItem  = button
        
        cardViews = [cardView, cardViewTwo, cardViewThird, cardViewFour, cardViewFifth]
        detectors = [roundDetectorFirst, roundDetectorSecond, roundDetectorThird, roundDetectorFourth, roundDetectorFifth]
        
        addPanGesture(view: cardView)
    }
   
    @objc func voiceButtonPressed(){
        let utterance = AVSpeechUtterance(string: searchText)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.rate = 0.5
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    @objc func recognizeCards(){
        DataSynonims.sharedInstance.arr = data
        let cardsViewController = CardsViewController()
        self.navigationController?.pushViewController(cardsViewController, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
//        collectionView.endEditing(true)
    }
    
    func addPanGesture(view: UIView) {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(pan)
        
    }
    
    var currentIndex = 0
    
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
                    
                    fileView.center = CGPoint(x: self.view.center.x - 290,y: fileView.center .y)
                    nextView.center = CGPoint(x: nextView.center.x  - 290,y: fileView.center.y)
                    self.addPanGesture(view: nextView)
                    self.detectorAssign(index: self.currentIndex+1)
                    
                })
            }else if self.currentIndex == 4{
                UIView.animate(withDuration: 0.7, animations: {
                    
                    fileView.center = CGPoint(x: self.view.center.x + 290,y: fileView.center .y)
                    previousView.center = CGPoint(x: previousView.center.x  + 290,y: fileView.center.y)
                    self.addPanGesture(view: previousView)
                    self.detectorAssign(index: self.currentIndex-1)
                    
                })
            }else{
                UIView.animate(withDuration: 0.7, animations: {
                    
                    if sender.location(in: fileView).x > 125{
                        if self.currentIndex != 4{
                            fileView.center = CGPoint(x: self.view.center.x - 290,y: fileView.center .y)
                        }
                        nextView.center = CGPoint(x: nextView.center.x  - 290,y: fileView.center.y)
                        self.addPanGesture(view: nextView)
                        self.detectorAssign(index: self.currentIndex+1)
                        
                    }else if sender.location(in: fileView).x < 125 {
                        if self.currentIndex != 0{
                            fileView.center = CGPoint(x: self.view.center.x + 290,y: fileView.center .y)
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
        [searchBar, definition, pronunciation, voiceButton, cardView, cardViewTwo, cardViewThird, cardViewFour, cardViewFifth, detectStackView].forEach {
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        pronunciation.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20).isActive = true
        pronunciation.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
//        pronunciation.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        pronunciation.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        voiceButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10).isActive = true
        voiceButton.leadingAnchor.constraint(equalTo: pronunciation.trailingAnchor, constant: 10).isActive = true
//        voiceButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        voiceButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        voiceButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        definition.topAnchor.constraint(equalTo: pronunciation.bottomAnchor, constant: 10).isActive = true
        definition.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        definition.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        definition.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
   
    
//        collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20).isActive = true
//        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        collectionView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        cardView.topAnchor.constraint(equalTo: definition.bottomAnchor, constant: 20).isActive = true
        cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        cardView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        detectStackView.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 20).isActive = true
        detectStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        detectStackView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        roundDetectorFirst.widthAnchor.constraint(equalToConstant: 10).isActive = true
        roundDetectorSecond.widthAnchor.constraint(equalToConstant: 10).isActive = true
        roundDetectorThird.widthAnchor.constraint(equalToConstant: 10).isActive = true
        roundDetectorFourth.widthAnchor.constraint(equalToConstant: 10).isActive = true
        roundDetectorFifth.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        cardViewTwo.topAnchor.constraint(equalTo: definition.bottomAnchor, constant: 20).isActive = true
        cardViewTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 250).isActive = true
        cardViewTwo.heightAnchor.constraint(equalToConstant: 100).isActive = true
        cardViewTwo.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        cardViewThird.topAnchor.constraint(equalTo: definition.bottomAnchor, constant: 20).isActive = true
        cardViewThird.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 250).isActive = true
        cardViewThird.heightAnchor.constraint(equalToConstant: 100).isActive = true
        cardViewThird.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        cardViewFour.topAnchor.constraint(equalTo: definition.bottomAnchor, constant: 20).isActive = true
        cardViewFour.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 250).isActive = true
        cardViewFour.heightAnchor.constraint(equalToConstant: 100).isActive = true
        cardViewFour.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        cardViewFifth.topAnchor.constraint(equalTo: definition.bottomAnchor, constant: 20).isActive = true
        cardViewFifth.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 250).isActive = true
        cardViewFifth.heightAnchor.constraint(equalToConstant: 100).isActive = true
        cardViewFifth.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
    }
    //MARK: - Networking -
    
    private func getSynonims(_ text: String){
        provider.request(.getSynonims(text: text)) { [weak self] result in
            switch result{
            case .success(let response):
                do {
                    let wordnikResponse = try JSONDecoder().decode([SynonymResponse].self, from: response.data)
                    guard let synonims = wordnikResponse.first else { return }
                    
                    self?.data = synonims.words
//                    self?.collectionView.reloadData()
                    self?.setTextForCards()
                } catch let error {
                    print("Error in parsing: \(error)")
                }
            case .failure(let error):
                let requestError = (error as NSError)
                print("Request Error message: \(error.localizedDescription), code: \(requestError.code)")
            }
        }
        
    }
    private func getAntonyms(_ text: String){
        provider.request(.getAntonym(text: text)) { [weak self] result in
            switch result{
            case .success(let response):
                do {
                    let antonymResponse = try JSONDecoder().decode([AntonymResponse].self, from: response.data)
                    guard let antonyms = antonymResponse.first else { return }
                    
                    print(antonyms)
                    
                } catch let error {
                    print("Error in parsing: \(error)")
                }
            case .failure(let error):
                let requestError = (error as NSError)
                print("Request Error message: \(error.localizedDescription), code: \(requestError.code)")
            }
        }
        
    }
    
    private func getDefinitions(_ text: String){
        provider.request(.getDefinitions(text: text)) { [weak self] result in
            switch result{
            case .success(let response):
                do {
                    let responseDefinition = try JSONDecoder().decode([DefinitionResponse].self, from: response.data)
                    guard let definition = responseDefinition.first else { return }
                    
                    self?.definition.text = definition.text
                    
                } catch let error {
                    print("Error in parsing: \(error)")
                }
            case .failure(let error):
                let requestError = (error as NSError)
                print("Request Error message: \(error.localizedDescription), code: \(requestError.code)")
            }
        }
    }
    private func getPronunciations(_ text: String){
        provider.request(.getPronunciations(text: text)) { [weak self] result in
            switch result{
            case .success(let response):
                do {
                    let responsePronunciation = try JSONDecoder().decode([PronunciationResponse].self, from: response.data)
                    guard let pronunciation = responsePronunciation.first else { return }
                    
                    self?.pronunciation.text = pronunciation.raw
                    self?.voiceButton.alpha = 1
                } catch let error {
                    print("Error in parsing: \(error)")
                }
            case .failure(let error):
                let requestError = (error as NSError)
                print("Request Error message: \(error.localizedDescription), code: \(requestError.code)")
            }
        }
    }
    
}

//MARK: - Extensions -
extension MainViewController: UISearchBarDelegate{
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        self.searchText = searchText
        self.getSynonims(searchText.lowercased())
        self.getDefinitions(searchText.lowercased())
        self.getPronunciations(searchText.lowercased())
        self.getAntonyms(searchText.lowercased())
        
        self.searchBar.endEditing(true)
    }
}

//extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return data.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SynonimsCollectionViewCell
//
//        cell.textLabel.text = data[indexPath.row]
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 150, height: 120)
//    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.view.endEditing(true)
//
//        let utterance = AVSpeechUtterance(string: data[indexPath.row])
//        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
//        utterance.rate = 0.5
//
//        let synthesizer = AVSpeechSynthesizer()
//        synthesizer.speak(utterance)
//    }
//
//}
class DataSynonims {
    static let sharedInstance = DataSynonims()
    var arr = [String]()
}
